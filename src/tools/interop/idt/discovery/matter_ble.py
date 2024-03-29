#
#    Copyright (c) 2023 Project CHIP Authors
#    All rights reserved.
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#        http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.
#

import asyncio
import datetime
import logging
import os
import time

from bleak import AdvertisementData, BleakScanner, BLEDevice
from bleak.exc import BleakDBusError


class MatterBleScanner:

    def __init__(self, artifact_dir: str):
        self.artifact_dir = artifact_dir
        self.logger = logging.getLogger(__file__)
        self.devices_seen_last_time: set[str] = set()
        self.devices_seen_this_time: set[str] = set()
        self.throttle_seconds = 1
        self.error_seconds = 5

    def parse_vid_pid(self, loggable_data: str) -> str:
        try:
            vid = loggable_data[8:10] + loggable_data[6:8]
            pid = loggable_data[12:14] + loggable_data[10:12]
        except IndexError:
            self.logger.warning("Error parsing vid / pid from BLE ad data")
            return ""
        return f"VID: {vid} PID: {pid}"

    def write_device_log(self, device_name: str, to_write: str) -> None:
        log_file_name = os.path.join(self.artifact_dir, f"{device_name}.txt")
        with open(log_file_name, "a+") as log_file:
            ts = datetime.datetime.now().isoformat(sep=' ', timespec='milliseconds')
            to_write = f"{ts}\n{to_write}\n\n"
            log_file.write(to_write)
            print(to_write)

    @staticmethod
    def is_matter_device(service_uuid: str) -> bool:
        is_matter_device = service_uuid.startswith("0000fff6")
        return is_matter_device

    def handle_device_states(self) -> None:
        for device_id in self.devices_seen_last_time - self.devices_seen_this_time:
            to_log = f"LOST {device_id}"
            self.write_device_log(device_id, to_log)
        self.devices_seen_last_time = self.devices_seen_this_time
        self.devices_seen_this_time = set()

    def log_ble_discovery(
            self,
            name: str,
            bin_data: bytes,
            ble_device: BLEDevice,
            rssi: int) -> None:
        loggable_data = bin_data.hex()
        if self.is_matter_device(name):
            device_id = f"{ble_device.name}_{ble_device.address}"
            self.devices_seen_this_time.add(device_id)
            if device_id not in self.devices_seen_last_time:
                to_log = f"DISCOVERED\n{ble_device.name} {ble_device.address}"
                to_log += f"{name}\n{loggable_data}\n"
                to_log += f"RSSI {rssi}\n"
                to_log += self.parse_vid_pid(loggable_data)
                self.write_device_log(device_id, to_log)

    async def browse(self, scanner: BleakScanner) -> None:
        devices: dict[str, tuple[BLEDevice, AdvertisementData]] = await scanner.discover(return_adv=True)
        for device in devices.values():
            ble_device = device[0]
            ad_data = device[1]
            for name, bin_data in ad_data.service_data.items():
                self.log_ble_discovery(
                    name, bin_data, ble_device, ad_data.rssi)
        self.handle_device_states()

    def browse_interactive(self) -> None:
        scanner = BleakScanner()
        self.logger.warning(
            "Scanning BLE\nDCL Lookup: https://webui.dcl.csa-iot.org/")
        while True:
            try:
                time.sleep(self.throttle_seconds)
                asyncio.run(self.browse(scanner))
            except BleakDBusError as e:
                self.logger.warning(e)
                time.sleep(self.error_seconds)

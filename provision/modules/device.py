import os

import modules.util as _util
import yaml
from modules.parameters import ID


class Device:
    CONFIG_FILE = 'devices.yaml'

    def __init__(self, paths, args, part_num) -> None:
        self.label = None
        self.ram_addr = None
        self.flash_addr = None
        self.flash_size = None
        self.stack_size = None
        self.rtt_addr = None
        self.firmware = args.str(ID.kGeneratorFW)
        self.override = False  # Override commander's part_num with devices.yaml label
        self.load(paths, part_num, args.str(ID.kVersion))

    def __str__(self) -> str:
        return "({}) ram:0x{:08x}, flash:0x{:08x}|0x{:08x}, stack:0x{:04x}, image:{}".format(self.label, self.ram_addr, self.flash_addr, self.flash_size, self.stack_size, self.firmware)

    def load(self, paths, part_num, version):
        filename = paths.base(Device.CONFIG_FILE)
        if part_num is None:
            _util.fail("Missing target part number")
        if not os.path.exists(filename):
            _util.fail("Missing device configuration ({})".format(Device.CONFIG_FILE))

        # Load the device configuration
        info = None
        pn = part_num.lower()
        y = _util.YamlFile(filename).read()
        for id, dev in y.items():
            if self.match(pn, id, dev):
                self.label = id
                info = dev
                break
        if info is None:
            _util.fail("Invalid part number \"{}\"".format(part_num))

        self.override = ('override' in info) and info['override'] or False
        self.ram_addr = self._int(info, 'ram_addr')
        self.flash_addr = self._int(info, 'flash_addr')
        self.flash_size = self._int(info, 'flash_size', None)
        self.stack_size = self._int(info, 'stack_size')

        # Search for a firmware for the given version, if needed
        if self.firmware is None:
            image = None
            rtt_addr = None
            version_len = len(version)
            for y in self._list(info, 'firmware'):
                v = self._str(y, 'version')
                prefix = v[:version_len]
                if prefix > version:
                    break
                if version == prefix:
                    image = self._str(y, 'file')
                    rtt_addr = self._int(y, 'rtt_addr', None)
            if image is None:
                _util.fail("Missing firmware for \"{}\" in version \"{}\"".format(part_num, version))

            self.firmware = paths.base("images/{}".format(image))
            self.rtt_addr = rtt_addr

    def match(self, pn, id, y):
        if pn.startswith(id.lower()):
            return True
        for a in self._list(y, 'alias'):
            if pn.startswith(a.lower()):
                return True
        return False

    def _int(self, conf, tag, default_=0):
        return tag in conf and int(conf[tag]) or default_

    def _str(self, conf, tag, default_=""):
        return tag in conf and str(conf[tag]) or default_

    def _list(self, conf, tag, default_=[]):
        return tag in conf and list(conf[tag]) or default_

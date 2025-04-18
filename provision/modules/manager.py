import os
import random
import base64
import importlib
import datetime
import modules.util as _util
import modules.tools as _tools
import modules.device as _dev
import modules.jlink as _jlink
import modules.channel as _chan
import modules.bluetooth as _bt
import modules.credentials as _creds
from modules.parameters import ID, Actions
from abc import ABC, abstractmethod
from enum import Enum


class ProvisionManager:
    DEFAULT_TEMP = './temp'

    def __init__(self, ver) -> None:
        prot_mod = importlib.import_module("{}.{}.protocol".format(_util.Paths.MODULES_DIR, ver.module))
        self.protocol = prot_mod.Protocol()

    def execute(self, paths, args):

        print("\n# Provision Protocol v{}\n".format(args.str(ID.kVersion)))

        # Help
        action = args.str(ID.kAction)
        if Actions.kHelp == action:
            args.help()
            exit(0)
        args.print()

        # Temporary folder
        temp = args.get(ID.kTemporaryDir)
        if temp.value is None:
            temp.set(ProvisionManager.DEFAULT_TEMP)
        if not os.path.isdir(temp.value):
            os.makedirs(temp.value)
        paths.setTemp(args.str(ID.kTemporaryDir))

        # Compute defaults
        creds = _creds.Credentials(paths, args)
        if (Actions.kAuto == action) or (Actions.kBinary == action):
            creds.collect()
            self.computeDefaults(paths, args)

        # Stop
        if args.value(ID.kStop):
            _util.warn("Stop requested.")
            # Export arguments (including generated values)
            args.export()
            exit(0)

        # Connection string
        conn = ConnectionArguments(args)
        comm = _tools.Commander(args, conn)

        # Channel
        if Actions.kBinary == action:
            chan = None
        else:
            chan = self.createChannel(paths, args, conn, comm)
            # Generator Firmware
            if _chan.Channel.BLE != chan.type:
                self.writeGeneratorFirmware(args, comm)

        # Exchange data
        self.protocol.execute(paths, args, chan)

        # Export arguments (including returned values)
        if Actions.kBinary != action:
            args.export()

        # Generate legacy header (silabs_cred.h) with credentials offsets and sizes
        if Actions.kAuto == action:
            creds.generateLegacyHeader()

        # Production Firmware
        if chan and (_chan.Channel.BLE != chan.type):
            self.writeProductionFirmware(args, comm)

    def createChannel(self, paths, args, conn, comm):
        if _chan.Channel.BLE == conn.channel_type:
            # Bluetooth channel
            return _bt.BluetoothChannel(paths, args, conn.address)
        else:
            # JLink RTT: Device info required
            self.collectDeviceInfo(paths, args, conn, comm)
            return _jlink.JLinkChannel(paths, args, conn)

    def collectDeviceInfo(self, paths, args, conn, comm):
        info = comm.info()
        flash_size = info.flash_size

        # TODO: Figure out a way to get the accessible flash instead of the physical flash for series 3
        if "simg3" in info.part:
            # `commander device info` returns the whole flash size but only a portion of it is available for any application
            # Based on that Total flash size, we can determine what is the current flash size available for apps.
            # The provision storage only reserve 1 flash page for matter credentials for all platforms
            # S3 token manager reserve 2 pages for it.
            # so we preventively remove 1 page to the real flash size
            if (info.flash_size == 0x00400000):
                flash_size = 0x390000 # base is 0x391000
            elif (info.flash_size == 0x00300000):
                flash_size = 0x2a2000 # base is 0x2a3000
            elif (info.flash_size == 0x00200000):
                flash_size = 0x1b3000 # base is 0x1b4000
            else:
                print("Unrecognized Series 3 flash size")

        # Collect device information
        device_num = args.get(ID.kDevice)
        if device_num.value is None:
            # Auto-detect part number
            device_num.set(info.part)

        # Read device configuration
        dev = _dev.Device(paths, args, device_num.str(), flash_size)
        if dev.override:
            # User configuration part number
            device_num.set(dev.label)
        print("Device: {}\n".format(dev))
        # Flash address
        fa = args.get(ID.kFlashAddress)
        fa.set(dev.flash_addr)
        # Flash size
        fs = args.get(ID.kFlashSize)
        fs.set(dev.flash_size)
        # Firmware
        fw = args.get(ID.kGeneratorFW)
        if fw.value is None:
            fw.set(dev.firmware)

    def computeDefaults(self, paths, args):
        # Mandatory
        if (args.int(ID.kVendorId) is None):
            raise ValueError("Missing vendor ID")
        if (args.int(ID.kProductId) is None):
            raise ValueError("Missing product ID")

        # Manufacturing Date
        mdate = args.get(ID.kManufacturingDate)
        if mdate.value is None:
            mdate.set("{:%Y-%m-%d}".format(datetime.date.today()))

        #
        # SPAKE2+
        #
        generate_verifier = False
        # passcode
        passcode = args.get(ID.kSpake2pPasscode)
        if passcode.value is None:
            self.generatePasscode(passcode)
            generate_verifier = True
        # salt (base 64)
        salt = args.get(ID.kSpake2pSalt)
        if salt.value is None:
            salt.set(base64.b64encode(os.urandom(32)).decode('utf-8'))
            generate_verifier = True
        # iterations
        iterations = args.get(ID.kSpake2pIterations)
        if iterations.value is None:
            self.generateIterations(iterations)
        # verifier (base 64)
        verifier = args.get(ID.kSpake2pVerifier)
        if (verifier.value is None) or generate_verifier:
            verifier_b64 = _tools.Spake2p.generateVerifier(passcode.value, iterations.value, salt.value)
            verifier.set(verifier_b64)

    def generateIterations(self, arg):
        # Upper limit is reduced here to improve performace by default
        min_value = arg.min
        max_value = arg.min + (arg.max - arg.min) / 4
        arg.set(random.randint(min_value, max_value))

    def generatePasscode(self, arg):
        passcode = 0
        while (passcode in arg.invalid) or (passcode > arg.max):
            passcode = int.from_bytes(os.urandom(4), byteorder='big')
        arg.set(passcode)

    def writeGeneratorFirmware(self, args, comm):
        gen_fw = args.str(ID.kGeneratorFW)
        if gen_fw is None:
            raise ValueError("Missing Generator Firmware")
        elif not os.path.exists(gen_fw) or not os.path.isfile(gen_fw):
            raise ValueError("Missing Generator firmware \"{}\"".format(gen_fw))
        comm.flash(gen_fw)

    def writeProductionFirmware(self, args, comm):
        prod_fw = args.str(ID.kProductionFW)
        if prod_fw is not None:
            print("Writing Production Firmware...")
            comm.flash(prod_fw)


class ConnectionArguments:

    def __init__(self, args) -> None:
        self.channel_type = _chan.Channel.NONE
        self.address = None
        self.serial_num = None
        self.ip_addr = None
        self.port = None
        # Parse connection string
        conn_str = args.str(ID.kChannel)
        # Parse channel
        if conn_str is None:
            self.serial_num = None
            self.ip_addr = None
            self.port = None
        elif conn_str.startswith('bt:'):
            self.channel_type = _chan.Channel.BLE
            self.address = conn_str[3:]
        elif conn_str.find('.') < 0:
            # Serial port
            self.channel_type = _chan.Channel.RTT
            self.serial_num = conn_str
        else:
            # IP address
            self.channel_type = _chan.Channel.RTT
            pair = conn_str.split(':')
            if len(pair) > 1:
                self.port = int(pair[1])
            self.ip_addr = pair[0]


class ProvisionProtocol(ABC):

    def __init__(self) -> None:
        pass

    @abstractmethod
    def execute(self, paths, args, chan):
        pass
import os
from .util import *


# SoC configuration
socs = {
  'mg12': { 'ram_addr': 0x20000000, 'stacksize': 0x1000, 'flash_addr': 0x0000000, 'image': 'efr32mg12.s37' },
  'mg24': { 'ram_addr': 0x20000000, 'stacksize': 0x1000, 'flash_addr': 0x8000000, 'image': 'efr32mg24.s37' },
  'si917': { 'ram_addr': 0x400, 'stacksize': 0x4FC00, 'flash_addr': 0x8202000, 'image': 'si917.rps' },
}


class DeviceInfo:
    def __init__(self, text):
        d = self.parseLines(text.decode('utf-8').splitlines())
        self.part = self.parseField(d, 'Part Number')
        self.uid = self.parseField(d, 'Unique ID')
        self.revision = self.parseField(d, 'Die Revision')
        self.version = self.parseField(d, 'Production Ver')
        self.flash_size = self.parseSize(d, 'Flash Size')
        self.family = self.part[0:9].lower()

        # Only MG12 and MG24 are supported in matter currently
        if self.part.startswith('efr32mg12'):
            soc = socs['mg12']
        elif self.part.startswith('efr32mg24') or self.part.startswith('mgm24'):
            soc = socs['mg24']
        elif self.part.startswith('si917') or self.part.startswith('siwg917'):
            soc = socs['si917']
        else:
            raise Exception('Invalid MCU')
        self.ram_addr = soc['ram_addr']
        self.stacksize = soc['stacksize']
        self.flash_addr = soc['flash_addr']
        self.image = soc['image']

    def parseLines(self, lines):
        m = {}
        for l in lines:
            pair = l.split(':')
            if len(pair) > 1:
                m[pair[0].strip()] = pair[1].strip().lower()
        return m

    def parseField(self, d, tag, default_value = '?'):
        v =  tag in d and d[tag] or default_value
        return isinstance(v, str) and v.lower() or v

    def parseSize(self, d, tag):
        text = self.parseField(d, tag, '0')
        if text is None: return 0
        parts = text.split()
        value = int(parts[0])
        multiplier = 1
        if len(parts) > 0 and ('kb' == parts[1].lower()):
            multiplier = 1024
        return value * multiplier

    def __str__(self):
        text =  "  ∙ part: '{}'\n".format(self.part)
        text += "  ∙ family: '{}'\n".format(self.family)
        text += "  ∙ flash_addr: 0x{:08x}\n".format(self.flash_addr)
        text += "  ∙ flash_size: 0x{:08x}".format(self.flash_size)
        return text

class Commander:

    def __init__(self, args):
        self.conn = args.conn
        self.device = args.device

    def execute(self, args, output = True, check = False):
        args.insert(0, 'commander')
        if self.conn.serial_num:
            args.extend(["--serialno", self.conn.serial_num])
        elif self.conn.ip_addr:
            if self.conn.port:
                args.extend(["--ip", "{}:{}".format(self.conn.ip_addr, self.conn.port)])
            else:
                args.extend(["--ip", self.conn.ip_addr])
        if self.device:
            args.extend(["--device", self.device])

        cmd = ' '.join(args)
        return execute(args, output, check)

    def info(self):
        res = self.execute(['device', 'info'], True, True)
        return DeviceInfo(res)

    def flash(self, image_path):
        self.execute(['flash' , image_path], False, True)
        self.execute(['device', 'reset'], False, True)

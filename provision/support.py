#! /usr/bin/python3
import os
import sys
import argparse
import shutil
import modules.util as _util


class PatchingFile:

    def __init__(self, path) -> None:
        self.path = path
        self.skip = 0

    def patch(self, paths):
        temp = "{}.temp".format(self.path)
        backup = "{}.bak".format(self.path)
        print("Patching {}...".format(temp))
        with open(self.path, 'r') as f:
            with open(temp, 'w') as t:
                self.process(f, t)

        os.rename(self.path, backup)
        os.rename(temp, self.path)

    def process(self, src, dest):
        lines = src.readlines()
        for l in lines:
            if self.skip > 0:
                self.skip -= 1
            else:
                self.write(dest, l)

    def write(self, file, line):
        pass


class MakefilePatcherEFR32(PatchingFile):

    def write(self, file, line):
        if line.startswith('BASE_SDK_PATH'):
            file.write("BASE_SDK_PATH ?= /git/gsdk\n")
        elif line.find('nvm3_default_common_linker') >= 0:
            self.skip = 6
        else:
            file.write(line)

class MakefilePatcherSi917(PatchingFile):

    def write(self, file, line):
        if line.startswith('BASE_SDK_PATH'):
            file.write("BASE_SDK_PATH ?= /git/gsdk\n")
        elif line.find('-DFLASH_PAGE_SIZE=1') >= 0:
            file.write(" '-DFLASH_PAGE_SIZE=4096' \\\n")
        elif line.find('-DSL_BOARD_NAME="BRD4002A"') >= 0:
            file.write(" '-DSL_BOARD_NAME=\"BRD4338A\"' \\\n")
        elif line.find('-DSL_BOARD_REV="A06"') >= 0:
            file.write(" '-DSL_BOARD_REV=\"A02\"' \\\n")
        elif line.find('startup_si91x') >= 0:
            self.skip = 6
        else:
            file.write(line)


class PartConfig:
    def __init__(self, family, suffix, reference, flash_size):
        self.family = family
        self.suffix = suffix
        self.reference = reference
        self.flash_size = flash_size


class Updater:

    SUPPORTED_PARTS = [
        PartConfig('efr32mg12', 'efr32', 'EFR32MG12P232F512GM68',     0x7f800),
        PartConfig('efr32mg24', 'efr32', 'EFR32MG24A010F1024IM48',    0xfe000),
		PartConfig('efr32mg26', 'efr32', 'EFR32MG26B410F3200IM48',    0x31c000),
        PartConfig('si917',     'si917', 'brd4338a;wiseconnect3_sdk', 0x1fe000),
    ]

    def __init__(self, paths, args, part) -> None:
        self.paths = paths
        self.part = self.findPart(part)
        self.part_dir = self.paths.support(self.part.family)
        self.gsdk_dir = args.sdk
        self.do_generate = args.generate
        self.do_patch = args.patch
        self.do_restore = True

    def findPart(self, name):
        lower = name.strip().lower()
        for p in Updater.SUPPORTED_PARTS:
            if lower == p.family:
                return p
        _util.fail("Unsupported device \"{}\"".format(name))

    def execute(self):
        print("\n* {}; {}".format(self.part.family, self.part_dir))
        # Generate
        if self.do_generate:
            self.generate()
        # Restore previous patches
        self.restore()
        # Make
        if ('si917' == self.part.family):
            # Non-PSA (Si917)
            self.make('nvm3k2')
        else:
            # PSA-based (EFR32)
            if (self.do_patch is None) or ('psa3' == self.do_patch):
                # PSAv3 + NVM3k2 (already generated)
                self.make('psa3_nvm3k2')

            if (self.do_patch is None) or ('psa123' == self.do_patch):
                # PSAv123 + NVM3k2 (add v1 and v2)
                self.patch("{}-psa123".format(self.part.family))
                self.make('psa123_nvm3k2')

            if (self.do_patch is None) or ('psa12' == self.do_patch):
                # PSAv12 + NVM3k2 (-v3 +v1 +v2)
                psa12_patch = "{}-psa12".format(self.part.family)
                self.patch(psa12_patch)
                self.make('psa12_nvm3k2')
                # PSAv12 + NVM3k1 (-v3 +v1 +v2 +nvm3k1)
                nvm3k1_patch = 'nvm3k1'
                self.patch(psa12_patch)
                self.patch(nvm3k1_patch)
                self.make('psa12_nvm3k1')

    def generate(self):
        # Generate
        print("{}+ Generate".format(_util.MARGIN))
        slcp_path = self.paths.base("generator/{}.slcp".format(self.part.suffix))
        _util.execute([ 'slc', 'signature', 'trust', '--sdk', self.gsdk_dir ])
        _util.execute([ 'slc', 'generate', '-p', slcp_path, '-d', self.part_dir, '--with', "\"{}\"".format(self.part.reference), '--sdk', self.gsdk_dir ])
        # Patch
        if 'si917' == self.part.family:
            # Makefile
            patcher = MakefilePatcherSi917("{}/generator.project.mak".format(self.part_dir))
            patcher.patch(self.paths)
            # Linkerfile
            _util.execute([ 'git', 'restore', "{}/RS9117_SF_4MB_42bsp.elf".format(self.part_dir) ])
            _util.execute([ 'git', 'restore', "{}/autogen/linkerfile_SoC.ld".format(self.part_dir) ])
        else:
            # Makefile
            patcher = MakefilePatcherEFR32("{}/generator.project.mak".format(self.part_dir))
            patcher.patch(self.paths)
            # Linker file
            linkerfile_from = self.paths.support("patch/{}.ld".format(self.part.family))
            if os.path.exists(linkerfile_from):
                linkerfile_into = "{}/autogen/linkerfile.ld".format(self.part_dir)
                shutil.copyfile(linkerfile_from, linkerfile_into)
        # Stage the newly generated code
        _util.execute([ 'git', 'add', self.part_dir ])

    def make(self, suffix = None):
        image_ext = ('si917' == self.part.family) and 'rps' or 's37'
        image_src = "{}/build/debug/generator.s37".format(self.part_dir)
        image_dest = self.paths.base("images/{}{}.{}".format(self.part.family, (suffix is not None) and "_{}".format(suffix) or '', image_ext))
        print("{}+ Make {}".format(_util.MARGIN, image_dest))
        # Environment
        envm = os.environ.copy()
        envm['BASE_SDK_PATH'] = self.gsdk_dir
        # Make
        _util.execute([ 'make', '-C', self.part_dir, '-f', 'generator.Makefile' ], env=envm)
        # Copy
        if 'si917' == self.part.family:
            _util.execute([ 'commander', 'rps', 'create', '--app', image_src, image_dest ])
        else:
            _util.execute([ 'cp', image_src, image_dest ])
        # Restore patches
        self.restore()

    def restore(self):
        if self.do_restore:
            self.do_restore = False
            print("{}+ Restore".format(_util.MARGIN))
            _util.execute([ 'git', 'restore', self.part_dir ])
            _util.execute([ 'git', 'restore', self.paths.root('src') ])

    def patch(self, name):
        print("{}+ Patch \"{}\"".format(_util.MARGIN, name))
        path = self.paths.support("patch/{}.diff".format(name))
        _util.execute([ 'git', 'apply', path ])
        self.do_restore = True


def main(argv):
    paths = _util.Paths(os.path.dirname(__file__))

    # Parse arguments
    parser = argparse.ArgumentParser(description='Provisioner Support')
    parser.add_argument('parts', nargs='?', default='efr32mg12, efr32mg24')
    parser.add_argument('-s', '--sdk', type=str, help='Simplicity SDK path', default=paths.root('third_party/silabs/simplicity_sdk'))
    parser.add_argument('-g', '--generate', action='store_true', help='Generate')
    parser.add_argument('-p', '--patch', type=str, help='Patch', default=None)
    args = parser.parse_args()

    # Build image(s)
    print("\nSDK: {}".format(args.sdk))
    for p in args.parts.split(','):
        up = Updater(paths, args, p)
        up.execute()

    print()

main(sys.argv[1:])
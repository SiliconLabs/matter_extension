import subprocess
import traceback
import sys
import os
import json
import yaml

MARGIN = '  '

class Paths:
    TEMP_DIR = 'temp'
    SUPPORT_DIR = 'support'
    MATTER_DIR = '../third_party/matter_sdk'

    def __init__(self, base_dir) -> None:
        self.current_dir = os.getcwd()
        self.base_dir = self.normalize(base_dir)
        self.root_dir = "{}/..".format(self.base_dir)
        self.temp_dir = "{}/{}".format(self.current_dir, Paths.TEMP_DIR)
        self.support_dir = "{}/{}".format(self.base_dir, Paths.SUPPORT_DIR)
        self.matter_dir = "{}/{}".format(self.base_dir, Paths.MATTER_DIR)

    def setTemp(self, temp):
        self.temp_dir = temp

    def base(self, path = None):
        return self.normalize(self.base_dir, path)

    def current(self, path = None):
        return self.normalize(self.current_dir, path)

    def root(self, path = None):
        return self.normalize(self.root_dir, path)

    def support(self, path = None):
        return self.normalize(self.support_dir, path)

    def matter(self, path = None):
        return self.normalize(self.matter_dir, path)

    def temp(self, path = None):
        return self.normalize(self.temp_dir, path)

    def normalize(self, base, path = None):
        if os.path.isfile(base):
            base = os.path.dirname(base)
        if not base: base = '.'
        if (path is None) or ('' == path) or ('.' == path):
            full = base
        elif os.path.isabs(path):
            full = path
        else:
            full = "{}/{}".format(base, path)
        return os.path.abspath(os.path.normpath(full))


class File:

    def __init__(self, path) -> None:
        self.path = path

    def read(self):
        with open(self.path, 'r') as f:
            return f.read()

    def write(self, data):
        with open(self.path, 'w') as f:
            f.write(data)

class BinaryFile(File):

    def read(self):
        if self.path is None: return bytes()
        with open(self.path, 'rb') as f:
            return bytes(f.read())

    def write(self, x):
        if x is None:
            data = bytes()
        elif isinstance(x, str):
            data = str(x).encode('utf-8')
        else: # isinstance(x, bytes) or isinstance(x, bytearray):
            data = x
        with open(self.path, 'wb') as f:
            f.write(data)

class JsonFile(File):

    def read(self):
        with open(self.path, 'r') as f:
            return json.loads(f.read())

    def write(self, data):
        with open(self.path, 'w') as f:
            json.dump(data, f, indent=4)

class YamlFile(File):

    def read(self):
        with open(self.path, 'r') as f:
            return yaml.safe_load(f)

    def write(self, data):
        with open(self.path, 'w') as f:
            yaml.dump(data, f)


def execute(args, output = False, check = True, env = None, retry = 1):
    sys.stdout.reconfigure(encoding='utf-8')
    args = [ str(x) for x in args ]
    cmd = ' '.join(args)
    print("{}> {}\n".format(MARGIN, cmd))
    if env is None:
        env = os.environ.copy()

    if output:
        try:
            return subprocess.check_output(cmd, shell=True)
        except BaseException as err:
            if check:
                fail(err)
            return None
    else:
        while retry > 0:
            retry = retry - 1
            complete = subprocess.run(cmd, stdout=subprocess.DEVNULL, stderr=subprocess.STDOUT, shell=True, env=env)
            if (0 == complete.returncode): return 0
            if check and (0 == retry):
                fail("Command failed with code {}".format(complete.returncode))
            else:
                warn("Command failed with code {}. Retrying...".format(complete.returncode))
        return complete.returncode


def fail(message, paths = None):
    sys.stdout.reconfigure(encoding='utf-8')
    if paths is not None:
        print()
        prefix = paths.base() + '/'
        trace = traceback.extract_stack()
        for t in trace[:-1]:
            filename = t.filename.removeprefix(prefix)
            location = "{}:{}".format(filename, t.lineno)
            print("{}{:32}\t{}".format(MARGIN, location, t.line))
        print()
    print("(!) {}\n".format(message))
    exit(1)


def warn(message):
    print("(!) {}\n".format(message))

def roundNearest(n, multiple):
    if n % multiple:
        n = n + (multiple - n % multiple)
    return n

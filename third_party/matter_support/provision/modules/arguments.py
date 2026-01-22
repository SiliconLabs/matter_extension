import argparse
import importlib
import json
import os
import sys
from abc import ABC, abstractmethod

import modules.formatter as _format
import modules.util as _util
import modules.versions as _ver
from modules.parameters import (ID, Actions, Formats, Parameter, ParameterList,
                                Types)


class Argument(Parameter):

    def __init__(self, parent, paths, y) -> None:
        super().__init__(y)
        self.parent = parent
        self.paths = paths
        self.value = None
        self.is_user_input = False

    def __str__(self) -> str:
        name = self.name or '?'
        value = '?'
        if self.value is None:
            value = '<null>'
        elif (Types.INT8U == self.type) or (Types.INT16U == self.type) or (Types.INT32U == self.type):
            if Formats.HEX == self.format:
                value = "0x{:02x}".format(self.value)
            else:
                value = "{}".format(self.value)
        elif Formats.HEX == self.format:
            value = '0x' + bytes(self.value).hex()
        elif Formats.PATH == self.format:
            value = "{}".format(self.value)
        elif Formats.STRING == self.format:
            if isinstance(self.value, str):
                value = "\"{}\"".format(self.value)
            elif (isinstance(self.value, bytes)):
                try:
                    value = "{}".format(self.value.decode())
                except:
                    value = self.value.hex()
        else:
            value = "{}".format(self.value)
        return "{}: {}".format(name, value)

    # Loads the argument value directy from the command line
    # @return The argument itself with updated value
    def load(self):
        short = "-{}".format(self.short)
        long = "--{}".format(self.name)
        values = []
        arg_count = len(sys.argv)
        for i in range(arg_count):
            a = sys.argv[i]
            if a in [short, long]:
                values.append((i + 1 < arg_count) and sys.argv[i + 1] or None)
            elif a.startswith(short):
                x = a[len(short):]
                if x[0].isnumeric():
                    values.append(x)
        if len(values) > 1:
            raise ValueError("Multiple version arguments: {}".format(values))
        self.value = (1 == len(values)) and values[0] or None
        return self

    def set(self, v, default_value=None, validate=True):
        if v is None:
            v = default_value
        if validate:
            self.value = self._validate(v)
        else:
            self.value = v

    def hex(self):
        if self.value is None:
            return None
        return hex(self.value)

    def int(self):
        if self.value is None:
            return None
        return int(self.value)

    def bool(self):
        if self.value is None:
            return None
        return bool(self.value)

    def str(self):
        if self.value is None:
            return None
        elif Types.BINARY == self.type:
            if (isinstance(self.value, bytearray)):
                if Formats.STRING == self.format:
                    try:
                        return self.value.decode()
                    except:
                        pass
                return self.value.hex()
        elif (Formats.BOOL == self.format):
            return str(self.value).lower()
        return str(self.value)

    def _validate(self, x):
        if x is None:
            return None
        if not self.check:
            return x
        h = (x is not None) and (x.__hash__) or None
        if (self.invalid is not None) and (h is not None) and (x in self.invalid):
            raise ValueError("Invalid \"{}\" value: {}".format(self.name, x))
        elif Types.INT8U == self.type:
            if (Formats.BOOL == self.format):
                return self._validateBool(x)
            else:
                return self._validateInt(x)
        elif (Types.INT16U == self.type) or (Types.INT32U == self.type):
            return self._validateInt(x)
        elif (Types.BINARY == self.type):
            if (Formats.STRING == self.format):
                return self._validateString(x)
            elif (Formats.PATH == self.format):
                return self._validatePath(x)
            else:
                return self._validateBinary(x)
        return x

    def _validateInt(self, x):
        try:
            i = isinstance(x, str) and int(x, 0) or int(x)
        except Exception as e:
            raise ValueError("Invalid \"{}\" integer value: {}; {}".format(self.name, x, e))
        r = self.range()
        if r is not None:
            if i not in r:
                raise ValueError("Integer \"{}\" out of range: {} [{}, {}]".format(self.name, x, self.min or 0, self.max))
        return i

    def _validateBool(self, x):
        try:
            return bool(x)
        except Exception as e:
            raise ValueError("Invalid \"{}\" boolean value: {}; {}".format(self.name, x, e))

    def _validateString(self, x):
        s = None
        if isinstance(x, str):
            s = x
        elif isinstance(x, bytes):
            try:
                s = x.decode()
            except:
                raise ValueError("Invalid \"{}\" string value: {}".format(self.name, x))
        else:
            s = str(x)
        r = self.range()
        if r is not None:
            l = (s is not None) and len(s) or 0
            if l not in r:
                raise ValueError("String \"{}\" size out of range: {} [{}, {}]".format(self.name, l, self.min, self.max))
        return s

    def _validatePath(self, x):
        s = self.paths.current(x)
        if self.parent.readMode():
            # Read mode, create output path if needed
            dir = os.path.dirname(s)
            if not os.path.isdir(dir):
                os.makedirs(dir)
        elif not os.path.exists(s):
            # Write mode, the input path must exist
            raise ValueError("Invalid \"{}\" path: {}".format(self.name, s))
        return s

    def _validateBinary(self, x):
        if isinstance(x, str):
            x = bytes.fromhex(x.removeprefix('0x'))
        if not isinstance(x, bytes):
            raise ValueError("Invalid \"{}\" binary value: {}".format(self.name, x))
        r = self.range()
        if r is not None:
            sz = len(x)
            if sz not in r:
                raise ValueError("Binary \"{}\" size out of range: {} [{}, {}]".format(self.name, sz, self.min, self.max))
        return x


class ArgumentList(ParameterList):
    DEFAULT_INPUTS_PATH = 'defaults.json'
    DEFAULT_OUTPUT_PATH = 'latest.json'

    def __init__(self, paths) -> None:
        super().__init__(paths)
        self.formatter = None

    def create(self, y):
        return Argument(self, self.paths, y)

    def set(self, k, v, default_value=None, validate=True):
        self.get(k).set(v, default_value, validate)

    def value(self, k):
        return self.get(k).value

    def hex(self, k):
        return self.get(k).hex()

    def int(self, k):
        return self.get(k).int()

    def bool(self, k):
        return self.get(k).bool()

    def str(self, k):
        return self.get(k).str()

    def compile(self):
        versions = _ver.VersionManager(self.paths)
        # Configure custom parameters, if exists
        params_path = self.get(ID.kParamsPath).load().str()
        self.load(params_path, True)
        # Default inputs file
        file_ver = None
        if os.path.isfile(self.DEFAULT_INPUTS_PATH):
            file_ver = self.compileFileInputs(versions, self.DEFAULT_INPUTS_PATH)
        # Command-line inputs file
        inputs_path = self.get(ID.kInputsPath).load().str()
        if inputs_path is not None:
            file_ver = self.compileFileInputs(versions, inputs_path)
        # Command-line inputs
        cmd_ver = self.compileCommandInputs(versions, file_ver, params_path)
        # Update version
        self.set(ID.kVersion, cmd_ver.tag)
        # Apply defaults
        for k, a in self.ids.items():
            if (a.value is None) and (a.default is not None):
                a.value = a.default
        # print("VERSION: {} (file), {} (command-line)".format(file_ver.tag, cmd_ver.tag))
        return cmd_ver

    def compileFileInputs(self, versions, inputs_path, is_user_input=False):
        # Process inputs file. Get file version
        formatter = _format.Formatter(self, is_user_input)
        file_ver = versions.find(formatter.parseVersion(inputs_path))
        # Version-specific formatter
        args_mod = importlib.import_module("{}.{}.arguments".format(_util.Paths.MODULES_DIR, file_ver.module))
        formatter = args_mod.Formatter(self)
        formatter.parseAll(inputs_path)
        return file_ver

    def compileCommandInputs(self, versions, file_ver, params_path):
        # Command-line version
        ver = self.get(ID.kVersion).load().str()
        cmd_ver = ver and versions.find(ver) or file_ver or versions.find()
        # print("VERSION: {} (file), {} (command-line)".format(file_ver and file_ver.tag or '?', cmd_ver and cmd_ver.tag or '?'))
        # Load version-specific parameters
        args_mod = importlib.import_module("{}.{}.arguments".format(_util.Paths.MODULES_DIR, cmd_ver.module))
        params = args_mod.ParameterList(self.paths, params_path)
        # Update arguments with versioned parameters
        for k, p in params.ids.items():
            arg = self.get(k)
            arg.copy(p)
        # Parse command line
        inputs = self.parseCommandLine(self)
        # Load parsed values into existing arguments
        for k, v in inputs.items():
            if v is not None:
                arg = self.find(k, True)
                arg.set(v, arg.default)
                arg.is_user_input = True
        # Create export formatter
        self.formatter = args_mod.Formatter(self)
        return cmd_ver

    def parseCommandLine(self, params):
        # Configure parser
        parser = argparse.ArgumentParser(add_help=False, conflict_handler='resolve')
        for k, p in params.ids.items():
            # Fixed arguments
            if p.fixed:
                parser.add_argument(p.name, nargs='?', default=p.default)
                # Variable arguments
            elif p.parser is None:
                # Boolean flag
                parser.add_argument("-{}".format(p.short), '--' + p.long, action='store_true', help=p.desc, default=None)
            else:
                # Interger, string, date or path
                parser.add_argument("-{}".format(p.short), '--' + p.long, type=p.parser, help=p.desc, default=None)

        return vars(parser.parse_args())

    # Write the compiled inputs into a file
    def export(self, path=None):
        self.formatter.exportAll(path or self.str(ID.kOutputPath) or ArgumentList.DEFAULT_OUTPUT_PATH)

    # Return true if action=='read', false otherwise
    def readMode(self) -> bool:
        action = (ID.kAction in self.ids) and self.ids[ID.kAction]
        return (Actions.kRead == action.str())

    def print(self):
        for n, g in self.groups.items():
            count = 0
            content = ''
            for k, a in g.items():
                if a.is_user_input and (a.value is not None):
                    count = count + 1
                    content += "\n{}+ {}".format(_util.MARGIN, a)
            if len(content) > 0:
                print("* {}({}/{}):{}\n".format(n, count, len(g), content))

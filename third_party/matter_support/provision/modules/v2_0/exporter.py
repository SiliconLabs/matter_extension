import modules.exporter as _base
from .encoding import *


class Exporter(_base.Exporter):

    def __init__(self, paths, args):
        super().__init__(paths, args)


    def encodeInt8u(self, a):
        self.data.extend(Coder.encode(a, a.value))

    def encodeInt16u(self, a):
        self.data.extend(Coder.encode(a, a.value))

    def encodeInt32u(self, a):
        self.data.extend(Coder.encode(a, a.value))

    def encodeBinary(self, a, v, max_size):
        self.data.extend(Coder.encode(a, v))

    def serialize(self):
        b = Buffer()
        b.addInt16u(2 + len(self.data))
        b.addBinary(self.data)
        return b.serialize()
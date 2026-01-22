#! /usr/bin/python3
import sys
import os
if 'STUDIO_PYTHONPATH' in os.environ.keys():
    [sys.path.append(path) for path in os.environ['STUDIO_PYTHONPATH'].split(os.pathsep)]
import modules.arguments as _args
import modules.manager as _man
import modules.util as _util


def main(argv):
    # Paths
    paths = _util.Paths(os.path.dirname(__file__))
    # Versions
    args = _args.ArgumentList(paths)
    ver = args.compile()
    # Manager
    man = _man.ProvisionManager(ver)
    man.execute(paths, args)


main(sys.argv[1:])

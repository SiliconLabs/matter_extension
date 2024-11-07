import itertools
import threading
import time
import sys

def print_bold(text: str) -> None:
    print('\033[1m' + text + '\033[0m')

def print_green(text: str) -> None:
    print('\033[92m' + text + '\033[0m')

def print_blue(text: str) -> None:
    print('\033[94m' + text + '\033[0m')    

def print_red(text: str) -> None:
    print('\033[91m' + text + '\033[0m')
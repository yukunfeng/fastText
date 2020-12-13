#!/usr/bin/env python3

"""
Author      : Yukun Feng
Date        : 2018/06/20
Email       : yukunfg@gmail.com
Description : Minimal text processing framework
"""

import sys
import re
import string
import os
import collections
from collections import Counter
import numpy as np


if __name__ == "__main__":
    fh_list = []
    if len(sys.argv) >= 2:
        extra_params = sys.argv[1:]
        for file_path in extra_params:
            fh = open(file_path, 'r')
            fh_list.append(fh)
    else:
        fh = sys.stdin
        fh_list.append(fh)

    for fh in fh_list:
        for line in fh:
            line = line.strip()
            # Skip empty lines
            if line == "":
                continue
            # skip header
            if len(line.split()) == 2:
                continue
            word = line.split()[0]
            print(f"{word} {word}")
    for fh in fh_list:
        fh.close()

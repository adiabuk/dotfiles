#!/usr/bin/env python

"""
Small script to symlink dotfiles from repo clone
"""

import calendar
import time
import json
import os

REAL_PATH = os.path.dirname(os.path.realpath(__file__))
HOME = os.getenv('HOME')
RAW = open(REAL_PATH + '/mapper.json', 'r').read()
CTIME = calendar.timegm(time.gmtime())
DATA = json.loads(RAW)

for key in DATA.keys():
    source = os.path.abspath('../{}'.format(key))
    DEST = '{}/{}'.format(HOME, DATA[key])
    print("Creating symlink {}".format(key))
    print('dest: {}'.format(DEST))

    if os.path.exists(DEST):
        print('renaming to {}.{}'.format(DEST, CTIME))
        os.rename(DEST, '{}.{}'.format(DEST, CTIME))
    elif os.path.islink(DEST):
        os.unlink(DEST)
    try:
        os.symlink(source, DEST)
    except Exception as e:
        print('Failed: ../{} to {}: {}'.format(source, DEST, e))

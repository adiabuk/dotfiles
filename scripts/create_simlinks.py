#!/usr/bin/env python

import calendar
import time
import json
import os

home = os.getenv('HOME')
raw = open('mapper.json', 'r').read()
ctime = calendar.timegm(time.gmtime())
data = json.loads(raw)

for key in data.keys():
    source = os.path.abspath('../{}'.format(key))
    dest = '{}/{}'.format(home, data[key])
    print("Creating symlink {}".format(key))
    print('dest: {}'.format(dest))
    
    if os.path.exists(dest):
        print('renaming to {}.{}'.format(dest, ctime))
        os.rename(dest, '{}.{}'.format(dest, ctime))
    elif os.path.islink(dest):
        os.unlink(dest)
    try:
        os.symlink(source, dest)
    except Exception as e:
        print('Failed: ../{} to {}: {}'.format(source, dest, e))
    
 

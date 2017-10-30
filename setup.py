#!/usr/bin/env python2
"""
Small script to symlink dotfiles from repo clone
Requirements:
    setxkbmap
    rbenv
    git-completion
TODO: don't use powerline, if python file unavailable

"""

from __future__ import print_function
import calendar
import time
import json
import os
import sys

REAL_PATH = os.path.dirname(os.path.realpath(__file__))
HOME = os.getenv('HOME')
RAW = open(REAL_PATH + '/mapper.json', 'r').read()
CTIME = calendar.timegm(time.gmtime())
DATA = json.loads(RAW)

for key in DATA.keys():
    source = os.path.abspath('config/{0}'.format(key))
    DEST = '{0}/{1}'.format(HOME, DATA[key])
    print('dest: {0}'.format(DEST))
    parent_dir = os.path.dirname(DEST)
    if not os.path.exists(source):
        print('Unable to find {0}. Exiting'.format(source))
        sys.exit(1)
    if not os.path.exists(parent_dir):
        # create full parent path to destination path
        # if it doesn't already exist
        os.makedirs(parent_dir)

    if os.path.islink(DEST):
        print('{0} is already a link, skipping'.format(DEST))
        continue
    elif os.path.exists(DEST):
        print('renaming to {0}.{1}'.format(DEST, CTIME))
        os.rename(DEST, '{0}.{1}'.format(DEST, CTIME))
    try:
        print("Creating symlink {0}".format(key))
        os.symlink(source, DEST)
    except Exception as ex:
        print('Failed: ../{0} to {1}: {2}'.format(source, DEST, ex))

print("\nSetting up vim")
os.system('vim +VundleInstall +qa')
os.system('pip install --user git+git://github.com/Lokaltog/powerline --upgrade')
print("\nSetting up org-protocol")
os.system('update-desktop-database ~/.local/share/applications/')
print("\nAdd the following as a bookmark in firefox")
print("\njavascript:location.href='org-protocol://capture://l/'+encodeURIComponent(location.href)+'/'+encodeURIComponent(document.title)+'/'+encodeURIComponent(window.getSelection())")


print("\nSetting up user crontab")
CRON_SOURCE = os.path.abspath('../crontab')
os.system('crontab {0}'.format(CRON_SOURCE))
print("\nInstalling argcomplete")
os.system('mkdir ~/.bash_completion.d')
os.system('activate-global-python2-argcomplete --dest ~/.bash_completion.d/')
print('\nDONE')

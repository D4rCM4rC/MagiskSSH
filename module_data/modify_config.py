#!/bin/env python3

import sys

def exchange_header(l):
	if 'ui_print "     Magisk Module Template    "' in l:
		return '  ui_print "      OpenSSH for Android      "\n'
	return l

extra_lines="""
  cp -af $INSTALLER/common/$ARCH $MODPATH/usr
  cp -af $INSTALLER/common/opensshd.init $MODPATH/
  chmod 755 $MODPATH/usr/bin/*
  chmod 755 $MODPATH/opensshd.init
  ln -s ./libcrypto.so.1.0.0 $MODPATH/usr/lib/libcrypto.so
  mkdir -p /data/ssh
  mkdir -p /data/ssh/root/.ssh
  mkdir -p /data/ssh/shell/.ssh
  [ -f /data/ssh/sshd_config ] || (cp -a $INSTALLER/common/sshd_config /data/ssh; chown root:root /data/ssh/sshd_config; chmod 600 /data/ssh/sshd_config)
"""

filename = sys.argv[1]
with open(filename,'r') as f:
	lines = f.readlines()

extra_lines = extra_lines.splitlines()
extra_lines = [l+'\n' for l in extra_lines]

lines = [exchange_header(l) for l in lines]

last_brace=0
for (i,l) in enumerate(lines):
	if '}' in l:
		last_brace=i

lines = lines[:last_brace] + extra_lines + lines[last_brace:]

#print(lines)

with open(filename,'w') as f:
	f.writelines(lines)
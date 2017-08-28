#!/bin/sh

set -u
set -e

# Add a console on tty1
if [ -e ${TARGET_DIR}/etc/inittab ]; then
    grep -qE '^tty1::' ${TARGET_DIR}/etc/inittab || \
	sed -i '/GENERIC_SERIAL/a\
tty1::respawn:/sbin/getty -L  tty1 0 vt100 # HDMI console' ${TARGET_DIR}/etc/inittab
fi

mkdir -p $1/root/.ssh/
chmod 0700 $1/root/.ssh/
chmod 0700 $1/root
cp -p ~/.ssh/id_rsa.pub $1/root/.ssh/authorized_keys
chmod 0600 $1/root/.ssh/authorized_keys

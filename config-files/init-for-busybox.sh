#!/bin/sh

/bin/busybox --install -s

/bin/mount -t devtmpfs devtmpfs /dev

#exec 0</dev/console
#exec 1>/dev/console
#exec 2>/dev/console

ln -s /proc/self/fd /dev/fd

exec /sbin/init $*

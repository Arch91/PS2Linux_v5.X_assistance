#!/bin/sh

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
export PATH

mount -t sysfs none /sys
mount -t tmpfs none /var
mount -t tmpfs none /tmp
mount -t proc none /proc
mkdir /dev/pts
mount -t devpts none /dev/pts
mount -t debugfs none /sys/kernel/debug

modprobe ps2fb mode_option=460p

modprobe sif
modprobe iop-memory
modprobe iop-heap
modprobe iop-module
modprobe iop-irq
modprobe iop-dev9
modprobe iop-registers

modprobe usb-common
modprobe usbcore
modprobe hid
modprobe usbhid
modprobe hid-generic
modprobe ums-usbat
modprobe sd_mod
modprobe ohci-ps2
exec >/dev/tty0 2>&1 </dev/tty0

uname -a

echo "Welcome!"
exec setsid /bin/sh -c 'exec /bin/sh < /dev/tty1 > /dev/tty1 2>&1'
sh

while :
do
	sleep 1
done

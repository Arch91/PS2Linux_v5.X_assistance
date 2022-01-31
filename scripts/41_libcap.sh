#!/bin/bash
# Simple brutal sh-scripts chain.
if [ "$(echo $PATH | grep -o /usr/local/ps2/bin)" != "/usr/local/ps2/bin" ]
then
 echo -en "\033[36;1m There is no "/usr/local/ps2/bin" was added to \$PATH . Adding... \033[0m\n"
 export PATH=/usr/local/ps2/bin:$PATH
fi

cd ../sources
if [ ! -e libcap-2.24.tar.xz ]
then
wget https://www.kernel.org/pub/linux/libs/security/linux-privs/libcap2/libcap-2.24.tar.xz || exit -1
fi
cd ../building
tar -Jxvf ../sources/libcap-2.24.tar.xz
cd libcap-2.24

patch -p1 < ../../patches/41_libcap-2.24_compat.patch || exit -1

make -j 4 || exit -1
make install
# Ignore those afterinstallation launches. Libs and the appropriate are installed.

sleep 2

cd ../../scripts
sh 42_zlib.sh

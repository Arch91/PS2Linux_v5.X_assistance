#!/bin/bash
# Simple brutal sh-scripts chain.
if [ "$(echo $PATH | grep -o /usr/local/ps2/bin)" != "/usr/local/ps2/bin" ]
then
 echo -en "\033[36;1m There is no "/usr/local/ps2/bin" was added to \$PATH . Adding... \033[0m\n"
 export PATH=/usr/local/ps2/bin:$PATH
fi

cd ../sources
if [ ! -e module-init-tools-3.15.tar.xz ]
then
wget http://ftp.be.debian.org/pub/linux/utils/kernel/module-init-tools/module-init-tools-3.15.tar.xz || exit -1
fi
cd ../building
tar -Jxvf ../sources/module-init-tools-3.15.tar.xz
cd module-init-tools-3.15

patch -p1 < ../../patches/46_module-init-tools-3.15_nomans.patch || exit -1

./configure --prefix=/usr/local/ps2/mipsr5900el-unknown-linux-gnu --host=mipsr5900el-unknown-linux-gnu || exit -1

make -j 4 || exit -1
make install
# Ignore those afterinstallation launches. The binaries are installed.

sleep 2

cd ../../scripts
sh 47_psmisc.sh

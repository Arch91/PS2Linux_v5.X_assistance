#!/bin/bash
# Simple brutal sh-scripts chain.
if [ "$(echo $PATH | grep -o /usr/local/ps2/bin)" != "/usr/local/ps2/bin" ]
then
 echo -en "\033[36;1m There is no "/usr/local/ps2/bin" was added to \$PATH . Adding... \033[0m\n"
 export PATH=/usr/local/ps2/bin:$PATH
fi

cd ../sources
if [ ! -e iproute2-4.8.0.tar.xz ]
then
wget http://ftp.iij.ad.jp/pub/linux/kernel/linux/utils/net/iproute2/iproute2-4.8.0.tar.xz || exit -1
fi
cd ../building
tar -Jxvf ../sources/iproute2-4.8.0.tar.xz
cd iproute2-4.8.0

patch -p1 < ../../patches/34_iproute2-4.8.0_incfix+compat.patch || exit -1

make -j 4 || exit -1
make install || exit -1

sleep 2

mkdir /usr/local/ps2/mipsr5900el-unknown-linux-gnu/var
mkdir /usr/local/ps2/mipsr5900el-unknown-linux-gnu/var/lib
mkdir /usr/local/ps2/mipsr5900el-unknown-linux-gnu/var/lib/arpd

cd ../../scripts
sh 35_procps.sh

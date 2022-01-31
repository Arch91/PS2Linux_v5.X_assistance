#!/bin/bash
# Simple brutal sh-scripts chain.
if [ "$(echo $PATH | grep -o /usr/local/ps2/bin)" != "/usr/local/ps2/bin" ]
then
 echo -en "\033[36;1m There is no "/usr/local/ps2/bin" was added to \$PATH . Adding... \033[0m\n"
 export PATH=/usr/local/ps2/bin:$PATH
fi

cd ../sources
if [ ! -e procps-3.2.8.tar.gz ]
then
wget http://procps.sourceforge.net/procps-3.2.8.tar.gz || exit -1
fi
cd ../building
tar -zxvf ../sources/procps-3.2.8.tar.gz
cd procps-3.2.8

patch -p1 < ../../patches/35_procps-3.2.8_incfix+compat.patch || exit -1

make -j 4 CC=mipsr5900el-unknown-linux-gnu-gcc || exit -1
make DESTDIR=/usr/local/ps2/mipsr5900el-unknown-linux-gnu install || exit -1

sleep 2

cd ../../scripts
sh 36_file.sh

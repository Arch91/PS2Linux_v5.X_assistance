#!/bin/bash
# Simple brutal sh-scripts chain.
if [ "$(echo $PATH | grep -o /usr/local/ps2/bin)" != "/usr/local/ps2/bin" ]
then
 echo -en "\033[36;1m There is no "/usr/local/ps2/bin" was added to \$PATH . Adding... \033[0m\n"
 export PATH=/usr/local/ps2/bin:$PATH
fi

cd ../sources
if [ ! -e zlib-1.2.10.tar.gz ]
then
wget https://zlib.net/fossils/zlib-1.2.10.tar.gz || exit -1
fi
cd ../building
tar -zxvf ../sources/zlib-1.2.10.tar.gz
cd zlib-1.2.10

patch -p1 < ../../patches/41_zlib-1.2.10_removechecktopass.patch || exit -1

CC=mipsr5900el-unknown-linux-gnu-gcc ./configure --prefix=/usr/local/ps2/mipsr5900el-unknown-linux-gnu --shared || exit -1

make -j 4 || exit -1
make install || exit -1

sleep 2

cd ../../scripts
sh 42_util-linux.sh

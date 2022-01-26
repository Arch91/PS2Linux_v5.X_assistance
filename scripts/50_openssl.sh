#!/bin/bash
# Simple brutal sh-scripts chain.
if [ "$(echo $PATH | grep -o /usr/local/ps2/bin)" != "/usr/local/ps2/bin" ]
then
 echo -en "\033[36;1m There is no "/usr/local/ps2/bin" was added to \$PATH . Adding... \033[0m\n"
 export PATH=/usr/local/ps2/bin:$PATH
fi

cd ../sources
if [ ! -e openssl-1.1.0c.tar.gz ]
then
wget https://ftp.openssl.org/source/old/1.1.0/openssl-1.1.0c.tar.gz || exit -1
fi
cd ../building
tar -zxvf ../sources/openssl-1.1.0c.tar.gz
cd openssl-1.1.0c

patch -p1 < ../../patches/50_openssl-1.1.0c_incfix+mipsr5900el-compat.patch || exit -1

CROSS_COMPILE="mipsr5900el-unknown-linux-gnu-" RANLIB=mipsr5900el-unknown-linux-gnu-ranlib ./Configure linux-mips32 --prefix=/usr/local/ps2/mipsr5900el-unknown-linux-gnu || exit -1

make -j 4 || exit -1
make install || exit -1

sleep 2

cd ../../scripts
sh 51_openssh.sh

#!/bin/bash
# Simple brutal sh-scripts chain.
if [ "$(echo $PATH | grep -o /usr/local/ps2/bin)" != "/usr/local/ps2/bin" ]
then
 echo -en "\033[36;1m There is no "/usr/local/ps2/bin" was added to \$PATH . Adding... \033[0m\n"
 export PATH=/usr/local/ps2/bin:$PATH
fi

cd ../sources
if [ ! -e mingetty-1.08.tar.gz ]
then
wget https://src.fedoraproject.org/repo/pkgs/mingetty/mingetty-1.08.tar.gz/2a75ad6487ff271424ffc00a64420990/mingetty-1.08.tar.gz || exit -1
fi
cd ../building
tar -zxvf ../sources/mingetty-1.08.tar.gz
cd mingetty-1.08

patch -p1 < ../../patches/32_mingetty-1.08_UTF8+compat.patch || exit -1

make || exit -1

cp -v mingetty /usr/local/ps2/mipsr5900el-unknown-linux-gnu/sbin/

cd ../../scripts
sh 33_iproute2.sh

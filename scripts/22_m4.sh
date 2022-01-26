#!/bin/bash
# Simple brutal sh-scripts chain.
if [ "$(echo $PATH | grep -o /usr/local/ps2/bin)" != "/usr/local/ps2/bin" ]
then
 echo -en "\033[36;1m There is no "/usr/local/ps2/bin" was added to \$PATH . Adding... \033[0m\n"
 export PATH=/usr/local/ps2/bin:$PATH
fi

cd ../sources
if [ ! -e m4-1.4.18.tar.xz ]
then
wget https://ftp.gnu.org/gnu/m4/m4-1.4.18.tar.xz || exit -1
fi
cd ../building
tar -Jxvf ../sources/m4-1.4.18.tar.xz
cd m4-1.4.18

patch -p1 < ../../patches/22_glibc-change-work-around.patch || exit -1

./configure --prefix=/usr/local/ps2/mipsr5900el-unknown-linux-gnu --host=mipsr5900el-unknown-linux-gnu || exit -1

make -j 4 || exit -1
make install || exit -1

sleep 2

cd ../../scripts
sh 23_make.sh

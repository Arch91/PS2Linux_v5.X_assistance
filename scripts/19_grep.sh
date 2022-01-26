#!/bin/bash
# Simple brutal sh-scripts chain.
if [ "$(echo $PATH | grep -o /usr/local/ps2/bin)" != "/usr/local/ps2/bin" ]
then
 echo -en "\033[36;1m There is no "/usr/local/ps2/bin" was added to \$PATH . Adding... \033[0m\n"
 export PATH=/usr/local/ps2/bin:$PATH
fi

cd ../sources
if [ ! -e grep-2.14.tar.xz ]
then
wget https://ftp.gnu.org/gnu/grep/grep-2.14.tar.xz || exit -1
fi
cd ../building
tar -Jxvf ../sources/grep-2.14.tar.xz
cd grep-2.14

./configure --prefix=/usr/local/ps2/mipsr5900el-unknown-linux-gnu --host=mipsr5900el-unknown-linux-gnu --disable-perl-regexp --without-included-regex || exit -1

make -j 4 || exit -1
make install || exit -1

sleep 2

cd ../../scripts
sh 20_gzip.sh

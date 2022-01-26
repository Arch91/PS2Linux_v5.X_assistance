#!/bin/bash
# Simple brutal sh-scripts chain.
if [ "$(echo $PATH | grep -o /usr/local/ps2/bin)" != "/usr/local/ps2/bin" ]
then
 echo -en "\033[36;1m There is no "/usr/local/ps2/bin" was added to \$PATH . Adding... \033[0m\n"
 export PATH=/usr/local/ps2/bin:$PATH
fi

cd ../sources
if [ ! -e e2fsprogs-1.45.4.tar.gz ]
then
wget https://distfiles.macports.org/e2fsprogs/e2fsprogs-1.45.4.tar.gz || exit -1
fi
cd ../building
tar -zxvf ../sources/e2fsprogs-1.45.4.tar.gz
cd e2fsprogs-1.45.4

./configure --prefix=/usr/local/ps2/mipsr5900el-unknown-linux-gnu --host=mipsr5900el-unknown-linux-gnu --disable-defrag || exit -1

make -j 4 || exit -1
make install || exit -1

sleep 2

cd ../../scripts
sh 16_findutils.sh

#!/bin/bash
# Simple brutal sh-scripts chain.
if [ "$(echo $PATH | grep -o /usr/local/ps2/bin)" != "/usr/local/ps2/bin" ]
then
 echo -en "\033[36;1m There is no "/usr/local/ps2/bin" was added to \$PATH . Adding... \033[0m\n"
 export PATH=/usr/local/ps2/bin:$PATH
fi

cd ../sources
if [ ! -e coreutils-8.31.tar.xz ]
then
wget https://ftp.gnu.org/gnu/coreutils/coreutils-8.31.tar.xz || exit -1
fi
cd ../building
tar -Jxvf ../sources/coreutils-8.31.tar.xz
cd coreutils-8.31

./configure --prefix=/usr/local/ps2/mipsr5900el-unknown-linux-gnu --host=mipsr5900el-unknown-linux-gnu --without-selinux --enable-threads=posix || exit -1

make -j 4 man1_MANS="" || exit -1
make man1_MANS="" install || exit -1

sleep 2

cd ../../scripts
sh 13_diffutils.sh

#!/bin/bash
# Simple brutal sh-scripts chain.
if [ "$(echo $PATH | grep -o /usr/local/ps2/bin)" != "/usr/local/ps2/bin" ]
then
 echo -en "\033[36;1m There is no "/usr/local/ps2/bin" was added to \$PATH . Adding... \033[0m\n"
 export PATH=/usr/local/ps2/bin:$PATH
 export GAWK_NO_RE_INTERVALS=1
fi

cd ../sources
if [ ! -e diffutils-3.7.tar.xz ]
then
wget https://ftp.gnu.org/gnu/diffutils/diffutils-3.7.tar.xz || exit -1
fi
cd ../building
tar -Jxvf ../sources/diffutils-3.7.tar.xz
cd diffutils-3.7
patch -p1 < ../../patches/13_diffutils-3.7_cstackFixed.patch || exit -1

./configure --prefix=/usr/local/ps2/mipsr5900el-unknown-linux-gnu --host=mipsr5900el-unknown-linux-gnu|| exit -1

make -j 4 || exit -1
make install || exit -1

sleep 2

cd ../../scripts
sh 14_gettext.sh

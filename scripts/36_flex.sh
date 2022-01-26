#!/bin/bash
# Simple brutal sh-scripts chain.
if [ "$(echo $PATH | grep -o /usr/local/ps2/bin)" != "/usr/local/ps2/bin" ]
then
 echo -en "\033[36;1m There is no "/usr/local/ps2/bin" was added to \$PATH . Adding... \033[0m\n"
 export PATH=/usr/local/ps2/bin:$PATH
fi

cd ../sources
if [ ! -e flex-2.6.0.tar.bz2 ]
then
wget https://src.fedoraproject.org/repo/pkgs/flex/flex-2.6.0.tar.bz2/266270f13c48ed043d95648075084d59/flex-2.6.0.tar.bz2 || exit -1
fi
cd ../building
tar -jxvf ../sources/flex-2.6.0.tar.bz2
cd flex-2.6.0

patch -p1 < ../../patches/36_flex-2.6.0_teststrick.patch || exit -1

./configure --prefix=/usr/local/ps2/mipsr5900el-unknown-linux-gnu --host=mipsr5900el-unknown-linux-gnu || exit -1

make -j 4 || exit -1
make install || exit -1

sleep 2

cd ../../scripts
sh 37_inetutils.sh

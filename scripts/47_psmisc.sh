#!/bin/bash
# Simple brutal sh-scripts chain.
if [ "$(echo $PATH | grep -o /usr/local/ps2/bin)" != "/usr/local/ps2/bin" ]
then
 echo -en "\033[36;1m There is no "/usr/local/ps2/bin" was added to \$PATH . Adding... \033[0m\n"
 export PATH=/usr/local/ps2/bin:$PATH
fi

cd ../sources
if [ ! -e psmisc-22.20.tar.gz ]
then
wget http://ftp.osuosl.org/pub/clfs/conglomeration/psmisc/psmisc-22.20.tar.gz || exit -1
fi
cd ../building
tar -zxvf ../sources/psmisc-22.20.tar.gz
cd psmisc-22.20

patch -p1 < ../../patches/47_psmisc-22.20_muteallocchekcs+compat.patch || exit -1

./configure --prefix=/usr/local/ps2/mipsr5900el-unknown-linux-gnu --host=mipsr5900el-unknown-linux-gnu || exit -1

make -j 4 || exit -1
make install || exit -1

sleep 2

cd ../../scripts
sh 48_sysklogd.sh

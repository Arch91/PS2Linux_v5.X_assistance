#!/bin/bash
# Simple brutal sh-scripts chain.
if [ "$(echo $PATH | grep -o /usr/local/ps2/bin)" != "/usr/local/ps2/bin" ]
then
 echo -en "\033[36;1m There is no "/usr/local/ps2/bin" was added to \$PATH . Adding... \033[0m\n"
 export PATH=/usr/local/ps2/bin:$PATH
fi

cd ../sources
if [ ! -e sysklogd-2.1.1.tar.gz ]
then
wget https://ftp.troglobit.com/sysklogd/sysklogd-2.1.1.tar.gz || exit -1
fi
cd ../building
tar -zxvf ../sources/sysklogd-2.1.1.tar.gz
cd sysklogd-2.1.1

./configure --prefix=/usr/local/ps2/mipsr5900el-unknown-linux-gnu --host=mipsr5900el-unknown-linux-gnu PKG_CONFIG_PATH=/usr/local/ps2/mipsr5900el-unknown-linux-gnu/lib/pkgconfig || exit -1

make -j 4 || exit -1
make install || exit -1

sleep 2

cd ../../scripts
sh 49_sysvinit.sh

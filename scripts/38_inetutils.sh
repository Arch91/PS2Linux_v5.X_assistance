#!/bin/bash
# Simple brutal sh-scripts chain.
if [ "$(echo $PATH | grep -o /usr/local/ps2/bin)" != "/usr/local/ps2/bin" ]
then
 echo -en "\033[36;1m There is no "/usr/local/ps2/bin" was added to \$PATH . Adding... \033[0m\n"
 export PATH=/usr/local/ps2/bin:$PATH
fi

cd ../sources
if [ ! -e inetutils-1.9.4.tar.gz ]
then
wget https://ftp.gnu.org/gnu/inetutils/inetutils-1.9.4.tar.gz || exit -1
fi
cd ../building
tar -zxvf ../sources/inetutils-1.9.4.tar.gz
cd inetutils-1.9.4

patch -p1 < ../../patches/38_inetutils-1.9.4-PATH_PROCNET_DEV.patch || exit -1

# What is disabled is provided from iproute2
./configure --prefix=/usr/local/ps2/mipsr5900el-unknown-linux-gnu --host=mipsr5900el-unknown-linux-gnu --disable-tftpd --disable-dnsdomainname --disable-ping --disable-ping6 || exit -1

make -j 4 || exit -1
make install || exit -1

sleep 2

cd ../../scripts
# Replace gettext's hostname to inetutils'es one.
SCRIPTS_DIR=$(pwd)
cd /usr/local/ps2/mipsr5900el-unknown-linux-gnu/lib/gettext
rm -f hostname
ln -s ../../bin/hostname hostname
cd $SCRIPTS_DIR
sh 39_cracklib.sh

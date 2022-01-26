#!/bin/bash
# Simple brutal sh-scripts chain.
if [ "$(echo $PATH | grep -o /usr/local/ps2/bin)" != "/usr/local/ps2/bin" ]
then
 echo -en "\033[36;1m There is no "/usr/local/ps2/bin" was added to \$PATH . Adding... \033[0m\n"
 export PATH=/usr/local/ps2/bin:$PATH
fi

cd ../sources
if [ ! -e pkg-config-0.29.1.tar.gz ]
then
wget https://pkgconfig.freedesktop.org/releases/pkg-config-0.29.1.tar.gz || exit -1
fi
cd ../building
tar -zxvf ../sources/pkg-config-0.29.1.tar.gz
cd pkg-config-0.29.1

patch -p1 < ../../patches/31_pkg-config-0.29.1_gdate_pragma.patch || exit -1

./configure --prefix=/usr/local/ps2 --target=mipsr5900el-unknown-linux-gnu --with-internal-glib --program-prefix=mipsr5900el-unknown-linux-gnu- || exit -1

make -j 4 || exit -1
make install
# Ignore those afterinstallation launches. pkg-config installed.

sleep 2

cd ../../scripts
sh 32_mingetty.sh

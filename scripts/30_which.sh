#!/bin/bash
# Simple brutal sh-scripts chain.
if [ "$(echo $PATH | grep -o /usr/local/ps2/bin)" != "/usr/local/ps2/bin" ]
then
 echo -en "\033[36;1m There is no "/usr/local/ps2/bin" was added to \$PATH . Adding... \033[0m\n"
 export PATH=/usr/local/ps2/bin:$PATH
fi

cd ../sources
if [ ! -e which-2.1.tar.gz ]
then
wget http://www.ibiblio.org/pub/linux/utils/shell/which-2.1.tar.gz || exit -1
fi
cd ../building
tar -zxvf ../sources/which-2.1.tar.gz
cd which-2.1

patch -p1 < ../../patches/30_which-2.1_compat.patch || exit -1

make || exit -1

cp -v which /usr/local/ps2/mipsr5900el-unknown-linux-gnu/bin/

cd ../../scripts
sh 31_pkg-config.sh

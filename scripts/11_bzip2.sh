#!/bin/bash
# Simple brutal sh-scripts chain.
if [ "$(echo $PATH | grep -o /usr/local/ps2/bin)" != "/usr/local/ps2/bin" ]
then
 echo -en "\033[36;1m There is no "/usr/local/ps2/bin" was added to \$PATH . Adding... \033[0m\n"
 export PATH=/usr/local/ps2/bin:$PATH
fi

cd ../sources
if [ ! -e bzip2-1.0.6.tar.gz ]
then
wget https://src.fedoraproject.org/lookaside/pkgs/bzip2/bzip2-1.0.6.tar.gz/00b516f4704d4a7cb50a1d97e6e8e15b/bzip2-1.0.6.tar.gz || exit -1
fi
cd ../building
tar -zxvf ../sources/bzip2-1.0.6.tar.gz
cd bzip2-1.0.6

patch -p1 < ../../patches/11_bzip2-1.0.6_compat.patch || exit -1

make || exit -1
make install PREFIX=/usr/local/ps2/mipsr5900el-unknown-linux-gnu || exit -1

sleep 2

cd ../../scripts
sh 12_coreutils.sh

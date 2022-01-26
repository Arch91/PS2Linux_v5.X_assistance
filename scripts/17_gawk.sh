#!/bin/bash
# Simple brutal sh-scripts chain.
if [ "$(echo $PATH | grep -o /usr/local/ps2/bin)" != "/usr/local/ps2/bin" ]
then
 echo -en "\033[36;1m There is no "/usr/local/ps2/bin" was added to \$PATH . Adding... \033[0m\n"
 export PATH=/usr/local/ps2/bin:$PATH
fi

cd ../sources
if [ ! -e gawk-4.0.1.tar.xz ]
then
wget https://ftp.gnu.org/gnu/gawk/gawk-4.0.1.tar.xz || exit -1
fi
cd ../building
tar -Jxvf ../sources/gawk-4.0.1.tar.xz
cd gawk-4.0.1

./configure --prefix=/usr/local/ps2/mipsr5900el-unknown-linux-gnu --host=mipsr5900el-unknown-linux-gnu ac_cv_func_working_mktime=yes || exit -1

make -j 4 || exit -1
make install || exit -1

sleep 2

cd ../../scripts
sh 18_libiconv.sh

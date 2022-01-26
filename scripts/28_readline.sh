#!/bin/bash
# Simple brutal sh-scripts chain.
if [ "$(echo $PATH | grep -o /usr/local/ps2/bin)" != "/usr/local/ps2/bin" ]
then
 echo -en "\033[36;1m There is no "/usr/local/ps2/bin" was added to \$PATH . Adding... \033[0m\n"
 export PATH=/usr/local/ps2/bin:$PATH
fi

cd ../sources
if [ ! -e readline-6.2.tar.gz ]
then
wget https://ftp.gnu.org/gnu/readline/readline-6.2.tar.gz || exit -1
fi
cd ../building
tar -zxvf ../sources/readline-6.2.tar.gz
cd readline-6.2

sed -i '/MV.*old/d' Makefile.in

./configure --prefix=/usr/local/ps2/mipsr5900el-unknown-linux-gnu --host=mipsr5900el-unknown-linux-gnu || exit -1

make -j 4 SHLIB_LIBS=-lncursesw || exit -1
make install || exit -1

sleep 2

cd ../../scripts
sh 29_bash.sh

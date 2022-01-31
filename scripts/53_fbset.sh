#!/bin/bash
# Simple brutal sh-scripts chain.
if [ "$(echo $PATH | grep -o /usr/local/ps2/bin)" != "/usr/local/ps2/bin" ]
then
 echo -en "\033[36;1m There is no "/usr/local/ps2/bin" was added to \$PATH . Adding... \033[0m\n"
 export PATH=/usr/local/ps2/bin:$PATH
fi

cd ../sources
if [ ! -e fbset-2.1.tar.gz ]
then
wget https://src.fedoraproject.org/lookaside/extras/fbset/fbset-2.1.tar.gz/md5/e547cfcbb8c1a4f2a6b8ba4acb8b7164/fbset-2.1.tar.gz || exit -1
fi
cd ../building
tar -zxvf ../sources/fbset-2.1.tar.gz
cd fbset-2.1

make CC=mipsr5900el-unknown-linux-gnu-gcc || exit -1
cp -v fbset /usr/local/ps2/mipsr5900el-unknown-linux-gnu/sbin/

sleep 2

cd ../../scripts
#sh Till_the_next_time.sh

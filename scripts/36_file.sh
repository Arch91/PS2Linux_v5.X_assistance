#!/bin/bash
# Simple brutal sh-scripts chain.
if [ "$(echo $PATH | grep -o /usr/local/ps2/bin)" != "/usr/local/ps2/bin" ]
then
 echo -en "\033[36;1m There is no "/usr/local/ps2/bin" was added to \$PATH . Adding... \033[0m\n"
 export PATH=/usr/local/ps2/bin:$PATH
fi

cd ../sources
if [ ! -e file-5.30.tar.gz ]
then
wget https://src.fedoraproject.org/lookaside/extras/file/file-5.30.tar.gz/sha512/473ee57517b449bae0832c17c9db914162c2404f0c669951f13a53f44ae288e6075907bac44fcfa8915f3d9313981a8bc15ea7e9851f584f95988bc76b2f20fc/file-5.30.tar.gz || exit -1
fi
cd ../building
tar -zxvf ../sources/file-5.30.tar.gz
cd file-5.30

./configure --prefix=/usr/local/ps2/mipsr5900el-unknown-linux-gnu --host=mipsr5900el-unknown-linux-gnu || exit -1

make -j 4 || exit -1
make install || exit -1

sleep 2

cd ../../scripts
sh 37_flex.sh

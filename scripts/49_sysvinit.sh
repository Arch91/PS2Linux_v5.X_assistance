#!/bin/bash
# Simple brutal sh-scripts chain.
if [ "$(echo $PATH | grep -o /usr/local/ps2/bin)" != "/usr/local/ps2/bin" ]
then
 echo -en "\033[36;1m There is no "/usr/local/ps2/bin" was added to \$PATH . Adding... \033[0m\n"
 export PATH=/usr/local/ps2/bin:$PATH
fi

cd ../sources
if [ ! -e sysvinit-2.88dsf.tar.bz2 ]
then
wget https://download-mirror.savannah.gnu.org/releases/sysvinit/sysvinit-2.88dsf.tar.bz2 || exit -1
fi
cd ../building
tar -jxvf ../sources/sysvinit-2.88dsf.tar.bz2
cd sysvinit-2.88dsf

patch -p1 < ../../patches/49_sysvinit-2.88dsf_compat.patch || exit -1

make CC=mipsr5900el-unknown-linux-gnu-gcc -C src || exit -1

sleep 2

cp -rdfv src/{fstab-decode,halt,init,killall5,runlevel,shutdown} /usr/local/ps2/mipsr5900el-unknown-linux-gnu/sbin/

cd ../../scripts
SCRIPTS_DIR=$(pwd)

cd /usr/local/ps2/mipsr5900el-unknown-linux-gnu/sbin
ln -s killall5 pidof

cd $SCRIPTS_DIR
sh 50_nano.sh

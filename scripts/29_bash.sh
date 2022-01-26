#!/bin/bash
# Simple brutal sh-scripts chain.
if [ "$(echo $PATH | grep -o /usr/local/ps2/bin)" != "/usr/local/ps2/bin" ]
then
 echo -en "\033[36;1m There is no "/usr/local/ps2/bin" was added to \$PATH . Adding... \033[0m\n"
 export PATH=/usr/local/ps2/bin:$PATH
fi

cd ../sources
if [ ! -e bash-4.2.tar.gz ]
then
wget https://ftp.gnu.org/gnu/bash/bash-4.2.tar.gz || exit -1
fi
cd ../building
tar -zxvf ../sources/bash-4.2.tar.gz
cd bash-4.2

patch -p1 < ../../patches/29_bash-4.2_uCompat.patch || exit -1

CC="mipsr5900el-unknown-linux-gnu-gcc -static -static-libgcc" ./configure --prefix=/usr/local/ps2/mipsr5900el-unknown-linux-gnu --host=mipsel-unknown-linux-gnu --with-curses --without-bash-malloc --with-installed-readline --enable-largefile ac_cv_func_working_mktime=yes ac_cv_c_bigendian=no || exit -1

make -j 4 || exit -1
make install || exit -1

sleep 2

cd ../../scripts
SCRIPTS_DIR=$(pwd)

cd /usr/local/ps2/mipsr5900el-unknown-linux-gnu/bin
mipsr5900el-unknown-linux-gnu-strip bash
ln -s bash sh

cd $SCRIPTS_DIR
sh 30_which.sh

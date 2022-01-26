#!/bin/bash
# Simple brutal sh-scripts chain.
if [ "$(echo $PATH | grep -o /usr/local/ps2/bin)" != "/usr/local/ps2/bin" ]
then
 echo -en "\033[36;1m There is no "/usr/local/ps2/bin" was added to \$PATH . Adding... \033[0m\n"
 export PATH=/usr/local/ps2/bin:$PATH
fi

cd ../sources
if [ ! -e ncurses-5.9.tar.gz ]
then
wget https://ftp.gnu.org/gnu/ncurses/ncurses-5.9.tar.gz || exit -1
fi
cd ../building
tar -zxvf ../sources/ncurses-5.9.tar.gz
cd ncurses-5.9

patch -p1 < ../../patches/10_work_around_changed_output_of_GNU_cpp_5.x.patch.txt || exit -1

./configure --prefix=/usr/local/ps2/mipsr5900el-unknown-linux-gnu --host=mipsr5900el-unknown-linux-gnu --without-cxx --without-cxx-binding --with-shared --without-debug --without-ada --enable-overwrite --enable-widec --enable-pc-files || exit -1

make -j 4 || exit -1
make install || exit -1

sleep 2

mkdir /usr/local/ps2/mipsr5900el-unknown-linux-gnu/lib/pkgconfig
cp -rdfv misc/*.pc /usr/local/ps2/mipsr5900el-unknown-linux-gnu/lib/pkgconfig/

cd ../../scripts
sh 11_bzip2.sh

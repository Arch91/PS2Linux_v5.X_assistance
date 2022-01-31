#!/bin/bash
# Simple brutal sh-scripts chain.
if [ "$(echo $PATH | grep -o /usr/local/ps2/bin)" != "/usr/local/ps2/bin" ]
then
 echo -en "\033[36;1m There is no "/usr/local/ps2/bin" was added to \$PATH . Adding... \033[0m\n"
 export PATH=/usr/local/ps2/bin:$PATH
fi

# Let's rebuild ncurses to have .pc files since we have pkg-config

cd ../building/ncurses-5.9

make distclean

sleep 2

./configure --prefix=/usr/local/ps2/mipsr5900el-unknown-linux-gnu --host=mipsr5900el-unknown-linux-gnu --without-cxx --without-cxx-binding --with-shared --without-debug --without-ada --enable-overwrite --enable-widec --enable-pc-files PKG_CONFIG_LIBDIR=/usr/local/ps2/mipsr5900el-unknown-linux-gnu/lib/pkgconfig || exit -1

make -j 4 || exit -1
make install || exit -1

sleep 2

cd ../../scripts
sh 33_mingetty.sh

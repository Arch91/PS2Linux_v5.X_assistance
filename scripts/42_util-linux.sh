#!/bin/bash
# Simple brutal sh-scripts chain.
if [ "$(echo $PATH | grep -o /usr/local/ps2/bin)" != "/usr/local/ps2/bin" ]
then
 echo -en "\033[36;1m There is no "/usr/local/ps2/bin" was added to \$PATH . Adding... \033[0m\n"
 export PATH=/usr/local/ps2/bin:$PATH
fi

cd ../sources
if [ ! -e util-linux-2.34-rc2.tar.xz ]
then
wget http://cdn.kernel.org/pub/linux/utils/util-linux/v2.34/util-linux-2.34-rc2.tar.xz || exit -1
fi
cd ../building
tar -Jxvf ../sources/util-linux-2.34-rc2.tar.xz
cd util-linux-2.34-rc2

# chfn, chsh, login, nologin, su - all of them will be from the shadow package.
./configure --prefix=/usr/local/ps2/mipsr5900el-unknown-linux-gnu --host=mipsr5900el-unknown-linux-gnu PKG_CONFIG_PATH=/usr/local/ps2/mipsr5900el-unknown-linux-gnu/lib/pkgconfig --without-selinux  --disable-chfn-chsh --disable-login --disable-nologin --disable-su || exit -1

# Just so:
# libcap-ng library not found; not building setpriv

make -j 4 NCURSES_LIBS="-lncursesw" || exit -1
make install || exit -1

sleep 2

cd ../../scripts
sh 43_shadow.sh

#!/bin/bash
# Simple brutal sh-scripts chain.
if [ "$(echo $PATH | grep -o /usr/local/ps2/bin)" != "/usr/local/ps2/bin" ]
then
 echo -en "\033[36;1m There is no "/usr/local/ps2/bin" was added to \$PATH . Adding... \033[0m\n"
 export PATH=/usr/local/ps2/bin:$PATH
fi

if [ -e /usr/bin/automake-1.13 ] && [ "$(automake-1.13 --version | grep -o 1.13.4)" == "1.13.4" ]
then
echo -en "\033[36;1m automake-1.13.4 is installed on the system. Proceeding to Linux-PAM installation...\033[0m\n"
sleep 2
else
echo -en "\033[36;1m automake-1.13.4 is NOT installed on the system. Will install it now (note that this will not pollute/damage your system and your current automake/aclocal)\033[0m\n"

cd ../forhost
wget https://ftp.gnu.org/gnu/automake/automake-1.13.4.tar.xz || exit -1
tar -Jxvf automake-1.13.4.tar.xz
FORHOSTDIR=$(pwd)
cd automake-1.13.4

./configure --prefix=/usr

make || exit -1
make DESTDIR=$FORHOSTDIR install

sleep 2

cd ../
mv -f usr/bin/aclocal-1.13 /usr/bin/
mv -f usr/bin/automake-1.13 /usr/bin/
mv -f usr/share/aclocal-1.13 /usr/share/
mv -f usr/share/automake-1.13 /usr/share/

rm -rf usr
rm -rf automake-1.13.4
fi

cd ../sources
if [ ! -e Linux-PAM-1.3.0.tar.bz2 ]
then
wget http://linux-pam.org/library/Linux-PAM-1.3.0.tar.bz2 || exit -1
fi
cd ../building
tar -jxvf ../sources/Linux-PAM-1.3.0.tar.bz2
cd Linux-PAM-1.3.0

./configure --prefix=/usr/local/ps2/mipsr5900el-unknown-linux-gnu --host=mipsr5900el-unknown-linux-gnu || exit -1

make -j 4
# Do not care about docs building in doc/specs if this error appears, just proceed to installation.
make install || exit -1

sleep 2

cd ../../scripts
SCRIPTS_DIR=$(pwd)
cd /usr/local/ps2/mipsr5900el-unknown-linux-gnu/include
ln -s . security

cd $SCRIPTS_DIR
sh 41_libcap.sh

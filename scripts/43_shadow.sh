#!/bin/bash
# Simple brutal sh-scripts chain.
if [ "$(echo $PATH | grep -o /usr/local/ps2/bin)" != "/usr/local/ps2/bin" ]
then
 echo -en "\033[36;1m There is no "/usr/local/ps2/bin" was added to \$PATH . Adding... \033[0m\n"
 export PATH=/usr/local/ps2/bin:$PATH
fi

cd ../sources
if [ ! -e shadow-4.1.5.1.tar.bz2 ]
then
wget https://ftp.osuosl.org/pub/blfs/conglomeration/shadow/shadow-4.1.5.1.tar.bz2 || exit -1
fi
cd ../building
tar -jxvf ../sources/shadow-4.1.5.1.tar.bz2
cd shadow-4.1.5.1

./configure --prefix=/usr/local/ps2/mipsr5900el-unknown-linux-gnu --host=mipsr5900el-unknown-linux-gnu --without-selinux --without-nscd --with-libpam --with-libcrack || exit -1

make -j 4 || exit -1
make install || exit -1

sleep 2

# After installation, there should make the appropriate files (passwd, group) in target-system's
# /etc and also edit target-system's /etc/pam.d/{su,login} - remove the lines which contains
# pam_selinux.so . Where is no file "system-auth", so I copied it from the times of testing
# fedora12_mips64el and keep it nowadays. All these presented in final-unpack archive.

cd ../../scripts
sh 44_kbd.sh

#!/bin/bash
# Simple brutal sh-scripts chain.
if [ "$(echo $PATH | grep -o /usr/local/ps2/bin)" != "/usr/local/ps2/bin" ]
then
 echo -en "\033[36;1m There is no "/usr/local/ps2/bin" was added to \$PATH . Adding... \033[0m\n"
 export PATH=/usr/local/ps2/bin:$PATH
fi

cd ../sources
if [ ! -e openssh-7.6p1.tar.gz ]
then
wget https://ftp.osuosl.org/pub/blfs/conglomeration/openssh/openssh-7.6p1.tar.gz || exit -1
fi
cd ../building
tar -zxvf ../sources/openssh-7.6p1.tar.gz
cd openssh-7.6p1

patch -p1 < ../../patches/52_openssh-7.6p1-openssl-1.1.0-1.patch || exit -1
patch -p1 < ../../patches/52_openssh-7.6p1_changesshdconfigoption.patch || exit -1

./configure --prefix=/usr/local/ps2/mipsr5900el-unknown-linux-gnu --host=mipsr5900el-unknown-linux-gnu PKG_CONFIG_PATH=/usr/local/ps2/mipsr5900el-unknown-linux-gnu/lib/pkgconfig --disable-strip || exit -1

make -j 4 || exit -1
make install
# Ignore those afterinstallation launches. sshd and the appropriate are installed.
# The default config for sshd is ready for ssh connection since now... but the
# sshd user and group, and the ssh_host_xxxxx_key creation will be maded in
# the final-unpack stage.

sleep 2

mkdir /usr/local/ps2/mipsr5900el-unknown-linux-gnu/var/empty

# Note that you should load the ssh daemon not just with command 'sshd'
# but using it's full path with it, eg. '/sbin/sshd'

cd ../../scripts
sh 53_fbset.sh

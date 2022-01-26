#!/bin/bash
# Simple brutal sh-scripts chain.
if [ "$(echo $PATH | grep -o /usr/local/ps2/bin)" != "/usr/local/ps2/bin" ]
then
 echo -en "\033[36;1m There is no "/usr/local/ps2/bin" was added to \$PATH . Adding... \033[0m\n"
 export PATH=/usr/local/ps2/bin:$PATH
fi

cd ../sources
if [ ! -e cracklib-2.8.19.tar.gz ]
then
wget https://ftp.osuosl.org/pub/blfs/conglomeration/cracklib/cracklib-2.8.19.tar.gz || exit -1
fi
cd ../building
tar -zxvf ../sources/cracklib-2.8.19.tar.gz
cd cracklib-2.8.19

./configure --prefix=/usr/local/ps2/mipsr5900el-unknown-linux-gnu --host=mipsr5900el-unknown-linux-gnu || exit -1

make -j 4 || exit -1
make install || exit -1

sleep 2

# Because I don't know how or where from to get the appropriated files for this lib, in the
# times I was testing fedora12_mips64el in qemu - I compiled the same cracklib
# version (that's 2.8.19 as you can see) and just copied the files from fedora12_mips64el
# from /usr/share/cracklib (cracklib.magic , cracklib-small.hwm , cracklib-small.pwd ,
# cracklib-small.pwi , pw_dict.hwm , pw_dict.pwd pw_dict.pwi) to
# /usr/local/ps2/mipsr5900el-unknown-linux-gnu/share/cracklib . Those files are
# presented in the final-unpack archive .

cd ../../scripts
sh 39_Linux-PAM.sh

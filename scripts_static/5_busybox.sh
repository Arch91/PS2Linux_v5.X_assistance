#!/bin/bash
# Simple brutal sh-scripts chain.
if [ "$(echo $PATH | grep -o /usr/local/ps2/bin)" != "/usr/local/ps2/bin" ]
then
 echo -en "\033[36;1m There is no "/usr/local/ps2/bin" was added to \$PATH . Adding... \033[0m\n"
 export PATH=/usr/local/ps2/bin:$PATH
 export GAWK_NO_RE_INTERVALS=1
fi
 echo -en "\033[36;1m ...so?.. README! \033[0m\n"

# The steps below are similar to the built -gnu toolchain. For the -musl toolchain, 
# the only difference is that you must change the 
#CONFIG_CROSS_COMPILER_PREFIX="mipsr5900el-unknown-linux-musl-"
# variable inside the copied .config file. To avoid wiping out the source directory,
# simple 'make distclean' will do its thing.
# To avoid wiping out the pre-configured and pre-installed initramfs structure, instead of
# running 'make install', simply copy the built 'busybox' binary to initramfs/bin/ with
# overwriting.
 
#cd ../sources
#if [ ! -e busybox-1.28.0.tar.bz2 ]
#then
#wget https://busybox.net/downloads/busybox-1.28.0.tar.bz2 || exit -1
#fi
#cd ../building
#tar -jxvf ../sources/busybox-1.28.0.tar.bz2
#cd busybox-1.28.0
#patch -p1 < ../../patches/7_busybox-1.28.0_stime_fixed.patch
#cp ../../config-files/config-busybox.txt .config || exit -1
#make oldconfig || exit -1
#make -j 4 || exit -1
# According to the config-busybox-default.txt, everything is going to be installed
# to the _install folder here.
#make install || exit -1

#cd _install
#mkdir {dev,lib,proc,sys,mnt,var,tmp,newroot}
#mkdir lib/firmware
#mkdir lib/firmware/ps2
#cp ../../../config-files/"init-for-busybox.sh" init || exit -1
#rm -f sbin/init
#cp ../../../config-files/"actual_init-for-busybox.sh" sbin/init || exit -1
#chmod a+x init
#chmod a+x sbin/init

#sleep 2

#cd ../../
#mv busybox-1.28.0/_install initramfs
#cd ../scripts_static
#sh 6_iopmod.sh

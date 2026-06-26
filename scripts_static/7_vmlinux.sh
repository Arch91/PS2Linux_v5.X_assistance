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
# the only difference is that you must use the 
#CROSS_COMPILE=mipsr5900el-unknown-linux-musl-
# variable in every 'make' action. Definetely, no need to re-download the entire kernel source!
# 'make distclean' will do its thing.

# To be able to control init, edit files 'init' and 'sbin/init' in the initramfs
# folder. If you have the target-system, better keep only the some modules inside
# the kernel for just to be able to launch that target-system, but all modules in
# the appropriate folder of target-system.
#cd ../building/linux-ps2-v5.4.221
# ps2_defconfig is a default config-file to make oldconfig with. Unless you
# have your own.
#cp arch/mips/configs/ps2_defconfig .config

#make ARCH=mips CROSS_COMPILE=mipsr5900el-unknown-linux-musl- oldconfig || exit -1
#make ARCH=mips CROSS_COMPILE=mipsr5900el-unknown-linux-musl- -j 4 modules || exit -1
#KERNEL_DIR=$(pwd)
#cd ../initramfs
#INITRAMFS_DIR=$(pwd)
#cd ../linux-ps2-v5.4.221
#make ARCH=mips CROSS_COMPILE=mipsr5900el-unknown-linux-musl- INSTALL_MOD_PATH=$INITRAMFS_DIR INSTALL_MOD_STRIP=1 modules_install || exit -1
#cd $INITRAMFS_DIR/lib/modules
#ln -s 5.4.221+ 5.4.221
#cd $KERNEL_DIR
#rm -rfv usr/initramfs_data.{o,cpio.xz}; make ARCH=mips CROSS_COMPILE=mipsr5900el-unknown-linux-musl- -j 4 vmlinuz || exit -1
#mv vmlinuz PS2Linux5.4.221.ELF
#echo -en "\033[31;1mIf you will be editing init files, you have to clean the kernel build and rebuild it by manually typing these commands:
#make clean
#rm -rfv usr/initramfs_data.{o,cpio.xz}; make ARCH=mips CROSS_COMPILE=mipsr5900el-unknown-linux-gnu- -j 4 vmlinuz
#mv vmlinuz PS2Linux5.4.221ELF\033[0m\n"

#sleep 2

#Congratulations! You have successfully built the PS2Linux kernel v5.4 test variant with the musl toolchain (as well)! Now, not only can you proudly move the PS2Linux5.4.221.ELF file to your USB flash drive to test things out, but you can also compile static binaries of your own choice and, for example, inject them into the initramfs! GJ!

#cd ../?

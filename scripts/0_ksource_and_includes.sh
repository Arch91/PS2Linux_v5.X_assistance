#!/bin/bash
# Simple brutal sh-scripts chain.
# Decided to read this one first? - that's right. Everything will be installed
# to /usr/local/ps2/mipsr5900el-unknown-linux-gnu . No VARIABLES=""
# prunings. BRUTAL. SCRIPTS. CHAIN.
# Also, no 'sudo' . And, obviously, you have to have libgmp,libmpfr,libmpc
# devels installed in your system.
# Chains are good to continue from the next place where the building stucks.
# In the end, the root of the system will be in /usr/local/ps2/mipsr5900el-unknown-linux-gnu
# so in the system we will just place a symlink to / in there.
# If there will be an issues while compiling - read the script with that package issue,
# maybe I have a comments how to solve them there.
mkdir -p ../{building,forhost,sources}
echo -en "\033[36;1mFrom now on, you can go smoke / drink tea / etc., because this is not for a short period of time. But when everyting will be downloaded, go to the downloaded kernel source:\033[0m\n"
echo -en "\033[31;1mcd ../building/linux-ps2-v5.4.221\033[0m\n"
echo -en "\033[31;1mpatch -p1 < ../../patches/0_MIPS_ATOMIC_CAS.patch\033[0m\n"
echo -en "\033[31;1mpatch -p1 < ../../patches/0_frnos-kernel_bitops.patch\033[0m\n"
echo -en "\033[36;1mand install the headers of it by typing this command:\033[0m\n"
echo -en "\033[31;1mmake ARCH=mips headers_install INSTALL_HDR_PATH=/usr/local/ps2/mipsr5900el-unknown-linux-gnu\033[0m\n"
echo -en "\033[36;1mThen, after the headers will be installed, you may proceed with building a cross-compiler by typing these commands:\033[0m\n"
echo -en "\033[31;1mcd ../../scripts
sh 1_binutils.sh\033[0m\n"

cd ../building
git clone https://github.com/frno7/linux.git
mv linux linux-ps2-v5.4.221
ln -s linux-ps2-v5.4.221 linux

mkdir -p /usr/local/ps2/mipsr5900el-unknown-linux-gnu
mkdir /usr/local/ps2/bin

cd ../sources
if [ ! -e make-3.81.tar.bz2 ]
then
wget https://ftp.gnu.org/gnu/make/make-3.81.tar.bz2 || exit -1
fi
cd ../forhost
tar -jxvf ../sources/make-3.81.tar.bz2
cd make-3.81
patch -p1 < ../../patches/0_make-3.81_hostcompat.patch

./configure --prefix=/usr/local/ps2 ac_cv_type_signal=void || exit -1

make -j 4 || exit -1
strip make || exit -1
cp -v make /usr/local/ps2/bin || exit -1

echo -en "\033[36;1mOk, we are good. Reminder. Go to the downloaded kernel source:\033[0m\n"
echo -en "\033[31;1mcd ../building/linux-ps2-v5.4.221\033[0m\n"
echo -en "\033[31;1mpatch -p1 < ../../patches/0_MIPS_ATOMIC_CAS.patch\033[0m\n"
echo -en "\033[31;1m(Before the next one, check the file arch/mips/include/asm/bitops.h to see whether he added the plzcw instruction there or he did not)\033[0m\n"
echo -en "\033[31;1mpatch -p1 < ../../patches/0_frnos-kernel_bitops.patch\033[0m\n"
echo -en "\033[36;1mand install the headers of it by typing this command:\033[0m\n"
echo -en "\033[31;1mmake ARCH=mips headers_install INSTALL_HDR_PATH=/usr/local/ps2/mipsr5900el-unknown-linux-gnu\033[0m\n"
echo -en "\033[36;1mThen, after the headers will be installed, you may proceed with building a cross-compiler by typing these commands:\033[0m\n"
echo -en "\033[31;1mcd ../../scripts
sh 1_binutils.sh\033[0m\n"

#cd linux-ps2-v5.4.221
#patch -p1 < patches/0_MIPS_ATOMIC_CAS.patch
# - that one basically gives the 'opportunity' to the coders to roll up the sleeves and rewrite the atomic compare-and-set write logic to use it via a syscall, which is lighter on the hardware than emulating the missing ll/sc instructions via the reserved instruction exception. HOWEVER, if you ever come across code that contains ll/sc and requires mandatory intervention to compile, that code will have to be modified...
#patch -p1 < patches/0_frnos-kernel_bitops.patch
#make ARCH=mips headers_install INSTALL_HDR_PATH=/usr/local/ps2/mipsr5900el-unknown-linux-gnu

#cd ../../scripts
#sh 1_binutils.sh

#!/bin/bash
# Simple brutal sh-scripts chain.
echo -en "\033[36;1mAssuming you already built a toolchain once at least for the -gnu target. Read me!\033[0m\n"

# The only difference here when building a toolchain based on musl libc is that we must install
# the headers into a directory matching the target name. If you have a toolchain based on glibc
# in your /usr/local/ps2 directory - move that ps2 folder to some other name.

#mv /usr/local/ps2 /usr/local/ps2_glibc
#mkdir -p /usr/local/ps2/mipsr5900el-unknown-linux-musl
#mkdir /usr/local/ps2/bin

#cd linux-ps2-v5.4.221
#make ARCH=mips headers_install INSTALL_HDR_PATH=/usr/local/ps2/mipsr5900el-unknown-linux-musl

# Also, copy the compiled binary file of make-3.81
#cp ../../forhost/make-3.81/make /usr/local/ps2/bin/

# And next, instead of running the scripts chain, I recommend manually reviewing each one and
# following the configuring/patching/compilation steps. By doing so, perhaps you'll choose
# a different directory so both target-system toolchain and static-building toolchain
# will be co-existing. Alternatively however, you can completely clean the 'building' folder and
# do use the automated script sequence, which obviously are going to build everything into
# the /usr/local/ps2 directory.

#cd ../../scripts
#sh 1_binutils.sh

#!/bin/bash
# Simple brutal sh-scripts chain.
if [ "$(echo $PATH | grep -o /usr/local/ps2/bin)" != "/usr/local/ps2/bin" ]
then
 echo -en "\033[36;1m There is no "/usr/local/ps2/bin" was added to \$PATH . Adding... \033[0m\n"
 export PATH=/usr/local/ps2/bin:$PATH
 export GAWK_NO_RE_INTERVALS=1
fi

cd ../sources
if [ ! -e musl-1.2.5.tar.gz ]
then
wget https://toolchains.bootlin.com/downloads/releases/sources/musl-1.2.5/musl-1.2.5.tar.gz || exit -1
fi
cd ../building
tar -zxvf ../sources/musl-1.2.5.tar.gz
cd musl-1.2.5
patch -p1 < ../../patches_static/musl-1.2.4-arm64-crti-alignment.patch
patch -p1 < ../../patches_static/musl-sched.h-reduce-namespace-conflicts.patch
patch -p1 < ../../patches_static/musl-iconv-out-of-bound-fix.patch
patch -p1 < ../../patches_static/musl-arm-crti-alignment.patch
patch -p1 < ../../patches_static/musl-ppc-clobber.patch
patch -p1 < ../../patches_static/musl-dns-union.patch
patch -p1 < ../../patches_static/musl-getauxval.patch
patch -p1 < ../../patches_static/musl-getifaddrs-qemu-workaround.patch
patch -p1 < ../../patches_static/musl-page-size.patch
patch -p1 < ../../patches_static/musl-isatty.patch
patch -p1 < ../../patches_static/musl-printf-empty-iovec.patch
patch -p1 < ../../patches_static/musl-syscall4149_2002use.patch
# - that one is to utilize the MIPS_ATOMIC_CAS part of the sys_sysmips syscall for musl!
# And also a modest clz over plzcw function.
CROSS_COMPILE=mipsr5900el-unknown-linux-musl- CC=mipsr5900el-unknown-linux-musl-gcc ./configure --prefix=/usr/local/ps2/mipsr5900el-unknown-linux-musl --target=mipsr5900el-unknown-linux-musl --syslibdir=/usr/local/ps2/mipsr5900el-unknown-linux-musl/lib
make -j 4
make install
cd /usr/local/ps2/mipsr5900el-unknown-linux-musl
mkdir usr
mkdir usr/bin
cd usr/bin
ln -s ../../lib/ld-musl-mipsel-sf.so.1 ldd
# Just in case
#mipsr5900el-unknown-linux-musl-gcc -O2 -c -o libssp_nonshared.o files/stack_chk_fail_local.c
#mipsr5900el-unknown-linux-musl-ar -rcs libssp_nonshared.a libssp_nonshared.o
#cp libssp_nonshared.a /usr/local/ps2/mipsr5900el-unknown-linux-musl/usr/lib/

sleep 2

cd ../../scripts_static
sh 4_gcc_st2_on_musl.sh

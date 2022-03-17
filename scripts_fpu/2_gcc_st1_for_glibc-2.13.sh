#!/bin/bash
# Simple brutal sh-scripts chain.
if [ "$(echo $PATH | grep -o /usr/local/ps2/bin)" != "/usr/local/ps2/bin" ]
then
 echo -en "\033[36;1m There is no "/usr/local/ps2/bin" was added to \$PATH . Adding... \033[0m\n"
 export PATH=/usr/local/ps2/bin:$PATH
fi

cd ../sources
if [ ! -e gcc-9.2.0.tar.xz ]
then
wget https://ftp.gnu.org/gnu/gcc/gcc-9.2.0/gcc-9.2.0.tar.xz || exit -1
fi
cd ../building
tar -Jxvf ../sources/gcc-9.2.0.tar.xz
cd gcc-9.2.0
patch -p1 < ../../patches/2_gcc-9.2.0_compat.patch
# FPU is not optimized for nextgen PS2Linux yet. For testing purposes only, you have been warned.
# https://gcc.gnu.org/legacy-ml/gcc-patches/2014-02/msg00420.html
# - there is something wrong been done with that implementation to use hardfp for libgcc floating-point routines - when building gcc, there are files.o are wrongly including this as the dependence - "../../../libgcc/hardfp.c". Compiling with that built gcc will result to a SegFaults which also tells about that "missed dependence" included (at least for single float targets). So, let's discard it and use as it was before that implementation until it is fixed.
patch -p1 < ../../patches/2_gcc-9.2.0-discard-hardfp-on-libgcc-fp-routines.patch
mkdir build
cd build
# Difference in flags - --with-float=hard and --with-fpu=single
../configure --prefix=/usr/local/ps2 --target=mipsr5900el-unknown-linux-gnu --enable-languages=c --includedir=/usr/local/ps2/mipsr5900el-unknown-linux-gnu/include --disable-nls --disable-shared --disable-libssp --disable-libmudflap --disable-threads --disable-libgomp --disable-libquadmath --disable-target-libiberty --disable-target-zlib --without-ppl --without-cloog --with-headers=no --disable-libada --disable-libatomic --with-llsc=no --with-float=hard --with-fpu=single --disable-multilib || exit -1

make -j 4 || exit -1
make install || exit -1

sleep 2

cd ../../../scripts
SCRIPTS_DIR=$(pwd)
cd /usr/local/ps2/lib/gcc/mipsr5900el-unknown-linux-gnu/9.2.0
ln -s libgcc.a libgcc_eh.a
cd $SCRIPTS_DIR
sh 3_glibc-2.13.sh

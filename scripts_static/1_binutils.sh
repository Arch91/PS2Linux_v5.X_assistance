#!/bin/bash
# Simple brutal sh-scripts chain.
cd ../sources
if [ ! -e binutils-2.34.tar.xz ]
then
# Note that unlike the -gnu target toolchain, we are building version 2.34 for the
# -musl target. It's not because it's better or anything — it's just because back when
# GCC 9.2.0 was modern, its matching companion was binutils about version 2.34.
wget https://ftp.gnu.org/gnu/binutils/binutils-2.34.tar.xz || exit -1
fi
cd ../building
tar -Jxvf ../sources/binutils-2.34.tar.xz
cd binutils-2.34
mkdir build
cd build
../configure --prefix=/usr/local/ps2 --target=mipsr5900el-unknown-linux-musl --enable-shared --enable-plugins --disable-werror || exit -1

make -j 4 || exit -1
make install || exit -1

sleep 2

cd ../../../scripts_static
sh 2_gcc_st1_for_musl.sh

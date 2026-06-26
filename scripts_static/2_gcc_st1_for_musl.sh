#!/bin/bash
# Simple brutal sh-scripts chain.
if [ "$(echo $PATH | grep -o /usr/local/ps2/bin)" != "/usr/local/ps2/bin" ]
then
 echo -en "\033[36;1m There is no "/usr/local/ps2/bin" was added to \$PATH . Adding... \033[0m\n"
 export PATH=/usr/local/ps2/bin:$PATH
 export GAWK_NO_RE_INTERVALS=1
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
patch -p1 < ../../patches/2_gcc-9.2.0_glimits.patch
patch -p1 < ../../patches/2_gcc-9.2.0_bitopsOverPlzcw.patch
# - that one is my pride B)
mkdir build
cd build
# A non-standard FPU remains an issue. So using --with-float=soft
# bitopsOverPlzcw patch lightly mitigates the emulation mechanism, but still...
../configure --prefix=/usr/local/ps2 --target=mipsr5900el-unknown-linux-musl --enable-languages=c --disable-libatomic --with-llsc=no --with-float=soft --without-cloog --without-isl --without-headers --disable-libitm --disable-libsanitizer --disable-libgomp --disable-libssp --disable-libmudflap --disable-threads --disable-libquadmath --disable-target-libiberty --disable-target-zlib --without-ppl --disable-libada --disable-multilib --disable-silent-rules --disable-werror --disable-nls --disable-shared --disable-libunwind-exceptions --enable-__cxa_atexit --disable-bootstrap skipdirs=fixincludes || exit -1

make -j 4 || exit -1
make install || exit -1

# Just in case if skipdirs=fixincludes set was absent or did not work
#mkdir -p ../build-x86_64-pc-linux-gnu/fixincludes
#touch ../build-x86_64-pc-linux-gnu/fixincludes/fixinc.sh
#chmod +x ../build-x86_64-pc-linux-gnu/fixincludes/fixinc.sh

sleep 2

cd ../../../scripts_static
SCRIPTS_DIR=$(pwd)
cd /usr/local/ps2/lib/gcc/mipsr5900el-unknown-linux-musl/9.2.0
ln -s libgcc.a libgcc_eh.a
cd $SCRIPTS_DIR
sh 3_musl-1.2.5.sh

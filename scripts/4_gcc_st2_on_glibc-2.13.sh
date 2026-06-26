#!/bin/bash
# Simple brutal sh-scripts chain.
if [ "$(echo $PATH | grep -o /usr/local/ps2/bin)" != "/usr/local/ps2/bin" ]
then
 echo -en "\033[36;1m There is no "/usr/local/ps2/bin" was added to \$PATH . Adding... \033[0m\n"
 export PATH=/usr/local/ps2/bin:$PATH
 export GAWK_NO_RE_INTERVALS=1
fi

cd ../building/gcc-9.2.0/build
if [ "$(pwd | grep -o /gcc-9.2.0/build)" != "/gcc-9.2.0/build" ]
then
echo "\033[31;1mWhow-whow-whow, scripts are now going to make 'rm -rf *' in the directory they are not supposed to do that! It needs your support, check them out.\033[0m\n"
else
make distclean; rm -rf *
fi

# To build the modern glibc, it is needed to have the compiler with libatomic...
# ...BUT! This toolchain will be using the mips_atomic_cas part of the sys_sysmips syscall
# specific to this build instead!
# A non-standard FPU remains an issue. So using --with-float=soft
../configure --prefix=/usr/local/ps2 --target=mipsr5900el-unknown-linux-gnu --enable-languages=c,c++ --includedir=/usr/local/ps2/mipsr5900el-unknown-linux-gnu/include --disable-libatomic --with-llsc=no --with-float=soft --without-cloog --without-isl --disable-libitm --disable-libsanitizer --disable-libgomp --disable-libssp --disable-libmudflap --disable-libquadmath --without-ppl --disable-libada --disable-multilib || exit -1

make -j 4 || exit -1
make install || exit -1

sleep 2

cd ../../../scripts
sh 5_glibc-2.34.sh

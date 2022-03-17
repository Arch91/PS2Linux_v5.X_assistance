#!/bin/bash
# Simple brutal sh-scripts chain.
if [ "$(echo $PATH | grep -o /usr/local/ps2/bin)" != "/usr/local/ps2/bin" ]
then
 echo -en "\033[36;1m There is no "/usr/local/ps2/bin" was added to \$PATH . Adding... \033[0m\n"
 export PATH=/usr/local/ps2/bin:$PATH
fi

cd ../building/gcc-9.2.0/build
make distclean
cd ..
rm -rf build && mkdir build && cd build

# To build the newest glibc, it is needed to have the compiler with libatomic,
# libstdc++.
# FPU is not optimized for nextgen PS2Linux yet. For testing purposes only, you have been warned.
# Difference in flags - --with-float=hard, --with-fpu=single and --disable-libsanitizer (some unresolved issue with libsanitizer, hardfp and single-float targets)
../configure --prefix=/usr/local/ps2 --target=mipsr5900el-unknown-linux-gnu --enable-languages=c,c++ --includedir=/usr/local/ps2/mipsr5900el-unknown-linux-gnu/include --enable-libatomic --with-llsc=yes --with-float=hard --with-fpu=single --disable-libsanitizer --disable-multilib || exit -1

make -j 4 || exit -1
make install || exit -1

sleep 2

cd ../../../scripts
sh 5_glibc-2.32.sh

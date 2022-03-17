#!/bin/bash
# Simple brutal sh-scripts chain.
# Rebuild gcc-9.2.0, now it will be based on glibc-2.32.
if [ "$(echo $PATH | grep -o /usr/local/ps2/bin)" != "/usr/local/ps2/bin" ]
then
 echo -en "\033[36;1m There is no "/usr/local/ps2/bin" was added to \$PATH . Adding... \033[0m\n"
 export PATH=/usr/local/ps2/bin:$PATH
fi

cd ../building/gcc-9.2.0/build
make distclean
cd ..
rm -rf build && mkdir build && cd build

# Clean the cross-compiler from the gcc libraries and headers installed which
# are based on glibc-2.13.
rm -rf /usr/local/ps2/bin/mipsr5900el-unknown-linux-gnu-{c++,cpp,g++,gcc,gcc-9.2.0,gcc-ar,gcc-nm,gcc-ranlib,gcov,gcov-dump,gcov-tool}
rm -rf /usr/local/ps2/lib/{gcc,libcc1*}
rm -rf /usr/local/ps2/libexec/gcc
rm -rf /usr/local/ps2/share/gcc-9.2.0
rm -rf /usr/local/ps2/mipsr5900el-unknown-linux-gnu/include/c++
rm -rf /usr/local/ps2/mipsr5900el-unknown-linux-gnu/lib/{libasan*,libatomic*,libgcc_s.*,libgomp*,libsanitizer.spec,libssp*,libstdc*,libsupc*,libubsan*}

# FPU is not optimized for nextgen PS2Linux yet. For testing purposes only, you have been warned.
# Difference in flags - --with-float=hard, --with-fpu=single and --disable-libsanitizer (some unresolved issue with libsanitizer, hardfp and single-float targets)
../configure --prefix=/usr/local/ps2 --target=mipsr5900el-unknown-linux-gnu --enable-languages=c,c++ --includedir=/usr/local/ps2/mipsr5900el-unknown-linux-gnu/include --enable-libatomic --with-llsc=yes --with-float=hard --with-fpu=single --disable-libsanitizer --disable-multilib || exit -1

make -j 4 || exit -1
make install || exit -1

sleep 2

# By default the gcc's limits.h file is not properly configured. After the
# next commands, #include_next <limits.h> will be presented in the bottom which
# eventually will be picking up the right header.
cd ..
GCC_DIR=$(pwd)
cat gcc/limitx.h gcc/glimits.h gcc/limity.h > /usr/local/ps2/lib/gcc/mipsr5900el-unknown-linux-gnu/9.2.0/include-fixed/limits.h
cd /usr/local/ps2/lib/gcc/mipsr5900el-unknown-linux-gnu/9.2.0/include-fixed/
sed '1s/1992/1991/; 36,57d' limits.h > limits_fixed.h
rm -f limits.h
mv limits_fixed.h limits.h

cd $GCC_DIR/../../scripts
sh 7_busybox.sh

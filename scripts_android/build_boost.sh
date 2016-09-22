#!/bin/bash
set -e

if [ -z "$NDK_ROOT" ] && [ "$#" -eq 0 ]; then
    echo 'Either $NDK_ROOT should be set or provided as argument'
    echo "e.g., 'export NDK_ROOT=/path/to/ndk' or"
    echo "      '${0} /path/to/ndk'"
    exit 1
else
    NDK_ROOT="${1:-${NDK_ROOT}}"
fi

#ANDROID_ABI=${ANDROID_ABI:-"armeabi-v7a with NEON"}
WD=$(readlink -f "`dirname $0`/..")
BOOST_ROOT=${WD}/3rdparty/boost
BUILD_DIR=${BOOST_ROOT}/build
INSTALL_DIR=${WD}/android
N_JOBS=${N_JOBS:-1}

if [ $2 = "all" ]; then
architectureList=(armeabi armeabi-v7a arm64-v8a mips mips64 x86 x86_64)
else
architectureList=("$@")
fi

GCC_VERSION=4.9
OS_VERSION=linux-x86_64
 
for architecture in ${architectureList[@]}; do 
    echo ${architecture}
	ANDROID_ABI=${architecture}
    case ${architecture} in
        "armeabi")
            target="ARMV5"
            arch="arch-arm"
            CCFolder="arm-linux-androideabi-${GCC_VERSION}" 
            CC="arm-linux-androideabi-gcc"
            ;;
        "armeabi-v7a")
            target="ARMV7"
            arch="arch-arm"
            CCFolder="arm-linux-androideabi-${GCC_VERSION}"  
            CC="arm-linux-androideabi-gcc"
            ;;
        "arm64-v8a")
            target="ARMV8 BINARY=64"
            arch="arch-arm64"
            CCFolder="aarch64-linux-android-${GCC_VERSION}"
            CC="aarch64-linux-android-gcc" 
            ;;
        "mips")
            target="P5600 AR=mipsel-linux-android-ar "
            arch="arch-mips"
            CCFolder="mipsel-linux-android-${GCC_VERSION}"
            CC="mipsel-linux-android-gcc" ;;
        "mips64")
            target="SICORTEX BINARY=64"
            arch="arch-mips64"
            CCFolder="mips64el-linux-android-${GCC_VERSION}"
            CC="mips64el-linux-android-gcc" ;;
        "x86")
            target="ATOM"
            arch="arch-x86"
            CCFolder="x86-${GCC_VERSION}"
            CC="i686-linux-android-gcc" 
             ;;
        "x86_64")
            target="ATOM BINARY=64"
            arch="arch-x86_64"
            CCFolder="x86_64-${GCC_VERSION}"
            CC="x86_64-linux-android-gcc" ;;
        *) 
          echo "UNKNOWN"
          continue
          ;;
    esac


rm -rf "${BUILD_DIR}"
mkdir -p "${BUILD_DIR}"
cd "${BUILD_DIR}"

cmake -DCMAKE_TOOLCHAIN_FILE="${WD}/android-cmake/android.toolchain.cmake" \
      -DANDROID_NDK="${NDK_ROOT}" \
      -DCMAKE_BUILD_TYPE=Release \
      -DANDROID_ABI="${ANDROID_ABI}" \
      -DANDROID_NATIVE_API_LEVEL=21 \
      -DCMAKE_INSTALL_PREFIX="${INSTALL_DIR}/boost/${ANDROID_ABI}" \
      ..

make -j${N_JOBS}
make install

rm -rf "${BUILD_DIR}"

done

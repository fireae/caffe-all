#!/bin/bash
set -e
# ANDROID_ABI "armeabi-v7a", "armeabi", "armeabi-v7a with NEON", "armeabi-v7a-hard-softfp with NEON", "armeabi-v7a-hard with NEON", "aarmeabi-v7a with VFPV3", "armeabi-v6 with VFP", "arm64-v8a", "mips", "mips64", "x86", "x86_64"

if [ -z "$NDK_ROOT" ] && [ "$#" -eq 0 ]; then
    echo 'Either $NDK_ROOT should be set or provided as argument'
    echo "e.g., 'export NDK_ROOT=/path/to/ndk' or"
    echo "      '${0} /path/to/ndk'"
    exit 1
else
    NDK_ROOT="${1:-${NDK_ROOT}}"
fi

APP_ABI="android-21"
API_LEVEL=21 
#NDK_ROOT=/home/wencc/Apps/android-ndk-r11b #$(locate ndk-bundle | head -1)
echo "NDK_ROOT=$NDK_ROOT"

PROJ_NAME=opencv
BUILD_TYPE=android
ROOT_DIR=$(readlink -f "`dirname $0`/..")
OPENCV_ROOT=${ROOT_DIR}/3rdparty/${PROJ_NAME}
BUILD_DIR=${OPENCV_ROOT}/build
INSTALL_DIR=${ROOT_DIR}/${BUILD_TYPE}/${PROJ_NAME}
echo ${INSTALL_DIR}

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
echo ${BUILD_DIR}
cd "${BUILD_DIR}"

cmake -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON \
      -DCMAKE_TOOLCHAIN_FILE="${ROOT_DIR}/android-cmake/android.toolchain.cmake" \
      -DANDROID_NDK="${NDK_ROOT}" \
      -DANDROID_NATIVE_API_LEVEL=${API_LEVEL} \
      -DANDROID_ABI="${ANDROID_ABI}" \
      -D WITH_CUDA=OFF \
      -D WITH_MATLAB=OFF \
      -D BUILD_ANDROID_EXAMPLES=OFF \
      -D BUILD_DOCS=OFF \
      -D BUILD_PERF_TESTS=OFF \
      -D BUILD_TESTS=OFF \
      -DCMAKE_INSTALL_PREFIX="${INSTALL_DIR}" \
      ..

N_JOBS=1
make -j${N_JOBS}
make install

rm -rf "${BUILD_DIR}"

done


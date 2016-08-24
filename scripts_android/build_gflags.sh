#!/usr/bin/env bash  
set -e

if [ -z "$NDK_ROOT" ] && [ "$#" -eq 0 ]; then
  echo 'Either $NDK_ROOT should be set or provided'
  exit 1
else
  NDK_ROOT="${1:-${NDK_ROOT}}"
fi

echo ${NDK_ROOT}

ANDROID_ABI=${ANDROID_ABI:-"armeabi-v7a with NEON"}
ANDROID_NATIVE_API_LEVEL=${ANDROID_NATIVE_API_LEVEL:-21}
INSTALL_TYPE=${INSTALL_TYPE:-"android"}

PROJ_NAME=gflags
ROOT_DIR=$(readlink -f "`dirname $0`"/..)
PROJECT_ROOT=${ROOT_DIR}/3rdparty/${PROJ_NAME}
BUILD_DIR=${PROJECT_ROOT}/build
INSTALL_DIR=${ROOT_DIR}/${INSTALL_TYPE}

TOOL_CHAIN_DIR=${ROOT_DIR}
TOOL_CHAIN_FILE="${ROOT_DIR}/android-cmake/android.toolchain.cmake"

rm -rf "${BUILD_DIR}"
mkdir -p "${BUILD_DIR}"
cd ${BUILD_DIR}
pwd

cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="${INSTALL_DIR}/${PROJ_NAME}" -DCMAKE_TOOLCHAIN_FILE="${TOOL_CHAIN_FILE}" -DANROID_NDK=${NDK_ROOT} -DANDROID_ABI=${ANDROID_ABI} -DANDROID_NATIVE_API_LEVEL=${ANDROID_NATIVE_API_LEVEL} ..

# compile params

N_JOBS=1
MAKE=make
pwd
$MAKE -j${N_JOBS}
rm -rf "${INSTALL_DIR}/${PROJ_NAME}"
$MAKE install

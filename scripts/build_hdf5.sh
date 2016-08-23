#!/usr/bin/env bash
set -e

PROJ_NAME=hdf5
INSTALL_TYPE=release
ROOT_DIR=$(readlink -f "`dirname $0`"/..)
PROJECT_ROOT=${ROOT_DIR}/3rdparty/${PROJ_NAME}
BUILD_DIR=${PROJECT_ROOT}/build
INSTALL_DIR=${ROOT_DIR}/${INSTALL_TYPE}

rm -rf "${BUILD_DIR}"
mkdir -p "${BUILD_DIR}"
cd ${BUILD_DIR}

../autogen.sh

cmake -DCMAKE_BUILD_TYPE=Release \
      -DBUILD_STATIC_EXECS=OFF \
      -DBUILD_TESTING=OFF \
      -DHDF5_BUILD_EXAMPLES=OFF \
      -DHDF5_BUILD_HL_LIB=OFF \
      -DHDF5_BUILD_TOOLS=OFF \
      -DCMAKE_INSTALL_PREFIX="${INSTALL_DIR}/${PROJ_NAME}" \
      ..

# compile params
TOOL_CHAIN_DIR=/usr/bin
N_JOBS=1
MAKE=${TOOL_CHAIN_DIR}/make
pwd
$MAKE -j${N_JOBS}
rm -rf "${INSTALL_DIR}/${PROJ_NAME}"
$MAKE install/strip

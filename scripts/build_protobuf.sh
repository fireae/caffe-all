#!/usr/bin/env bash
set -e

PROJ_NAME=protobuf
INSTALL_TYPE=release
ROOT_DIR=$(readlink -f "`dirname $0`"/..)
PROJECT_ROOT=${ROOT_DIR}/3rdparty/${PROJ_NAME}
BUILD_DIR=${PROJECT_ROOT}/build
INSTALL_DIR=${ROOT_DIR}/${INSTALL_TYPE}/${PROJ_NAME}

rm -rf "${BUILD_DIR}"
mkdir -p "${BUILD_DIR}"
cd ${BUILD_DIR}

cmake -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_PREFIX="${INSTALL_DIR}" \
      -DCMAKE_CXX_FLAGS="-fPIC" \
      -Dprotobuf_BUILD_TESTS=OFF \
      ../cmake

# compile params
N_JOBS=1
pwd
make -j${N_JOBS}
rm -rf "${INSTALL_DIR}"
make install

#!/usr/bin/env bash
set -e

PROJ_NAME=OpenBLAS
INSTALL_TYPE=release
ROOT_DIR=$(readlink -f "`dirname $0`"/..)
PROJECT_ROOT=${ROOT_DIR}/3rdparty/${PROJ_NAME}
BUILD_DIR=${PROJECT_ROOT}/build
INSTALL_DIR=${ROOT_DIR}/${INSTALL_TYPE}/${PROJ_NAME}
cd ${PROJECT_ROOT}

# compile params
N_JOBS=1
pwd
make -j${N_JOBS} BINARY=64
rm -rf "${INSTALL_DIR}"
make PREFIX="${INSTALL_DIR}" install

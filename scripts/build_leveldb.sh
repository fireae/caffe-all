#!/usr/bin/env bash
set -e

PROJ_NAME=leveldb
INSTALL_TYPE=release
ROOT_DIR=$(readlink -f "`dirname $0`"/..)
PROJECT_ROOT=${ROOT_DIR}/3rdparty/${PROJ_NAME}
BUILD_DIR=${PROJECT_ROOT}/build
INSTALL_DIR=${ROOT_DIR}/${INSTALL_TYPE}/${PROJ_NAME}

cd ${PROJECT_ROOT}
# compile params
N_JOBS=1
make -j${N_JOBS}
rm -rf "${INSTALL_DIR}/${PROJ_NAME}"
mkdir -p "${INSTALL_DIR}"/lib
cp out-shared/lib* "${INSTALL_DIR}"/lib
cp -r include "${INSTALL_DIR}"

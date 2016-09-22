#!/usr/bin/env bash
set -e

PROJ_NAME=snappy
INSTALL_TYPE=release
ROOT_DIR=$(readlink -f "`dirname $0`"/..)
PROJECT_ROOT=${ROOT_DIR}/3rdparty/${PROJ_NAME}
BUILD_DIR=${PROJECT_ROOT}/build
INSTALL_DIR=${ROOT_DIR}/${INSTALL_TYPE}/${PROJ_NAME}

cd ${PROJECT_ROOT}

./autogen.sh
./configure --prefix=${INSTALL_DIR}

# compile params
N_JOBS=1
pwd
make -j${N_JOBS}
rm -rf "${INSTALL_DIR}"
make install

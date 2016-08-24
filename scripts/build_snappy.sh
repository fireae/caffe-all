#!/usr/bin/env bash
set -e

PROJ_NAME=snappy
INSTALL_TYPE=release
ROOT_DIR=$(readlink -f "`dirname $0`"/..)
PROJECT_ROOT=${ROOT_DIR}/3rdparty/${PROJ_NAME}
BUILD_DIR=${PROJECT_ROOT}/build
INSTALL_DIR=${ROOT_DIR}/${INSTALL_TYPE}

cd ${PROJECT_ROOT}

./autogen.sh
./configure --prefix=${INSTALL_DIR}

# compile params
TOOL_CHAIN_DIR=/usr/bin
N_JOBS=1
MAKE=${TOOL_CHAIN_DIR}/make
pwd
$MAKE -j${N_JOBS}
rm -rf "${INSTALL_DIR}/${PROJ_NAME}"
$MAKE install

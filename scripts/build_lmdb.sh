#!/usr/bin/env bash
set -e

PROJ_NAME=lmdb
INSTALL_TYPE=release
ROOT_DIR=$(readlink -f "`dirname $0`"/..)
PROJECT_ROOT=${ROOT_DIR}/3rdparty/${PROJ_NAME}/libraries/liblmdb
BUILD_DIR=${PROJECT_ROOT}/build
INSTALL_DIR=${ROOT_DIR}/${INSTALL_TYPE}/${PROJ_NAME}

cd ${PROJECT_ROOT}

# compile params
N_JOBS=1

make clean
make -j${N_JOBS} XCFLAGS="-DMDB_DSYNC=O_SYNC -DMDB_USE_ROBUST=0"

make prefix="$INSTALL_DIR" install


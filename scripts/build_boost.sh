#!/usr/bin/env bash
set -e

PROJ_NAME=boost
INSTALL_TYPE=release
ROOT_DIR=$(readlink -f "`dirname $0`"/..)
PROJECT_ROOT=${ROOT_DIR}/3rdparty/${PROJ_NAME}
BUILD_DIR=${PROJECT_ROOT}/build
INSTALL_DIR=${ROOT_DIR}/${INSTALL_TYPE}

mkdir -p "${ROOT_DIR}/3rdparty/${PROJ_NAME}/include"

MODULES=`ls ${ROOT_DIR}/3rdparty/${PROJ_NAME}/libs`
for MODULE in ${MODULES}; do
  if [ -d $MODULE ]; then
    cp -r "${ROOT_DIR}/3rdparty/${PROJ_NAME}/libs/${MODULE}/include/boost" "${ROOT_DIR}/3rdparty/${PROJ_NAME}/include"
  fi
done

rm -rf "${BUILD_DIR}"
mkdir -p "${BUILD_DIR}"
cd ${BUILD_DIR}
pwd

cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="${INSTALL_DIR}/${PROJ_NAME}" ..

# compile params
TOOL_CHAIN_DIR=/usr/bin
N_JOBS=1
MAKE=${TOOL_CHAIN_DIR}/make
pwd
$MAKE -j${N_JOBS}
rm -rf "${INSTALL_DIR}/${PROJ_NAME}"
$MAKE install

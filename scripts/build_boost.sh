#!/usr/bin/env bash
set -e

PROJ_NAME=boost
INSTALL_TYPE=release
ROOT_DIR=$(readlink -f "`dirname $0`"/..)
PROJECT_ROOT=${ROOT_DIR}/3rdparty/${PROJ_NAME}
BUILD_DIR=${PROJECT_ROOT}/build
INSTALL_DIR=${ROOT_DIR}/${INSTALL_TYPE}/${PROJ_NAME}

mkdir -p "${ROOT_DIR}/3rdparty/${PROJ_NAME}/include"

MODULES=`ls ${ROOT_DIR}/3rdparty/${PROJ_NAME}/libs`
for MODULE in ${MODULES}; do
  if [ -d "${ROOT_DIR}/3rdparty/${PROJ_NAME}/libs/${MODULE}" ]; then
    echo ${MODULE}
    NUMERIC=numeric
    if [ "${MODULE}" = "${NUMERIC}" ]; then 
      cp -r "${ROOT_DIR}/3rdparty/${PROJ_NAME}/libs/${MODULE}/conversion/include/boost" "${ROOT_DIR}/3rdparty/${PROJ_NAME}/include"
      cp -r "${ROOT_DIR}/3rdparty/${PROJ_NAME}/libs/${MODULE}/interval/include/boost" "${ROOT_DIR}/3rdparty/${PROJ_NAME}/include"
      cp -r "${ROOT_DIR}/3rdparty/${PROJ_NAME}/libs/${MODULE}/odeint/include/boost" "${ROOT_DIR}/3rdparty/${PROJ_NAME}/include"
      cp -r "${ROOT_DIR}/3rdparty/${PROJ_NAME}/libs/${MODULE}/ublas/include/boost" "${ROOT_DIR}/3rdparty/${PROJ_NAME}/include"
    else    
      cp -r "${ROOT_DIR}/3rdparty/${PROJ_NAME}/libs/${MODULE}/include/boost" "${ROOT_DIR}/3rdparty/${PROJ_NAME}/include"
    fi
  fi
done

rm -rf "${BUILD_DIR}"
mkdir -p "${BUILD_DIR}"
cd ${BUILD_DIR}

cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="${INSTALL_DIR}" -DCMAKE_CXX_FLAGS="-fPIC" ..

# compile params
N_JOBS=1
pwd
make -j${N_JOBS}
rm -rf "${INSTALL_DIR}"
make install

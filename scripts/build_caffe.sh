#!/usr/bin/env bash
set -e

PROJ_NAME=caffe
INSTALL_TYPE=release
ROOT_DIR=$(readlink -f "`dirname $0`"/..)
PROJECT_ROOT=${ROOT_DIR}/${PROJ_NAME}
BUILD_DIR=${PROJECT_ROOT}/build
INSTALL_DIR=${ROOT_DIR}/${INSTALL_TYPE}/${PROJ_NAME}


USE_OPENBLAS=${USE_OPENBLAS:-1}
if [ ${USE_OPENBLAS} -eq 1 ]; then
    BLAS=open
    export OpenBLAS_HOME="${INSTALL_DIR}"
else
    BLAS=eigen
    export EIGEN_HOME="${INSTALL_DIR}/eigen3"
fi

rm -rf "${BUILD_DIR}"
mkdir -p "${BUILD_DIR}"
cd ${BUILD_DIR}
# set ENV

export HDF5_ROOT=${INSTALL_DIR}
export OpenCV_DIR=${INSTALL_DIR}/share/OpenCV
export LMDB_DIR=${INSTALL_DIR}
cmake -DCMAKE_BUILD_TYPE=Release \
      -DADDITIONAL_FIND_PATH="${INSTALL_DIR}" \
      -DBUILD_python=OFF \
      -DBUILD_docs=OFF \
      -DCPU_ONLY=ON \
      -DUSE_LMDB=ON \
      -DUSE_LEVELDB=OFF \
      -DUSE_HDF5=OFF \
      -DBLAS=${BLAS} \
      -DBOOST_ROOT="${INSTALL_DIR}/boost" \
      -DOpenCV_DIR="${INSTALL_DIR}/opencv" \
      -DPROTOBUF_PROTOC_EXECUTABLE="${INSTALL_DIR}/protobuf/bin/protoc" \
      -DPROTOBUF_INCLUDE_DIR="${INSTALL_DIR}/protobuf/include" \
      -DPROTOBUF_LIBRARY="${INSTALL_DIR}/protobuf/lib/libprotobuf.a" \
      -DCMAKE_INSTALL_PREFIX="${INSTALL_DIR}/caffe" \
      ..

# compile params
N_JOBS=1
pwd
make -j${N_JOBS}
rm -rf "${INSTALL_DIR}/${PROJ_NAME}"
make install

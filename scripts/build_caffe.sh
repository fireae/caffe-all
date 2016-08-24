#!/usr/bin/env bash
set -e

PROJ_NAME=caffe
INSTALL_TYPE=release
ROOT_DIR=$(readlink -f "`dirname $0`"/..)
PROJECT_ROOT=${ROOT_DIR}/${PROJ_NAME}
BUILD_DIR=${PROJECT_ROOT}/build
INSTALL_DIR=${ROOT_DIR}/${INSTALL_TYPE}


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
      -DUSE_HDF5=ON \
      -DBLAS=${BLAS} \
      -DBOOST_ROOT="${INSTALL_DIR}" \
      -DGFLAGS_INCLUDE_DIR="${INSTALL_DIR}/include" \
      -DGFLAGS_LIBRARY="${INSTALL_DIR}/lib/libgflags.a" \
      -DGLOG_INCLUDE_DIR="${INSTALL_DIR}/include" \
      -DGLOG_LIBRARY="${INSTALL_DIR}/lib/libglog.a" \
      -DOpenCV_DIR="${INSTALL_DIR}" \
      -DPROTOBUF_PROTOC_EXECUTABLE="${INSTALL_DIR}/protobuf_host/bin/protoc" \
      -DPROTOBUF_INCLUDE_DIR="${INSTALL_DIR}/include" \
      -DPROTOBUF_LIBRARY="${INSTALL_DIR}/lib/libprotobuf.a" \
      -DHDF5_INCLUDE_DIRS="${INSTALL_DIR}/include" \
      -DHDF5_LIBRARIES="${INSTALL_DIR}/lib/libhdf5.so" \
      -DHDF5_HL_INCLUDE_DIR="${INSTALL_DIR}/include" \
      -DHDF5_HL_LIBRARIES="${INSTALL_DIR}/lib/libhdf5_cpp.so" \
      -DCMAKE_INSTALL_PREFIX="${INSTALL_DIR}" \
      ..

# compile params
TOOL_CHAIN_DIR=/usr/bin
N_JOBS=1
MAKE=${TOOL_CHAIN_DIR}/make
pwd
$MAKE -j${N_JOBS}
rm -rf "${INSTALL_DIR}/${PROJ_NAME}"
$MAKE install

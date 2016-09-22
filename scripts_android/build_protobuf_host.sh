#!/usr/bin/env sh
set -e

WD=$(readlink -f "`dirname $0`/..")
PROTOBUF_ROOT=${WD}/3rdparty/protobuf
BUILD_DIR=${PROTOBUF_ROOT}/build_host
INSTALL_DIR=${WD}/android
N_JOBS=${N_JOBS:-1}

if [ -f "${INSTALL_DIR}/protobuf_host/bin/protoc" ]; then
    echo "Found host protoc"
    exit 0
fi

rm -rf "${BUILD_DIR}"
mkdir -p "${BUILD_DIR}"
cd "${BUILD_DIR}"

cmake -DCMAKE_INSTALL_PREFIX="${INSTALL_DIR}/protobuf_host" \
      -Dprotobuf_BUILD_TESTS=OFF \
      ../cmake

make -j${N_JOBS}
rm -rf "${INSTALL_DIR}/protobuf_host"
make install/strip

cd "${WD}"
rm -rf "${BUILD_DIR}"

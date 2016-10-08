#!/usr/bin/env bash
set -e

ROOT_DIR=$(readlink -f "`dirname $0`"/..)
cd ${ROOT_DIR}/scripts

# optional
#./build_eigen.sh
#./build_gflags.sh
#./build_glog.sh
#./build_hdf5.sh
#./build_snappy.sh
#./build_leveldb.sh

# required 
./build_boost.sh
./build_lmdb.sh
./build_openblas.sh
./build_protobuf.sh
./build_opencv.sh
#./build_protobuf_host.sh
./build_caffe.sh

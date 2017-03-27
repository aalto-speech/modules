#!/bin/bash -e

source ../common/common.sh

PROFILE=${1:-triton}

source profiles/${PROFILE}

NAME=variKN
GIT_REPO=git@github.com:vsiivola/variKN

init_vars


checkout_git

DESC="variKN"
HELP="A toolkit for producing n-gram language models with Kneser-Ney growing and revised Kneser pruning methods"

mkdir -p "${BUILD_DIR}/build"
pushd "${BUILD_DIR}/build"

CXX=g++ CC=gcc cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR} -DPYTHON2=ON ..
make install

popd

BIN_PATH=${INSTALL_DIR}/bin
LIB_PATH=${INSTALL_DIR}/lib
EXTRA_LINES="append-path     PYTHONPATH ${LIB_PATH}/site-packages"

write_module


rm -rf "${BUILD_DIR}"

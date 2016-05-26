#!/bin/bash -e

source ../common/common.sh

NAME=variKN
GIT_REPO=git@github.com:/vsiivola/variKN

init_vars

module load GCC
module load CMake

checkout_git

DESC="variKN"
HELP="A toolkit for producing n-gram language models with Kneser-Ney growing and revised Kneser pruning methods"

mkdir -p "${BUILD_DIR}/build"
pushd "${BUILD_DIR}/build"

cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR} ..
make install

# This isn't copied automatically.
mv "${BUILD_DIR}/build/bin" "${INSTALL_DIR}/"

popd

BIN_PATH="${INSTALL_DIR}/bin"
LIB_PATH="${INSTALL_DIR}/lib"

EXTRA_LINES="module add      GCC"

write_module

rm -rf "${BUILD_DIR}"

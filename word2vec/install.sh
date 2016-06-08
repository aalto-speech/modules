#!/bin/bash -e

source ../common/common.sh

NAME=word2vec
GIT_REPO=git@github.com:dav/word2vec.git

init_vars

module load GCC

checkout_git

DESC="word2vec"
HELP="Implementation of the continuous bag-of-words and skip-gram architectures for computing vector representations of words."

pushd "${BUILD_DIR}/src"
make
popd

mkdir -p "${INSTALL_DIR}"
mv "${BUILD_DIR}/bin" "${INSTALL_DIR}/"

BIN_PATH="${INSTALL_DIR}/bin"

EXTRA_LINES="module add      GCC"

write_module

rm -rf "${BUILD_DIR}"

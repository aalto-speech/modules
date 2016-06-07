#!/bin/bash -e

source ../common/common.sh

NAME=wang2vec
GIT_REPO=git@github.com:wlin12/wang2vec.git

init_vars

module load GCC

checkout_git

DESC="wang2vec - extension of word2vec"
HELP="Extension of the original word2vec using different architectures."

pushd "${BUILD_DIR}"
sed -i 's/ -march=native / /' makefile
make
popd
rm -rf "${INSTALL_DIR}"
mv "${BUILD_DIR}" "${INSTALL_DIR}"

BIN_PATH="${INSTALL_DIR}"
EXTRA_LINES="module add      GCC"
write_module

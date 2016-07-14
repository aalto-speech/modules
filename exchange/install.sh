#!/bin/bash -e

source ../common/common.sh

NAME=exchange
GIT_REPO=git@github.com:aalto-speech/exchange.git

init_vars

module load GCC

checkout_git

DESC="exchange word clustering"
HELP="An efficient C++ implementation of the exchange algorithm for a bigram model."

pushd "${BUILD_DIR}"
make exchange
popd
rm -rf "${INSTALL_DIR}"
mv "${BUILD_DIR}" "${INSTALL_DIR}"

BIN_PATH="${INSTALL_DIR}"
EXTRA_LINES="module add      GCC"
write_module

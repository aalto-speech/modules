#!/bin/bash -e

source ../common/common.sh

NAME=irstlm
GIT_REPO=git@github.com:irstlm-team/irstlm.git

init_vars
checkout_git

module purge
module load GCC

pushd "${BUILD_DIR}"
./regenerate-makefiles.sh
./configure --prefix="${INSTALL_DIR}"
touch scripts/qplsa.sh  # bug fix
make
make install
popd

DESC="IRSTLM Toolkit"
HELP="A tool for the estimation, representation, and computation of statistical language models."
BIN_PATH="${INSTALL_DIR}/bin"
EXTRA_LINES="module add      GCC"
write_module

rm -rf "${BUILD_DIR}"

#!/bin/bash -e

source ../common/common.sh

NAME=hfst
GIT_REPO=git@github.com:hfst/hfst.git

init_vars
checkout_git

module purge
module load GCC
module load Bison

BIN_PATH="${INSTALL_DIR}/bin"
LIB_PATH="${INSTALL_DIR}/lib"

pushd "${GIT_PATH}"
./autogen.sh
./configure --prefix="${INSTALL_DIR}"
make
mkdir -p "${BIN_PATH}"
mkdir -p "${LIB_PATH}"
make install
popd

DESC="Helsinki Finite-State Transducer Technology (HFST)"
HELP="The Helsinki Finite-State Transducer software is intended for the implementation of morphological analysers and other tools which are based on weighted and unweighted finite-state transducer technology."

write_module

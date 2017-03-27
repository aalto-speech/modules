#!/bin/bash

source ../common/common.sh

NAME=phonetisaurus
GIT_REPO=https://github.com/AdolfVonKleist/Phonetisaurus.git
GIT_BRANCH=openfst-1.6.1

PROFILE=${1:-triton}

source profiles/${PROFILE}

init_vars
checkout_git

BIN_PATH=${INSTALL_DIR}/bin
LIB_PATH=${INSTALL_DIR}/lib

mkdir -p ${BIN_PATH} ${LIB_PATH}

pushd ${BUILD_DIR}/src
patch -p2 < ${FILE_DIR}/makefile.diff
./configure  --with-openfst-libs=$FSTROOT/lib --with-openfst-includes=$FSTROOT/include --with-install-bin=${BIN_PATH} --with-install-lib=${LIB_PATH} LDFLAGS="${LDFLAGS}"


make all phonetisaurus-binding || error_exit "compilation failed"
make install || error_exit "installation failed"


DESC="phonetisaurus"
HELP="phonetisaurus ${VERSION}"

write_module

popd

rm -Rf ${BUILD_DIR}

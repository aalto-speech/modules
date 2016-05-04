#!/bin/bash

source ../common/common.sh

NAME=AaltoASR
GIT_REPO=https://github.com/aalto-speech/AaltoASR.git
GIT_BRANCH=develop

init_vars

module load gcc
module load cmake

checkout_git

mkdir ${BUILD_DIR}/build
pushd ${BUILD_DIR}/build

cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR} ..
make install

popd

BIN_PATH=${INSTALL_DIR}/bin
LIB_PATH=${INSTALL_DIR}/lib


read -d '' EXTRA_LINES << EOF
module load prgenv
append-path     PYTHONPATH ${LIB_PATH}/site-packages
append-path     PERL5LIB ${GIT_PATH}/aku/scripts
setenv          AALTOASR ${INSTALL_DIR}
EOF

write_module

rm -Rf ${BUILD_DIR}

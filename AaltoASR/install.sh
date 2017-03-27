#!/bin/bash

source ../common/common.sh

NAME=AaltoASR
GIT_REPO=https://github.com/aalto-speech/AaltoASR.git
GIT_BRANCH=develop

init_vars

module load GCC
module load CMake

checkout_git

mkdir ${BUILD_DIR}/build
pushd ${BUILD_DIR}/build

cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR} -DCMAKE_CXX_FLAGS="-Wl,-rpath,${EBROOTGCC}/lib64" ..
make install

popd

BIN_PATH=${INSTALL_DIR}/bin
LIB_PATH=${INSTALL_DIR}/lib


read -d '' EXTRA_LINES << EOF
append-path     PYTHONPATH ${LIB_PATH}/site-packages
append-path     PERL5LIB ${GIT_PATH}/aku/scripts
append-path     PATH ${GIT_PATH}/pyrectool
setenv          AALTOASR ${INSTALL_DIR}
EOF

write_module

rm -Rf ${BUILD_DIR}

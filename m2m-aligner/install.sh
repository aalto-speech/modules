#!/bin/bash

source ../common/common.sh

NAME=m2m-aligner
GIT_REPO=git@github.com:letter-to-phoneme/m2m-aligner.git

module purge
module load GCC
module list

init_vars
checkout_git

BIN_PATH=${INSTALL_DIR}/bin

mkdir -p ${BIN_PATH}

pushd ${BUILD_DIR}

LIBS="-Wl,-rpath,${EBROOTGCC}/lib64" make || error_exit "Compilation failed"
cp m2m-aligner ${BIN_PATH}


DESC="m2m-aligner"
HELP="m2m-aligner ${VERSION}"

write_module

popd

rm -Rf ${BUILD_DIR}

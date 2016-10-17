#!/bin/bash

source ../common/common.sh

NAME=pocolm
GIT_REPO=git@github.com:danpovey/pocolm.git

module purge
module load GCC
module list

init_vars
checkout_git

BIN_PATH=${BUILD_DIR}/scripts

mkdir -p ${BIN_PATH}

pushd ${BUILD_DIR}/src

LDFLAGS="-Wl,-rpath,${EBROOTGCC}/lib64" make || error_exit "Compilation failed"
#cp m2m-aligner ${BIN_PATH}


DESC="pocolm"
HELP="pocolm ${VERSION}"

write_module

popd


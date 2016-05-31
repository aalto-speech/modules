#!/bin/bash

source ../common/common.sh

NAME=phonetisaurus
GIT_REPO=https://github.com/AdolfVonKleist/Phonetisaurus.git

module purge
module load GCC/4.9.3-2.25
module load openfst
module list

init_vars
checkout_git

BIN_PATH=${INSTALL_DIR}/bin

mkdir -p ${BIN_PATH}

pushd ${BUILD_DIR}/src
patch -p2 < ${FILE_DIR}/makefile.diff
./configure  --with-openfst-libs=$FSTROOT/lib --with-openfst-includes=$FSTROOT/include --with-install-bin=${BIN_PATH} LDFLAGS="-Wl,-rpath,/share/apps/easybuild/software/GCCcore/4.9.3/lib64"


make || error_exit "compilation failed"
make install || error_exit "installation failed"


DESC="phonetisaurus"
HELP="phonetisaurus ${VERSION}"

write_module

popd

rm -Rf ${BUILD_DIR}

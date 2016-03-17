#!/bin/bash

source ../common/common.sh

NAME=phonetisaurus
GIT_REPO=https://github.com/AdolfVonKleist/Phonetisaurus.git

module load openfst

init_vars
checkout_git

BIN_PATH=${INSTALL_DIR}/bin

mkdir -p ${BIN_PATH}

pushd ${BUILD_DIR}/src

./configure  --with-openfst-libs=$FSTROOT/lib --with-openfst-includes=$FSTROOT/include --with-install-bin=${BIN_PATH}

sed -i "s/^GIT_REVISION/#GIT_REVISION/" Makefile
sed -i "1iGIT_REVISION := ${COMMIT}" Makefile

make || error_exit "compilation failed"
make install || error_exit "installation failed"


DESC="phonetisaurus"
HELP="phonetisaurus ${VERSION}"

EXTRA_LINES="module load openfst"

write_module

popd

rm -Rf ${BUILD_DIR}

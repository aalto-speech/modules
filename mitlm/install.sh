#!/bin/bash

source ../common/common.sh

VERSION=${1:-0.4.1}
NAME=mitlm

init_vars

if [ ! -f downloads/mitlm-${VERSION}.tar.gz ]; then
   error_exit "Please download mitlm-${VERSION}.tar.gz to the downloads folder"
fi

mkdir -p ${OPT_DIR}/${VERSION}-build
tar xzf downloads/mitlm-${VERSION}.tar.gz --strip-components=1 -C ${OPT_DIR}/${VERSION}-build

pushd ${OPT_DIR}/${VERSION}-build

./configure --prefix=${INSTALL_DIR}

make all || error_exit "compilation failed"
make install || error_exit "install failed"

BIN_PATH=${OPT_DIR}/${VERSION}/bin
LIB_PATH=${OPT_DIR}/${VERSION}/lib

DESC="mitlm"
HELP="mitlm ${VERSION}"

write_module

popd

rm -Rf ${OPT_DIR}/${VERSION}-build

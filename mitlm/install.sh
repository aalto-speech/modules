#!/bin/bash

source ../common/common.sh

VERSION=${1:-0.4.1}
NAME=mitlm

init_vars

module load gcc

if [ ! -f downloads/mitlm-${VERSION}.tar.gz ]; then
   error_exit "Please download mitlm-${VERSION}.tar.gz to the downloads folder"
fi

mkdir -p ${OPT_DIR}/${VERSION}-build
tar xzf downloads/mitlm-${VERSION}.tar.gz --strip-components=1 -C ${OPT_DIR}/${VERSION}-build

pushd ${OPT_DIR}/${VERSION}-build

./configure --prefix=${OPT_DIR}/${VERSION}

make all || error_exit "compilation failed"
make install || error_exit "install failed"

BIN_PATH=${OPT_DIR}/${VERSION}/bin
LIB_PATH=${OPT_DIR}/${VERSION}/lib

DESC="mitlm"
HELP="mitlm ${VERSION}"

EXTRA_LINES="module load prgenv"

write_module

popd

rm -Rf ${OPT_DIR}/${VERSION}-build

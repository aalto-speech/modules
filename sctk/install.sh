#!/bin/bash

source ../common/common.sh

VERSION=${1:-2.4.10}
NAME=sctk

init_vars

if [ ! -f downloads/sctk-${VERSION}*.bz2 ]; then
   error_exit "Please download sctk-${VERSION}.xxxx.bz2 to the downloads folder"
fi

mkdir -p ${OPT_DIR}/${VERSION}-build
tar xjf downloads/sctk-${VERSION}*.bz2 --strip-components=1 -C ${OPT_DIR}/${VERSION}-build

pushd ${OPT_DIR}/${VERSION}-build

sed -i "s/^PREFIX/#PREFIX/" src/makefile
sed -i "1iPREFIX = ${OPT_DIR}/${VERSION}/" Makefile

make config || error_exit "config failed"
make all || error_exit "compilation failed"
#make check || error_exit "test failed"
make install || error_exit "install failed"
make doc || error_exit "doc failed"

BIN_PATH=${OPT_DIR}/${VERSION}/bin
LIB_PATH=${OPT_DIR}/${VERSION}/lib

DESC="SCTK"
HELP="sctk ${VERSION}"

write_module

popd

rm -Rf ${OPT_DIR}/${VERSION}-build
#!/bin/bash

source ../common/common.sh

VERSION=${1:-2.4.10}
NAME=sctk

init_vars

module load GCC

if [ ! -f downloads/sctk-${VERSION}*.bz2 ]; then
   error_exit "Please download sctk-${VERSION}.xxxx.bz2 to the downloads folder"
fi

mkdir -p ${OPT_DIR}/${VERSION}-build
fname=$(ls -1 downloads/sctk-${VERSION}*.bz2)
tar xjf $fname --strip-components=1 -C ${OPT_DIR}/${VERSION}-build

pushd ${OPT_DIR}/${VERSION}-build

sed -i "s#^PREFIX.*#PREFIX=${OPT_DIR}/${VERSION}#" src/makefile

make config || error_exit "config failed"
#sed -i "1iPREFIX = ${OPT_DIR}/${VERSION}/" Makefile
make all || error_exit "compilation failed"

BIN_PATH=${OPT_DIR}/${VERSION}/bin

mkdir -p $BIN_PATH
make install || error_exit "install failed"
make doc || error_exit "doc failed"

DESC="SCTK"
HELP="sctk ${VERSION}"

write_module

popd

rm -Rf ${OPT_DIR}/${VERSION}-build

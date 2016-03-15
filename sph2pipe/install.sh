#!/bin/bash

source ../common/common.sh

VERSION=${1:-2.5}
NAME=sph2pipe

init_vars

pushd ${OPT_DIR}

wget https://www.ldc.upenn.edu/sites/www.ldc.upenn.edu/files/ctools/sph2pipe_v${VERSION}.tar.gz || error_exit "Could not download this version"

tar -zxf sph2pipe_v${VERSION}.tar.gz
pushd sph2pipe_v${VERSION}

mkdir bin

gcc -o bin/sph2pipe *.c -lm

BIN_PATH=`pwd`/bin
LIB_PATH=

DESC="sph2pipe"
HELP="sph2pipe ${VERSION}"

write_module

popd
popd
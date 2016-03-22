#!/bin/bash

source ../common/common.sh

VERSION=${1:-14.4.2}
NAME=sox

init_vars

pushd ${OPT_DIR}

wget http://downloads.sourceforge.net/project/sox/sox/${VERSION}/sox-${VERSION}.tar.gz || error_exit "Could not download this version"

tar xf sox-${VERSION}.tar.gz

pushd sox-${VERSION}

./configure --prefix=${OPT_DIR}/${VERSION}
make -s
make install

BIN_PATH=${OPT_DIR}/${VERSION}/bin
LIB_PATH=${OPT_DIR}/${VERSION}/lib

DESC="SOX"
HELP="SOX ${VERSION}"

write_module

popd
rm -Rf sox-${VERSION}
popd

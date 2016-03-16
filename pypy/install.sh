#!/bin/bash

source ../common/common.sh

VERSION=${1:-5.0.0}
NAME=pypy

init_vars

pushd ${OPT_DIR}

wget https://bitbucket.org/pypy/pypy/downloads/pypy-${VERSION}-src.tar.bz2 || error_exit "Could not download this version"

mkdir -p ${OPT_DIR}/${VERSION}

tar xjf pypy-${VERSION}-src.tar.bz2 --strip-components 1 -C ${OPT_DIR}/${VERSION}
pushd ${OPT_DIR}/${VERSION}

rpython/bin/rpython -Ojit pypy/goal/targetpypystandalone.py



BIN_PATH=${OPT_DIR}/${VERSION}/bin
LIB_PATH=${OPT_DIR}/${VERSION}/lib

DESC="PyPy"
HELP="PyPy ${VERSION}"

write_module

popd
popd


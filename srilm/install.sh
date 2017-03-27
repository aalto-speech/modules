#!/bin/bash

source ../common/common.sh

VERSION=${1:-1.7.2}
NAME=srilm

init_vars

module load GCC/5.4.0-2.25

if [ ! -f downloads/srilm-${VERSION}.tar.gz ]; then
   error_exit "Please download srilm-${VERSION}.tar.gz to the downloads folder"
fi

mkdir -p ${OPT_DIR}/${VERSION}
tar xzvf downloads/srilm-${VERSION}.tar.gz -C ${OPT_DIR}/${VERSION}

pushd ${OPT_DIR}/${VERSION}

if [ -f $FILE_DIR/${VERSION}.patch ]; then
    patch -p1 < $FILE_DIR/${VERSION}.patch
fi

sed -i "1iSRILM = ${OPT_DIR}/${VERSION}/" Makefile

cp ${FILE_DIR}/Makefile.machine.i686-m64 common/
make World || error_exit "Compilation failed"
make test || error_exit "test failed"
make cleanest || error_exit "Cleaning failed"

BIN_PATH=`pwd`/bin:`pwd`/bin/i686-m64
LIB_PATH=`pwd`/lib

DESC="SRI Language model Toolkit"
HELP="SRILM ${VERSION}"

EXTRA_LINES="prepend-path MANPATH $(pwd)/man"

write_module

popd

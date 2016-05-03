#!/bin/bash

source ../common/common.sh

VERSION=${1:-6.1.0}
NAME=gcc

init_vars

pushd ${OPT_DIR}

rm -Rf gcc-${VERSION}* ${VERSION}

wget ftp://ftp.nluug.nl/mirror/languages/gcc/releases/gcc-${VERSION}/gcc-${VERSION}.tar.gz || error_exit "Could not download this version"

tar -zxf gcc-${VERSION}.tar.gz
mkdir gcc-${VERSION}-build
pushd gcc-${VERSION}-build
../gcc-${VERSION}/configure --prefix=${OPT_DIR}/${VERSION} --disable-multilib
make
make install

export LIB_PATH=${OPT_DIR}/${VERSION}/lib64

./create_prgenv.sh ${VERSION}

BIN_PATH=${OPT_DIR}/${VERSION}/bin
DESC="GCC compiler"
HELP="GCC ${VERSION}"

read -d '' EXTRA_LINES << EOF
module load prgenv

prepend-path CPATH ${OPT_DIR}/${VERSION}/include
prepend-path LIBRARY_PATH ${OPT_DIR}/${VERSION}/lib64
prepend-path MAN_PATH ${OPT_DIR}/${VERSION}/share/man
EOF

write_module

popd
rm -Rf gcc-${VERSION}*
popd

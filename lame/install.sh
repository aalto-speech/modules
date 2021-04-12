#!/bin/bash -e

source ../common/common.sh

VERSION="3.99.5"
MAJOR_VERSION="3.99"
NAME=lame

init_vars

module load GCC

pushd ${OPT_DIR}
wget "http://downloads.sourceforge.net/project/lame/lame/${MAJOR_VERSION}/lame-${VERSION}.tar.gz"
tar xf "lame-${VERSION}.tar.gz"

pushd "lame-${VERSION}"
./configure --prefix="${OPT_DIR}/${VERSION}"
make -s
make install

BIN_PATH="${OPT_DIR}/${VERSION}/bin"
LIB_PATH="${OPT_DIR}/${VERSION}/lib"

DESC="LAME"
HELP="LAME (Lame Aint an MP3 Encoder) ${VERSION}"

write_module

popd
rm -rf "lame-${VERSION}"
popd

#!/bin/bash

source ../common/common.sh

VERSION=${1:-1.2.2}
NAME=opengrm-ngram

module load openfst
module load gcc

init_vars

pushd ${OPT_DIR}

rm -Rf opengrm-ngram-${VERSION}*

wget http://www.openfst.org/twiki/pub/GRM/NGramDownload/opengrm-ngram-${VERSION}.tar.gz || error_exit "Could not download this version"

tar -zxf opengrm-ngram-${VERSION}.tar.gz
pushd opengrm-ngram-${VERSION}

./configure CPPFLAGS="-I${FST_ROOT}/include" LDFLAGS="-L${FST_ROOT}/lib -L${FST_ROOT}/lib/fst" --prefix=${OPT_DIR}/${VERSION}
make
make install

BIN_PATH=${OPT_DIR}/${VERSION}/bin
LIB_PATH=${OPT_DIR}/${VERSION}/lib

DESC="OpenGrm NGram"
HELP="OpenGrm NGram ${VERSION}"

EXTRA_LINES="module load prgenv
module load openfst"

write_module

popd

rm -Rf opengrm-ngram-${VERSION}*

popd



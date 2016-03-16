#!/bin/bash

source ../common/common.sh

VERSION=${1:-1.2.2}
NAME=opengrm-ngram

module load openfst

init_vars

pushd ${OPT_DIR}

rm -Rf opengrm-ngram-${VERSION}*

wget http://www.openfst.org/twiki/pub/GRM/NGramDownload/opengrm-ngram-${VERSION}.tar.gz || error_exit "Could not download this version"

tar -zxf opengrm-ngram-${VERSION}.tar.gz
pushd opengrm-ngram-${VERSION}

./configure CPPFLAGS="-I${FSTROOT}/include" LDFLAGS="-L${FSTROOT}/lib -L${FSTROOT}/lib/fst" --prefix=${OPT_DIR}/${VERSION}
make
make install

BIN_PATH=${OPT_DIR}/${VERSION}/bin
LIB_PATH=${OPT_DIR}/${VERSION}/lib

DESC="OpenGrm NGram"
HELP="OpenGrm NGram ${VERSION}"

write_module

popd

rm -Rf opengrm-ngram-${VERSION}*

popd



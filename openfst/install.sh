#!/bin/bash

source ../common/common.sh

VERSION=${1:-1.4.1}
NAME=openfst

init_vars

pushd ${OPT_DIR}

wget http://openfst.cs.nyu.edu/twiki/pub/FST/FstDownload/openfst-${VERSION}.tar.gz || error_exit "Could not download this version"
wget https://github.com/kaldi-asr/kaldi/raw/master/tools/extras/openfst-${VERSION}.patch || error_exit "Could not download kaldi patch"

tar -zxf openfst-${VERSION}.tar.gz
pushd openfst-${VERSION}/src/include/fst
patch -c -p0 -N < ../../../../openfst-${VERSION}.patch
popd
pushd  openfst-${VERSION}
./configure --prefix=`pwd` --enable-static --enable-shared --enable-far --enable-ngram-fsts --enable-lookahead-fsts --enable-const-fsts --enable-pdt --enable-linear-fsts LIBS="-ldl"
make install

BIN_PATH=`pwd`/bin
LIB_PATH=`pwd`/lib

DESC="OpenFST Toolkit"
HELP="OpenFST ${VERSION}"

EXTRA_LINES="FST_ROOT=$(pwd)"

write_module

popd
popd
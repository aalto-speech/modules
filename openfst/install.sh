#!/bin/bash
#SBATCH --mem-per-cpu 2G
#SBATCH -t 10:00:00

source ../common/common.sh

VERSION=${1:-1.4.1}
NAME=openfst

init_vars

module load gcc

pushd ${OPT_DIR}

rm -Rf openfst-${VERSION}* ${VERSION}

wget http://openfst.cs.nyu.edu/twiki/pub/FST/FstDownload/openfst-${VERSION}.tar.gz || error_exit "Could not download this version"
wget https://github.com/kaldi-asr/kaldi/raw/master/tools/extras/openfst-${VERSION}.patch || error_exit "Could not download kaldi patch"

tar -zxf openfst-${VERSION}.tar.gz
pushd openfst-${VERSION}/src/include/fst
patch -c -p0 -N < ../../../../openfst-${VERSION}.patch
popd
pushd  openfst-${VERSION}
./configure --prefix=${OPT_DIR}/${VERSION} --enable-static --enable-shared --enable-far --enable-ngram-fsts --enable-lookahead-fsts --enable-const-fsts --enable-pdt --enable-linear-fsts LIBS="-ldl"
make install

BIN_PATH=${OPT_DIR}/${VERSION}/bin
LIB_PATH=${OPT_DIR}/${VERSION}/lib

DESC="OpenFST Toolkit"
HELP="OpenFST ${VERSION}. This installation contains the kaldi patch for the minimization algorithm"

EXTRA_LINES="module load prgenv
setenv FST_ROOT ${OPT_DIR}/${VERSION}"

write_module

popd
rm -Rf openfst-${VERSION}*
popd

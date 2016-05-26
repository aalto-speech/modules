#!/bin/bash
#SBATCH --mem-per-cpu 2G
#SBATCH -t 10:00:00
#SBATCH -c 6

source ../common/common.sh

VERSION=${1:-1.4.1}
PROFILE=${2:-gcc}

source profiles/${PROFILE}

module list

NAME=openfst

init_vars

env

BDIR=$(mktemp -d)

pushd ${BDIR}

wget http://openfst.cs.nyu.edu/twiki/pub/FST/FstDownload/openfst-${VERSION}.tar.gz || error_exit "Could not download this version"
wget https://github.com/kaldi-asr/kaldi/raw/master/tools/extras/openfst-${VERSION}.patch || error_exit "Could not download kaldi patch"

tar xf openfst-${VERSION}.tar.gz
pushd openfst-${VERSION}/src/include/fst
patch -c -p0 -N < ../../../../openfst-${VERSION}.patch
popd
pushd  openfst-${VERSION}
./configure --prefix=${OPT_DIR}/${VERSION}${TOOLCHAIN} --enable-static --enable-shared --enable-far --enable-ngram-fsts --enable-lookahead-fsts --enable-const-fsts --enable-pdt --enable-linear-fsts LIBS="-ldl"
rm -Rf ${OPT_DIR}/${VERSION}${TOOLCHAIN}
make -j6 install

BIN_PATH=${OPT_DIR}/${VERSION}${TOOLCHAIN}/bin
LIB_PATH=${OPT_DIR}/${VERSION}${TOOLCHAIN}/lib

DESC="OpenFST Toolkit"
HELP="OpenFST ${VERSION}. This installation contains the kaldi patch for the minimization algorithm"

EXTRA_LINES="setenv FSTROOT ${OPT_DIR}/${VERSION}${TOOLCHAIN}
setenv FSTVER ${VERSION}"

write_module

popd
popd
rm -Rf ${BDIR}

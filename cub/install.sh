#!/bin/bash

source ../common/common.sh

NAME=CUB
VERSION=1.8.0

init_vars

export INSTALL_DIR=${OPT_DIR}/cub-$VERSION
export BUILD_DIR="$INSTALL_DIR"-build
mkdir -p ${BUILD_DIR}

pushd ${BUILD_DIR}

#Copied from https://github.com/kaldi-asr/kaldi/blob/master/tools/Makefile
wget -T 10 -t 3 -O cub-${VERSION}.zip https://github.com/NVlabs/cub/archive/${VERSION}.zip
unzip -oq cub-${VERSION}.zip

mv cub-${VERSION} $INSTALL_DIR
popd

read -d '' EXTRA_LINES << EOF
setenv CUBROOT ${INSTALL_DIR}
setenv CUBVER ${VERSION}
EOF

export HELP='See: https://github.com/NVlabs/cub'
export DESC='CUB provides state-of-the-art, reusable software components for every layer of the CUDA programming model'

write_module

rm -Rf ${BUILD_DIR}

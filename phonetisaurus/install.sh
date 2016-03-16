#!/bin/bash

source ../common/common.sh

VERSION=${1:-0.8a}
NAME=phonetisaurus

init_vars

if [ -f downloads/phonetisaurus-${VERSION}.tgz ]; then
   error_exit "Please download phonetisaurus-${VERSION}.tgz  to the downloads folder"
fi

mkdir -p ${OPT_DIR}/${VERSION}
tar xzvf downloads/phonetisaurus-${VERSION}.tgz --strip-components=1 -C ${OPT_DIR}/${VERSION}

pushd ${OPT_DIR}/${VERSION}/phonetisaurus/src

make all || error_exit "compilation failed"

BIN_PATH=${OPT_DIR}/${VERSION}/bin


DESC="phonetisaurus"
HELP="phonetisaurus ${VERSION}"

write_module

popd
#!/bin/bash

source ../common/common.sh

VERSION=${1:-2017.0.010}
NAME=intelpython3

init_vars

if [ ! -f downloads/l_python35_b_${VERSION}.tgz ]; then
   error_exit "Please download l_python35_b_${VERSION}.tgz to the downloads folder"
fi

tar xzvf downloads/l_python35_b_${VERSION}.tgz -C ${OPT_DIR}

pushd ${OPT_DIR}/l_python35_b_${VERSION}

cat ${SCRIPT_DIR}/config | sed "s#INSTALLPATH#${OPT_DIR}/${VERSION}#" > config
./install.sh -s config --user-mode --SHARED_INSTALL

BIN_PATH=${OPT_DIR}/${VERSION}/bin
LIB_PATH=${OPT_DIR}/${VERSION}/lib

DESC="Intel Python 3.5"
HELP="Intel Python 3.5 ${VERSION}"

EXTRA_LINES="
prepend-path MANPATH ${OPT_DIR}/${VERSION}/man"

write_module

popd

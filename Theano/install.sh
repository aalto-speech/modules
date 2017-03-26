#!/bin/bash

set -x

source ../common/common.sh

NAME=Theano
GIT_REPO=git@github.com:Theano/Theano.git

init_vars

checkout_git

pushd "${BUILD_DIR}"
module load anaconda3
export PYTHONPATH="${INSTALL_DIR}/lib/python3.5/site-packages/:${PYTHONPATH}"
mkdir -p "${INSTALL_DIR}/lib/python3.5/site-packages"
python3 setup.py install --prefix="${INSTALL_DIR}"
popd

DESC="Theano computation library"
HELP="Installs Theano library for Python"
BIN_PATH="${INSTALL_DIR}/bin"

read -d '' EXTRA_LINES << EOF
module add      anaconda3
append-path     PYTHONPATH ${INSTALL_DIR}/lib/python3.5/site-packages
EOF

write_module

rm -Rf "${BUILD_DIR}"

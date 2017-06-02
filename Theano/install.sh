#!/bin/bash

source ../common/common.sh

NAME=Theano
GIT_REPO=git@github.com:Theano/Theano.git

init_vars

checkout_git

pushd "${BUILD_DIR}"
module load libgpuarray
export PYTHONPATH="${INSTALL_DIR}/${PYTHON3_PACKAGE_SUBDIR}:${PYTHONPATH}"
mkdir -p "${INSTALL_DIR}/${PYTHON3_PACKAGE_SUBDIR}"
python3 setup.py install --prefix="${INSTALL_DIR}"
popd

DESC="Theano computation library"
HELP="Installs Theano library for Python"
BIN_PATH="${INSTALL_DIR}/bin"

read -d '' EXTRA_LINES << EOF
module add      libgpuarray
append-path     PYTHONPATH ${INSTALL_DIR}/${PYTHON3_PACKAGE_SUBDIR}
EOF

write_module

rm -Rf "${BUILD_DIR}"

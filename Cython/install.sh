#!/bin/bash -e

source ../common/common.sh

NAME=Cython
GIT_REPO=git@github.com:cython/cython.git

init_vars

checkout_git

pushd "${BUILD_DIR}"
module load anaconda3
export PYTHONPATH="${INSTALL_DIR}/${PYTHON3_PACKAGE_SUBDIR}:${PYTHONPATH}"
mkdir -p "${INSTALL_DIR}/${PYTHON3_PACKAGE_SUBDIR}"
python3 setup.py install --prefix="${INSTALL_DIR}"
popd

DESC="Theano computation library"
HELP="Installs Theano library for Python"
BIN_PATH="${INSTALL_DIR}/bin"

read -d '' EXTRA_LINES <<EOF || true
module add      anaconda3
append-path     PYTHONPATH ${INSTALL_DIR}/${PYTHON3_PACKAGE_SUBDIR}
EOF

write_module

rm -rf "${BUILD_DIR}"

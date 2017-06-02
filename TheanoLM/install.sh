#!/bin/bash

source ../common/common.sh

NAME=TheanoLM
GIT_REPO=git@github.com:senarvi/theanolm.git

init_vars
checkout_git

VERSION="1.1.2"
pushd "${GIT_PATH}"
git checkout "tags/v${VERSION}"
pushd "${GIT_PATH}"
module load anaconda3
module load Theano
export PYTHONPATH="${INSTALL_DIR}/${PYTHON3_PACKAGE_SUBDIR}:${PYTHONPATH}"
mkdir -p "${INSTALL_DIR}/${PYTHON3_PACKAGE_SUBDIR}"
python3 setup.py install --prefix="${INSTALL_DIR}"
popd

DESC="TheanoLM"
HELP="A neural network language modeling toolkit written using Python library Theano"
BIN_PATH="${INSTALL_DIR}/bin"

read -d '' EXTRA_LINES << EOF
module add      anaconda3
module add      Theano
append-path     PYTHONPATH ${INSTALL_DIR}/${PYTHON3_PACKAGE_SUBDIR}
EOF

VERSION=$(git --git-dir="${GIT_PATH}/.git" describe --match 'v[0-9]*')
VERSION=${VERSION:1}
write_module

rm -rf "${BUILD_DIR}"

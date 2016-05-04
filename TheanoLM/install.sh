#!/bin/bash

source ../common/common.sh

NAME=TheanoLM
GIT_REPO=git@github.com:senarvi/theanolm.git

init_vars

checkout_git

pushd "${GIT_PATH}"
module load anaconda3
module load Theano
export PYTHONPATH="${INSTALL_DIR}/lib/python3.5/site-packages/:${PYTHONPATH}"
mkdir -p "${INSTALL_DIR}/lib/python3.5/site-packages"
python3 setup.py install --prefix="${INSTALL_DIR}"
popd

DESC="TheanoLM"
HELP="A neural network language modeling toolkit written using Python library Theano"
BIN_PATH="${INSTALL_DIR}/bin"

read -d '' EXTRA_LINES << EOF
module add      anaconda3
module add      Theano
append-path     PYTHONPATH ${INSTALL_DIR}/lib/python3.5/site-packages
EOF

VERSION=$(git --git-dir="${GIT_PATH}/.git" describe --match 'v[0-9]*')
VERSION=${VERSION:1}
write_module

rm -Rf "${BUILD_DIR}"

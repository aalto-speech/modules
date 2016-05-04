#!/bin/bash

source ../common/common.sh

NAME=Morfessor
GIT_REPO=git@github.com:aalto-speech/morfessor.git

init_vars

checkout_git

pushd "${GIT_PATH}"
module load anaconda2
export PYTHONPATH="${INSTALL_DIR}/lib/python2.7/site-packages/:${PYTHONPATH}"
mkdir -p "${INSTALL_DIR}/lib/python2.7/site-packages"
python setup.py install --prefix="${INSTALL_DIR}"
popd

DESC="Morfessor"
HELP="A tool for unsupervised learning of subword units"
BIN_PATH="${INSTALL_DIR}/bin"

read -d '' EXTRA_LINES << EOF
module add      anaconda2
append-path     PYTHONPATH ${INSTALL_DIR}/lib/python2.7/site-packages
EOF

write_module

rm -Rf "${BUILD_DIR}"

#!/bin/bash

source ../common/common.sh

NAME=MorfessorJoint
GIT_REPO=git@github.com:psmit/morfessor.git
GIT_BRANCH=jointopt

init_vars

checkout_git

pushd "${GIT_PATH}"
module load pypy2
export PYTHONPATH="${INSTALL_DIR}/lib/python2.7/site-packages/:${PYTHONPATH}"
mkdir -p "${INSTALL_DIR}/lib/python2.7/site-packages"
python setup.py install --prefix="${INSTALL_DIR}"
popd

DESC="Morfessor Joint"
HELP="A tool for unsupervised learning of subword units"
BIN_PATH="${INSTALL_DIR}/bin"

read -d '' EXTRA_LINES << EOF
module load pypy2
module load Morfessor
append-path     PYTHONPATH ${INSTALL_DIR}/lib/python2.7/site-packages
EOF

write_module

rm -Rf "${BUILD_DIR}"

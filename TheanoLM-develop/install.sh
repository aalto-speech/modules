#!/bin/bash

source ../common/common.sh

NAME=TheanoLM-develop
GIT_REPO=git@github.com:senarvi/theanolm.git
GIT_BRANCH=develop

init_vars

checkout_git

DESC="TheanoLM"
HELP="A neural network language modeling toolkit written using Python library Theano"
BIN_PATH="${GIT_PATH}/bin"

read -d '' EXTRA_LINES << EOF
module add      anaconda3
module add      Theano
append-path     PYTHONPATH ${GIT_PATH}
setenv          THEANOLM ${GIT_PATH}
EOF

write_module

rm -Rf "${BUILD_DIR}"

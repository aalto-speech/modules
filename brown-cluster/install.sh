#!/bin/bash

source ../common/common.sh

NAME=brown-cluster
GIT_REPO=https://github.com/percyliang/brown-cluster

init_vars

checkout_git

pushd "${GIT_PATH}"
module load GCC
make
popd

BIN_PATH="${GIT_PATH}"

DESC="Percy Liang's brown-cluster tool"
HELP="Implementation of the Brown hierarchical word clustering algorithm."

write_module

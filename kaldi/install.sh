#!/bin/bash

source ../common/common.sh

NAME=kaldi
GIT_REPO=https://github.com/kaldi-asr/kaldi.git

init_vars

checkout_git

#this script must always be run from its own directory!
SCRIPT_DIR=$(pwd)
OPT_DIR=${GROUP_DIR}/opt/${NAME}

if [ ! -d "${OPT_DIR}/${NAME}-git" ]; then
    git clone
fi

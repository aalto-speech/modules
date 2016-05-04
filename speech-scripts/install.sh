#!/bin/bash

source ../common/common.sh

NAME=speech-scripts
GIT_REPO=git@github.com:aalto-speech/speech-scripts.git
GIT_DIR=src

init_vars

checkout_git

BIN_PATH="${GIT_PATH}/am-scripts"

DESC="Aalto Speech Group internal scripts"
HELP="Adds scripts from our private repository to PATH"

EXTRA_LINES="prepend-path     PATH ${GIT_PATH}/cluster-scripts
prepend-path     PATH ${GIT_PATH}/dictionary-scripts
prepend-path     PATH ${GIT_PATH}/lattice-scripts
prepend-path     PATH ${GIT_PATH}/lm-scripts
prepend-path     PATH ${GIT_PATH}/transcript-scripts"

write_module

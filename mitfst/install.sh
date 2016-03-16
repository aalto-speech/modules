#!/bin/bash

source ../common/common.sh

VERSION=1.4.0
NAME=mitfst

init_vars

pushd ${OPT_DIR}

wget http://people.csail.mit.edu/ilh/fst/libfst-${VERSION}.zip || error_exit "Could not download mitfst"

unzip libfst-${VERSION}.zip
pushd libfst-${VERSION}

autoreconf -fvi


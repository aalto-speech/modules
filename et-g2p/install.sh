#!/bin/bash -e

source ../common/common.sh

NAME=et-g2p
GIT_REPO=https://github.com/alumae/et-g2p

module purge
module load ant

init_vars
checkout_git
pushd "${GIT_PATH}"
ant
mv run.sh vocab2dict-ee.sh
popd

BIN_PATH="${GIT_PATH}"

DESC="Grapheme to phoneme rules for Estonian"
HELP="Tanel Alumäe's rule-based G2P converter for Estonian."

write_module

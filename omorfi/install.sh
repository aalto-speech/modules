#!/bin/bash -e

source ../common/common.sh

NAME=omorfi
GIT_REPO=git@github.com:flammie/omorfi.git
DESC="Omorfi–Open morphology of Finnish"
HELP="A free open source morphology of Finnish: a database, tools and APIs."

module purge
module load GCC
module load hfst
module load anaconda3

init_vars
checkout_git

BIN_PATH="${INSTALL_DIR}/bin"

pushd "${BUILD_DIR}"
./autogen.sh
./configure --prefix="${INSTALL_DIR}"
make -j 4
mkdir -p "${BIN_PATH}"
make install
popd
rm -rf "${BUILD_DIR}"

EXTRA_LINES="module add      GCC
module add      hfst"
write_module

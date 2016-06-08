#!/bin/bash -e

source ../common/common.sh

NAME=mitfst
VERSION='1.4.0'

init_vars

build_dir="$(mktemp -d)"
pushd "${build_dir}"

#wget "http://people.csail.mit.edu/ilh/fst/libfst-${VERSION}.zip"
#unzip "libfst-${VERSION}.zip"
cp -a /scratch/elec/puhe/Modules/install_scripts/mitfst/libfst-1.4.0 .
cd "libfst-${VERSION}"

module purge
# Installation requires Bison. I have been able to build it with
# Bison 2.4.1 and 2.7, but not with Bison 3.0.2.
module load Bison/2.7-GCC-4.8.4
# With GCC 4.8.4 or 4.9.3 I get an error about class trait requirements. With
# 4.7.4 I get less errors, but I still have to use the patched version.
module load GCC/4.7.4

aclocal
libtoolize
autoreconf --install
automake --add-missing

mkdir -p build
cd build
../configure --prefix="${OPT_DIR}/${VERSION}"
rm -rf "${OPT_DIR}/${VERSION}"
make install

BIN_PATH="${OPT_DIR}/${VERSION}/bin"
LIB_PATH="${OPT_DIR}/${VERSION}/lib"

DESC="MIT FST Toolkit"
HELP="The MIT FST Toolkit version ${VERSION}. This toolkit is not maintained anymore, but required by AaltoASR."

write_module

popd
rm -rf "${build_dir}"

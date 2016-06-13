#!/bin/bash
#SBATCH --mem-per-cpu 2G
#SBATCH -t 10:00:00

source ../common/common.sh

VERSION=${1:-3.5.2}
NAME=cmake

init_vars

module purge
module load GCC

pushd ${OPT_DIR}

rm -Rf cmake-${VERSION}* ${VERSION}

wget https://cmake.org/files/v3.5/cmake-${VERSION}.tar.gz || error_exit "Could not download this version"

tar xf cmake-${VERSION}.tar.gz
pushd cmake-${VERSION}

LDFLAGS="-Wl,-rpath,${EBROOTGCC}/lib64" ./bootstrap --prefix=${OPT_DIR}/${VERSION}
make
make install

BIN_PATH=${OPT_DIR}/${VERSION}/bin
LIB_PATH=${OPT_DIR}/${VERSION}/lib

DESC="CMake"
HELP="CMake ${VERSION}"


write_module

popd
rm -Rf cmake-${VERSION}*
popd

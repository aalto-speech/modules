#!/bin/bash
#SBATCH --mem-per-cpu 2G
#SBATCH -t 10:00:00
#SBATCH -c 6
#SBATCH -p coin

source ../common/common.sh

VERSION=${1:-1.6.1}

module purge
module load GCC
module list

NAME=xmlstarlet

init_vars

env

BDIR=$(mktemp -d)

pushd ${BDIR}

wget https://downloads.sourceforge.net/project/xmlstar/xmlstarlet/${VERSION}/xmlstarlet-${VERSION}.tar.gz
tar xf xmlstarlet-${VERSION}.tar.gz
pushd xmlstarlet-${VERSION}

env CPPFLAGS="-I/usr/include/libxml2 -Wl,-rpath=$EBROOTGCC/lib64" ./configure --prefix=${OPT_DIR}/${VERSION}
make install
ln -rs ${OPT_DIR}/${VERSION}/bin/xml ${OPT_DIR}/${VERSION}/bin/xmlstarlet

BIN_PATH=${OPT_DIR}/${VERSION}/bin

DESC="XMLStarlet Toolkit"
HELP="XMLStarlet ${VERSION}."

write_module

popd
popd
rm -Rf ${BDIR}

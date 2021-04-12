#!/bin/bash
#SBATCH --mem 2G
#SBATCH -t 0:02:0

set -eu 

NAME=tree
VERSION=1.8.0
SRC_HTTP=http://mama.indstate.edu/users/ice/tree/src/tree-${VERSION}.tgz
TOOLCHAIN=goolfc/triton-2017a
TOOLCHAIN_NAME=goolfc-triton-2017a
module load ${TOOLCHAIN}

OPTDIR=/scratch/elec/puhe/Modules/opt/${NAME}/${VERSION}-${TOOLCHAIN_NAME}
BUILDDIR=${OPTDIR}/build
INSTALLDIR=${OPTDIR}/install
MODULEDIR=/scratch/elec/puhe/Modules/modulefiles/${NAME}
mkdir -p $MODULEDIR
MODULEFILE=${MODULEDIR}/${VERSION}-${TOOLCHAIN_NAME}

# Download, compile, and install
mkdir -p $BUILDDIR
cd $BUILDDIR
wget ${SRC_HTTP}
tar -xzf tree-${VERSION}.tgz
cd $BUILDDIR/tree-${VERSION}
make prefix=${INSTALLDIR}
make prefix=${INSTALLDIR} install
rm -rf $BUILDDIR

# Create Modulefile
cat > ${MODULEFILE} << EOF
#%Module1.0#####################################################################
##
##
proc ModulesHelp { } {
        puts stderr "\ttree command, version ${VERSION}"
}


module-whatis   "Recursive directory listing command Tree"
prepend-path PATH ${INSTALLDIR}/bin
prepend-path MANPATH ${INSTALLDIR}/man
EOF


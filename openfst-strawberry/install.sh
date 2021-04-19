#!/bin/bash
#SBATCH --mem-per-cpu 2G
#SBATCH -t 1:00:00
#SBATCH -N1
#SBATCH -c 12

set -e -u

module purge
# Prepare the compilation environment
GCC=8.4.0
# note the lowercase modules
module load gcc/$GCC autoconf automake sox libtool
module list

# Define module
NAME=openfst-strawberry
TOOLCHAIN="gcc$GCC" # This variable needs to be update if mentioned dependencies change
VERSION=1.6.7
OPENFST_CONFIGURE="--enable-static --enable-shared --enable-far --enable-ngram-fsts --enable-lookahead-fsts --with-pic"
# Get temp dir and Install dir:
mkdir -p $GROUP_DIR/Modules/opt/$NAME
DIR=$(mktemp -d $GROUP_DIR/Modules/opt/$NAME/XXXXXXXXXX.tmpdir)
INSTALLDIR="$GROUP_DIR/Modules/opt/$NAME/$VERSION-$TOOLCHAIN"

# Move to DIR and follow KALDI-style install there
cd $DIR
wget -nv -T 10 -t 1 http://www.openfst.org/twiki/pub/FST/FstDownload/openfst-${VERSION}.tar.gz || \
wget -nv -T 10 -t 3 -c https://www.openslr.org/resources/2/openfst-${VERSION}.tar.gz
tar xozf openfst-${VERSION}.tar.gz
cd openfst-${VERSION}
./configure --prefix="$INSTALLDIR" ${OPENFST_CONFIGURE} \
  CXXFLAGS=" -g -O2" LIBS="-ldl"
make -j12 install MAKEOVERRIDES=
cd $INSTALLDIR
[ -d lib64 ] && [ ! -d lib ] && ln -s lib64 lib

#RM tempdir
rm -rf $DIR

# Write module file
mkdir -p $GROUP_DIR/Modules/modulefiles/$NAME/
MODULEFILE=$GROUP_DIR/Modules/modulefiles/$NAME/${VERSION}-${TOOLCHAIN}
cat > ${MODULEFILE} << EOF
#%Module1.0#####################################################################
##
##
proc ModulesHelp { } {
        puts stderr "\tOpenFST, Finite state machine library, to be used with kaldi-strawberry, version ${VERSION}"
}

module-whatis   "OpenFST to be used with Kaldi-strawberry"
prepend-path PATH ${INSTALLDIR}/bin
prepend-path CPATH ${INSTALLDIR}/include
prepend-path LIBRARY_PATH ${INSTALLDIR}/lib
prepend-path LD_LIBRARY_PATH ${INSTALLDIR}/lib
setenv OPENFST_PATH ${INSTALLDIR}
setenv OPENFST_VER ${VERSION}
module load gcc/$GCC

EOF

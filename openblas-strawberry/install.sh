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
NAME=openblas-strawberry
TOOLCHAIN="gcc$GCC" # This variable needs to be update if mentioned dependencies change
VERSION=0.3.13
# Get git vars and clone:
mkdir -p $GROUP_DIR/Modules/opt/$NAME
DIR=$(mktemp -d $GROUP_DIR/Modules/opt/$NAME/XXXXXXXXXX.tmpdir)
INSTALLDIR="$GROUP_DIR/Modules/opt/$NAME/$VERSION-$TOOLCHAIN"


# Move to DIR and follow KALDI-style install there
cd $DIR
WGET=${WGET:-wget}
tarball=OpenBLAS-$VERSION.tar.gz
url=$($WGET -qO- "https://api.github.com/repos/xianyi/OpenBLAS/releases/tags/v${VERSION}" | python -c 'import sys,json;print(json.load(sys.stdin)["tarball_url"])')
test -n "$url"
$WGET -t3 -nv -O $tarball "$url"
tar xzf $tarball
mv xianyi-OpenBLAS-* OpenBLAS
# NOTE the RANLIB injection (a little edit to Kaldi's install script)
make PREFIX="$INSTALLDIR" USE_LOCKING=1 USE_THREAD=0 RANLIB=gcc-ranlib -C OpenBLAS -j 12 all install
if [ $? -eq 0 ]; then
   echo "OpenBLAS is installed successfully."
   rm $tarball
fi

#RM temp dir:
rm -rf $DIR

# Write module file
mkdir -p $GROUP_DIR/Modules/modulefiles/$NAME/
MODULEFILE=$GROUP_DIR/Modules/modulefiles/$NAME/${VERSION}-${TOOLCHAIN}
cat > ${MODULEFILE} << EOF
#%Module1.0#####################################################################
##
##
proc ModulesHelp { } {
        puts stderr "\tOpenBLAS, Linear Algebra library, to be used with kaldi-strawberry, version ${VERSION}"
}

module-whatis   "To be used with Kaldi-strawberry"
prepend-path CPATH ${INSTALLDIR}/include
prepend-path LIBRARY_PATH ${INSTALLDIR}/lib
prepend-path LD_LIBRARY_PATH ${INSTALLDIR}/lib
setenv OPENBLAS_PATH ${INSTALLDIR}
module load gcc/$GCC

EOF

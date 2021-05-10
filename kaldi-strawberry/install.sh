#!/bin/bash
#SBATCH --mem-per-cpu 2G
#SBATCH -t 1:00:00
#SBATCH -N1
#SBATCH -c 12

set -e -u

module purge
# Prepare the compilation environment
GCC=8.4.0
CUDA=10.2.89
OPENBLAS=0.3.13
OPENFST=1.6.7
CUB=1.8.0
# note the lowercase modules
module load gcc/$GCC cuda/$CUDA autoconf automake sox libtool
module load openblas-strawberry/$OPENBLAS-gcc$GCC openfst-strawberry/$OPENFST-gcc$GCC
module load CUB/$CUB
module load sctk
module load sph2pipe
module list

# Define module
NAME=kaldi-strawberry
GIT_REPO=https://github.com/kaldi-asr/kaldi.git
TOOLCHAIN="staticmath-gcc$GCC-cuda$CUDA-openblas$OPENBLAS-openfst$OPENFST" # This variable needs to be update if mentioned dependencies change
# Get git vars and clone:
mkdir -p $GROUP_DIR/Modules/opt/$NAME
GITDIR=$(mktemp -d $GROUP_DIR/Modules/opt/$NAME/XXXXXXXXXX.tmpdir)
git clone $GIT_REPO $GITDIR
cd $GITDIR
VERSION=$(git rev-parse --short HEAD)

# Compile
cd src
./configure --mathlib=OPENBLAS \
            --openblas-root=${OPENBLAS_PATH} \
            --fst-root=${OPENFST_PATH} \
            --cub-root=${CUBROOT} \
            --cudatk-dir=${CUDA_ROOT} \
						--static-math=yes
make -j12 depend
make -j12 
cd ..


## Filter the right files.
BINDIR=$GROUP_DIR/Modules/opt/$NAME/$VERSION-bin
mkdir -p $BINDIR
# Find Kaldi executables 
find src/ -type f -executable -print | grep "bin/" | grep -v "so$" | xargs cp -t "${BINDIR}"
rm -rf $GITDIR

# Write module file
mkdir -p $GROUP_DIR/Modules/modulefiles/$NAME/
MODULEFILE=$GROUP_DIR/Modules/modulefiles/$NAME/${VERSION}-${TOOLCHAIN}
cat > ${MODULEFILE} << EOF
#%Module1.0#####################################################################
##
##
proc ModulesHelp { } {
        puts stderr "\tKaldi ASR toolkit, Version ${VERSION}"
}

module-whatis   "Kaldi Speech Recognition Toolkit, in a strawberry configuration"
prepend-path PATH ${BINDIR}
setenv KALDI_COMMIT ${VERSION}
module load openblas-strawberry/$OPENBLAS-gcc$GCC 
module load openfst-strawberry/$OPENFST-gcc$GCC
module load cuda/$CUDA 
module load sox
module load sph2pipe
module load sctk

EOF

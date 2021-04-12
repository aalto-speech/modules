#!/bin/bash
#SBATCH --mem-per-cpu 4G
#SBATCH -t 1:00:00
#SBATCH -p coin,batch-ivb,batch-hsw,short-ivb,short-hsw,batch-csl,batch-skl
#SBATCH -N1
#SBATCH -c 20

source ../common/common.sh

PROFILE=${1:-triton-gcc-openblas-adap}

module purge
source profiles/${PROFILE}
module list
NAME=kaldi-adap
GIT_REPO=https://github.com/wangkenpu/Adaptation-Interspeech18.git
GIT_DIR=kaldi-wangke/src

init_vars

checkout_git

pushd ${BUILD_DIR}/kaldi-wangke/src

./configure --fst-root="/scratch/elec/puhe/Modules/opt/openfst/$OPENFST" --fst-version="$OPENFST_VERSION" \
            --cudatk-dir="/share/apps/easybuild/software/CUDA/$CUDA" \
            --mathlib=OPENBLAS --openblas-root="/share/apps/easybuild/software/OpenBLAS/$OPENBLAS" 

make -j clean depend

make -j $SLURM_CPUS_PER_TASK

rm -Rf "${INSTALL_DIR}"
mkdir -p ${INSTALL_DIR}/{bin,testbin}


find . -type f -executable -print | grep "bin/" | grep -v "\.cc$" | grep -v "so$" | grep -v test | xargs cp -t "${INSTALL_DIR}/bin"
find . -type f -executable -print | grep -v "\.cc$" | grep -v "so$" | grep test | xargs cp -t "${INSTALL_DIR}/testbin"

popd


BIN_PATH=${INSTALL_DIR}/bin

EXTRA_LINES="module load GCC/$GCC openfst/$OPENFST CUDA/$CUDA OpenBLAS/$OPENBLAS sctk/$SCTK sph2pipe/$SPH sox
setenv KALDI_INSTALL_DIR ${INSTALL_DIR}"
DESC="Kaldi Speech Recognition Toolkit"
HELP="Kaldi ${VERSION} ${TOOLCHAIN}"

write_module


rm -Rf ${BUILD_DIR}

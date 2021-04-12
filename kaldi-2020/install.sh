#!/bin/bash
#SBATCH --mem-per-cpu 4G
#SBATCH -t 1:00:00
#SBATCH -N1
#SBATCH -c 20

source ../common/common.sh

PROFILE=${1:-triton-gcc-openblas-2020}

module purge
source profiles/${PROFILE}
module list
NAME=kaldi
GIT_REPO=https://github.com/kaldi-asr/kaldi.git
GIT_DIR=src

init_vars

checkout_git

pushd ${BUILD_DIR}/src

./configure --fst-root="/scratch/elec/puhe/Modules/opt/openfst/$OPENFST" --fst-version="$OPENFST_VERSION" \
            --cub-root="/scratch/elec/puhe/Modules/opt/CUB/cub-$CUB" \
            --mathlib=OPENBLAS --openblas-root="/share/apps/easybuild/software/OpenBLAS/$OPENBLAS" \
            --cudatk-dir="/share/apps/spack/envs/fgci-centos7-generic/software/cuda/$CUDA/6e7kenm" 

make -j clean depend

make -j $SLURM_CPUS_PER_TASK

#make -j $SLURM_CPUS_PER_TASK test_compile

rm -Rf "${INSTALL_DIR}"
mkdir -p ${INSTALL_DIR}/{bin,testbin}


find . -type f -executable -print | grep "bin/" | grep -v "\.cc$" | grep -v "so$" | grep -v test | xargs cp -t "${INSTALL_DIR}/bin"
find . -type f -executable -print | grep -v "\.cc$" | grep -v "so$" | grep test | xargs cp -t "${INSTALL_DIR}/testbin"

popd


BIN_PATH=${INSTALL_DIR}/bin

EXTRA_LINES="module load GCC/$GCC openfst/$OPENFST CUB/$CUB cuda/$CUDA OpenBLAS/$OPENBLAS sctk/$SCTK sph2pipe/$SPH sox
setenv KALDI_INSTALL_DIR ${INSTALL_DIR}
setenv KALDI_GIT_COMMIT ${VERSION}"
DESC="Kaldi Speech Recognition Toolkit"
HELP="Kaldi ${VERSION} ${TOOLCHAIN}"

write_module


rm -Rf ${BUILD_DIR}

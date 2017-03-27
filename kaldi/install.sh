#!/bin/bash
#SBATCH --mem-per-cpu 4G
#SBATCH -t 1:00:00
#SBATCH -p coin,batch-ivb,batch-wsm,batch-hsw,short-ivb,short-wsm,short-hsw
#SBATCH -N1
#SBATCH -c 20

source ../common/common.sh

PROFILE=${1:-gcc-mkl2017}

module purge
source profiles/${PROFILE}
module list
NAME=kaldi
GIT_REPO=https://github.com/kaldi-asr/kaldi.git
GIT_DIR=src

init_vars

checkout_git

pushd ${BUILD_DIR}/src

echo "BUILD_DIR = ${BUILD_DIR}" > kaldi.mk
echo "${MAKELINES}" >> kaldi.mk
cat ${FILE_DIR}/common.mk >> kaldi.mk
patch -p2 < ${FILE_DIR}/matrix.diff
echo "${PWD}"
make clean

make -j $SLURM_CPUS_PER_TASK all 
make -j $SLURM_CPUS_PER_TASK test_compile

rm -Rf "${INSTALL_DIR}"
mkdir -p ${INSTALL_DIR}/{bin,testbin}


find . -type f -executable -print | grep "bin/" | grep -v "\.cc$" | grep -v "so$" | grep -v test | xargs cp -t "${INSTALL_DIR}/bin"
find . -type f -executable -print | grep -v "\.cc$" | grep -v "so$" | grep test | xargs cp -t "${INSTALL_DIR}/testbin"

popd


BIN_PATH=${INSTALL_DIR}/bin

EXTRA_LINES="setenv KALDI_INSTALL_DIR ${INSTALL_DIR}"
DESC="Kaldi Speech Recognition Toolkit"
HELP="Kaldi ${VERSION} ${TOOLCHAIN}"

write_module


#rm -Rf ${BUILD_DIR}

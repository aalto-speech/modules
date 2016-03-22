#!/bin/bash

source ../common/common.sh

NAME=kaldi
GIT_REPO=https://github.com/kaldi-asr/kaldi.git
GIT_DIR=src

init_vars

. ${FILE_DIR}/modules

checkout_git

pushd ${BUILD_DIR}/src

echo "KALDI_COMMIT = ${COMMIT}" > kaldi.mk
echo "FSTROOT = ${FST_ROOT}" >> kaldi.mk
echo "KALDIROOT = ${OPT_DIR}" >> kaldi.mk

cat ${FILE_DIR}/base.mk >> kaldi.mk

if [ "${TRITON}" = "triton" ]; then
    echo "OPENBLASLIBS = -L/usr/lib64 -lopenblas -lgfortran" >> kaldi.mk
    echo "OPENBLASROOT = /usr" >> kaldi.mk
    echo "EXTRA_CXXFLAGS += -I/usr/include/openblas" >> kaldi.mk
else
    echo "OPENBLASLIBS = -L/usr/lib -lopenblas -lgfortran -llapack -Wl,-rpath=/usr/lib" >> kaldi.mk
    echo "OPENBLASROOT = /usr" >> kaldi.mk
fi


cat ${FILE_DIR}/linux_openblas.mk >> kaldi.mk

make
mkdir -p collectbin
pushd collectbin
find .. -type f -executable -print | grep "bin/" | grep -v "\.cc$" | grep -v "so$" | xargs -L 1 ln -s
popd

for ext in "o" "cc" "png" "mk"; do
    find . -type f -iname \*.${ext} -exec rm -f {} \;
done


popd


BIN_PATH=${BUILD_DIR}/src/collectbin
LIB_PATH=${BUILD_DIR}/src/lib

DESC="Kaldi Speech Recognition Toolkit"
HELP="Kaldi ${VERSION}, non-cuda with systems openblas"

EXTRA_LINES=$(cat ${FILE_DIR}/modules)

write_module




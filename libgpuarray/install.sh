#!/bin/bash

source ../common/common.sh

NAME=libgpuarray
GIT_REPO=https://github.com/Theano/libgpuarray.git

init_vars

module load GCC
module load cmake
module load anaconda3

checkout_git

mkdir "${BUILD_DIR}/build"
pushd "${BUILD_DIR}/build"
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="${INSTALL_DIR}" ..
make
make install
popd

export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${INSTALL_DIR}/lib64"
export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${INSTALL_DIR}/lib"
export LIBRARY_PATH="${LIBRARY_PATH}:${INSTALL_DIR}/lib64"
export LIBRARY_PATH="${LIBRARY_PATH}:${INSTALL_DIR}/lib"
export CPATH="${CPATH}:${INSTALL_DIR}/include"
export PYTHONPATH="${PYTHONPATH}:${INSTALL_DIR}/lib/python3.5/site-packages"

pushd "${BUILD_DIR}"
python3 setup.py build_ext -L "${INSTALL_DIR}/lib" -I "${INSTALL_DIR}/include"
python3 setup.py install --prefix="${INSTALL_DIR}"

BIN_PATH="${INSTALL_DIR}/bin"
LIB_PATH="${INSTALL_DIR}/lib"

read -d '' EXTRA_LINES <<EOF
module add      GCC
module add      anaconda3
append-path     PYTHONPATH "${INSTALL_DIR}/lib/python3.5/site-packages"
append-path     LD_LIBRARY_PATH "${INSTALL_DIR}/lib64"
append-path     LD_LIBRARY_PATH "${INSTALL_DIR}/lib"
append-path     LIBRARY_PATH "${INSTALL_DIR}/lib64"
append-path     LIBRARY_PATH "${INSTALL_DIR}/lib"
append-path     CPATH "${INSTALL_DIR}/include"
EOF

write_module

rm -rf "${BUILD_DIR}"
#!/bin/bash -e

source ../common/common.sh

NAME=libgpuarray
GIT_REPO=https://github.com/Theano/libgpuarray.git

init_vars

checkout_git

module purge
module load GCC/4.9.3-2.25
module load cmake/3.5.2-GCC-4.9.3
module load anaconda3
#module load Cython

mkdir -p "${BUILD_DIR}/build"
pushd "${BUILD_DIR}/build"
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="${INSTALL_DIR}" ..
mkdir -p "${INSTALL_DIR}"
make
make install
popd

export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${INSTALL_DIR}/lib64"
export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${INSTALL_DIR}/lib"
export LIBRARY_PATH="${LIBRARY_PATH}:${INSTALL_DIR}/lib64"
export LIBRARY_PATH="${LIBRARY_PATH}:${INSTALL_DIR}/lib"
export CPATH="${CPATH}:${INSTALL_DIR}/include"
export PYTHONPATH="${INSTALL_DIR}/${PYTHON3_PACKAGE_SUBDIR}:${PYTHONPATH}"

pushd "${BUILD_DIR}"
mkdir -p "${INSTALL_DIR}/${PYTHON3_PACKAGE_SUBDIR}"
python3 setup.py build_ext -L "${INSTALL_DIR}/lib" -I "${INSTALL_DIR}/include"
python3 setup.py install --prefix="${INSTALL_DIR}"

BIN_PATH="${INSTALL_DIR}/bin"
LIB_PATH="${INSTALL_DIR}/lib"

read -d '' EXTRA_LINES <<EOF || true
module add      GCC/4.9.3-2.25
module add      anaconda3
append-path     PYTHONPATH "${INSTALL_DIR}/${PYTHON3_PACKAGE_SUBDIR}"
append-path     LD_LIBRARY_PATH "${INSTALL_DIR}/lib64"
append-path     LD_LIBRARY_PATH "${INSTALL_DIR}/lib"
append-path     LIBRARY_PATH "${INSTALL_DIR}/lib64"
append-path     LIBRARY_PATH "${INSTALL_DIR}/lib"
append-path     CPATH "${INSTALL_DIR}/include"
EOF

write_module

rm -rf "${BUILD_DIR}"

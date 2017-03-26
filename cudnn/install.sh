#!/bin/bash -e

script_dir=$(dirname "${0}")
script_dir=$(readlink -e "${script_dir}")
source "${script_dir}/../common/common.sh"

NAME=cudnn
VERSION='7.5-linux-x64-v5.1'

init_vars

mkdir -p "${OPT_DIR}/${VERSION}"
pushd "${OPT_DIR}/${VERSION}"

tar xvzf "${script_dir}/cudnn-${VERSION}.tgz"

BIN_PATH="${OPT_DIR}/${VERSION}/cuda/bin"
LIB_PATH="${OPT_DIR}/${VERSION}/cuda/lib64"

DESC="NVIDIA cuDNN"
HELP="cuDNN library for improved CUDA performance with TensorFlow, Theano, etc."

read -d '' EXTRA_LINES <<EOF || true
append-path     CPATH ${OPT_DIR}/${VERSION}/cuda/include
EOF

write_module

popd

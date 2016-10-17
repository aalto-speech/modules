#!/bin/bash -e

source ../common/common.sh

VERSION=1.9.7
NAME=ant

init_vars
module load Java
pushd "${OPT_DIR}"
echo "Downloading ${OPT_DIR}/apache-ant-${VERSION}-src.tar.gz."
wget -N "http://www.nic.funet.fi/pub/mirrors/apache.org/ant/source/apache-ant-${VERSION}-src.tar.gz"
tar xzf "apache-ant-${VERSION}-src.tar.gz"
rm -f "${OPT_DIR}/apache-ant-${VERSION}-src.tar.gz"
pushd "apache-ant-${VERSION}"
./build.sh

BIN_PATH="$(pwd)/dist/bin"
LIB_PATH="$(pwd)/dist/lib"
EXTRA_LINES="module add      Java"
EXTRA_LINES="setenv          ANT_HOME $(pwd)/dist"
DESC="ant"
HELP="Apache Ant ${VERSION}"

write_module
popd
popd

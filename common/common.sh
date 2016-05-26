#!/bin/bash


error_exit () {
    echo "$1" >&2
    exit "${2:-1}"
}


init_vars () {
    SCRIPT_DIR=$(pwd)
    MODULE_ROOT=${MODULE_ROOT:-${GROUP_DIR}/Modules}
    OPT_DIR=${MODULE_ROOT}/opt/${NAME}
    MODULE_DIR=${MODULE_ROOT}/modulefiles/${NAME}

    mkdir -p "${OPT_DIR}"
    mkdir -p "${MODULE_DIR}"

    FILE_DIR=${SCRIPT_DIR}/files
}

checkout_git () {
    pushd ${OPT_DIR}

    if [ ! -d ${NAME}-git ]; then
         git clone ${GIT_REPO} ${NAME}-git
    fi

    GIT_PATH=${OPT_DIR}/${NAME}-git

    pushd ${GIT_PATH}
    git checkout ${GIT_BRANCH:-master}
    git pull

    COMMIT=$(git rev-parse --short HEAD)

    export BUILD_DIR=${OPT_DIR}/${NAME}-${COMMIT}${TOOLCHAIN}-build
    INSTALL_DIR=${OPT_DIR}/${NAME}-${COMMIT}${TOOLCHAIN}

    mkdir -p "${BUILD_DIR}"

    git archive ${COMMIT} ${GIT_DIR:-.} | tar -x -C ${BUILD_DIR}

    popd

    popd

    VERSION=$(date +%Y.%m.%d)-${COMMIT}

}

write_module () {

cat > ${MODULE_DIR}/${VERSION}${TOOLCHAIN} <<Endofmessage
#%Module1.0#####################################################################
##
##
proc ModulesHelp { } {
        puts stderr "\t${HELP}"
}

module-whatis   "${DESC}"

${EXTRA_LINES}
Endofmessage

if [ ! -z "${BIN_PATH}" ]; then
echo "prepend-path     PATH ${BIN_PATH}" >> ${MODULE_DIR}/${VERSION}${TOOLCHAIN}
fi

if [ ! -z "${LIB_PATH}" ]; then
echo "prepend-path     LD_LIBRARY_PATH ${LIB_PATH}" >> ${MODULE_DIR}/${VERSION}${TOOLCHAIN}
fi

}

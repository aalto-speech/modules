#!/bin/bash

init_vars () {
    SCRIPT_DIR=$(pwd)
    OPT_DIR=${GROUP_DIR}/Modules/opt/${NAME}
    MODULE_DIR=${GROUP_DIR}/Modules/modulefiles/${NAME}

    mkdir -p ${OPT_DIR}
    mkdir -p ${MODULE_DIR}
}

checkout_git () {
    pushd ${OPT_DIR}

    if [ ! -d ${NAME}-git ]; then
         git clone ${GIT_REPO} ${NAME}-git
    fi

    pushd ${NAME}-git
    git checkout ${GIT_BRANCH:-master}
    git pull

    COMMIT=$(git rev-parse --short HEAD)

    BUILD_DIR=${OPT_DIR}/${NAME}-${COMMIT}

    mkdir ${OPT_DIR}/${NAME}-${COMMIT}

    git archive ${COMMIT} src | tar -x --strip-components 1 -C ${OPT_DIR}/${NAME}-${COMMIT}

    popd

    popd
}


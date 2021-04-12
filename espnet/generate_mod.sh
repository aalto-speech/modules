#!/bin/bash
#SBATCH -t 1:00:00
#SBATCH --cpus-per-task 5
#SBATCH --mem-per-cpu 6G
#SBATCH --ntasks 1

#load modules that contain the tools needed
KALDI_VERSION="7637de7-GCC-6.4.0-2.28-OPENBLAS"
KALDI_DIR_SUFIX="7637de7-6.4.0-2.28"
CUDA_VERSION=10.0.130
GIT_HASH="652be4c"
#Loading dependencies
module load kaldi-vanilla/${KALDI_VERSION} anaconda3 cmake nvidia-torch cuda/${CUDA_VERSION}


CUDAROOT=/share/apps/spack/software/cuda/${CUDA_VERSION}
export PATH=$CUDAROOT/bin:$PATH
export LD_LIBRARY_PATH=$CUDAROOT/lib64:$LD_LIBRARY_PATH
export CFLAGS="-I$CUDAROOT/include $CFLAGS"
export CPATH=$CUDAROOT/include:$CPATH
export CUDA_HOME=$CUDAROOT
export CUDA_PATH=$CUDAROOT


NAME="espnet-2020"
GIT_REPO=https://github.com/espnet/espnet
VERSION=${GIT_HASH}
SCRIPT_DIR=$(pwd)
MODULE_ROOT="${MODULE_ROOT:-${GROUP_DIR}/Modules}"
OPT_DIR="${MODULE_ROOT}/opt/${NAME}"
MODULE_DIR="${MODULE_ROOT}/modulefiles/${NAME}"


DESC="ESPnet: end-to-end speech processing toolkit"
HELP="ESPnet $VERSION CUDA-${CUDA_VERSION} with kaldi-vanilla/${KALDI_VERSION}"
MODULE_FILE=${MODULE_DIR}/"$VERSION"
echo "$MODULE_FILE"
cat > $MODULE_FILE <<Endofmessage
#%Module1.0#####################################################################
##
##
proc ModulesHelp { } {
        puts stderr "\t${HELP}"
        puts stderr "NOTE: This module also loads the necessary libraries (like CUDA and Kaldi) as modules"
        puts stderr "The module file does not activate the virtual enviroment."
        puts stderr "To set the path for Kaldi and activate the env use:"
        puts stderr "\t[ -f $KALDI_ROOT/tools/env.sh ] && . $KALDI_ROOT/tools/env.sh"
        puts stderr "\t source \$ESPNET_ROOT/tools/venv/etc/profile.d/conda.sh && conda deactivate && conda activate"
        puts stderr "in the the path.sh file."

}


module-whatis   "${DESC}"
Endofmessage
# Load dependencies automatically:
echo "module load kaldi-vanilla/${KALDI_VERSION} anaconda3 cuda/${CUDA_VERSION} sox" >> $MODULE_FILE

# You need the correct version of the scripts, so let's set the version as an env var:


# Set up the enviroment
echo "export LC_ALL=C" >> $MODULE_FILE
echo "setenv ESPNET_COMMIT $GIT_HASH" >> $MODULE_FILE
MAIN_ROOT="$OPT_DIR"/"espnet-$GIT_HASH"
echo "setenv ESPNET_ROOT $MAIN_ROOT" >> $MODULE_FILE

echo "prepend-path LD_LIBRARY_PATH $MAIN_ROOT/tools/chainer_ctc/ext/warp-ctc/build" >> $MODULE_FILE
echo "prepend-path PATH $MAIN_ROOT/utils:$MAIN_ROOT/espnet/bin" >> $MODULE_FILE


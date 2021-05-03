#!/bin/bash
#SBATCH --mem-per-cpu 2G
#SBATCH -t 0:30:00
#SBATCH -N1
#SBATCH -c 2

module purge
GOVERSION=1.14.7
module load go/$GOVERSION
module list

# Define module
NAME=tarp
GIT_REPO=https://github.com/tmbdev/tarp
# Get git vars and clone:
mkdir -p $GROUP_DIR/Modules/opt/$NAME
GITDIR=$(mktemp -d $GROUP_DIR/Modules/opt/$NAME/XXXXXXXXXX.tmpdir)
git clone $GIT_REPO $GITDIR
cd $GITDIR
VERSION=$(git rev-parse --short HEAD)

# Compile
# NOTE: this is going to error out, but it's just a faulty Makefile, the compilation works
make bin/tarp

# Copy the tarp program
BINDIR=$GROUP_DIR/Modules/opt/$NAME/$VERSION-bin
mkdir -p $BINDIR
mv tarp/tarp $BINDIR/
rm -rf $GITDIR

# Write module file
mkdir -p $GROUP_DIR/Modules/modulefiles/$NAME/
MODULEFILE=$GROUP_DIR/Modules/modulefiles/$NAME/${VERSION}
cat > ${MODULEFILE} << EOF
#%Module1.0#####################################################################
##
##
proc ModulesHelp { } {
        puts stderr "\tTarp TAR file utility, Version ${VERSION}"
}

module-whatis   "Stream processing of files in TAR archives, mostly for sharding datasets."
prepend-path PATH ${BINDIR}

EOF

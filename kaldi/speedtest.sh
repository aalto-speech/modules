#!/bin/bash

echo $1
hostname

module purge

module load $1

for _ in $(seq 10); do

 $KALDI_INSTALL_DIR/testbin/matrix-lib-speed-test 2>&1 | grep "total duration"
    sleep 5

done

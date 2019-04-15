#!/bin/bash

set -xe
WORK_DIR=${GIT_REPO##*/}
if [ ! -d "$WORK_DIR" ]; then
    git clone https://github.com/$GIT_REPO
fi
cd $WORK_DIR
./build_mir3g.sh
#!/bin/bash

set -e

. activate "${PREFIX}"
pushd ${SRC_DIR}

# top level build has done everything, so just test it, and install it
make -j ${CPU_COUNT} check
make install

popd

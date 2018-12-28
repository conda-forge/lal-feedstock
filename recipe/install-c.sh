#!/bin/bash
#
# Install the C libraries and SWIG interface files for
# a LALSuite subpackage.
#

set -e
pushd ${SRC_DIR}
make install

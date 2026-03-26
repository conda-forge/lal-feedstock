#!/bin/bash
#
# Configure, build, test, and install the LAL C libraries.
#
# This is run once for the staging output, the results of which are
# then split into the liblal package; the python-lal and lal packages
# reuse the _build directory to avoid rebuilding the C libraries.
#

set -ex

# get common options
. ${RECIPE_DIR}/common.sh

# use out-of-tree build
mkdir -pv _build
cd _build

# configure needs a Python interpreter (even with --disable-python),
# so use the one from the build environment
export PYTHON=${BUILD_PREFIX}/bin/python

# configure
${SRC_DIR}/configure \
  ${CONFIGURE_ARGS} \
  --disable-python \
  --disable-swig-python \
  --enable-swig-iface \
;

# build
${_make} HDF5_LIBS="${HDF5_LIBS}"

# test
if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" ]]; then
  ${_make} check
fi

# install library and headers
${_make} -C lib install HDF5_LIBS="${HDF5_LIBS}"

# install SWIG binding definitions and headers
${_make} -C swig install-data

# install pkg-config
${_make} install-pkgconfigDATA

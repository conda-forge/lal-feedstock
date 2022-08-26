#!/bin/bash

set -e

# macros
_make="make -j ${CPU_COUNT} V=1 VERBOSE=1"

# use out-of-tree build
mkdir -pv _build
cd _build

# add all of the common instructions
. ${RECIPE_DIR}/common.sh

# configure
${SRC_DIR}/configure \
	--disable-doxygen \
	--disable-gcc-flags \
	--disable-python \
	--disable-swig-octave \
	--disable-swig-python \
	--enable-swig-iface \
	--prefix="${PREFIX}" \
	--with-hdf5=yes \
	${CONFIGURE_ARGS} \
;

# build
${_make} HDF5_LIBS="${HDF5_LIBS}"

# test
if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" || "${CROSSCOMPILING_EMULATOR}" != "" ]]; then
	${_make} check
fi

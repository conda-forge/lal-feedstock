#!/bin/bash

set -ex

# macros
_make="make -j ${CPU_COUNT} V=1 VERBOSE=1"

cd _build

# install library and headers
${_make} -C lib install HDF5_LIBS="-L${PREFIX} -lhdf5 -lhdf5_hl"

# install SWIG binding definitions and headers
${_make} -C swig install-data

# install pkg-config
${_make} install-pkgconfigDATA

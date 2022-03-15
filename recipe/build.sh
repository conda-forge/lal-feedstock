#!/bin/bash

set -e

# use out-of-tree build
mkdir -pv _build
cd _build

# replace package name in debug-prefix-map with source name
export CFLAGS=$(
   echo ${CFLAGS:-} |
   sed -E 's|'\/usr\/local\/src\/conda\/${PKG_NAME}'|/usr/local/src/conda/lal|g'
)

# select FFT implementation
if [[ "${fft_impl}" == "mkl" ]]; then
    FFT_CONFIG_ARGS="--disable-static --enable-intelfft"
else
    FFT_CONFIG_ARGS=""
fi

# only link libraries we actually use
export GSL_LIBS="-L${PREFIX}/lib -lgsl"
export HDF5_LIBS="-L${PREFIX}/lib -lhdf5 -lhdf5_hl"

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
	${FFT_CONFIG_ARGS} \
;

# build
make -j ${CPU_COUNT} V=1 VERBOSE=1 HDF5_LIBS="${HDF5_LIBS}"

# test
if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" ]]; then
	make -j ${CPU_COUNT} V=1 VERBOSE=1 check
fi

#!/bin/bash

set -e

# use out-of-tree build
mkdir -pv _build
cd _build

# select FFT implementation
if [[ "${fft_impl}" == "mkl" ]]; then
    FFT_CONFIG_ARGS="--disable-static --enable-intelfft"
else
    FFT_CONFIG_ARGS=""
fi

# only link libraries we actually use
export GSL_LIBS="-L${PREFIX}/lib -lgsl"

# configure
${SRC_DIR}/configure \
	--disable-doxygen \
	--disable-gcc-flags \
	--disable-python \
	--disable-swig-octave \
	--disable-swig-python \
	--enable-swig-iface \
	--prefix="${PREFIX}" \
	${FFT_CONFIG_ARGS} \
;

# build
make -j ${CPU_COUNT} V=1 VERBOSE=1

# test
make -j ${CPU_COUNT} V=1 VERBOSE=1 check

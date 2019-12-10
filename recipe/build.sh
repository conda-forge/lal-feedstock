#!/bin/bash

set -e

# select FFT implementation
if [[ "${fft_impl}" == "mkl" ]]; then
    FFT_CONFIG_ARGS="--disable-static --enable-intelfft"
else
    FFT_CONFIG_ARGS=""
fi

# only link libraries we actually use
export GSL_LIBS="-L${PREFIX}/lib -lgsl"

# configure
./configure \
	--prefix="${PREFIX}" \
	--disable-gcc-flags \
	--disable-python \
	--disable-swig-octave \
	--disable-swig-python \
	--enable-silent-rules \
	--enable-swig-iface \
	${FFT_CONFIG_ARGS}

# build
make -j ${CPU_COUNT}

# test
make -j ${CPU_COUNT} check

# install
make install

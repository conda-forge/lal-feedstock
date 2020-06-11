#!/bin/bash

set -e

mkdir -pv ${TMPDIR:=${SRC_DIR}/_tmp}
export TMPDIR
export PKG_CONFIG_PATH="${PREFIX}/lib/pkgconfig:${PREFIX}/share/pkgconfig:${PKG_CONFIG_PATH}"

# select FFT implementation
if [[ "${fft_impl}" == "mkl" ]]; then
    FFT_CONFIG_ARGS="--disable-static --enable-intelfft"
else
    FFT_CONFIG_ARGS=""
fi

echo ${PREFIX}
ls ${PREFIX}
ld --verbose | grep SEARCH_DIR | tr -s ' ;' \\012

# only link libraries we actually use
export GSL_LIBS="-L${PREFIX}/lib -lgsl"

# configure
./configure \
	--disable-gcc-flags \
	--disable-python \
	--disable-swig-octave \
	--disable-swig-python \
	--enable-swig-iface \
	--prefix="${PREFIX}" \
	${FFT_CONFIG_ARGS}

# build
make -j ${CPU_COUNT} VERBOSE=1 V=1

# test (no `bc` on windows, so skip for now)
if [ "$(uname)" == "Linux" -o "$(uname)" == "Darwin" ]; then
	make -j ${CPU_COUNT} VERBOSE=1 V=1 check
fi

# install
make -j ${CPU_COUNT} VERBOSE=1 V=1 install

#!/bin/bash
#
# Configure, built, test, and install the Python language bindings
# for a LALSuite subpackage.
#

set -ex

# macros
_make="make -j ${CPU_COUNT} V=1 VERBOSE=1"

# build python in a sub-directory using a copy of the C build
_builddir="_build${PY_VER}"
cp -r _build ${_builddir}
cd ${_builddir}

# replace package name in debug-prefix-map with source name
export CFLAGS=$(
   echo ${CFLAGS:-} |
   sed -E 's|'\/usr\/local\/src\/conda\/${PKG_NAME}'|/usr/local/src/conda/lal|g'
)

# if we're using MKL, the C library will have been built with
# --enable-intelfft, so we have to use that here as well
if [[ "${fft_impl}" == "mkl" ]]; then
    FFT_CONFIG_ARGS="--disable-static --enable-intelfft"
else
    FFT_CONFIG_ARGS=""
fi

# only link libraries we actually use
export GSL_LIBS="-L${PREFIX}/lib -lgsl"

# configure only python bindings and pure-python extras
${SRC_DIR}/configure \
	--disable-doxygen \
	--disable-gcc-flags \
	--disable-swig-iface \
	--enable-python \
	--enable-swig-python \
	--prefix=$PREFIX \
	${FFT_CONFIG_ARGS} \
;

# patch out dependency_libs from libtool archive to prevent overlinking
sed -i.tmp '/^dependency_libs/d' lib/liblal.la
sed -i.tmp '/^dependency_libs/d' lib/support/liblalsupport.la

# build
${_make} -C swig LIBS=""
${_make} -C python LIBS=""

# test
if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" || "${CROSSCOMPILING_EMULATOR}" != "" ]]; then
	${_make} check -C swig
fi

# install
${_make} -C swig install-exec  # swig bindings
${_make} -C python install  # pure-python extras

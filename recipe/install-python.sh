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

# add all of the common instructions
. ${RECIPE_DIR}/common.sh

# configure only python bindings and pure-python extras
${SRC_DIR}/configure \
	--disable-doxygen \
	--disable-gcc-flags \
	--disable-swig-iface \
	--enable-python \
	--enable-swig-python \
	--prefix=$PREFIX \
	${CONFIGURE_ARGS} \
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

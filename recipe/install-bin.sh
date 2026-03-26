#!/bin/bash
#
# Configure, build, test, and install the LAL executables
# (including the Python scripts).
#

set -ex

. ${RECIPE_DIR}/common.sh

# build in a sub-directory using a copy of the C build
_builddir="_build${PY_VER}_bin"
cp -r _build ${_builddir}
cd ${_builddir}

# configure with Python support (as for python-lal) so that the Python
# scripts are included
${SRC_DIR}/configure \
  ${CONFIGURE_ARGS} \
  --disable-swig-iface \
  --enable-python \
  --enable-swig-python \
;

# patch out dependency_libs from libtool archive to prevent overlinking
sed -i.tmp '/^dependency_libs/d' lib/liblal.la
sed -i.tmp '/^dependency_libs/d' lib/support/liblalsupport.la

# copy in the built Python bindings from the installed Python package so that the Python scripts can find them
# (bytecode is excluded as it was compiled from the $PREFIX sources)
rsync -av --exclude='__pycache__' ${SP_DIR}/lal python/

# build
${_make} -C bin

# test
if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" ]]; then
  ${_make} check -C bin
fi

# install binaries
${_make} install -C bin

# install system configuration files
${_make} install-sysconfDATA

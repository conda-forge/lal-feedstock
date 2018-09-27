#!/bin/bash

set -e

# build only python bindings and pure-python extras
./configure \
	--prefix=$PREFIX \
	--disable-doxygen \
	--disable-swig \
	--enable-swig-python \
	--enable-python \
	--disable-gcc-flags \
	--enable-silent-rules
make -j ${CPU_COUNT}

# test
make -j ${CPU_COUNT} -C test/python check

# install
make -j ${CPU_COUNT} -C swig install-exec-am  # swig bindings
make -j ${CPU_COUNT} -C python install  # pure-python extras

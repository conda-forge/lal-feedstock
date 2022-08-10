#!/bin/bash

set -ex

# install from python build directory
_pybuilddir="_build${PY_VER}"
cd ${_pybuilddir}

# test binaries
if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" || "${CROSSCOMPILING_EMULATOR}" != "" ]]; then
	make -j ${CPU_COUNT} V=1 VERBOSE=1 check -C bin
fi

# install binaries
make -j ${CPU_COUNT} V=1 VERBOSE=1 install -C bin

# install system configuration files
make -j ${CPU_COUNT} V=1 VERBOSE=1 install-sysconfDATA

#!/bin/bash

set -e

# top level build has done everything, so just test it, and install it
make -j ${CPU_COUNT} check
make install

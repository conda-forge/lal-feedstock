#!/bin/bash

set -e

# copy everything from fake build to actual install
cp -vr ${SRC_DIR}/build/* ${PREFIX}/

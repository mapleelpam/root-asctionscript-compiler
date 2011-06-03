#!/bin/bash

BINARY_PATH=$(dirname $0)/bin/
BUILD_FORLDER=build_tmp

rm -rf ${BUILD_FORLDER}
mkdir ${BUILD_FORLDER}
cd ${BUILD_FORLDER}

export PATH=${BINARY_PATH}:${PATH}
cmake ..
make asc.jar pnc
make runtest-complex

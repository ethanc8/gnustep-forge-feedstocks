#!/bin/bash

export CC="clang"
export CXX="clang++"
export LD="$(which ld.lld)"
export LDFLAGS="-fuse-ld=$LD"

mkdir build
cd build

extra_cmake_args=(
    -DCMAKE_C_COMPILER="${CC}"
    -DCMAKE_CXX_COMPILER="${CXX}"
    -DCMAKE_ASM_COMPILER="${CC}"
    -DCMAKE_LINKER="${LD}"
    -DCMAKE_MODULE_LINKER_FLAGS="${LDFLAGS}"
    -DINSTALL_PRIVATE_HEADERS=ON
    -DTESTS=OFF
)

cmake -GNinja ${CMAKE_ARGS} "${extra_cmake_args[@]}" \
    -DCMAKE_PREFIX_PATH="$PREFIX" \
    -DCMAKE_INSTALL_PREFIX="$PREFIX" \
    "$SRC_DIR"

ninja
ninja install

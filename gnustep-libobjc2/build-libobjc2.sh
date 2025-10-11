#!/bin/bash

source "$PREFIX/GNUstep/System/Library/Makefiles/GNUstep.sh"

export CC="clang"
export CXX="clang++"
export LD="$(which ld.gold)"
export LDFLAGS="-fuse-ld=$LD"

# pre-create some directories
mkdir -p "$PREFIX/GNUstep/Local/Library/Libraries"
mkdir -p "$PREFIX/GNUstep/Local/Library/Headers"

mkdir build
cd build

extra_cmake_args=(
    -DGNUSTEP_INSTALL_TYPE=SYSTEM
    -DCMAKE_C_COMPILER="${CC}"
    -DCMAKE_CXX_COMPILER="${CXX}"
    -DCMAKE_ASM_COMPILER="${CC}"
    -DCMAKE_LINKER="${LD}"
    -DCMAKE_MODULE_LINKER_FLAGS="${LDFLAGS}"
    -DEMBEDDED_BLOCKS_RUNTIME=OFF
)

cmake -GNinja ${CMAKE_ARGS} "${extra_cmake_args[@]}" \
    "$SRC_DIR" \
    # -DCMAKE_PREFIX_PATH="$PREFIX" \
    # -DCMAKE_INSTALL_PREFIX="$PREFIX" \

ninja
ninja install

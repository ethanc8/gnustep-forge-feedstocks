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
    -DCMAKE_C_COMPILER="${CC}"
    -DCMAKE_CXX_COMPILER="${CXX}"
    -DCMAKE_ASM_COMPILER="${CC}"
    -DCMAKE_LINKER="${LD}"
    -DCMAKE_MODULE_LINKER_FLAGS="${LDFLAGS}"
    # -DCMAKE_INSTALL_BINDIR="$(gnustep-config --variable=GNUSTEP_SYSTEM_TOOLS)"
    # -DCMAKE_INSTALL_LIBDIR="$(gnustep-config --variable=GNUSTEP_SYSTEM_LIBRARIES)"
    # -DCMAKE_INSTALL_INCLUDEDIR="$(gnustep-config --variable=GNUSTEP_SYSTEM_HEADERS)"
    # -DCMAKE_INSTALL_OLDINCLUDEDIR="$(gnustep-config --variable=GNUSTEP_SYSTEM_HEADERS)"
    # -DCMAKE_INSTALL_MANDIR="$(gnustep-config --variable=GNUSTEP_SYSTEM_DOC_MAN)"
    # -DCMAKE_INSTALL_INFODIR="$(gnustep-config --variable=GNUSTEP_SYSTEM_DOC_INFO)"
    # -DCMAKE_INSTALL_DOCDIR="$(gnustep-config --variable=GNUSTEP_SYSTEM_DOC)"
    # -DCMAKE_INSTALL_DATAROOTDIR="$(gnustep-config --variable=GNUSTEP_SYSTEM_LIBRARY)"
    -DINSTALL_PRIVATE_HEADERS=ON
    -DTESTS=OFF
)

cmake -GNinja ${CMAKE_ARGS} "${extra_cmake_args[@]}" \
    -DCMAKE_PREFIX_PATH="$PREFIX" \
    -DCMAKE_INSTALL_PREFIX="$PREFIX" \
    "$SRC_DIR"

ninja
ninja install

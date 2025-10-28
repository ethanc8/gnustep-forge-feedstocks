#!/bin/bash

source "$PREFIX/GNUstep/System/Library/Makefiles/GNUstep.sh"

export CC="clang"
export CXX="clang++"
export LD="$(which ld.gold)"

# Build

./configure --disable-newkvo --with-libiconv-library="$PREFIX/lib"
make GNUSTEP_INSTALLATION_DOMAIN=SYSTEM debug=yes || exit 1
make GNUSTEP_INSTALLATION_DOMAIN=SYSTEM install

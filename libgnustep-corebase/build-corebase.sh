#!/bin/bash

source "$PREFIX/GNUstep/System/Library/Makefiles/GNUstep.sh"

export CC="clang"
export CXX="clang++"
export LD="$(which ld.lld)"

# Build

CFLAGS="$(gnustep-config --objc-flags)" OBJCFLAGS="$(gnustep-config --objc-flags)" LDFLAGS="$(gnustep-config --objc-libs)" ./configure
make GNUSTEP_INSTALLATION_DOMAIN=SYSTEM debug=yes || exit 1
make GNUSTEP_INSTALLATION_DOMAIN=SYSTEM install

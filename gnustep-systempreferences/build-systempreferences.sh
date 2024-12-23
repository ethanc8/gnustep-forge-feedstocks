#!/bin/bash

source "$PREFIX/GNUstep/System/Library/Makefiles/GNUstep.sh"

export CC="clang"
export CXX="clang++"
export LD="$(which ld.gold)"
export LDFLAGS="-fuse-ld=$LD $(gnustep-config --objc-libs)"

# Build

# On Linux this uses X11 + Cairo
make GNUSTEP_INSTALLATION_DOMAIN=SYSTEM debug=yes || exit 1
make GNUSTEP_INSTALLATION_DOMAIN=SYSTEM install

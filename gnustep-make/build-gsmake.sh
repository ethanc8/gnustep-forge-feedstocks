#!/bin/bash

export CC="clang"
export CXX="clang++"
export LD="$(which lld)"

extra_configure_args=(
    --with-library-combo=ng-gnu-gnu
    --enable-objc-arc
    --enable-native-objc-exceptions
)

./configure --with-layout=gnustep --prefix="$PREFIX/GNUstep" "${extra_configure_args[@]}"

make
make install

# Make activation and deactivation scripts
mkdir -p "$PREFIX/etc/conda/activate.d"
cp "$PREFIX/GNUstep/System/Library/Makefiles/GNUstep.sh" "$PREFIX/etc/conda/activate.d/10-activate-gnustep.sh"

mkdir -p "$PREFIX/etc/conda/deactivate.d"
cp "$PREFIX/GNUstep/System/Library/Makefiles/GNUstep-reset.sh" "$PREFIX/etc/conda/deactivate.d/10-deactivate-gnustep.sh"

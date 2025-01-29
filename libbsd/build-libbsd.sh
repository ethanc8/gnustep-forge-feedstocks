#!/bin/bash

./configure --prefix="$PREFIX" --libdir="$PREFIX/lib"
make
make install

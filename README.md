# gnustep-forge

To build any individual package locally, `cd` to its directory and use
```
rattler-build build -c https://prefix.dev/gnustep-forge -c conda-forge
```

## Acknowledgements

This forge's build scripts are based on Wolf Vollprecht's https://github.com/wolfv/rust-forge.

## TODO

* [X] Switch to LLD
* [X] Finish upgrading to latest versions as of October 2025
* [ ] Have libobjc2 depend on libdispatch's BlocksRuntime
* [ ] Package a lot of other important GNUstep libraries
* [ ] Make separate packages for the documentation
* [ ] Produce packages for other platforms
* [ ] Make it cross-compile between architectures
* [ ] Make the distribution system, producing AppImages, EXEs, etc.

# Guide

Hi everyone,

I wanted to introduce my recent work on Conda packaging of GNUstep. Conda, and its relatives `mamba`, `micromamba`, and `pixi`, are cross-platform package managers which can manage "environments". These environments are similar to Python's "virtual environments", as they allow you to create environments that contain certain packages, which will only be available after the environment is activated. This way, you can install different versions of the same software in different environments, reduce dependency hell, and share your environments with others in order to allow them to easily get a working setup. Unlike Python's "virtual environments", it is able to manage both Python software and native software like shared objects, configuration files, and native executables. This has made it very popular amongst Python datascience and machine learning users which often need to manage Python packages with C, Rust, and Fortran dependencies tightly coupled to the Python packages and the Python interpreter. Conda, along with `nix` and `guix`, are the only package managers I know of that are able to have multiple environments which stack on top of the user's operating system (as opposed to a chroot).

For GNUstep, this can make it a lot easier for new users to get started, and it could also make it easier to distribute GNUstep software. GNUstep libraries could be distributed as conda packages, and GNUstep apps could be distributed as conda packages which could then be turned into other formats. Conda environments can already be converted into AppImages, but the scripts to do so are kind of outdated and depend on the Anaconda `defaults` channel and the Miniconda installer. I intend to work on improving that and to make more output formats.

I have packaged the core GNUstep software (in the `ng-gnu-gnu` configuration; Clang 18 as compiler, `ld.gold` as linker, `libdispatch`, `libobjc2` as Objective-C runtime, and using GNUstep Base for Foundation and GNUstep GUI for AppKit) on top of `conda-forge` for `linux-64` (glibc Linux on x86_64). glibc Linux on arm64 and ppc64le, macOS on x86_64 and arm64, and Windows on x86_64 are also supported by `conda-forge`. The package definitions are available at https://github.com/ethanc8/gnustep-forge-feedstocks/ and the binary packages are available at https://prefix.dev/channels/gnustep-forge.

## Remaining contents

* More information on Conda ecosystem
* TODO
* Quick start/tutorial
* Packaging and distributing your own software

## More information on Conda ecosystem

There are two "distributions" of conda packages in the package-repository sense. Anaconda, Inc. publishes the Anaconda and Miniconda installers, and publish the `defaults` channel (package repository). It is released with a EULA that prohibits certain commercial uses, and is missing many useful packages. Meanwhile, `conda-forge` is a community distribution which includes many more packages and is quite popular, but is ABI-incompatible with `defaults`. They publish the Miniforge installer.

`conda` is written in Python, and is kind of slow. `mamba` is a faster reimplementation of `conda` in C++. `micromamba` is based on `mamba` but does not need its own conda environment with Python installed in order to work. `pixi` is a more `npm`/`cargo`-style package manager, which is very fast and written in Rust, and which ties environments to specific projects.

Packages are either specified in `meta.yaml` files (which include semantically significant and Turing-complete comments!) and are built by `conda-build`, or are specified in `recipe.yaml` files (which are much saner) and built by `rattler-build` (implemented in Rust).

## TODO

* [ ] Figure out application bundling (fix AppImage, see if we can do Flatpak, Snap, portable `.exe`, `.msi`, and `.msix`)
* [ ] Ensure runtime dependencies are properly specified
* [ ] Fix cross-compilation on GNU/Linux
* [ ] Support Windows (should we do MinGW or MSVC?)
* [ ] Support macOS (should we do `ng-gnu-gnu`, `apple-gnu-gnu`, or `apple-apple-apple`?)
* [ ] Support `pixi build`

## Quick start/tutorial

This will guide you through setting up a basic GNUstep environment and verifying that it works by installing SystemPreferences.app in it and running it. Right now it only works on x86_64 glibc Linux.

First you should download Miniforge:

```bash
wget "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
bash Miniforge3-$(uname)-$(uname -m).sh
rm Miniforge3-$(uname)-$(uname -m).sh
```

Close and reopen your shell, and run:

```bash
# Prevent Conda from polluting your environment when you're not working on Conda-managed projects.
conda config --set auto_activate_base false
```

Create a file named `environment.yml` and in it, write: (you can omit the comments if you want)

```yaml
name: gnustep
channels: # package repositories
  - https://repo.prefix.dev/gnustep-forge # My GNUstep packages
  - conda-forge # Community distribution of conda packages
  - nodefaults # Disable the `defaults` channel if for some reason it's enabled
dependencies:
  # GNUstep dependencies
  - gnustep-make
  - gnustep-libdispatch
  - gnustep-libobjc2
  - libgnustep-base
  - libgnustep-gui
  - libgnustep-back
  - imagemagick # This is here because I need to fix the dependency list
  - clang=18
  - clangxx=18
  # Applications
  - gnustep-systempreferences
```

Now, you can use `conda` or `mamba` to install the dependencies:

```bash
mamba env create -f environment.yml
mamba activate gnustep
```

If you modify `environment.yml` after creating the environment, you need to run

```bash
mamba env update -f environment.yml
```

Now, you can test out SystemPreferences:

```bash
SystemPreferences
```

Remember that the environment must be activated using `mamba activate gnustep` every time you open a new shell.

You can deactivate the environment using `mamba deactivate`. Then GNUstep should no longer be present. (I set it up to call `GNUstep-reset.sh`; this might not work exactly as expected. It's better to simply open a new shell.)

All the packages are built with debug symbols and headers included, so you can try them out.

The GNUstep installation is located at `$CONDA_PREFIX/GNUstep`. On my system, that's `~/miniforge3/envs/gnustep/GNUstep`.

## Packaging and distributing your own software

Clone my repository https://github.com/ethanc8/gnustep-forge-feedstocks/, and copy the `gnustep-systempreferences` directory into a new directory with the name of your software.

These are the requirements I usually specify in `recipe.yaml`:

```yaml
requirements:
  build:
    - ${{ compiler('c') }}
    - ${{ compiler('cxx') }}
    - ${{ stdlib('c') }}
    - ninja # only for CMake projects
  host:
    - ${{ stdlib('c') }}
    - gnustep-make
    - gnustep-libobjc2
    - gnustep-libdispatch
    - libgnustep-base
    - libgnustep-gui
    - libgnustep-back
```

If you have more dependencies, specify them in the `host` section in addition to the ones above.

Most of the changes you'll need to make are in `recipe.yaml`: the name, the GitHub URLs (or the homepage and source tarball download URL if you don't use GitHub), the version number, and the Git tag (or commit hash, etc). Also remember to change the metadata at the bottom of `recipe.yaml`, and make sure that the `about.license_file` is properly specified (this is usually `COPYING` or `LICENSE`).

If you need to add more build steps, such as running `./configure`, just modify `build-systempreferences.sh` (you can rename this if you want, but you'll also have to change the name of the build script in `recipe.yaml`).

You can now build the package using

```bash
rattler-build build -c conda-forge -c https://prefix.dev/gnustep-forge
```

The built package will be in `output/linux-64`.

If you want to publish it to https://prefix.dev/gnustep-forge, submit your package as a pull request to my repo and I will look over and merge it. If you want to make your own channel and host it at prefix.dev:

1. Sign in to https://prefix.dev/.
2. Create a channel at https://prefix.dev/channels/create.
3. Modify `.github/workflows/build.yml`:
```yaml
    - name: Run code in changed subdirectories
      shell: bash
      env:
        TARGET_PLATFORM: ${{ matrix.target }}

      run: |
        rattler-build build --recipe-dir . \
          --skip-existing=all --target-platform=$TARGET_PLATFORM \
          -c conda-forge -c https://prefix.dev/gnustep-forge -c https://prefix.dev/<<<NAME OF YOUR CHANNEL>>>
      #   --experimental $(for file in **/variants.yaml; do echo "-m$file"; done) 
      # no longer necessary because it should be discovered by default

    - name: Upload all packages
      shell: bash
      # do not upload on PR
      if: github.event_name == 'push'
      env:
        PREFIX_API_KEY: ${{ secrets.PREFIX_API_KEY }}
      run: |
        # ignore errors because we want to ignore duplicate packages
        for file in output/**/*.conda; do
          rattler-build upload prefix -c gnustep-forge -c <<<NAME OF YOUR CHANNEL>>> "$file" || true
        done
```
4. Commit your changes and push them to a GitHub repository.
5. Grab an API key from https://prefix.dev/settings/api_keys and set it as a repository secret named `PREFIX_API_KEY` in the GitHub repository (for me, the appropriate settings page is at https://github.com/ethanc8/gnustep-forge-feedstocks/settings/secrets/actions)
6. Enable GitHub Actions on your GitHub repository.

You can also self-host the channel or host it at anaconda.org, but I don't know how to do that. You should be able to find instructions online on how to do it.

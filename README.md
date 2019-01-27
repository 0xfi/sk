<div align="center">
    <img src="img/logo.png">
</div>

- [Introduction](#introduction)
- [`sk` Tool](#sk-tool)
  - [Configuration](#configuration)
    - [`PREFIX`](#prefix)
    - [`TARGET`](#target)
    - [`V_BINUTILS`](#vbinutils)
    - [`V_GCC`](#vgcc)
  - [`help`](#help)
  - [`setup`](#setup)
- [Documentation](#documentation)
- [Credits](#credits)

# Introduction
sk is a simple kernel designed mostly for education.

I'll write more about its history, etc. later, I don't feel like it right now.

# `sk` Tool
The script `sk` is responsible for managing all of the production and managing
of `sk` builds and using them. `sk` is an entirely independant tool that sets
up everything one would need to use it. The only requirement to use it is `curl`
for downloading the files needed to build the cross-compiler.

Each command can be called by running `./sk <command>` where `<command>` is the
command you want to run.

## Configuration
All configuration of `sk` is done through the `sk.config` file in the root of the repository.

**NOTE**
`sk` *must* be run from the root of the repository for everything to work as
expected, there are currently *no* checks to make sure this is true and running
it outside of the directory will break everything.

### `PREFIX`
The root location for the cross-compiler. It's ill-advised to change this but
if you want to make the cross-compiler available throughout the system it can
be done by changing the location to `/usr/bin/cross`.

The default is `$PWD/cross`

### `TARGET`
The architecture to compile for. This effects not only the architecture the
cross-compiler is built to compile to but also which arch-based source files
are included during compilation and the various settings that are used when
building sk.

The default is `i686-elf`.

### `V_BINUTILS`
The version of binutils to use.

The default is `2.31`.

### `V_GCC`
The version of GCC to use.

The default is `8.2.0`.

## `help`
```
USAGE
    ./make [options] command

COMMANDS
    help
        Print this help message.

    config
        Download, configure, and compile the cross-compiler (gcc and binutils).

ABOUT
    For setting this up I want minimal dependancies so part of that is doing as
    much as possible from scratch, and one of those things was the build tool.
    Instead of using GNU Make, I implemented by own "version" of make which is
    designed specifically for this project.

SEE ALSO
    make
    gen
```

## `setup`
The `setup` command will download the specified version of gcc and binutils and
will then compile these for `$TARGET` system into the `$PREFIX/build` directory
and install the cross-compiler executables into `$PREFIX/bin`. If any error is
detected the script will hault and an error message will be returned.

# Documentation
**TODO**

# Credits
Thanks to Warp, Void, and of course Bisqwit from the 
[Bisqwit](https://youtube.com/Bisqwit) Discord Server for
their help with this project.

Also thanks to [OSDev](https://wiki.osdev.org) 
for having such great documentation for how to get started
and for having great reference materials.

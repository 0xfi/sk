#!/bin/bash

PREFIX="$PWD/cross"
TARGET="i686-elf"
PATH="$PREFIX/bin:$PATH"

V_BINUTILS="2.31"
V_GCC="8.2.0"

die() {
    echo "fatal: $1"
    exit ${2-1}
}

_help() {
cat <<EOF
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
EOF
}

_config() {
    rm -rf "$PREFIX/build"
    mkdir -p "$PREFIX/build"
    cd "$PREFIX/build"

    curl -L "https://ftp.gnu.org/gnu/binutils/binutils-$V_BINUTILS.tar.gz" \
        -o binutils.tar.gz
    tar xf binutils.tar.gz && rm binutils.tar.gz
    mkdir -p build-binutils && cd build-binutils
    ../binutils/configure --target=$TARGET \
        --prefix="$PREFIX" --with-sysroot --disable-nls --disable-werror
    make && make install
    cd ..

    which -- $TARGET-as || die "$TARGET-as is not in PATH"

    curl -L "https://ftp.gnu.org/gnu/gcc/gcc-$V_GCC/gcc-$V_GCC.tar.gz" \
        -o gcc.tar.gz
    tar xf gcc.tar.gz && rm gcc.tar.gz
    mkdir build-gcc && cd build-gcc
    ../gcc/configure --target=$TARGET --prefix="$" \PREFIX
        --disable-nls --enable-languages=c --without-headers
    make all-gcc all-target-libgcc install-gcc install-target-libgcc
}

for arg in "$@"; do
    case "$arg" in
        config|help)
            cmds="$cmds $arg";;
        *) die "Unknown command '$arg'";;
    esac
done

for cmd in $cmds; do
    _$cmd
done

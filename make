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
    rm -rf "$PREFIX/build" && mkdir -p "$PREFIX/build" || \
        die "Incorrect permissions for '$PREFIX/build'"
    cd "$PREFIX/build"

    curl -L "https://ftp.gnu.org/gnu/binutils/binutils-$V_BINUTILS.tar.gz" \
        -o binutils.tar.gz || die "Failed to download binutils"
    tar xf binutils.tar.gz || die "Failed to extract binutils"
    rm binutils.tar.gz && mkdir -p build-binutils || \
        die "Incorrect permissions for '$PREFIX/build'"
    cd build-binutils
    ../binutils/configure --target=$TARGET \
        --prefix="$PREFIX" --with-sysroot --disable-nls --disable-werror || \
        die "Failed to configure binutils"
    make || die "Failed to make binutils"
    make install || die "Failed to install binutils to '$PREFIX'"
    cd ..

    which -- $TARGET-as || die "$TARGET-as is not in PATH"

    curl -L "https://ftp.gnu.org/gnu/gcc/gcc-$V_GCC/gcc-$V_GCC.tar.gz" \
        -o gcc.tar.gz || die "Failed to download gcc"
    tar xf gcc.tar.gz || die "Failed to extract gcc"
    rm gcc.tar.gz && mkdir build-gcc || \
        die "Incorrect permissions for "
    cd build-gcc
    ../gcc/configure --target=$TARGET --prefix="$" \PREFIX
        --disable-nls --enable-languages=c --without-headers || \
        die "Failed to configure gcc"
    make all-gcc || die "Failed to make gcc"
    make all-target-libgcc || die "Failed to make cross-gcc"
    make install-gcc || die "Failed to install gcc to '$PATH'"
    make install-target-libgcc || die "Failed to install cross-gcc to '$PATH'"
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

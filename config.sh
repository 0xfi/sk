#############
##         ##
## General ##
##         ##
#############

# Target architecture
TARGET="i686-elf"

####################
##                ##
## Cross Compiler ##
##                ##
####################

# Subdirectory to install the cross-compiler to
CC_PREFIX="cross"

# Binutils version and URL
CC_BINUTILS="2.31"
CC_BINUTILS_URL="https://ftp.gnu.org/gnu/binutils/binutils-%s.tar.gz"

# GCC version and URL
CC_GCC="8.20"
CC_GCC_URL="https://ftp.gnu.org/gnu/gcc/gcc-%s/gcc-%s.tar.gz"

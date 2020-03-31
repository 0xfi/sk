# This is free and unencumbered software released into the public domain.

# Anyone is free to copy, modify, publish, use, compile, sell, or
# distribute this software, either in source code form or as a compiled
# binary, for any purpose, commercial or non-commercial, and by any
# means.

# In jurisdictions that recognize copyright laws, the author or authors
# of this software dedicate any and all copyright interest in the
# software to the public domain. We make this dedication for the benefit
# of the public at large and to the detriment of our heirs and
# successors. We intend this dedication to be an overt act of
# relinquishment in perpetuity of all present and future rights to this
# software under copyright law.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
# OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
# ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.

# For more information, please refer to <http://unlicense.org/>

NAME := sk

# Alias all of the repository's directories.
SRC := src
BIN := bin
ETC := etc
MAN := man
ISO := boot
INC := include

# Find sources and generate targets for object-level compilation.
INCLUDE := $(shell find $(INC) -name *.h)
SOURCES := $(shell find $(SRC) -name *.c -or name *.S)
OBJECTS := $(SOURCES:%=$(BIN)/%.o)

# Select the architecture and generate the target triplet.
ARCH := x86_64
TARGET := $(ARCH)-linux

# Alias architecture specific tools.
CC := $(TARGET)-gnu-gcc
LD := $(TARGET)-gnu-ld
EM := qemu-system-$(ARCH)

# Target elf64 (x86_64) architecture for the assembler.
ASFLAGS :=  -f elf64

# Optimize at level 2, include all normal warnings, include extra warnings, be
# pedantic, use the C99 standard, disable sse instructions, disable sse2
# instructions, do not use the "red zone", compile with the kernel model in
# mind, assert that there will not be an available standard library nor will
# entry point necessarily be `main`, disable built in stack protection, ensure
# that the compiler places the stack frame pointer in a register.
CCFLAGS := -Wall -Wextra -pedantic -std=c99 -mno-sse -mno-sse2 -I$(INCLUDE) \
           -mno-redzone -mcmodel=kernel -ffreestanding -fno-stack-protector \ 
		   -fno-omit-frame-pointer -c -O2
LDFLAGS := -O2 -nostdlib -no-pie -T linker.ld
EMFLAGS := -m 2G -enable-kvm -smp 4 -debugcon stdio

# Inform Make that these targets aren't providing actual files given their
# names.
.PHONY: all clean wipe run

# Set the default target to be the disk image.
all: $(NAME).iso

# Generate a disk image from the GRUB configuration and linked executable.
$(NAME).iso: $(BIN)/$(NAME).elf $(ETC)/grub.cfg
	mkdir -p $(ISO)/boot/grub
	cp $(BIN)/$(NAME).elf $(ISO)/boot
	grub-mkrescue -o $(NAME).iso $(ISO)

# link together compiled objects into the kernel executable.
$(BIN)/$(NAME).elf: $(OBJECTS) $(INCLUDE)
	$(LD) $(LDFLAGS) 

# Build a C file into an object.
$(BIN)/%.o: %.c
	$(CC) $(CCFLAGS) $< -o $@

# Build an assembler file into an object.
$(BIN)%.o: %.S
	$(AS) $(ASFLAGS) $< -o $@

# Remove _everything_ untracked from the repostiory.
wipe: clean
	rm -rf $(ISO) $(NAME).iso

# Remove intermediate object files.
clean:
	rm -rf $(BIN) 

# Run disk image through the emulator (QEMU).
run: $(NAME).iso
	$(EM) $(EMFLAGS) -cdrom $(NAME).iso

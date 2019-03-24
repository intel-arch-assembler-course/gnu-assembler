ASSEMBLER= as
# 
# If you want debug symbols add -g flag
#
# ASSEMBLER_FLAGS= --32 -g
#
ASSEMBLER_FLAGS= --32

LINKER= ld
LINKER_FLAGS= -m elf_i386 --dynamic-linker=/lib32/ld-linux.so.2

LIBS= -lc


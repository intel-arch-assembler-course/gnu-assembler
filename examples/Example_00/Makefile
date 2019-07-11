include ../../config.mk

ASM_FLAGS= $(ASSEMBLER_FLAGS) -I../../include

all: a

a: a.o
	$(LINKER) $(LINKER_FLAGS) -o $@ $^ $(LIBS)


%.o: %.s
	$(ASSEMBLER) $(ASM_FLAGS) -o $@ $<





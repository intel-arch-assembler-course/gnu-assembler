include ../../config.mk

ASM_FLAGS= $(ASSEMBLER_FLAGS) -I../../include

all: outchar_test

outchar_test: outchar_test.o
	$(LINKER) $(LINKER_FLAGS) -o $@ $^ $(LIBS)


%.o: %.s
	$(ASSEMBLER) $(ASM_FLAGS) -o $@ $<





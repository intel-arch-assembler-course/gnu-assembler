include ../../config.mk

ASM_FLAGS= $(ASSEMBLER_FLAGS) -I../../include

all: inputstr_test

inputstr_test: inputstr_test.o
	$(LINKER) $(LINKER_FLAGS) -o $@ $^ $(LIBS)


%.o: %.s
	$(ASSEMBLER) $(ASM_FLAGS) -o $@ $<





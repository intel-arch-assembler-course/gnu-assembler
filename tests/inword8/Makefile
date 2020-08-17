include ../../config.mk

ASM_FLAGS= $(ASSEMBLER_FLAGS) -I../../include

all: inword8_test

inword8_test: inword8_test.o
	$(LINKER) $(LINKER_FLAGS) -o $@ $^ $(LIBS)


%.o: %.s
	$(ASSEMBLER) $(ASM_FLAGS) -o $@ $<





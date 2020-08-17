include ../../config.mk

ASM_FLAGS= $(ASSEMBLER_FLAGS) -I../../include

all: inint16_test

inint16_test: inint16_test.o
	$(LINKER) $(LINKER_FLAGS) -o $@ $^ $(LIBS)


%.o: %.s
	$(ASSEMBLER) $(ASM_FLAGS) -o $@ $<





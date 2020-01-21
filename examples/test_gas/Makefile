include ../../config.mk

ASM_FLAGS= -g $(ASSEMBLER_FLAGS) -I../../include

all: test_gas

test_gas: test_gas.o
	$(LINKER) $(LINKER_FLAGS) -o $@ $^ $(LIBS)


%.o: %.s
	$(ASSEMBLER) $(ASM_FLAGS) -o $@ $<





include ../../config.mk

ASSEMBLER_FLAGS= $(ASSEMBLER_FLAGS) -I../../include

all: a

a: a.o
	$(LINKER) $(LINKER_FLAGS) -o $@ $^ $(LIBS)


%.o: %.s
	$(ASSEMBLER) $(ASSEMBLER_FLAGS) -o $@ $<





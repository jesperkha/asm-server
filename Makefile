ASM_SOURCES := $(wildcard *.asm)
OBJ_FILES := $(patsubst %.asm,bin/%.o,$(ASM_SOURCES))
BIN_DIR := bin
TARGET := $(BIN_DIR)/server

NASM := nasm
LD := ld
NASMFLAGS := -f elf64
LDFLAGS :=

all: $(TARGET)
	./$(TARGET)

$(TARGET): $(OBJ_FILES)
	$(LD) $(LDFLAGS) -o $@ $^

$(BIN_DIR)/%.o: %.asm | $(BIN_DIR)
	$(NASM) $(NASMFLAGS) -o $@ $<

$(BIN_DIR):
	mkdir -p $(BIN_DIR)

.PHONY: clean
clean:
	rm -rf $(BIN_DIR)

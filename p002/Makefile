###############################################################################
# ARM Assembly/C cross-compiler makefile
###############################################################################

# The toolchain to use. Can be overridden by previous definition
ARMGNU ?= arm-linux-gnueabihf

# Directory for compiled object files.
BUILD = build

# Base source directory
SOURCE = p002

TARGET = $(BUILD)/Truthtable
# The name of the assembler listing file to generate.
LIST = $(TARGET).list

# The name of the binary (.bin) file to generate
BIN = $(TARGET).bin

# The name of the hex (.hex) file to generate
HEX = $(TARGET).hex

# The name of the map file to generate.
MAP = $(TARGET).map

# The name of the linker script to use.
LINKER = rpi_kernel.ld

# -O0 -- turn off all C optimization
CFLAGS = -Wall -Werror -g
LDFLAGS =

# The names of all object files that must be generated. Deduced from the
# code files in source.
OBJECTS := $(patsubst $(SOURCE)/%.c,$(BUILD)/%.o,$(wildcard $(SOURCE)/*.c))
OBJECTS += $(patsubst $(SOURCE)/%.s,$(BUILD)/%.o,$(wildcard $(SOURCE)/*.s))

# Rule to make everything.
all: $(TARGET) $(BUILD)

# Rule to remake everything. Does not include clean.
rebuild: all

# Rule to make the elf file.
$(TARGET) : $(OBJECTS)
	$(ARMGNU)-gcc $(CFLAGS) $(LDFLAGS) -o $(TARGET) $(OBJECTS)

# Rule to make the object files.
$(BUILD)/%.o: $(SOURCE)/%.s $(BUILD)
	$(ARMGNU)-as -g -I $(SOURCE) $< -o $@

$(BUILD)/%.o: $(SOURCE)/%.c $(BUILD)
	$(ARMGNU)-gcc -g -I $(SOURCE) $(CFLAGS) -c $< -o $@

$(BUILD):
	mkdir $@

# Rule to clean files.
clean :
	-rm -rf $(BUILD)

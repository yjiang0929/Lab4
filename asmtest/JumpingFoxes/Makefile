# Generate machine code memory image from MIPS assembly

# Get PROGRAM and *MEMDUMP from project settings
PROGRAM := jalmem
TEXTMEMDUMP := $(PROGRAM).text.hex
DATAMEMDUMP := $(PROGRAM).data.hex

ALLMEM := $(TEXTMEMDUMP) $(DATAMEMDUMP)

# MARS is pre-installed (/usr/local/bin/mars) on VM. Non-VM users should use
# MARS_PATH := java -jar path/to/Mars4_5.jar
MARS_PATH := mars
MARS_OPTS := a  mc CompactTextAtZero
MARS      := $(MARS_PATH) $(MARS_OPTS)


# Pattern rule for generating .text memory dump from MIPS assembly
%.text.hex: %.asm
	$(MARS) dump .text HexText $@  $<

# Pattern rule for generating .data memory dump from MIPS assembly
%.data.hex: %.asm
	$(MARS) dump .data HexText $@  $<


# Shortcut (phony) targets for convenience
assemble: $(ALLMEM)

clean:
	-rm -f $(ALLMEM)

# Get PROGRAM and *MEMDUMP from project settings
PROGRAM := jumpbranch
TEXTMEMDUMP := $(PROGRAM).text.hex
DATAMEMDUMP := $(PROGRAM).data.hex

ALLMEM := $(TEXTMEMDUMP) $(DATAMEMDUMP)

# MARS is pre-installed (/usr/local/bin/mars) on VM. Non-VM users should use
# MARS_PATH := java -jar path/to/Mars4_5.jar
MARS_PATH := mars
MARS_OPTS := a  mc CompactTextAtZero
MARS      := $(MARS_PATH) $(MARS_OPTS)


# Pattern rule for generating .text memory dump from MIPS assembly
%.text.hex: %.asm
	$(MARS) dump .text HexText $@  $<

# Pattern rule for generating .data memory dump from MIPS assembly
%.data.hex: %.asm
	$(MARS) dump .data HexText $@  $<


# Shortcut (phony) targets for convenience
assemble: $(ALLMEM)

clean:
	-rm -f $(ALLMEM)

# Get PROGRAM and *MEMDUMP from project settings
PROGRAM := multiplyby3
TEXTMEMDUMP := $(PROGRAM).text.hex
DATAMEMDUMP := $(PROGRAM).data.hex

ALLMEM := $(TEXTMEMDUMP) $(DATAMEMDUMP)

# MARS is pre-installed (/usr/local/bin/mars) on VM. Non-VM users should use
# MARS_PATH := java -jar path/to/Mars4_5.jar
MARS_PATH := mars
MARS_OPTS := a  mc CompactTextAtZero
MARS      := $(MARS_PATH) $(MARS_OPTS)


# Pattern rule for generating .text memory dump from MIPS assembly
%.text.hex: %.asm
	$(MARS) dump .text HexText $@  $<

# Pattern rule for generating .data memory dump from MIPS assembly
%.data.hex: %.asm
	$(MARS) dump .data HexText $@  $<


# Shortcut (phony) targets for convenience
assemble: $(ALLMEM)

clean:
	-rm -f $(ALLMEM)


.PHONY: assemble clean

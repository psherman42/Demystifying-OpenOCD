

#RISCVGNU ?= riscv32-unknown-elf

# requires $(RISCVGNU)-ld option -b elf32-littleriscv
RISCVGNU ?= riscv64-unknown-elf

AOPS = -march=rv32imac -mabi=ilp32
COPS = -march=rv32imac -mabi=ilp32 -Wall -O2 -nostdlib -nostartfiles -ffreestanding

OPENOCD_WIN = openocd
OPENOCD_LIN = sudo openocd
OPENOCD = $(OPENOCD_WIN)

DELCMD_WIN = del
DELCMD_LIN = rm -f
DELCMD = $(DELCMD_WIN)

PROGRAM := fft

all :

#
# Program Definition
#
#   note the tab (\t) character at beginning of line! it is critical for make
#   list all your project object (.o) files here, each on line by itself
#

clean :
	$(DELCMD) start.o
	$(DELCMD) foo.o
	$(DELCMD) bar.o
	$(DELCMD) baz.o
	...
	$(DELCMD) $(PROGRAM)-ram.elf
	$(DELCMD) $(PROGRAM)-ram.bin
	$(DELCMD) $(PROGRAM)-ram.lst
	$(DELCMD) $(PROGRAM)-ram.hex
	$(DELCMD) $(PROGRAM)-ram.map
	$(DELCMD) $(PROGRAM)-rom.elf
	$(DELCMD) $(PROGRAM)-rom.bin
	$(DELCMD) $(PROGRAM)-rom.lst
	$(DELCMD) $(PROGRAM)-rom.hex
	$(DELCMD) $(PROGRAM)-rom.map

start.o : start.s
	$(RISCVGNU)-as $(COPS) start.s -o start.o

foo.o : foo.s
	$(RISCVGNU)-as $(AOPS) foo.s -o foo.o

bar.o : bar.c
	$(RISCVGNU)-gcc $(COPS) bar.c -o bar.o

baz.o : baz.c
	$(RISCVGNU)-gcc $(COPS) baz.c -o baZ.o

# ...

#
# RAM link and load
#

ram : fe310-g002-ram.lds start.o foo.o bar.o baz.o ...
	$(RISCVGNU)-ld start.o foo.o bar.o baz.o ... -T fe310-g002-ram.lds -o $(PROGRAM)-ram.elf -Map $(PROGRAM)-ram.map -b elf32-littleriscv
	$(RISCVGNU)-objdump -D $(PROGRAM)-ram.elf > $(PROGRAM)-ram.lst
	$(RISCVGNU)-objcopy $(PROGRAM)-ram.elf -O ihex $(PROGRAM)-ram.hex
	$(RISCVGNU)-objcopy $(PROGRAM)-ram.elf -O binary $(PROGRAM)-ram.bin

ifeq (LOAD, $(tgt))
	@$(OPENOCD) -f fe310-g002.cfg -c init -c "asic_ram_load ${PROGRAM}" -c shutdown -c exit
	@echo "target RAM programmed"
else
	@echo "target not changed"
endif

#
# ROM link and load
#

rom : fe310-g002-rom.lds start.o foo.o bar.o baz.o
	$(RISCVGNU)-ld start.o foo.o bar.o baz.o ... -T fe310-g002-rom.lds -o $(PROGRAM)-rom.elf -Map $(PROGRAM)-rom.map -b elf32-littleriscv
	$(RISCVGNU)-objdump -D $(PROGRAM)-rom.elf > $(PROGRAM)-rom.lst
	$(RISCVGNU)-objcopy $(PROGRAM)-rom.elf -O ihex $(PROGRAM)-rom.hex
	$(RISCVGNU)-objcopy $(PROGRAM)-rom.elf -O binary $(PROGRAM)-rom.bin

ifeq (LOAD, $(tgt))
	@$(OPENOCD) -f fe310-g002.cfg -c init -c "asic_rom_load ${PROGRAM}" -c shutdown -c exit
	@echo "target ROM programmed"
else
	@echo "target not changed"
endif


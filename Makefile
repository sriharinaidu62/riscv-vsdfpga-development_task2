ARCH = rv32i
ABI = ilp32

PROGRAM = gpio_test
RAM_SIZE = 6144

RVASFLAGS = -march=$(ARCH) -mabi=$(ABI)
RVCFLAGS  = -fno-pic -march=$(ARCH) -mabi=$(ABI) \
            -fno-stack-protector -w -Wl,--no-relax

RVINCS = -I ./LIBFEMTOGL -I ./LIBFEMTORV32 -I ./LIBFEMTOC

LIBOBJECTS = putchar.o wait.o print.o memcpy.o errno.o perf.o

RVAS      = riscv64-unknown-elf-as
RVLD      = riscv64-unknown-elf-ld
RVOBJCOPY = riscv64-unknown-elf-objcopy
RVOBJDUMP = riscv64-unknown-elf-objdump
RVGCC     = riscv64-unknown-elf-gcc

all: $(PROGRAM).hex

.c.o:
	$(RVGCC) $(RVCFLAGS) $(RVINCS) -c $<

.S.o:
	$(RVAS) $(RVASFLAGS) $< -o $@

$(PROGRAM).bram.elf: $(PROGRAM).o start.o $(LIBOBJECTS)
	$(RVLD) -T bram.ld -m elf32lriscv -nostdlib $^ ./libgcc.a -o $@

$(PROGRAM).hex: $(PROGRAM).bram.elf
	./firmware_words $< -ram $(RAM_SIZE) -max_addr $(RAM_SIZE) -out $@
	cp $@ ../RTL/firmware.hex
	mkdir -p ../RTL/obj_dir
	cp $@ ../RTL/obj_dir/firmware.hex
	echo $@ > ../RTL/firmware.txt

clean:
	rm -f *.o *.elf *.hex *.bram.elf

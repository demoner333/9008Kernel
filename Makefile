ASM      = nasm
ASMFLAGS = -f elf32

LD       = ld
LDFLAGS  = -m elf_i386 -Ttext 0x100000 -e _start

ASM_SRCS = \
	kernel/kernel.nasm \
	kernel/kernel_main.nasm \
	kernel/idt/idt.nasm \
	kernel/idt/isr.nasm \
	kernel/idt/syscall.nasm \
	drivers/VGA/vga.nasm \
	drivers/keyboard-PS2/keyboard.nasm

ASM_OBJS = $(ASM_SRCS:.nasm=.o)
OBJS     = $(ASM_OBJS)

all: kernel.elf

%.o: %.nasm
	$(ASM) $(ASMFLAGS) $< -o $@

kernel.elf: $(OBJS)
	$(LD) $(LDFLAGS) $^ -o $@

run: kernel.elf
	qemu-system-i386 -kernel $<

clean:
	rm -f $(OBJS) kernel.elf

.PHONY: all run clean

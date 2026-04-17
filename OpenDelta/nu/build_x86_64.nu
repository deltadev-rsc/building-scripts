def x86_64_kern () {
    cd  ~/OpenDelta/kernel/
   
    nasm boot/x86_64/boot.asm -f bin -o img/boot64.bin
    nasm kernel_entry.asm -f elf -o obj/entry.o

    clang -m64 -fno-pie -ffreestanding -nostdlib -c kernel.c -o obj/kernel.o
    clang -m64 -fno-pie -ffreestanding -nostdlib -c cpu/idt.c -o obj/idt.o
    clang -m64 -fno-pie -ffreestanding -nostdlib -c lib/source/stdbase.c -o obj/stdbase.o
    clang -m64 -fno-pie -ffreestanding -nostdlib -c lib/source/string.c -o obj/string.o
    clang -m64 -fno-pie -ffreestanding -nostdlib -c lib/sourcce/types.c -o obj/types.o
    clang -m64 -fno-pie -ffreestanding -nostdlib -c mem/memory.c -o obj/mem.o
    clang -m64 -fno-pie -ffreestanding -nostdlib -c ports/ports.c -o obj/ports.o
    clang -m64 -fno-pie -ffreestanding -nostdlib -c drvs/screen.c -o obj/screen.o

    ld.lld -m elf_x64_64 -s obj/kernel.o obj/entry.o obj/idt.o obj/mem.o obj/stdbase.o obj/string.o obj/types.o obj/ports.o obj/screen.o -o img/kernel.bin -z noexecstack -T link.ld -Ttext 0x10000 --oformat binary

    dd if=/dev/zero/ of=img/open-delta.img bs=512 count=32516 status=none
    mkfas.fat -F32 img/open-delta.img
    dd if=img/boot.bin of=img/open-delta.img conv=ascii bs=1024 count=1
    dd if=img/kernel.bin of=img/open-delta.img conv=ascii bs=2048 count=1
}

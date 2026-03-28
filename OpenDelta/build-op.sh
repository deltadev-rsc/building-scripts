#!/bin/bash

function base_actions() {
    mkdir ~/OpenDelta/shell/bin # folder for shell binaries
    mkdir ~/OpenDelts/kernel/img/
    mkdir ~/OpenDelts/kernel/obj/
}

function clone_repo() { git clone https://github.com/deltadev-rsc/OpenDelta.git }

#---function-for-build---#

function buildKernel() {
    cd ~/OpenDelta/kernel/
    
    #---compile-asm-code---# 
    nasm boot/i386/boot.asm -f bin -o img/boot.bin    
    nasm kernel_entry.asm -f elf -o obj/kern_entry.o
    nasm entry_i386.asm -f elf -o obj/entry_i386.o

    #---compile-kernel---#
    clang -m32 -march=i386 -fno-pie -ffreestanding -nostdlib -c kernel.c -o obj/kernel.o
    clang -m32 -march=i386 -fno-pie -ffreestanding -nostdlib -c cpu/idt.c -o obj/idt.o
    clang -m32 -march=i386 -fno-pie -ffreestanding -nostdlib -c lib/source/stdbase.c -o obj/stdbase.o

    #---create-kernel-bin-file---#
    ld.lld -m elf_i386 -s obj/kernel.o obj/stdbase.o obj/idt.o obj/kern_entry.o obj/entry_i386.o -o img/kernel.bin -z noexecstack -T link.ld -Ttext 0x10000 --oformat binary

    #---create-os-image---#
    dd if=/dev/zero of=img/open-delta.img bs=512 count=32516 status=none
    mkfs.fat -F12 img/open-delta.img
    dd if=img/boot.bin of=img/open-delta.img conv=ascii bs=1024 count=1 
    dd if=img/kernel.bin of=img/open-delta.img conv=ascii bs=2048 count=1
}

function build_shell() {
    while true; do
        clang -c ~/OpenDelta/shell/src/term.c -o ~/OpenDelta/bin/dltsh
        rustc ~/OpenDelta/shell/src/clocks.rs -o ~/OpenDelta/shell/bin/clocks
        rustc ~/OpenDelta/shell/src/dexide.rs -o ~/OpenDelta/shell/bin/dexide
    done  
}

clone_repo 

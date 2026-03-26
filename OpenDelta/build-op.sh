#!/bin/bash

#---toolchain---#
CC = clang
CXX = clang++
LD = ld.ldd

CC_FLAGS = -m64 -nostdlib -ffreestanding -fno-pie  
LD_FLAGS = -m elf_x86_64 -z noexecstack -T ~/open-delta/kernel/boot/x86_64/linker.ld -Ttext 0x10000 --oformat binary

#---os-image---#
image = "~/OpenDelta/kernel/img/open-delta.img"

#---source-code-and-binaries---#
bootPath = "~/OpenDelta/kernel/boot/x86_64/boot.asm"
bootBinPath = "~/OpenDelta/kernel/img/boot_x86_64.bin"
kernEntryPath = "~/OpenDelta/kernel/kernel_entry.asm"
kernEntryI386Path = "~/OpenDelta/kernel/entry_i386.asm"
kernEntryBinPath = "~/OpenDelta/kernel/obj/kern_entry.o"
kernEntryI386BinPath = "~/OpenDelta/kernel/obj/entry_i386.o"

#---source-code-and-binaries-for-kernel---#
kernelSourcePath = "~/OpenDelta/kernel/kernel.c"
kernelObjPath = "~/OpenDelta/kernel/obj/kernel.o"
kernelBinPath = "~/OpenDelta/kernel/img/kernel.bin"
idtSourcePath = "~/OpenDelta/kernel/cpu/idt.c"
idtBinPath = "~/OpenDelta/kernel/obj/idt.o"

#---source-code-for-dltsh---#
termSrcPath = "~/OpenDelta/shell/src/term.c"
clocksSrcPath = "~/OpenDelta/shell/src/clocks.rs"
dexideSrcPath = "~/OpenDelta/shell/src/dexide.rs"

termBinPath = "~/OpenDelta/shell/bin/term"
clocksBinPath = "~/OpenDelta/shell/bin/clocks"
dexideBinPath = "~/OpenDelta/shell/bin/dexide"

base_actions() {
    mkdir ~/OpenDelta/shell/bin # folder for shell binaries
    mkdir ~/OpenDelts/kernel/img/
    mkdir ~/OpenDelts/kernel/obj/
}

clone_repo() { git clone https://github.com/deltadev-rsc/OpenDelta.git }

#---function-for-build---#
build() {
    while true; do
        nasm $bootPath -f bin -o $bootBinPath 
        nasm $kernEntryPath -f elf -o $kernEntryBinPath
        nasm $kernEntryI386Path -f elf -o $kernEntryI386BinPath
        $CC $FLAGS -c $kernelSourcePath -o $kernelObjPath
        $CC $FLAGS -c $idtSourcePath -o $idtBinPath
        $LD $LD_FLAGS -s $kernelObjPath $idtBinPath -o $kernelBinPath
        dd if=/dev/zero of=$image bs=512 count=32516 status=none
        mkfs.fat -F12 $iamge
        dd if=$bootBinPath of=$image conv=ascii bs=1024 count=1
        dd if=$kernelBinPath of=$image conv=ascii bs=2048 count=1
    done
} 

build_shell() {
    while true; do
        $CC -c $termSrcPath -o $termBinPath
        rustc $clocksSrcPath -o $clocksBinPath
        rustc $dexideSrcPath -o $dexideBinPath
    done  
}

clone_repo 

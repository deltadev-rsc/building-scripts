#!/usr/bin/bash

function build-dltsh {
    mkdir -p ~/OpenDelta/shell/bin 

    clang ~/OpenDelta/shell/src/term.c \ 
            ~/OpenDelta/shell/src/files.c \ 
            ~/OpenDelta/shell/src/commands.c \
            ~/OpenDelta/shell/src/simple_comms.c \ 
            ~/OpenDelta/shell/src/dltsh.c \ 
            -o ~/OpenDelta/bin/dltsh
    
    clang++ ~/OpenDelta/shell/src/help_table.cpp -o bin/table -lncursesw

    rustc ~/OpenDelta/shell/src/clocks.rs -o ~/OpenDelta/shell/bin/clocks
    rustc ~/OpenDelta/shell/src/calc.rs -o ~/OpenDelta/shell/bin/calc
    rustc ~/OpenDelta/shell/src/dexide.rs -o ~/OpenDelta/shell/bin/dexide
}

build-dltsh

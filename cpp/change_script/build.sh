#!/usr/bin/bash

CXX=clang++

function build_run {
    cd ~/CPP/change_script/
    mkdir ./bin/
    $CXX -o bin/cs -cpp chscript.cpp
    ./bin/cs
}

build_run

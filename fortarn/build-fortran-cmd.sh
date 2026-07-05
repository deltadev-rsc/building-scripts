#!/usr/bin/bash

mkdir -p ~/CPP/fortran/bin/

function build {
    gfortran ~/CPP/fortran/cmd.f95 -o ~/CPP/fortran/bin/cmd
    ~/CPP/fortran/bin/cmd
}

build

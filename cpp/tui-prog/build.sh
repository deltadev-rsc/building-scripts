#!/bin/bash

CXX=clang++

function build() {
  cd ~/CPP/tui-prog/
  mkdir bin/
  $CXX -o bin/prog -cpp src/main.cpp -lncursesw
}

function run() { ./bin/prog }

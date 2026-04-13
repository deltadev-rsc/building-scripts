#!/bin/sh

function build() {
  cd ~/CPP/terminal/
  mkdir bin/
  g++ terminal.cpp dex.cpp -o bin/term
}

function run() { ./bin/term }

build && run

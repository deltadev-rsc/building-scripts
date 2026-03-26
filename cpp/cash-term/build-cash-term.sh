#!/bin/sh

function build() {
  cd ~/CPP/cash-terminal/
  mkdir bin/
  g++ cash_term.cpp -o bin/cash_term
}

function run() { ./bin/cash-term }

build && run

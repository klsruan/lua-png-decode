#!/bin/sh

[ ! -d binaries ] && mkdir -p binaries

git clone https://github.com/lvandeve/lodepng.git && cd lodepng
git checkout 997936fd2b45842031e4180d73d7880e381cf33f && cp -f lodepng.cpp lodepng.c

cmake .. -DCMAKE_CXX_COMPILER=gcc -G "Unix Makefiles" -B ../binaries
cd ../binaries && make lodepng
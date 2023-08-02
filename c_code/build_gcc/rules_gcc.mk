CROSS_LD=lwlink
CROSS_CC=m6809-unknown-gcc
CROSS_AS=lwasm
CROSS_AR=lwar

CCOPTS= -Wall -O3 -nostdlib -fno-builtin -D_TURBO9 -DCOMPILER="\"gcc\"" -D_GCC

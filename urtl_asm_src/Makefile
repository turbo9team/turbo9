# [TURBO9_HEADER_START]
# ///////////////////////////////////////////////////////////////////////////
#                          Turbo9 Microprocessor IP
# ///////////////////////////////////////////////////////////////////////////
# Website: www.turbo9.org
# Contact: team[at]turbo9[dot]org
# ///////////////////////////////////////////////////////////////////////////
# [TURBO9_LICENSE_START]
# Copyright (c) 2020-2023
# Kevin Phillipson
# Michael Rywalt
# All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
# FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
# COPYRIGHT HOLDERS AND CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
# INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
# STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
# OF THE POSSIBILITY OF SUCH DAMAGE.
# 
# License Type: BSD-1-Clause
# [TURBO9_LICENSE_END]
# ///////////////////////////////////////////////////////////////////////////
# File: Makefile
# Engineer: Michael Rywalt
# Description: Used with make tool to build any part of the assembler.
#
# ///////////////////////////////////////////////////////////////////////////
# History:
# 07.14.2023 - Kevin Phillipson
#   File header added
#
# ///////////////////////////////////////////////////////////////////////////
# [TURBO9_HEADER_END]

GCC = cc

CFLAGS = -g -l c -I -Wall

urtl_asm: urtl_asm.o log.o err.o mathlib.o strproc.o statistics.o ctrl_vec.o macro.o verilog.o assemble.o decode_table.o fileproc.o 
	${CC} -o urtl_asm urtl_asm.o log.o err.o mathlib.o strproc.o statistics.o ctrl_vec.o macro.o verilog.o assemble.o decode_table.o fileproc.o 

urtl_asm.o: urtl_asm.c
	${CC} -g -o urtl_asm.o -c urtl_asm.c
ctrl_vec.o: ctrl_vec.c mathlib.h
	${CC} -g -o ctrl_vec.o -c ctrl_vec.c
macro.o: macro.c 
	${CC} -g -o macro.o -c macro.c
verilog.o: verilog.c 
	${CC} -g -o verilog.o -c verilog.c
assemble.o: assemble.c 
	${CC} -g -o assemble.o -c assemble.c
decode_table.o: decode_table.c 
	${CC} -g -o decode_table.o -c decode_table.c
statistics.o: statistics.c mathlib.h
	${CC} -g -o statistics.o -c statistics.c
strproc.o: strproc.c
	${CC} -g -o strproc.o -c strproc.c
fileproc.o: fileproc.c
	${CC} -g -o fileproc.o -c fileproc.c
log.o: log.c
	${CC} -g -o log.o -c log.c
err.o: err.c
	${CC} -g -o err.o -c err.c
mathlib.o: mathlib.c
	${CC} -g -o mathlib.o -c mathlib.c
debug.o: debug.c
	${CC} -g -o debug.o -c debug.c

clean:
	rm -f *.o urtl_asm

install:
	cp urtl_asm ../urtl

all: clean urtl_asm install

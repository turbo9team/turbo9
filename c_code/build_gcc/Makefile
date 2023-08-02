# [TURBO9_HEADER_START]
# ////////////////////////////////////////////////////////////////////////////
#                          Turbo9 Microprocessor IP
# ////////////////////////////////////////////////////////////////////////////
# Website: www.turbo9.org
# Contact: team[at]turbo9[dot]org
# ////////////////////////////////////////////////////////////////////////////
# [TURBO9_LICENSE_START]
# BSD-1-Clause
#
# Copyright (c) 2020-2023
# Kevin Phillipson
# Michael Rywalt
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice,
#    this list of conditions and the following disclaimer.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS AND CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.
# [TURBO9_LICENSE_END]
# ////////////////////////////////////////////////////////////////////////////
# Engineer: Kevin Phillipson
# Description: Makefile for GCC6809 compiler
#
# ////////////////////////////////////////////////////////////////////////////
# History:
# 07.14.2023 - Kevin Phillipson
#   File header added
#
# ////////////////////////////////////////////////////////////////////////////
# [TURBO9_HEADER_END]

SRCDIR=../../c_code
include rules_gcc.mk

GCC=/usr/lib/gcc/m6809-unknown/4.6.4

LIB=$(SRCDIR)/lib_gcc

HELLO_DIR=$(SRCDIR)/hello_world_src
DHRY_DIR=$(SRCDIR)/dhrystone_src
SIEVE_DIR=$(SRCDIR)/byte_sieve_src

vpath %.c $(SRCDIR)/dhrystone_src $(SRCDIR)/byte_sieve_src $(SRCDIR)/hello_world_src $(LIB)

all: hello.s19 sieve.s19 dhry.s19



# /////////////////////////////// 
#           COMPILE
# ///////////////////////////////

lib.o: lib.c
	@echo ""
	@echo "//////////// Compile ////////////"
	$(CROSS_CC) $(CCOPTS) -S $(LIB)/lib.c -o lib.asm
	$(CROSS_CC) $(CCOPTS) -c $(LIB)/lib.c -o lib.o

hello.o: hello_world.c
	@echo ""
	@echo "//////////// Compile ////////////"
	$(CROSS_CC) $(CCOPTS) -S -I$(LIB) $(HELLO_DIR)/hello_world.c -o hello.asm
	$(CROSS_CC) $(CCOPTS) -c -I$(LIB) $(HELLO_DIR)/hello_world.c -o hello.o

sieve.o: byte_sieve.c
	@echo ""
	@echo "//////////// Compile ////////////"
	$(CROSS_CC) $(CCOPTS) -S -I$(LIB) $(SIEVE_DIR)/byte_sieve.c -o sieve.asm
	$(CROSS_CC) $(CCOPTS) -c -I$(LIB) $(SIEVE_DIR)/byte_sieve.c -o sieve.o

dhry1.o: dhry1.c
	@echo ""
	@echo "//////////// Compile ////////////"
	$(CROSS_CC) $(CCOPTS) -S -I$(LIB) $(DHRY_DIR)/dhry1.c -o dhry1.asm
	$(CROSS_CC) $(CCOPTS) -c -I$(LIB) $(DHRY_DIR)/dhry1.c -o dhry1.o

dhry2.o: dhry2.c
	@echo ""
	@echo "//////////// Compile ////////////"
	$(CROSS_CC) $(CCOPTS) -S -I$(LIB) $(DHRY_DIR)/dhry2.c -o dhry2.asm
	$(CROSS_CC) $(CCOPTS) -c -I$(LIB) $(DHRY_DIR)/dhry2.c -o dhry2.o

# /////////////////////////////// 



# /////////////////////////////// 
#              LINK
# ///////////////////////////////

hello.s19: hello.o lib.o
	@echo ""
	@echo "//////////// Link ////////////"
	$(CROSS_LD) -f srec -o hello.s19 lib.o hello.o --script=gcc.link --map=hello.map --library=gcc --library-path=$(GCC)

sieve.s19: sieve.o lib.o
	@echo ""
	@echo "//////////// Link ////////////"
	$(CROSS_LD) -f srec -o sieve.s19 lib.o sieve.o --script=gcc.link --map=sieve.map --library=gcc --library-path=$(GCC)

dhry.s19: dhry1.o dhry2.o lib.o
	@echo ""
	@echo "//////////// Link ////////////"
	$(CROSS_LD) -f srec -o dhry.s19 lib.o dhry1.o dhry2.o --script=gcc.link --map=dhry.map --library=gcc --library-path=$(GCC)

# /////////////////////////////// 

clean:
	rm -f  *.map *.sym *.lst *.o *.s *.s19 *.asm

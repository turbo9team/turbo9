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
# Description: Makefile for vbcc compiler
#
# ////////////////////////////////////////////////////////////////////////////
# History:
# 07.14.2023 - Kevin Phillipson
#   File header added
#
# ////////////////////////////////////////////////////////////////////////////
# [TURBO9_HEADER_END]

SRCDIR=../../c_code
include rules_vbcc.mk

VBCC=/opt/vbcc

LIB=$(SRCDIR)/lib_vbcc

HELLO_DIR=$(SRCDIR)/hello_world_src
DHRY_DIR=$(SRCDIR)/dhrystone_src
SIEVE_DIR=$(SRCDIR)/byte_sieve_src

vpath %.c $(SRCDIR)/dhrystone_src $(SRCDIR)/byte_sieve_src $(SRCDIR)/hello_world_src $(LIB)

all: hello.s19 sieve.s19 dhry.s19



# /////////////////////////////// 
#           COMPILE
# ///////////////////////////////

lib.asm: lib.c
	@echo ""
	@echo "//////////// Compile ////////////"
	#vbcchc12 $(OP3speed) $(CCOPTS) -I$(VBCC)/targets/6809-sim/include -I$(LIB)  $(LIB)/lib.c -o= lib.asm
	vbcchc12 $(OP3speed)  $(CCOPTS) -I$(LIB)  $(LIB)/lib.c -o= lib.asm

lib_s.asm: lib.c
	@echo ""
	@echo "//////////// Compile ////////////"
	#vbcchc12 $(OP3speed) $(CCOPTS) -I$(VBCC)/targets/6809-sim/include -I$(LIB)  $(LIB)/lib.c -o= lib.asm
	vbcchc12 $(OP1size) $(CCOPTS) -I$(LIB)  $(LIB)/lib.c -o= lib_s.asm

hello.o: hello_world.c
	@echo ""
	@echo "//////////// Compile ////////////"
	vc -S -O3 -speed $(VCOPTS) -I$(LIB)  $(HELLO_DIR)/hello_world.c -o hello.asm
	vc -c -O3 -speed $(VCOPTS) -I$(LIB)  $(HELLO_DIR)/hello_world.c -o hello.o

sieve.asm: byte_sieve.c
	@echo ""
	@echo "//////////// Compile ////////////"
	vbcchc12 $(OP3speed)  $(CCOPTS) -I$(LIB) $(SIEVE_DIR)/byte_sieve.c -o= sieve.asm

dhry.asm: dhry1.c dhry2.c
	@echo ""
	@echo "//////////// Compile ////////////"
	vbcchc12 $(OP3speed) $(CCOPTS) -I$(LIB) $(DHRY_DIR)/dhry1.c $(DHRY_DIR)/dhry2.c -o= dhry.asm 

dhry1_s.asm: dhry1.c
	@echo ""
	@echo "//////////// Compile ////////////"
	vbcchc12 $(OP1speed) $(CCOPTS) -I$(LIB) $(DHRY_DIR)/dhry1.c -o= dhry1_s.asm 

dhry2_s.asm: dhry1.c
	@echo ""
	@echo "//////////// Compile ////////////"
	vbcchc12 $(OP3speed) $(CCOPTS) -I$(LIB) $(DHRY_DIR)/dhry2.c -o= dhry2_s.asm 

# /////////////////////////////// 



# /////////////////////////////// 
#          ASSEMBLE
# ///////////////////////////////

lib.o: lib.asm
	@echo ""
	@echo "//////////// Assemble ////////////"
	vasm6809_std -turbo9 -nowarn=62 -opt-branch -opt-offset -Fvobj lib.asm -o lib.o

lib_s.o: lib_s.asm
	@echo ""
	@echo "//////////// Assemble ////////////"
	vasm6809_std -turbo9 -nowarn=62 -opt-branch -opt-offset -Fvobj lib_s.asm -o lib_s.o
	
#hello.o: hello.asm
#	@echo ""
#	@echo "//////////// Assemble ////////////"
#	vasm6809_std -turbo9 -nowarn=62 -opt-branch -opt-offset -Fvobj hello.asm -o hello.o
	
sieve.o: sieve.asm
	@echo ""
	@echo "//////////// Assemble ////////////"
	vasm6809_std -turbo9 -nowarn=62 -opt-branch -opt-offset -Fvobj sieve.asm -o sieve.o
	
dhry1_s.o: dhry1_s.asm
	@echo ""
	@echo "//////////// Assemble ////////////"
	vasm6809_std -turbo9 -nowarn=62 -opt-branch -opt-offset -Fvobj dhry1_s.asm -o dhry1_s.o
	
dhry2_s.o: dhry2_s.asm
	@echo ""
	@echo "//////////// Assemble ////////////"
	vasm6809_std -turbo9 -nowarn=62 -opt-branch -opt-offset -Fvobj dhry2_s.asm -o dhry2_s.o
	
dhry.o: dhry.asm
	@echo ""
	@echo "//////////// Assemble ////////////"
	vasm6809_std -turbo9 -nowarn=62 -opt-branch -opt-offset -Fvobj dhry.asm -o dhry.o

# /////////////////////////////// 



# /////////////////////////////// 
#              LINK
# ///////////////////////////////

hello.s19: hello.o lib_s.o
	@echo ""
	@echo "//////////// Link ////////////"
	#vlink -b srec19 -Cvbccelf -Tvlink.cmd -Mhello.map -L$(VBCC)/targets/6809-sim/lib $(VBCC)/targets/6809-sim/lib/startup.o hello.o -o hello.s19 -lvc
	vlink -b srec19 -Cvbccelf -Tvlink.cmd -nostdlib -Mhello.map -L$(VBCC)/targets/6809-sim/lib $(VBCC)/targets/6809-sim/lib/startup.o hello.o lib_s.o -o hello.s19 -lvc
	srec_size < hello.s19
	
sieve.s19: sieve.o lib_s.o
	@echo ""
	@echo "//////////// Link ////////////"
	vlink -b srec19 -Cvbccelf -Tvlink.cmd -nostdlib -Msieve.map -L$(VBCC)/targets/6809-sim/lib $(VBCC)/targets/6809-sim/lib/startup.o sieve.o lib_s.o -o sieve.s19 -lvc
	srec_size < sieve.s19

dhry.s19: dhry.o lib_s.o
	@echo ""
	@echo "//////////// Link ////////////"
	vlink -b srec19 -Cvbccelf -Tvlink.cmd -nostdlib -Mdhry.map -L$(VBCC)/targets/6809-sim/lib $(VBCC)/targets/6809-sim/lib/startup.o dhry.o lib_s.o -o dhry.s19 -lvc
	srec_size < dhry.s19

dhry_s.s19: dhry1_s.o dhry2_s.o lib_s.o
	@echo ""
	@echo "//////////// Link ////////////"
	vlink -b srec19 -Cvbccelf -Tvlink.cmd -nostdlib -Mdhry.map -L$(VBCC)/targets/6809-sim/lib $(VBCC)/targets/6809-sim/lib/startup.o dhry1_s.o dhry2_s.o lib_s.o -o dhry_s.s19 -lvc
	srec_size < dhry_s.s19

# /////////////////////////////// 

clean:
	rm -f  *.map *.sym *.lst *.o *.s *.s19 *.asm

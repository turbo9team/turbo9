#!/bin/csh
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
# Description: Script to assemble using LWTools LWASM.
# Outputs 32KB S19 and HEX files with correct offset
#
# ////////////////////////////////////////////////////////////////////////////
# History:
# 07.14.2023 - Kevin Phillipson
#   File header added
#
# ////////////////////////////////////////////////////////////////////////////
# [TURBO9_HEADER_END]

set name=$0
if ($#argv <1) then
   echo Usage: $name \
   '<filename w/o extension>'
   echo Example: $name demo
   exit
endif

set filename=$1

lwasm -f srec -o ${filename}.s19 -l${filename}.lst ${filename}.asm --symbol-dump=${filename}.sym

#./s192mif8 < ${filename}.s19 > ${filename}.mif
./s192hex8_offset0x8000      < ${filename}.s19 > ${filename}.hex
./s192hex8_offset0x8000_even < ${filename}.s19 > ${filename}_even.hex
./s192hex8_offset0x8000_odd  < ${filename}.s19 > ${filename}_odd.hex

if ($filename == "tb_dv_asm") then
  ./verihead -i ${filename}.sym -o ${filename}.vh
  #sed 's/^/  `define  tb_asm_/g' ${filename}.sym | sed 's/EQU.*\$/             16\x27h/g' > ${filename}.vh
  cp ${filename}.vh ../tb/.
  echo "Copying ${filename}.vh to ../tb/."
endif

if ($filename == "turbo_boot") then
  cp ${filename}.hex ../rtl/default.hex
  echo "Copying ${filename}.hex to ../rtl/default.hex"
  cp ${filename}_even.hex ../rtl/default_even.hex
  echo "Copying ${filename}_even.hex to ../rtl/default_even.hex"
  cp ${filename}_odd.hex ../rtl/default_odd.hex
  echo "Copying ${filename}_odd.hex to ../rtl/default_odd.hex"
  #
  echo "Creating sim_boot.asm"
  cp turbo_boot.asm sim_boot.asm
  sed -i 's/ brn / bra /g' sim_boot.asm
  sed -i 's/ lbrn / lbra /g' sim_boot.asm
  sed -i 's/.*tag_sim_detect.*/  fcb   $01   ;sed replace tag_sim_detect/g' sim_boot.asm
  lwasm -f srec -o sim_boot.s19 -lsim_boot.lst sim_boot.asm --symbol-dump=sim_boot.sym
  ./s192hex8_offset0x8000      < sim_boot.s19 > sim_boot.hex
  ./s192hex8_offset0x8000_even < sim_boot.s19 > sim_boot_even.hex
  ./s192hex8_offset0x8000_odd  < sim_boot.s19 > sim_boot_odd.hex
  ./verihead -i sim_boot.sym -o sim_boot.vh
  echo "Copying sim_boot.vh to ../tb/."
  cp sim_boot.vh ../tb/.
endif


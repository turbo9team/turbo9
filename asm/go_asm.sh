#!/bin/bash
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
# Outputs 64KB S19 and HEX files with zero offset
#
# ////////////////////////////////////////////////////////////////////////////
# History:
# 07.14.2023 - Kevin Phillipson
#   File header added
# 07.28.2026 - Kevin Phillipson
#   Converted from csh to bash. Swapped the retired
#   s192hex8_offset0x0000[_even|_odd] trio for the new flag-driven s192hex
#   tool (-i/-o file args, -l even/odd for the lane splits).
# ////////////////////////////////////////////////////////////////////////////
# [TURBO9_HEADER_END]

set -u

NAME=$0

if [[ $# -lt 1 ]]; then
  echo "Usage: ${NAME} <filename w/o extension>" >&2
  echo "Example: ${NAME} demo" >&2
  exit 1
fi

FILENAME=$1

run_s192hex() {
  if ! ./s192hex "$@"; then
    echo "${NAME}: s192hex failed: $*" >&2
    exit 1
  fi
}

if ! lwasm -f srec -o "${FILENAME}.s19" -l"${FILENAME}.lst" "${FILENAME}.asm" --symbol-dump="${FILENAME}.sym"; then
  echo "${NAME}: lwasm failed for ${FILENAME}.asm" >&2
  exit 1
fi


if [[ "${FILENAME}" == "tb_dv_asm" ]]; then
  run_s192hex -i tb_dv_asm.s19 -o tb_dv_asm.hex
  ./verihead -i tb_dv_asm.sym -o tb_dv_asm.vh
  #sed 's/^/  `define  tb_asm_/g' ${FILENAME}.sym | sed 's/EQU.*\$/             16\x27h/g' > ${FILENAME}.vh
  echo "Copying tb_dv_asm.vh to ../tb/."
  cp tb_dv_asm.vh ../tb/.
fi

if [[ "${FILENAME}" == "turbo9_boot" ]]; then
  run_s192hex -i turbo9_boot.s19 -o turbo9_boot.hex       -s fc00 -e fdff
  run_s192hex -i turbo9_boot.s19 -o turbo9_boot_even.hex  -s fc00 -e fdff -l even
  run_s192hex -i turbo9_boot.s19 -o turbo9_boot_odd.hex   -s fc00 -e fdff -l odd 
  run_s192hex -i turbo9_boot.s19 -o turbo9_boot_16bit.hex -s fc00 -e fdff -w 16  
  echo "Copying turbo9_boot*.hex to ../rtl/."
  cp turbo9_boot*.hex ../rtl/.
  echo "Creating turbo9_boot_io_lib.sym"
  grep _io_lib "turbo9_boot.sym" > "turbo9_boot_io_lib.sym"
  sed -i 's/_io_lib//g' "turbo9_boot_io_lib.sym"
fi

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
# Description: Run simulation script for Icarus Verilog, tb_dv_top only.
# Flag-based args replace run_iv.sh's positional modes; --define/--plusarg are
# generic passthroughs to iverilog -D / vvp +arg so new testbench knobs never
# require a script change. tb_stim_top still runs through the old run_iv.sh.
#
# ////////////////////////////////////////////////////////////////////////////
# History:
# 07.25.2026 - Kevin Phillipson
#   File header added
#
# ////////////////////////////////////////////////////////////////////////////
# [TURBO9_HEADER_END]

set -u

########################################## Locate ourselves
#
INVOKED_FROM="$(pwd)"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "${SCRIPT_DIR}"

if [[ ! -d ../tb || ! -d ../asm ]]; then
  echo "Can't find '../tb' or '../asm' relative to ${SCRIPT_DIR}."
  echo "This script expects to live in a directory parallel to 'tb' and 'asm'."
  exit 1
fi

TB=tb_dv_top
TB_SRC=../tb/${TB}.v
FLIST=../tb/f.list.${TB}
NAME=$0

########################################## Known macros / plusargs (documentation only)
#
# Hand-maintained: this list is short and changes rarely, and a maintained
# table documents defaults better than regex-scraping the `ifndef guards in
# tb/turbo9_tb_config.vh would. The test case lists below are NOT
# hand-maintained -- see all_test_cases(), regress_test_cases(), and
# debug_test_cases().
print_macro_table() {
  cat <<'EOF'
  DUT variant select (pick one, default TURBO9_TB_DUT_TURBO9_S):
    TURBO9_TB_DUT_TURBO9
    TURBO9_TB_DUT_TURBO9_S
    TURBO9_TB_DUT_TURBO9_R
    TURBO9_TB_DUT_TURBO9_GTS
    TURBO9_TB_DUT_TURBO9_GTR

  Parameter defaults:
    TURBO9_TB_MEM_ADDR_WIDTH=16
    TURBO9_TB_SOC_WB_PIPELINE_REG=0
    TURBO9_TB_CPU_WB_PIPELINE_REG=0
    TURBO9_TB_CPU_QUEUE_SIZE=6

  Behavior switches (opt-in, no value):
    TURBO9_TB_MODEL_FAST        Run behavioral 6809 model w/ no idle cycles
    TURBO9_TB_MODEL_VERBOSE     Verbose 6809 model
    TURBO9_TB_MODEL_BREAK_DEC   Intentionally break 6809 model DEC instruction
    TURBO9_RTL_SYNC_RESET       Use synchronous reset
    TURBO9_RTL_MIN_RESET        Reset minimal registers
    TURBO9_RTL_USE_X            Assign X in don't-care logic for optimization
    TURBO9_RTL_SIM_DEBUG        Decode debug strings in decode table files
    TURBO9_RTL_SIM_T6551_FAST   Run the T6551 UART model as fast as possible
EOF
}

print_plusarg_table() {
  cat <<'EOF'
  seed=N          Random seed (default: seed generated from system clock)
  rand_itr=N      Random iterations per test (default: testbench picks 1)
  hex_file=PATH   HEX image to load (default: asm/tb_dv_asm.hex if omitted)
  s19_file=PATH   S19 image to load (no default)
  dump            Boolean: dump <test_case>.vcd
EOF
}

########################################## Auto-derived test case lists
#
# Scraped from the marker-delimited blocks in tb_dv_top.v's case(test_case)
# so these can never drift out of sync with the testbench the way a
# hand-maintained list can (see AGENTS.md's note on mismatched test names).
# all_test_cases() is just the union of the other two, so any test_case
# arm that isn't inside one of the two marker blocks is silently excluded
# from --help's "Test cases" listing until it's added to a block.
regress_test_cases() {
  sed -n '/\[TURBO9_REGRESS_TEST_CASES_START\]/,/\[TURBO9_REGRESS_TEST_CASES_END\]/p' "${TB_SRC}" \
    | grep -oE '"[A-Za-z0-9_]+"' | tr -d '"'
}

debug_test_cases() {
  sed -n '/\[TURBO9_DEBUG_TEST_CASES_START\]/,/\[TURBO9_DEBUG_TEST_CASES_END\]/p' "${TB_SRC}" \
    | grep -oE '"[A-Za-z0-9_]+"' | tr -d '"'
}

all_test_cases() {
  regress_test_cases
  debug_test_cases
}

########################################## Usage
#
usage() {
  cat <<EOF

Usage:
  ${NAME} --test=<name> [options]
  ${NAME} --regress [options]

Examples:
  ${NAME} --test=tc_dv_dir_instr
  ${NAME} --test=tc_dv_dir_instr --plusarg=rand_itr=5 --plusarg=dump
  ${NAME} --test=tc_dv_dir_instr --define=TURBO9_TB_MODEL_FAST --define=TURBO9_RTL_SIM_T6551_FAST --define=TURBO9_RTL_SIM_DEBUG
  ${NAME} --test=tc_dv_run_hex --plusarg=hex_file=../asm/tb_dv_asm.hex --plusarg=dump
  ${NAME} --test=tc_dv_run_s19 --plusarg=s19_file=../asm/byte_sieve_6809.s19 --plusarg=hex_file=../asm/turbo9_boot.hex
  ${NAME} --regress --plusarg=rand_itr=100

Options:
  --test=NAME           Run one test case (see list below)
  --regress             Run the curated regression list (see list below)
  --define=MACRO[=VAL]  Compile-time -DMACRO[=VAL] for iverilog. Repeatable.
  --plusarg=NAME[=VAL]  Runtime +NAME[=VAL] for vvp. Repeatable.
  -h, --help            Show this help

Known compile-time macros (see tb/turbo9_tb_config.vh):
$(print_macro_table)

Known runtime plusargs understood by tb_dv_top.v:
$(print_plusarg_table)

Verification test cases (can be run individually or by --regress):
  $(regress_test_cases | tr '\n' ' ')

Debug test cases (excluded from --regress):
  $(debug_test_cases | tr '\n' ' ')
EOF
}

########################################## Parse arguments
#
TEST=""
REGRESS=0
DEFINES=()
PLUSARGS=()

if [[ $# -eq 0 ]]; then
  usage
  exit 0
fi

while [[ $# -gt 0 ]]; do
  case "$1" in
    --test=*)    TEST="${1#--test=}" ;;
    --regress)   REGRESS=1 ;;
    --define=*)  DEFINES+=("${1#--define=}") ;;
    --plusarg=*) PLUSARGS+=("${1#--plusarg=}") ;;
    -h|--help)   usage; exit 0 ;;
    *)
      echo "Unknown argument: $1" >&2
      usage
      exit 1
      ;;
  esac
  shift
done

if [[ -z "${TEST}" && "${REGRESS}" -eq 0 ]]; then
  echo "Must pass --test=<name> or --regress." >&2
  usage
  exit 1
fi

if [[ -n "${TEST}" && "${REGRESS}" -eq 1 ]]; then
  echo "Pass either --test=<name> or --regress, not both." >&2
  exit 1
fi

if [[ -n "${TEST}" ]]; then
  if ! all_test_cases | grep -qx "${TEST}"; then
    echo "Unknown test case: ${TEST}" >&2
    echo "" >&2
    echo "Valid test cases:" >&2
    echo "  $(all_test_cases | tr '\n' ' ')" >&2
    exit 1
  fi
  TESTS=("${TEST}")
else
  TESTS=($(regress_test_cases))
fi

########################################## Script-level defaults
#
# Everything else is pure passthrough (the testbench's own $value$plusargs
# defaults apply if omitted). Only seed and hex_file get a script-side
# default: seed because generating one is a script concern, not a Verilog
# concern; hex_file because nearly every tc_dv_*_instr test needs a base
# image loaded to have any code to execute.
HAVE_SEED=0
HAVE_HEX=0
for pa in "${PLUSARGS[@]}"; do
  [[ "${pa}" == seed=*     ]] && HAVE_SEED=1
  [[ "${pa}" == hex_file=* ]] && HAVE_HEX=1
done

if [[ "${HAVE_SEED}" -eq 0 ]]; then
  SEED=$(( $(date +%s%N) % (2**31) ))
  PLUSARGS+=("seed=${SEED}")
else
  for pa in "${PLUSARGS[@]}"; do
    [[ "${pa}" == seed=* ]] && SEED="${pa#seed=}"
  done
fi

if [[ "${HAVE_HEX}" -eq 0 ]]; then
  PLUSARGS+=("hex_file=${SCRIPT_DIR}/../asm/tb_dv_asm.hex")
fi

########################################## Compile tb_dv_top
#
CUR_DATE="$(date +"%m-%d-%y.%H-%M-%S")"
WORKDIR="${TB}"
[[ "${REGRESS}" -eq 1 ]] && WORKDIR="${TB}.${CUR_DATE}"

mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

DEFINE_FLAGS=()
for d in "${DEFINES[@]}"; do
  DEFINE_FLAGS+=("-D${d}")
done

echo ""
echo "Defines: ${DEFINES[*]:-none}"
echo "Compiling ${TB}..."
if ! iverilog -Wall -Wno-timescale -f "../${FLIST}" -g2001 "${DEFINE_FLAGS[@]}" -o "${TB}.vvp" > "${TB}.iv.com.log" 2>&1; then
  echo "${NAME}: Compile FAILED for ${TB}"
  for t in "${TESTS[@]}"; do
    mkdir -p "${t}"
    echo "${NAME}: Compile FAILED for ${TB}" > "${t}/${t}.iv.run.log"
  done
  exit 1
fi
echo "${NAME}: Compile OK for ${TB}"

########################################## Run tb_dv_top
#
echo ""
for t in "${TESTS[@]}"; do
  mkdir -p "${t}"
  (
    cd "${t}"

    RUN_PLUSARGS=("test_case=${t}")
    for pa in "${PLUSARGS[@]}"; do
      case "${pa}" in
        hex_file=*)
          abspath="$(cd "${INVOKED_FROM}" && realpath -m "${pa#hex_file=}")"
          cp "${abspath}" .
          RUN_PLUSARGS+=("hex_file=${abspath}")
          ;;
        s19_file=*)
          abspath="$(cd "${INVOKED_FROM}" && realpath -m "${pa#s19_file=}")"
          cp "${abspath}" .
          RUN_PLUSARGS+=("s19_file=${abspath}")
          ;;
        *)
          RUN_PLUSARGS+=("${pa}")
          ;;
      esac
    done

    CMD=("../${TB}.vvp")
    for pa in "${RUN_PLUSARGS[@]}"; do
      CMD+=("+${pa}")
    done

    echo "Run command: ${CMD[*]}"
    "${CMD[@]}" > "${t}.iv.run.raw.log" 2>&1
    rc=$?
    if [[ ${rc} -eq 0 ]]; then
      echo "${NAME}: Run OK for ${TB}.${t}"
    else
      echo "${NAME}: Run FAILED for ${TB}.${t}"
    fi
  ) &
done

wait

########################################## Filter Run Output Logs
#
rm -f "${TB}.summary.iv.run.log"
for t in "${TESTS[@]}"; do
  (
    cd "${t}"
    grep -v "warning: dumping array word" "${t}.iv.run.raw.log" > "${t}.iv.run.log"
    grep "\[TB;" "${t}.iv.run.log" >> "../${TB}.summary.iv.run.log"
    rm -f "${t}.iv.run.raw.log"
  )
done

########################################## Output PASS / FAIL Result
#
echo ""
echo "" >> "${TB}.summary.iv.run.log"
echo "${NAME}: Seed = ${SEED}"
echo "${NAME}: Seed = ${SEED}" >> "${TB}.summary.iv.run.log"

if grep -q FAIL "${TB}.summary.iv.run.log"; then
  echo "${NAME}: Run summary: FAIL for ${TB}"
  echo "${NAME}: Run summary: FAIL for ${TB}" >> "${TB}.summary.iv.run.log"
  touch "${TB}.summary.iv.run.FAIL"
  rm -f "${TB}.summary.iv.run.PASS"
else
  echo "${NAME}: Run summary: PASS for ${TB}"
  echo "${NAME}: Run summary: PASS for ${TB}" >> "${TB}.summary.iv.run.log"
  touch "${TB}.summary.iv.run.PASS"
  rm -f "${TB}.summary.iv.run.FAIL"
fi

echo ""

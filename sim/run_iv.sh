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
# Description: Run simulation script for Icarus Verilog
#
# ////////////////////////////////////////////////////////////////////////////
# History:
# 07.14.2023 - Kevin Phillipson
#   File header added
#
# ////////////////////////////////////////////////////////////////////////////
# [TURBO9_HEADER_END]


########################################## Add regression tests here
# 
set test_list = ("tc_dv_dir_instr" "tc_dv_ext_instr" "tc_dv_imm_instr" "tc_dv_rel_instr" "tc_dv_rel16_instr" "tc_dv_inh_instr" "tc_dv_sau_instr" "tc_dv_idx_a_instr" "tc_dv_idx_b_instr" "tc_dv_idx_d_instr" "tc_dv_idx_0b_instr" "tc_dv_idx_5b_instr" "tc_dv_idx_8b_instr" "tc_dv_idx_16b_instr" "tc_dv_idx_p1_instr" "tc_dv_idx_p2_instr" "tc_dv_idx_m1_instr" "tc_dv_idx_m2_instr" "tc_dv_idx_pc8_instr" "tc_dv_idx_pc16_instr" "tc_dv_ind_0b_instr" "tc_dv_ind_8b_instr" "tc_dv_16b_instr" "tc_dv_ind_a_instr" "tc_dv_ind_b_instr" "tc_dv_ind_d_instr")

########################################## Check Command Line 
#
set name=$0
if ($#argv <= 1) then
  echo ""
  echo "DV Testcase:"
  echo "Usage:    $name tb_dv_top <testcase> <rand_itr> <dump> <seed>"
  echo "Example:  $name tb_dv_top tc_dv_dir_instr"
  echo "Example:  $name tb_dv_top tc_dv_dir_instr 5 dump 1813988259"
  echo ""
  echo "DV Regression:"
  echo "Usage:    $name tb_dv_top regress <rand_itr>"
  echo "Example:  $name tb_dv_top regress 5"
  echo ""
  echo "Testcase Run Hex Code:"
  echo "Usage:    $name tb_dv_top tc_dv_run_hex <./path/file.hex> <dump>"
  echo "Example:  $name tb_dv_top tc_dv_run_hex ../asm/tb_dv_asm.hex dump"
  echo ""
  echo "Testcase Run S19 Code:"
  echo "Usage:    $name tb_dv_top tc_dv_run_s19 <./path/file.s19> <dump>"
  echo "Example:  $name tb_dv_top tc_dv_run_s19 ../asm/byte_sieve_6809.s19 dump"
  echo ""
  echo "Stim Bench:"
  echo "Usage:    $name tb_stim_top <testcase> <rand_itr> <dump> <seed>"
  echo "Example:  $name tb_stim_top tb_stim_fpga 1 dump"
  echo ""
  echo "DV Testcase list:"
  foreach test_x ( $test_list )
    echo -n "${test_x} "
  end
  echo ""
  exit
endif

if (!( -d ../tb )) then
  echo "Can't find the '../tb' directory."
  echo "Must be run in a a directory parallel to 'tb'"
  echo ""
  exit
endif

if (!( -d ../asm )) then
  echo "Can't find the '../asm' directory." 
  echo "Must be run in a a directory parallel to 'asm'"
  echo ""
  exit
endif


########################################## Get the current date and time
#  for log file name timestamp
set cur_date=`date +"%m-%d-%y.%H-%M-%S"`


########################################## Generate Seed for randomization
#
set nanotime=`date +%N`
set datetime=`date +%s`
set bigseed = `(echo "scale = 10; ($nanotime / $datetime)" | bc | sed 's/\.//')`
set seed = `echo "($bigseed % (2^31))" | bc`


########################################## Setup Test Variables
#
# Defaults
set tb   = $1
set test = $2
set rand_itr = "+rand_itr=1"
set dump = ""
set timestamp = ""
set hex_file = "../../../asm/tb_dv_asm.hex"
set s19_file = "../../../asm/byte_sieve_6809.s19"

echo ""

if ($tb == "tb_dv_top") then #######################################  TB = tb_dv_top

  switch ("$test")

    case "regress":
      echo "Setting up tb_dv_top regress..."
      set timestamp = ".${cur_date}"

      if ($#argv >= 3) then
        set rand_itr = "+rand_itr=${3}"
      endif
    breaksw
    
    case "tc_dv_run_hex":
      echo "Setting up tb_dv_top tc_dv_run_hex..."
      
      set test_list = ( "tc_dv_run_code" )
      set s19_file = ""

      if ($#argv >= 3) then
        set hex_file = "../../${3}"
      endif

      if ($#argv >= 4) then
        set dump = $4 
      endif
    breaksw
    
    case "tc_dv_run_s19":
      echo "Setting up tb_dv_top tc_dv_run_s19..."
      
      set test_list = ( "tc_dv_run_code" )
      set hex_file = "../../../asm/sim_boot.hex" # not necessary set below

      if ($#argv >= 3) then
        set s19_file = "../../${3}"
      endif

      if ($#argv >= 4) then
        set dump = $4 
      endif
    breaksw
    
    default:
      echo "Setting up tb_dv_top ${test}..."

      set test_list = ( "${test}" )
      set hex_file = "../../../asm/tb_dv_asm.hex"
      set s19_file = ""
    
      if ($#argv >= 3) then
        set rand_itr = "+rand_itr=${3}"
      endif

      if ($#argv >= 4) then
        set dump = $4 
      endif

      if ($#argv >= 5) then
        set seed = $5 
      endif
    breaksw
  endsw

else  #################################################  TB = tb_stim_top
      
  echo "Setting up tb_stim_top ${test}..."
  
  set test_list = ( "${test}" )

  if ($#argv >= 3) then
    set rand_itr = "+rand_itr=${3}"
  endif

  if ($#argv >= 4) then
    set dump = $4 
  endif

  if ($#argv >= 5) then
    set seed = $5 
  endif

endif

echo ""

########################################## Compile
#
mkdir -p ${tb}${timestamp}
cd ${tb}${timestamp}
iverilog -v -Wall -Wno-timescale -f ../../tb/f.list.${tb} -g2001 -o ${tb}.vvp >& ${tb}.iv.com.log
if ($status) then
  echo "${name}: Compile FAILED for ${tb}"
  foreach test_x ( $test_list )
    mkdir -p ${test_x}
    cd ${test_x}
    echo "${name}: Compile FAILED for ${tb}" > ${test_x}.iv.run.log
    cd ..
  end
  exit
else
  echo "${name}: Compile OK for ${tb}"
endif


##########################################  Run
#
foreach test_x ( $test_list )

  if ($dump != "") then
    set dump = "+dump_vcd=${test_x}.vcd"
  endif

  mkdir -p ${test_x}
  cd ${test_x}

  # Setup S19 & HEX files
  if ($test_x == "tc_dv_run_code") then
    if (s19_file == "") then
      cp ${hex_file} .
      set hex_arg = "+hex_file=${hex_file}"
      set s19_arg = ""
    else
      cp ../../../asm/sim_boot.hex .
      set hex_arg = "+hex_file=../../../asm/sim_boot.hex"
      cp ${s19_file} .
      set s19_arg = "+s19_file=${s19_file}"
    endif
  else
    cp ${hex_file} .
    set hex_arg = "+hex_file=${hex_file}"
    set s19_arg = ""
  endif
  if ($tb == "tb_stim_top") then
    cp ../../../rtl/default*.hex .
  endif

#  set run_cmd = "../${tb}.vvp -lxt2 +${test_x} +seed=${seed} ${rand_itr} ${dump} ${hex_arg} ${s19_arg}"
  set run_cmd = "../${tb}.vvp +${test_x} +seed=${seed} ${rand_itr} ${dump} ${hex_arg} ${s19_arg}"
  echo ""
  echo "Run command:"
  echo $run_cmd
  echo ""
  $run_cmd >& ${test_x}.iv.run.raw.log &
  if ($status) then
    echo "${name}: Run FAILED for ${tb}.${test_x}"
  else
    echo "${name}: Run OK for ${tb}.${test_x}"
  endif
  cd ..
end

wait


########################################## Filter Run Output Logs
#
rm -f ${tb}.summary.iv.run.log
foreach test_x ( $test_list )
  cd ${test_x}
  grep -v "warning: dumping array word" ${test_x}.iv.run.raw.log > ${test_x}.iv.run.log
  grep "\[TB\;" ${test_x}.iv.run.log >> ../${tb}.summary.iv.run.log
  rm ${test_x}.iv.run.raw.log
  cd ..
end


########################################## Output PASS / FAIL Result
#
echo ""
echo "" >> ${tb}.summary.iv.run.log
echo "${name}: Seed = ${seed}"
echo "${name}: Seed = ${seed}" >> ${tb}.summary.iv.run.log

grep -q FAIL ${tb}.summary.iv.run.log
if ($status) then
  echo "${name}: Run summary: PASS for ${tb}"
  echo "${name}: Run summary: PASS for ${tb}" >> ${tb}.summary.iv.run.log
  touch ${tb}.summary.iv.run.PASS
  rm -f ${tb}.summary.iv.run.FAIL
else
  echo "${name}: Run summary: FAIL for ${tb}"
  echo "${name}: Run summary: FAIL for ${tb}" >> ${tb}.summary.iv.run.log
  touch ${tb}.summary.iv.run.FAIL
  rm -f ${tb}.summary.iv.run.PASS
endif


echo ""

cd ..

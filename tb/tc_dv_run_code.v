// [TURBO9_HEADER_START]
//////////////////////////////////////////////////////////////////////////////
//                          Turbo9 Microprocessor IP
//////////////////////////////////////////////////////////////////////////////
// Website: www.turbo9.org
// Contact: team[at]turbo9[dot]org
//////////////////////////////////////////////////////////////////////////////
// [TURBO9_LICENSE_START]
// BSD-1-Clause
//
// Copyright (c) 2020-2023
// Kevin Phillipson
// Michael Rywalt
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
// 1. Redistributions of source code must retain the above copyright notice,
//    this list of conditions and the following disclaimer.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS AND CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.
// [TURBO9_LICENSE_END]
//////////////////////////////////////////////////////////////////////////////
// Engineer: Kevin Phillipson
// Description: Testcase: Run Code
//
//////////////////////////////////////////////////////////////////////////////
// History:
// 07.14.2023 - Kevin Phillipson
//   File header added
//
//////////////////////////////////////////////////////////////////////////////
// [TURBO9_HEADER_END]

/////////////////////////////////////////////////////////////////////////////
//                  Test Code Testcase
/////////////////////////////////////////////////////////////////////////////

  `define RUN_CODE_RESET_CYCLES    100
  `define RUN_CODE_START_CYCLES    10_000
  `define RUN_CODE_FINISH_CYCLES  300_000_000

  ////////////////////////////////////////////////////////////////////////////
  // Test Code
  ////////////////////////////////////////////////////////////////////////////
  task tc_dv_run_code;

    integer error_cnt;
    real    dut_ticks;
    real    model_ticks;
    real    ratio;

  begin

    ///////////////// Load the instruction setup
    //
    $display("[TB: tc_dv_run_code]"); 
    $display("[TB: tc_dv_run_code]"); 
    $display("[TB: tc_dv_run_code] ////////////////////////////////////////////////////////////////////"); 
    $display("[TB; tc_dv_run_code] // Test Code ");
    $display("[TB: tc_dv_run_code] ////////////////////////////////////////////////////////////////////"); 

    error_cnt = 0;
    
    ///////////////// Loading HEX test code
    //
    $display("[TB: tc_dv_run_code] Loading HEX test code: %0s",hex_file);
    $readmemh(hex_file,`tb_mem);
    
    ///////////////// Loading S19 test code
    //
    if (s19_file != "") begin
      $display("[TB: tc_dv_run_code] Loading S19 test code: %0s",s19_file);
      load_s19_tb_mem(s19_file);
    end

    ///////////////// Copy testbench program into model and DUT memory
    //
    copy_tb_mem;
    
    
    ///////////////// Reset DUT and Model
    //
    $display("[TB: tc_dv_run_code] Resetting DUT and Model");
    reset = 1'b1;
    wait_clk_cycles(4);

    ///////////////// Open Console File
    //
    console_file_open("tc_dv_run_code");

    ///////////////// Ensure the output port are cleared
    //
    $display("[TB: tc_dv_run_code] Waiting for output ports of Model and DUT to clear...");
    wait_bits_clear(8'hFF, `RUN_CODE_RESET_CYCLES, error_cnt);
    
    
    ///////////////// Release Reset and begin testcase
    //
    $display("[TB: tc_dv_run_code] Release reset and begin testcase!");
    reset = 1'b0;
    
    
    ///////////////// Waiting for indication of begining of code under test
    //
    $display("[TB: tc_dv_run_code] Waiting for Model and DUT to indicate begining of code under test...");
    wait_bits_set(8'h01, `RUN_CODE_START_CYCLES, error_cnt);
    
    
    ///////////////// Waiting for indication of completed code under test
    //
    $display("[TB: tc_dv_run_code] Waiting for Model and DUT to indicate completion of code under test...");
    wait_bits_set(8'h80, `RUN_CODE_FINISH_CYCLES, error_cnt);
    model_ticks = model_cycle_cnt;
    dut_ticks = `dut_cycle_cnt;

    wait_clk_cycles(32); // wait a few cycles to capture the output port in waveform dump

    error_cnt += model_error; //add model error to error count

    
    $display("[TB: tc_dv_run_code] Resetting DUT and Model");
    reset = 1'b1;
    wait_clk_cycles(4);
 
    ///////////////// Close Console File
    //
    console_file_close;

    ///////////////// Running a diff on the memories
    //
    $display("[TB: tc_dv_run_code] Comparing DUT memory and Model memory...");
    error_cnt += mem_diff_cnt(1'b0);
    

    ///////////////// Display performance
    //
    $display("[TB: tc_dv_run_code] Turbo9 clock cycles:       %16d", dut_ticks);
    $display("[TB: tc_dv_run_code] 6809 Model E clock cycles: %16d", model_ticks);
    ratio = model_ticks / dut_ticks;
    $display("[TB: tc_dv_run_code] Ratio: %f", ratio);

    
    ///////////////// Test PASS / FAIL summary 
    //
    if (error_cnt == 0) begin
      if (s19_file != "") begin
        $display("[TB: tc_dv_run_code] Test PASS for %0s",s19_file);
      end else begin
        $display("[TB: tc_dv_run_code] Test PASS for %0s",hex_file);
      end
      pass_test_cnt++;
    end else begin
      $display("[TB: tc_dv_run_code] ERROR count: %0d", error_cnt);
      if (s19_file != "") begin
        $display("[TB; tc_dv_run_code] Test FAIL for %0s",s19_file);
      end else begin
        $display("[TB; tc_dv_run_code] Test FAIL for %0s",hex_file);
      end
      $display("[TB: tc_dv_run_code] Exiting... ");
      fail_test_cnt++;
    end
    
  end
  endtask
  

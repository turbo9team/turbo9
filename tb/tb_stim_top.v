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
// Description: Stimbench: Top level
//
//////////////////////////////////////////////////////////////////////////////
// History:
// 07.14.2023 - Kevin Phillipson
//   File header added
//
//////////////////////////////////////////////////////////////////////////////
// [TURBO9_HEADER_END]

/////////////////////////////////////////////////////////////////////////////
//                     Top Level Of Turbo9 Testbench
/////////////////////////////////////////////////////////////////////////////
`timescale 1ps/1ps

module tb_stim_top;

  ///////////////////// Select one of the following:
  //`define TURBO9 
  //`define TURBO9_S
  `define TURBO9_R
  /////////////////////

  `define MEM_ADDR_WIDTH  15 //32 Kbyte Memory, adjust the asm accordingly


`ifdef TURBO9_R
  `define dut_mem_even    I_fpga_top.I_soc_top_r.I_even_syncram_8bit.ram
  `define dut_mem_odd     I_fpga_top.I_soc_top_r.I_odd_syncram_8bit.ram
`else
  `define dut_mem         I_fpga_top.I_soc_top.I_syncram_8bit.ram
`endif


  reg sys_clk;
  reg fpga_reset;

  `include "tb_stim_flags.v"         // Flags
  `include "tb_stim_fpga.v"          // FPGA
  //`include "tb_stim_mul_div.v"       // MUL_DIV

  integer seed;
  integer rand_itr_total;

  ////////////////////////////////////////////////////////////////////////////
  // Dump VCD
  ////////////////////////////////////////////////////////////////////////////
  reg [(128*8)-1:0] vcd_file_name;
  integer dump_idx;
  initial
  begin
    if ($value$plusargs("dump_vcd=%s", vcd_file_name)) begin
      $dumpfile(vcd_file_name);
      $dumpvars(0,tb_stim_top);
      /*
      for (dump_idx = 16'h2000; dump_idx < 16'h3000; dump_idx = dump_idx + 1) begin
        $dumpvars(0, `dut_mem[dump_idx]);
        //$dumpvars(0, `tb_mem[dump_idx]);
      end
      
      for (dump_idx = (2**`MEM_ADDR_WIDTH)-4096; dump_idx < (2**`MEM_ADDR_WIDTH); dump_idx = dump_idx + 1) begin
        $dumpvars(0, `dut_mem[dump_idx]);
        //$dumpvars(0, `tb_mem[dump_idx]);
      end
      */
    end
  end



  ////////////////////////////////////////////////////////////////////////////
  // Generate Clock
  ////////////////////////////////////////////////////////////////////////////
  initial begin
    sys_clk = 1'b0;

    fork
      forever begin
        #5000 sys_clk = ~sys_clk;
      end
      // Add more clocks here
    join
  end

  /////////////////////////////////////////////////////////////////////////////
  // Testbench "Main"
  /////////////////////////////////////////////////////////////////////////////
  initial begin

    fpga_reset =  1'b1;
    
    $display("[TB; tb_stim_top      ]"); 
    $display("[TB; tb_stim_top      ] ////////////////////////////////////////////////////////////////////"); 
    $display("[TB; tb_stim_top      ] //     Turbo9 Stim Bench Start");
    $display("[TB; tb_stim_top      ] ////////////////////////////////////////////////////////////////////"); 
    $display("[TB; tb_stim_top      ]"); 


    /////////// Initialize global variables / signals from the command line
    //
    seed = 123; // default
    if ($value$plusargs ("seed=%0d", seed));
    //
    rand_itr_total  = 4; // default
    if ($value$plusargs ("rand_itr=%0d", rand_itr_total));

    $display("[TB; tb_stim_top      ] Random seed value = %0d", seed);
    $display("[TB; tb_stim_top      ] Random iterations = %0d", rand_itr_total);
    $display("[TB; tb_stim_top      ]"); 



    /////////// Run selected tests
    //
    if ($test$plusargs("tb_stim_flags")) begin // Test Flags
      tb_stim_flags;
    end
    //
    if ($test$plusargs("tb_stim_fpga")) begin // Test FPGA
      tb_stim_fpga;
    end
    //
    //if ($test$plusargs("tb_stim_mul_div")) begin // Test MUL_DIV
    //  tb_stim_mul_div;
    //end


    $display("[TB; tb_stim_top      ]"); 
    $display("[TB; tb_stim_top      ] ////////////////////////////////////////////////////////////////////"); 
    $display("[TB; tb_stim_top      ] //      Turbo9 Stim Bench End");
    $display("[TB; tb_stim_top      ] ////////////////////////////////////////////////////////////////////"); 
    $display("[TB; tb_stim_top      ]"); 


    $finish();

  end


endmodule

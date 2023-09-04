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
// Description: Testbench: Top level of the testbench
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

module tb_dv_top;

  ///////////////////// Select one of the following:
  //`define TURBO9 
  //`define TURBO9_S
  `define TURBO9_R
  /////////////////////

  `define SIM_TURBO9  // Turns on debug strings in decode table verilog files

  `define MEM_ADDR_WIDTH  15 //32 Kbyte Memory, adjust the asm accordingly

  `define model_mem       I_tb_dv_6809_model.I_tb_dv_6809_memory.memory
//`define dut_mem         I_broken_6809_model.I_tb_dv_6809_memory.memory

`ifdef TURBO9_R
  `define dut_mem_even    I_soc_top_r.I_even_syncram_8bit.ram
  `define dut_mem_odd     I_soc_top_r.I_odd_syncram_8bit.ram
  `define dut_cycle_cnt   I_soc_top_r.clk_cnt_rd_dat
`else
  `define dut_mem         I_soc_top.I_syncram_8bit.ram
  `define dut_cycle_cnt   I_soc_top.clk_cnt_rd_dat
`endif

  `define tb_mem          I_tb_dv_memory.memory

  `include "sim_boot.vh"            // Address defines from simulation bootloader 
  `include "tb_dv_asm.vh"           // Address defines from assembly testbench 
  `include "tb_dv_lib.v"            // Library of utility tasks & functions
  `include "tc_dv_dir_instr.v"      // Testcase for direct addressing instrutions
  `include "tc_dv_ext_instr.v"      // Testcase for extended addressing instrutions
  `include "tc_dv_imm_instr.v"      // Testcase for immediate addressing instrutions
  `include "tc_dv_rel_instr.v"      // Testcase for relative addressing 8-bit instrutions
  `include "tc_dv_rel16_instr.v"    // Testcase for relative addressing 16-bit instrutions
  `include "tc_dv_inh_instr.v"      // Testcase for inherent addressing instructions
  `include "tc_dv_sau_instr.v"      // Testcase for sequential arithmetic instructions
  `include "tc_dv_run_code.v"       // Testcase for running code
  `include "tc_dv_idx_a_instr.v"    // Testcase for indexed
  `include "tc_dv_idx_b_instr.v"    // Testcase for indexed
  `include "tc_dv_idx_d_instr.v"    // Testcase for indexed
  `include "tc_dv_idx_0b_instr.v"   // Testcase for indexed
  `include "tc_dv_idx_5b_instr.v"   // Testcase for indexed
  `include "tc_dv_idx_8b_instr.v"   // Testcase for indexed
  `include "tc_dv_idx_16b_instr.v"  // Testcase for indexed
  `include "tc_dv_idx_p1_instr.v"   // Testcase for indexed
  `include "tc_dv_idx_p2_instr.v"   // Testcase for indexed
  `include "tc_dv_idx_m1_instr.v"   // Testcase for indexed
  `include "tc_dv_idx_m2_instr.v"   // Testcase for indexed
  `include "tc_dv_idx_pc8_instr.v"  // Testcase for indexed
  `include "tc_dv_idx_pc16_instr.v" // Testcase for indexed
  `include "tc_dv_ind_0b_instr.v"   // Testcase for indirect indexed
  `include "tc_dv_ind_8b_instr.v"   // Testcase for indirect indexed
  `include "tc_dv_ind_16b_instr.v"  // Testcase for indirect indexed
  `include "tc_dv_ind_a_instr.v"    // Testcase for indirect indexed
  `include "tc_dv_ind_b_instr.v"    // Testcase for indirect indexed
  `include "tc_dv_ind_d_instr.v"    // Testcase for indirect indexed
  `include "tc_dv_ind_p2_instr.v"   // Testcase for indirect indexed
  `include "tc_dv_ind_m2_instr.v"   // Testcase for indirect indexed
  `include "tc_dv_ind_pc8_instr.v"  // Testcase for indirect indexed
  `include "tc_dv_ind_pc16_instr.v" // Testcase for indirect indexed
  `include "tc_dv_exg_8b_instr.v"   // Testcase for exchange 8-bit registers
  `include "tc_dv_exg_16b_instr.v"  // Testcase for exchange 16-bit registers
  `include "tc_dv_tfr_8b_instr.v"   // Testcase for transfer 8-bit registers
  `include "tc_dv_tfr_16b_instr.v"  // Testcase for transfer 16-bit registers

  reg sysclk;
  reg reset;

  integer seed;
  integer rand_itr_total;
  integer fail_test_cnt;
  integer pass_test_cnt;
  reg [(128*8)-1:0] hex_file;
  reg [(128*8)-1:0] s19_file;


  integer    model_cycle_cnt;
  wire       model_error;
  wire [7:0] model_output_port;
  wire [7:0] dut_output_port;

  ////////////////////////////////////////////////////////////////////////////
  // Dump VCD
  ////////////////////////////////////////////////////////////////////////////
  reg [(128*8)-1:0] vcd_file_name;
  integer dump_idx;
  initial
  begin
    if ($value$plusargs("dump_vcd=%s", vcd_file_name)) begin
      $dumpfile(vcd_file_name);
      $dumpvars(0,tb_dv_top);
      /*
      for (dump_idx = 0; dump_idx < 7; dump_idx = dump_idx + 1) begin
        $dumpvars(0, I_soc_top_r.I_turbo9_r.I_turbo9_pipeline.I_turbo9_fetch_stage.I_turbo9_fetch_queue.queue_data_nxt[dump_idx]);
        $dumpvars(0, I_soc_top_r.I_turbo9_r.I_turbo9_pipeline.I_turbo9_fetch_stage.I_turbo9_fetch_queue.queue_data_reg[dump_idx]);
        $dumpvars(0, I_soc_top_r.I_turbo9_r.I_turbo9_pipeline.I_turbo9_fetch_stage.I_turbo9_fetch_queue.queue_data_shift4[dump_idx]);
        $dumpvars(0, I_soc_top_r.I_turbo9_r.I_turbo9_pipeline.I_turbo9_fetch_stage.I_turbo9_fetch_queue.queue_data_shift2[dump_idx]);
        $dumpvars(0, I_soc_top_r.I_turbo9_r.I_turbo9_pipeline.I_turbo9_fetch_stage.I_turbo9_fetch_queue.queue_data_shift1[dump_idx]);
      end
       
      for (dump_idx = 16'h2000; dump_idx < 16'h3000; dump_idx = dump_idx + 1) begin
        $dumpvars(0, `model_mem[dump_idx]);
        $dumpvars(0, `dut_mem[dump_idx]);
        //$dumpvars(0, `tb_mem[dump_idx]);
      end
      
      for (dump_idx = (2**`MEM_ADDR_WIDTH)-4096; dump_idx < (2**`MEM_ADDR_WIDTH); dump_idx = dump_idx + 1) begin
        $dumpvars(0, `model_mem[dump_idx]);
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
    sysclk = 1'b0;

    fork
      forever begin
        #5000 sysclk = ~sysclk;
      end
      // Add more clocks here
    join
  end

  /////////////////////////////////////////////////////////////////////////////
  // Testbench "Main"
  /////////////////////////////////////////////////////////////////////////////
  initial begin

    /////////// Initialize global variables / signals
    //
    pass_test_cnt   = 0;
    fail_test_cnt   = 0;
    reset           = 1'b1;
    
    
    $display("[TB; tb_dv_top      ] ////////////////////////////////////////////////////////////////////"); 
    $display("[TB; tb_dv_top      ] //     Turbo9 Testbench ");
    $display("[TB; tb_dv_top      ] ////////////////////////////////////////////////////////////////////"); 
    $display("[TB; tb_dv_top      ]"); 


    /////////// Initialize global variables / signals from the command line
    //
    // Defaults
    seed = 123;
    rand_itr_total  = 4;
    hex_file = "";
    s19_file = "";
    //
    if ($value$plusargs("seed=%0d", seed));
    if ($value$plusargs("rand_itr=%0d", rand_itr_total));
    if ($value$plusargs("hex_file=%s", hex_file));
    if ($value$plusargs("s19_file=%s", s19_file));

    $display("[TB; tb_dv_top      ] Random seed value = %0d", seed);
    $display("[TB; tb_dv_top      ] Random iterations = %0d", rand_itr_total);
    $display("[TB; tb_dv_top      ] HEX file = %0s", hex_file);
    $display("[TB; tb_dv_top      ] S19 file = %0s", s19_file);
    $display("[TB; tb_dv_top      ]"); 



    /////////// Run selected tests
    //
    if ($test$plusargs("tc_dv_dir_instr")) begin // Direct Addressing Test
      tc_dv_dir_instr;
    end
    //
    if ($test$plusargs("tc_dv_ext_instr")) begin // Extended Addressing Test
      tc_dv_ext_instr;
    end
    //
    if ($test$plusargs("tc_dv_imm_instr")) begin // Immediate Addressing Test
      tc_dv_imm_instr;
    end
    //
    if ($test$plusargs("tc_dv_rel_instr")) begin // Relative Addressing Test
      tc_dv_rel_instr;
    end
    //
    if ($test$plusargs("tc_dv_rel16_instr")) begin // Long Relative Addressing Test
      tc_dv_rel16_instr;
    end
    //
    if ($test$plusargs("tc_dv_run_code")) begin // Run HEX or S19 Code
      tc_dv_run_code;
    end
    //
    if ($test$plusargs("tc_dv_inh_instr")) begin // Inherent Addressing Test
      tc_dv_inh_instr;
    end
    //
    if ($test$plusargs("tc_dv_sau_instr")) begin // Sequential Arithmetic Test
      tc_dv_sau_instr;
    end
    //
    if ($test$plusargs("tc_dv_idx_a_instr")) begin // Indexed A Offset Addressing Test
      tc_dv_idx_a_instr;
    end
    //
    if ($test$plusargs("tc_dv_idx_b_instr")) begin // Indexed B Offset Addressing Test
      tc_dv_idx_b_instr;
    end
    //
    if ($test$plusargs("tc_dv_idx_d_instr")) begin // Indexed D Offset Addressing Test
      tc_dv_idx_d_instr;
    end
    //
    if ($test$plusargs("tc_dv_idx_0b_instr")) begin // Indexed No Offset Addressing Test
      tc_dv_idx_0b_instr;
    end
    //
    if ($test$plusargs("tc_dv_idx_5b_instr")) begin // Indexed 5bit Offset Addressing Test
      tc_dv_idx_5b_instr;
    end
    //
    if ($test$plusargs("tc_dv_idx_8b_instr")) begin // Indexed 8bit Offset Addressing Test
      tc_dv_idx_8b_instr;
    end
    //
    if ($test$plusargs("tc_dv_idx_16b_instr")) begin // Indexed 16bit Offset Addressing Test
      tc_dv_idx_16b_instr;
    end
    //
    //
    if ($test$plusargs("tc_dv_idx_p1_instr")) begin // Indexed Auto Increment by 1 Addressing Test
      tc_dv_idx_p1_instr;
    end
    //
    if ($test$plusargs("tc_dv_idx_p2_instr")) begin // Indexed Auto Increment by 2 Addressing Test
      tc_dv_idx_p2_instr;
    end
    //
    if ($test$plusargs("tc_dv_idx_m1_instr")) begin // Indexed Auto Increment by 1 Addressing Test
      tc_dv_idx_m1_instr;
    end
    //
    if ($test$plusargs("tc_dv_idx_m2_instr")) begin // Indexed Auto Increment by 2 Addressing Test
      tc_dv_idx_m2_instr;
    end
    //
    if ($test$plusargs("tc_dv_idx_pc8_instr")) begin // Indexed PC 8-bit Offset Addressing Test
      tc_dv_idx_pc8_instr;
    end
    if ($test$plusargs("tc_dv_idx_pc16_instr")) begin // Indexed PC 16-bit Offset Addressing Test
      tc_dv_idx_pc16_instr;
    end
    if ($test$plusargs("tc_dv_ind_0b_instr")) begin // Indexed Indirect Addressing Test
      tc_dv_ind_0b_instr;
    end
    if ($test$plusargs("tc_dv_ind_8b_instr")) begin // Indexed 8-bit Indirect Addressing Test
      tc_dv_ind_8b_instr;
    end
    if ($test$plusargs("tc_dv_ind_16b_instr")) begin // Indexed 16-bit Indirect Addressing Test
      tc_dv_ind_16b_instr;
    end
    if ($test$plusargs("tc_dv_ind_a_instr")) begin // Indexed A Offset Indirect Addressing Test
      tc_dv_ind_a_instr;
    end
    if ($test$plusargs("tc_dv_ind_b_instr")) begin // Indexed B Offset Indirect Addressing Test
      tc_dv_ind_b_instr;
    end
    if ($test$plusargs("tc_dv_ind_d_instr")) begin // Indexed D Offset Indirect Addressing Test
      tc_dv_ind_d_instr;
    end
    if ($test$plusargs("tc_dv_ind_p2_instr")) begin // Indexed Auto Increment by 2 Indirect Addressing Test
      tc_dv_ind_p2_instr;
    end
    if ($test$plusargs("tc_dv_ind_m2_instr")) begin // Indexed Auto Increment by 2 Indirect Addressing Test
      tc_dv_ind_m2_instr;
    end
    if ($test$plusargs("tc_dv_ind_pc8_instr")) begin // Indexed Auto Increment by 2 Indirect Addressing Test
      tc_dv_ind_pc8_instr;
    end
    if ($test$plusargs("tc_dv_ind_pc16_instr")) begin // Indexed Auto Increment by 2 Indirect Addressing Test
      tc_dv_ind_pc16_instr;
    end
    if ($test$plusargs("tc_dv_exg_8b_instr")) begin // Exchange 8-bit Registers Test
      tc_dv_exg_8b_instr;
    end
    if ($test$plusargs("tc_dv_exg_16b_instr")) begin // Exchange 16-bit Registers Test
      tc_dv_exg_16b_instr;
    end
    if ($test$plusargs("tc_dv_tfr_8b_instr")) begin // Exchange 8-bit Registers Test
      tc_dv_tfr_8b_instr;
    end
    if ($test$plusargs("tc_dv_tfr_16b_instr")) begin // Exchange 16-bit Registers Test
      tc_dv_tfr_16b_instr;
    end
    if ($test$plusargs("debug_random")) begin // debug random
      debug_random;
    end


    $display("[TB; tb_dv_top      ]"); 
    $display("[TB; tb_dv_top      ]"); 
    $display("[TB; tb_dv_top      ] ////////////////////////////////////////////////////////////////////"); 
    $display("[TB; tb_dv_top      ] //     Turbo9 Testbench Summary");
    $display("[TB; tb_dv_top      ] ////////////////////////////////////////////////////////////////////"); 
    $display("[TB; tb_dv_top      ]"); 
    $display("[TB; tb_dv_top      ] Number of passing tests: %0d", pass_test_cnt); 
    $display("[TB; tb_dv_top      ] Number of failing tests: %0d", fail_test_cnt); 
    $display("[TB; tb_dv_top      ]"); 
    if(fail_test_cnt > 0 || pass_test_cnt == 0) begin
      $display("[TB; tb_dv_top      ] Testbench FAIL!"); 
    end else begin
      $display("[TB; tb_dv_top      ] Testbench PASS!"); 
    end
    $display("[TB; tb_dv_top      ]"); 

    $finish();

  end

 
  /////////////////////////////////////////////////////////////////////////////
  // DUT
  /////////////////////////////////////////////////////////////////////////////

  reg turbo9_rst_meta;
  reg turbo9_rst_sync;

  always @(posedge reset or posedge sysclk)
  begin
    if (reset) begin
      turbo9_rst_meta <= 1'b1;
      turbo9_rst_sync <= 1'b1;
    end else begin
      turbo9_rst_meta <= 1'b0;
      turbo9_rst_sync <= turbo9_rst_meta;
    end
  end

`ifdef TURBO9_R
  soc_top_r
  #(
    `MEM_ADDR_WIDTH // MEM_ADDR_WIDTH 
  )
  I_soc_top_r
  (
    // Inputs: Clock & Reset
    .RST_I         (turbo9_rst_sync), // Reset. Active high and synchronized to CLK_I
    .CLK_I         (sysclk), // Clock
    //
    // Inputs 
    .RXD_PIN_I     (1'b1),
  
    // Outputs
    .TXD_PIN_O     (),
    .OUTPUT_PORT_O (dut_output_port)
  );
`else
  soc_top
  #(
    `MEM_ADDR_WIDTH // MEM_ADDR_WIDTH 
  )
  I_soc_top
  (
    // Inputs: Clock & Reset
    .RST_I         (turbo9_rst_sync), // Reset. Active high and synchronized to CLK_I
    .CLK_I         (sysclk), // Clock
    //
    // Inputs 
    .RXD_PIN_I     (1'b1),
  
    // Outputs
    .TXD_PIN_O     (),
    .OUTPUT_PORT_O (dut_output_port)
  );
`endif

  /////////////////////////////////////////////////////////////////////////////
  // 6809 Behavioral Model
  /////////////////////////////////////////////////////////////////////////////
  tb_dv_6809_model
  #(
    `MEM_ADDR_WIDTH, // MEM_ADDR_WIDTH 
    0,  // BREAK_COM_DIR_OP 
  )
  I_tb_dv_6809_model
  (
    // Inputs: Clock & Reset
    .RST_N_I        (~reset),
    .CLK_I          (sysclk),

    // Inputs
    .QUIET_I      (1'b1),
    .FAST_CLK_I   (1'b1),


    // Outputs
    .E_CLK_O        (),
    .Q_CLK_O        (),
    .ERROR_O        (model_error),
    .OUTPUT_PORT_O  (model_output_port),
    .CYCLE_CNT_O    (model_cycle_cnt)
  );
  
  
  /////////////////////////////////////////////////////////////////////////////
  // Broken 6809 Behavioral Model
  /////////////////////////////////////////////////////////////////////////////
  /*
  tb_dv_6809_model
  #(
    `MEM_ADDR_WIDTH, // MEM_ADDR_WIDTH 
    1,  // BREAK_COM_DIR_OP 
  )
  I_broken_6809_model
  (
    // Inputs: Clock & Reset
    .RST_N_I        (~reset),
    .CLK_I          (sysclk),

    // Inputs
    .QUIET_I      (1'b1),
    .FAST_CLK_I   (1'b1),

    // Outputs
    .E_CLK_O        (),
    .Q_CLK_O        (),
    .ERROR_O        (),
    .OUTPUT_PORT_O  (dut_output_port)
  );
  */
  /////////////////////////////////////////////////////////////////////////////
  // Testbench Memory
  /////////////////////////////////////////////////////////////////////////////
  tb_dv_memory
  #(
    `MEM_ADDR_WIDTH
  )
  I_tb_dv_memory ();

  always @(posedge sysclk)
  begin
    if ((dut_output_port[1]) && (~dut_output_port[6]) && ((`dut_cycle_cnt % 100_000) == 0)) begin
      $display("[TB: tb_dv_top      ] DUT clock cycle count: %d", `dut_cycle_cnt);
    end
    if ((model_output_port[1]) && (~model_output_port[6]) && ((model_cycle_cnt % 100_000) == 0)) begin
      $display("[TB: tb_dv_top      ] Model E clock cycle count: %d", model_cycle_cnt);


    end
  end

  ////////////////////////////////////////////////////////////////////////////
  // Console File Output
  ////////////////////////////////////////////////////////////////////////////
  integer   model_console_file_ptr;
  integer   dut_console_file_ptr;
  reg       console_output_en;
  integer   putchar_en_addr;
  integer   putchar_buf_addr;

  initial begin
    console_output_en = 1'b0;
    putchar_en_addr = `asm_sim_putchar_en-((2**16)-(2**`MEM_ADDR_WIDTH));
    putchar_buf_addr = `asm_sim_putchar_buf-((2**16)-(2**`MEM_ADDR_WIDTH));
  end

  task console_file_open(input [(32*8)-1:0] test_name);
    reg [(64*8)-1:0] console_file_name;
  begin
    $sformat(console_file_name,"%0s.model.console.txt",test_name);
    model_console_file_ptr = $fopen(console_file_name,"w");
    $display("[TB: console_file_open] Opening %0s for console output", console_file_name);
    //
    $sformat(console_file_name,"%0s.dut.console.txt",test_name);
    dut_console_file_ptr = $fopen(console_file_name,"w");
    $display("[TB: console_file_open] Opening %0s for console output", console_file_name);
    //
    console_output_en = 1'b1;
  end
  endtask

  task console_file_close;
  begin
    $fclose(model_console_file_ptr);
    $fclose(dut_console_file_ptr);
  end
  endtask

  wire        model_putchar_en  = `model_mem[putchar_en_addr][0] & console_output_en;
  wire [7:0]  model_putchar_buf = `model_mem[putchar_buf_addr];

`ifdef TURBO9_R
  wire        dut_putchar_en  = (~putchar_en_addr[0]) ? (`dut_mem_even[putchar_en_addr[15:1]][0] & console_output_en) :
                                                        (`dut_mem_odd [putchar_en_addr[15:1]][0] & console_output_en) ;

  wire [7:0]  dut_putchar_buf = (~putchar_buf_addr[0]) ? `dut_mem_even[putchar_buf_addr[15:1]] :
                                                         `dut_mem_odd [putchar_buf_addr[15:1]] ;
`else
  wire        dut_putchar_en  = `dut_mem[putchar_en_addr][0] & console_output_en;
  wire [7:0]  dut_putchar_buf = `dut_mem[putchar_buf_addr];
`endif

  always @(posedge model_putchar_en)
  begin
    $fwrite(model_console_file_ptr,"%0s", model_putchar_buf);
  end

  always @(posedge dut_putchar_en)
  begin
    $fwrite(dut_console_file_ptr,"%0s", dut_putchar_buf);
  end

endmodule


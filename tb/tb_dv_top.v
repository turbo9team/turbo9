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

`include "turbo9_tb_config.vh"

module tb_dv_top;

  `define TURBO9_CPU_SIM_DEBUG      // Turns on debug strings in decode table verilog files
  `define TURBO9_SOC_SIM_T6551_FAST  // Runs T6551 UART as fast as possible

  `include "tb_dv_asm.vh"           // Address defines from assembly testbench 
  `include "tb_dv_lib.v"            // Library of utility tasks & functions
  `include "tc_dv_dir_instr.v"      // Testcase for direct addressing instrutions
  `include "tc_dv_ext_instr.v"      // Testcase for extended addressing instrutions
  `include "tc_dv_imm_instr.v"      // Testcase for immediate addressing instrutions
  `include "tc_dv_rel_instr.v"      // Testcase for relative addressing 8-bit instrutions
  `include "tc_dv_rel16_instr.v"    // Testcase for relative addressing 16-bit instrutions
  `include "tc_dv_inh_instr.v"      // Testcase for inherent addressing instructions
  `include "tc_dv_sau_instr.v"      // Testcase for sequential arithmetic instructions
  `include "tc_dv_run_s19.v"        // Testcase for running s19 code
  `include "tc_dv_run_hex.v"        // Testcase for running hex code
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
  reg tb_done;

  integer seed;
  integer rand_itr_total;
  integer fail_test_cnt;
  integer pass_test_cnt;
  reg [(128*8)-1:0] hex_file;
  reg [(128*8)-1:0] s19_file;


  wire [7:0]  model_output_port;
  reg         model_console_en;
  reg         model_upload_en;
  wire        model_uart_rxd_pin;
  wire        model_uart_cts = ~`model_uart_rx_full;
  wire        model_uart_txd_pin;
  wire        model_upload_done; 
  wire        model_rx_idle;

  wire [7:0]  dut_output_port;
  reg         dut_console_en;
  reg         dut_upload_en;
  wire        dut_uart_rxd_pin;
  wire        dut_uart_cts = ~`dut_uart_rx_full;
  wire        dut_uart_txd_pin;
  wire        dut_upload_done; 
  wire        dut_rx_idle;

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
      
      for (dump_idx = (2**`TURBO9_TB_MEM_ADDR_WIDTH)-4096; dump_idx < (2**`TURBO9_TB_MEM_ADDR_WIDTH); dump_idx = dump_idx + 1) begin
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
    reset           = 1'b1;
    tb_done         = 1'b0;
    
    pass_test_cnt   = 0;
    fail_test_cnt   = 0;
    
    model_console_en = 1'b0;
    model_upload_en  = 1'b0;
    
    dut_console_en   = 1'b0;
    dut_upload_en    = 1'b0;
    
    
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
    if ($test$plusargs("tc_dv_run_hex")) begin // Run HEX Code
      tc_dv_run_hex;
    end
    //
    if ($test$plusargs("tc_dv_run_s19")) begin // Run S19 Code
      tc_dv_run_s19;
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

    tb_done = 1'b1;

    @(posedge sysclk);

    $finish();

  end

  /////////////////////////////////////////////////////////////////////////////
  // Reset Synchronizer
  /////////////////////////////////////////////////////////////////////////////
 
  reg tb_rst_meta;
  reg tb_rst_sync;

  always @(posedge reset or posedge sysclk)
  begin
    if (reset) begin
      tb_rst_meta <= 1'b1;
      tb_rst_sync <= 1'b1;
    end else begin
      tb_rst_meta <= 1'b0;
      tb_rst_sync <= tb_rst_meta;
    end
  end

  /////////////////////////////////////////////////////////////////////////////
  // DUT
  /////////////////////////////////////////////////////////////////////////////

`ifdef TURBO9_TB_DUT_TURBO9_GTR
  soc_top_gtr
  #(
    .TURBO9_SOC_MEM_ADDR_WIDTH  (`TURBO9_TB_MEM_ADDR_WIDTH),       // SoC Memory Address Width: 16=64KB
    .TURBO9_SOC_WB_PIPELINE_REG (`TURBO9_TB_SOC_WB_PIPELINE_REG),  // SoC WB Pipeline Registers: True=1, False=0
    .TURBO9_CPU_WB_PIPELINE_REG (`TURBO9_TB_CPU_WB_PIPELINE_REG),  // CPU WB Pipeline Registers: True=1, False=0
    .TURBO9_CPU_QUEUE_SIZE      (`TURBO9_TB_CPU_QUEUE_SIZE)        // CPU Fetch Queue Size: 6=Default, 4=Min, 7=Max
  )
  I_soc_top_gtr
`elsif TURBO9_TB_DUT_TURBO9_GTS
  soc_top_gts
  #(
    .TURBO9_SOC_MEM_ADDR_WIDTH  (`TURBO9_TB_MEM_ADDR_WIDTH),       // SoC Memory Address Width: 16=64KB
    .TURBO9_SOC_WB_PIPELINE_REG (`TURBO9_TB_SOC_WB_PIPELINE_REG),  // SoC WB Pipeline Registers: True=1, False=0
    .TURBO9_CPU_WB_PIPELINE_REG (`TURBO9_TB_CPU_WB_PIPELINE_REG),  // CPU WB Pipeline Registers: True=1, False=0
    .TURBO9_CPU_QUEUE_SIZE      (`TURBO9_TB_CPU_QUEUE_SIZE)        // CPU Fetch Queue Size: 6=Default, 4=Min, 7=Max
  )
  I_soc_top_gts
`elsif TURBO9_TB_DUT_TURBO9_R
  soc_top_r
  #(
    .TURBO9_SOC_MEM_ADDR_WIDTH  (`TURBO9_TB_MEM_ADDR_WIDTH),       // SoC Memory Address Width: 16=64KB
    .TURBO9_SOC_WB_PIPELINE_REG (`TURBO9_TB_SOC_WB_PIPELINE_REG),  // SoC WB Pipeline Registers: True=1, False=0
    .TURBO9_CPU_WB_PIPELINE_REG (`TURBO9_TB_CPU_WB_PIPELINE_REG),  // CPU WB Pipeline Registers: True=1, False=0
    .TURBO9_CPU_QUEUE_SIZE      (`TURBO9_TB_CPU_QUEUE_SIZE)        // CPU Fetch Queue Size: 6=Default, 4=Min, 7=Max
  )
  I_soc_top_r
`elsif TURBO9_TB_DUT_TURBO9
  soc_top
  #(
    .TURBO9_SOC_MEM_ADDR_WIDTH  (`TURBO9_TB_MEM_ADDR_WIDTH),       // SoC Memory Address Width: 16=64KB
    .TURBO9_SOC_WB_PIPELINE_REG (`TURBO9_TB_SOC_WB_PIPELINE_REG),  // SoC WB Pipeline Registers: True=1, False=0
    .TURBO9_CPU_WB_PIPELINE_REG (`TURBO9_TB_CPU_WB_PIPELINE_REG),  // CPU WB Pipeline Registers: True=1, False=0
    .TURBO9_CPU_QUEUE_SIZE      (`TURBO9_TB_CPU_QUEUE_SIZE)        // CPU Fetch Queue Size: 6=Default, 4=Min, 7=Max
  )
  I_soc_top
`else
  soc_top_s
  #(
    .TURBO9_SOC_MEM_ADDR_WIDTH  (`TURBO9_TB_MEM_ADDR_WIDTH),       // SoC Memory Address Width: 16=64KB
    .TURBO9_SOC_WB_PIPELINE_REG (`TURBO9_TB_SOC_WB_PIPELINE_REG),  // SoC WB Pipeline Registers: True=1, False=0
    .TURBO9_CPU_WB_PIPELINE_REG (`TURBO9_TB_CPU_WB_PIPELINE_REG),  // CPU WB Pipeline Registers: True=1, False=0
    .TURBO9_CPU_QUEUE_SIZE      (`TURBO9_TB_CPU_QUEUE_SIZE)        // CPU Fetch Queue Size: 6=Default, 4=Min, 7=Max
  )
  I_soc_top_s
`endif
  (
    // Inputs: Clock & Reset
    .RST_I         (tb_rst_sync), // Reset. Active high and synchronized to CLK_I
    .CLK_I         (sysclk), // Clock
    //
    // Inputs 
    .RXD_PIN_I     (dut_uart_txd_pin),
    .GPI_PORT_I    (8'h00),
  
    // Outputs
    .TXD_PIN_O     (dut_uart_rxd_pin),
    .GPO_PORT_O    (dut_output_port)
  );

  tb_dv_uart_agent I_tb_dv_uart_agent_dut
  (
    // Filenames
    .CONSOLE_FILENAME_I ("dut_console.txt" ),
    .UPLOAD_FILENAME_I  (s19_file          ),
  
    // Inputs: Clock & Reset
    .RST_I              (`dut_uart_rst     ),   // Active high
    .CLK_I              (`dut_uart_clk     ),   // UART clock
  
    // TB Control Inputs
    .CONSOLE_EN_I       (dut_console_en    ),
    .UPLOAD_EN_I        (dut_upload_en     ),
    .TB_DONE_I          (tb_done           ),
  
    .RXD_PIN_I          (dut_uart_rxd_pin  ), // from soc_top*.TXD_PIN_O
    .CTS_PIN_I          (dut_uart_cts      ), // active-high CTS: 0 = clear to send

    .TXD_PIN_O          (dut_uart_txd_pin  ),  // to   soc_top*.RXD_PIN_I
    .UPLOAD_DONE_O      (dut_upload_done   ),
    .RX_IDLE_O          (dut_rx_idle       )
  );


  /////////////////////////////////////////////////////////////////////////////
  // 6809 Behavioral Model
  /////////////////////////////////////////////////////////////////////////////
  tb_dv_soc_top_model
  #(
    .TURBO9_SOC_MEM_ADDR_WIDTH  (`TURBO9_TB_MEM_ADDR_WIDTH),      // SoC Model Memory Address Width: 16=64KB
    .TURBO9_SOC_WB_PIPELINE_REG (`TURBO9_TB_SOC_WB_PIPELINE_REG)  // SoC Model WB Pipeline Registers: True=1, False=0
  )
  I_tb_dv_soc_top_model
  (
    // Inputs: Clock & Reset
    .RST_I         (tb_rst_sync), // Reset. Active high and synchronized to CLK_I
    .CLK_I         (sysclk), // Clock
    //
    // Inputs 
    .RXD_PIN_I     (model_uart_txd_pin),
    .GPI_PORT_I    (8'h00),
  
    // Outputs
    .TXD_PIN_O     (model_uart_rxd_pin),
    .GPO_PORT_O    (model_output_port)
  );

  tb_dv_uart_agent I_tb_dv_uart_agent_model
  (
    // Filenames
    .CONSOLE_FILENAME_I ("model_console.txt" ),
    .UPLOAD_FILENAME_I  (s19_file            ),
  
    // Inputs: Clock & Reset
    .RST_I              (`model_uart_rst     ),   // Active high
    .CLK_I              (`model_uart_clk     ),   // UART clock
                                            
    // TB Control Inputs                    
    .CONSOLE_EN_I       (model_console_en    ),
    .UPLOAD_EN_I        (model_upload_en     ),
    .TB_DONE_I          (tb_done             ),
                                            
    .RXD_PIN_I          (model_uart_rxd_pin  ), // from soc_top*.TXD_PIN_O
    .CTS_PIN_I          (model_uart_cts      ), // active-high CTS: 0 = clear to send
                                            
    .TXD_PIN_O          (model_uart_txd_pin  ),  // to   soc_top*.RXD_PIN_I
    .UPLOAD_DONE_O      (model_upload_done   ),
    .RX_IDLE_O          (model_rx_idle       )
  );

  
  /////////////////////////////////////////////////////////////////////////////
  // Testbench Memory
  /////////////////////////////////////////////////////////////////////////////
  tb_dv_memory
  #(
    `TURBO9_TB_MEM_ADDR_WIDTH // TB Memory Address Width: 16=64KB
  )
  I_tb_dv_memory ();

  always @(posedge sysclk)
  begin
    if (`dut_clk_cnt_ctrl[1:0] == 2'b10) begin
      if (`dut_cycle_cnt[15:0] == 0) $display("[TB: tb_dv_top      ] DUT clock cycle count: %d", `dut_cycle_cnt);
    end
    if (`model_clk_cnt_ctrl[1:0] == 2'b10) begin
      if (`model_cycle_cnt[15:0] == 0) $display("[TB: tb_dv_top      ] Model E clock cycle count: %d", `model_cycle_cnt);
    end
  end



endmodule

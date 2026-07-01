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
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE
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
// Description: Turbo9 DV testbench configuration defaults. This header
// centralizes parameter defaults, DUT selection, and hierarchy aliases used by
// the tb_dv_top simulation hierarchy.
//
//////////////////////////////////////////////////////////////////////////////
// History:
// 06.29.2026 - Kevin Phillipson
//   File header added
//
//////////////////////////////////////////////////////////////////////////////
// [TURBO9_HEADER_END]

`ifndef TURBO9_TB_CONFIG_VH
`define TURBO9_TB_CONFIG_VH

///////////////////// DUT Variant Selection
//
// Select the SoC/CPU variant instantiated by tb_dv_top. The default remains
// Turbo9S to preserve existing testbench behavior. Override from the compile
// command with one of these TURBO9_TB_DUT_* defines.

`ifndef TURBO9_TB_DUT_TURBO9
`ifndef TURBO9_TB_DUT_TURBO9_S
`ifndef TURBO9_TB_DUT_TURBO9_R
`ifndef TURBO9_TB_DUT_TURBO9_GTS
`ifndef TURBO9_TB_DUT_TURBO9_GTR
  `define TURBO9_TB_DUT_TURBO9_S
`endif
`endif
`endif
`endif
`endif

///////////////////// Testbench Parameter Defaults
//
// These values are fed into the DV top and SoC model as normal Verilog
// parameters. Keep them guarded so a compile command can override specific
// settings without editing the testbench source.

`ifndef TURBO9_TB_MEM_ADDR_WIDTH
  `define TURBO9_TB_MEM_ADDR_WIDTH 16
`endif

`ifndef TURBO9_TB_SOC_WB_PIPELINE_REG
  `define TURBO9_TB_SOC_WB_PIPELINE_REG 0
`endif

`ifndef TURBO9_TB_CPU_WB_PIPELINE_REG
  `define TURBO9_TB_CPU_WB_PIPELINE_REG 0
`endif

`ifndef TURBO9_TB_CPU_QUEUE_SIZE
  `define TURBO9_TB_CPU_QUEUE_SIZE 6
`endif

///////////////////// Model Simulation Options
//
// These TB/model-only behavior switches are opt-in enable macros. Leave them
// undefined by default so command-line defines only enable extra behavior.

// `define TURBO9_TB_MODEL_FAST
// `define TURBO9_TB_MODEL_VERBOSE
// `define TURBO9_TB_MODEL_BREAK_DEC

///////////////////// Testbench Hierarchy Aliases
//
// These aliases keep the included DV library code independent from the DUT
// variant selected below. They are intentionally TB-only hierarchical paths.

`define model_mem           I_tb_dv_soc_top_model.I_syncram_8bit.ram
`define model_cycle_cnt     I_tb_dv_soc_top_model.clk_cnt_rd_dat
`define model_clk_cnt_ctrl  I_tb_dv_soc_top_model.clk_cnt_ctrl_dat
`define model_error         I_tb_dv_soc_top_model.I_tb_dv_6809_model.model_error
`define model_uart_clk      I_tb_dv_soc_top_model.I_t6551.CLK_I
`define model_uart_rst      I_tb_dv_soc_top_model.I_t6551.RST_I
`define model_uart_rx_full  I_tb_dv_soc_top_model.I_t6551.rx_data_reg_full

`ifdef TURBO9_TB_DUT_TURBO9_GTR
  `define TURBO9_16BIT
  `define dut_mem_even      I_soc_top_gtr.I_even_syncram_8bit.ram
  `define dut_mem_odd       I_soc_top_gtr.I_odd_syncram_8bit.ram
  `define dut_cycle_cnt     I_soc_top_gtr.clk_cnt_rd_dat
  `define dut_clk_cnt_ctrl  I_soc_top_gtr.clk_cnt_ctrl_dat
  `define dut_uart_clk      I_soc_top_gtr.I_t6551.CLK_I
  `define dut_uart_rst      I_soc_top_gtr.I_t6551.RST_I
  `define dut_uart_rx_full  I_soc_top_gtr.I_t6551.rx_data_reg_full
`elsif TURBO9_TB_DUT_TURBO9_GTS
  `define TURBO9_16BIT
  `define dut_mem_even      I_soc_top_gts.I_even_syncram_8bit.ram
  `define dut_mem_odd       I_soc_top_gts.I_odd_syncram_8bit.ram
  `define dut_cycle_cnt     I_soc_top_gts.clk_cnt_rd_dat
  `define dut_clk_cnt_ctrl  I_soc_top_gts.clk_cnt_ctrl_dat
  `define dut_uart_clk      I_soc_top_gts.I_t6551.CLK_I
  `define dut_uart_rst      I_soc_top_gts.I_t6551.RST_I
  `define dut_uart_rx_full  I_soc_top_gts.I_t6551.rx_data_reg_full
`elsif TURBO9_TB_DUT_TURBO9_R
  `define TURBO9_16BIT
  `define dut_mem_even      I_soc_top_r.I_even_syncram_8bit.ram
  `define dut_mem_odd       I_soc_top_r.I_odd_syncram_8bit.ram
  `define dut_cycle_cnt     I_soc_top_r.clk_cnt_rd_dat
  `define dut_clk_cnt_ctrl  I_soc_top_r.clk_cnt_ctrl_dat
  `define dut_uart_clk      I_soc_top_r.I_t6551.CLK_I
  `define dut_uart_rst      I_soc_top_r.I_t6551.RST_I
  `define dut_uart_rx_full  I_soc_top_r.I_t6551.rx_data_reg_full
`elsif TURBO9_TB_DUT_TURBO9
  `define dut_mem           I_soc_top.I_syncram_8bit.ram
  `define dut_cycle_cnt     I_soc_top.clk_cnt_rd_dat
  `define dut_clk_cnt_ctrl  I_soc_top.clk_cnt_ctrl_dat
  `define dut_uart_clk      I_soc_top.I_t6551.CLK_I
  `define dut_uart_rst      I_soc_top.I_t6551.RST_I
  `define dut_uart_rx_full  I_soc_top.I_t6551.rx_data_reg_full
`else // TURBO9_TB_DUT_TURBO9_S (default)
  `define TURBO9_16BIT
  `define dut_mem_even      I_soc_top_s.I_even_syncram_8bit.ram
  `define dut_mem_odd       I_soc_top_s.I_odd_syncram_8bit.ram
  `define dut_cycle_cnt     I_soc_top_s.clk_cnt_rd_dat
  `define dut_clk_cnt_ctrl  I_soc_top_s.clk_cnt_ctrl_dat
  `define dut_uart_clk      I_soc_top_s.I_t6551.CLK_I
  `define dut_uart_rst      I_soc_top_s.I_t6551.RST_I
  `define dut_uart_rx_full  I_soc_top_s.I_t6551.rx_data_reg_full
`endif

`define tb_mem              I_tb_dv_memory.memory

`endif

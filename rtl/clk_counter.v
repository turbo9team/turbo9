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
// Description: Simple timer for counting clock cycles
//
//////////////////////////////////////////////////////////////////////////////
// History:
// 07.14.2023 - Kevin Phillipson
//   File header added
//
//////////////////////////////////////////////////////////////////////////////
// [TURBO9_HEADER_END]

/////////////////////////////////////////////////////////////////////////////
//                                MODULE
/////////////////////////////////////////////////////////////////////////////
`include "turbo9_soc_config.vh"

module clk_counter
(
  // Inputs: Clock & Reset
  input          RST_I,
  input          CLK_I,

  // Inputs         
  input [ 7:0]   DATA_I,
  input          CLK_CNT_CTRL_WR_EN_I,

  // Outputs         
  output [ 7:0]  CLK_CNT_CTRL_DATA_O,
  output [31:0]  CLK_CNT_DATA_O
);


/////////////////////////////////////////////////////////////////////////////
//                             INTERNAL SIGNALS
/////////////////////////////////////////////////////////////////////////////

reg   [1:0]   clk_cnt_ctrl_reg;
localparam    clk_cnt_ctrl_rst = 2'd0;

reg   [31:0]  clk_cnt_reg;
localparam    clk_cnt_rst = 32'd0;

localparam  CLEAR = 2'b00;
localparam  RUN   = 2'b01;
localparam  STOP  = 2'b10;

/////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////
//                           Clock Counter Control
/////////////////////////////////////////////////////////////////////////////
`ifdef TURBO9_SOC_SYNC_RESET
always @(posedge CLK_I) begin
`else
always @(posedge CLK_I, posedge RST_I) begin
`endif
  if (RST_I) begin
    clk_cnt_ctrl_reg   <= clk_cnt_ctrl_rst;
  end else begin
    if (CLK_CNT_CTRL_WR_EN_I) begin
      clk_cnt_ctrl_reg   <= DATA_I[1:0];
    end
  end
end
//
/////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////
//                               Clock Counter
/////////////////////////////////////////////////////////////////////////////
`ifdef TURBO9_SOC_SYNC_RESET
always @(posedge CLK_I) begin
`else
always @(posedge CLK_I, posedge RST_I) begin
`endif
  if (RST_I) begin
    clk_cnt_reg   <= clk_cnt_rst;
  end else begin
    if (clk_cnt_ctrl_reg == CLEAR) begin
      clk_cnt_reg <= clk_cnt_rst;
    end else if (clk_cnt_ctrl_reg == RUN) begin
      clk_cnt_reg <= clk_cnt_reg + 32'd1;
    end
  end
end
//
/////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////
//                             ASSIGN OUTPUTS
/////////////////////////////////////////////////////////////////////////////

assign CLK_CNT_CTRL_DATA_O = {6'd0, clk_cnt_ctrl_reg};
assign CLK_CNT_DATA_O      = clk_cnt_reg;

/////////////////////////////////////////////////////////////////////////////

endmodule

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
// Description: 8 by 8-bit shifting FIFO
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
module turbo9_fifo_8x8
#(
  parameter ENABLE_16BIT = 1
)
(
  // Inputs: Clock & Reset
  input  RST_I,
  input  CLK_I,

  input   [3:0] FIFO_RD_LEN_I,
  input         FIFO_FLUSH_I,
  input         FIFO_WR_EN_I,
  input         FIFO_WR_WIDTH_I,
  input  [15:0] FIFO_DAT_I,
  
  output        PREBYTE_EN_O,

  output  [3:0] FIFO_LEVEL_O,
  output        FIFO_FULL_O,
  //
  output  [7:0] FIFO_DATA_7_O,
  output  [7:0] FIFO_DATA_6_O,
  output  [7:0] FIFO_DATA_5_O,
  output  [7:0] FIFO_DATA_4_O,
  output  [7:0] FIFO_DATA_3_O,
  output  [7:0] FIFO_DATA_2_O,
  output  [7:0] FIFO_DATA_1_O,
  output  [7:0] FIFO_DATA_0_O
  
);

/////////////////////////////////////////////////////////////////////////////
//                             INTERNAL SIGNALS
/////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////// WIDTH_I defines
//
// This must match the MSB of the *_REG_SEL control vectors
localparam  WIDTH_16 =  1'b0;
localparam  WIDTH_8  =  1'b1;

wire   [3:0] fifo_wr_ptr;

wire   [7:0] fifo_wr_en;

wire   [3:0] fifo_level_term;
wire   [3:0] fifo_level_inc;
reg    [3:0] fifo_level_reg;
wire   [3:0] fifo_level_nxt;
localparam   fifo_level_rst = 4'h0;

reg    [7:0] fifo_data_reg [7:0];
wire   [7:0] fifo_data_nxt [7:0];
localparam   fifo_data_rst = 8'h00;

wire   [7:0] fifo_data_shift4 [7:0];
wire   [7:0] fifo_data_shift2 [7:0];
wire   [7:0] fifo_data_shift1 [7:0];

reg         prebyte_en_reg;
wire        prebyte_en_nxt;
localparam  prebyte_en_rst = 1'b0;
/////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////
//                               FIFO LOGIC
/////////////////////////////////////////////////////////////////////////////
//

generate
  if (ENABLE_16BIT) begin
    assign fifo_level_term = (FIFO_WR_WIDTH_I == WIDTH_16) ? 4'h2 : 4'h1; 
  end else begin
    assign fifo_level_term = 4'h1;
  end
endgenerate

assign fifo_level_inc = (FIFO_WR_EN_I) ? fifo_level_term : 4'h0;

assign fifo_wr_ptr    = FIFO_FLUSH_I ? 4'h0 : fifo_level_reg - FIFO_RD_LEN_I  ;
//assign fifo_level_nxt = FIFO_FLUSH_I ? 4'h0 : fifo_wr_ptr    + fifo_level_inc ;
assign fifo_level_nxt = fifo_wr_ptr    + fifo_level_inc ;

// Write Enables
assign fifo_wr_en[7] = (FIFO_WR_EN_I & (fifo_wr_ptr[2:0] == 3'h7));
assign fifo_wr_en[6] = (FIFO_WR_EN_I & (fifo_wr_ptr[2:0] == 3'h6));
assign fifo_wr_en[5] = (FIFO_WR_EN_I & (fifo_wr_ptr[2:0] == 3'h5));
assign fifo_wr_en[4] = (FIFO_WR_EN_I & (fifo_wr_ptr[2:0] == 3'h4));
assign fifo_wr_en[3] = (FIFO_WR_EN_I & (fifo_wr_ptr[2:0] == 3'h3));
assign fifo_wr_en[2] = (FIFO_WR_EN_I & (fifo_wr_ptr[2:0] == 3'h2));
assign fifo_wr_en[1] = (FIFO_WR_EN_I & (fifo_wr_ptr[2:0] == 3'h1));
assign fifo_wr_en[0] = (FIFO_WR_EN_I & (fifo_wr_ptr[2:0] == 3'h0));

/* FIXME iverilog does not support
assign fifo_data_shift4 = FIFO_RD_LEN_I[2] ? {fifo_data_reg[7:4]    , fifo_data_reg[7:4]   } : fifo_data_reg;
assign fifo_data_shift2 = FIFO_RD_LEN_I[1] ? {fifo_data_shift4[7:6] , fifo_data_shift4[7:2]} : fifo_data_shift4;
assign fifo_data_shift1 = FIFO_RD_LEN_I[0] ? {fifo_data_shift2[7]   , fifo_data_shift2[7:1]} : fifo_data_shift2;
assign fifo_data_shift  = fifo_data_shift1;
*/

// Data Barrell Shifter
assign fifo_data_shift4[7] =                                          fifo_data_reg[7];
assign fifo_data_shift4[6] =                                          fifo_data_reg[6];
assign fifo_data_shift4[5] =                                          fifo_data_reg[5];
assign fifo_data_shift4[4] =                                          fifo_data_reg[4];
assign fifo_data_shift4[3] = FIFO_RD_LEN_I[2] ? fifo_data_reg[7]    : fifo_data_reg[3];
assign fifo_data_shift4[2] = FIFO_RD_LEN_I[2] ? fifo_data_reg[6]    : fifo_data_reg[2];
assign fifo_data_shift4[1] = FIFO_RD_LEN_I[2] ? fifo_data_reg[5]    : fifo_data_reg[1];
assign fifo_data_shift4[0] = FIFO_RD_LEN_I[2] ? fifo_data_reg[4]    : fifo_data_reg[0];
//
assign fifo_data_shift2[7] =                                          fifo_data_shift4[7];
assign fifo_data_shift2[6] =                                          fifo_data_shift4[6];
assign fifo_data_shift2[5] = FIFO_RD_LEN_I[1] ? fifo_data_shift4[7] : fifo_data_shift4[5];
assign fifo_data_shift2[4] = FIFO_RD_LEN_I[1] ? fifo_data_shift4[6] : fifo_data_shift4[4];
assign fifo_data_shift2[3] = FIFO_RD_LEN_I[1] ? fifo_data_shift4[5] : fifo_data_shift4[3];
assign fifo_data_shift2[2] = FIFO_RD_LEN_I[1] ? fifo_data_shift4[4] : fifo_data_shift4[2];
assign fifo_data_shift2[1] = FIFO_RD_LEN_I[1] ? fifo_data_shift4[3] : fifo_data_shift4[1];
assign fifo_data_shift2[0] = FIFO_RD_LEN_I[1] ? fifo_data_shift4[2] : fifo_data_shift4[0];
//
assign fifo_data_shift1[7] =                                          fifo_data_shift2[7];
assign fifo_data_shift1[6] = FIFO_RD_LEN_I[0] ? fifo_data_shift2[7] : fifo_data_shift2[6];
assign fifo_data_shift1[5] = FIFO_RD_LEN_I[0] ? fifo_data_shift2[6] : fifo_data_shift2[5];
assign fifo_data_shift1[4] = FIFO_RD_LEN_I[0] ? fifo_data_shift2[5] : fifo_data_shift2[4];
assign fifo_data_shift1[3] = FIFO_RD_LEN_I[0] ? fifo_data_shift2[4] : fifo_data_shift2[3];
assign fifo_data_shift1[2] = FIFO_RD_LEN_I[0] ? fifo_data_shift2[3] : fifo_data_shift2[2];
assign fifo_data_shift1[1] = FIFO_RD_LEN_I[0] ? fifo_data_shift2[2] : fifo_data_shift2[1];
assign fifo_data_shift1[0] = FIFO_RD_LEN_I[0] ? fifo_data_shift2[1] : fifo_data_shift2[0];

generate
  if (ENABLE_16BIT) begin
    wire [7:0] fifo_data_lo_nxt [7:0];

    // Write Enable Logic (Low Byte)
    assign fifo_data_lo_nxt[7] = (fifo_wr_en[7]) ? FIFO_DAT_I[15:8] : fifo_data_shift1[7];
    assign fifo_data_lo_nxt[6] = (fifo_wr_en[6]) ? FIFO_DAT_I[15:8] : fifo_data_shift1[6];
    assign fifo_data_lo_nxt[5] = (fifo_wr_en[5]) ? FIFO_DAT_I[15:8] : fifo_data_shift1[5];
    assign fifo_data_lo_nxt[4] = (fifo_wr_en[4]) ? FIFO_DAT_I[15:8] : fifo_data_shift1[4];
    assign fifo_data_lo_nxt[3] = (fifo_wr_en[3]) ? FIFO_DAT_I[15:8] : fifo_data_shift1[3];
    assign fifo_data_lo_nxt[2] = (fifo_wr_en[2]) ? FIFO_DAT_I[15:8] : fifo_data_shift1[2];
    assign fifo_data_lo_nxt[1] = (fifo_wr_en[1]) ? FIFO_DAT_I[15:8] : fifo_data_shift1[1];
    assign fifo_data_lo_nxt[0] = (fifo_wr_en[0]) ? FIFO_DAT_I[15:8] : fifo_data_shift1[0];

    // Write Enable Logic (High Byte)
    assign fifo_data_nxt[7]    = (fifo_wr_en[6]) ? FIFO_DAT_I[ 7:0] : fifo_data_lo_nxt[7];
    assign fifo_data_nxt[6]    = (fifo_wr_en[5]) ? FIFO_DAT_I[ 7:0] : fifo_data_lo_nxt[6];
    assign fifo_data_nxt[5]    = (fifo_wr_en[4]) ? FIFO_DAT_I[ 7:0] : fifo_data_lo_nxt[5];
    assign fifo_data_nxt[4]    = (fifo_wr_en[3]) ? FIFO_DAT_I[ 7:0] : fifo_data_lo_nxt[4];
    assign fifo_data_nxt[3]    = (fifo_wr_en[2]) ? FIFO_DAT_I[ 7:0] : fifo_data_lo_nxt[3];
    assign fifo_data_nxt[2]    = (fifo_wr_en[1]) ? FIFO_DAT_I[ 7:0] : fifo_data_lo_nxt[2];
    assign fifo_data_nxt[1]    = (fifo_wr_en[0]) ? FIFO_DAT_I[ 7:0] : fifo_data_lo_nxt[1];
    assign fifo_data_nxt[0]    =                                      fifo_data_lo_nxt[0];

  end else begin

    // Write Enable Logic (8bit)
    assign fifo_data_nxt[7] = (fifo_wr_en[7]) ? FIFO_DAT_I[ 7:0] : fifo_data_shift1[7];
    assign fifo_data_nxt[6] = (fifo_wr_en[6]) ? FIFO_DAT_I[ 7:0] : fifo_data_shift1[6];
    assign fifo_data_nxt[5] = (fifo_wr_en[5]) ? FIFO_DAT_I[ 7:0] : fifo_data_shift1[5];
    assign fifo_data_nxt[4] = (fifo_wr_en[4]) ? FIFO_DAT_I[ 7:0] : fifo_data_shift1[4];
    assign fifo_data_nxt[3] = (fifo_wr_en[3]) ? FIFO_DAT_I[ 7:0] : fifo_data_shift1[3];
    assign fifo_data_nxt[2] = (fifo_wr_en[2]) ? FIFO_DAT_I[ 7:0] : fifo_data_shift1[2];
    assign fifo_data_nxt[1] = (fifo_wr_en[1]) ? FIFO_DAT_I[ 7:0] : fifo_data_shift1[1];
    assign fifo_data_nxt[0] = (fifo_wr_en[0]) ? FIFO_DAT_I[ 7:0] : fifo_data_shift1[0];

  end
endgenerate

assign prebyte_en_nxt = (fifo_data_nxt[0][7:1] == 7'b0001_000);

// Registers
always @(posedge CLK_I, posedge RST_I) begin
  if (RST_I) begin
    fifo_level_reg    <= fifo_level_rst;
    //fifo_data_reg   <= '{default:fifo_data_rst}; FIXME iverilog does not support
    fifo_data_reg[7]  <= fifo_data_rst;
    fifo_data_reg[6]  <= fifo_data_rst;
    fifo_data_reg[5]  <= fifo_data_rst;
    fifo_data_reg[4]  <= fifo_data_rst;
    fifo_data_reg[3]  <= fifo_data_rst;
    fifo_data_reg[2]  <= fifo_data_rst;
    fifo_data_reg[1]  <= fifo_data_rst;
    fifo_data_reg[0]  <= fifo_data_rst;
    prebyte_en_reg    <= prebyte_en_rst;
  end else begin
    fifo_level_reg  <= fifo_level_nxt;
    //fifo_data_reg   <= fifo_data_nxt; FIXME iverilog does not support
    fifo_data_reg[7]  <= fifo_data_nxt[7];
    fifo_data_reg[6]  <= fifo_data_nxt[6];
    fifo_data_reg[5]  <= fifo_data_nxt[5];
    fifo_data_reg[4]  <= fifo_data_nxt[4];
    fifo_data_reg[3]  <= fifo_data_nxt[3];
    fifo_data_reg[2]  <= fifo_data_nxt[2];
    fifo_data_reg[1]  <= fifo_data_nxt[1];
    fifo_data_reg[0]  <= fifo_data_nxt[0];
    prebyte_en_reg    <= prebyte_en_nxt;
  end
end
//
/////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////
//                             ASSIGN OUTPUTS
/////////////////////////////////////////////////////////////////////////////
//
assign FIFO_LEVEL_O  = fifo_level_reg;
assign FIFO_FULL_O   = fifo_level_reg[3];
//
assign FIFO_DATA_7_O = fifo_data_reg[7];
assign FIFO_DATA_6_O = fifo_data_reg[6];
assign FIFO_DATA_5_O = fifo_data_reg[5];
assign FIFO_DATA_4_O = fifo_data_reg[4];
assign FIFO_DATA_3_O = fifo_data_reg[3];
assign FIFO_DATA_2_O = fifo_data_reg[2];
assign FIFO_DATA_1_O = fifo_data_reg[1];
assign FIFO_DATA_0_O = fifo_data_reg[0];
assign PREBYTE_EN_O  = prebyte_en_reg;
//
/////////////////////////////////////////////////////////////////////////////

endmodule


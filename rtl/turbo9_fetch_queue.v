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
// Description: Fetch Queue (8-bit by 4to7 shifting FIFO)
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
module turbo9_fetch_queue
#(
  parameter ENABLE_16BIT = 1,
  parameter SIZE = 4 // Min: 4, Max: 7
)
(
  // Inputs: Clock & Reset
  input  RST_I,
  input  CLK_I,

  input   [2:0] QUEUE_RD_LEN_I,
  input         QUEUE_FLUSH_I,
  input         QUEUE_WR_EN_I,
  
  input   [((ENABLE_16BIT*8)+7):0] QUEUE_DAT_I,
  
  output  [2:0] QUEUE_LEVEL_O,
  output  [2:0] QUEUE_REJECT_LEN_O,
  //
  output  [7:0] QUEUE_DATA_3_O,
  output  [7:0] QUEUE_DATA_2_O,
  output  [7:0] QUEUE_DATA_1_O,
  output  [7:0] QUEUE_DATA_0_O,
  output        PREBYTE_EN_O
  //
);

/////////////////////////////////////////////////////////////////////////////
//                             INTERNAL SIGNALS
/////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////// WIDTH_I defines
//

localparam  CLOG2_SIZE = 3; // Solve: 2^CLOG2_SIZE >= SIZE (keep it Verilog2001!)

// This must match the MSB of the *_REG_SEL control vectors
localparam  WIDTH_16 =  1'b0;
localparam  WIDTH_8  =  1'b1;

wire   [(SIZE-1):0] queue_wr_en;

wire   [(CLOG2_SIZE-1):0] queue_wr_ptr;

wire   [(CLOG2_SIZE-1):0] queue_reject_len;

wire   [(CLOG2_SIZE-1):0] queue_level_term;
wire   [(CLOG2_SIZE-1):0] queue_level_inc;
reg    [(CLOG2_SIZE-1):0] queue_level_reg;
wire   [(CLOG2_SIZE-1):0] queue_level_nxt;
localparam   queue_level_rst = 'd0;

reg          prebyte_en_reg;
localparam   prebyte_en_rst = 1'b0;

reg    [7:0] queue_data_reg [(SIZE-1):0];
wire   [7:0] queue_data_nxt [(SIZE-1):0];
localparam   queue_data_rst = 'd0;

wire   [7:0] queue_data_shift4 [(SIZE-1):0];
wire   [7:0] queue_data_shift2 [(SIZE-1):0];
wire   [7:0] queue_data_shift1 [(SIZE-1):0];
/////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////
//                               QUEUE LOGIC
/////////////////////////////////////////////////////////////////////////////



/////////////////////////////////// Pointer & Level Calculation
//
generate
  if (ENABLE_16BIT) begin
    assign queue_level_term = 'd2;
  end else begin
    assign queue_level_term = 'd1;
  end
endgenerate
//
assign queue_level_inc  = (QUEUE_WR_EN_I) ? queue_level_term : 'd0;
assign queue_wr_ptr     = QUEUE_FLUSH_I ? 'd0 : queue_level_reg - QUEUE_RD_LEN_I;
assign queue_level_nxt  = queue_wr_ptr + queue_level_inc - queue_reject_len;



/////////////////////////////////// Reject Calculation
//
generate
  if (ENABLE_16BIT) begin
    assign queue_reject_len = (QUEUE_WR_EN_I & (queue_wr_ptr==(SIZE  ))) ? 'd2 :
                              (QUEUE_WR_EN_I & (queue_wr_ptr==(SIZE-1))) ? 'd1 :
                                                                           'd0 ;
  end else begin
    assign queue_reject_len = (QUEUE_WR_EN_I & (queue_wr_ptr==(SIZE  ))) ? 'd1 :
                                                                           'd0 ;
  end
endgenerate



/////////////////////////////////// Write Enables
//
genvar i;
generate
  // SIZE = 7 example:
  // assign queue_wr_en[0] = (QUEUE_WR_EN_I & (queue_wr_ptr == 'd0));
  // assign queue_wr_en[1] = (QUEUE_WR_EN_I & (queue_wr_ptr == 'd1));
  // assign queue_wr_en[2] = (QUEUE_WR_EN_I & (queue_wr_ptr == 'd2));
  // assign queue_wr_en[3] = (QUEUE_WR_EN_I & (queue_wr_ptr == 'd3));
  // assign queue_wr_en[4] = (QUEUE_WR_EN_I & (queue_wr_ptr == 'd4));
  // assign queue_wr_en[5] = (QUEUE_WR_EN_I & (queue_wr_ptr == 'd5));
  // assign queue_wr_en[6] = (QUEUE_WR_EN_I & (queue_wr_ptr == 'd6));
  for (i=0; i<SIZE; i=i+1) begin
    assign queue_wr_en[i] = (QUEUE_WR_EN_I & (queue_wr_ptr == i));
  end
endgenerate



/////////////////////////////////// Data Barrell Shifter
//
// Shift by 4
generate
  // SIZE = 7 example:
  // assign queue_data_shift4[0] = QUEUE_RD_LEN_I[2] ? queue_data_reg[4] : queue_data_reg[0];
  // assign queue_data_shift4[1] = QUEUE_RD_LEN_I[2] ? queue_data_reg[5] : queue_data_reg[1];
  // assign queue_data_shift4[2] = QUEUE_RD_LEN_I[2] ? queue_data_reg[6] : queue_data_reg[2];
  // assign queue_data_shift4[3] =                                         queue_data_reg[3];
  // assign queue_data_shift4[4] =                                         queue_data_reg[4];
  // assign queue_data_shift4[5] =                                         queue_data_reg[5];
  // assign queue_data_shift4[6] =                                         queue_data_reg[6];
  if (SIZE > 4) begin
    for (i=0; i<SIZE; i=i+1) begin
      if (i<(SIZE-4)) begin
        assign queue_data_shift4[i] = QUEUE_RD_LEN_I[CLOG2_SIZE-1] ? queue_data_reg[i+4] : queue_data_reg[i];
      end else begin
        assign queue_data_shift4[i] = queue_data_reg[i];
      end
    end
  end else begin
    for (i=0; i<SIZE; i=i+1) begin
      assign queue_data_shift4[i] = queue_data_reg[i];
    end
  end
endgenerate
//
// Shift by 2
generate
  // SIZE = 7 example:
  // assign queue_data_shift2[0] = QUEUE_RD_LEN_I[1] ? queue_data_shift4[2] : queue_data_shift4[0];
  // assign queue_data_shift2[1] = QUEUE_RD_LEN_I[1] ? queue_data_shift4[3] : queue_data_shift4[1];
  // assign queue_data_shift2[2] = QUEUE_RD_LEN_I[1] ? queue_data_shift4[4] : queue_data_shift4[2];
  // assign queue_data_shift2[3] = QUEUE_RD_LEN_I[1] ? queue_data_shift4[5] : queue_data_shift4[3];
  // assign queue_data_shift2[4] = QUEUE_RD_LEN_I[1] ? queue_data_shift4[6] : queue_data_shift4[4];
  // assign queue_data_shift2[5] =                                            queue_data_shift4[5];
  // assign queue_data_shift2[6] =                                            queue_data_shift4[6];
  for (i=0; i<SIZE; i=i+1) begin
    if (i<(SIZE-2)) begin
      assign queue_data_shift2[i] = QUEUE_RD_LEN_I[CLOG2_SIZE-2] ? queue_data_shift4[i+2] : queue_data_shift4[i];
    end else begin
      assign queue_data_shift2[i] = queue_data_shift4[i];
    end
  end
endgenerate
//
// Shift by 1
generate
  // SIZE = 7 example:
  // assign queue_data_shift1[0] = QUEUE_RD_LEN_I[0] ? queue_data_shift2[1] : queue_data_shift2[0];
  // assign queue_data_shift1[1] = QUEUE_RD_LEN_I[0] ? queue_data_shift2[2] : queue_data_shift2[1];
  // assign queue_data_shift1[2] = QUEUE_RD_LEN_I[0] ? queue_data_shift2[3] : queue_data_shift2[2];
  // assign queue_data_shift1[3] = QUEUE_RD_LEN_I[0] ? queue_data_shift2[4] : queue_data_shift2[3];
  // assign queue_data_shift1[4] = QUEUE_RD_LEN_I[0] ? queue_data_shift2[5] : queue_data_shift2[4];
  // assign queue_data_shift1[5] = QUEUE_RD_LEN_I[0] ? queue_data_shift2[6] : queue_data_shift2[5];
  // assign queue_data_shift1[6] =                                            queue_data_shift2[6];
  for (i=0; i<SIZE; i=i+1) begin
    if (i<(SIZE-1)) begin
      assign queue_data_shift1[i] = QUEUE_RD_LEN_I[CLOG2_SIZE-3] ? queue_data_shift2[i+1] : queue_data_shift2[i];
    end else begin
      assign queue_data_shift1[i] = queue_data_shift2[i];
    end
  end
endgenerate



/////////////////////////////////// Write Logic
//
generate
  if (ENABLE_16BIT) begin
    wire [7:0] queue_data_nxt_lo [(SIZE-1):0];
    //
    // Write Enable Logic (Low Byte)
    // assign queue_data_nxt_lo[0] = (queue_wr_en[0]) ? QUEUE_DAT_I[15:8] : queue_data_shift1[0];
    // assign queue_data_nxt_lo[1] = (queue_wr_en[1]) ? QUEUE_DAT_I[15:8] : queue_data_shift1[1];
    // assign queue_data_nxt_lo[2] = (queue_wr_en[2]) ? QUEUE_DAT_I[15:8] : queue_data_shift1[2];
    // assign queue_data_nxt_lo[3] = (queue_wr_en[3]) ? QUEUE_DAT_I[15:8] : queue_data_shift1[3];
    // assign queue_data_nxt_lo[4] = (queue_wr_en[4]) ? QUEUE_DAT_I[15:8] : queue_data_shift1[4];
    // assign queue_data_nxt_lo[5] = (queue_wr_en[5]) ? QUEUE_DAT_I[15:8] : queue_data_shift1[5];
    // assign queue_data_nxt_lo[6] = (queue_wr_en[6]) ? QUEUE_DAT_I[15:8] : queue_data_shift1[6];
    for (i=0; i<SIZE; i=i+1) begin
      assign queue_data_nxt_lo[i] = (queue_wr_en[i]) ? QUEUE_DAT_I[15:8] : queue_data_shift1[i];
    end
    //
    // Write Enable Logic (High Byte)
    // assign queue_data_nxt[0]    =                                        queue_data_nxt_lo[0];
    // assign queue_data_nxt[1]    = (queue_wr_en[0]) ? QUEUE_DAT_I[ 7:0] : queue_data_nxt_lo[1];
    // assign queue_data_nxt[2]    = (queue_wr_en[1]) ? QUEUE_DAT_I[ 7:0] : queue_data_nxt_lo[2];
    // assign queue_data_nxt[3]    = (queue_wr_en[2]) ? QUEUE_DAT_I[ 7:0] : queue_data_nxt_lo[3];
    // assign queue_data_nxt[4]    = (queue_wr_en[3]) ? QUEUE_DAT_I[ 7:0] : queue_data_nxt_lo[4];
    // assign queue_data_nxt[5]    = (queue_wr_en[4]) ? QUEUE_DAT_I[ 7:0] : queue_data_nxt_lo[5];
    // assign queue_data_nxt[6]    = (queue_wr_en[5]) ? QUEUE_DAT_I[ 7:0] : queue_data_nxt_lo[6];
    for (i=0; i<SIZE; i=i+1) begin
      if (i==0) begin
        assign queue_data_nxt[i] = queue_data_nxt_lo[i];
      end else begin
        assign queue_data_nxt[i] = (queue_wr_en[i-1]) ? QUEUE_DAT_I[ 7:0] : queue_data_nxt_lo[i];
      end
    end
  end else begin
    //
    // Write Enable Logic (8bit)
    // assign queue_data_nxt[0] = (queue_wr_en[0]) ? QUEUE_DAT_I[ 7:0] : queue_data_shift1[0];
    // assign queue_data_nxt[1] = (queue_wr_en[1]) ? QUEUE_DAT_I[ 7:0] : queue_data_shift1[1];
    // assign queue_data_nxt[2] = (queue_wr_en[2]) ? QUEUE_DAT_I[ 7:0] : queue_data_shift1[2];
    // assign queue_data_nxt[3] = (queue_wr_en[3]) ? QUEUE_DAT_I[ 7:0] : queue_data_shift1[3];
    // assign queue_data_nxt[4] = (queue_wr_en[4]) ? QUEUE_DAT_I[ 7:0] : queue_data_shift1[4];
    // assign queue_data_nxt[5] = (queue_wr_en[5]) ? QUEUE_DAT_I[ 7:0] : queue_data_shift1[5];
    // assign queue_data_nxt[6] = (queue_wr_en[6]) ? QUEUE_DAT_I[ 7:0] : queue_data_shift1[6];
    for (i=0; i<SIZE; i=i+1) begin
      assign queue_data_nxt[i] = (queue_wr_en[i]) ? QUEUE_DAT_I[ 7:0] : queue_data_shift1[i];
    end
  end
endgenerate



/////////////////////////////////// Queue Data Registers
//
generate
  for (i=0; i<SIZE; i=i+1) begin
    always @(posedge CLK_I, posedge RST_I) begin
      if (RST_I) begin
        queue_data_reg[i]  <= queue_data_rst;
      end else begin
        queue_data_reg[i]  <= queue_data_nxt[i];
      end
    end
  end
endgenerate



/////////////////////////////////// Level and Prebyte Registers
//
always @(posedge CLK_I, posedge RST_I) begin
  if (RST_I) begin
    queue_level_reg <= queue_level_rst;
    prebyte_en_reg  <= prebyte_en_rst;
  end else begin
    queue_level_reg <= queue_level_nxt;
    prebyte_en_reg  <= (queue_data_nxt[0][7:1] == 7'b0001_000);
  end
end
//
/////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////
//                             ASSIGN OUTPUTS
/////////////////////////////////////////////////////////////////////////////
//
assign QUEUE_REJECT_LEN_O  = queue_reject_len;
assign QUEUE_LEVEL_O       = queue_level_reg;
//
assign QUEUE_DATA_3_O = queue_data_reg[3];
assign QUEUE_DATA_2_O = queue_data_reg[2];
assign QUEUE_DATA_1_O = queue_data_reg[1];
assign QUEUE_DATA_0_O = queue_data_reg[0];
assign PREBYTE_EN_O   = prebyte_en_reg;
//
/////////////////////////////////////////////////////////////////////////////

endmodule


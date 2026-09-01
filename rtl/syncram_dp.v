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
// Description: Dual port synchronous RAM, parameterized byte width, with a
// per-byte lane write enable bus on port A (A_WE_I[RAM_BYTE_WIDTH-1:0]). Port B
// is read-only.
//
//////////////////////////////////////////////////////////////////////////////
// History:
// 08.23.2026 - Kevin Phillipson
//   File header added
//
//////////////////////////////////////////////////////////////////////////////
// [TURBO9_HEADER_END]

/////////////////////////////////////////////////////////////////////////////
//                                MODULE
/////////////////////////////////////////////////////////////////////////////
`include "turbo9_rtl_config.vh"

module syncram_dp
#(
  parameter RAM_BYTE_WIDTH = 1,   // Memory Byte Width: 1=8bit, 2=16bit
  parameter RAM_ADDR_WIDTH = 12   // RAM Address Width: 12=4K words
)
(
  input                             CLK_I,
  input   [RAM_BYTE_WIDTH-1:0]      A_WE_I,
  input   [RAM_ADDR_WIDTH-1:0]      A_ADR_I,
  input   [(RAM_BYTE_WIDTH*8)-1:0]  A_DAT_I,
  output  [(RAM_BYTE_WIDTH*8)-1:0]  A_DAT_O,

  input   [RAM_ADDR_WIDTH-1:0]      B_ADR_I,
  output  [(RAM_BYTE_WIDTH*8)-1:0]  B_DAT_O
);

/////////////////////////////////////////////////////////////////////////////
//                                LOGIC
/////////////////////////////////////////////////////////////////////////////

reg [(RAM_BYTE_WIDTH*8)-1:0] ram [0:(2**RAM_ADDR_WIDTH)-1];
reg [(RAM_BYTE_WIDTH*8)-1:0] a_dat_o_reg;
reg [(RAM_BYTE_WIDTH*8)-1:0] b_dat_o_reg;

integer i;

always @(posedge CLK_I)
begin
  for (i=0; i<RAM_BYTE_WIDTH; i=i+1) begin
    if (A_WE_I[i]) begin
      ram[A_ADR_I][i*8 +: 8] <= A_DAT_I[i*8 +: 8];
      a_dat_o_reg[i*8 +: 8]  <= A_DAT_I[i*8 +: 8]; //'write first' or transparent mode, less logic in FPGA block rams
    end else begin
      a_dat_o_reg[i*8 +: 8]  <= ram[A_ADR_I][i*8 +: 8];
    end
  end
  //
  b_dat_o_reg  <= ram[B_ADR_I];
  //
end

assign A_DAT_O = a_dat_o_reg;
assign B_DAT_O = b_dat_o_reg;

/////////////////////////////////////////////////////////////////////////////

endmodule

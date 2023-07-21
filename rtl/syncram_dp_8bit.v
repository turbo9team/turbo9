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
// Description: Dual port 8bit Synchronous RAM
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
module syncram_dp_8bit
#(
  parameter MEM_ADDR_WIDTH = 12,
  parameter MEM_INIT_FILE = "syncram_8bit.hex"
)
(
  input          CLK_I,
  input          A_WE_I,
  input   [MEM_ADDR_WIDTH-1:0] A_ADR_I,
  input   [ 7:0] A_DAT_I,
  output  [ 7:0] A_DAT_O,
  
  input   [MEM_ADDR_WIDTH-1:0] B_ADR_I,
  output  [ 7:0] B_DAT_O
);

/////////////////////////////////////////////////////////////////////////////
//                                LOGIC
/////////////////////////////////////////////////////////////////////////////

reg [7:0] ram [0:(2**MEM_ADDR_WIDTH)-1];
reg [7:0] a_dat_o_reg;
reg [7:0] b_dat_o_reg;

initial
begin
  $readmemh(MEM_INIT_FILE,ram);
end

always @(posedge CLK_I)
begin
  if (A_WE_I) begin
    ram[A_ADR_I] <= A_DAT_I;
    a_dat_o_reg  <= A_DAT_I; //'write first' or transparent mode, less logic in FPGA block rams
  end else begin
    a_dat_o_reg  <= ram[A_ADR_I];
  end
  //
  b_dat_o_reg  <= ram[B_ADR_I];
  //
end


assign A_DAT_O = a_dat_o_reg;
assign B_DAT_O = b_dat_o_reg;

/////////////////////////////////////////////////////////////////////////////

endmodule



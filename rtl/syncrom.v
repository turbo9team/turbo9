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
// Description: Synchronous ROM (read-only), parameterized byte width
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

module syncrom
#(
  parameter ROM_BYTE_WIDTH = 1,             // Memory Byte Width: 1=8bit, 2=16bit
  parameter ROM_ADDR_WIDTH = 12,            // ROM Address Width: 12=4K words
  parameter ROM_INIT_FILE  = "syncrom.hex"  // ROM Init File: syncrom.hex
)
(
  input                             CLK_I,
  input   [ROM_ADDR_WIDTH-1:0]      ADR_I,
  output  [(ROM_BYTE_WIDTH*8)-1:0]  DAT_O
);

/////////////////////////////////////////////////////////////////////////////
//                                LOGIC
/////////////////////////////////////////////////////////////////////////////

reg [(ROM_BYTE_WIDTH*8)-1:0] rom [0:(2**ROM_ADDR_WIDTH)-1];
reg [(ROM_BYTE_WIDTH*8)-1:0] dat_o_reg;

initial
begin
  $readmemh(ROM_INIT_FILE,rom);
end

always @(posedge CLK_I)
begin
  dat_o_reg <= rom[ADR_I];
end

assign DAT_O = dat_o_reg;

/////////////////////////////////////////////////////////////////////////////

endmodule

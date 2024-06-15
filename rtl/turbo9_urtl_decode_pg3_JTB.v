// [TURBO9_DECODE_HEADER_START]
//////////////////////////////////////////////////////////////////////////////
//                          Turbo9 Microprocessor IP
//////////////////////////////////////////////////////////////////////////////
// Website: www.turbo9.org
// Contact: team[at]turbo9[dot]org
//////////////////////////////////////////////////////////////////////////////
// [TURBO9_DECODE_LICENSE_START]
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
// [TURBO9_DECODE_LICENSE_END]
//////////////////////////////////////////////////////////////////////////////
// Engineer: Kevin Phillipson & Michael Rywalt
// Description:
// Assembled from turbo9_urtl.asm file
// built using cv_MICRO_SEQ_BRANCH_ADDR ctrl_vec
//
//////////////////////////////////////////////////////////////////////////////
// History:
// 07.14.2023 - Kevin Phillipson
//   File header added
//
//////////////////////////////////////////////////////////////////////////////
// [TURBO9_DECODE_HEADER_END]

/////////////////////////////////////////////////////////////////////////////
//                                MODULE
/////////////////////////////////////////////////////////////////////////////
module turbo9_urtl_decode_pg3_JTB(
  input      [7:0] OPCODE_I,
  output reg [7:0] PG3_JTB_O
);

/////////////////////////////////////////////////////////////////////////////
//                                LOGIC
/////////////////////////////////////////////////////////////////////////////

always @* begin
  case (OPCODE_I)
    8'h93 : PG3_JTB_O = 8'h1b; // CMP         CMPU (dir idx ext)
    8'h9C : PG3_JTB_O = 8'h1b; // CMP         CMPS (dir idx ext)
    8'hA3 : PG3_JTB_O = 8'h1b; // CMP         CMPU (dir idx ext)
    8'hAC : PG3_JTB_O = 8'h1b; // CMP         CMPS (dir idx ext)
    8'hB3 : PG3_JTB_O = 8'h1b; // CMP         CMPU (dir idx ext)
    8'hBC : PG3_JTB_O = 8'h1b; // CMP         CMPS (dir idx ext)
    default : PG3_JTB_O = 8'hFF; // from decode_init
  endcase
end

`ifdef SIM_TURBO9

reg [(8*64):0] PG3_JTB_op;

always @* begin
  case (OPCODE_I)
    8'h93 : PG3_JTB_op = "CMPU (dir idx ext)";
    8'h9C : PG3_JTB_op = "CMPS (dir idx ext)";
    8'hA3 : PG3_JTB_op = "CMPU (dir idx ext)";
    8'hAC : PG3_JTB_op = "CMPS (dir idx ext)";
    8'hB3 : PG3_JTB_op = "CMPU (dir idx ext)";
    8'hBC : PG3_JTB_op = "CMPS (dir idx ext)";
    default : PG3_JTB_op = "invalid";
  endcase
end

reg [(8*64):0] PG3_JTB_eq;

always @* begin
  case (OPCODE_I)
    8'h93 : PG3_JTB_eq = "CMP";
    8'h9C : PG3_JTB_eq = "CMP";
    8'hA3 : PG3_JTB_eq = "CMP";
    8'hAC : PG3_JTB_eq = "CMP";
    8'hB3 : PG3_JTB_eq = "CMP";
    8'hBC : PG3_JTB_eq = "CMP";
    default : PG3_JTB_eq = "invalid";
  endcase
end

`endif

/////////////////////////////////////////////////////////////////////////////

endmodule

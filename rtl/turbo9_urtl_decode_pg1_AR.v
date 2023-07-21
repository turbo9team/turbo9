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
// built using cv_AR_SEL ctrl_vec
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
module turbo9_urtl_decode_pg1_AR(
  input      [7:0] OPCODE_I,
  output reg [3:0] PG1_AR_O
);

/////////////////////////////////////////////////////////////////////////////
//                                LOGIC
/////////////////////////////////////////////////////////////////////////////

always @* begin
  case (OPCODE_I)
    8'h0F : PG1_AR_O = 4'he; // IDATA       CLR (dir ext)
    8'h17 : PG1_AR_O = 4'h4; // S           BSR LBSR
    8'h34 : PG1_AR_O = 4'h4; // S           PSHS
    8'h35 : PG1_AR_O = 4'h4; // S           PULS
    8'h36 : PG1_AR_O = 4'h3; // U           PSHU
    8'h37 : PG1_AR_O = 4'h3; // U           PULU
    8'h39 : PG1_AR_O = 4'h4; // S           RTS
    8'h3B : PG1_AR_O = 4'h4; // S           RTI
    8'h3F : PG1_AR_O = 4'h4; // S           SWI
    8'h6F : PG1_AR_O = 4'hc; // EA          CLR (idx)
    8'h7F : PG1_AR_O = 4'he; // IDATA       CLR (dir ext)
    8'h8D : PG1_AR_O = 4'h4; // S           BSR LBSR
    8'h97 : PG1_AR_O = 4'he; // IDATA       STA (dir ext)
    8'h9D : PG1_AR_O = 4'h4; // S           JSR (dir ext)
    8'h9F : PG1_AR_O = 4'he; // IDATA       STX (dir ext)
    8'hA7 : PG1_AR_O = 4'hc; // EA          STA (idx)
    8'hAD : PG1_AR_O = 4'h4; // S           JSR (idx)
    8'hAF : PG1_AR_O = 4'hc; // EA          STX (idx)
    8'hB7 : PG1_AR_O = 4'he; // IDATA       STA (dir ext)
    8'hBD : PG1_AR_O = 4'h4; // S           JSR (dir ext)
    8'hBF : PG1_AR_O = 4'he; // IDATA       STX (dir ext)
    8'hD7 : PG1_AR_O = 4'he; // IDATA       STB (dir ext)
    8'hDD : PG1_AR_O = 4'he; // IDATA       STD (dir ext)
    8'hDF : PG1_AR_O = 4'he; // IDATA       STU (dir ext)
    8'hE7 : PG1_AR_O = 4'hc; // EA          STB (idx)
    8'hED : PG1_AR_O = 4'hc; // EA          STD (idx)
    8'hEF : PG1_AR_O = 4'hc; // EA          STU (idx)
    8'hF7 : PG1_AR_O = 4'he; // IDATA       STB (dir ext)
    8'hFD : PG1_AR_O = 4'he; // IDATA       STD (dir ext)
    8'hFF : PG1_AR_O = 4'he; // IDATA       STU (dir ext)
    default : PG1_AR_O = 4'hx; // from decode_init
  endcase
end

`ifdef SIM_TURBO9

reg [(8*64):0] PG1_AR_op;

always @* begin
  case (OPCODE_I)
    8'h0F : PG1_AR_op = "CLR (dir ext)";
    8'h17 : PG1_AR_op = "BSR LBSR";
    8'h34 : PG1_AR_op = "PSHS";
    8'h35 : PG1_AR_op = "PULS";
    8'h36 : PG1_AR_op = "PSHU";
    8'h37 : PG1_AR_op = "PULU";
    8'h39 : PG1_AR_op = "RTS";
    8'h3B : PG1_AR_op = "RTI";
    8'h3F : PG1_AR_op = "SWI";
    8'h6F : PG1_AR_op = "CLR (idx)";
    8'h7F : PG1_AR_op = "CLR (dir ext)";
    8'h8D : PG1_AR_op = "BSR LBSR";
    8'h97 : PG1_AR_op = "STA (dir ext)";
    8'h9D : PG1_AR_op = "JSR (dir ext)";
    8'h9F : PG1_AR_op = "STX (dir ext)";
    8'hA7 : PG1_AR_op = "STA (idx)";
    8'hAD : PG1_AR_op = "JSR (idx)";
    8'hAF : PG1_AR_op = "STX (idx)";
    8'hB7 : PG1_AR_op = "STA (dir ext)";
    8'hBD : PG1_AR_op = "JSR (dir ext)";
    8'hBF : PG1_AR_op = "STX (dir ext)";
    8'hD7 : PG1_AR_op = "STB (dir ext)";
    8'hDD : PG1_AR_op = "STD (dir ext)";
    8'hDF : PG1_AR_op = "STU (dir ext)";
    8'hE7 : PG1_AR_op = "STB (idx)";
    8'hED : PG1_AR_op = "STD (idx)";
    8'hEF : PG1_AR_op = "STU (idx)";
    8'hF7 : PG1_AR_op = "STB (dir ext)";
    8'hFD : PG1_AR_op = "STD (dir ext)";
    8'hFF : PG1_AR_op = "STU (dir ext)";
    default : PG1_AR_op = "invalid";
  endcase
end

reg [(8*64):0] PG1_AR_eq;

always @* begin
  case (OPCODE_I)
    8'h0F : PG1_AR_eq = "IDATA";
    8'h17 : PG1_AR_eq = "S";
    8'h34 : PG1_AR_eq = "S";
    8'h35 : PG1_AR_eq = "S";
    8'h36 : PG1_AR_eq = "U";
    8'h37 : PG1_AR_eq = "U";
    8'h39 : PG1_AR_eq = "S";
    8'h3B : PG1_AR_eq = "S";
    8'h3F : PG1_AR_eq = "S";
    8'h6F : PG1_AR_eq = "EA";
    8'h7F : PG1_AR_eq = "IDATA";
    8'h8D : PG1_AR_eq = "S";
    8'h97 : PG1_AR_eq = "IDATA";
    8'h9D : PG1_AR_eq = "S";
    8'h9F : PG1_AR_eq = "IDATA";
    8'hA7 : PG1_AR_eq = "EA";
    8'hAD : PG1_AR_eq = "S";
    8'hAF : PG1_AR_eq = "EA";
    8'hB7 : PG1_AR_eq = "IDATA";
    8'hBD : PG1_AR_eq = "S";
    8'hBF : PG1_AR_eq = "IDATA";
    8'hD7 : PG1_AR_eq = "IDATA";
    8'hDD : PG1_AR_eq = "IDATA";
    8'hDF : PG1_AR_eq = "IDATA";
    8'hE7 : PG1_AR_eq = "EA";
    8'hED : PG1_AR_eq = "EA";
    8'hEF : PG1_AR_eq = "EA";
    8'hF7 : PG1_AR_eq = "IDATA";
    8'hFD : PG1_AR_eq = "IDATA";
    8'hFF : PG1_AR_eq = "IDATA";
    default : PG1_AR_eq = "invalid";
  endcase
end

`endif

/////////////////////////////////////////////////////////////////////////////

endmodule

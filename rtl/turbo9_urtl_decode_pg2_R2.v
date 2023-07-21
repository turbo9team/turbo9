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
// built using cv_R2_SEL ctrl_vec
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
module turbo9_urtl_decode_pg2_R2(
  input      [7:0] OPCODE_I,
  output reg [3:0] PG2_R2_O
);

/////////////////////////////////////////////////////////////////////////////
//                                LOGIC
/////////////////////////////////////////////////////////////////////////////

always @* begin
  case (OPCODE_I)
    8'h18 : PG2_R2_O = 4'h0; // D           IDIVS (inh)
    8'h20 : PG2_R2_O = 4'hc; // EA          LBRA LBRN LBHI LBLS
    8'h21 : PG2_R2_O = 4'hc; // EA          LBRA LBRN LBHI LBLS
    8'h22 : PG2_R2_O = 4'hc; // EA          LBRA LBRN LBHI LBLS
    8'h23 : PG2_R2_O = 4'hc; // EA          LBRA LBRN LBHI LBLS
    8'h24 : PG2_R2_O = 4'hc; // EA          LBCC LBCS LBNE LBEQ
    8'h25 : PG2_R2_O = 4'hc; // EA          LBCC LBCS LBNE LBEQ
    8'h26 : PG2_R2_O = 4'hc; // EA          LBCC LBCS LBNE LBEQ
    8'h27 : PG2_R2_O = 4'hc; // EA          LBCC LBCS LBNE LBEQ
    8'h28 : PG2_R2_O = 4'hc; // EA          LBVC LBVS LBPL LBMI
    8'h29 : PG2_R2_O = 4'hc; // EA          LBVC LBVS LBPL LBMI
    8'h2A : PG2_R2_O = 4'hc; // EA          LBVC LBVS LBPL LBMI
    8'h2B : PG2_R2_O = 4'hc; // EA          LBVC LBVS LBPL LBMI
    8'h2C : PG2_R2_O = 4'hc; // EA          LBGE LBLT LBGT LBLE
    8'h2D : PG2_R2_O = 4'hc; // EA          LBGE LBLT LBGT LBLE
    8'h2E : PG2_R2_O = 4'hc; // EA          LBGE LBLT LBGT LBLE
    8'h2F : PG2_R2_O = 4'hc; // EA          LBGE LBLT LBGT LBLE
    8'h83 : PG2_R2_O = 4'he; // IDATA       CMPD (imm)
    8'h8C : PG2_R2_O = 4'he; // IDATA       CMPY (imm)
    8'h8E : PG2_R2_O = 4'he; // IDATA       LDY (imm)
    8'h93 : PG2_R2_O = 4'hd; // DMEM_RD     CMPD (dir idx ext)
    8'h9C : PG2_R2_O = 4'hd; // DMEM_RD     CMPY (dir idx ext)
    8'h9E : PG2_R2_O = 4'hd; // DMEM_RD     LDY (dir idx ext)
    8'hA3 : PG2_R2_O = 4'hd; // DMEM_RD     CMPD (dir idx ext)
    8'hAC : PG2_R2_O = 4'hd; // DMEM_RD     CMPY (dir idx ext)
    8'hAE : PG2_R2_O = 4'hd; // DMEM_RD     LDY (dir idx ext)
    8'hB3 : PG2_R2_O = 4'hd; // DMEM_RD     CMPD (dir idx ext)
    8'hBC : PG2_R2_O = 4'hd; // DMEM_RD     CMPY (dir idx ext)
    8'hBE : PG2_R2_O = 4'hd; // DMEM_RD     LDY (dir idx ext)
    8'hCE : PG2_R2_O = 4'he; // IDATA       LDS (imm)
    8'hDE : PG2_R2_O = 4'hd; // DMEM_RD     LDS (dir idx ext)
    8'hEE : PG2_R2_O = 4'hd; // DMEM_RD     LDS (dir idx ext)
    8'hFE : PG2_R2_O = 4'hd; // DMEM_RD     LDS (dir idx ext)
    default : PG2_R2_O = 4'hx; // from decode_init
  endcase
end

`ifdef SIM_TURBO9

reg [(8*64):0] PG2_R2_op;

always @* begin
  case (OPCODE_I)
    8'h18 : PG2_R2_op = "IDIVS (inh)";
    8'h20 : PG2_R2_op = "LBRA LBRN LBHI LBLS";
    8'h21 : PG2_R2_op = "LBRA LBRN LBHI LBLS";
    8'h22 : PG2_R2_op = "LBRA LBRN LBHI LBLS";
    8'h23 : PG2_R2_op = "LBRA LBRN LBHI LBLS";
    8'h24 : PG2_R2_op = "LBCC LBCS LBNE LBEQ";
    8'h25 : PG2_R2_op = "LBCC LBCS LBNE LBEQ";
    8'h26 : PG2_R2_op = "LBCC LBCS LBNE LBEQ";
    8'h27 : PG2_R2_op = "LBCC LBCS LBNE LBEQ";
    8'h28 : PG2_R2_op = "LBVC LBVS LBPL LBMI";
    8'h29 : PG2_R2_op = "LBVC LBVS LBPL LBMI";
    8'h2A : PG2_R2_op = "LBVC LBVS LBPL LBMI";
    8'h2B : PG2_R2_op = "LBVC LBVS LBPL LBMI";
    8'h2C : PG2_R2_op = "LBGE LBLT LBGT LBLE";
    8'h2D : PG2_R2_op = "LBGE LBLT LBGT LBLE";
    8'h2E : PG2_R2_op = "LBGE LBLT LBGT LBLE";
    8'h2F : PG2_R2_op = "LBGE LBLT LBGT LBLE";
    8'h83 : PG2_R2_op = "CMPD (imm)";
    8'h8C : PG2_R2_op = "CMPY (imm)";
    8'h8E : PG2_R2_op = "LDY (imm)";
    8'h93 : PG2_R2_op = "CMPD (dir idx ext)";
    8'h9C : PG2_R2_op = "CMPY (dir idx ext)";
    8'h9E : PG2_R2_op = "LDY (dir idx ext)";
    8'hA3 : PG2_R2_op = "CMPD (dir idx ext)";
    8'hAC : PG2_R2_op = "CMPY (dir idx ext)";
    8'hAE : PG2_R2_op = "LDY (dir idx ext)";
    8'hB3 : PG2_R2_op = "CMPD (dir idx ext)";
    8'hBC : PG2_R2_op = "CMPY (dir idx ext)";
    8'hBE : PG2_R2_op = "LDY (dir idx ext)";
    8'hCE : PG2_R2_op = "LDS (imm)";
    8'hDE : PG2_R2_op = "LDS (dir idx ext)";
    8'hEE : PG2_R2_op = "LDS (dir idx ext)";
    8'hFE : PG2_R2_op = "LDS (dir idx ext)";
    default : PG2_R2_op = "invalid";
  endcase
end

reg [(8*64):0] PG2_R2_eq;

always @* begin
  case (OPCODE_I)
    8'h18 : PG2_R2_eq = "D";
    8'h20 : PG2_R2_eq = "EA";
    8'h21 : PG2_R2_eq = "EA";
    8'h22 : PG2_R2_eq = "EA";
    8'h23 : PG2_R2_eq = "EA";
    8'h24 : PG2_R2_eq = "EA";
    8'h25 : PG2_R2_eq = "EA";
    8'h26 : PG2_R2_eq = "EA";
    8'h27 : PG2_R2_eq = "EA";
    8'h28 : PG2_R2_eq = "EA";
    8'h29 : PG2_R2_eq = "EA";
    8'h2A : PG2_R2_eq = "EA";
    8'h2B : PG2_R2_eq = "EA";
    8'h2C : PG2_R2_eq = "EA";
    8'h2D : PG2_R2_eq = "EA";
    8'h2E : PG2_R2_eq = "EA";
    8'h2F : PG2_R2_eq = "EA";
    8'h83 : PG2_R2_eq = "IDATA";
    8'h8C : PG2_R2_eq = "IDATA";
    8'h8E : PG2_R2_eq = "IDATA";
    8'h93 : PG2_R2_eq = "DMEM_RD";
    8'h9C : PG2_R2_eq = "DMEM_RD";
    8'h9E : PG2_R2_eq = "DMEM_RD";
    8'hA3 : PG2_R2_eq = "DMEM_RD";
    8'hAC : PG2_R2_eq = "DMEM_RD";
    8'hAE : PG2_R2_eq = "DMEM_RD";
    8'hB3 : PG2_R2_eq = "DMEM_RD";
    8'hBC : PG2_R2_eq = "DMEM_RD";
    8'hBE : PG2_R2_eq = "DMEM_RD";
    8'hCE : PG2_R2_eq = "IDATA";
    8'hDE : PG2_R2_eq = "DMEM_RD";
    8'hEE : PG2_R2_eq = "DMEM_RD";
    8'hFE : PG2_R2_eq = "DMEM_RD";
    default : PG2_R2_eq = "invalid";
  endcase
end

`endif

/////////////////////////////////////////////////////////////////////////////

endmodule

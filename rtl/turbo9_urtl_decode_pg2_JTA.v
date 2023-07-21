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
module turbo9_urtl_decode_pg2_JTA(
  input      [7:0] OPCODE_I,
  output reg [7:0] PG2_JTA_O
);

/////////////////////////////////////////////////////////////////////////////
//                                LOGIC
/////////////////////////////////////////////////////////////////////////////

always @* begin
  case (OPCODE_I)
    8'h18 : PG2_JTA_O = 8'hd; // SAU16       IDIVS (inh)
    8'h20 : PG2_JTA_O = 8'h2b; // BRANCH      LBRA LBRN LBHI LBLS
    8'h21 : PG2_JTA_O = 8'h2b; // BRANCH      LBRA LBRN LBHI LBLS
    8'h22 : PG2_JTA_O = 8'h2b; // BRANCH      LBRA LBRN LBHI LBLS
    8'h23 : PG2_JTA_O = 8'h2b; // BRANCH      LBRA LBRN LBHI LBLS
    8'h24 : PG2_JTA_O = 8'h2b; // BRANCH      LBCC LBCS LBNE LBEQ
    8'h25 : PG2_JTA_O = 8'h2b; // BRANCH      LBCC LBCS LBNE LBEQ
    8'h26 : PG2_JTA_O = 8'h2b; // BRANCH      LBCC LBCS LBNE LBEQ
    8'h27 : PG2_JTA_O = 8'h2b; // BRANCH      LBCC LBCS LBNE LBEQ
    8'h28 : PG2_JTA_O = 8'h2b; // BRANCH      LBVC LBVS LBPL LBMI
    8'h29 : PG2_JTA_O = 8'h2b; // BRANCH      LBVC LBVS LBPL LBMI
    8'h2A : PG2_JTA_O = 8'h2b; // BRANCH      LBVC LBVS LBPL LBMI
    8'h2B : PG2_JTA_O = 8'h2b; // BRANCH      LBVC LBVS LBPL LBMI
    8'h2C : PG2_JTA_O = 8'h2b; // BRANCH      LBGE LBLT LBGT LBLE
    8'h2D : PG2_JTA_O = 8'h2b; // BRANCH      LBGE LBLT LBGT LBLE
    8'h2E : PG2_JTA_O = 8'h2b; // BRANCH      LBGE LBLT LBGT LBLE
    8'h2F : PG2_JTA_O = 8'h2b; // BRANCH      LBGE LBLT LBGT LBLE
    8'h83 : PG2_JTA_O = 8'h18; // CMP         CMPD (imm)
    8'h8C : PG2_JTA_O = 8'h18; // CMP         CMPY (imm)
    8'h8E : PG2_JTA_O = 8'h1a; // LD          LDY (imm)
    8'h93 : PG2_JTA_O = 8'h1; // LD_DIR_EXT  CMPD (dir ext)
    8'h9C : PG2_JTA_O = 8'h1; // LD_DIR_EXT  CMPY (dir ext)
    8'h9E : PG2_JTA_O = 8'h1; // LD_DIR_EXT  LDY (dir ext)
    8'h9F : PG2_JTA_O = 8'h1f; // ST          STY (dir ext)
    8'hA3 : PG2_JTA_O = 8'h2; // LD_INDEXED  CMPD (idx)
    8'hAC : PG2_JTA_O = 8'h2; // LD_INDEXED  CMPY (idx)
    8'hAE : PG2_JTA_O = 8'h2; // LD_INDEXED  LDY (idx)
    8'hAF : PG2_JTA_O = 8'h4; // ST_INDEXED  STY (idx)
    8'hB3 : PG2_JTA_O = 8'h1; // LD_DIR_EXT  CMPD (dir ext)
    8'hBC : PG2_JTA_O = 8'h1; // LD_DIR_EXT  CMPY (dir ext)
    8'hBE : PG2_JTA_O = 8'h1; // LD_DIR_EXT  LDY (dir ext)
    8'hBF : PG2_JTA_O = 8'h1f; // ST          STY (dir ext)
    8'hCE : PG2_JTA_O = 8'h1a; // LD          LDS (imm)
    8'hDE : PG2_JTA_O = 8'h1; // LD_DIR_EXT  LDS (dir ext)
    8'hDF : PG2_JTA_O = 8'h1f; // ST          STS (dir ext)
    8'hEE : PG2_JTA_O = 8'h2; // LD_INDEXED  LDS (idx)
    8'hEF : PG2_JTA_O = 8'h4; // ST_INDEXED  STS (idx)
    8'hFE : PG2_JTA_O = 8'h1; // LD_DIR_EXT  LDS (dir ext)
    8'hFF : PG2_JTA_O = 8'h1f; // ST          STS (dir ext)
    default : PG2_JTA_O = 8'hFF; // from decode_init
  endcase
end

`ifdef SIM_TURBO9

reg [(8*64):0] PG2_JTA_op;

always @* begin
  case (OPCODE_I)
    8'h18 : PG2_JTA_op = "IDIVS (inh)";
    8'h20 : PG2_JTA_op = "LBRA LBRN LBHI LBLS";
    8'h21 : PG2_JTA_op = "LBRA LBRN LBHI LBLS";
    8'h22 : PG2_JTA_op = "LBRA LBRN LBHI LBLS";
    8'h23 : PG2_JTA_op = "LBRA LBRN LBHI LBLS";
    8'h24 : PG2_JTA_op = "LBCC LBCS LBNE LBEQ";
    8'h25 : PG2_JTA_op = "LBCC LBCS LBNE LBEQ";
    8'h26 : PG2_JTA_op = "LBCC LBCS LBNE LBEQ";
    8'h27 : PG2_JTA_op = "LBCC LBCS LBNE LBEQ";
    8'h28 : PG2_JTA_op = "LBVC LBVS LBPL LBMI";
    8'h29 : PG2_JTA_op = "LBVC LBVS LBPL LBMI";
    8'h2A : PG2_JTA_op = "LBVC LBVS LBPL LBMI";
    8'h2B : PG2_JTA_op = "LBVC LBVS LBPL LBMI";
    8'h2C : PG2_JTA_op = "LBGE LBLT LBGT LBLE";
    8'h2D : PG2_JTA_op = "LBGE LBLT LBGT LBLE";
    8'h2E : PG2_JTA_op = "LBGE LBLT LBGT LBLE";
    8'h2F : PG2_JTA_op = "LBGE LBLT LBGT LBLE";
    8'h83 : PG2_JTA_op = "CMPD (imm)";
    8'h8C : PG2_JTA_op = "CMPY (imm)";
    8'h8E : PG2_JTA_op = "LDY (imm)";
    8'h93 : PG2_JTA_op = "CMPD (dir ext)";
    8'h9C : PG2_JTA_op = "CMPY (dir ext)";
    8'h9E : PG2_JTA_op = "LDY (dir ext)";
    8'h9F : PG2_JTA_op = "STY (dir ext)";
    8'hA3 : PG2_JTA_op = "CMPD (idx)";
    8'hAC : PG2_JTA_op = "CMPY (idx)";
    8'hAE : PG2_JTA_op = "LDY (idx)";
    8'hAF : PG2_JTA_op = "STY (idx)";
    8'hB3 : PG2_JTA_op = "CMPD (dir ext)";
    8'hBC : PG2_JTA_op = "CMPY (dir ext)";
    8'hBE : PG2_JTA_op = "LDY (dir ext)";
    8'hBF : PG2_JTA_op = "STY (dir ext)";
    8'hCE : PG2_JTA_op = "LDS (imm)";
    8'hDE : PG2_JTA_op = "LDS (dir ext)";
    8'hDF : PG2_JTA_op = "STS (dir ext)";
    8'hEE : PG2_JTA_op = "LDS (idx)";
    8'hEF : PG2_JTA_op = "STS (idx)";
    8'hFE : PG2_JTA_op = "LDS (dir ext)";
    8'hFF : PG2_JTA_op = "STS (dir ext)";
    default : PG2_JTA_op = "invalid";
  endcase
end

reg [(8*64):0] PG2_JTA_eq;

always @* begin
  case (OPCODE_I)
    8'h18 : PG2_JTA_eq = "SAU16";
    8'h20 : PG2_JTA_eq = "BRANCH";
    8'h21 : PG2_JTA_eq = "BRANCH";
    8'h22 : PG2_JTA_eq = "BRANCH";
    8'h23 : PG2_JTA_eq = "BRANCH";
    8'h24 : PG2_JTA_eq = "BRANCH";
    8'h25 : PG2_JTA_eq = "BRANCH";
    8'h26 : PG2_JTA_eq = "BRANCH";
    8'h27 : PG2_JTA_eq = "BRANCH";
    8'h28 : PG2_JTA_eq = "BRANCH";
    8'h29 : PG2_JTA_eq = "BRANCH";
    8'h2A : PG2_JTA_eq = "BRANCH";
    8'h2B : PG2_JTA_eq = "BRANCH";
    8'h2C : PG2_JTA_eq = "BRANCH";
    8'h2D : PG2_JTA_eq = "BRANCH";
    8'h2E : PG2_JTA_eq = "BRANCH";
    8'h2F : PG2_JTA_eq = "BRANCH";
    8'h83 : PG2_JTA_eq = "CMP";
    8'h8C : PG2_JTA_eq = "CMP";
    8'h8E : PG2_JTA_eq = "LD";
    8'h93 : PG2_JTA_eq = "LD_DIR_EXT";
    8'h9C : PG2_JTA_eq = "LD_DIR_EXT";
    8'h9E : PG2_JTA_eq = "LD_DIR_EXT";
    8'h9F : PG2_JTA_eq = "ST";
    8'hA3 : PG2_JTA_eq = "LD_INDEXED";
    8'hAC : PG2_JTA_eq = "LD_INDEXED";
    8'hAE : PG2_JTA_eq = "LD_INDEXED";
    8'hAF : PG2_JTA_eq = "ST_INDEXED";
    8'hB3 : PG2_JTA_eq = "LD_DIR_EXT";
    8'hBC : PG2_JTA_eq = "LD_DIR_EXT";
    8'hBE : PG2_JTA_eq = "LD_DIR_EXT";
    8'hBF : PG2_JTA_eq = "ST";
    8'hCE : PG2_JTA_eq = "LD";
    8'hDE : PG2_JTA_eq = "LD_DIR_EXT";
    8'hDF : PG2_JTA_eq = "ST";
    8'hEE : PG2_JTA_eq = "LD_INDEXED";
    8'hEF : PG2_JTA_eq = "ST_INDEXED";
    8'hFE : PG2_JTA_eq = "LD_DIR_EXT";
    8'hFF : PG2_JTA_eq = "ST";
    default : PG2_JTA_eq = "invalid";
  endcase
end

`endif

/////////////////////////////////////////////////////////////////////////////

endmodule

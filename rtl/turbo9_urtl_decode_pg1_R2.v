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
module turbo9_urtl_decode_pg1_R2(
  input      [7:0] OPCODE_I,
  output reg [3:0] PG1_R2_O
);

/////////////////////////////////////////////////////////////////////////////
//                                LOGIC
/////////////////////////////////////////////////////////////////////////////

always @* begin
  case (OPCODE_I)
    8'h00 : PG1_R2_O = 4'hd; // DMEM_RD     NEG (dir idx ext)
    8'h03 : PG1_R2_O = 4'hd; // DMEM_RD     COM (dir idx ext)
    8'h0E : PG1_R2_O = 4'he; // IDATA       JMP (dir ext)
    8'h14 : PG1_R2_O = 4'h2; // Y           EMUL (inh)
    8'h16 : PG1_R2_O = 4'hc; // EA          LBRA 
    8'h17 : PG1_R2_O = 4'hc; // EA          BSR LBSR
    8'h18 : PG1_R2_O = 4'h0; // D           IDIV (inh)
    8'h1A : PG1_R2_O = 4'he; // IDATA       ORCC (imm)
    8'h1C : PG1_R2_O = 4'he; // IDATA       ANDCC (imm)
    8'h1D : PG1_R2_O = 4'h7; // SEXB        SEX(inh)
    8'h20 : PG1_R2_O = 4'hc; // EA          BRA BRN BHI BLS
    8'h21 : PG1_R2_O = 4'hc; // EA          BRA BRN BHI BLS
    8'h22 : PG1_R2_O = 4'hc; // EA          BRA BRN BHI BLS
    8'h23 : PG1_R2_O = 4'hc; // EA          BRA BRN BHI BLS
    8'h24 : PG1_R2_O = 4'hc; // EA          BCC BCS BNE BEQ
    8'h25 : PG1_R2_O = 4'hc; // EA          BCC BCS BNE BEQ
    8'h26 : PG1_R2_O = 4'hc; // EA          BCC BCS BNE BEQ
    8'h27 : PG1_R2_O = 4'hc; // EA          BCC BCS BNE BEQ
    8'h28 : PG1_R2_O = 4'hc; // EA          BVC BVS BPL BMI
    8'h29 : PG1_R2_O = 4'hc; // EA          BVC BVS BPL BMI
    8'h2A : PG1_R2_O = 4'hc; // EA          BVC BVS BPL BMI
    8'h2B : PG1_R2_O = 4'hc; // EA          BVC BVS BPL BMI
    8'h2C : PG1_R2_O = 4'hc; // EA          BGE BLT BGT BLE
    8'h2D : PG1_R2_O = 4'hc; // EA          BGE BLT BGT BLE
    8'h2E : PG1_R2_O = 4'hc; // EA          BGE BLT BGT BLE
    8'h2F : PG1_R2_O = 4'hc; // EA          BGE BLT BGT BLE
    8'h39 : PG1_R2_O = 4'hd; // DMEM_RD     RTS
    8'h3A : PG1_R2_O = 4'h9; // B           ABX(inh)
    8'h3B : PG1_R2_O = 4'hd; // DMEM_RD     RTI
    8'h3F : PG1_R2_O = 4'hd; // DMEM_RD     SWI
    8'h40 : PG1_R2_O = 4'h8; // A           NEGA (inh)
    8'h43 : PG1_R2_O = 4'h8; // A           COMA (inh)
    8'h50 : PG1_R2_O = 4'h9; // B           NEGB (inh)
    8'h53 : PG1_R2_O = 4'h9; // B           COMB (inh)
    8'h60 : PG1_R2_O = 4'hd; // DMEM_RD     NEG (dir idx ext)
    8'h63 : PG1_R2_O = 4'hd; // DMEM_RD     COM (dir idx ext)
    8'h6E : PG1_R2_O = 4'hc; // EA          JMP (idx)
    8'h70 : PG1_R2_O = 4'hd; // DMEM_RD     NEG (dir idx ext)
    8'h73 : PG1_R2_O = 4'hd; // DMEM_RD     COM (dir idx ext)
    8'h7E : PG1_R2_O = 4'he; // IDATA       JMP (dir ext)
    8'h80 : PG1_R2_O = 4'he; // IDATA       SUBA (imm)
    8'h81 : PG1_R2_O = 4'he; // IDATA       CMPA (imm)
    8'h82 : PG1_R2_O = 4'he; // IDATA       SBCA (imm)
    8'h83 : PG1_R2_O = 4'he; // IDATA       SUBD (imm)
    8'h84 : PG1_R2_O = 4'he; // IDATA       ANDA (imm)
    8'h85 : PG1_R2_O = 4'he; // IDATA       BITA (imm)
    8'h86 : PG1_R2_O = 4'he; // IDATA       LDA (imm)
    8'h88 : PG1_R2_O = 4'he; // IDATA       EORA (imm)
    8'h89 : PG1_R2_O = 4'he; // IDATA       ADCA (imm)
    8'h8A : PG1_R2_O = 4'he; // IDATA       ORA (imm)
    8'h8B : PG1_R2_O = 4'he; // IDATA       ADDA (imm)
    8'h8C : PG1_R2_O = 4'he; // IDATA       CMPX (imm)
    8'h8D : PG1_R2_O = 4'hc; // EA          BSR LBSR
    8'h8E : PG1_R2_O = 4'he; // IDATA       LDX (imm)
    8'h90 : PG1_R2_O = 4'hd; // DMEM_RD     SUBA (dir idx ext)
    8'h91 : PG1_R2_O = 4'hd; // DMEM_RD     CMPA (dir idx ext)
    8'h92 : PG1_R2_O = 4'hd; // DMEM_RD     SBCA (dir idx ext)
    8'h93 : PG1_R2_O = 4'hd; // DMEM_RD     SUBD (dir idx ext)
    8'h94 : PG1_R2_O = 4'hd; // DMEM_RD     ANDA (dir idx ext)
    8'h95 : PG1_R2_O = 4'hd; // DMEM_RD     BITA (dir idx ext)
    8'h96 : PG1_R2_O = 4'hd; // DMEM_RD     LDA (dir idx ext)
    8'h98 : PG1_R2_O = 4'hd; // DMEM_RD     EORA (dir idx ext)
    8'h99 : PG1_R2_O = 4'hd; // DMEM_RD     ADCA (dir idx ext)
    8'h9A : PG1_R2_O = 4'hd; // DMEM_RD     ORA (dir idx ext)
    8'h9B : PG1_R2_O = 4'hd; // DMEM_RD     ADDA (dir idx ext)
    8'h9C : PG1_R2_O = 4'hd; // DMEM_RD     CMPX (dir idx ext)
    8'h9D : PG1_R2_O = 4'he; // IDATA       JSR (dir ext)
    8'h9E : PG1_R2_O = 4'hd; // DMEM_RD     LDX (dir idx ext)
    8'hA0 : PG1_R2_O = 4'hd; // DMEM_RD     SUBA (dir idx ext)
    8'hA1 : PG1_R2_O = 4'hd; // DMEM_RD     CMPA (dir idx ext)
    8'hA2 : PG1_R2_O = 4'hd; // DMEM_RD     SBCA (dir idx ext)
    8'hA3 : PG1_R2_O = 4'hd; // DMEM_RD     SUBD (dir idx ext)
    8'hA4 : PG1_R2_O = 4'hd; // DMEM_RD     ANDA (dir idx ext)
    8'hA5 : PG1_R2_O = 4'hd; // DMEM_RD     BITA (dir idx ext)
    8'hA6 : PG1_R2_O = 4'hd; // DMEM_RD     LDA (dir idx ext)
    8'hA8 : PG1_R2_O = 4'hd; // DMEM_RD     EORA (dir idx ext)
    8'hA9 : PG1_R2_O = 4'hd; // DMEM_RD     ADCA (dir idx ext)
    8'hAA : PG1_R2_O = 4'hd; // DMEM_RD     ORA (dir idx ext)
    8'hAB : PG1_R2_O = 4'hd; // DMEM_RD     ADDA (dir idx ext)
    8'hAC : PG1_R2_O = 4'hd; // DMEM_RD     CMPX (dir idx ext)
    8'hAD : PG1_R2_O = 4'hc; // EA          JSR (idx)
    8'hAE : PG1_R2_O = 4'hd; // DMEM_RD     LDX (dir idx ext)
    8'hB0 : PG1_R2_O = 4'hd; // DMEM_RD     SUBA (dir idx ext)
    8'hB1 : PG1_R2_O = 4'hd; // DMEM_RD     CMPA (dir idx ext)
    8'hB2 : PG1_R2_O = 4'hd; // DMEM_RD     SBCA (dir idx ext)
    8'hB3 : PG1_R2_O = 4'hd; // DMEM_RD     SUBD (dir idx ext)
    8'hB4 : PG1_R2_O = 4'hd; // DMEM_RD     ANDA (dir idx ext)
    8'hB5 : PG1_R2_O = 4'hd; // DMEM_RD     BITA (dir idx ext)
    8'hB6 : PG1_R2_O = 4'hd; // DMEM_RD     LDA (dir idx ext)
    8'hB8 : PG1_R2_O = 4'hd; // DMEM_RD     EORA (dir idx ext)
    8'hB9 : PG1_R2_O = 4'hd; // DMEM_RD     ADCA (dir idx ext)
    8'hBA : PG1_R2_O = 4'hd; // DMEM_RD     ORA (dir idx ext)
    8'hBB : PG1_R2_O = 4'hd; // DMEM_RD     ADDA (dir idx ext)
    8'hBC : PG1_R2_O = 4'hd; // DMEM_RD     CMPX (dir idx ext)
    8'hBD : PG1_R2_O = 4'he; // IDATA       JSR (dir ext)
    8'hBE : PG1_R2_O = 4'hd; // DMEM_RD     LDX (dir idx ext)
    8'hC0 : PG1_R2_O = 4'he; // IDATA       SUBB (imm)
    8'hC1 : PG1_R2_O = 4'he; // IDATA       CMPB (imm)
    8'hC2 : PG1_R2_O = 4'he; // IDATA       SBCB (imm)
    8'hC3 : PG1_R2_O = 4'he; // IDATA       ADDD (imm)
    8'hC4 : PG1_R2_O = 4'he; // IDATA       ANDB (imm)
    8'hC5 : PG1_R2_O = 4'he; // IDATA       BITB (imm)
    8'hC6 : PG1_R2_O = 4'he; // IDATA       LDB (imm)
    8'hC8 : PG1_R2_O = 4'he; // IDATA       EORB (imm)
    8'hC9 : PG1_R2_O = 4'he; // IDATA       ADCB (imm)
    8'hCA : PG1_R2_O = 4'he; // IDATA       ORB (imm)
    8'hCB : PG1_R2_O = 4'he; // IDATA       ADDB (imm)
    8'hCC : PG1_R2_O = 4'he; // IDATA       LDD (imm)
    8'hCE : PG1_R2_O = 4'he; // IDATA       LDU (imm)
    8'hD0 : PG1_R2_O = 4'hd; // DMEM_RD     SUBB (dir idx ext)
    8'hD1 : PG1_R2_O = 4'hd; // DMEM_RD     CMPB (dir idx ext)
    8'hD2 : PG1_R2_O = 4'hd; // DMEM_RD     SBCB (dir idx ext)
    8'hD3 : PG1_R2_O = 4'hd; // DMEM_RD     ADDD (dir idx ext)
    8'hD4 : PG1_R2_O = 4'hd; // DMEM_RD     ANDB (dir idx ext)
    8'hD5 : PG1_R2_O = 4'hd; // DMEM_RD     BITB (dir idx ext)
    8'hD6 : PG1_R2_O = 4'hd; // DMEM_RD     LDB (dir idx ext)
    8'hD8 : PG1_R2_O = 4'hd; // DMEM_RD     EORB (dir idx ext)
    8'hD9 : PG1_R2_O = 4'hd; // DMEM_RD     ADCB (dir idx ext)
    8'hDA : PG1_R2_O = 4'hd; // DMEM_RD     ORB (dir idx ext)
    8'hDB : PG1_R2_O = 4'hd; // DMEM_RD     ADDB (dir idx ext)
    8'hDC : PG1_R2_O = 4'hd; // DMEM_RD     LDD (dir idx ext)
    8'hDE : PG1_R2_O = 4'hd; // DMEM_RD     LDU (dir idx ext)
    8'hE0 : PG1_R2_O = 4'hd; // DMEM_RD     SUBB (dir idx ext)
    8'hE1 : PG1_R2_O = 4'hd; // DMEM_RD     CMPB (dir idx ext)
    8'hE2 : PG1_R2_O = 4'hd; // DMEM_RD     SBCB (dir idx ext)
    8'hE3 : PG1_R2_O = 4'hd; // DMEM_RD     ADDD (dir idx ext)
    8'hE4 : PG1_R2_O = 4'hd; // DMEM_RD     ANDB (dir idx ext)
    8'hE5 : PG1_R2_O = 4'hd; // DMEM_RD     BITB (dir idx ext)
    8'hE6 : PG1_R2_O = 4'hd; // DMEM_RD     LDB (dir idx ext)
    8'hE8 : PG1_R2_O = 4'hd; // DMEM_RD     EORB (dir idx ext)
    8'hE9 : PG1_R2_O = 4'hd; // DMEM_RD     ADCB (dir idx ext)
    8'hEA : PG1_R2_O = 4'hd; // DMEM_RD     ORB (dir idx ext)
    8'hEB : PG1_R2_O = 4'hd; // DMEM_RD     ADDB (dir idx ext)
    8'hEC : PG1_R2_O = 4'hd; // DMEM_RD     LDD (dir idx ext)
    8'hEE : PG1_R2_O = 4'hd; // DMEM_RD     LDU (dir idx ext)
    8'hF0 : PG1_R2_O = 4'hd; // DMEM_RD     SUBB (dir idx ext)
    8'hF1 : PG1_R2_O = 4'hd; // DMEM_RD     CMPB (dir idx ext)
    8'hF2 : PG1_R2_O = 4'hd; // DMEM_RD     SBCB (dir idx ext)
    8'hF3 : PG1_R2_O = 4'hd; // DMEM_RD     ADDD (dir idx ext)
    8'hF4 : PG1_R2_O = 4'hd; // DMEM_RD     ANDB (dir idx ext)
    8'hF5 : PG1_R2_O = 4'hd; // DMEM_RD     BITB (dir idx ext)
    8'hF6 : PG1_R2_O = 4'hd; // DMEM_RD     LDB (dir idx ext)
    8'hF8 : PG1_R2_O = 4'hd; // DMEM_RD     EORB (dir idx ext)
    8'hF9 : PG1_R2_O = 4'hd; // DMEM_RD     ADCB (dir idx ext)
    8'hFA : PG1_R2_O = 4'hd; // DMEM_RD     ORB (dir idx ext)
    8'hFB : PG1_R2_O = 4'hd; // DMEM_RD     ADDB (dir idx ext)
    8'hFC : PG1_R2_O = 4'hd; // DMEM_RD     LDD (dir idx ext)
    8'hFE : PG1_R2_O = 4'hd; // DMEM_RD     LDU (dir idx ext)
    default : PG1_R2_O = 4'hx; // from decode_init
  endcase
end

`ifdef SIM_TURBO9

reg [(8*64):0] PG1_R2_op;

always @* begin
  case (OPCODE_I)
    8'h00 : PG1_R2_op = "NEG (dir idx ext)";
    8'h03 : PG1_R2_op = "COM (dir idx ext)";
    8'h0E : PG1_R2_op = "JMP (dir ext)";
    8'h14 : PG1_R2_op = "EMUL (inh)";
    8'h16 : PG1_R2_op = "LBRA ";
    8'h17 : PG1_R2_op = "BSR LBSR";
    8'h18 : PG1_R2_op = "IDIV (inh)";
    8'h1A : PG1_R2_op = "ORCC (imm)";
    8'h1C : PG1_R2_op = "ANDCC (imm)";
    8'h1D : PG1_R2_op = "SEX(inh)";
    8'h20 : PG1_R2_op = "BRA BRN BHI BLS";
    8'h21 : PG1_R2_op = "BRA BRN BHI BLS";
    8'h22 : PG1_R2_op = "BRA BRN BHI BLS";
    8'h23 : PG1_R2_op = "BRA BRN BHI BLS";
    8'h24 : PG1_R2_op = "BCC BCS BNE BEQ";
    8'h25 : PG1_R2_op = "BCC BCS BNE BEQ";
    8'h26 : PG1_R2_op = "BCC BCS BNE BEQ";
    8'h27 : PG1_R2_op = "BCC BCS BNE BEQ";
    8'h28 : PG1_R2_op = "BVC BVS BPL BMI";
    8'h29 : PG1_R2_op = "BVC BVS BPL BMI";
    8'h2A : PG1_R2_op = "BVC BVS BPL BMI";
    8'h2B : PG1_R2_op = "BVC BVS BPL BMI";
    8'h2C : PG1_R2_op = "BGE BLT BGT BLE";
    8'h2D : PG1_R2_op = "BGE BLT BGT BLE";
    8'h2E : PG1_R2_op = "BGE BLT BGT BLE";
    8'h2F : PG1_R2_op = "BGE BLT BGT BLE";
    8'h39 : PG1_R2_op = "RTS";
    8'h3A : PG1_R2_op = "ABX(inh)";
    8'h3B : PG1_R2_op = "RTI";
    8'h3F : PG1_R2_op = "SWI";
    8'h40 : PG1_R2_op = "NEGA (inh)";
    8'h43 : PG1_R2_op = "COMA (inh)";
    8'h50 : PG1_R2_op = "NEGB (inh)";
    8'h53 : PG1_R2_op = "COMB (inh)";
    8'h60 : PG1_R2_op = "NEG (dir idx ext)";
    8'h63 : PG1_R2_op = "COM (dir idx ext)";
    8'h6E : PG1_R2_op = "JMP (idx)";
    8'h70 : PG1_R2_op = "NEG (dir idx ext)";
    8'h73 : PG1_R2_op = "COM (dir idx ext)";
    8'h7E : PG1_R2_op = "JMP (dir ext)";
    8'h80 : PG1_R2_op = "SUBA (imm)";
    8'h81 : PG1_R2_op = "CMPA (imm)";
    8'h82 : PG1_R2_op = "SBCA (imm)";
    8'h83 : PG1_R2_op = "SUBD (imm)";
    8'h84 : PG1_R2_op = "ANDA (imm)";
    8'h85 : PG1_R2_op = "BITA (imm)";
    8'h86 : PG1_R2_op = "LDA (imm)";
    8'h88 : PG1_R2_op = "EORA (imm)";
    8'h89 : PG1_R2_op = "ADCA (imm)";
    8'h8A : PG1_R2_op = "ORA (imm)";
    8'h8B : PG1_R2_op = "ADDA (imm)";
    8'h8C : PG1_R2_op = "CMPX (imm)";
    8'h8D : PG1_R2_op = "BSR LBSR";
    8'h8E : PG1_R2_op = "LDX (imm)";
    8'h90 : PG1_R2_op = "SUBA (dir idx ext)";
    8'h91 : PG1_R2_op = "CMPA (dir idx ext)";
    8'h92 : PG1_R2_op = "SBCA (dir idx ext)";
    8'h93 : PG1_R2_op = "SUBD (dir idx ext)";
    8'h94 : PG1_R2_op = "ANDA (dir idx ext)";
    8'h95 : PG1_R2_op = "BITA (dir idx ext)";
    8'h96 : PG1_R2_op = "LDA (dir idx ext)";
    8'h98 : PG1_R2_op = "EORA (dir idx ext)";
    8'h99 : PG1_R2_op = "ADCA (dir idx ext)";
    8'h9A : PG1_R2_op = "ORA (dir idx ext)";
    8'h9B : PG1_R2_op = "ADDA (dir idx ext)";
    8'h9C : PG1_R2_op = "CMPX (dir idx ext)";
    8'h9D : PG1_R2_op = "JSR (dir ext)";
    8'h9E : PG1_R2_op = "LDX (dir idx ext)";
    8'hA0 : PG1_R2_op = "SUBA (dir idx ext)";
    8'hA1 : PG1_R2_op = "CMPA (dir idx ext)";
    8'hA2 : PG1_R2_op = "SBCA (dir idx ext)";
    8'hA3 : PG1_R2_op = "SUBD (dir idx ext)";
    8'hA4 : PG1_R2_op = "ANDA (dir idx ext)";
    8'hA5 : PG1_R2_op = "BITA (dir idx ext)";
    8'hA6 : PG1_R2_op = "LDA (dir idx ext)";
    8'hA8 : PG1_R2_op = "EORA (dir idx ext)";
    8'hA9 : PG1_R2_op = "ADCA (dir idx ext)";
    8'hAA : PG1_R2_op = "ORA (dir idx ext)";
    8'hAB : PG1_R2_op = "ADDA (dir idx ext)";
    8'hAC : PG1_R2_op = "CMPX (dir idx ext)";
    8'hAD : PG1_R2_op = "JSR (idx)";
    8'hAE : PG1_R2_op = "LDX (dir idx ext)";
    8'hB0 : PG1_R2_op = "SUBA (dir idx ext)";
    8'hB1 : PG1_R2_op = "CMPA (dir idx ext)";
    8'hB2 : PG1_R2_op = "SBCA (dir idx ext)";
    8'hB3 : PG1_R2_op = "SUBD (dir idx ext)";
    8'hB4 : PG1_R2_op = "ANDA (dir idx ext)";
    8'hB5 : PG1_R2_op = "BITA (dir idx ext)";
    8'hB6 : PG1_R2_op = "LDA (dir idx ext)";
    8'hB8 : PG1_R2_op = "EORA (dir idx ext)";
    8'hB9 : PG1_R2_op = "ADCA (dir idx ext)";
    8'hBA : PG1_R2_op = "ORA (dir idx ext)";
    8'hBB : PG1_R2_op = "ADDA (dir idx ext)";
    8'hBC : PG1_R2_op = "CMPX (dir idx ext)";
    8'hBD : PG1_R2_op = "JSR (dir ext)";
    8'hBE : PG1_R2_op = "LDX (dir idx ext)";
    8'hC0 : PG1_R2_op = "SUBB (imm)";
    8'hC1 : PG1_R2_op = "CMPB (imm)";
    8'hC2 : PG1_R2_op = "SBCB (imm)";
    8'hC3 : PG1_R2_op = "ADDD (imm)";
    8'hC4 : PG1_R2_op = "ANDB (imm)";
    8'hC5 : PG1_R2_op = "BITB (imm)";
    8'hC6 : PG1_R2_op = "LDB (imm)";
    8'hC8 : PG1_R2_op = "EORB (imm)";
    8'hC9 : PG1_R2_op = "ADCB (imm)";
    8'hCA : PG1_R2_op = "ORB (imm)";
    8'hCB : PG1_R2_op = "ADDB (imm)";
    8'hCC : PG1_R2_op = "LDD (imm)";
    8'hCE : PG1_R2_op = "LDU (imm)";
    8'hD0 : PG1_R2_op = "SUBB (dir idx ext)";
    8'hD1 : PG1_R2_op = "CMPB (dir idx ext)";
    8'hD2 : PG1_R2_op = "SBCB (dir idx ext)";
    8'hD3 : PG1_R2_op = "ADDD (dir idx ext)";
    8'hD4 : PG1_R2_op = "ANDB (dir idx ext)";
    8'hD5 : PG1_R2_op = "BITB (dir idx ext)";
    8'hD6 : PG1_R2_op = "LDB (dir idx ext)";
    8'hD8 : PG1_R2_op = "EORB (dir idx ext)";
    8'hD9 : PG1_R2_op = "ADCB (dir idx ext)";
    8'hDA : PG1_R2_op = "ORB (dir idx ext)";
    8'hDB : PG1_R2_op = "ADDB (dir idx ext)";
    8'hDC : PG1_R2_op = "LDD (dir idx ext)";
    8'hDE : PG1_R2_op = "LDU (dir idx ext)";
    8'hE0 : PG1_R2_op = "SUBB (dir idx ext)";
    8'hE1 : PG1_R2_op = "CMPB (dir idx ext)";
    8'hE2 : PG1_R2_op = "SBCB (dir idx ext)";
    8'hE3 : PG1_R2_op = "ADDD (dir idx ext)";
    8'hE4 : PG1_R2_op = "ANDB (dir idx ext)";
    8'hE5 : PG1_R2_op = "BITB (dir idx ext)";
    8'hE6 : PG1_R2_op = "LDB (dir idx ext)";
    8'hE8 : PG1_R2_op = "EORB (dir idx ext)";
    8'hE9 : PG1_R2_op = "ADCB (dir idx ext)";
    8'hEA : PG1_R2_op = "ORB (dir idx ext)";
    8'hEB : PG1_R2_op = "ADDB (dir idx ext)";
    8'hEC : PG1_R2_op = "LDD (dir idx ext)";
    8'hEE : PG1_R2_op = "LDU (dir idx ext)";
    8'hF0 : PG1_R2_op = "SUBB (dir idx ext)";
    8'hF1 : PG1_R2_op = "CMPB (dir idx ext)";
    8'hF2 : PG1_R2_op = "SBCB (dir idx ext)";
    8'hF3 : PG1_R2_op = "ADDD (dir idx ext)";
    8'hF4 : PG1_R2_op = "ANDB (dir idx ext)";
    8'hF5 : PG1_R2_op = "BITB (dir idx ext)";
    8'hF6 : PG1_R2_op = "LDB (dir idx ext)";
    8'hF8 : PG1_R2_op = "EORB (dir idx ext)";
    8'hF9 : PG1_R2_op = "ADCB (dir idx ext)";
    8'hFA : PG1_R2_op = "ORB (dir idx ext)";
    8'hFB : PG1_R2_op = "ADDB (dir idx ext)";
    8'hFC : PG1_R2_op = "LDD (dir idx ext)";
    8'hFE : PG1_R2_op = "LDU (dir idx ext)";
    default : PG1_R2_op = "invalid";
  endcase
end

reg [(8*64):0] PG1_R2_eq;

always @* begin
  case (OPCODE_I)
    8'h00 : PG1_R2_eq = "DMEM_RD";
    8'h03 : PG1_R2_eq = "DMEM_RD";
    8'h0E : PG1_R2_eq = "IDATA";
    8'h14 : PG1_R2_eq = "Y";
    8'h16 : PG1_R2_eq = "EA";
    8'h17 : PG1_R2_eq = "EA";
    8'h18 : PG1_R2_eq = "D";
    8'h1A : PG1_R2_eq = "IDATA";
    8'h1C : PG1_R2_eq = "IDATA";
    8'h1D : PG1_R2_eq = "SEXB";
    8'h20 : PG1_R2_eq = "EA";
    8'h21 : PG1_R2_eq = "EA";
    8'h22 : PG1_R2_eq = "EA";
    8'h23 : PG1_R2_eq = "EA";
    8'h24 : PG1_R2_eq = "EA";
    8'h25 : PG1_R2_eq = "EA";
    8'h26 : PG1_R2_eq = "EA";
    8'h27 : PG1_R2_eq = "EA";
    8'h28 : PG1_R2_eq = "EA";
    8'h29 : PG1_R2_eq = "EA";
    8'h2A : PG1_R2_eq = "EA";
    8'h2B : PG1_R2_eq = "EA";
    8'h2C : PG1_R2_eq = "EA";
    8'h2D : PG1_R2_eq = "EA";
    8'h2E : PG1_R2_eq = "EA";
    8'h2F : PG1_R2_eq = "EA";
    8'h39 : PG1_R2_eq = "DMEM_RD";
    8'h3A : PG1_R2_eq = "B";
    8'h3B : PG1_R2_eq = "DMEM_RD";
    8'h3F : PG1_R2_eq = "DMEM_RD";
    8'h40 : PG1_R2_eq = "A";
    8'h43 : PG1_R2_eq = "A";
    8'h50 : PG1_R2_eq = "B";
    8'h53 : PG1_R2_eq = "B";
    8'h60 : PG1_R2_eq = "DMEM_RD";
    8'h63 : PG1_R2_eq = "DMEM_RD";
    8'h6E : PG1_R2_eq = "EA";
    8'h70 : PG1_R2_eq = "DMEM_RD";
    8'h73 : PG1_R2_eq = "DMEM_RD";
    8'h7E : PG1_R2_eq = "IDATA";
    8'h80 : PG1_R2_eq = "IDATA";
    8'h81 : PG1_R2_eq = "IDATA";
    8'h82 : PG1_R2_eq = "IDATA";
    8'h83 : PG1_R2_eq = "IDATA";
    8'h84 : PG1_R2_eq = "IDATA";
    8'h85 : PG1_R2_eq = "IDATA";
    8'h86 : PG1_R2_eq = "IDATA";
    8'h88 : PG1_R2_eq = "IDATA";
    8'h89 : PG1_R2_eq = "IDATA";
    8'h8A : PG1_R2_eq = "IDATA";
    8'h8B : PG1_R2_eq = "IDATA";
    8'h8C : PG1_R2_eq = "IDATA";
    8'h8D : PG1_R2_eq = "EA";
    8'h8E : PG1_R2_eq = "IDATA";
    8'h90 : PG1_R2_eq = "DMEM_RD";
    8'h91 : PG1_R2_eq = "DMEM_RD";
    8'h92 : PG1_R2_eq = "DMEM_RD";
    8'h93 : PG1_R2_eq = "DMEM_RD";
    8'h94 : PG1_R2_eq = "DMEM_RD";
    8'h95 : PG1_R2_eq = "DMEM_RD";
    8'h96 : PG1_R2_eq = "DMEM_RD";
    8'h98 : PG1_R2_eq = "DMEM_RD";
    8'h99 : PG1_R2_eq = "DMEM_RD";
    8'h9A : PG1_R2_eq = "DMEM_RD";
    8'h9B : PG1_R2_eq = "DMEM_RD";
    8'h9C : PG1_R2_eq = "DMEM_RD";
    8'h9D : PG1_R2_eq = "IDATA";
    8'h9E : PG1_R2_eq = "DMEM_RD";
    8'hA0 : PG1_R2_eq = "DMEM_RD";
    8'hA1 : PG1_R2_eq = "DMEM_RD";
    8'hA2 : PG1_R2_eq = "DMEM_RD";
    8'hA3 : PG1_R2_eq = "DMEM_RD";
    8'hA4 : PG1_R2_eq = "DMEM_RD";
    8'hA5 : PG1_R2_eq = "DMEM_RD";
    8'hA6 : PG1_R2_eq = "DMEM_RD";
    8'hA8 : PG1_R2_eq = "DMEM_RD";
    8'hA9 : PG1_R2_eq = "DMEM_RD";
    8'hAA : PG1_R2_eq = "DMEM_RD";
    8'hAB : PG1_R2_eq = "DMEM_RD";
    8'hAC : PG1_R2_eq = "DMEM_RD";
    8'hAD : PG1_R2_eq = "EA";
    8'hAE : PG1_R2_eq = "DMEM_RD";
    8'hB0 : PG1_R2_eq = "DMEM_RD";
    8'hB1 : PG1_R2_eq = "DMEM_RD";
    8'hB2 : PG1_R2_eq = "DMEM_RD";
    8'hB3 : PG1_R2_eq = "DMEM_RD";
    8'hB4 : PG1_R2_eq = "DMEM_RD";
    8'hB5 : PG1_R2_eq = "DMEM_RD";
    8'hB6 : PG1_R2_eq = "DMEM_RD";
    8'hB8 : PG1_R2_eq = "DMEM_RD";
    8'hB9 : PG1_R2_eq = "DMEM_RD";
    8'hBA : PG1_R2_eq = "DMEM_RD";
    8'hBB : PG1_R2_eq = "DMEM_RD";
    8'hBC : PG1_R2_eq = "DMEM_RD";
    8'hBD : PG1_R2_eq = "IDATA";
    8'hBE : PG1_R2_eq = "DMEM_RD";
    8'hC0 : PG1_R2_eq = "IDATA";
    8'hC1 : PG1_R2_eq = "IDATA";
    8'hC2 : PG1_R2_eq = "IDATA";
    8'hC3 : PG1_R2_eq = "IDATA";
    8'hC4 : PG1_R2_eq = "IDATA";
    8'hC5 : PG1_R2_eq = "IDATA";
    8'hC6 : PG1_R2_eq = "IDATA";
    8'hC8 : PG1_R2_eq = "IDATA";
    8'hC9 : PG1_R2_eq = "IDATA";
    8'hCA : PG1_R2_eq = "IDATA";
    8'hCB : PG1_R2_eq = "IDATA";
    8'hCC : PG1_R2_eq = "IDATA";
    8'hCE : PG1_R2_eq = "IDATA";
    8'hD0 : PG1_R2_eq = "DMEM_RD";
    8'hD1 : PG1_R2_eq = "DMEM_RD";
    8'hD2 : PG1_R2_eq = "DMEM_RD";
    8'hD3 : PG1_R2_eq = "DMEM_RD";
    8'hD4 : PG1_R2_eq = "DMEM_RD";
    8'hD5 : PG1_R2_eq = "DMEM_RD";
    8'hD6 : PG1_R2_eq = "DMEM_RD";
    8'hD8 : PG1_R2_eq = "DMEM_RD";
    8'hD9 : PG1_R2_eq = "DMEM_RD";
    8'hDA : PG1_R2_eq = "DMEM_RD";
    8'hDB : PG1_R2_eq = "DMEM_RD";
    8'hDC : PG1_R2_eq = "DMEM_RD";
    8'hDE : PG1_R2_eq = "DMEM_RD";
    8'hE0 : PG1_R2_eq = "DMEM_RD";
    8'hE1 : PG1_R2_eq = "DMEM_RD";
    8'hE2 : PG1_R2_eq = "DMEM_RD";
    8'hE3 : PG1_R2_eq = "DMEM_RD";
    8'hE4 : PG1_R2_eq = "DMEM_RD";
    8'hE5 : PG1_R2_eq = "DMEM_RD";
    8'hE6 : PG1_R2_eq = "DMEM_RD";
    8'hE8 : PG1_R2_eq = "DMEM_RD";
    8'hE9 : PG1_R2_eq = "DMEM_RD";
    8'hEA : PG1_R2_eq = "DMEM_RD";
    8'hEB : PG1_R2_eq = "DMEM_RD";
    8'hEC : PG1_R2_eq = "DMEM_RD";
    8'hEE : PG1_R2_eq = "DMEM_RD";
    8'hF0 : PG1_R2_eq = "DMEM_RD";
    8'hF1 : PG1_R2_eq = "DMEM_RD";
    8'hF2 : PG1_R2_eq = "DMEM_RD";
    8'hF3 : PG1_R2_eq = "DMEM_RD";
    8'hF4 : PG1_R2_eq = "DMEM_RD";
    8'hF5 : PG1_R2_eq = "DMEM_RD";
    8'hF6 : PG1_R2_eq = "DMEM_RD";
    8'hF8 : PG1_R2_eq = "DMEM_RD";
    8'hF9 : PG1_R2_eq = "DMEM_RD";
    8'hFA : PG1_R2_eq = "DMEM_RD";
    8'hFB : PG1_R2_eq = "DMEM_RD";
    8'hFC : PG1_R2_eq = "DMEM_RD";
    8'hFE : PG1_R2_eq = "DMEM_RD";
    default : PG1_R2_eq = "invalid";
  endcase
end

`endif

/////////////////////////////////////////////////////////////////////////////

endmodule

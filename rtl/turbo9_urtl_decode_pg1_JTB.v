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
module turbo9_urtl_decode_pg1_JTB(
  input      [7:0] OPCODE_I,
  output reg [7:0] PG1_JTB_O
);

/////////////////////////////////////////////////////////////////////////////
//                                LOGIC
/////////////////////////////////////////////////////////////////////////////

always @* begin
  case (OPCODE_I)
    8'h00 : PG1_JTB_O = 8'h27; // NEG         NEG (dir idx ext)
    8'h03 : PG1_JTB_O = 8'h23; // COM         COM (dir idx ext)
    8'h04 : PG1_JTB_O = 8'h26; // LSR         LSR (dir idx ext)
    8'h06 : PG1_JTB_O = 8'h29; // ROR         ROR (dir idx ext)
    8'h07 : PG1_JTB_O = 8'h21; // ASR         ASR (dir idx ext)
    8'h08 : PG1_JTB_O = 8'h20; // ASL_LSL     ASL LSL (dir idx ext)
    8'h09 : PG1_JTB_O = 8'h28; // ROL         ROL (dir idx ext)
    8'h0A : PG1_JTB_O = 8'h24; // DEC         DEC (dir idx ext)
    8'h0C : PG1_JTB_O = 8'h25; // INC         INC (dir idx ext)
    8'h0D : PG1_JTB_O = 8'h2a; // TST         TST (dir idx ext)
    8'h16 : PG1_JTB_O = 8'h2d; // JMP         LBRA
    8'h17 : PG1_JTB_O = 8'h2e; // JSR         BSR LBSR // FIXME check if smaller area
    8'h20 : PG1_JTB_O = 8'h2d; // JMP         BRA BRN BHI BLS
    8'h21 : PG1_JTB_O = 8'h2d; // JMP         BRA BRN BHI BLS
    8'h22 : PG1_JTB_O = 8'h2d; // JMP         BRA BRN BHI BLS
    8'h23 : PG1_JTB_O = 8'h2d; // JMP         BRA BRN BHI BLS
    8'h24 : PG1_JTB_O = 8'h2d; // JMP         BCC BCS BNE BEQ
    8'h25 : PG1_JTB_O = 8'h2d; // JMP         BCC BCS BNE BEQ
    8'h26 : PG1_JTB_O = 8'h2d; // JMP         BCC BCS BNE BEQ
    8'h27 : PG1_JTB_O = 8'h2d; // JMP         BCC BCS BNE BEQ
    8'h28 : PG1_JTB_O = 8'h2d; // JMP         BVC BVS BPL BMI
    8'h29 : PG1_JTB_O = 8'h2d; // JMP         BVC BVS BPL BMI
    8'h2A : PG1_JTB_O = 8'h2d; // JMP         BVC BVS BPL BMI
    8'h2B : PG1_JTB_O = 8'h2d; // JMP         BVC BVS BPL BMI
    8'h2C : PG1_JTB_O = 8'h2d; // JMP         BGE BLT BGT BLE
    8'h2D : PG1_JTB_O = 8'h2d; // JMP         BGE BLT BGT BLE
    8'h2E : PG1_JTB_O = 8'h2d; // JMP         BGE BLT BGT BLE
    8'h2F : PG1_JTB_O = 8'h2d; // JMP         BGE BLT BGT BLE
    8'h30 : PG1_JTB_O = 8'hb; // LEA_XY      LEAX(inh)
    8'h31 : PG1_JTB_O = 8'hb; // LEA_XY      LEAY(inh)
    8'h32 : PG1_JTB_O = 8'ha; // LEA_SU      LEAS(inh)
    8'h33 : PG1_JTB_O = 8'ha; // LEA_SU      LEAU(inh)
    8'h60 : PG1_JTB_O = 8'h27; // NEG         NEG (dir idx ext)
    8'h63 : PG1_JTB_O = 8'h23; // COM         COM (dir idx ext)
    8'h64 : PG1_JTB_O = 8'h26; // LSR         LSR (dir idx ext)
    8'h66 : PG1_JTB_O = 8'h29; // ROR         ROR (dir idx ext)
    8'h67 : PG1_JTB_O = 8'h21; // ASR         ASR (dir idx ext)
    8'h68 : PG1_JTB_O = 8'h20; // ASL_LSL     ASL LSL (dir idx ext)
    8'h69 : PG1_JTB_O = 8'h28; // ROL         ROL (dir idx ext)
    8'h6A : PG1_JTB_O = 8'h24; // DEC         DEC (dir idx ext)
    8'h6C : PG1_JTB_O = 8'h25; // INC         INC (dir idx ext)
    8'h6D : PG1_JTB_O = 8'h2a; // TST         TST (dir idx ext)
    8'h6E : PG1_JTB_O = 8'h2d; // JMP         JMP (idx)
    8'h6F : PG1_JTB_O = 8'h22; // CLR         CLR (idx)
    8'h70 : PG1_JTB_O = 8'h27; // NEG         NEG (dir idx ext)
    8'h73 : PG1_JTB_O = 8'h23; // COM         COM (dir idx ext)
    8'h74 : PG1_JTB_O = 8'h26; // LSR         LSR (dir idx ext)
    8'h76 : PG1_JTB_O = 8'h29; // ROR         ROR (dir idx ext)
    8'h77 : PG1_JTB_O = 8'h21; // ASR         ASR (dir idx ext)
    8'h78 : PG1_JTB_O = 8'h20; // ASL_LSL     ASL LSL (dir idx ext)
    8'h79 : PG1_JTB_O = 8'h28; // ROL         ROL (dir idx ext)
    8'h7A : PG1_JTB_O = 8'h24; // DEC         DEC (dir idx ext)
    8'h7C : PG1_JTB_O = 8'h25; // INC         INC (dir idx ext)
    8'h7D : PG1_JTB_O = 8'h2a; // TST         TST (dir idx ext)
    8'h8D : PG1_JTB_O = 8'h2e; // JSR         BSR LBSR // FIXME check if smaller area
    8'h90 : PG1_JTB_O = 8'h1e; // SUB         SUBA (dir idx ext)
    8'h91 : PG1_JTB_O = 8'h18; // CMP         CMPA (dir idx ext)
    8'h92 : PG1_JTB_O = 8'h1d; // SBC         SBCA (dir idx ext)
    8'h93 : PG1_JTB_O = 8'h1e; // SUB         SUBD (dir idx ext)
    8'h94 : PG1_JTB_O = 8'h15; // AND         ANDA (dir idx ext)
    8'h95 : PG1_JTB_O = 8'h17; // BIT         BITA (dir idx ext)
    8'h96 : PG1_JTB_O = 8'h1a; // LD          LDA (dir idx ext)
    8'h98 : PG1_JTB_O = 8'h19; // EOR         EORA (dir idx ext)
    8'h99 : PG1_JTB_O = 8'h13; // ADC         ADCA (dir idx ext)
    8'h9A : PG1_JTB_O = 8'h1b; // OR          ORA (dir idx ext)
    8'h9B : PG1_JTB_O = 8'h14; // ADD         ADDA (dir idx ext)
    8'h9C : PG1_JTB_O = 8'h18; // CMP         CMPX (dir idx ext)
    8'h9E : PG1_JTB_O = 8'h1a; // LD          LDX (dir idx ext)
    8'hA0 : PG1_JTB_O = 8'h1e; // SUB         SUBA (dir idx ext)
    8'hA1 : PG1_JTB_O = 8'h18; // CMP         CMPA (dir idx ext)
    8'hA2 : PG1_JTB_O = 8'h1d; // SBC         SBCA (dir idx ext)
    8'hA3 : PG1_JTB_O = 8'h1e; // SUB         SUBD (dir idx ext)
    8'hA4 : PG1_JTB_O = 8'h15; // AND         ANDA (dir idx ext)
    8'hA5 : PG1_JTB_O = 8'h17; // BIT         BITA (dir idx ext)
    8'hA6 : PG1_JTB_O = 8'h1a; // LD          LDA (dir idx ext)
    8'hA7 : PG1_JTB_O = 8'h1f; // ST          STA (idx)
    8'hA8 : PG1_JTB_O = 8'h19; // EOR         EORA (dir idx ext)
    8'hA9 : PG1_JTB_O = 8'h13; // ADC         ADCA (dir idx ext)
    8'hAA : PG1_JTB_O = 8'h1b; // OR          ORA (dir idx ext)
    8'hAB : PG1_JTB_O = 8'h14; // ADD         ADDA (dir idx ext)
    8'hAC : PG1_JTB_O = 8'h18; // CMP         CMPX (dir idx ext)
    8'hAD : PG1_JTB_O = 8'h2e; // JSR         JSR (idx)
    8'hAE : PG1_JTB_O = 8'h1a; // LD          LDX (dir idx ext)
    8'hAF : PG1_JTB_O = 8'h1f; // ST          STX (idx)
    8'hB0 : PG1_JTB_O = 8'h1e; // SUB         SUBA (dir idx ext)
    8'hB1 : PG1_JTB_O = 8'h18; // CMP         CMPA (dir idx ext)
    8'hB2 : PG1_JTB_O = 8'h1d; // SBC         SBCA (dir idx ext)
    8'hB3 : PG1_JTB_O = 8'h1e; // SUB         SUBD (dir idx ext)
    8'hB4 : PG1_JTB_O = 8'h15; // AND         ANDA (dir idx ext)
    8'hB5 : PG1_JTB_O = 8'h17; // BIT         BITA (dir idx ext)
    8'hB6 : PG1_JTB_O = 8'h1a; // LD          LDA (dir idx ext)
    8'hB8 : PG1_JTB_O = 8'h19; // EOR         EORA (dir idx ext)
    8'hB9 : PG1_JTB_O = 8'h13; // ADC         ADCA (dir idx ext)
    8'hBA : PG1_JTB_O = 8'h1b; // OR          ORA (dir idx ext)
    8'hBB : PG1_JTB_O = 8'h14; // ADD         ADDA (dir idx ext)
    8'hBC : PG1_JTB_O = 8'h18; // CMP         CMPX (dir idx ext)
    8'hBE : PG1_JTB_O = 8'h1a; // LD          LDX (dir idx ext)
    8'hD0 : PG1_JTB_O = 8'h1e; // SUB         SUBB (dir idx ext)
    8'hD1 : PG1_JTB_O = 8'h18; // CMP         CMPB (dir idx ext)
    8'hD2 : PG1_JTB_O = 8'h1d; // SBC         SBCB (dir idx ext)
    8'hD3 : PG1_JTB_O = 8'h14; // ADD         ADDD (dir idx ext)
    8'hD4 : PG1_JTB_O = 8'h15; // AND         ANDB (dir idx ext)
    8'hD5 : PG1_JTB_O = 8'h17; // BIT         BITB (dir idx ext)
    8'hD6 : PG1_JTB_O = 8'h1a; // LD          LDB (dir idx ext)
    8'hD8 : PG1_JTB_O = 8'h19; // EOR         EORB (dir idx ext)
    8'hD9 : PG1_JTB_O = 8'h13; // ADC         ADCB (dir idx ext)
    8'hDA : PG1_JTB_O = 8'h1b; // OR          ORB (dir idx ext)
    8'hDB : PG1_JTB_O = 8'h14; // ADD         ADDB (dir idx ext)
    8'hDC : PG1_JTB_O = 8'h1a; // LD          LDD (dir idx ext)
    8'hDE : PG1_JTB_O = 8'h1a; // LD          LDU (dir idx ext)
    8'hE0 : PG1_JTB_O = 8'h1e; // SUB         SUBB (dir idx ext)
    8'hE1 : PG1_JTB_O = 8'h18; // CMP         CMPB (dir idx ext)
    8'hE2 : PG1_JTB_O = 8'h1d; // SBC         SBCB (dir idx ext)
    8'hE3 : PG1_JTB_O = 8'h14; // ADD         ADDD (dir idx ext)
    8'hE4 : PG1_JTB_O = 8'h15; // AND         ANDB (dir idx ext)
    8'hE5 : PG1_JTB_O = 8'h17; // BIT         BITB (dir idx ext)
    8'hE6 : PG1_JTB_O = 8'h1a; // LD          LDB (dir idx ext)
    8'hE7 : PG1_JTB_O = 8'h1f; // ST          STB (idx)
    8'hE8 : PG1_JTB_O = 8'h19; // EOR         EORB (dir idx ext)
    8'hE9 : PG1_JTB_O = 8'h13; // ADC         ADCB (dir idx ext)
    8'hEA : PG1_JTB_O = 8'h1b; // OR          ORB (dir idx ext)
    8'hEB : PG1_JTB_O = 8'h14; // ADD         ADDB (dir idx ext)
    8'hEC : PG1_JTB_O = 8'h1a; // LD          LDD (dir idx ext)
    8'hED : PG1_JTB_O = 8'h1f; // ST          STD (idx)
    8'hEE : PG1_JTB_O = 8'h1a; // LD          LDU (dir idx ext)
    8'hEF : PG1_JTB_O = 8'h1f; // ST          STU (idx)
    8'hF0 : PG1_JTB_O = 8'h1e; // SUB         SUBB (dir idx ext)
    8'hF1 : PG1_JTB_O = 8'h18; // CMP         CMPB (dir idx ext)
    8'hF2 : PG1_JTB_O = 8'h1d; // SBC         SBCB (dir idx ext)
    8'hF3 : PG1_JTB_O = 8'h14; // ADD         ADDD (dir idx ext)
    8'hF4 : PG1_JTB_O = 8'h15; // AND         ANDB (dir idx ext)
    8'hF5 : PG1_JTB_O = 8'h17; // BIT         BITB (dir idx ext)
    8'hF6 : PG1_JTB_O = 8'h1a; // LD          LDB (dir idx ext)
    8'hF8 : PG1_JTB_O = 8'h19; // EOR         EORB (dir idx ext)
    8'hF9 : PG1_JTB_O = 8'h13; // ADC         ADCB (dir idx ext)
    8'hFA : PG1_JTB_O = 8'h1b; // OR          ORB (dir idx ext)
    8'hFB : PG1_JTB_O = 8'h14; // ADD         ADDB (dir idx ext)
    8'hFC : PG1_JTB_O = 8'h1a; // LD          LDD (dir idx ext)
    8'hFE : PG1_JTB_O = 8'h1a; // LD          LDU (dir idx ext)
    default : PG1_JTB_O = 8'hFF; // from decode_init
  endcase
end

`ifdef SIM_TURBO9

reg [(8*64):0] PG1_JTB_op;

always @* begin
  case (OPCODE_I)
    8'h00 : PG1_JTB_op = "NEG (dir idx ext)";
    8'h03 : PG1_JTB_op = "COM (dir idx ext)";
    8'h04 : PG1_JTB_op = "LSR (dir idx ext)";
    8'h06 : PG1_JTB_op = "ROR (dir idx ext)";
    8'h07 : PG1_JTB_op = "ASR (dir idx ext)";
    8'h08 : PG1_JTB_op = "ASL LSL (dir idx ext)";
    8'h09 : PG1_JTB_op = "ROL (dir idx ext)";
    8'h0A : PG1_JTB_op = "DEC (dir idx ext)";
    8'h0C : PG1_JTB_op = "INC (dir idx ext)";
    8'h0D : PG1_JTB_op = "TST (dir idx ext)";
    8'h16 : PG1_JTB_op = "LBRA";
    8'h17 : PG1_JTB_op = "BSR LBSR // FIXME check if smaller area";
    8'h20 : PG1_JTB_op = "BRA BRN BHI BLS";
    8'h21 : PG1_JTB_op = "BRA BRN BHI BLS";
    8'h22 : PG1_JTB_op = "BRA BRN BHI BLS";
    8'h23 : PG1_JTB_op = "BRA BRN BHI BLS";
    8'h24 : PG1_JTB_op = "BCC BCS BNE BEQ";
    8'h25 : PG1_JTB_op = "BCC BCS BNE BEQ";
    8'h26 : PG1_JTB_op = "BCC BCS BNE BEQ";
    8'h27 : PG1_JTB_op = "BCC BCS BNE BEQ";
    8'h28 : PG1_JTB_op = "BVC BVS BPL BMI";
    8'h29 : PG1_JTB_op = "BVC BVS BPL BMI";
    8'h2A : PG1_JTB_op = "BVC BVS BPL BMI";
    8'h2B : PG1_JTB_op = "BVC BVS BPL BMI";
    8'h2C : PG1_JTB_op = "BGE BLT BGT BLE";
    8'h2D : PG1_JTB_op = "BGE BLT BGT BLE";
    8'h2E : PG1_JTB_op = "BGE BLT BGT BLE";
    8'h2F : PG1_JTB_op = "BGE BLT BGT BLE";
    8'h30 : PG1_JTB_op = "LEAX(inh)";
    8'h31 : PG1_JTB_op = "LEAY(inh)";
    8'h32 : PG1_JTB_op = "LEAS(inh)";
    8'h33 : PG1_JTB_op = "LEAU(inh)";
    8'h60 : PG1_JTB_op = "NEG (dir idx ext)";
    8'h63 : PG1_JTB_op = "COM (dir idx ext)";
    8'h64 : PG1_JTB_op = "LSR (dir idx ext)";
    8'h66 : PG1_JTB_op = "ROR (dir idx ext)";
    8'h67 : PG1_JTB_op = "ASR (dir idx ext)";
    8'h68 : PG1_JTB_op = "ASL LSL (dir idx ext)";
    8'h69 : PG1_JTB_op = "ROL (dir idx ext)";
    8'h6A : PG1_JTB_op = "DEC (dir idx ext)";
    8'h6C : PG1_JTB_op = "INC (dir idx ext)";
    8'h6D : PG1_JTB_op = "TST (dir idx ext)";
    8'h6E : PG1_JTB_op = "JMP (idx)";
    8'h6F : PG1_JTB_op = "CLR (idx)";
    8'h70 : PG1_JTB_op = "NEG (dir idx ext)";
    8'h73 : PG1_JTB_op = "COM (dir idx ext)";
    8'h74 : PG1_JTB_op = "LSR (dir idx ext)";
    8'h76 : PG1_JTB_op = "ROR (dir idx ext)";
    8'h77 : PG1_JTB_op = "ASR (dir idx ext)";
    8'h78 : PG1_JTB_op = "ASL LSL (dir idx ext)";
    8'h79 : PG1_JTB_op = "ROL (dir idx ext)";
    8'h7A : PG1_JTB_op = "DEC (dir idx ext)";
    8'h7C : PG1_JTB_op = "INC (dir idx ext)";
    8'h7D : PG1_JTB_op = "TST (dir idx ext)";
    8'h8D : PG1_JTB_op = "BSR LBSR // FIXME check if smaller area";
    8'h90 : PG1_JTB_op = "SUBA (dir idx ext)";
    8'h91 : PG1_JTB_op = "CMPA (dir idx ext)";
    8'h92 : PG1_JTB_op = "SBCA (dir idx ext)";
    8'h93 : PG1_JTB_op = "SUBD (dir idx ext)";
    8'h94 : PG1_JTB_op = "ANDA (dir idx ext)";
    8'h95 : PG1_JTB_op = "BITA (dir idx ext)";
    8'h96 : PG1_JTB_op = "LDA (dir idx ext)";
    8'h98 : PG1_JTB_op = "EORA (dir idx ext)";
    8'h99 : PG1_JTB_op = "ADCA (dir idx ext)";
    8'h9A : PG1_JTB_op = "ORA (dir idx ext)";
    8'h9B : PG1_JTB_op = "ADDA (dir idx ext)";
    8'h9C : PG1_JTB_op = "CMPX (dir idx ext)";
    8'h9E : PG1_JTB_op = "LDX (dir idx ext)";
    8'hA0 : PG1_JTB_op = "SUBA (dir idx ext)";
    8'hA1 : PG1_JTB_op = "CMPA (dir idx ext)";
    8'hA2 : PG1_JTB_op = "SBCA (dir idx ext)";
    8'hA3 : PG1_JTB_op = "SUBD (dir idx ext)";
    8'hA4 : PG1_JTB_op = "ANDA (dir idx ext)";
    8'hA5 : PG1_JTB_op = "BITA (dir idx ext)";
    8'hA6 : PG1_JTB_op = "LDA (dir idx ext)";
    8'hA7 : PG1_JTB_op = "STA (idx)";
    8'hA8 : PG1_JTB_op = "EORA (dir idx ext)";
    8'hA9 : PG1_JTB_op = "ADCA (dir idx ext)";
    8'hAA : PG1_JTB_op = "ORA (dir idx ext)";
    8'hAB : PG1_JTB_op = "ADDA (dir idx ext)";
    8'hAC : PG1_JTB_op = "CMPX (dir idx ext)";
    8'hAD : PG1_JTB_op = "JSR (idx)";
    8'hAE : PG1_JTB_op = "LDX (dir idx ext)";
    8'hAF : PG1_JTB_op = "STX (idx)";
    8'hB0 : PG1_JTB_op = "SUBA (dir idx ext)";
    8'hB1 : PG1_JTB_op = "CMPA (dir idx ext)";
    8'hB2 : PG1_JTB_op = "SBCA (dir idx ext)";
    8'hB3 : PG1_JTB_op = "SUBD (dir idx ext)";
    8'hB4 : PG1_JTB_op = "ANDA (dir idx ext)";
    8'hB5 : PG1_JTB_op = "BITA (dir idx ext)";
    8'hB6 : PG1_JTB_op = "LDA (dir idx ext)";
    8'hB8 : PG1_JTB_op = "EORA (dir idx ext)";
    8'hB9 : PG1_JTB_op = "ADCA (dir idx ext)";
    8'hBA : PG1_JTB_op = "ORA (dir idx ext)";
    8'hBB : PG1_JTB_op = "ADDA (dir idx ext)";
    8'hBC : PG1_JTB_op = "CMPX (dir idx ext)";
    8'hBE : PG1_JTB_op = "LDX (dir idx ext)";
    8'hD0 : PG1_JTB_op = "SUBB (dir idx ext)";
    8'hD1 : PG1_JTB_op = "CMPB (dir idx ext)";
    8'hD2 : PG1_JTB_op = "SBCB (dir idx ext)";
    8'hD3 : PG1_JTB_op = "ADDD (dir idx ext)";
    8'hD4 : PG1_JTB_op = "ANDB (dir idx ext)";
    8'hD5 : PG1_JTB_op = "BITB (dir idx ext)";
    8'hD6 : PG1_JTB_op = "LDB (dir idx ext)";
    8'hD8 : PG1_JTB_op = "EORB (dir idx ext)";
    8'hD9 : PG1_JTB_op = "ADCB (dir idx ext)";
    8'hDA : PG1_JTB_op = "ORB (dir idx ext)";
    8'hDB : PG1_JTB_op = "ADDB (dir idx ext)";
    8'hDC : PG1_JTB_op = "LDD (dir idx ext)";
    8'hDE : PG1_JTB_op = "LDU (dir idx ext)";
    8'hE0 : PG1_JTB_op = "SUBB (dir idx ext)";
    8'hE1 : PG1_JTB_op = "CMPB (dir idx ext)";
    8'hE2 : PG1_JTB_op = "SBCB (dir idx ext)";
    8'hE3 : PG1_JTB_op = "ADDD (dir idx ext)";
    8'hE4 : PG1_JTB_op = "ANDB (dir idx ext)";
    8'hE5 : PG1_JTB_op = "BITB (dir idx ext)";
    8'hE6 : PG1_JTB_op = "LDB (dir idx ext)";
    8'hE7 : PG1_JTB_op = "STB (idx)";
    8'hE8 : PG1_JTB_op = "EORB (dir idx ext)";
    8'hE9 : PG1_JTB_op = "ADCB (dir idx ext)";
    8'hEA : PG1_JTB_op = "ORB (dir idx ext)";
    8'hEB : PG1_JTB_op = "ADDB (dir idx ext)";
    8'hEC : PG1_JTB_op = "LDD (dir idx ext)";
    8'hED : PG1_JTB_op = "STD (idx)";
    8'hEE : PG1_JTB_op = "LDU (dir idx ext)";
    8'hEF : PG1_JTB_op = "STU (idx)";
    8'hF0 : PG1_JTB_op = "SUBB (dir idx ext)";
    8'hF1 : PG1_JTB_op = "CMPB (dir idx ext)";
    8'hF2 : PG1_JTB_op = "SBCB (dir idx ext)";
    8'hF3 : PG1_JTB_op = "ADDD (dir idx ext)";
    8'hF4 : PG1_JTB_op = "ANDB (dir idx ext)";
    8'hF5 : PG1_JTB_op = "BITB (dir idx ext)";
    8'hF6 : PG1_JTB_op = "LDB (dir idx ext)";
    8'hF8 : PG1_JTB_op = "EORB (dir idx ext)";
    8'hF9 : PG1_JTB_op = "ADCB (dir idx ext)";
    8'hFA : PG1_JTB_op = "ORB (dir idx ext)";
    8'hFB : PG1_JTB_op = "ADDB (dir idx ext)";
    8'hFC : PG1_JTB_op = "LDD (dir idx ext)";
    8'hFE : PG1_JTB_op = "LDU (dir idx ext)";
    default : PG1_JTB_op = "invalid";
  endcase
end

reg [(8*64):0] PG1_JTB_eq;

always @* begin
  case (OPCODE_I)
    8'h00 : PG1_JTB_eq = "NEG";
    8'h03 : PG1_JTB_eq = "COM";
    8'h04 : PG1_JTB_eq = "LSR";
    8'h06 : PG1_JTB_eq = "ROR";
    8'h07 : PG1_JTB_eq = "ASR";
    8'h08 : PG1_JTB_eq = "ASL_LSL";
    8'h09 : PG1_JTB_eq = "ROL";
    8'h0A : PG1_JTB_eq = "DEC";
    8'h0C : PG1_JTB_eq = "INC";
    8'h0D : PG1_JTB_eq = "TST";
    8'h16 : PG1_JTB_eq = "JMP";
    8'h17 : PG1_JTB_eq = "JSR";
    8'h20 : PG1_JTB_eq = "JMP";
    8'h21 : PG1_JTB_eq = "JMP";
    8'h22 : PG1_JTB_eq = "JMP";
    8'h23 : PG1_JTB_eq = "JMP";
    8'h24 : PG1_JTB_eq = "JMP";
    8'h25 : PG1_JTB_eq = "JMP";
    8'h26 : PG1_JTB_eq = "JMP";
    8'h27 : PG1_JTB_eq = "JMP";
    8'h28 : PG1_JTB_eq = "JMP";
    8'h29 : PG1_JTB_eq = "JMP";
    8'h2A : PG1_JTB_eq = "JMP";
    8'h2B : PG1_JTB_eq = "JMP";
    8'h2C : PG1_JTB_eq = "JMP";
    8'h2D : PG1_JTB_eq = "JMP";
    8'h2E : PG1_JTB_eq = "JMP";
    8'h2F : PG1_JTB_eq = "JMP";
    8'h30 : PG1_JTB_eq = "LEA_XY";
    8'h31 : PG1_JTB_eq = "LEA_XY";
    8'h32 : PG1_JTB_eq = "LEA_SU";
    8'h33 : PG1_JTB_eq = "LEA_SU";
    8'h60 : PG1_JTB_eq = "NEG";
    8'h63 : PG1_JTB_eq = "COM";
    8'h64 : PG1_JTB_eq = "LSR";
    8'h66 : PG1_JTB_eq = "ROR";
    8'h67 : PG1_JTB_eq = "ASR";
    8'h68 : PG1_JTB_eq = "ASL_LSL";
    8'h69 : PG1_JTB_eq = "ROL";
    8'h6A : PG1_JTB_eq = "DEC";
    8'h6C : PG1_JTB_eq = "INC";
    8'h6D : PG1_JTB_eq = "TST";
    8'h6E : PG1_JTB_eq = "JMP";
    8'h6F : PG1_JTB_eq = "CLR";
    8'h70 : PG1_JTB_eq = "NEG";
    8'h73 : PG1_JTB_eq = "COM";
    8'h74 : PG1_JTB_eq = "LSR";
    8'h76 : PG1_JTB_eq = "ROR";
    8'h77 : PG1_JTB_eq = "ASR";
    8'h78 : PG1_JTB_eq = "ASL_LSL";
    8'h79 : PG1_JTB_eq = "ROL";
    8'h7A : PG1_JTB_eq = "DEC";
    8'h7C : PG1_JTB_eq = "INC";
    8'h7D : PG1_JTB_eq = "TST";
    8'h8D : PG1_JTB_eq = "JSR";
    8'h90 : PG1_JTB_eq = "SUB";
    8'h91 : PG1_JTB_eq = "CMP";
    8'h92 : PG1_JTB_eq = "SBC";
    8'h93 : PG1_JTB_eq = "SUB";
    8'h94 : PG1_JTB_eq = "AND";
    8'h95 : PG1_JTB_eq = "BIT";
    8'h96 : PG1_JTB_eq = "LD";
    8'h98 : PG1_JTB_eq = "EOR";
    8'h99 : PG1_JTB_eq = "ADC";
    8'h9A : PG1_JTB_eq = "OR";
    8'h9B : PG1_JTB_eq = "ADD";
    8'h9C : PG1_JTB_eq = "CMP";
    8'h9E : PG1_JTB_eq = "LD";
    8'hA0 : PG1_JTB_eq = "SUB";
    8'hA1 : PG1_JTB_eq = "CMP";
    8'hA2 : PG1_JTB_eq = "SBC";
    8'hA3 : PG1_JTB_eq = "SUB";
    8'hA4 : PG1_JTB_eq = "AND";
    8'hA5 : PG1_JTB_eq = "BIT";
    8'hA6 : PG1_JTB_eq = "LD";
    8'hA7 : PG1_JTB_eq = "ST";
    8'hA8 : PG1_JTB_eq = "EOR";
    8'hA9 : PG1_JTB_eq = "ADC";
    8'hAA : PG1_JTB_eq = "OR";
    8'hAB : PG1_JTB_eq = "ADD";
    8'hAC : PG1_JTB_eq = "CMP";
    8'hAD : PG1_JTB_eq = "JSR";
    8'hAE : PG1_JTB_eq = "LD";
    8'hAF : PG1_JTB_eq = "ST";
    8'hB0 : PG1_JTB_eq = "SUB";
    8'hB1 : PG1_JTB_eq = "CMP";
    8'hB2 : PG1_JTB_eq = "SBC";
    8'hB3 : PG1_JTB_eq = "SUB";
    8'hB4 : PG1_JTB_eq = "AND";
    8'hB5 : PG1_JTB_eq = "BIT";
    8'hB6 : PG1_JTB_eq = "LD";
    8'hB8 : PG1_JTB_eq = "EOR";
    8'hB9 : PG1_JTB_eq = "ADC";
    8'hBA : PG1_JTB_eq = "OR";
    8'hBB : PG1_JTB_eq = "ADD";
    8'hBC : PG1_JTB_eq = "CMP";
    8'hBE : PG1_JTB_eq = "LD";
    8'hD0 : PG1_JTB_eq = "SUB";
    8'hD1 : PG1_JTB_eq = "CMP";
    8'hD2 : PG1_JTB_eq = "SBC";
    8'hD3 : PG1_JTB_eq = "ADD";
    8'hD4 : PG1_JTB_eq = "AND";
    8'hD5 : PG1_JTB_eq = "BIT";
    8'hD6 : PG1_JTB_eq = "LD";
    8'hD8 : PG1_JTB_eq = "EOR";
    8'hD9 : PG1_JTB_eq = "ADC";
    8'hDA : PG1_JTB_eq = "OR";
    8'hDB : PG1_JTB_eq = "ADD";
    8'hDC : PG1_JTB_eq = "LD";
    8'hDE : PG1_JTB_eq = "LD";
    8'hE0 : PG1_JTB_eq = "SUB";
    8'hE1 : PG1_JTB_eq = "CMP";
    8'hE2 : PG1_JTB_eq = "SBC";
    8'hE3 : PG1_JTB_eq = "ADD";
    8'hE4 : PG1_JTB_eq = "AND";
    8'hE5 : PG1_JTB_eq = "BIT";
    8'hE6 : PG1_JTB_eq = "LD";
    8'hE7 : PG1_JTB_eq = "ST";
    8'hE8 : PG1_JTB_eq = "EOR";
    8'hE9 : PG1_JTB_eq = "ADC";
    8'hEA : PG1_JTB_eq = "OR";
    8'hEB : PG1_JTB_eq = "ADD";
    8'hEC : PG1_JTB_eq = "LD";
    8'hED : PG1_JTB_eq = "ST";
    8'hEE : PG1_JTB_eq = "LD";
    8'hEF : PG1_JTB_eq = "ST";
    8'hF0 : PG1_JTB_eq = "SUB";
    8'hF1 : PG1_JTB_eq = "CMP";
    8'hF2 : PG1_JTB_eq = "SBC";
    8'hF3 : PG1_JTB_eq = "ADD";
    8'hF4 : PG1_JTB_eq = "AND";
    8'hF5 : PG1_JTB_eq = "BIT";
    8'hF6 : PG1_JTB_eq = "LD";
    8'hF8 : PG1_JTB_eq = "EOR";
    8'hF9 : PG1_JTB_eq = "ADC";
    8'hFA : PG1_JTB_eq = "OR";
    8'hFB : PG1_JTB_eq = "ADD";
    8'hFC : PG1_JTB_eq = "LD";
    8'hFE : PG1_JTB_eq = "LD";
    default : PG1_JTB_eq = "invalid";
  endcase
end

`endif

/////////////////////////////////////////////////////////////////////////////

endmodule

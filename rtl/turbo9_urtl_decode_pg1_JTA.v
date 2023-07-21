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
module turbo9_urtl_decode_pg1_JTA(
  input      [7:0] OPCODE_I,
  output reg [7:0] PG1_JTA_O
);

/////////////////////////////////////////////////////////////////////////////
//                                LOGIC
/////////////////////////////////////////////////////////////////////////////

always @* begin
  case (OPCODE_I)
    8'h00 : PG1_JTA_O = 8'h1; // LD_DIR_EXT  NEG (dir ext)
    8'h03 : PG1_JTA_O = 8'h1; // LD_DIR_EXT  COM (dir ext)
    8'h04 : PG1_JTA_O = 8'h1; // LD_DIR_EXT  LSR (dir ext)
    8'h06 : PG1_JTA_O = 8'h1; // LD_DIR_EXT  ROR (dir ext)
    8'h07 : PG1_JTA_O = 8'h1; // LD_DIR_EXT  ASR (dir ext)
    8'h08 : PG1_JTA_O = 8'h1; // LD_DIR_EXT  ASL LSL (dir ext)
    8'h09 : PG1_JTA_O = 8'h1; // LD_DIR_EXT  ROL (dir ext)
    8'h0A : PG1_JTA_O = 8'h1; // LD_DIR_EXT  DEC (dir ext)
    8'h0C : PG1_JTA_O = 8'h1; // LD_DIR_EXT  INC (dir ext)
    8'h0D : PG1_JTA_O = 8'h1; // LD_DIR_EXT  TST (dir ext)
    8'h0E : PG1_JTA_O = 8'h2d; // JMP         JMP (dir ext)
    8'h0F : PG1_JTA_O = 8'h22; // CLR         CLR (dir ext)
    8'h10 : PG1_JTA_O = 8'hc; // NOP         page2 (prebyte)
    8'h11 : PG1_JTA_O = 8'hc; // NOP         page3 (prebyte)
    8'h12 : PG1_JTA_O = 8'hc; // NOP         NOP(inh)
    8'h14 : PG1_JTA_O = 8'hd; // SAU16       EMUL (inh)
    8'h16 : PG1_JTA_O = 8'h2b; // BRANCH      LBRA On page 1!
    8'h17 : PG1_JTA_O = 8'h2b; // BRANCH      BSR LBSR // FIXME could do this without JUMP_TABLE_A
    8'h18 : PG1_JTA_O = 8'hd; // SAU16       IDIV (inh)
    8'h19 : PG1_JTA_O = 8'hf; // SAU8        DAA (inh)
    8'h1A : PG1_JTA_O = 8'h1c; // ORCC        ORCC (imm)
    8'h1C : PG1_JTA_O = 8'h16; // ANDCC       ANDCC (imm)
    8'h1D : PG1_JTA_O = 8'h11; // SEX         SEX(inh)
    8'h1E : PG1_JTA_O = 8'h7; // EXG         EXG(inh)
    8'h1F : PG1_JTA_O = 8'h12; // TFR         TFR(inh)
    8'h20 : PG1_JTA_O = 8'h2b; // BRANCH      BRA BRN BHI BLS
    8'h21 : PG1_JTA_O = 8'h2b; // BRANCH      BRA BRN BHI BLS
    8'h22 : PG1_JTA_O = 8'h2b; // BRANCH      BRA BRN BHI BLS
    8'h23 : PG1_JTA_O = 8'h2b; // BRANCH      BRA BRN BHI BLS
    8'h24 : PG1_JTA_O = 8'h2b; // BRANCH      BCC BCS BNE BEQ
    8'h25 : PG1_JTA_O = 8'h2b; // BRANCH      BCC BCS BNE BEQ
    8'h26 : PG1_JTA_O = 8'h2b; // BRANCH      BCC BCS BNE BEQ
    8'h27 : PG1_JTA_O = 8'h2b; // BRANCH      BCC BCS BNE BEQ
    8'h28 : PG1_JTA_O = 8'h2b; // BRANCH      BVC BVS BPL BMI
    8'h29 : PG1_JTA_O = 8'h2b; // BRANCH      BVC BVS BPL BMI
    8'h2A : PG1_JTA_O = 8'h2b; // BRANCH      BVC BVS BPL BMI
    8'h2B : PG1_JTA_O = 8'h2b; // BRANCH      BVC BVS BPL BMI
    8'h2C : PG1_JTA_O = 8'h2b; // BRANCH      BGE BLT BGT BLE
    8'h2D : PG1_JTA_O = 8'h2b; // BRANCH      BGE BLT BGT BLE
    8'h2E : PG1_JTA_O = 8'h2b; // BRANCH      BGE BLT BGT BLE
    8'h2F : PG1_JTA_O = 8'h2b; // BRANCH      BGE BLT BGT BLE
    8'h30 : PG1_JTA_O = 8'h4; // ST_INDEXED  LEAX(inh)
    8'h31 : PG1_JTA_O = 8'h4; // ST_INDEXED  LEAY(inh)
    8'h32 : PG1_JTA_O = 8'h4; // ST_INDEXED  LEAS(inh)
    8'h33 : PG1_JTA_O = 8'h4; // ST_INDEXED  LEAU(inh)
    8'h34 : PG1_JTA_O = 8'h39; // PSH         PSHS
    8'h35 : PG1_JTA_O = 8'h35; // PUL         PULS
    8'h36 : PG1_JTA_O = 8'h39; // PSH         PSHU
    8'h37 : PG1_JTA_O = 8'h35; // PUL         PULU
    8'h39 : PG1_JTA_O = 8'h2f; // RTS         RTS
    8'h3A : PG1_JTA_O = 8'h6; // ABX         ABX(inh)
    8'h3B : PG1_JTA_O = 8'h30; // RTI         RTI
    8'h3D : PG1_JTA_O = 8'hf; // SAU8        MUL (inh)
    8'h3F : PG1_JTA_O = 8'h3c; // SWI         SWI
    8'h40 : PG1_JTA_O = 8'h27; // NEG         NEGA (inh)
    8'h43 : PG1_JTA_O = 8'h23; // COM         COMA (inh)
    8'h44 : PG1_JTA_O = 8'h26; // LSR         LSRA (inh)
    8'h46 : PG1_JTA_O = 8'h29; // ROR         RORA (inh)
    8'h47 : PG1_JTA_O = 8'h21; // ASR         ASRA (inh)
    8'h48 : PG1_JTA_O = 8'h20; // ASL_LSL     ASLA LSLA (inh)
    8'h49 : PG1_JTA_O = 8'h28; // ROL         ROLA (inh)
    8'h4A : PG1_JTA_O = 8'h24; // DEC         DECA (inh)
    8'h4C : PG1_JTA_O = 8'h25; // INC         INCA (inh)
    8'h4D : PG1_JTA_O = 8'h2a; // TST         TSTA (inh)
    8'h4F : PG1_JTA_O = 8'h22; // CLR         CLRA (inh)
    8'h50 : PG1_JTA_O = 8'h27; // NEG         NEGB (inh)
    8'h53 : PG1_JTA_O = 8'h23; // COM         COMB (inh)
    8'h54 : PG1_JTA_O = 8'h26; // LSR         LSRB (inh)
    8'h56 : PG1_JTA_O = 8'h29; // ROR         RORB (inh)
    8'h57 : PG1_JTA_O = 8'h21; // ASR         ASRB (inh)
    8'h58 : PG1_JTA_O = 8'h20; // ASL_LSL     ASLB LSLB (inh)
    8'h59 : PG1_JTA_O = 8'h28; // ROL         ROLB (inh)
    8'h5A : PG1_JTA_O = 8'h24; // DEC         DECB (inh)
    8'h5C : PG1_JTA_O = 8'h25; // INC         INCB (inh)
    8'h5D : PG1_JTA_O = 8'h2a; // TST         TSTB (inh)
    8'h5F : PG1_JTA_O = 8'h22; // CLR         CLRB (inh)
    8'h60 : PG1_JTA_O = 8'h2; // LD_INDEXED  NEG (idx)
    8'h63 : PG1_JTA_O = 8'h2; // LD_INDEXED  COM (idx)
    8'h64 : PG1_JTA_O = 8'h2; // LD_INDEXED  LSR (idx)
    8'h66 : PG1_JTA_O = 8'h2; // LD_INDEXED  ROR (idx)
    8'h67 : PG1_JTA_O = 8'h2; // LD_INDEXED  ASR (idx)
    8'h68 : PG1_JTA_O = 8'h2; // LD_INDEXED  ASL LSL (idx)
    8'h69 : PG1_JTA_O = 8'h2; // LD_INDEXED  ROL (idx)
    8'h6A : PG1_JTA_O = 8'h2; // LD_INDEXED  DEC (idx)
    8'h6C : PG1_JTA_O = 8'h2; // LD_INDEXED  INC (idx)
    8'h6D : PG1_JTA_O = 8'h2; // LD_INDEXED  TST (idx)
    8'h6E : PG1_JTA_O = 8'h4; // ST_INDEXED  JMP(idx)
    8'h6F : PG1_JTA_O = 8'h4; // ST_INDEXED  CLR(idx)
    8'h70 : PG1_JTA_O = 8'h1; // LD_DIR_EXT  NEG (dir ext)
    8'h73 : PG1_JTA_O = 8'h1; // LD_DIR_EXT  COM (dir ext)
    8'h74 : PG1_JTA_O = 8'h1; // LD_DIR_EXT  LSR (dir ext)
    8'h76 : PG1_JTA_O = 8'h1; // LD_DIR_EXT  ROR (dir ext)
    8'h77 : PG1_JTA_O = 8'h1; // LD_DIR_EXT  ASR (dir ext)
    8'h78 : PG1_JTA_O = 8'h1; // LD_DIR_EXT  ASL LSL (dir ext)
    8'h79 : PG1_JTA_O = 8'h1; // LD_DIR_EXT  ROL (dir ext)
    8'h7A : PG1_JTA_O = 8'h1; // LD_DIR_EXT  DEC (dir ext)
    8'h7C : PG1_JTA_O = 8'h1; // LD_DIR_EXT  INC (dir ext)
    8'h7D : PG1_JTA_O = 8'h1; // LD_DIR_EXT  TST (dir ext)
    8'h7E : PG1_JTA_O = 8'h2d; // JMP         JMP (dir ext)
    8'h7F : PG1_JTA_O = 8'h22; // CLR         CLR (dir ext)
    8'h80 : PG1_JTA_O = 8'h1e; // SUB         SUBA (imm)
    8'h81 : PG1_JTA_O = 8'h18; // CMP         CMPA (imm)
    8'h82 : PG1_JTA_O = 8'h1d; // SBC         SBCA (imm)
    8'h83 : PG1_JTA_O = 8'h1e; // SUB         SUBD (imm)
    8'h84 : PG1_JTA_O = 8'h15; // AND         ANDA (imm)
    8'h85 : PG1_JTA_O = 8'h17; // BIT         BITA (imm)
    8'h86 : PG1_JTA_O = 8'h1a; // LD          LDA (imm)
    8'h88 : PG1_JTA_O = 8'h19; // EOR         EORA (imm)
    8'h89 : PG1_JTA_O = 8'h13; // ADC         ADCA (imm)
    8'h8A : PG1_JTA_O = 8'h1b; // OR          ORA (imm)
    8'h8B : PG1_JTA_O = 8'h14; // ADD         ADDA (imm)
    8'h8C : PG1_JTA_O = 8'h18; // CMP         CMPX (imm)
    8'h8D : PG1_JTA_O = 8'h2b; // BRANCH      BSR LBSR // FIXME could do this without JUMP_TABLE_A
    8'h8E : PG1_JTA_O = 8'h1a; // LD          LDX (imm)
    8'h90 : PG1_JTA_O = 8'h1; // LD_DIR_EXT  SUBA (dir ext)
    8'h91 : PG1_JTA_O = 8'h1; // LD_DIR_EXT  CMPA (dir ext)
    8'h92 : PG1_JTA_O = 8'h1; // LD_DIR_EXT  SBCA (dir ext)
    8'h93 : PG1_JTA_O = 8'h1; // LD_DIR_EXT  SUBD (dir ext)
    8'h94 : PG1_JTA_O = 8'h1; // LD_DIR_EXT  ANDA (dir ext)
    8'h95 : PG1_JTA_O = 8'h1; // LD_DIR_EXT  BITA (dir ext)
    8'h96 : PG1_JTA_O = 8'h1; // LD_DIR_EXT  LDA (dir ext)
    8'h97 : PG1_JTA_O = 8'h1f; // ST          STA (dir ext)
    8'h98 : PG1_JTA_O = 8'h1; // LD_DIR_EXT  EORA (dir ext)
    8'h99 : PG1_JTA_O = 8'h1; // LD_DIR_EXT  ADCA (dir ext)
    8'h9A : PG1_JTA_O = 8'h1; // LD_DIR_EXT  ORA (dir ext)
    8'h9B : PG1_JTA_O = 8'h1; // LD_DIR_EXT  ADDA (dir ext)
    8'h9C : PG1_JTA_O = 8'h1; // LD_DIR_EXT  CMPX (dir ext)
    8'h9D : PG1_JTA_O = 8'h2e; // JSR         JSR (dir ext)
    8'h9E : PG1_JTA_O = 8'h1; // LD_DIR_EXT  LDX (dir ext)
    8'h9F : PG1_JTA_O = 8'h1f; // ST          STX (dir ext)
    8'hA0 : PG1_JTA_O = 8'h2; // LD_INDEXED  SUBA (idx)
    8'hA1 : PG1_JTA_O = 8'h2; // LD_INDEXED  CMPA (idx)
    8'hA2 : PG1_JTA_O = 8'h2; // LD_INDEXED  SBCA (idx)
    8'hA3 : PG1_JTA_O = 8'h2; // LD_INDEXED  SUBD (idx)
    8'hA4 : PG1_JTA_O = 8'h2; // LD_INDEXED  ANDA (idx)
    8'hA5 : PG1_JTA_O = 8'h2; // LD_INDEXED  BITA (idx)
    8'hA6 : PG1_JTA_O = 8'h2; // LD_INDEXED  LDA (idx)
    8'hA7 : PG1_JTA_O = 8'h4; // ST_INDEXED  STA (idx)
    8'hA8 : PG1_JTA_O = 8'h2; // LD_INDEXED  EORA (idx)
    8'hA9 : PG1_JTA_O = 8'h2; // LD_INDEXED  ADCA (idx)
    8'hAA : PG1_JTA_O = 8'h2; // LD_INDEXED  ORA (idx)
    8'hAB : PG1_JTA_O = 8'h2; // LD_INDEXED  ADDA (idx)
    8'hAC : PG1_JTA_O = 8'h2; // LD_INDEXED  CMPX (idx)
    8'hAD : PG1_JTA_O = 8'h4; // ST_INDEXED  JSR (idx)
    8'hAE : PG1_JTA_O = 8'h2; // LD_INDEXED  LDX (idx)
    8'hAF : PG1_JTA_O = 8'h4; // ST_INDEXED  STX (idx)
    8'hB0 : PG1_JTA_O = 8'h1; // LD_DIR_EXT  SUBA (dir ext)
    8'hB1 : PG1_JTA_O = 8'h1; // LD_DIR_EXT  CMPA (dir ext)
    8'hB2 : PG1_JTA_O = 8'h1; // LD_DIR_EXT  SBCA (dir ext)
    8'hB3 : PG1_JTA_O = 8'h1; // LD_DIR_EXT  SUBD (dir ext)
    8'hB4 : PG1_JTA_O = 8'h1; // LD_DIR_EXT  ANDA (dir ext)
    8'hB5 : PG1_JTA_O = 8'h1; // LD_DIR_EXT  BITA (dir ext)
    8'hB6 : PG1_JTA_O = 8'h1; // LD_DIR_EXT  LDA (dir ext)
    8'hB7 : PG1_JTA_O = 8'h1f; // ST          STA (dir ext)
    8'hB8 : PG1_JTA_O = 8'h1; // LD_DIR_EXT  EORA (dir ext)
    8'hB9 : PG1_JTA_O = 8'h1; // LD_DIR_EXT  ADCA (dir ext)
    8'hBA : PG1_JTA_O = 8'h1; // LD_DIR_EXT  ORA (dir ext)
    8'hBB : PG1_JTA_O = 8'h1; // LD_DIR_EXT  ADDA (dir ext)
    8'hBC : PG1_JTA_O = 8'h1; // LD_DIR_EXT  CMPX (dir ext)
    8'hBD : PG1_JTA_O = 8'h2e; // JSR         JSR (dir ext)
    8'hBE : PG1_JTA_O = 8'h1; // LD_DIR_EXT  LDX (dir ext)
    8'hBF : PG1_JTA_O = 8'h1f; // ST          STX (dir ext)
    8'hC0 : PG1_JTA_O = 8'h1e; // SUB         SUBB (imm)
    8'hC1 : PG1_JTA_O = 8'h18; // CMP         CMPB (imm)
    8'hC2 : PG1_JTA_O = 8'h1d; // SBC         SBCB (imm)
    8'hC3 : PG1_JTA_O = 8'h14; // ADD         ADDD (imm)
    8'hC4 : PG1_JTA_O = 8'h15; // AND         ANDB (imm)
    8'hC5 : PG1_JTA_O = 8'h17; // BIT         BITB (imm)
    8'hC6 : PG1_JTA_O = 8'h1a; // LD          LDB (imm)
    8'hC8 : PG1_JTA_O = 8'h19; // EOR         EORB (imm)
    8'hC9 : PG1_JTA_O = 8'h13; // ADC         ADCB (imm)
    8'hCA : PG1_JTA_O = 8'h1b; // OR          ORB (imm)
    8'hCB : PG1_JTA_O = 8'h14; // ADD         ADDB (imm)
    8'hCC : PG1_JTA_O = 8'h1a; // LD          LDD (imm)
    8'hCE : PG1_JTA_O = 8'h1a; // LD          LDU (imm)
    8'hD0 : PG1_JTA_O = 8'h1; // LD_DIR_EXT  SUBB (dir ext)
    8'hD1 : PG1_JTA_O = 8'h1; // LD_DIR_EXT  CMPB (dir ext)
    8'hD2 : PG1_JTA_O = 8'h1; // LD_DIR_EXT  SBCB (dir ext)
    8'hD3 : PG1_JTA_O = 8'h1; // LD_DIR_EXT  ADDD (dir ext)
    8'hD4 : PG1_JTA_O = 8'h1; // LD_DIR_EXT  ANDB (dir ext)
    8'hD5 : PG1_JTA_O = 8'h1; // LD_DIR_EXT  BITB (dir ext)
    8'hD6 : PG1_JTA_O = 8'h1; // LD_DIR_EXT  LDB (dir ext)
    8'hD7 : PG1_JTA_O = 8'h1f; // ST          STB (dir ext)
    8'hD8 : PG1_JTA_O = 8'h1; // LD_DIR_EXT  EORB (dir ext)
    8'hD9 : PG1_JTA_O = 8'h1; // LD_DIR_EXT  ADCB (dir ext)
    8'hDA : PG1_JTA_O = 8'h1; // LD_DIR_EXT  ORB (dir ext)
    8'hDB : PG1_JTA_O = 8'h1; // LD_DIR_EXT  ADDB (dir ext)
    8'hDC : PG1_JTA_O = 8'h1; // LD_DIR_EXT  LDD (dir ext)
    8'hDD : PG1_JTA_O = 8'h1f; // ST          STD (dir ext)
    8'hDE : PG1_JTA_O = 8'h1; // LD_DIR_EXT  LDU (dir ext)
    8'hDF : PG1_JTA_O = 8'h1f; // ST          STU (dir ext)
    8'hE0 : PG1_JTA_O = 8'h2; // LD_INDEXED  SUBB (idx)
    8'hE1 : PG1_JTA_O = 8'h2; // LD_INDEXED  CMPB (idx)
    8'hE2 : PG1_JTA_O = 8'h2; // LD_INDEXED  SBCB (idx)
    8'hE3 : PG1_JTA_O = 8'h2; // LD_INDEXED  ADDD (idx)
    8'hE4 : PG1_JTA_O = 8'h2; // LD_INDEXED  ANDB (idx)
    8'hE5 : PG1_JTA_O = 8'h2; // LD_INDEXED  BITB (idx)
    8'hE6 : PG1_JTA_O = 8'h2; // LD_INDEXED  LDB (idx)
    8'hE7 : PG1_JTA_O = 8'h4; // ST_INDEXED  STB (idx)
    8'hE8 : PG1_JTA_O = 8'h2; // LD_INDEXED  EORB (idx)
    8'hE9 : PG1_JTA_O = 8'h2; // LD_INDEXED  ADCB (idx)
    8'hEA : PG1_JTA_O = 8'h2; // LD_INDEXED  ORB (idx)
    8'hEB : PG1_JTA_O = 8'h2; // LD_INDEXED  ADDB (idx)
    8'hEC : PG1_JTA_O = 8'h2; // LD_INDEXED  LDD (idx)
    8'hED : PG1_JTA_O = 8'h4; // ST_INDEXED  STD (idx)
    8'hEE : PG1_JTA_O = 8'h2; // LD_INDEXED  LDU (idx)
    8'hEF : PG1_JTA_O = 8'h4; // ST_INDEXED  STU (idx)
    8'hF0 : PG1_JTA_O = 8'h1; // LD_DIR_EXT  SUBB (dir ext)
    8'hF1 : PG1_JTA_O = 8'h1; // LD_DIR_EXT  CMPB (dir ext)
    8'hF2 : PG1_JTA_O = 8'h1; // LD_DIR_EXT  SBCB (dir ext)
    8'hF3 : PG1_JTA_O = 8'h1; // LD_DIR_EXT  ADDD (dir ext)
    8'hF4 : PG1_JTA_O = 8'h1; // LD_DIR_EXT  ANDB (dir ext)
    8'hF5 : PG1_JTA_O = 8'h1; // LD_DIR_EXT  BITB (dir ext)
    8'hF6 : PG1_JTA_O = 8'h1; // LD_DIR_EXT  LDB (dir ext)
    8'hF7 : PG1_JTA_O = 8'h1f; // ST          STB (dir ext)
    8'hF8 : PG1_JTA_O = 8'h1; // LD_DIR_EXT  EORB (dir ext)
    8'hF9 : PG1_JTA_O = 8'h1; // LD_DIR_EXT  ADCB (dir ext)
    8'hFA : PG1_JTA_O = 8'h1; // LD_DIR_EXT  ORB (dir ext)
    8'hFB : PG1_JTA_O = 8'h1; // LD_DIR_EXT  ADDB (dir ext)
    8'hFC : PG1_JTA_O = 8'h1; // LD_DIR_EXT  LDD (dir ext)
    8'hFD : PG1_JTA_O = 8'h1f; // ST          STD (dir ext)
    8'hFE : PG1_JTA_O = 8'h1; // LD_DIR_EXT  LDU (dir ext)
    8'hFF : PG1_JTA_O = 8'h1f; // ST          STU (dir ext)
    default : PG1_JTA_O = 8'hFF; // from decode_init
  endcase
end

`ifdef SIM_TURBO9

reg [(8*64):0] PG1_JTA_op;

always @* begin
  case (OPCODE_I)
    8'h00 : PG1_JTA_op = "NEG (dir ext)";
    8'h03 : PG1_JTA_op = "COM (dir ext)";
    8'h04 : PG1_JTA_op = "LSR (dir ext)";
    8'h06 : PG1_JTA_op = "ROR (dir ext)";
    8'h07 : PG1_JTA_op = "ASR (dir ext)";
    8'h08 : PG1_JTA_op = "ASL LSL (dir ext)";
    8'h09 : PG1_JTA_op = "ROL (dir ext)";
    8'h0A : PG1_JTA_op = "DEC (dir ext)";
    8'h0C : PG1_JTA_op = "INC (dir ext)";
    8'h0D : PG1_JTA_op = "TST (dir ext)";
    8'h0E : PG1_JTA_op = "JMP (dir ext)";
    8'h0F : PG1_JTA_op = "CLR (dir ext)";
    8'h10 : PG1_JTA_op = "page2 (prebyte)";
    8'h11 : PG1_JTA_op = "page3 (prebyte)";
    8'h12 : PG1_JTA_op = "NOP(inh)";
    8'h14 : PG1_JTA_op = "EMUL (inh)";
    8'h16 : PG1_JTA_op = "LBRA On page 1!";
    8'h17 : PG1_JTA_op = "BSR LBSR // FIXME could do this without JUMP_TABLE_A";
    8'h18 : PG1_JTA_op = "IDIV (inh)";
    8'h19 : PG1_JTA_op = "DAA (inh)";
    8'h1A : PG1_JTA_op = "ORCC (imm)";
    8'h1C : PG1_JTA_op = "ANDCC (imm)";
    8'h1D : PG1_JTA_op = "SEX(inh)";
    8'h1E : PG1_JTA_op = "EXG(inh)";
    8'h1F : PG1_JTA_op = "TFR(inh)";
    8'h20 : PG1_JTA_op = "BRA BRN BHI BLS";
    8'h21 : PG1_JTA_op = "BRA BRN BHI BLS";
    8'h22 : PG1_JTA_op = "BRA BRN BHI BLS";
    8'h23 : PG1_JTA_op = "BRA BRN BHI BLS";
    8'h24 : PG1_JTA_op = "BCC BCS BNE BEQ";
    8'h25 : PG1_JTA_op = "BCC BCS BNE BEQ";
    8'h26 : PG1_JTA_op = "BCC BCS BNE BEQ";
    8'h27 : PG1_JTA_op = "BCC BCS BNE BEQ";
    8'h28 : PG1_JTA_op = "BVC BVS BPL BMI";
    8'h29 : PG1_JTA_op = "BVC BVS BPL BMI";
    8'h2A : PG1_JTA_op = "BVC BVS BPL BMI";
    8'h2B : PG1_JTA_op = "BVC BVS BPL BMI";
    8'h2C : PG1_JTA_op = "BGE BLT BGT BLE";
    8'h2D : PG1_JTA_op = "BGE BLT BGT BLE";
    8'h2E : PG1_JTA_op = "BGE BLT BGT BLE";
    8'h2F : PG1_JTA_op = "BGE BLT BGT BLE";
    8'h30 : PG1_JTA_op = "LEAX(inh)";
    8'h31 : PG1_JTA_op = "LEAY(inh)";
    8'h32 : PG1_JTA_op = "LEAS(inh)";
    8'h33 : PG1_JTA_op = "LEAU(inh)";
    8'h34 : PG1_JTA_op = "PSHS";
    8'h35 : PG1_JTA_op = "PULS";
    8'h36 : PG1_JTA_op = "PSHU";
    8'h37 : PG1_JTA_op = "PULU";
    8'h39 : PG1_JTA_op = "RTS";
    8'h3A : PG1_JTA_op = "ABX(inh)";
    8'h3B : PG1_JTA_op = "RTI";
    8'h3D : PG1_JTA_op = "MUL (inh)";
    8'h3F : PG1_JTA_op = "SWI";
    8'h40 : PG1_JTA_op = "NEGA (inh)";
    8'h43 : PG1_JTA_op = "COMA (inh)";
    8'h44 : PG1_JTA_op = "LSRA (inh)";
    8'h46 : PG1_JTA_op = "RORA (inh)";
    8'h47 : PG1_JTA_op = "ASRA (inh)";
    8'h48 : PG1_JTA_op = "ASLA LSLA (inh)";
    8'h49 : PG1_JTA_op = "ROLA (inh)";
    8'h4A : PG1_JTA_op = "DECA (inh)";
    8'h4C : PG1_JTA_op = "INCA (inh)";
    8'h4D : PG1_JTA_op = "TSTA (inh)";
    8'h4F : PG1_JTA_op = "CLRA (inh)";
    8'h50 : PG1_JTA_op = "NEGB (inh)";
    8'h53 : PG1_JTA_op = "COMB (inh)";
    8'h54 : PG1_JTA_op = "LSRB (inh)";
    8'h56 : PG1_JTA_op = "RORB (inh)";
    8'h57 : PG1_JTA_op = "ASRB (inh)";
    8'h58 : PG1_JTA_op = "ASLB LSLB (inh)";
    8'h59 : PG1_JTA_op = "ROLB (inh)";
    8'h5A : PG1_JTA_op = "DECB (inh)";
    8'h5C : PG1_JTA_op = "INCB (inh)";
    8'h5D : PG1_JTA_op = "TSTB (inh)";
    8'h5F : PG1_JTA_op = "CLRB (inh)";
    8'h60 : PG1_JTA_op = "NEG (idx)";
    8'h63 : PG1_JTA_op = "COM (idx)";
    8'h64 : PG1_JTA_op = "LSR (idx)";
    8'h66 : PG1_JTA_op = "ROR (idx)";
    8'h67 : PG1_JTA_op = "ASR (idx)";
    8'h68 : PG1_JTA_op = "ASL LSL (idx)";
    8'h69 : PG1_JTA_op = "ROL (idx)";
    8'h6A : PG1_JTA_op = "DEC (idx)";
    8'h6C : PG1_JTA_op = "INC (idx)";
    8'h6D : PG1_JTA_op = "TST (idx)";
    8'h6E : PG1_JTA_op = "JMP(idx)";
    8'h6F : PG1_JTA_op = "CLR(idx)";
    8'h70 : PG1_JTA_op = "NEG (dir ext)";
    8'h73 : PG1_JTA_op = "COM (dir ext)";
    8'h74 : PG1_JTA_op = "LSR (dir ext)";
    8'h76 : PG1_JTA_op = "ROR (dir ext)";
    8'h77 : PG1_JTA_op = "ASR (dir ext)";
    8'h78 : PG1_JTA_op = "ASL LSL (dir ext)";
    8'h79 : PG1_JTA_op = "ROL (dir ext)";
    8'h7A : PG1_JTA_op = "DEC (dir ext)";
    8'h7C : PG1_JTA_op = "INC (dir ext)";
    8'h7D : PG1_JTA_op = "TST (dir ext)";
    8'h7E : PG1_JTA_op = "JMP (dir ext)";
    8'h7F : PG1_JTA_op = "CLR (dir ext)";
    8'h80 : PG1_JTA_op = "SUBA (imm)";
    8'h81 : PG1_JTA_op = "CMPA (imm)";
    8'h82 : PG1_JTA_op = "SBCA (imm)";
    8'h83 : PG1_JTA_op = "SUBD (imm)";
    8'h84 : PG1_JTA_op = "ANDA (imm)";
    8'h85 : PG1_JTA_op = "BITA (imm)";
    8'h86 : PG1_JTA_op = "LDA (imm)";
    8'h88 : PG1_JTA_op = "EORA (imm)";
    8'h89 : PG1_JTA_op = "ADCA (imm)";
    8'h8A : PG1_JTA_op = "ORA (imm)";
    8'h8B : PG1_JTA_op = "ADDA (imm)";
    8'h8C : PG1_JTA_op = "CMPX (imm)";
    8'h8D : PG1_JTA_op = "BSR LBSR // FIXME could do this without JUMP_TABLE_A";
    8'h8E : PG1_JTA_op = "LDX (imm)";
    8'h90 : PG1_JTA_op = "SUBA (dir ext)";
    8'h91 : PG1_JTA_op = "CMPA (dir ext)";
    8'h92 : PG1_JTA_op = "SBCA (dir ext)";
    8'h93 : PG1_JTA_op = "SUBD (dir ext)";
    8'h94 : PG1_JTA_op = "ANDA (dir ext)";
    8'h95 : PG1_JTA_op = "BITA (dir ext)";
    8'h96 : PG1_JTA_op = "LDA (dir ext)";
    8'h97 : PG1_JTA_op = "STA (dir ext)";
    8'h98 : PG1_JTA_op = "EORA (dir ext)";
    8'h99 : PG1_JTA_op = "ADCA (dir ext)";
    8'h9A : PG1_JTA_op = "ORA (dir ext)";
    8'h9B : PG1_JTA_op = "ADDA (dir ext)";
    8'h9C : PG1_JTA_op = "CMPX (dir ext)";
    8'h9D : PG1_JTA_op = "JSR (dir ext)";
    8'h9E : PG1_JTA_op = "LDX (dir ext)";
    8'h9F : PG1_JTA_op = "STX (dir ext)";
    8'hA0 : PG1_JTA_op = "SUBA (idx)";
    8'hA1 : PG1_JTA_op = "CMPA (idx)";
    8'hA2 : PG1_JTA_op = "SBCA (idx)";
    8'hA3 : PG1_JTA_op = "SUBD (idx)";
    8'hA4 : PG1_JTA_op = "ANDA (idx)";
    8'hA5 : PG1_JTA_op = "BITA (idx)";
    8'hA6 : PG1_JTA_op = "LDA (idx)";
    8'hA7 : PG1_JTA_op = "STA (idx)";
    8'hA8 : PG1_JTA_op = "EORA (idx)";
    8'hA9 : PG1_JTA_op = "ADCA (idx)";
    8'hAA : PG1_JTA_op = "ORA (idx)";
    8'hAB : PG1_JTA_op = "ADDA (idx)";
    8'hAC : PG1_JTA_op = "CMPX (idx)";
    8'hAD : PG1_JTA_op = "JSR (idx)";
    8'hAE : PG1_JTA_op = "LDX (idx)";
    8'hAF : PG1_JTA_op = "STX (idx)";
    8'hB0 : PG1_JTA_op = "SUBA (dir ext)";
    8'hB1 : PG1_JTA_op = "CMPA (dir ext)";
    8'hB2 : PG1_JTA_op = "SBCA (dir ext)";
    8'hB3 : PG1_JTA_op = "SUBD (dir ext)";
    8'hB4 : PG1_JTA_op = "ANDA (dir ext)";
    8'hB5 : PG1_JTA_op = "BITA (dir ext)";
    8'hB6 : PG1_JTA_op = "LDA (dir ext)";
    8'hB7 : PG1_JTA_op = "STA (dir ext)";
    8'hB8 : PG1_JTA_op = "EORA (dir ext)";
    8'hB9 : PG1_JTA_op = "ADCA (dir ext)";
    8'hBA : PG1_JTA_op = "ORA (dir ext)";
    8'hBB : PG1_JTA_op = "ADDA (dir ext)";
    8'hBC : PG1_JTA_op = "CMPX (dir ext)";
    8'hBD : PG1_JTA_op = "JSR (dir ext)";
    8'hBE : PG1_JTA_op = "LDX (dir ext)";
    8'hBF : PG1_JTA_op = "STX (dir ext)";
    8'hC0 : PG1_JTA_op = "SUBB (imm)";
    8'hC1 : PG1_JTA_op = "CMPB (imm)";
    8'hC2 : PG1_JTA_op = "SBCB (imm)";
    8'hC3 : PG1_JTA_op = "ADDD (imm)";
    8'hC4 : PG1_JTA_op = "ANDB (imm)";
    8'hC5 : PG1_JTA_op = "BITB (imm)";
    8'hC6 : PG1_JTA_op = "LDB (imm)";
    8'hC8 : PG1_JTA_op = "EORB (imm)";
    8'hC9 : PG1_JTA_op = "ADCB (imm)";
    8'hCA : PG1_JTA_op = "ORB (imm)";
    8'hCB : PG1_JTA_op = "ADDB (imm)";
    8'hCC : PG1_JTA_op = "LDD (imm)";
    8'hCE : PG1_JTA_op = "LDU (imm)";
    8'hD0 : PG1_JTA_op = "SUBB (dir ext)";
    8'hD1 : PG1_JTA_op = "CMPB (dir ext)";
    8'hD2 : PG1_JTA_op = "SBCB (dir ext)";
    8'hD3 : PG1_JTA_op = "ADDD (dir ext)";
    8'hD4 : PG1_JTA_op = "ANDB (dir ext)";
    8'hD5 : PG1_JTA_op = "BITB (dir ext)";
    8'hD6 : PG1_JTA_op = "LDB (dir ext)";
    8'hD7 : PG1_JTA_op = "STB (dir ext)";
    8'hD8 : PG1_JTA_op = "EORB (dir ext)";
    8'hD9 : PG1_JTA_op = "ADCB (dir ext)";
    8'hDA : PG1_JTA_op = "ORB (dir ext)";
    8'hDB : PG1_JTA_op = "ADDB (dir ext)";
    8'hDC : PG1_JTA_op = "LDD (dir ext)";
    8'hDD : PG1_JTA_op = "STD (dir ext)";
    8'hDE : PG1_JTA_op = "LDU (dir ext)";
    8'hDF : PG1_JTA_op = "STU (dir ext)";
    8'hE0 : PG1_JTA_op = "SUBB (idx)";
    8'hE1 : PG1_JTA_op = "CMPB (idx)";
    8'hE2 : PG1_JTA_op = "SBCB (idx)";
    8'hE3 : PG1_JTA_op = "ADDD (idx)";
    8'hE4 : PG1_JTA_op = "ANDB (idx)";
    8'hE5 : PG1_JTA_op = "BITB (idx)";
    8'hE6 : PG1_JTA_op = "LDB (idx)";
    8'hE7 : PG1_JTA_op = "STB (idx)";
    8'hE8 : PG1_JTA_op = "EORB (idx)";
    8'hE9 : PG1_JTA_op = "ADCB (idx)";
    8'hEA : PG1_JTA_op = "ORB (idx)";
    8'hEB : PG1_JTA_op = "ADDB (idx)";
    8'hEC : PG1_JTA_op = "LDD (idx)";
    8'hED : PG1_JTA_op = "STD (idx)";
    8'hEE : PG1_JTA_op = "LDU (idx)";
    8'hEF : PG1_JTA_op = "STU (idx)";
    8'hF0 : PG1_JTA_op = "SUBB (dir ext)";
    8'hF1 : PG1_JTA_op = "CMPB (dir ext)";
    8'hF2 : PG1_JTA_op = "SBCB (dir ext)";
    8'hF3 : PG1_JTA_op = "ADDD (dir ext)";
    8'hF4 : PG1_JTA_op = "ANDB (dir ext)";
    8'hF5 : PG1_JTA_op = "BITB (dir ext)";
    8'hF6 : PG1_JTA_op = "LDB (dir ext)";
    8'hF7 : PG1_JTA_op = "STB (dir ext)";
    8'hF8 : PG1_JTA_op = "EORB (dir ext)";
    8'hF9 : PG1_JTA_op = "ADCB (dir ext)";
    8'hFA : PG1_JTA_op = "ORB (dir ext)";
    8'hFB : PG1_JTA_op = "ADDB (dir ext)";
    8'hFC : PG1_JTA_op = "LDD (dir ext)";
    8'hFD : PG1_JTA_op = "STD (dir ext)";
    8'hFE : PG1_JTA_op = "LDU (dir ext)";
    8'hFF : PG1_JTA_op = "STU (dir ext)";
    default : PG1_JTA_op = "invalid";
  endcase
end

reg [(8*64):0] PG1_JTA_eq;

always @* begin
  case (OPCODE_I)
    8'h00 : PG1_JTA_eq = "LD_DIR_EXT";
    8'h03 : PG1_JTA_eq = "LD_DIR_EXT";
    8'h04 : PG1_JTA_eq = "LD_DIR_EXT";
    8'h06 : PG1_JTA_eq = "LD_DIR_EXT";
    8'h07 : PG1_JTA_eq = "LD_DIR_EXT";
    8'h08 : PG1_JTA_eq = "LD_DIR_EXT";
    8'h09 : PG1_JTA_eq = "LD_DIR_EXT";
    8'h0A : PG1_JTA_eq = "LD_DIR_EXT";
    8'h0C : PG1_JTA_eq = "LD_DIR_EXT";
    8'h0D : PG1_JTA_eq = "LD_DIR_EXT";
    8'h0E : PG1_JTA_eq = "JMP";
    8'h0F : PG1_JTA_eq = "CLR";
    8'h10 : PG1_JTA_eq = "NOP";
    8'h11 : PG1_JTA_eq = "NOP";
    8'h12 : PG1_JTA_eq = "NOP";
    8'h14 : PG1_JTA_eq = "SAU16";
    8'h16 : PG1_JTA_eq = "BRANCH";
    8'h17 : PG1_JTA_eq = "BRANCH";
    8'h18 : PG1_JTA_eq = "SAU16";
    8'h19 : PG1_JTA_eq = "SAU8";
    8'h1A : PG1_JTA_eq = "ORCC";
    8'h1C : PG1_JTA_eq = "ANDCC";
    8'h1D : PG1_JTA_eq = "SEX";
    8'h1E : PG1_JTA_eq = "EXG";
    8'h1F : PG1_JTA_eq = "TFR";
    8'h20 : PG1_JTA_eq = "BRANCH";
    8'h21 : PG1_JTA_eq = "BRANCH";
    8'h22 : PG1_JTA_eq = "BRANCH";
    8'h23 : PG1_JTA_eq = "BRANCH";
    8'h24 : PG1_JTA_eq = "BRANCH";
    8'h25 : PG1_JTA_eq = "BRANCH";
    8'h26 : PG1_JTA_eq = "BRANCH";
    8'h27 : PG1_JTA_eq = "BRANCH";
    8'h28 : PG1_JTA_eq = "BRANCH";
    8'h29 : PG1_JTA_eq = "BRANCH";
    8'h2A : PG1_JTA_eq = "BRANCH";
    8'h2B : PG1_JTA_eq = "BRANCH";
    8'h2C : PG1_JTA_eq = "BRANCH";
    8'h2D : PG1_JTA_eq = "BRANCH";
    8'h2E : PG1_JTA_eq = "BRANCH";
    8'h2F : PG1_JTA_eq = "BRANCH";
    8'h30 : PG1_JTA_eq = "ST_INDEXED";
    8'h31 : PG1_JTA_eq = "ST_INDEXED";
    8'h32 : PG1_JTA_eq = "ST_INDEXED";
    8'h33 : PG1_JTA_eq = "ST_INDEXED";
    8'h34 : PG1_JTA_eq = "PSH";
    8'h35 : PG1_JTA_eq = "PUL";
    8'h36 : PG1_JTA_eq = "PSH";
    8'h37 : PG1_JTA_eq = "PUL";
    8'h39 : PG1_JTA_eq = "RTS";
    8'h3A : PG1_JTA_eq = "ABX";
    8'h3B : PG1_JTA_eq = "RTI";
    8'h3D : PG1_JTA_eq = "SAU8";
    8'h3F : PG1_JTA_eq = "SWI";
    8'h40 : PG1_JTA_eq = "NEG";
    8'h43 : PG1_JTA_eq = "COM";
    8'h44 : PG1_JTA_eq = "LSR";
    8'h46 : PG1_JTA_eq = "ROR";
    8'h47 : PG1_JTA_eq = "ASR";
    8'h48 : PG1_JTA_eq = "ASL_LSL";
    8'h49 : PG1_JTA_eq = "ROL";
    8'h4A : PG1_JTA_eq = "DEC";
    8'h4C : PG1_JTA_eq = "INC";
    8'h4D : PG1_JTA_eq = "TST";
    8'h4F : PG1_JTA_eq = "CLR";
    8'h50 : PG1_JTA_eq = "NEG";
    8'h53 : PG1_JTA_eq = "COM";
    8'h54 : PG1_JTA_eq = "LSR";
    8'h56 : PG1_JTA_eq = "ROR";
    8'h57 : PG1_JTA_eq = "ASR";
    8'h58 : PG1_JTA_eq = "ASL_LSL";
    8'h59 : PG1_JTA_eq = "ROL";
    8'h5A : PG1_JTA_eq = "DEC";
    8'h5C : PG1_JTA_eq = "INC";
    8'h5D : PG1_JTA_eq = "TST";
    8'h5F : PG1_JTA_eq = "CLR";
    8'h60 : PG1_JTA_eq = "LD_INDEXED";
    8'h63 : PG1_JTA_eq = "LD_INDEXED";
    8'h64 : PG1_JTA_eq = "LD_INDEXED";
    8'h66 : PG1_JTA_eq = "LD_INDEXED";
    8'h67 : PG1_JTA_eq = "LD_INDEXED";
    8'h68 : PG1_JTA_eq = "LD_INDEXED";
    8'h69 : PG1_JTA_eq = "LD_INDEXED";
    8'h6A : PG1_JTA_eq = "LD_INDEXED";
    8'h6C : PG1_JTA_eq = "LD_INDEXED";
    8'h6D : PG1_JTA_eq = "LD_INDEXED";
    8'h6E : PG1_JTA_eq = "ST_INDEXED";
    8'h6F : PG1_JTA_eq = "ST_INDEXED";
    8'h70 : PG1_JTA_eq = "LD_DIR_EXT";
    8'h73 : PG1_JTA_eq = "LD_DIR_EXT";
    8'h74 : PG1_JTA_eq = "LD_DIR_EXT";
    8'h76 : PG1_JTA_eq = "LD_DIR_EXT";
    8'h77 : PG1_JTA_eq = "LD_DIR_EXT";
    8'h78 : PG1_JTA_eq = "LD_DIR_EXT";
    8'h79 : PG1_JTA_eq = "LD_DIR_EXT";
    8'h7A : PG1_JTA_eq = "LD_DIR_EXT";
    8'h7C : PG1_JTA_eq = "LD_DIR_EXT";
    8'h7D : PG1_JTA_eq = "LD_DIR_EXT";
    8'h7E : PG1_JTA_eq = "JMP";
    8'h7F : PG1_JTA_eq = "CLR";
    8'h80 : PG1_JTA_eq = "SUB";
    8'h81 : PG1_JTA_eq = "CMP";
    8'h82 : PG1_JTA_eq = "SBC";
    8'h83 : PG1_JTA_eq = "SUB";
    8'h84 : PG1_JTA_eq = "AND";
    8'h85 : PG1_JTA_eq = "BIT";
    8'h86 : PG1_JTA_eq = "LD";
    8'h88 : PG1_JTA_eq = "EOR";
    8'h89 : PG1_JTA_eq = "ADC";
    8'h8A : PG1_JTA_eq = "OR";
    8'h8B : PG1_JTA_eq = "ADD";
    8'h8C : PG1_JTA_eq = "CMP";
    8'h8D : PG1_JTA_eq = "BRANCH";
    8'h8E : PG1_JTA_eq = "LD";
    8'h90 : PG1_JTA_eq = "LD_DIR_EXT";
    8'h91 : PG1_JTA_eq = "LD_DIR_EXT";
    8'h92 : PG1_JTA_eq = "LD_DIR_EXT";
    8'h93 : PG1_JTA_eq = "LD_DIR_EXT";
    8'h94 : PG1_JTA_eq = "LD_DIR_EXT";
    8'h95 : PG1_JTA_eq = "LD_DIR_EXT";
    8'h96 : PG1_JTA_eq = "LD_DIR_EXT";
    8'h97 : PG1_JTA_eq = "ST";
    8'h98 : PG1_JTA_eq = "LD_DIR_EXT";
    8'h99 : PG1_JTA_eq = "LD_DIR_EXT";
    8'h9A : PG1_JTA_eq = "LD_DIR_EXT";
    8'h9B : PG1_JTA_eq = "LD_DIR_EXT";
    8'h9C : PG1_JTA_eq = "LD_DIR_EXT";
    8'h9D : PG1_JTA_eq = "JSR";
    8'h9E : PG1_JTA_eq = "LD_DIR_EXT";
    8'h9F : PG1_JTA_eq = "ST";
    8'hA0 : PG1_JTA_eq = "LD_INDEXED";
    8'hA1 : PG1_JTA_eq = "LD_INDEXED";
    8'hA2 : PG1_JTA_eq = "LD_INDEXED";
    8'hA3 : PG1_JTA_eq = "LD_INDEXED";
    8'hA4 : PG1_JTA_eq = "LD_INDEXED";
    8'hA5 : PG1_JTA_eq = "LD_INDEXED";
    8'hA6 : PG1_JTA_eq = "LD_INDEXED";
    8'hA7 : PG1_JTA_eq = "ST_INDEXED";
    8'hA8 : PG1_JTA_eq = "LD_INDEXED";
    8'hA9 : PG1_JTA_eq = "LD_INDEXED";
    8'hAA : PG1_JTA_eq = "LD_INDEXED";
    8'hAB : PG1_JTA_eq = "LD_INDEXED";
    8'hAC : PG1_JTA_eq = "LD_INDEXED";
    8'hAD : PG1_JTA_eq = "ST_INDEXED";
    8'hAE : PG1_JTA_eq = "LD_INDEXED";
    8'hAF : PG1_JTA_eq = "ST_INDEXED";
    8'hB0 : PG1_JTA_eq = "LD_DIR_EXT";
    8'hB1 : PG1_JTA_eq = "LD_DIR_EXT";
    8'hB2 : PG1_JTA_eq = "LD_DIR_EXT";
    8'hB3 : PG1_JTA_eq = "LD_DIR_EXT";
    8'hB4 : PG1_JTA_eq = "LD_DIR_EXT";
    8'hB5 : PG1_JTA_eq = "LD_DIR_EXT";
    8'hB6 : PG1_JTA_eq = "LD_DIR_EXT";
    8'hB7 : PG1_JTA_eq = "ST";
    8'hB8 : PG1_JTA_eq = "LD_DIR_EXT";
    8'hB9 : PG1_JTA_eq = "LD_DIR_EXT";
    8'hBA : PG1_JTA_eq = "LD_DIR_EXT";
    8'hBB : PG1_JTA_eq = "LD_DIR_EXT";
    8'hBC : PG1_JTA_eq = "LD_DIR_EXT";
    8'hBD : PG1_JTA_eq = "JSR";
    8'hBE : PG1_JTA_eq = "LD_DIR_EXT";
    8'hBF : PG1_JTA_eq = "ST";
    8'hC0 : PG1_JTA_eq = "SUB";
    8'hC1 : PG1_JTA_eq = "CMP";
    8'hC2 : PG1_JTA_eq = "SBC";
    8'hC3 : PG1_JTA_eq = "ADD";
    8'hC4 : PG1_JTA_eq = "AND";
    8'hC5 : PG1_JTA_eq = "BIT";
    8'hC6 : PG1_JTA_eq = "LD";
    8'hC8 : PG1_JTA_eq = "EOR";
    8'hC9 : PG1_JTA_eq = "ADC";
    8'hCA : PG1_JTA_eq = "OR";
    8'hCB : PG1_JTA_eq = "ADD";
    8'hCC : PG1_JTA_eq = "LD";
    8'hCE : PG1_JTA_eq = "LD";
    8'hD0 : PG1_JTA_eq = "LD_DIR_EXT";
    8'hD1 : PG1_JTA_eq = "LD_DIR_EXT";
    8'hD2 : PG1_JTA_eq = "LD_DIR_EXT";
    8'hD3 : PG1_JTA_eq = "LD_DIR_EXT";
    8'hD4 : PG1_JTA_eq = "LD_DIR_EXT";
    8'hD5 : PG1_JTA_eq = "LD_DIR_EXT";
    8'hD6 : PG1_JTA_eq = "LD_DIR_EXT";
    8'hD7 : PG1_JTA_eq = "ST";
    8'hD8 : PG1_JTA_eq = "LD_DIR_EXT";
    8'hD9 : PG1_JTA_eq = "LD_DIR_EXT";
    8'hDA : PG1_JTA_eq = "LD_DIR_EXT";
    8'hDB : PG1_JTA_eq = "LD_DIR_EXT";
    8'hDC : PG1_JTA_eq = "LD_DIR_EXT";
    8'hDD : PG1_JTA_eq = "ST";
    8'hDE : PG1_JTA_eq = "LD_DIR_EXT";
    8'hDF : PG1_JTA_eq = "ST";
    8'hE0 : PG1_JTA_eq = "LD_INDEXED";
    8'hE1 : PG1_JTA_eq = "LD_INDEXED";
    8'hE2 : PG1_JTA_eq = "LD_INDEXED";
    8'hE3 : PG1_JTA_eq = "LD_INDEXED";
    8'hE4 : PG1_JTA_eq = "LD_INDEXED";
    8'hE5 : PG1_JTA_eq = "LD_INDEXED";
    8'hE6 : PG1_JTA_eq = "LD_INDEXED";
    8'hE7 : PG1_JTA_eq = "ST_INDEXED";
    8'hE8 : PG1_JTA_eq = "LD_INDEXED";
    8'hE9 : PG1_JTA_eq = "LD_INDEXED";
    8'hEA : PG1_JTA_eq = "LD_INDEXED";
    8'hEB : PG1_JTA_eq = "LD_INDEXED";
    8'hEC : PG1_JTA_eq = "LD_INDEXED";
    8'hED : PG1_JTA_eq = "ST_INDEXED";
    8'hEE : PG1_JTA_eq = "LD_INDEXED";
    8'hEF : PG1_JTA_eq = "ST_INDEXED";
    8'hF0 : PG1_JTA_eq = "LD_DIR_EXT";
    8'hF1 : PG1_JTA_eq = "LD_DIR_EXT";
    8'hF2 : PG1_JTA_eq = "LD_DIR_EXT";
    8'hF3 : PG1_JTA_eq = "LD_DIR_EXT";
    8'hF4 : PG1_JTA_eq = "LD_DIR_EXT";
    8'hF5 : PG1_JTA_eq = "LD_DIR_EXT";
    8'hF6 : PG1_JTA_eq = "LD_DIR_EXT";
    8'hF7 : PG1_JTA_eq = "ST";
    8'hF8 : PG1_JTA_eq = "LD_DIR_EXT";
    8'hF9 : PG1_JTA_eq = "LD_DIR_EXT";
    8'hFA : PG1_JTA_eq = "LD_DIR_EXT";
    8'hFB : PG1_JTA_eq = "LD_DIR_EXT";
    8'hFC : PG1_JTA_eq = "LD_DIR_EXT";
    8'hFD : PG1_JTA_eq = "ST";
    8'hFE : PG1_JTA_eq = "LD_DIR_EXT";
    8'hFF : PG1_JTA_eq = "ST";
    default : PG1_JTA_eq = "invalid";
  endcase
end

`endif

/////////////////////////////////////////////////////////////////////////////

endmodule

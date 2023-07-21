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
// built using cv_R1_SEL ctrl_vec
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
module turbo9_urtl_decode_pg1_R1(
  input      [7:0] OPCODE_I,
  output reg [3:0] PG1_R1_O
);

/////////////////////////////////////////////////////////////////////////////
//                                LOGIC
/////////////////////////////////////////////////////////////////////////////

always @* begin
  case (OPCODE_I)
    8'h00 : PG1_R1_O = 4'hd; // DMEM_RD     NEG (dir idx ext) sets 8bit width
    8'h03 : PG1_R1_O = 4'hd; // DMEM_RD     COM (dir idx ext) sets 8bit width
    8'h04 : PG1_R1_O = 4'hd; // DMEM_RD     LSR (dir idx ext)
    8'h06 : PG1_R1_O = 4'hd; // DMEM_RD     ROR (dir idx ext)
    8'h07 : PG1_R1_O = 4'hd; // DMEM_RD     ASR (dir idx ext)
    8'h08 : PG1_R1_O = 4'hd; // DMEM_RD     ASL LSL (dir idx ext)
    8'h09 : PG1_R1_O = 4'hd; // DMEM_RD     ROL (dir idx ext)
    8'h0A : PG1_R1_O = 4'hd; // DMEM_RD     DEC (dir idx ext)
    8'h0C : PG1_R1_O = 4'hd; // DMEM_RD     INC (dir idx ext)
    8'h0D : PG1_R1_O = 4'hd; // DMEM_RD     TST (dir idx ext)
    8'h0E : PG1_R1_O = 4'h5; // PC          JMP (dir ext)
    8'h0F : PG1_R1_O = 4'hd; // DMEM_RD     CLR (dir ext) sets 8bit width
    8'h14 : PG1_R1_O = 4'h0; // D           EMUL (inh)
    8'h16 : PG1_R1_O = 4'h5; // PC          LBRA 
    8'h17 : PG1_R1_O = 4'h5; // PC          BSR LBSR
    8'h18 : PG1_R1_O = 4'h1; // X           IDIV (inh)
    8'h19 : PG1_R1_O = 4'h0; // D           DAA (inh)
    8'h1A : PG1_R1_O = 4'ha; // CCR         ORCC (imm)
    8'h1C : PG1_R1_O = 4'ha; // CCR         ANDCC (imm)
    8'h1D : PG1_R1_O = 4'h0; // D           SEX(inh)
    8'h20 : PG1_R1_O = 4'h5; // PC          BRA BRN BHI BLS
    8'h21 : PG1_R1_O = 4'h5; // PC          BRA BRN BHI BLS
    8'h22 : PG1_R1_O = 4'h5; // PC          BRA BRN BHI BLS
    8'h23 : PG1_R1_O = 4'h5; // PC          BRA BRN BHI BLS
    8'h24 : PG1_R1_O = 4'h5; // PC          BCC BCS BNE BEQ
    8'h25 : PG1_R1_O = 4'h5; // PC          BCC BCS BNE BEQ
    8'h26 : PG1_R1_O = 4'h5; // PC          BCC BCS BNE BEQ
    8'h27 : PG1_R1_O = 4'h5; // PC          BCC BCS BNE BEQ
    8'h28 : PG1_R1_O = 4'h5; // PC          BVC BVS BPL BMI
    8'h29 : PG1_R1_O = 4'h5; // PC          BVC BVS BPL BMI
    8'h2A : PG1_R1_O = 4'h5; // PC          BVC BVS BPL BMI
    8'h2B : PG1_R1_O = 4'h5; // PC          BVC BVS BPL BMI
    8'h2C : PG1_R1_O = 4'h5; // PC          BGE BLT BGT BLE
    8'h2D : PG1_R1_O = 4'h5; // PC          BGE BLT BGT BLE
    8'h2E : PG1_R1_O = 4'h5; // PC          BGE BLT BGT BLE
    8'h2F : PG1_R1_O = 4'h5; // PC          BGE BLT BGT BLE
    8'h30 : PG1_R1_O = 4'h1; // X           LEAX(inh)
    8'h31 : PG1_R1_O = 4'h2; // Y           LEAY(inh)
    8'h32 : PG1_R1_O = 4'h4; // S           LEAS(inh)
    8'h33 : PG1_R1_O = 4'h3; // U           LEAU(inh)
    8'h39 : PG1_R1_O = 4'h5; // PC          RTS
    8'h3A : PG1_R1_O = 4'h1; // X           ABX(inh)
    8'h3B : PG1_R1_O = 4'h5; // PC          RTI
    8'h3D : PG1_R1_O = 4'h0; // D           MUL (inh)
    8'h3F : PG1_R1_O = 4'h5; // PC          SWI
    8'h40 : PG1_R1_O = 4'h8; // A           NEGA (inh)
    8'h43 : PG1_R1_O = 4'h8; // A           COMA (inh)
    8'h44 : PG1_R1_O = 4'h8; // A           LSRA (inh)
    8'h46 : PG1_R1_O = 4'h8; // A           RORA (inh)
    8'h47 : PG1_R1_O = 4'h8; // A           ASRA (inh)
    8'h48 : PG1_R1_O = 4'h8; // A           ASLA LSLA (inh)
    8'h49 : PG1_R1_O = 4'h8; // A           ROLA (inh)
    8'h4A : PG1_R1_O = 4'h8; // A           DECA (inh)
    8'h4C : PG1_R1_O = 4'h8; // A           INCA (inh)
    8'h4D : PG1_R1_O = 4'h8; // A           TSTA (inh)
    8'h4F : PG1_R1_O = 4'h8; // A           CLRA (inh)
    8'h50 : PG1_R1_O = 4'h9; // B           NEGB (inh)
    8'h53 : PG1_R1_O = 4'h9; // B           COMB (inh)
    8'h54 : PG1_R1_O = 4'h9; // B           LSRB (inh)
    8'h56 : PG1_R1_O = 4'h9; // B           RORB (inh)
    8'h57 : PG1_R1_O = 4'h9; // B           ASRB (inh)
    8'h58 : PG1_R1_O = 4'h9; // B           ASLB LSLB (inh)
    8'h59 : PG1_R1_O = 4'h9; // B           ROLB (inh)
    8'h5A : PG1_R1_O = 4'h9; // B           DECB (inh)
    8'h5C : PG1_R1_O = 4'h9; // B           INCB (inh)
    8'h5D : PG1_R1_O = 4'h9; // B           TSTB (inh)
    8'h5F : PG1_R1_O = 4'h9; // B           CLRB (inh)
    8'h60 : PG1_R1_O = 4'hd; // DMEM_RD     NEG (dir idx ext) sets 8bit width
    8'h63 : PG1_R1_O = 4'hd; // DMEM_RD     COM (dir idx ext) sets 8bit width
    8'h64 : PG1_R1_O = 4'hd; // DMEM_RD     LSR (dir idx ext)
    8'h66 : PG1_R1_O = 4'hd; // DMEM_RD     ROR (dir idx ext)
    8'h67 : PG1_R1_O = 4'hd; // DMEM_RD     ASR (dir idx ext)
    8'h68 : PG1_R1_O = 4'hd; // DMEM_RD     ASL LSL (dir idx ext)
    8'h69 : PG1_R1_O = 4'hd; // DMEM_RD     ROL (dir idx ext)
    8'h6A : PG1_R1_O = 4'hd; // DMEM_RD     DEC (dir idx ext)
    8'h6C : PG1_R1_O = 4'hd; // DMEM_RD     INC (dir idx ext)
    8'h6D : PG1_R1_O = 4'hd; // DMEM_RD     TST (dir idx ext)
    8'h6E : PG1_R1_O = 4'h5; // PC          JMP (idx)
    8'h6F : PG1_R1_O = 4'hd; // DMEM_RD     CLR (idx) sets 8bit width
    8'h70 : PG1_R1_O = 4'hd; // DMEM_RD     NEG (dir idx ext) sets 8bit width
    8'h73 : PG1_R1_O = 4'hd; // DMEM_RD     COM (dir idx ext) sets 8bit width
    8'h74 : PG1_R1_O = 4'hd; // DMEM_RD     LSR (dir idx ext)
    8'h76 : PG1_R1_O = 4'hd; // DMEM_RD     ROR (dir idx ext)
    8'h77 : PG1_R1_O = 4'hd; // DMEM_RD     ASR (dir idx ext)
    8'h78 : PG1_R1_O = 4'hd; // DMEM_RD     ASL LSL (dir idx ext)
    8'h79 : PG1_R1_O = 4'hd; // DMEM_RD     ROL (dir idx ext)
    8'h7A : PG1_R1_O = 4'hd; // DMEM_RD     DEC (dir idx ext)
    8'h7C : PG1_R1_O = 4'hd; // DMEM_RD     INC (dir idx ext)
    8'h7D : PG1_R1_O = 4'hd; // DMEM_RD     TST (dir idx ext)
    8'h7E : PG1_R1_O = 4'h5; // PC          JMP (dir ext)
    8'h7F : PG1_R1_O = 4'hd; // DMEM_RD     CLR (dir ext) sets 8bit width
    8'h80 : PG1_R1_O = 4'h8; // A           SUBA (imm)
    8'h81 : PG1_R1_O = 4'h8; // A           CMPA (imm)
    8'h82 : PG1_R1_O = 4'h8; // A           SBCA (imm)
    8'h83 : PG1_R1_O = 4'h0; // D           SUBD (imm)
    8'h84 : PG1_R1_O = 4'h8; // A           ANDA (imm)
    8'h85 : PG1_R1_O = 4'h8; // A           BITA (imm)
    8'h86 : PG1_R1_O = 4'h8; // A           LDA (imm)
    8'h88 : PG1_R1_O = 4'h8; // A           EORA (imm)
    8'h89 : PG1_R1_O = 4'h8; // A           ADCA (imm)
    8'h8A : PG1_R1_O = 4'h8; // A           ORA (imm)
    8'h8B : PG1_R1_O = 4'h8; // A           ADDA (imm)
    8'h8C : PG1_R1_O = 4'h1; // X           CMPX (imm)
    8'h8D : PG1_R1_O = 4'h5; // PC          BSR LBSR
    8'h8E : PG1_R1_O = 4'h1; // X           LDX (imm)
    8'h90 : PG1_R1_O = 4'h8; // A           SUBA (dir idx ext)
    8'h91 : PG1_R1_O = 4'h8; // A           CMPA (dir idx ext)
    8'h92 : PG1_R1_O = 4'h8; // A           SBCA (dir idx ext)
    8'h93 : PG1_R1_O = 4'h0; // D           SUBD (dir idx ext)
    8'h94 : PG1_R1_O = 4'h8; // A           ANDA (dir idx ext)
    8'h95 : PG1_R1_O = 4'h8; // A           BITA (dir idx ext)
    8'h96 : PG1_R1_O = 4'h8; // A           LDA (dir idx ext)
    8'h97 : PG1_R1_O = 4'h8; // A           STA (dir ext)
    8'h98 : PG1_R1_O = 4'h8; // A           EORA (dir idx ext)
    8'h99 : PG1_R1_O = 4'h8; // A           ADCA (dir idx ext)
    8'h9A : PG1_R1_O = 4'h8; // A           ORA (dir idx ext)
    8'h9B : PG1_R1_O = 4'h8; // A           ADDA (dir idx ext)
    8'h9C : PG1_R1_O = 4'h1; // X           CMPX (dir idx ext)
    8'h9D : PG1_R1_O = 4'h5; // PC          JSR (dir ext)
    8'h9E : PG1_R1_O = 4'h1; // X           LDX (dir idx ext)
    8'h9F : PG1_R1_O = 4'h1; // X           STX (dir ext)
    8'hA0 : PG1_R1_O = 4'h8; // A           SUBA (dir idx ext)
    8'hA1 : PG1_R1_O = 4'h8; // A           CMPA (dir idx ext)
    8'hA2 : PG1_R1_O = 4'h8; // A           SBCA (dir idx ext)
    8'hA3 : PG1_R1_O = 4'h0; // D           SUBD (dir idx ext)
    8'hA4 : PG1_R1_O = 4'h8; // A           ANDA (dir idx ext)
    8'hA5 : PG1_R1_O = 4'h8; // A           BITA (dir idx ext)
    8'hA6 : PG1_R1_O = 4'h8; // A           LDA (dir idx ext)
    8'hA7 : PG1_R1_O = 4'h8; // A           STA (idx)
    8'hA8 : PG1_R1_O = 4'h8; // A           EORA (dir idx ext)
    8'hA9 : PG1_R1_O = 4'h8; // A           ADCA (dir idx ext)
    8'hAA : PG1_R1_O = 4'h8; // A           ORA (dir idx ext)
    8'hAB : PG1_R1_O = 4'h8; // A           ADDA (dir idx ext)
    8'hAC : PG1_R1_O = 4'h1; // X           CMPX (dir idx ext)
    8'hAD : PG1_R1_O = 4'h5; // PC          JSR (idx)
    8'hAE : PG1_R1_O = 4'h1; // X           LDX (dir idx ext)
    8'hAF : PG1_R1_O = 4'h1; // X           STX (idx)
    8'hB0 : PG1_R1_O = 4'h8; // A           SUBA (dir idx ext)
    8'hB1 : PG1_R1_O = 4'h8; // A           CMPA (dir idx ext)
    8'hB2 : PG1_R1_O = 4'h8; // A           SBCA (dir idx ext)
    8'hB3 : PG1_R1_O = 4'h0; // D           SUBD (dir idx ext)
    8'hB4 : PG1_R1_O = 4'h8; // A           ANDA (dir idx ext)
    8'hB5 : PG1_R1_O = 4'h8; // A           BITA (dir idx ext)
    8'hB6 : PG1_R1_O = 4'h8; // A           LDA (dir idx ext)
    8'hB7 : PG1_R1_O = 4'h8; // A           STA (dir ext)
    8'hB8 : PG1_R1_O = 4'h8; // A           EORA (dir idx ext)
    8'hB9 : PG1_R1_O = 4'h8; // A           ADCA (dir idx ext)
    8'hBA : PG1_R1_O = 4'h8; // A           ORA (dir idx ext)
    8'hBB : PG1_R1_O = 4'h8; // A           ADDA (dir idx ext)
    8'hBC : PG1_R1_O = 4'h1; // X           CMPX (dir idx ext)
    8'hBD : PG1_R1_O = 4'h5; // PC          JSR (dir ext)
    8'hBE : PG1_R1_O = 4'h1; // X           LDX (dir idx ext)
    8'hBF : PG1_R1_O = 4'h1; // X           STX (dir ext)
    8'hC0 : PG1_R1_O = 4'h9; // B           SUBB (imm)
    8'hC1 : PG1_R1_O = 4'h9; // B           CMPB (imm)
    8'hC2 : PG1_R1_O = 4'h9; // B           SBCB (imm)
    8'hC3 : PG1_R1_O = 4'h0; // D           ADDD (imm)
    8'hC4 : PG1_R1_O = 4'h9; // B           ANDB (imm)
    8'hC5 : PG1_R1_O = 4'h9; // B           BITB (imm)
    8'hC6 : PG1_R1_O = 4'h9; // B           LDB (imm)
    8'hC8 : PG1_R1_O = 4'h9; // B           EORB (imm)
    8'hC9 : PG1_R1_O = 4'h9; // B           ADCB (imm)
    8'hCA : PG1_R1_O = 4'h9; // B           ORB (imm)
    8'hCB : PG1_R1_O = 4'h9; // B           ADDB (imm)
    8'hCC : PG1_R1_O = 4'h0; // D           LDD (imm)
    8'hCE : PG1_R1_O = 4'h3; // U           LDU (imm)
    8'hD0 : PG1_R1_O = 4'h9; // B           SUBB (dir idx ext)
    8'hD1 : PG1_R1_O = 4'h9; // B           CMPB (dir idx ext)
    8'hD2 : PG1_R1_O = 4'h9; // B           SBCB (dir idx ext)
    8'hD3 : PG1_R1_O = 4'h0; // D           ADDD (dir idx ext)
    8'hD4 : PG1_R1_O = 4'h9; // B           ANDB (dir idx ext)
    8'hD5 : PG1_R1_O = 4'h9; // B           BITB (dir idx ext)
    8'hD6 : PG1_R1_O = 4'h9; // B           LDB (dir idx ext)
    8'hD7 : PG1_R1_O = 4'h9; // B           STB (dir ext)
    8'hD8 : PG1_R1_O = 4'h9; // B           EORB (dir idx ext)
    8'hD9 : PG1_R1_O = 4'h9; // B           ADCB (dir idx ext)
    8'hDA : PG1_R1_O = 4'h9; // B           ORB (dir idx ext)
    8'hDB : PG1_R1_O = 4'h9; // B           ADDB (dir idx ext)
    8'hDC : PG1_R1_O = 4'h0; // D           LDD (dir idx ext)
    8'hDD : PG1_R1_O = 4'h0; // D           STD (dir ext)
    8'hDE : PG1_R1_O = 4'h3; // U           LDU (dir idx ext)
    8'hDF : PG1_R1_O = 4'h3; // U           STU (dir ext)
    8'hE0 : PG1_R1_O = 4'h9; // B           SUBB (dir idx ext)
    8'hE1 : PG1_R1_O = 4'h9; // B           CMPB (dir idx ext)
    8'hE2 : PG1_R1_O = 4'h9; // B           SBCB (dir idx ext)
    8'hE3 : PG1_R1_O = 4'h0; // D           ADDD (dir idx ext)
    8'hE4 : PG1_R1_O = 4'h9; // B           ANDB (dir idx ext)
    8'hE5 : PG1_R1_O = 4'h9; // B           BITB (dir idx ext)
    8'hE6 : PG1_R1_O = 4'h9; // B           LDB (dir idx ext)
    8'hE7 : PG1_R1_O = 4'h9; // B           STB (idx)
    8'hE8 : PG1_R1_O = 4'h9; // B           EORB (dir idx ext)
    8'hE9 : PG1_R1_O = 4'h9; // B           ADCB (dir idx ext)
    8'hEA : PG1_R1_O = 4'h9; // B           ORB (dir idx ext)
    8'hEB : PG1_R1_O = 4'h9; // B           ADDB (dir idx ext)
    8'hEC : PG1_R1_O = 4'h0; // D           LDD (dir idx ext)
    8'hED : PG1_R1_O = 4'h0; // D           STD (idx)
    8'hEE : PG1_R1_O = 4'h3; // U           LDU (dir idx ext)
    8'hEF : PG1_R1_O = 4'h3; // U           STU (idx)
    8'hF0 : PG1_R1_O = 4'h9; // B           SUBB (dir idx ext)
    8'hF1 : PG1_R1_O = 4'h9; // B           CMPB (dir idx ext)
    8'hF2 : PG1_R1_O = 4'h9; // B           SBCB (dir idx ext)
    8'hF3 : PG1_R1_O = 4'h0; // D           ADDD (dir idx ext)
    8'hF4 : PG1_R1_O = 4'h9; // B           ANDB (dir idx ext)
    8'hF5 : PG1_R1_O = 4'h9; // B           BITB (dir idx ext)
    8'hF6 : PG1_R1_O = 4'h9; // B           LDB (dir idx ext)
    8'hF7 : PG1_R1_O = 4'h9; // B           STB (dir ext)
    8'hF8 : PG1_R1_O = 4'h9; // B           EORB (dir idx ext)
    8'hF9 : PG1_R1_O = 4'h9; // B           ADCB (dir idx ext)
    8'hFA : PG1_R1_O = 4'h9; // B           ORB (dir idx ext)
    8'hFB : PG1_R1_O = 4'h9; // B           ADDB (dir idx ext)
    8'hFC : PG1_R1_O = 4'h0; // D           LDD (dir idx ext)
    8'hFD : PG1_R1_O = 4'h0; // D           STD (dir ext)
    8'hFE : PG1_R1_O = 4'h3; // U           LDU (dir idx ext)
    8'hFF : PG1_R1_O = 4'h3; // U           STU (dir ext)
    default : PG1_R1_O = 4'hx; // from decode_init
  endcase
end

`ifdef SIM_TURBO9

reg [(8*64):0] PG1_R1_op;

always @* begin
  case (OPCODE_I)
    8'h00 : PG1_R1_op = "NEG (dir idx ext) sets 8bit width";
    8'h03 : PG1_R1_op = "COM (dir idx ext) sets 8bit width";
    8'h04 : PG1_R1_op = "LSR (dir idx ext)";
    8'h06 : PG1_R1_op = "ROR (dir idx ext)";
    8'h07 : PG1_R1_op = "ASR (dir idx ext)";
    8'h08 : PG1_R1_op = "ASL LSL (dir idx ext)";
    8'h09 : PG1_R1_op = "ROL (dir idx ext)";
    8'h0A : PG1_R1_op = "DEC (dir idx ext)";
    8'h0C : PG1_R1_op = "INC (dir idx ext)";
    8'h0D : PG1_R1_op = "TST (dir idx ext)";
    8'h0E : PG1_R1_op = "JMP (dir ext)";
    8'h0F : PG1_R1_op = "CLR (dir ext) sets 8bit width";
    8'h14 : PG1_R1_op = "EMUL (inh)";
    8'h16 : PG1_R1_op = "LBRA ";
    8'h17 : PG1_R1_op = "BSR LBSR";
    8'h18 : PG1_R1_op = "IDIV (inh)";
    8'h19 : PG1_R1_op = "DAA (inh)";
    8'h1A : PG1_R1_op = "ORCC (imm)";
    8'h1C : PG1_R1_op = "ANDCC (imm)";
    8'h1D : PG1_R1_op = "SEX(inh)";
    8'h20 : PG1_R1_op = "BRA BRN BHI BLS";
    8'h21 : PG1_R1_op = "BRA BRN BHI BLS";
    8'h22 : PG1_R1_op = "BRA BRN BHI BLS";
    8'h23 : PG1_R1_op = "BRA BRN BHI BLS";
    8'h24 : PG1_R1_op = "BCC BCS BNE BEQ";
    8'h25 : PG1_R1_op = "BCC BCS BNE BEQ";
    8'h26 : PG1_R1_op = "BCC BCS BNE BEQ";
    8'h27 : PG1_R1_op = "BCC BCS BNE BEQ";
    8'h28 : PG1_R1_op = "BVC BVS BPL BMI";
    8'h29 : PG1_R1_op = "BVC BVS BPL BMI";
    8'h2A : PG1_R1_op = "BVC BVS BPL BMI";
    8'h2B : PG1_R1_op = "BVC BVS BPL BMI";
    8'h2C : PG1_R1_op = "BGE BLT BGT BLE";
    8'h2D : PG1_R1_op = "BGE BLT BGT BLE";
    8'h2E : PG1_R1_op = "BGE BLT BGT BLE";
    8'h2F : PG1_R1_op = "BGE BLT BGT BLE";
    8'h30 : PG1_R1_op = "LEAX(inh)";
    8'h31 : PG1_R1_op = "LEAY(inh)";
    8'h32 : PG1_R1_op = "LEAS(inh)";
    8'h33 : PG1_R1_op = "LEAU(inh)";
    8'h39 : PG1_R1_op = "RTS";
    8'h3A : PG1_R1_op = "ABX(inh)";
    8'h3B : PG1_R1_op = "RTI";
    8'h3D : PG1_R1_op = "MUL (inh)";
    8'h3F : PG1_R1_op = "SWI";
    8'h40 : PG1_R1_op = "NEGA (inh)";
    8'h43 : PG1_R1_op = "COMA (inh)";
    8'h44 : PG1_R1_op = "LSRA (inh)";
    8'h46 : PG1_R1_op = "RORA (inh)";
    8'h47 : PG1_R1_op = "ASRA (inh)";
    8'h48 : PG1_R1_op = "ASLA LSLA (inh)";
    8'h49 : PG1_R1_op = "ROLA (inh)";
    8'h4A : PG1_R1_op = "DECA (inh)";
    8'h4C : PG1_R1_op = "INCA (inh)";
    8'h4D : PG1_R1_op = "TSTA (inh)";
    8'h4F : PG1_R1_op = "CLRA (inh)";
    8'h50 : PG1_R1_op = "NEGB (inh)";
    8'h53 : PG1_R1_op = "COMB (inh)";
    8'h54 : PG1_R1_op = "LSRB (inh)";
    8'h56 : PG1_R1_op = "RORB (inh)";
    8'h57 : PG1_R1_op = "ASRB (inh)";
    8'h58 : PG1_R1_op = "ASLB LSLB (inh)";
    8'h59 : PG1_R1_op = "ROLB (inh)";
    8'h5A : PG1_R1_op = "DECB (inh)";
    8'h5C : PG1_R1_op = "INCB (inh)";
    8'h5D : PG1_R1_op = "TSTB (inh)";
    8'h5F : PG1_R1_op = "CLRB (inh)";
    8'h60 : PG1_R1_op = "NEG (dir idx ext) sets 8bit width";
    8'h63 : PG1_R1_op = "COM (dir idx ext) sets 8bit width";
    8'h64 : PG1_R1_op = "LSR (dir idx ext)";
    8'h66 : PG1_R1_op = "ROR (dir idx ext)";
    8'h67 : PG1_R1_op = "ASR (dir idx ext)";
    8'h68 : PG1_R1_op = "ASL LSL (dir idx ext)";
    8'h69 : PG1_R1_op = "ROL (dir idx ext)";
    8'h6A : PG1_R1_op = "DEC (dir idx ext)";
    8'h6C : PG1_R1_op = "INC (dir idx ext)";
    8'h6D : PG1_R1_op = "TST (dir idx ext)";
    8'h6E : PG1_R1_op = "JMP (idx)";
    8'h6F : PG1_R1_op = "CLR (idx) sets 8bit width";
    8'h70 : PG1_R1_op = "NEG (dir idx ext) sets 8bit width";
    8'h73 : PG1_R1_op = "COM (dir idx ext) sets 8bit width";
    8'h74 : PG1_R1_op = "LSR (dir idx ext)";
    8'h76 : PG1_R1_op = "ROR (dir idx ext)";
    8'h77 : PG1_R1_op = "ASR (dir idx ext)";
    8'h78 : PG1_R1_op = "ASL LSL (dir idx ext)";
    8'h79 : PG1_R1_op = "ROL (dir idx ext)";
    8'h7A : PG1_R1_op = "DEC (dir idx ext)";
    8'h7C : PG1_R1_op = "INC (dir idx ext)";
    8'h7D : PG1_R1_op = "TST (dir idx ext)";
    8'h7E : PG1_R1_op = "JMP (dir ext)";
    8'h7F : PG1_R1_op = "CLR (dir ext) sets 8bit width";
    8'h80 : PG1_R1_op = "SUBA (imm)";
    8'h81 : PG1_R1_op = "CMPA (imm)";
    8'h82 : PG1_R1_op = "SBCA (imm)";
    8'h83 : PG1_R1_op = "SUBD (imm)";
    8'h84 : PG1_R1_op = "ANDA (imm)";
    8'h85 : PG1_R1_op = "BITA (imm)";
    8'h86 : PG1_R1_op = "LDA (imm)";
    8'h88 : PG1_R1_op = "EORA (imm)";
    8'h89 : PG1_R1_op = "ADCA (imm)";
    8'h8A : PG1_R1_op = "ORA (imm)";
    8'h8B : PG1_R1_op = "ADDA (imm)";
    8'h8C : PG1_R1_op = "CMPX (imm)";
    8'h8D : PG1_R1_op = "BSR LBSR";
    8'h8E : PG1_R1_op = "LDX (imm)";
    8'h90 : PG1_R1_op = "SUBA (dir idx ext)";
    8'h91 : PG1_R1_op = "CMPA (dir idx ext)";
    8'h92 : PG1_R1_op = "SBCA (dir idx ext)";
    8'h93 : PG1_R1_op = "SUBD (dir idx ext)";
    8'h94 : PG1_R1_op = "ANDA (dir idx ext)";
    8'h95 : PG1_R1_op = "BITA (dir idx ext)";
    8'h96 : PG1_R1_op = "LDA (dir idx ext)";
    8'h97 : PG1_R1_op = "STA (dir ext)";
    8'h98 : PG1_R1_op = "EORA (dir idx ext)";
    8'h99 : PG1_R1_op = "ADCA (dir idx ext)";
    8'h9A : PG1_R1_op = "ORA (dir idx ext)";
    8'h9B : PG1_R1_op = "ADDA (dir idx ext)";
    8'h9C : PG1_R1_op = "CMPX (dir idx ext)";
    8'h9D : PG1_R1_op = "JSR (dir ext)";
    8'h9E : PG1_R1_op = "LDX (dir idx ext)";
    8'h9F : PG1_R1_op = "STX (dir ext)";
    8'hA0 : PG1_R1_op = "SUBA (dir idx ext)";
    8'hA1 : PG1_R1_op = "CMPA (dir idx ext)";
    8'hA2 : PG1_R1_op = "SBCA (dir idx ext)";
    8'hA3 : PG1_R1_op = "SUBD (dir idx ext)";
    8'hA4 : PG1_R1_op = "ANDA (dir idx ext)";
    8'hA5 : PG1_R1_op = "BITA (dir idx ext)";
    8'hA6 : PG1_R1_op = "LDA (dir idx ext)";
    8'hA7 : PG1_R1_op = "STA (idx)";
    8'hA8 : PG1_R1_op = "EORA (dir idx ext)";
    8'hA9 : PG1_R1_op = "ADCA (dir idx ext)";
    8'hAA : PG1_R1_op = "ORA (dir idx ext)";
    8'hAB : PG1_R1_op = "ADDA (dir idx ext)";
    8'hAC : PG1_R1_op = "CMPX (dir idx ext)";
    8'hAD : PG1_R1_op = "JSR (idx)";
    8'hAE : PG1_R1_op = "LDX (dir idx ext)";
    8'hAF : PG1_R1_op = "STX (idx)";
    8'hB0 : PG1_R1_op = "SUBA (dir idx ext)";
    8'hB1 : PG1_R1_op = "CMPA (dir idx ext)";
    8'hB2 : PG1_R1_op = "SBCA (dir idx ext)";
    8'hB3 : PG1_R1_op = "SUBD (dir idx ext)";
    8'hB4 : PG1_R1_op = "ANDA (dir idx ext)";
    8'hB5 : PG1_R1_op = "BITA (dir idx ext)";
    8'hB6 : PG1_R1_op = "LDA (dir idx ext)";
    8'hB7 : PG1_R1_op = "STA (dir ext)";
    8'hB8 : PG1_R1_op = "EORA (dir idx ext)";
    8'hB9 : PG1_R1_op = "ADCA (dir idx ext)";
    8'hBA : PG1_R1_op = "ORA (dir idx ext)";
    8'hBB : PG1_R1_op = "ADDA (dir idx ext)";
    8'hBC : PG1_R1_op = "CMPX (dir idx ext)";
    8'hBD : PG1_R1_op = "JSR (dir ext)";
    8'hBE : PG1_R1_op = "LDX (dir idx ext)";
    8'hBF : PG1_R1_op = "STX (dir ext)";
    8'hC0 : PG1_R1_op = "SUBB (imm)";
    8'hC1 : PG1_R1_op = "CMPB (imm)";
    8'hC2 : PG1_R1_op = "SBCB (imm)";
    8'hC3 : PG1_R1_op = "ADDD (imm)";
    8'hC4 : PG1_R1_op = "ANDB (imm)";
    8'hC5 : PG1_R1_op = "BITB (imm)";
    8'hC6 : PG1_R1_op = "LDB (imm)";
    8'hC8 : PG1_R1_op = "EORB (imm)";
    8'hC9 : PG1_R1_op = "ADCB (imm)";
    8'hCA : PG1_R1_op = "ORB (imm)";
    8'hCB : PG1_R1_op = "ADDB (imm)";
    8'hCC : PG1_R1_op = "LDD (imm)";
    8'hCE : PG1_R1_op = "LDU (imm)";
    8'hD0 : PG1_R1_op = "SUBB (dir idx ext)";
    8'hD1 : PG1_R1_op = "CMPB (dir idx ext)";
    8'hD2 : PG1_R1_op = "SBCB (dir idx ext)";
    8'hD3 : PG1_R1_op = "ADDD (dir idx ext)";
    8'hD4 : PG1_R1_op = "ANDB (dir idx ext)";
    8'hD5 : PG1_R1_op = "BITB (dir idx ext)";
    8'hD6 : PG1_R1_op = "LDB (dir idx ext)";
    8'hD7 : PG1_R1_op = "STB (dir ext)";
    8'hD8 : PG1_R1_op = "EORB (dir idx ext)";
    8'hD9 : PG1_R1_op = "ADCB (dir idx ext)";
    8'hDA : PG1_R1_op = "ORB (dir idx ext)";
    8'hDB : PG1_R1_op = "ADDB (dir idx ext)";
    8'hDC : PG1_R1_op = "LDD (dir idx ext)";
    8'hDD : PG1_R1_op = "STD (dir ext)";
    8'hDE : PG1_R1_op = "LDU (dir idx ext)";
    8'hDF : PG1_R1_op = "STU (dir ext)";
    8'hE0 : PG1_R1_op = "SUBB (dir idx ext)";
    8'hE1 : PG1_R1_op = "CMPB (dir idx ext)";
    8'hE2 : PG1_R1_op = "SBCB (dir idx ext)";
    8'hE3 : PG1_R1_op = "ADDD (dir idx ext)";
    8'hE4 : PG1_R1_op = "ANDB (dir idx ext)";
    8'hE5 : PG1_R1_op = "BITB (dir idx ext)";
    8'hE6 : PG1_R1_op = "LDB (dir idx ext)";
    8'hE7 : PG1_R1_op = "STB (idx)";
    8'hE8 : PG1_R1_op = "EORB (dir idx ext)";
    8'hE9 : PG1_R1_op = "ADCB (dir idx ext)";
    8'hEA : PG1_R1_op = "ORB (dir idx ext)";
    8'hEB : PG1_R1_op = "ADDB (dir idx ext)";
    8'hEC : PG1_R1_op = "LDD (dir idx ext)";
    8'hED : PG1_R1_op = "STD (idx)";
    8'hEE : PG1_R1_op = "LDU (dir idx ext)";
    8'hEF : PG1_R1_op = "STU (idx)";
    8'hF0 : PG1_R1_op = "SUBB (dir idx ext)";
    8'hF1 : PG1_R1_op = "CMPB (dir idx ext)";
    8'hF2 : PG1_R1_op = "SBCB (dir idx ext)";
    8'hF3 : PG1_R1_op = "ADDD (dir idx ext)";
    8'hF4 : PG1_R1_op = "ANDB (dir idx ext)";
    8'hF5 : PG1_R1_op = "BITB (dir idx ext)";
    8'hF6 : PG1_R1_op = "LDB (dir idx ext)";
    8'hF7 : PG1_R1_op = "STB (dir ext)";
    8'hF8 : PG1_R1_op = "EORB (dir idx ext)";
    8'hF9 : PG1_R1_op = "ADCB (dir idx ext)";
    8'hFA : PG1_R1_op = "ORB (dir idx ext)";
    8'hFB : PG1_R1_op = "ADDB (dir idx ext)";
    8'hFC : PG1_R1_op = "LDD (dir idx ext)";
    8'hFD : PG1_R1_op = "STD (dir ext)";
    8'hFE : PG1_R1_op = "LDU (dir idx ext)";
    8'hFF : PG1_R1_op = "STU (dir ext)";
    default : PG1_R1_op = "invalid";
  endcase
end

reg [(8*64):0] PG1_R1_eq;

always @* begin
  case (OPCODE_I)
    8'h00 : PG1_R1_eq = "DMEM_RD";
    8'h03 : PG1_R1_eq = "DMEM_RD";
    8'h04 : PG1_R1_eq = "DMEM_RD";
    8'h06 : PG1_R1_eq = "DMEM_RD";
    8'h07 : PG1_R1_eq = "DMEM_RD";
    8'h08 : PG1_R1_eq = "DMEM_RD";
    8'h09 : PG1_R1_eq = "DMEM_RD";
    8'h0A : PG1_R1_eq = "DMEM_RD";
    8'h0C : PG1_R1_eq = "DMEM_RD";
    8'h0D : PG1_R1_eq = "DMEM_RD";
    8'h0E : PG1_R1_eq = "PC";
    8'h0F : PG1_R1_eq = "DMEM_RD";
    8'h14 : PG1_R1_eq = "D";
    8'h16 : PG1_R1_eq = "PC";
    8'h17 : PG1_R1_eq = "PC";
    8'h18 : PG1_R1_eq = "X";
    8'h19 : PG1_R1_eq = "D";
    8'h1A : PG1_R1_eq = "CCR";
    8'h1C : PG1_R1_eq = "CCR";
    8'h1D : PG1_R1_eq = "D";
    8'h20 : PG1_R1_eq = "PC";
    8'h21 : PG1_R1_eq = "PC";
    8'h22 : PG1_R1_eq = "PC";
    8'h23 : PG1_R1_eq = "PC";
    8'h24 : PG1_R1_eq = "PC";
    8'h25 : PG1_R1_eq = "PC";
    8'h26 : PG1_R1_eq = "PC";
    8'h27 : PG1_R1_eq = "PC";
    8'h28 : PG1_R1_eq = "PC";
    8'h29 : PG1_R1_eq = "PC";
    8'h2A : PG1_R1_eq = "PC";
    8'h2B : PG1_R1_eq = "PC";
    8'h2C : PG1_R1_eq = "PC";
    8'h2D : PG1_R1_eq = "PC";
    8'h2E : PG1_R1_eq = "PC";
    8'h2F : PG1_R1_eq = "PC";
    8'h30 : PG1_R1_eq = "X";
    8'h31 : PG1_R1_eq = "Y";
    8'h32 : PG1_R1_eq = "S";
    8'h33 : PG1_R1_eq = "U";
    8'h39 : PG1_R1_eq = "PC";
    8'h3A : PG1_R1_eq = "X";
    8'h3B : PG1_R1_eq = "PC";
    8'h3D : PG1_R1_eq = "D";
    8'h3F : PG1_R1_eq = "PC";
    8'h40 : PG1_R1_eq = "A";
    8'h43 : PG1_R1_eq = "A";
    8'h44 : PG1_R1_eq = "A";
    8'h46 : PG1_R1_eq = "A";
    8'h47 : PG1_R1_eq = "A";
    8'h48 : PG1_R1_eq = "A";
    8'h49 : PG1_R1_eq = "A";
    8'h4A : PG1_R1_eq = "A";
    8'h4C : PG1_R1_eq = "A";
    8'h4D : PG1_R1_eq = "A";
    8'h4F : PG1_R1_eq = "A";
    8'h50 : PG1_R1_eq = "B";
    8'h53 : PG1_R1_eq = "B";
    8'h54 : PG1_R1_eq = "B";
    8'h56 : PG1_R1_eq = "B";
    8'h57 : PG1_R1_eq = "B";
    8'h58 : PG1_R1_eq = "B";
    8'h59 : PG1_R1_eq = "B";
    8'h5A : PG1_R1_eq = "B";
    8'h5C : PG1_R1_eq = "B";
    8'h5D : PG1_R1_eq = "B";
    8'h5F : PG1_R1_eq = "B";
    8'h60 : PG1_R1_eq = "DMEM_RD";
    8'h63 : PG1_R1_eq = "DMEM_RD";
    8'h64 : PG1_R1_eq = "DMEM_RD";
    8'h66 : PG1_R1_eq = "DMEM_RD";
    8'h67 : PG1_R1_eq = "DMEM_RD";
    8'h68 : PG1_R1_eq = "DMEM_RD";
    8'h69 : PG1_R1_eq = "DMEM_RD";
    8'h6A : PG1_R1_eq = "DMEM_RD";
    8'h6C : PG1_R1_eq = "DMEM_RD";
    8'h6D : PG1_R1_eq = "DMEM_RD";
    8'h6E : PG1_R1_eq = "PC";
    8'h6F : PG1_R1_eq = "DMEM_RD";
    8'h70 : PG1_R1_eq = "DMEM_RD";
    8'h73 : PG1_R1_eq = "DMEM_RD";
    8'h74 : PG1_R1_eq = "DMEM_RD";
    8'h76 : PG1_R1_eq = "DMEM_RD";
    8'h77 : PG1_R1_eq = "DMEM_RD";
    8'h78 : PG1_R1_eq = "DMEM_RD";
    8'h79 : PG1_R1_eq = "DMEM_RD";
    8'h7A : PG1_R1_eq = "DMEM_RD";
    8'h7C : PG1_R1_eq = "DMEM_RD";
    8'h7D : PG1_R1_eq = "DMEM_RD";
    8'h7E : PG1_R1_eq = "PC";
    8'h7F : PG1_R1_eq = "DMEM_RD";
    8'h80 : PG1_R1_eq = "A";
    8'h81 : PG1_R1_eq = "A";
    8'h82 : PG1_R1_eq = "A";
    8'h83 : PG1_R1_eq = "D";
    8'h84 : PG1_R1_eq = "A";
    8'h85 : PG1_R1_eq = "A";
    8'h86 : PG1_R1_eq = "A";
    8'h88 : PG1_R1_eq = "A";
    8'h89 : PG1_R1_eq = "A";
    8'h8A : PG1_R1_eq = "A";
    8'h8B : PG1_R1_eq = "A";
    8'h8C : PG1_R1_eq = "X";
    8'h8D : PG1_R1_eq = "PC";
    8'h8E : PG1_R1_eq = "X";
    8'h90 : PG1_R1_eq = "A";
    8'h91 : PG1_R1_eq = "A";
    8'h92 : PG1_R1_eq = "A";
    8'h93 : PG1_R1_eq = "D";
    8'h94 : PG1_R1_eq = "A";
    8'h95 : PG1_R1_eq = "A";
    8'h96 : PG1_R1_eq = "A";
    8'h97 : PG1_R1_eq = "A";
    8'h98 : PG1_R1_eq = "A";
    8'h99 : PG1_R1_eq = "A";
    8'h9A : PG1_R1_eq = "A";
    8'h9B : PG1_R1_eq = "A";
    8'h9C : PG1_R1_eq = "X";
    8'h9D : PG1_R1_eq = "PC";
    8'h9E : PG1_R1_eq = "X";
    8'h9F : PG1_R1_eq = "X";
    8'hA0 : PG1_R1_eq = "A";
    8'hA1 : PG1_R1_eq = "A";
    8'hA2 : PG1_R1_eq = "A";
    8'hA3 : PG1_R1_eq = "D";
    8'hA4 : PG1_R1_eq = "A";
    8'hA5 : PG1_R1_eq = "A";
    8'hA6 : PG1_R1_eq = "A";
    8'hA7 : PG1_R1_eq = "A";
    8'hA8 : PG1_R1_eq = "A";
    8'hA9 : PG1_R1_eq = "A";
    8'hAA : PG1_R1_eq = "A";
    8'hAB : PG1_R1_eq = "A";
    8'hAC : PG1_R1_eq = "X";
    8'hAD : PG1_R1_eq = "PC";
    8'hAE : PG1_R1_eq = "X";
    8'hAF : PG1_R1_eq = "X";
    8'hB0 : PG1_R1_eq = "A";
    8'hB1 : PG1_R1_eq = "A";
    8'hB2 : PG1_R1_eq = "A";
    8'hB3 : PG1_R1_eq = "D";
    8'hB4 : PG1_R1_eq = "A";
    8'hB5 : PG1_R1_eq = "A";
    8'hB6 : PG1_R1_eq = "A";
    8'hB7 : PG1_R1_eq = "A";
    8'hB8 : PG1_R1_eq = "A";
    8'hB9 : PG1_R1_eq = "A";
    8'hBA : PG1_R1_eq = "A";
    8'hBB : PG1_R1_eq = "A";
    8'hBC : PG1_R1_eq = "X";
    8'hBD : PG1_R1_eq = "PC";
    8'hBE : PG1_R1_eq = "X";
    8'hBF : PG1_R1_eq = "X";
    8'hC0 : PG1_R1_eq = "B";
    8'hC1 : PG1_R1_eq = "B";
    8'hC2 : PG1_R1_eq = "B";
    8'hC3 : PG1_R1_eq = "D";
    8'hC4 : PG1_R1_eq = "B";
    8'hC5 : PG1_R1_eq = "B";
    8'hC6 : PG1_R1_eq = "B";
    8'hC8 : PG1_R1_eq = "B";
    8'hC9 : PG1_R1_eq = "B";
    8'hCA : PG1_R1_eq = "B";
    8'hCB : PG1_R1_eq = "B";
    8'hCC : PG1_R1_eq = "D";
    8'hCE : PG1_R1_eq = "U";
    8'hD0 : PG1_R1_eq = "B";
    8'hD1 : PG1_R1_eq = "B";
    8'hD2 : PG1_R1_eq = "B";
    8'hD3 : PG1_R1_eq = "D";
    8'hD4 : PG1_R1_eq = "B";
    8'hD5 : PG1_R1_eq = "B";
    8'hD6 : PG1_R1_eq = "B";
    8'hD7 : PG1_R1_eq = "B";
    8'hD8 : PG1_R1_eq = "B";
    8'hD9 : PG1_R1_eq = "B";
    8'hDA : PG1_R1_eq = "B";
    8'hDB : PG1_R1_eq = "B";
    8'hDC : PG1_R1_eq = "D";
    8'hDD : PG1_R1_eq = "D";
    8'hDE : PG1_R1_eq = "U";
    8'hDF : PG1_R1_eq = "U";
    8'hE0 : PG1_R1_eq = "B";
    8'hE1 : PG1_R1_eq = "B";
    8'hE2 : PG1_R1_eq = "B";
    8'hE3 : PG1_R1_eq = "D";
    8'hE4 : PG1_R1_eq = "B";
    8'hE5 : PG1_R1_eq = "B";
    8'hE6 : PG1_R1_eq = "B";
    8'hE7 : PG1_R1_eq = "B";
    8'hE8 : PG1_R1_eq = "B";
    8'hE9 : PG1_R1_eq = "B";
    8'hEA : PG1_R1_eq = "B";
    8'hEB : PG1_R1_eq = "B";
    8'hEC : PG1_R1_eq = "D";
    8'hED : PG1_R1_eq = "D";
    8'hEE : PG1_R1_eq = "U";
    8'hEF : PG1_R1_eq = "U";
    8'hF0 : PG1_R1_eq = "B";
    8'hF1 : PG1_R1_eq = "B";
    8'hF2 : PG1_R1_eq = "B";
    8'hF3 : PG1_R1_eq = "D";
    8'hF4 : PG1_R1_eq = "B";
    8'hF5 : PG1_R1_eq = "B";
    8'hF6 : PG1_R1_eq = "B";
    8'hF7 : PG1_R1_eq = "B";
    8'hF8 : PG1_R1_eq = "B";
    8'hF9 : PG1_R1_eq = "B";
    8'hFA : PG1_R1_eq = "B";
    8'hFB : PG1_R1_eq = "B";
    8'hFC : PG1_R1_eq = "D";
    8'hFD : PG1_R1_eq = "D";
    8'hFE : PG1_R1_eq = "U";
    8'hFF : PG1_R1_eq = "U";
    default : PG1_R1_eq = "invalid";
  endcase
end

`endif

/////////////////////////////////////////////////////////////////////////////

endmodule

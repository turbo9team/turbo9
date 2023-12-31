// [TURBO9_MICROCODE_HEADER_START]
//////////////////////////////////////////////////////////////////////////////
//                          Turbo9 Microprocessor IP
//////////////////////////////////////////////////////////////////////////////
// Website: www.turbo9.org
// Contact: team[at]turbo9[dot]org
//////////////////////////////////////////////////////////////////////////////
// [TURBO9_MICROCODE_LICENSE_START]
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
// [TURBO9_MICROCODE_LICENSE_END]
//////////////////////////////////////////////////////////////////////////////
// Engineer: Kevin Phillipson & Michael Rywalt
// Description:
// Assembled from turbo9_urtl.asm file

//
//////////////////////////////////////////////////////////////////////////////
// History:
// 07.14.2023 - Kevin Phillipson
//   File header added
//
//////////////////////////////////////////////////////////////////////////////
// [TURBO9_MICROCODE_HEADER_END]

/////////////////////////////////////////////////////////////////////////////
//                                MODULE
/////////////////////////////////////////////////////////////////////////////
module turbo9_urtl_microcode
(
  // Inputs:
  input     [8:0] MICROCODE_ADR_I,

  // Control Vectors
  output reg [2:0] CV_MICRO_SEQ_OP_O,
  output reg [7:0] CV_MICRO_SEQ_BRANCH_ADDR_O,
  output reg [3:0] CV_DATA_ALU_A_SEL_O,
  output reg [2:0] CV_DATA_ALU_B_SEL_O,
  output reg [3:0] CV_DATA_ALU_WR_SEL_O,
  output reg [3:0] CV_ADDR_ALU_REG_SEL_O,
  output reg [2:0] CV_DATA_ALU_OP_O,
  output reg [2:0] CV_DATA_WIDTH_SEL_O,
  output reg [0:0] CV_DATA_ALU_SAU_EN_O,
  output reg [3:0] CV_CCR_OP_O,
  output reg [1:0] CV_DATA_ALU_COND_SEL_O,
  output reg [3:0] CV_MICRO_SEQ_COND_SEL_O,
  output reg [1:0] CV_DMEM_OP_O,
  output reg [1:0] CV_STACK_OP_O 
);


/////////////////////////////////////////////////////////////////////////////
//                                  MICROCODE
/////////////////////////////////////////////////////////////////////////////

always @* begin
  //
  // Control Logic Defaults
  CV_MICRO_SEQ_OP_O = 3'h0;  // OP_CONTINUE
  CV_MICRO_SEQ_BRANCH_ADDR_O = 8'h0;  // RESET
  CV_DATA_ALU_A_SEL_O = 4'hf;  // ZERO
  CV_DATA_ALU_B_SEL_O = 3'h7;  // ZERO
  CV_DATA_ALU_WR_SEL_O = 4'hf;  // ZERO
  CV_ADDR_ALU_REG_SEL_O = 4'hf;  // ZERO
  CV_DATA_ALU_OP_O = 3'h0;  // A_PLUS_B
  CV_DATA_WIDTH_SEL_O = 3'h0;  // W_R1
  CV_DATA_ALU_SAU_EN_O = 1'h0;  // FALSE
  CV_CCR_OP_O = 4'h0;  // OP_OOOOOOOO
  CV_DATA_ALU_COND_SEL_O = 2'h0;  // ZERO_BIT
  CV_MICRO_SEQ_COND_SEL_O = 4'h1;  // TRUE
  CV_DMEM_OP_O = 2'h0;  // DMEM_OP_IDLE
  CV_STACK_OP_O = 2'h0;  // STACK_OP_IDLE
  //
  // Decode Microcode Address
  case (MICROCODE_ADR_I)

    // 0001: ; [TURBO9_HEADER_START]
    // 0002: ; ////////////////////////////////////////////////////////////////////////////
    // 0003: ;                          Turbo9 Microprocessor IP
    // 0004: ; ////////////////////////////////////////////////////////////////////////////
    // 0005: ; Website: www.turbo9.org
    // 0006: ; Contact: team[at]turbo9[dot]org
    // 0007: ; ////////////////////////////////////////////////////////////////////////////
    // 0008: ; [TURBO9_LICENSE_START]
    // 0009: ; BSD-1-Clause
    // 0010: ;
    // 0011: ; Copyright (c) 2020-2023
    // 0012: ; Kevin Phillipson
    // 0013: ; Michael Rywalt
    // 0014: ; All rights reserved.
    // 0015: ;
    // 0016: ; Redistribution and use in source and binary forms, with or without
    // 0017: ; modification, are permitted provided that the following conditions are met:
    // 0018: ;
    // 0019: ; 1. Redistributions of source code must retain the above copyright notice,
    // 0020: ;    this list of conditions and the following disclaimer.
    // 0021: ;
    // 0022: ; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
    // 0023: ; AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
    // 0024: ; IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
    // 0025: ; ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS AND CONTRIBUTORS BE
    // 0026: ; LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
    // 0027: ; CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
    // 0028: ; SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
    // 0029: ; INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
    // 0030: ; CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
    // 0031: ; ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
    // 0032: ; POSSIBILITY OF SUCH DAMAGE.
    // 0033: ; [TURBO9_LICENSE_END]
    // 0034: ; ////////////////////////////////////////////////////////////////////////////
    // 0035: ; Engineer: Kevin Phillipson
    // 0036: ; Description: Turbo9 uRTL microcode 
    // 0037: ;
    // 0038: ; ////////////////////////////////////////////////////////////////////////////
    // 0039: ; History:
    // 0040: ; 07.14.2023 - Kevin Phillipson
    // 0041: ;   File header added
    // 0042: ;
    // 0043: ; ////////////////////////////////////////////////////////////////////////////
    // 0044: ; [TURBO9_HEADER_END]
    // 0045: 
    // 0046: ; decode_init <tablename> <ctrl_vec> <default_string> ; Comment
    // 0047: 
    // 0048:   ; Jump Table A
    // 0049:   decode_init pg1_JTA cv_MICRO_SEQ_BRANCH_ADDR FF ; Page 1
    // 0050:   decode_init pg2_JTA cv_MICRO_SEQ_BRANCH_ADDR FF ; Page 2
    // 0051:   decode_init pg3_JTA cv_MICRO_SEQ_BRANCH_ADDR FF ; Page 3
    // 0052:   
    // 0053:   ; Jump Table B
    // 0054:   decode_init pg1_JTB cv_MICRO_SEQ_BRANCH_ADDR FF ; Page 1
    // 0055:   decode_init pg2_JTB cv_MICRO_SEQ_BRANCH_ADDR FF ; Page 2
    // 0056:   decode_init pg3_JTB cv_MICRO_SEQ_BRANCH_ADDR FF ; Page 3
    // 0057:   
    // 0058:   ; Register A Decode
    // 0059:   ; A side of ALU and ALU write
    // 0060:   decode_init pg1_R1  cv_R1_SEL x ; Page 1 
    // 0061:   decode_init pg2_R1  cv_R1_SEL x ; Page 2 
    // 0062:   decode_init pg3_R1  cv_R1_SEL x ; Page 3 
    // 0063: 
    // 0064:   ; Register B Decode
    // 0065:   ; B side of ALU
    // 0066:   decode_init pg1_R2  cv_R2_SEL x ; Page 1 
    // 0067:   decode_init pg2_R2  cv_R2_SEL x ; Page 2 
    // 0068:   decode_init pg3_R2  cv_R2_SEL x ; Page 3 
    // 0069: 
    // 0070:   ; Address Register Decode
    // 0071:   decode_init pg1_AR  cv_AR_SEL x ; Page 1 
    // 0072:   decode_init pg2_AR  cv_AR_SEL x ; Page 2 
    // 0073:   decode_init pg3_AR  cv_AR_SEL x ; Page 3 
    // 0074: 
    // 0075: ; decode <tablename> <equ> <opcode0...opcodeN> ; Comment
    // 0076: ;
    // 0077: ; EXAMPLE:
    // 0078: ; decode pg1_JTA ABX $3A ; ABX(inh)
    // 0079: 
    // 0080: 
    // 0081: 
    // 0082:   ORG  $00
    // 0083: RESET:
    // 0084:   ; R1 is reset to PC
    // 0085:   ; R2 is reset to DMEM_RD
    // 0086: 
    // 0087:   SET_DATA_WIDTH  W_16
    // 0088: 
    // 0089:   STACK_PUSH      ZERO ; a cute way of creating EA=$FFFE
    // 0090:   DMEM_LOAD_W
    // 0091: 
    // 0092:   JUMP            JMP
    // 0093:   end_state
    9'h000: begin
      CV_MICRO_SEQ_OP_O = 3'h1;  // OP_JUMP
      CV_MICRO_SEQ_BRANCH_ADDR_O = 8'h30;  // JMP
      CV_ADDR_ALU_REG_SEL_O = 4'hf;  // ZERO
      CV_DATA_WIDTH_SEL_O = 3'h3;  // W_16
      CV_DMEM_OP_O = 2'h2;  // DMEM_OP_RD
      CV_STACK_OP_O = 2'h2;  // STACK_OP_PUSH
    end


    // 0094: 
    // 0095: ; ////////////////////////////////////////////////////////////////////////////
    // 0096: ;                           LOAD ADDRESSING MODES
    // 0097: ; ////////////////////////////////////////////////////////////////////////////
    // 0098: ; //
    // 0099: LD_DIR_EXT:
    // 0100:   decode pg1_JTA LD_DIR_EXT $99 $B9 ; ADCA (dir ext)
    // 0101:   decode pg1_JTA LD_DIR_EXT $D9 $F9 ; ADCB (dir ext)
    // 0102:   ;                               
    // 0103:   decode pg1_JTA LD_DIR_EXT $9B $BB ; ADDA (dir ext)
    // 0104:   decode pg1_JTA LD_DIR_EXT $DB $FB ; ADDB (dir ext)
    // 0105:   decode pg1_JTA LD_DIR_EXT $D3 $F3 ; ADDD (dir ext)
    // 0106: ; //                              
    // 0107:   decode pg1_JTA LD_DIR_EXT $94 $B4 ; ANDA (dir ext)
    // 0108:   decode pg1_JTA LD_DIR_EXT $D4 $F4 ; ANDB (dir ext)
    // 0109: ; //                              
    // 0110:   decode pg1_JTA LD_DIR_EXT $08 $78 ; ASL LSL (dir ext)
    // 0111: ; //                              
    // 0112:   decode pg1_JTA LD_DIR_EXT $07 $77 ; ASR (dir ext)
    // 0113: ; //                              
    // 0114:   decode pg1_JTA LD_DIR_EXT $95 $B5 ; BITA (dir ext)
    // 0115:   decode pg1_JTA LD_DIR_EXT $D5 $F5 ; BITB (dir ext)
    // 0116: ; //                              
    // 0117:   decode pg1_JTA LD_DIR_EXT $91 $B1 ; CMPA (dir ext)
    // 0118:   decode pg1_JTA LD_DIR_EXT $D1 $F1 ; CMPB (dir ext)
    // 0119:   decode pg2_JTA LD_DIR_EXT $93 $B3 ; CMPD (dir ext)
    // 0120:   decode pg3_JTA LD_DIR_EXT $9C $BC ; CMPS (dir ext)
    // 0121:   decode pg3_JTA LD_DIR_EXT $93 $B3 ; CMPU (dir ext)
    // 0122:   decode pg1_JTA LD_DIR_EXT $9C $BC ; CMPX (dir ext)
    // 0123:   decode pg2_JTA LD_DIR_EXT $9C $BC ; CMPY (dir ext)
    // 0124: ; //                              
    // 0125:   decode pg1_JTA LD_DIR_EXT $03 $73 ; COM (dir ext)
    // 0126: ; //                              
    // 0127:   decode pg1_JTA LD_DIR_EXT $0A $7A ; DEC (dir ext)
    // 0128: ; //                              
    // 0129:   decode pg1_JTA LD_DIR_EXT $98 $B8 ; EORA (dir ext)
    // 0130:   decode pg1_JTA LD_DIR_EXT $D8 $F8 ; EORB (dir ext)
    // 0131: ; //                              
    // 0132:   decode pg1_JTA LD_DIR_EXT $0C $7C ; INC (dir ext)
    // 0133: ; //                              
    // 0134:   decode pg1_JTA LD_DIR_EXT $96 $B6 ; LDA (dir ext)
    // 0135:   decode pg1_JTA LD_DIR_EXT $D6 $F6 ; LDB (dir ext)
    // 0136:   decode pg1_JTA LD_DIR_EXT $DC $FC ; LDD (dir ext)
    // 0137:   decode pg2_JTA LD_DIR_EXT $DE $FE ; LDS (dir ext)
    // 0138:   decode pg1_JTA LD_DIR_EXT $DE $FE ; LDU (dir ext)
    // 0139:   decode pg1_JTA LD_DIR_EXT $9E $BE ; LDX (dir ext)
    // 0140:   decode pg2_JTA LD_DIR_EXT $9E $BE ; LDY (dir ext)
    // 0141: ; //                              
    // 0142:   decode pg1_JTA LD_DIR_EXT $04 $74 ; LSR (dir ext)
    // 0143: ; //                              
    // 0144:   decode pg1_JTA LD_DIR_EXT $00 $70 ; NEG (dir ext)
    // 0145: ; //                              
    // 0146:   decode pg1_JTA LD_DIR_EXT $9A $BA ; ORA (dir ext)
    // 0147:   decode pg1_JTA LD_DIR_EXT $DA $FA ; ORB (dir ext)
    // 0148: ; //                              
    // 0149:   decode pg1_JTA LD_DIR_EXT $09 $79 ; ROL (dir ext)
    // 0150:   decode pg1_JTA LD_DIR_EXT $06 $76 ; ROR (dir ext)
    // 0151: ; //                              
    // 0152:   decode pg1_JTA LD_DIR_EXT $92 $B2 ; SBCA (dir ext)
    // 0153:   decode pg1_JTA LD_DIR_EXT $D2 $F2 ; SBCB (dir ext)
    // 0154: ; //                              
    // 0155:   decode pg1_JTA LD_DIR_EXT $90 $B0 ; SUBA (dir ext)
    // 0156:   decode pg1_JTA LD_DIR_EXT $D0 $F0 ; SUBB (dir ext)
    // 0157:   decode pg1_JTA LD_DIR_EXT $93 $B3 ; SUBD (dir ext)
    // 0158: ; //                              
    // 0159:   decode pg1_JTA LD_DIR_EXT $0D $7D ; TST (dir ext)
    // 0160: 
    // 0161:   DATA_PASS_B     IDATA
    // 0162:   DATA_WRITE      EA
    // 0163: 
    // 0164:   SET_DATA_WIDTH  W_R1
    // 0165: 
    // 0166:   ADDR_PASS       IDATA
    // 0167:   DMEM_LOAD_W
    // 0168: 
    // 0169:   JUMP_TABLE_B
    // 0170:   end_state
    9'h001: begin
      CV_MICRO_SEQ_OP_O = 3'h4;  // OP_JUMP_TABLE_B
      CV_DATA_ALU_A_SEL_O = 4'hf;  // ZERO
      CV_DATA_ALU_B_SEL_O = 3'h6;  // IDATA
      CV_DATA_ALU_WR_SEL_O = 4'hc;  // EA
      CV_ADDR_ALU_REG_SEL_O = 4'he;  // IDATA
      CV_DATA_ALU_OP_O = 3'h0;  // A_PLUS_B
      CV_DATA_WIDTH_SEL_O = 3'h0;  // W_R1
      CV_DATA_ALU_COND_SEL_O = 2'h0;  // ZERO_BIT
      CV_DMEM_OP_O = 2'h2;  // DMEM_OP_RD
    end


    // 0171: 
    // 0172: 
    // 0173: LD_INDEXED:
    // 0174:   decode pg1_JTA LD_INDEXED $A9 ; ADCA (idx)
    // 0175:   decode pg1_JTA LD_INDEXED $E9 ; ADCB (idx)
    // 0176: ; //                            
    // 0177:   decode pg1_JTA LD_INDEXED $AB ; ADDA (idx)
    // 0178:   decode pg1_JTA LD_INDEXED $EB ; ADDB (idx)
    // 0179:   decode pg1_JTA LD_INDEXED $E3 ; ADDD (idx)
    // 0180: ; //                            
    // 0181:   decode pg1_JTA LD_INDEXED $A4 ; ANDA (idx)
    // 0182:   decode pg1_JTA LD_INDEXED $E4 ; ANDB (idx)
    // 0183: ; //                            
    // 0184:   decode pg1_JTA LD_INDEXED $68 ; ASL LSL (idx)
    // 0185: ; //                            
    // 0186:   decode pg1_JTA LD_INDEXED $67 ; ASR (idx)
    // 0187: ; //                            
    // 0188:   decode pg1_JTA LD_INDEXED $A5 ; BITA (idx)
    // 0189:   decode pg1_JTA LD_INDEXED $E5 ; BITB (idx)
    // 0190: ; //                            
    // 0191:   decode pg1_JTA LD_INDEXED $A1 ; CMPA (idx)
    // 0192:   decode pg1_JTA LD_INDEXED $E1 ; CMPB (idx)
    // 0193:   decode pg2_JTA LD_INDEXED $A3 ; CMPD (idx)
    // 0194:   decode pg3_JTA LD_INDEXED $AC ; CMPS (idx)
    // 0195:   decode pg3_JTA LD_INDEXED $A3 ; CMPU (idx)
    // 0196:   decode pg1_JTA LD_INDEXED $AC ; CMPX (idx)
    // 0197:   decode pg2_JTA LD_INDEXED $AC ; CMPY (idx)
    // 0198: ; //                            
    // 0199:   decode pg1_JTA LD_INDEXED $63 ; COM (idx)
    // 0200: ; //                            
    // 0201:   decode pg1_JTA LD_INDEXED $6A ; DEC (idx)
    // 0202: ; //                            
    // 0203:   decode pg1_JTA LD_INDEXED $A8 ; EORA (idx)
    // 0204:   decode pg1_JTA LD_INDEXED $E8 ; EORB (idx)
    // 0205: ; //                            
    // 0206:   decode pg1_JTA LD_INDEXED $6C ; INC (idx)
    // 0207: ; //                            
    // 0208:   decode pg1_JTA LD_INDEXED $A6 ; LDA (idx)
    // 0209:   decode pg1_JTA LD_INDEXED $E6 ; LDB (idx)
    // 0210:   decode pg1_JTA LD_INDEXED $EC ; LDD (idx)
    // 0211:   decode pg2_JTA LD_INDEXED $EE ; LDS (idx)
    // 0212:   decode pg1_JTA LD_INDEXED $EE ; LDU (idx)
    // 0213:   decode pg1_JTA LD_INDEXED $AE ; LDX (idx)
    // 0214:   decode pg2_JTA LD_INDEXED $AE ; LDY (idx)
    // 0215: ; //                            
    // 0216:   decode pg1_JTA LD_INDEXED $64 ; LSR (idx)
    // 0217: ; //                            
    // 0218:   decode pg1_JTA LD_INDEXED $60 ; NEG (idx)
    // 0219: ; //                            
    // 0220:   decode pg1_JTA LD_INDEXED $AA ; ORA (idx)
    // 0221:   decode pg1_JTA LD_INDEXED $EA ; ORB (idx)
    // 0222: ; //                            
    // 0223:   decode pg1_JTA LD_INDEXED $69 ; ROL (idx)
    // 0224:   decode pg1_JTA LD_INDEXED $66 ; ROR (idx)
    // 0225: ; //                            
    // 0226:   decode pg1_JTA LD_INDEXED $A2 ; SBCA (idx)
    // 0227:   decode pg1_JTA LD_INDEXED $E2 ; SBCB (idx)
    // 0228: ; //                            
    // 0229:   decode pg1_JTA LD_INDEXED $A0 ; SUBA (idx)
    // 0230:   decode pg1_JTA LD_INDEXED $E0 ; SUBB (idx)
    // 0231:   decode pg1_JTA LD_INDEXED $A3 ; SUBD (idx)
    // 0232: ; //                            
    // 0233:   decode pg1_JTA LD_INDEXED $6D ; TST (idx)
    // 0234:   
    // 0235:   SET_DATA_WIDTH  W_R1_OR_IND
    // 0236: 
    // 0237:   ADDR_INX_OR_LOAD_IND
    // 0238:   DMEM_LOAD_W ; LOAD_IND can override
    // 0239: 
    // 0240:   IF              NOT_INDIRECT
    // 0241:   JUMP_TABLE_B
    // 0242:   end_state
    9'h002: begin
      CV_MICRO_SEQ_OP_O = 3'h4;  // OP_JUMP_TABLE_B
      CV_ADDR_ALU_REG_SEL_O = 4'h0;  // INDEXED
      CV_DATA_WIDTH_SEL_O = 3'h1;  // W_R1_OR_IND
      CV_MICRO_SEQ_COND_SEL_O = 4'h0;  // NOT_INDIRECT
      CV_DMEM_OP_O = 2'h2;  // DMEM_OP_RD
    end


    // 0243: 
    // 0244: LD_INDIRECT:
    // 0245:   DATA_PASS_B     DMEM_RD
    // 0246:   DATA_WRITE      EA
    // 0247:   
    // 0248:   SET_DATA_WIDTH  W_R1
    // 0249: 
    // 0250:   ADDR_PASS       DMEM_RD
    // 0251:   DMEM_LOAD_W
    // 0252: 
    // 0253:   JUMP_TABLE_B
    // 0254:   end_state
    9'h003: begin
      CV_MICRO_SEQ_OP_O = 3'h4;  // OP_JUMP_TABLE_B
      CV_DATA_ALU_A_SEL_O = 4'hf;  // ZERO
      CV_DATA_ALU_B_SEL_O = 3'h5;  // DMEM_RD
      CV_DATA_ALU_WR_SEL_O = 4'hc;  // EA
      CV_ADDR_ALU_REG_SEL_O = 4'hd;  // DMEM_RD
      CV_DATA_ALU_OP_O = 3'h0;  // A_PLUS_B
      CV_DATA_WIDTH_SEL_O = 3'h0;  // W_R1
      CV_DATA_ALU_COND_SEL_O = 2'h0;  // ZERO_BIT
      CV_DMEM_OP_O = 2'h2;  // DMEM_OP_RD
    end


    // 0255: ; //
    // 0256: ; ////////////////////////////////////////////////////////////////////////////
    // 0257: 
    // 0258: 
    // 0259: ; ////////////////////////////////////////////////////////////////////////////
    // 0260: ;                           STORE ADDRESSING MODES
    // 0261: ; ////////////////////////////////////////////////////////////////////////////
    // 0262: ; //
    // 0263: ST_INDEXED:
    // 0264:   decode pg1_JTA ST_INDEXED $6F ; CLR(idx)
    // 0265: ; //                                
    // 0266:   decode pg1_JTA ST_INDEXED $6E ; JMP(idx)
    // 0267: ; //                                
    // 0268:   decode pg1_JTA ST_INDEXED $AD ; JSR (idx)
    // 0269: ; //                                
    // 0270:   decode pg1_JTA ST_INDEXED $32 ; LEAS(inh)
    // 0271:   decode pg1_JTA ST_INDEXED $33 ; LEAU(inh)
    // 0272:   decode pg1_JTA ST_INDEXED $30 ; LEAX(inh)
    // 0273:   decode pg1_JTA ST_INDEXED $31 ; LEAY(inh)
    // 0274: ; //                                
    // 0275:   decode pg1_JTA ST_INDEXED $A7 ; STA (idx)
    // 0276:   decode pg1_JTA ST_INDEXED $E7 ; STB (idx)
    // 0277:   decode pg1_JTA ST_INDEXED $ED ; STD (idx)
    // 0278:   decode pg2_JTA ST_INDEXED $EF ; STS (idx)
    // 0279:   decode pg1_JTA ST_INDEXED $EF ; STU (idx)
    // 0280:   decode pg1_JTA ST_INDEXED $AF ; STX (idx)
    // 0281:   decode pg2_JTA ST_INDEXED $AF ; STY (idx)
    // 0282:   
    // 0283:   SET_DATA_WIDTH  W_R1_OR_IND
    // 0284: 
    // 0285:   ADDR_INX_OR_LOAD_IND
    // 0286: 
    // 0287:   IF              NOT_INDIRECT
    // 0288:   JUMP_TABLE_B
    // 0289:   end_state
    9'h004: begin
      CV_MICRO_SEQ_OP_O = 3'h4;  // OP_JUMP_TABLE_B
      CV_ADDR_ALU_REG_SEL_O = 4'h0;  // INDEXED
      CV_DATA_WIDTH_SEL_O = 3'h1;  // W_R1_OR_IND
      CV_MICRO_SEQ_COND_SEL_O = 4'h0;  // NOT_INDIRECT
    end


    // 0290: 
    // 0291: ST_INDIRECT:
    // 0292:   DATA_PASS_B     DMEM_RD
    // 0293:   DATA_WRITE      EA
    // 0294:   
    // 0295:   JUMP_TABLE_B
    // 0296:   end_state
    9'h005: begin
      CV_MICRO_SEQ_OP_O = 3'h4;  // OP_JUMP_TABLE_B
      CV_DATA_ALU_A_SEL_O = 4'hf;  // ZERO
      CV_DATA_ALU_B_SEL_O = 3'h5;  // DMEM_RD
      CV_DATA_ALU_WR_SEL_O = 4'hc;  // EA
      CV_DATA_ALU_OP_O = 3'h0;  // A_PLUS_B
      CV_DATA_ALU_COND_SEL_O = 2'h0;  // ZERO_BIT
    end


    // 0297: 
    // 0298: ; //
    // 0299: ; ////////////////////////////////////////////////////////////////////////////
    // 0300: 
    // 0301: 
    // 0302: ; ////////////////////////////////////////////////////////////////////////////
    // 0303: ;                           INHERENT INSTRUCTIONS
    // 0304: ; ////////////////////////////////////////////////////////////////////////////
    // 0305: ; //
    // 0306: 
    // 0307: ; //////////////////////////////////////////// ABX
    // 0308: ; //
    // 0309: ABX:
    // 0310:   decode pg1_JTA ABX $3A ; ABX(inh)
    // 0311:   decode pg1_R1  X   $3A ; ABX(inh)
    // 0312:   decode pg1_R2  B   $3A ; ABX(inh)
    // 0313: 
    // 0314:   DATA_ADD        R1, R2
    // 0315:   DATA_WRITE      R1
    // 0316: 
    // 0317:   JUMP_TABLE_A_NEXT_PC
    // 0318:   end_state
    9'h006: begin
      CV_MICRO_SEQ_OP_O = 3'h5;  // OP_JUMP_TABLE_A_NEXT_PC
      CV_DATA_ALU_A_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_B_SEL_O = 3'h0;  // R2
      CV_DATA_ALU_WR_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_OP_O = 3'h0;  // A_PLUS_B
      CV_DATA_ALU_COND_SEL_O = 2'h0;  // ZERO_BIT
    end


    // 0319: 
    // 0320: ; //////////////////////////////////////////// EXG
    // 0321: ; //
    // 0322: EXG:
    // 0323:   decode pg1_JTA EXG $1E ; EXG(inh)
    // 0324: ; R1 = postbyte[7:0] $1E ; EXG(inh)
    // 0325: ; R2 = postbyte[3:0] $1E ; EXG(inh)
    // 0326: 
    // 0327:   DATA_PASS_A     R1
    // 0328:   DATA_WRITE      EA
    // 0329:   end_state
    9'h007: begin
      CV_DATA_ALU_A_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_B_SEL_O = 3'h7;  // ZERO
      CV_DATA_ALU_WR_SEL_O = 4'hc;  // EA
      CV_DATA_ALU_OP_O = 3'h0;  // A_PLUS_B
      CV_DATA_ALU_COND_SEL_O = 2'h0;  // ZERO_BIT
    end


    // 0330: 
    // 0331:   DATA_PASS_A     R2
    // 0332:   DATA_WRITE      R1
    // 0333:   
    // 0334:   CCR_OP_W        OP_XXXXXXXX ; Just in case CCR is destination
    // 0335:   end_state
    9'h008: begin
      CV_DATA_ALU_A_SEL_O = 4'h4;  // R2
      CV_DATA_ALU_B_SEL_O = 3'h7;  // ZERO
      CV_DATA_ALU_WR_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_OP_O = 3'h0;  // A_PLUS_B
      CV_CCR_OP_O = 4'h9;  // OP_XXXXXXXX
      CV_DATA_ALU_COND_SEL_O = 2'h0;  // ZERO_BIT
    end


    // 0336: 
    // 0337:   DATA_PASS_A     EA
    // 0338:   DATA_WRITE      R2
    // 0339: 
    // 0340:   CCR_OP_W        OP_XXXXXXXX ; Just in case CCR is destination
    // 0341: 
    // 0342:   JUMP            GO_NEW_PC ; Just in case PC is destination
    // 0343:   end_state
    9'h009: begin
      CV_MICRO_SEQ_OP_O = 3'h1;  // OP_JUMP
      CV_MICRO_SEQ_BRANCH_ADDR_O = 8'h2f;  // GO_NEW_PC
      CV_DATA_ALU_A_SEL_O = 4'hc;  // EA
      CV_DATA_ALU_B_SEL_O = 3'h7;  // ZERO
      CV_DATA_ALU_WR_SEL_O = 4'h4;  // R2
      CV_DATA_ALU_OP_O = 3'h0;  // A_PLUS_B
      CV_CCR_OP_O = 4'h9;  // OP_XXXXXXXX
      CV_DATA_ALU_COND_SEL_O = 2'h0;  // ZERO_BIT
    end


    // 0344: 
    // 0345: 
    // 0346: ; //////////////////////////////////////////// LEA S or U
    // 0347: ; //
    // 0348: LEA_SU:
    // 0349:   decode pg1_JTB LEA_SU $32 ; LEAS(inh)
    // 0350:   decode pg1_R1  S      $32 ; LEAS(inh)
    // 0351:                             
    // 0352:   decode pg1_JTB LEA_SU $33 ; LEAU(inh)
    // 0353:   decode pg1_R1  U      $33 ; LEAU(inh)
    // 0354: 
    // 0355:   DATA_PASS_B     EA
    // 0356:   DATA_WRITE      R1
    // 0357: 
    // 0358:   JUMP_TABLE_A_NEXT_PC
    // 0359:   end_state
    9'h00a: begin
      CV_MICRO_SEQ_OP_O = 3'h5;  // OP_JUMP_TABLE_A_NEXT_PC
      CV_DATA_ALU_A_SEL_O = 4'hf;  // ZERO
      CV_DATA_ALU_B_SEL_O = 3'h4;  // EA
      CV_DATA_ALU_WR_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_OP_O = 3'h0;  // A_PLUS_B
      CV_DATA_ALU_COND_SEL_O = 2'h0;  // ZERO_BIT
    end


    // 0360: 
    // 0361: ; //////////////////////////////////////////// LEA X or Y
    // 0362: ; //
    // 0363: LEA_XY:
    // 0364:   decode pg1_JTB LEA_XY $30 ; LEAX(inh)
    // 0365:   decode pg1_R1  X      $30 ; LEAX(inh)
    // 0366:                             
    // 0367:   decode pg1_JTB LEA_XY $31 ; LEAY(inh)
    // 0368:   decode pg1_R1  Y      $31 ; LEAY(inh)
    // 0369: 
    // 0370:   DATA_PASS_B     EA
    // 0371:   DATA_WRITE      R1
    // 0372: 
    // 0373:   SET_DATA_WIDTH  W_R1
    // 0374: 
    // 0375:   CCR_OP_W        OP_oooooXoo 
    // 0376: 
    // 0377:   JUMP_TABLE_A_NEXT_PC
    // 0378:   end_state
    9'h00b: begin
      CV_MICRO_SEQ_OP_O = 3'h5;  // OP_JUMP_TABLE_A_NEXT_PC
      CV_DATA_ALU_A_SEL_O = 4'hf;  // ZERO
      CV_DATA_ALU_B_SEL_O = 3'h4;  // EA
      CV_DATA_ALU_WR_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_OP_O = 3'h0;  // A_PLUS_B
      CV_DATA_WIDTH_SEL_O = 3'h0;  // W_R1
      CV_CCR_OP_O = 4'h1;  // OP_OOOOOXOO
      CV_DATA_ALU_COND_SEL_O = 2'h0;  // ZERO_BIT
    end


    // 0379: 
    // 0380: ; //////////////////////////////////////////// NOP
    // 0381: ; //
    // 0382: ; // Prebytes are sent here if the execute stage has nothing
    // 0383: ; // else better to do. However, this is unnecessary given
    // 0384: ; // prebyte processing logic is contained in the decode stage
    // 0385: ; // and prebytes are decoded independently without delay if
    // 0386: ; // the execute stage is busy. It's called pipelining ;-)
    // 0387: ; //
    // 0388: NOP:
    // 0389:   decode pg1_JTA NOP $12 ; NOP(inh)
    // 0390:   decode pg1_JTA NOP $11 ; page3 (prebyte)
    // 0391:   decode pg1_JTA NOP $10 ; page2 (prebyte)
    // 0392: 
    // 0393:   JUMP_TABLE_A_NEXT_PC
    // 0394:   end_state
    9'h00c: begin
      CV_MICRO_SEQ_OP_O = 3'h5;  // OP_JUMP_TABLE_A_NEXT_PC
    end


    // 0395: 
    // 0396: ; //////////////////////////////////////////// EMUL EMULS IDIV EDIV EDIVS IDIVS FDIV
    // 0397: ; //
    // 0398: SAU16:
    // 0399:   decode pg1_JTA SAU16 $14 ; EMUL (inh)
    // 0400:   decode pg1_R2  Y     $14 ; EMUL (inh)
    // 0401:   decode pg1_R1  D     $14 ; EMUL (inh)
    // 0402: 
    // 0403:   decode pg1_JTA SAU16 $18 ; IDIV (inh)
    // 0404:   decode pg1_R2  D     $18 ; IDIV (inh)
    // 0405:   decode pg1_R1  X     $18 ; IDIV (inh)
    // 0406: 
    // 0407:   decode pg2_JTA SAU16 $18 ; IDIVS (inh)
    // 0408:   decode pg2_R2  D     $18 ; IDIVS (inh)
    // 0409:   decode pg2_R1  X     $18 ; IDIVS (inh)
    // 0410: 
    // 0411:   DATA_SAU_EN
    // 0412: 
    // 0413:   IF              SAU_NOT_DONE
    // 0414:   JUMP            SAU16
    // 0415:   end_state
    9'h00d: begin
      CV_MICRO_SEQ_OP_O = 3'h1;  // OP_JUMP
      CV_MICRO_SEQ_BRANCH_ADDR_O = 8'hd;  // SAU16
      CV_DATA_ALU_SAU_EN_O = 1'h1;  // TRUE
      CV_MICRO_SEQ_COND_SEL_O = 4'h5;  // SAU_NOT_DONE
    end


    // 0416: 
    // 0417: SAU16_DONE:
    // 0418: 
    // 0419:   DATA_SAU_EN
    // 0420:   DATA_SAU_DONE
    // 0421:   DATA_WRITE      R2
    // 0422: 
    // 0423:   JUMP            SAU8_DONE
    // 0424:   end_state
    9'h00e: begin
      CV_MICRO_SEQ_OP_O = 3'h1;  // OP_JUMP
      CV_MICRO_SEQ_BRANCH_ADDR_O = 8'h10;  // SAU8_DONE
      CV_DATA_ALU_WR_SEL_O = 4'h4;  // R2
      CV_DATA_ALU_OP_O = 3'h7;  // SAU
      CV_DATA_ALU_SAU_EN_O = 1'h1;  // TRUE
    end


    // 0425: 
    // 0426: ; //////////////////////////////////////////// DAA MUL
    // 0427: ; //
    // 0428: SAU8:
    // 0429:   decode pg1_JTA SAU8 $19 ; DAA (inh)
    // 0430:   decode pg1_R1  D    $19 ; DAA (inh)
    // 0431: 
    // 0432:   decode pg1_JTA SAU8 $3D ; MUL (inh)
    // 0433:   decode pg1_R1  D    $3D ; MUL (inh)
    // 0434: 
    // 0435:   DATA_SAU_EN
    // 0436: 
    // 0437:   IF              SAU_NOT_DONE
    // 0438:   JUMP            SAU8
    // 0439:   end_state
    9'h00f: begin
      CV_MICRO_SEQ_OP_O = 3'h1;  // OP_JUMP
      CV_MICRO_SEQ_BRANCH_ADDR_O = 8'hf;  // SAU8
      CV_DATA_ALU_SAU_EN_O = 1'h1;  // TRUE
      CV_MICRO_SEQ_COND_SEL_O = 4'h5;  // SAU_NOT_DONE
    end


    // 0440: 
    // 0441: SAU8_DONE:
    // 0442: 
    // 0443:   DATA_SAU_EN
    // 0444:   DATA_SAU_DONE
    // 0445:   DATA_WRITE      R1
    // 0446: 
    // 0447:   CCR_OP_W        OP_ooooXXXX ; SAU masks correct bits
    // 0448: 
    // 0449:   JUMP_TABLE_A_NEXT_PC
    // 0450:   end_state
    9'h010: begin
      CV_MICRO_SEQ_OP_O = 3'h5;  // OP_JUMP_TABLE_A_NEXT_PC
      CV_DATA_ALU_WR_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_OP_O = 3'h7;  // SAU
      CV_DATA_ALU_SAU_EN_O = 1'h1;  // TRUE
      CV_CCR_OP_O = 4'h2;  // OP_OOOOXXXX
    end


    // 0451: 
    // 0452: ; //////////////////////////////////////////// SEX (in 1 micro-cycle!)
    // 0453: ; //
    // 0454: SEX:
    // 0455:   decode pg1_JTA SEX  $1D ; SEX(inh)
    // 0456:   decode pg1_R1  D    $1D ; SEX(inh)
    // 0457:   decode pg1_R2  SEXB $1D ; SEX(inh)
    // 0458: 
    // 0459:   DATA_PASS_B     R2
    // 0460:   DATA_WRITE      R1
    // 0461:   
    // 0462:   SET_DATA_WIDTH  W_R1
    // 0463: 
    // 0464:   CCR_OP_W        OP_ooooXXXo ; INFO Prog Man says V unaffected, datasheet says v=0
    // 0465: 
    // 0466:   JUMP_TABLE_A_NEXT_PC
    // 0467:   end_state
    9'h011: begin
      CV_MICRO_SEQ_OP_O = 3'h5;  // OP_JUMP_TABLE_A_NEXT_PC
      CV_DATA_ALU_A_SEL_O = 4'hf;  // ZERO
      CV_DATA_ALU_B_SEL_O = 3'h0;  // R2
      CV_DATA_ALU_WR_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_OP_O = 3'h0;  // A_PLUS_B
      CV_DATA_WIDTH_SEL_O = 3'h0;  // W_R1
      CV_CCR_OP_O = 4'h4;  // OP_OOOOXXXO
      CV_DATA_ALU_COND_SEL_O = 2'h0;  // ZERO_BIT
    end


    // 0468: 
    // 0469: ; //////////////////////////////////////////// CPY
    // 0470: ; //
    // 0471: CPY:
    // 0472:   decode pg2_JTA CPY $1F ; CPY (inh)
    // 0473: ; R1 = postbyte[7:0] $1F ; CPY (inh)
    // 0474: ; R2 = postbyte[3:0] $1F ; CPY (inh)
    // 0475: 
    // 0476: ; TODO INFO: could combine this state with SAU states
    // 0477: 
    // 0478:   DATA_SAU_EN ; initalize byte counter from D register
    // 0479:   end_state
    9'h012: begin
      CV_DATA_ALU_SAU_EN_O = 1'h1;  // TRUE
    end


    // 0480:   
    // 0481: CPY_LOOP:
    // 0482:   DATA_SAU_EN ; enable byte counter
    // 0483: 
    // 0484:   SET_DATA_WIDTH  W_8
    // 0485: 
    // 0486:   ADDR_PASS       RR1_WR2
    // 0487:   DMEM_LOAD_W
    // 0488: 
    // 0489:   IF              SAU_DONE
    // 0490:   JUMP            GO_NEW_PC
    // 0491:   end_state
    9'h013: begin
      CV_MICRO_SEQ_OP_O = 3'h1;  // OP_JUMP
      CV_MICRO_SEQ_BRANCH_ADDR_O = 8'h2f;  // GO_NEW_PC
      CV_ADDR_ALU_REG_SEL_O = 4'h4;  // RR1_WR2
      CV_DATA_WIDTH_SEL_O = 3'h4;  // W_8
      CV_DATA_ALU_SAU_EN_O = 1'h1;  // TRUE
      CV_MICRO_SEQ_COND_SEL_O = 4'h4;  // SAU_DONE
      CV_DMEM_OP_O = 2'h2;  // DMEM_OP_RD
    end


    // 0492:   
    // 0493:   DATA_SAU_EN ; enable byte counter
    // 0494: 
    // 0495:   SET_DATA_WIDTH  W_8
    // 0496: 
    // 0497:   DATA_PASS_B     DMEM_RD
    // 0498: 
    // 0499:   ADDR_PASS       RR1_WR2
    // 0500:   DMEM_STORE_W
    // 0501: 
    // 0502:   JUMP            CPY_LOOP
    // 0503:   end_state
    9'h014: begin
      CV_MICRO_SEQ_OP_O = 3'h1;  // OP_JUMP
      CV_MICRO_SEQ_BRANCH_ADDR_O = 8'h13;  // CPY_LOOP
      CV_DATA_ALU_A_SEL_O = 4'hf;  // ZERO
      CV_DATA_ALU_B_SEL_O = 3'h5;  // DMEM_RD
      CV_ADDR_ALU_REG_SEL_O = 4'h4;  // RR1_WR2
      CV_DATA_ALU_OP_O = 3'h0;  // A_PLUS_B
      CV_DATA_WIDTH_SEL_O = 3'h4;  // W_8
      CV_DATA_ALU_SAU_EN_O = 1'h1;  // TRUE
      CV_DATA_ALU_COND_SEL_O = 2'h0;  // ZERO_BIT
      CV_DMEM_OP_O = 2'h3;  // DMEM_OP_WR
    end


    // 0504: 
    // 0505: 
    // 0506: 
    // 0507: ; //////////////////////////////////////////// TFR
    // 0508: ; //
    // 0509: TFR:
    // 0510:   decode pg1_JTA TFR $1F ; TFR(inh)
    // 0511: ; R1 = postbyte[7:0] $1F ; TFR(inh)
    // 0512: ; R2 = postbyte[3:0] $1F ; TFR(inh)
    // 0513: 
    // 0514:   DATA_PASS_A     R1
    // 0515:   DATA_WRITE      R2
    // 0516: 
    // 0517:   CCR_OP_W        OP_XXXXXXXX ; Just in case CCR is destination
    // 0518: 
    // 0519:   JUMP            GO_NEW_PC ; Just in case PC is destination
    // 0520:   end_state
    9'h015: begin
      CV_MICRO_SEQ_OP_O = 3'h1;  // OP_JUMP
      CV_MICRO_SEQ_BRANCH_ADDR_O = 8'h2f;  // GO_NEW_PC
      CV_DATA_ALU_A_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_B_SEL_O = 3'h7;  // ZERO
      CV_DATA_ALU_WR_SEL_O = 4'h4;  // R2
      CV_DATA_ALU_OP_O = 3'h0;  // A_PLUS_B
      CV_CCR_OP_O = 4'h9;  // OP_XXXXXXXX
      CV_DATA_ALU_COND_SEL_O = 2'h0;  // ZERO_BIT
    end


    // 0521: 
    // 0522: ; //
    // 0523: ; ////////////////////////////////////////////////////////////////////////////
    // 0524: 
    // 0525: 
    // 0526: ; ////////////////////////////////////////////////////////////////////////////
    // 0527: ;                        LOAD TYPE INSTRUCTIONS
    // 0528: ; ////////////////////////////////////////////////////////////////////////////
    // 0529: 
    // 0530: ; //////////////////////////////////////////// ADC
    // 0531: ; //
    // 0532: ADC:
    // 0533:   decode pg1_JTA ADC     $89         ; ADCA (imm)
    // 0534:   decode pg1_R1  A       $89         ; ADCA (imm)
    // 0535:   decode pg1_R2  IDATA   $89         ; ADCA (imm)
    // 0536:                                                    
    // 0537:   decode pg1_JTA ADC     $C9         ; ADCB (imm)
    // 0538:   decode pg1_R1  B       $C9         ; ADCB (imm)
    // 0539:   decode pg1_R2  IDATA   $C9         ; ADCB (imm)
    // 0540:                                          
    // 0541:   decode pg1_JTB ADC     $99 $A9 $B9 ; ADCA (dir idx ext)
    // 0542:   decode pg1_R1  A       $99 $A9 $B9 ; ADCA (dir idx ext)
    // 0543:   decode pg1_R2  DMEM_RD $99 $A9 $B9 ; ADCA (dir idx ext)
    // 0544:                                          
    // 0545:   decode pg1_JTB ADC     $D9 $E9 $F9 ; ADCB (dir idx ext)
    // 0546:   decode pg1_R1  B       $D9 $E9 $F9 ; ADCB (dir idx ext)
    // 0547:   decode pg1_R2  DMEM_RD $D9 $E9 $F9 ; ADCB (dir idx ext)
    // 0548: 
    // 0549:   DATA_ADDC       R1, R2
    // 0550:   DATA_WRITE      R1
    // 0551: 
    // 0552:   SET_DATA_WIDTH  W_R1
    // 0553: 
    // 0554:   CCR_OP_W        OP_ooXoXXXX ; H is masked for 16bit
    // 0555: 
    // 0556:   JUMP_TABLE_A_NEXT_PC
    // 0557:   end_state
    9'h016: begin
      CV_MICRO_SEQ_OP_O = 3'h5;  // OP_JUMP_TABLE_A_NEXT_PC
      CV_DATA_ALU_A_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_B_SEL_O = 3'h0;  // R2
      CV_DATA_ALU_WR_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_OP_O = 3'h0;  // A_PLUS_B
      CV_DATA_WIDTH_SEL_O = 3'h0;  // W_R1
      CV_CCR_OP_O = 4'h5;  // OP_OOXOXXXX
      CV_DATA_ALU_COND_SEL_O = 2'h2;  // CARRY_BIT
    end


    // 0558: 
    // 0559: ; //////////////////////////////////////////// ADD
    // 0560: ; //
    // 0561: ADD:
    // 0562:   decode pg1_JTA ADD     $8B         ; ADDA (imm)
    // 0563:   decode pg1_R1  A       $8B         ; ADDA (imm)
    // 0564:   decode pg1_R2  IDATA   $8B         ; ADDA (imm)
    // 0565:                                                    
    // 0566:   decode pg1_JTA ADD     $CB         ; ADDB (imm)
    // 0567:   decode pg1_R1  B       $CB         ; ADDB (imm)
    // 0568:   decode pg1_R2  IDATA   $CB         ; ADDB (imm)
    // 0569:                                                    
    // 0570:   decode pg1_JTA ADD     $C3         ; ADDD (imm)
    // 0571:   decode pg1_R1  D       $C3         ; ADDD (imm)
    // 0572:   decode pg1_R2  IDATA   $C3         ; ADDD (imm)
    // 0573:                              
    // 0574:   decode pg1_JTB ADD     $9B $AB $BB ; ADDA (dir idx ext)
    // 0575:   decode pg1_R1  A       $9B $AB $BB ; ADDA (dir idx ext)
    // 0576:   decode pg1_R2  DMEM_RD $9B $AB $BB ; ADDA (dir idx ext)
    // 0577:                              
    // 0578:   decode pg1_JTB ADD     $DB $EB $FB ; ADDB (dir idx ext)
    // 0579:   decode pg1_R1  B       $DB $EB $FB ; ADDB (dir idx ext)
    // 0580:   decode pg1_R2  DMEM_RD $DB $EB $FB ; ADDB (dir idx ext)
    // 0581:                              
    // 0582:   decode pg1_JTB ADD     $D3 $E3 $F3 ; ADDD (dir idx ext)
    // 0583:   decode pg1_R1  D       $D3 $E3 $F3 ; ADDD (dir idx ext)
    // 0584:   decode pg1_R2  DMEM_RD $D3 $E3 $F3 ; ADDD (dir idx ext)
    // 0585: 
    // 0586:   DATA_ADD        R1, R2
    // 0587:   DATA_WRITE      R1
    // 0588: 
    // 0589:   SET_DATA_WIDTH  W_R1
    // 0590: 
    // 0591:   CCR_OP_W        OP_ooXoXXXX ; H is masked for 16bit
    // 0592: 
    // 0593:   JUMP_TABLE_A_NEXT_PC
    // 0594:   end_state
    9'h017: begin
      CV_MICRO_SEQ_OP_O = 3'h5;  // OP_JUMP_TABLE_A_NEXT_PC
      CV_DATA_ALU_A_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_B_SEL_O = 3'h0;  // R2
      CV_DATA_ALU_WR_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_OP_O = 3'h0;  // A_PLUS_B
      CV_DATA_WIDTH_SEL_O = 3'h0;  // W_R1
      CV_CCR_OP_O = 4'h5;  // OP_OOXOXXXX
      CV_DATA_ALU_COND_SEL_O = 2'h0;  // ZERO_BIT
    end


    // 0595: 
    // 0596: 
    // 0597: ; //////////////////////////////////////////// AND
    // 0598: ; //
    // 0599: AND:
    // 0600:   decode pg1_JTA AND     $84         ; ANDA (imm)
    // 0601:   decode pg1_R1  A       $84         ; ANDA (imm)
    // 0602:   decode pg1_R2  IDATA   $84         ; ANDA (imm)
    // 0603:                                                    
    // 0604:   decode pg1_JTA AND     $C4         ; ANDB (imm)
    // 0605:   decode pg1_R1  B       $C4         ; ANDB (imm)
    // 0606:   decode pg1_R2  IDATA   $C4         ; ANDB (imm)
    // 0607:                                      
    // 0608:   decode pg1_JTB AND     $94 $A4 $B4 ; ANDA (dir idx ext)
    // 0609:   decode pg1_R1  A       $94 $A4 $B4 ; ANDA (dir idx ext)
    // 0610:   decode pg1_R2  DMEM_RD $94 $A4 $B4 ; ANDA (dir idx ext)
    // 0611:                                      
    // 0612:   decode pg1_JTB AND     $D4 $E4 $F4 ; ANDB (dir idx ext)
    // 0613:   decode pg1_R1  B       $D4 $E4 $F4 ; ANDB (dir idx ext)
    // 0614:   decode pg1_R2  DMEM_RD $D4 $E4 $F4 ; ANDB (dir idx ext)
    // 0615: 
    // 0616:   DATA_AND        R1, R2
    // 0617:   DATA_WRITE      R1
    // 0618: 
    // 0619:   SET_DATA_WIDTH  W_R1
    // 0620: 
    // 0621:   CCR_OP_W        OP_ooooXXXo 
    // 0622: 
    // 0623:   JUMP_TABLE_A_NEXT_PC
    // 0624:   end_state
    9'h018: begin
      CV_MICRO_SEQ_OP_O = 3'h5;  // OP_JUMP_TABLE_A_NEXT_PC
      CV_DATA_ALU_A_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_B_SEL_O = 3'h0;  // R2
      CV_DATA_ALU_WR_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_OP_O = 3'h4;  // A_AND_B
      CV_DATA_WIDTH_SEL_O = 3'h0;  // W_R1
      CV_CCR_OP_O = 4'h4;  // OP_OOOOXXXO
      CV_DATA_ALU_COND_SEL_O = 2'h0;  // ZERO_BIT
    end


    // 0625: 
    // 0626: ANDCC:
    // 0627:   decode pg1_JTA ANDCC $1C ; ANDCC (imm)
    // 0628:   decode pg1_R1  CCR   $1C ; ANDCC (imm)
    // 0629:   decode pg1_R2  IDATA $1C ; ANDCC (imm)
    // 0630: 
    // 0631:   DATA_AND        R1, R2
    // 0632:   DATA_WRITE      R1
    // 0633: 
    // 0634:   SET_DATA_WIDTH  W_R1
    // 0635: 
    // 0636:   CCR_OP_W        OP_XXXXXXXX 
    // 0637: 
    // 0638:   JUMP_TABLE_A_NEXT_PC
    // 0639:   end_state
    9'h019: begin
      CV_MICRO_SEQ_OP_O = 3'h5;  // OP_JUMP_TABLE_A_NEXT_PC
      CV_DATA_ALU_A_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_B_SEL_O = 3'h0;  // R2
      CV_DATA_ALU_WR_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_OP_O = 3'h4;  // A_AND_B
      CV_DATA_WIDTH_SEL_O = 3'h0;  // W_R1
      CV_CCR_OP_O = 4'h9;  // OP_XXXXXXXX
      CV_DATA_ALU_COND_SEL_O = 2'h0;  // ZERO_BIT
    end


    // 0640: 
    // 0641: ; //////////////////////////////////////////// BIT
    // 0642: ; //
    // 0643: BIT:
    // 0644:   decode pg1_JTA BIT     $85         ; BITA (imm)
    // 0645:   decode pg1_R1  A       $85         ; BITA (imm)
    // 0646:   decode pg1_R2  IDATA   $85         ; BITA (imm)
    // 0647:                                                 
    // 0648:   decode pg1_JTA BIT     $C5         ; BITB (imm)
    // 0649:   decode pg1_R1  B       $C5         ; BITB (imm)
    // 0650:   decode pg1_R2  IDATA   $C5         ; BITB (imm)
    // 0651:                              
    // 0652:   decode pg1_JTB BIT     $95 $A5 $B5 ; BITA (dir idx ext)
    // 0653:   decode pg1_R1  A       $95 $A5 $B5 ; BITA (dir idx ext)
    // 0654:   decode pg1_R2  DMEM_RD $95 $A5 $B5 ; BITA (dir idx ext)
    // 0655:                              
    // 0656:   decode pg1_JTB BIT     $D5 $E5 $F5 ; BITB (dir idx ext)
    // 0657:   decode pg1_R1  B       $D5 $E5 $F5 ; BITB (dir idx ext)
    // 0658:   decode pg1_R2  DMEM_RD $D5 $E5 $F5 ; BITB (dir idx ext)
    // 0659: 
    // 0660:   DATA_AND        R1, R2
    // 0661: 
    // 0662:   SET_DATA_WIDTH  W_R1
    // 0663: 
    // 0664:   CCR_OP_W        OP_ooooXXXo 
    // 0665: 
    // 0666:   JUMP_TABLE_A_NEXT_PC
    // 0667:   end_state
    9'h01a: begin
      CV_MICRO_SEQ_OP_O = 3'h5;  // OP_JUMP_TABLE_A_NEXT_PC
      CV_DATA_ALU_A_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_B_SEL_O = 3'h0;  // R2
      CV_DATA_ALU_OP_O = 3'h4;  // A_AND_B
      CV_DATA_WIDTH_SEL_O = 3'h0;  // W_R1
      CV_CCR_OP_O = 4'h4;  // OP_OOOOXXXO
      CV_DATA_ALU_COND_SEL_O = 2'h0;  // ZERO_BIT
    end


    // 0668: 
    // 0669: ; //////////////////////////////////////////// CMP
    // 0670: ; //
    // 0671: CMP:
    // 0672:   decode pg1_JTA CMP     $81         ; CMPA (imm)
    // 0673:   decode pg1_R1  A       $81         ; CMPA (imm)
    // 0674:   decode pg1_R2  IDATA   $81         ; CMPA (imm)
    // 0675:                                                
    // 0676:   decode pg1_JTA CMP     $C1         ; CMPB (imm)
    // 0677:   decode pg1_R1  B       $C1         ; CMPB (imm)
    // 0678:   decode pg1_R2  IDATA   $C1         ; CMPB (imm)
    // 0679:                                                
    // 0680:   decode pg2_JTA CMP     $83         ; CMPD (imm)
    // 0681:   decode pg2_R1  D       $83         ; CMPD (imm)
    // 0682:   decode pg2_R2  IDATA   $83         ; CMPD (imm)
    // 0683:                                                
    // 0684:   decode pg3_JTA CMP     $8C         ; CMPS (imm)
    // 0685:   decode pg3_R1  S       $8C         ; CMPS (imm)
    // 0686:   decode pg3_R2  IDATA   $8C         ; CMPS (imm)
    // 0687:                                                
    // 0688:   decode pg3_JTA CMP     $83         ; CMPU (imm)
    // 0689:   decode pg3_R1  U       $83         ; CMPU (imm)
    // 0690:   decode pg3_R2  IDATA   $83         ; CMPU (imm)
    // 0691:                                                
    // 0692:   decode pg1_JTA CMP     $8C         ; CMPX (imm)
    // 0693:   decode pg1_R1  X       $8C         ; CMPX (imm)
    // 0694:   decode pg1_R2  IDATA   $8C         ; CMPX (imm)
    // 0695:                                                
    // 0696:   decode pg2_JTA CMP     $8C         ; CMPY (imm)
    // 0697:   decode pg2_R1  Y       $8C         ; CMPY (imm)
    // 0698:   decode pg2_R2  IDATA   $8C         ; CMPY (imm)
    // 0699:                              
    // 0700:   decode pg1_JTB CMP     $91 $A1 $B1 ; CMPA (dir idx ext)
    // 0701:   decode pg1_R1  A       $91 $A1 $B1 ; CMPA (dir idx ext)
    // 0702:   decode pg1_R2  DMEM_RD $91 $A1 $B1 ; CMPA (dir idx ext)
    // 0703:                              
    // 0704:   decode pg1_JTB CMP     $D1 $E1 $F1 ; CMPB (dir idx ext)
    // 0705:   decode pg1_R1  B       $D1 $E1 $F1 ; CMPB (dir idx ext)
    // 0706:   decode pg1_R2  DMEM_RD $D1 $E1 $F1 ; CMPB (dir idx ext)
    // 0707:                              
    // 0708:   decode pg2_JTB CMP     $93 $A3 $B3 ; CMPD (dir idx ext)
    // 0709:   decode pg2_R1  D       $93 $A3 $B3 ; CMPD (dir idx ext)
    // 0710:   decode pg2_R2  DMEM_RD $93 $A3 $B3 ; CMPD (dir idx ext)
    // 0711:                              
    // 0712:   decode pg3_JTB CMP     $9C $AC $BC ; CMPS (dir idx ext)
    // 0713:   decode pg3_R1  S       $9C $AC $BC ; CMPS (dir idx ext)
    // 0714:   decode pg3_R2  DMEM_RD $9C $AC $BC ; CMPS (dir idx ext)
    // 0715:                              
    // 0716:   decode pg3_JTB CMP     $93 $A3 $B3 ; CMPU (dir idx ext)
    // 0717:   decode pg3_R1  U       $93 $A3 $B3 ; CMPU (dir idx ext)
    // 0718:   decode pg3_R2  DMEM_RD $93 $A3 $B3 ; CMPU (dir idx ext)
    // 0719:                              
    // 0720:   decode pg1_JTB CMP     $9C $AC $BC ; CMPX (dir idx ext)
    // 0721:   decode pg1_R1  X       $9C $AC $BC ; CMPX (dir idx ext)
    // 0722:   decode pg1_R2  DMEM_RD $9C $AC $BC ; CMPX (dir idx ext)
    // 0723:                              
    // 0724:   decode pg2_JTB CMP     $9C $AC $BC ; CMPY (dir idx ext)
    // 0725:   decode pg2_R1  Y       $9C $AC $BC ; CMPY (dir idx ext)
    // 0726:   decode pg2_R2  DMEM_RD $9C $AC $BC ; CMPY (dir idx ext)
    // 0727: 
    // 0728:   DATA_SUB        R1, R2
    // 0729: 
    // 0730:   SET_DATA_WIDTH  W_R1
    // 0731: 
    // 0732:   CCR_OP_W        OP_ooooXXXX ; INFO: Spec H Undefined, Turbo9 H not affected
    // 0733: 
    // 0734:   JUMP_TABLE_A_NEXT_PC
    // 0735:   end_state
    9'h01b: begin
      CV_MICRO_SEQ_OP_O = 3'h5;  // OP_JUMP_TABLE_A_NEXT_PC
      CV_DATA_ALU_A_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_B_SEL_O = 3'h0;  // R2
      CV_DATA_ALU_OP_O = 3'h1;  // A_PLUS_NOT_B
      CV_DATA_WIDTH_SEL_O = 3'h0;  // W_R1
      CV_CCR_OP_O = 4'h2;  // OP_OOOOXXXX
      CV_DATA_ALU_COND_SEL_O = 2'h0;  // ZERO_BIT
    end


    // 0736: 
    // 0737: ; //////////////////////////////////////////// EOR
    // 0738: ; //
    // 0739: EOR:
    // 0740:   decode pg1_JTA EOR     $88         ; EORA (imm)
    // 0741:   decode pg1_R1  A       $88         ; EORA (imm)
    // 0742:   decode pg1_R2  IDATA   $88         ; EORA (imm)
    // 0743:                                                 
    // 0744:   decode pg1_JTA EOR     $C8         ; EORB (imm)
    // 0745:   decode pg1_R1  B       $C8         ; EORB (imm)
    // 0746:   decode pg1_R2  IDATA   $C8         ; EORB (imm)
    // 0747:                              
    // 0748:   decode pg1_JTB EOR     $98 $A8 $B8 ; EORA (dir idx ext)
    // 0749:   decode pg1_R1  A       $98 $A8 $B8 ; EORA (dir idx ext)
    // 0750:   decode pg1_R2  DMEM_RD $98 $A8 $B8 ; EORA (dir idx ext)
    // 0751:                              
    // 0752:   decode pg1_JTB EOR     $D8 $E8 $F8 ; EORB (dir idx ext)
    // 0753:   decode pg1_R1  B       $D8 $E8 $F8 ; EORB (dir idx ext)
    // 0754:   decode pg1_R2  DMEM_RD $D8 $E8 $F8 ; EORB (dir idx ext)
    // 0755: 
    // 0756:   DATA_XOR        R1, R2
    // 0757:   DATA_WRITE      R1
    // 0758: 
    // 0759:   SET_DATA_WIDTH  W_R1
    // 0760: 
    // 0761:   CCR_OP_W        OP_ooooXXXo 
    // 0762: 
    // 0763:   JUMP_TABLE_A_NEXT_PC
    // 0764:   end_state
    9'h01c: begin
      CV_MICRO_SEQ_OP_O = 3'h5;  // OP_JUMP_TABLE_A_NEXT_PC
      CV_DATA_ALU_A_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_B_SEL_O = 3'h0;  // R2
      CV_DATA_ALU_WR_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_OP_O = 3'h6;  // A_XOR_B
      CV_DATA_WIDTH_SEL_O = 3'h0;  // W_R1
      CV_CCR_OP_O = 4'h4;  // OP_OOOOXXXO
      CV_DATA_ALU_COND_SEL_O = 2'h0;  // ZERO_BIT
    end


    // 0765: 
    // 0766: ; //////////////////////////////////////////// LD
    // 0767: ; //
    // 0768: LD:
    // 0769:   decode pg1_JTA LD      $86         ; LDA (imm)
    // 0770:   decode pg1_R1  A       $86         ; LDA (imm)
    // 0771:   decode pg1_R2  IDATA   $86         ; LDA (imm)
    // 0772:                                                 
    // 0773:   decode pg1_JTA LD      $C6         ; LDB (imm)
    // 0774:   decode pg1_R1  B       $C6         ; LDB (imm)
    // 0775:   decode pg1_R2  IDATA   $C6         ; LDB (imm)
    // 0776:                                                 
    // 0777:   decode pg1_JTA LD      $CC         ; LDD (imm)
    // 0778:   decode pg1_R1  D       $CC         ; LDD (imm)
    // 0779:   decode pg1_R2  IDATA   $CC         ; LDD (imm)
    // 0780:                                                 
    // 0781:   decode pg2_JTA LD      $CE         ; LDS (imm)
    // 0782:   decode pg2_R1  S       $CE         ; LDS (imm)
    // 0783:   decode pg2_R2  IDATA   $CE         ; LDS (imm)
    // 0784:                                                 
    // 0785:   decode pg1_JTA LD      $CE         ; LDU (imm)
    // 0786:   decode pg1_R1  U       $CE         ; LDU (imm)
    // 0787:   decode pg1_R2  IDATA   $CE         ; LDU (imm)
    // 0788:                                                 
    // 0789:   decode pg1_JTA LD      $8E         ; LDX (imm)
    // 0790:   decode pg1_R1  X       $8E         ; LDX (imm)
    // 0791:   decode pg1_R2  IDATA   $8E         ; LDX (imm)
    // 0792:                                                 
    // 0793:   decode pg2_JTA LD      $8E         ; LDY (imm)
    // 0794:   decode pg2_R1  Y       $8E         ; LDY (imm)
    // 0795:   decode pg2_R2  IDATA   $8E         ; LDY (imm)
    // 0796:                              
    // 0797:   decode pg1_JTB LD      $96 $A6 $B6 ; LDA (dir idx ext)
    // 0798:   decode pg1_R1  A       $96 $A6 $B6 ; LDA (dir idx ext)
    // 0799:   decode pg1_R2  DMEM_RD $96 $A6 $B6 ; LDA (dir idx ext)
    // 0800:                              
    // 0801:   decode pg1_JTB LD      $D6 $E6 $F6 ; LDB (dir idx ext)
    // 0802:   decode pg1_R1  B       $D6 $E6 $F6 ; LDB (dir idx ext)
    // 0803:   decode pg1_R2  DMEM_RD $D6 $E6 $F6 ; LDB (dir idx ext)
    // 0804:                              
    // 0805:   decode pg1_JTB LD      $DC $EC $FC ; LDD (dir idx ext)
    // 0806:   decode pg1_R1  D       $DC $EC $FC ; LDD (dir idx ext)
    // 0807:   decode pg1_R2  DMEM_RD $DC $EC $FC ; LDD (dir idx ext)
    // 0808:                              
    // 0809:   decode pg2_JTB LD      $DE $EE $FE ; LDS (dir idx ext)
    // 0810:   decode pg2_R1  S       $DE $EE $FE ; LDS (dir idx ext)
    // 0811:   decode pg2_R2  DMEM_RD $DE $EE $FE ; LDS (dir idx ext)
    // 0812:                              
    // 0813:   decode pg1_JTB LD      $DE $EE $FE ; LDU (dir idx ext)
    // 0814:   decode pg1_R1  U       $DE $EE $FE ; LDU (dir idx ext)
    // 0815:   decode pg1_R2  DMEM_RD $DE $EE $FE ; LDU (dir idx ext)
    // 0816:                              
    // 0817:   decode pg1_JTB LD      $9E $AE $BE ; LDX (dir idx ext)
    // 0818:   decode pg1_R1  X       $9E $AE $BE ; LDX (dir idx ext)
    // 0819:   decode pg1_R2  DMEM_RD $9E $AE $BE ; LDX (dir idx ext)
    // 0820:                              
    // 0821:   decode pg2_JTB LD      $9E $AE $BE ; LDY (dir idx ext)
    // 0822:   decode pg2_R1  Y       $9E $AE $BE ; LDY (dir idx ext)
    // 0823:   decode pg2_R2  DMEM_RD $9E $AE $BE ; LDY (dir idx ext)
    // 0824: 
    // 0825:   DATA_PASS_B     R2
    // 0826:   DATA_WRITE      R1
    // 0827: 
    // 0828:   SET_DATA_WIDTH  W_R1
    // 0829: 
    // 0830:   CCR_OP_W        OP_ooooXXXo
    // 0831: 
    // 0832:   JUMP_TABLE_A_NEXT_PC
    // 0833:   end_state
    9'h01d: begin
      CV_MICRO_SEQ_OP_O = 3'h5;  // OP_JUMP_TABLE_A_NEXT_PC
      CV_DATA_ALU_A_SEL_O = 4'hf;  // ZERO
      CV_DATA_ALU_B_SEL_O = 3'h0;  // R2
      CV_DATA_ALU_WR_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_OP_O = 3'h0;  // A_PLUS_B
      CV_DATA_WIDTH_SEL_O = 3'h0;  // W_R1
      CV_CCR_OP_O = 4'h4;  // OP_OOOOXXXO
      CV_DATA_ALU_COND_SEL_O = 2'h0;  // ZERO_BIT
    end


    // 0834: 
    // 0835: ; //////////////////////////////////////////// OR
    // 0836: ; //
    // 0837: OR:
    // 0838:   decode pg1_JTA OR      $8A         ; ORA (imm)
    // 0839:   decode pg1_R1  A       $8A         ; ORA (imm)
    // 0840:   decode pg1_R2  IDATA   $8A         ; ORA (imm)
    // 0841:                                                 
    // 0842:   decode pg1_JTA OR      $CA         ; ORB (imm)
    // 0843:   decode pg1_R1  B       $CA         ; ORB (imm)
    // 0844:   decode pg1_R2  IDATA   $CA         ; ORB (imm)
    // 0845:                              
    // 0846:   decode pg1_JTB OR      $9A $AA $BA ; ORA (dir idx ext)
    // 0847:   decode pg1_R1  A       $9A $AA $BA ; ORA (dir idx ext)
    // 0848:   decode pg1_R2  DMEM_RD $9A $AA $BA ; ORA (dir idx ext)
    // 0849:                              
    // 0850:   decode pg1_JTB OR      $DA $EA $FA ; ORB (dir idx ext)
    // 0851:   decode pg1_R1  B       $DA $EA $FA ; ORB (dir idx ext)
    // 0852:   decode pg1_R2  DMEM_RD $DA $EA $FA ; ORB (dir idx ext)
    // 0853: 
    // 0854:   DATA_OR         R1, R2
    // 0855:   DATA_WRITE      R1
    // 0856: 
    // 0857:   SET_DATA_WIDTH  W_R1
    // 0858: 
    // 0859:   CCR_OP_W        OP_ooooXXXo 
    // 0860: 
    // 0861:   JUMP_TABLE_A_NEXT_PC
    // 0862:   end_state
    9'h01e: begin
      CV_MICRO_SEQ_OP_O = 3'h5;  // OP_JUMP_TABLE_A_NEXT_PC
      CV_DATA_ALU_A_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_B_SEL_O = 3'h0;  // R2
      CV_DATA_ALU_WR_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_OP_O = 3'h5;  // A_OR_B
      CV_DATA_WIDTH_SEL_O = 3'h0;  // W_R1
      CV_CCR_OP_O = 4'h4;  // OP_OOOOXXXO
      CV_DATA_ALU_COND_SEL_O = 2'h0;  // ZERO_BIT
    end


    // 0863: 
    // 0864: ORCC:
    // 0865:   decode pg1_JTA ORCC  $1A ; ORCC (imm)
    // 0866:   decode pg1_R1  CCR   $1A ; ORCC (imm)
    // 0867:   decode pg1_R2  IDATA $1A ; ORCC (imm)
    // 0868: 
    // 0869:   DATA_OR         R1, R2   
    // 0870:   DATA_WRITE      R1
    // 0871: 
    // 0872:   SET_DATA_WIDTH  W_R1
    // 0873: 
    // 0874:   CCR_OP_W        OP_XXXXXXXX 
    // 0875: 
    // 0876:   JUMP_TABLE_A_NEXT_PC
    // 0877:   end_state
    9'h01f: begin
      CV_MICRO_SEQ_OP_O = 3'h5;  // OP_JUMP_TABLE_A_NEXT_PC
      CV_DATA_ALU_A_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_B_SEL_O = 3'h0;  // R2
      CV_DATA_ALU_WR_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_OP_O = 3'h5;  // A_OR_B
      CV_DATA_WIDTH_SEL_O = 3'h0;  // W_R1
      CV_CCR_OP_O = 4'h9;  // OP_XXXXXXXX
      CV_DATA_ALU_COND_SEL_O = 2'h0;  // ZERO_BIT
    end


    // 0878: 
    // 0879: ; //////////////////////////////////////////// SBC
    // 0880: ; //
    // 0881: SBC:
    // 0882:   decode pg1_JTA SBC     $82         ; SBCA (imm)
    // 0883:   decode pg1_R1  A       $82         ; SBCA (imm)
    // 0884:   decode pg1_R2  IDATA   $82         ; SBCA (imm)
    // 0885:                                                 
    // 0886:   decode pg1_JTA SBC     $C2         ; SBCB (imm)
    // 0887:   decode pg1_R1  B       $C2         ; SBCB (imm)
    // 0888:   decode pg1_R2  IDATA   $C2         ; SBCB (imm)
    // 0889:                              
    // 0890:   decode pg1_JTB SBC     $92 $A2 $B2 ; SBCA (dir idx ext)
    // 0891:   decode pg1_R1  A       $92 $A2 $B2 ; SBCA (dir idx ext)
    // 0892:   decode pg1_R2  DMEM_RD $92 $A2 $B2 ; SBCA (dir idx ext)
    // 0893:                                                      
    // 0894:   decode pg1_JTB SBC     $D2 $E2 $F2 ; SBCB (dir idx ext)
    // 0895:   decode pg1_R1  B       $D2 $E2 $F2 ; SBCB (dir idx ext)
    // 0896:   decode pg1_R2  DMEM_RD $D2 $E2 $F2 ; SBCB (dir idx ext)
    // 0897: 
    // 0898:   DATA_SUBC       R1, R2
    // 0899:   DATA_WRITE      R1
    // 0900: 
    // 0901:   SET_DATA_WIDTH  W_R1
    // 0902: 
    // 0903:   CCR_OP_W        OP_ooooXXXX ; INFO: Spec H Undefined, Turbo9 H not affected
    // 0904: 
    // 0905:   JUMP_TABLE_A_NEXT_PC
    // 0906:   end_state
    9'h020: begin
      CV_MICRO_SEQ_OP_O = 3'h5;  // OP_JUMP_TABLE_A_NEXT_PC
      CV_DATA_ALU_A_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_B_SEL_O = 3'h0;  // R2
      CV_DATA_ALU_WR_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_OP_O = 3'h1;  // A_PLUS_NOT_B
      CV_DATA_WIDTH_SEL_O = 3'h0;  // W_R1
      CV_CCR_OP_O = 4'h2;  // OP_OOOOXXXX
      CV_DATA_ALU_COND_SEL_O = 2'h2;  // CARRY_BIT
    end


    // 0907: 
    // 0908: ; //////////////////////////////////////////// SUB
    // 0909: ; //
    // 0910: SUB:
    // 0911:   decode pg1_JTA SUB     $80         ; SUBA (imm)
    // 0912:   decode pg1_R1  A       $80         ; SUBA (imm)
    // 0913:   decode pg1_R2  IDATA   $80         ; SUBA (imm)
    // 0914:                                                 
    // 0915:   decode pg1_JTA SUB     $C0         ; SUBB (imm)
    // 0916:   decode pg1_R1  B       $C0         ; SUBB (imm)
    // 0917:   decode pg1_R2  IDATA   $C0         ; SUBB (imm)
    // 0918:                                                 
    // 0919:   decode pg1_JTA SUB     $83         ; SUBD (imm)
    // 0920:   decode pg1_R1  D       $83         ; SUBD (imm)
    // 0921:   decode pg1_R2  IDATA   $83         ; SUBD (imm)
    // 0922:                              
    // 0923:   decode pg1_JTB SUB     $90 $A0 $B0 ; SUBA (dir idx ext)
    // 0924:   decode pg1_R1  A       $90 $A0 $B0 ; SUBA (dir idx ext)
    // 0925:   decode pg1_R2  DMEM_RD $90 $A0 $B0 ; SUBA (dir idx ext)
    // 0926:                                                       
    // 0927:   decode pg1_JTB SUB     $D0 $E0 $F0 ; SUBB (dir idx ext)
    // 0928:   decode pg1_R1  B       $D0 $E0 $F0 ; SUBB (dir idx ext)
    // 0929:   decode pg1_R2  DMEM_RD $D0 $E0 $F0 ; SUBB (dir idx ext)
    // 0930:                                                       
    // 0931:   decode pg1_JTB SUB     $93 $A3 $B3 ; SUBD (dir idx ext)
    // 0932:   decode pg1_R1  D       $93 $A3 $B3 ; SUBD (dir idx ext)
    // 0933:   decode pg1_R2  DMEM_RD $93 $A3 $B3 ; SUBD (dir idx ext)
    // 0934: 
    // 0935:   DATA_SUB        R1, R2
    // 0936:   DATA_WRITE      R1
    // 0937: 
    // 0938:   SET_DATA_WIDTH  W_R1
    // 0939: 
    // 0940:   CCR_OP_W        OP_ooooXXXX ; INFO: Spec H Undefined, Turbo9 H not affected (8-bit)
    // 0941: 
    // 0942:   JUMP_TABLE_A_NEXT_PC
    // 0943:   end_state
    9'h021: begin
      CV_MICRO_SEQ_OP_O = 3'h5;  // OP_JUMP_TABLE_A_NEXT_PC
      CV_DATA_ALU_A_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_B_SEL_O = 3'h0;  // R2
      CV_DATA_ALU_WR_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_OP_O = 3'h1;  // A_PLUS_NOT_B
      CV_DATA_WIDTH_SEL_O = 3'h0;  // W_R1
      CV_CCR_OP_O = 4'h2;  // OP_OOOOXXXX
      CV_DATA_ALU_COND_SEL_O = 2'h0;  // ZERO_BIT
    end


    // 0944: 
    // 0945: 
    // 0946: ; //
    // 0947: ; ////////////////////////////////////////////////////////////////////////////
    // 0948: 
    // 0949: 
    // 0950: ; ////////////////////////////////////////////////////////////////////////////
    // 0951: ;                        STORE INSTRUCTIONS
    // 0952: ; ////////////////////////////////////////////////////////////////////////////
    // 0953: ; //
    // 0954: 
    // 0955: ; //////////////////////////////////////////// ST
    // 0956: ; //
    // 0957: ST:
    // 0958:   decode pg1_JTA ST    $97 $B7 ; STA (dir ext)
    // 0959:   decode pg1_R1  A     $97 $B7 ; STA (dir ext)
    // 0960:   decode pg1_AR  IDATA $97 $B7 ; STA (dir ext)
    // 0961:                            
    // 0962:   decode pg1_JTA ST    $D7 $F7 ; STB (dir ext)
    // 0963:   decode pg1_R1  B     $D7 $F7 ; STB (dir ext)
    // 0964:   decode pg1_AR  IDATA $D7 $F7 ; STB (dir ext)
    // 0965:                            
    // 0966:   decode pg1_JTA ST    $DD $FD ; STD (dir ext)
    // 0967:   decode pg1_R1  D     $DD $FD ; STD (dir ext)
    // 0968:   decode pg1_AR  IDATA $DD $FD ; STD (dir ext)
    // 0969:                            
    // 0970:   decode pg2_JTA ST    $DF $FF ; STS (dir ext)
    // 0971:   decode pg2_R1  S     $DF $FF ; STS (dir ext)
    // 0972:   decode pg2_AR  IDATA $DF $FF ; STS (dir ext)
    // 0973:                            
    // 0974:   decode pg1_JTA ST    $DF $FF ; STU (dir ext)
    // 0975:   decode pg1_R1  U     $DF $FF ; STU (dir ext)
    // 0976:   decode pg1_AR  IDATA $DF $FF ; STU (dir ext)
    // 0977:                            
    // 0978:   decode pg1_JTA ST    $9F $BF ; STX (dir ext)
    // 0979:   decode pg1_R1  X     $9F $BF ; STX (dir ext)
    // 0980:   decode pg1_AR  IDATA $9F $BF ; STX (dir ext)
    // 0981:                            
    // 0982:   decode pg2_JTA ST    $9F $BF ; STY (dir ext)
    // 0983:   decode pg2_R1  Y     $9F $BF ; STY (dir ext)
    // 0984:   decode pg2_AR  IDATA $9F $BF ; STY (dir ext)
    // 0985:                            
    // 0986:   decode pg1_JTB ST    $A7     ; STA (idx)
    // 0987:   decode pg1_R1  A     $A7     ; STA (idx)
    // 0988:   decode pg1_AR  EA    $A7     ; STA (idx)
    // 0989:                                    
    // 0990:   decode pg1_JTB ST    $E7     ; STB (idx)
    // 0991:   decode pg1_R1  B     $E7     ; STB (idx)
    // 0992:   decode pg1_AR  EA    $E7     ; STB (idx)
    // 0993:                                    
    // 0994:   decode pg1_JTB ST    $ED     ; STD (idx)
    // 0995:   decode pg1_R1  D     $ED     ; STD (idx)
    // 0996:   decode pg1_AR  EA    $ED     ; STD (idx)
    // 0997:                                    
    // 0998:   decode pg2_JTB ST    $EF     ; STS (idx)
    // 0999:   decode pg2_R1  S     $EF     ; STS (idx)
    // 1000:   decode pg2_AR  EA    $EF     ; STS (idx)
    // 1001:                                    
    // 1002:   decode pg1_JTB ST    $EF     ; STU (idx)
    // 1003:   decode pg1_R1  U     $EF     ; STU (idx)
    // 1004:   decode pg1_AR  EA    $EF     ; STU (idx)
    // 1005:                                    
    // 1006:   decode pg1_JTB ST    $AF     ; STX (idx)
    // 1007:   decode pg1_R1  X     $AF     ; STX (idx)
    // 1008:   decode pg1_AR  EA    $AF     ; STX (idx)
    // 1009:                                    
    // 1010:   decode pg2_JTB ST    $AF     ; STY (idx)
    // 1011:   decode pg2_R1  Y     $AF     ; STY (idx)
    // 1012:   decode pg2_AR  EA    $AF     ; STY (idx)
    // 1013: 
    // 1014:   DATA_PASS_A     R1
    // 1015: 
    // 1016:   SET_DATA_WIDTH  W_R1
    // 1017: 
    // 1018:   CCR_OP_W        OP_ooooXXXo
    // 1019: 
    // 1020:   ADDR_PASS       AR
    // 1021:   DMEM_STORE_W
    // 1022: 
    // 1023:   JUMP_TABLE_A_NEXT_PC
    // 1024:   end_state
    9'h022: begin
      CV_MICRO_SEQ_OP_O = 3'h5;  // OP_JUMP_TABLE_A_NEXT_PC
      CV_DATA_ALU_A_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_B_SEL_O = 3'h7;  // ZERO
      CV_ADDR_ALU_REG_SEL_O = 4'h8;  // AR
      CV_DATA_ALU_OP_O = 3'h0;  // A_PLUS_B
      CV_DATA_WIDTH_SEL_O = 3'h0;  // W_R1
      CV_CCR_OP_O = 4'h4;  // OP_OOOOXXXO
      CV_DATA_ALU_COND_SEL_O = 2'h0;  // ZERO_BIT
      CV_DMEM_OP_O = 2'h3;  // DMEM_OP_WR
    end


    // 1025: 
    // 1026: ; //
    // 1027: ; ////////////////////////////////////////////////////////////////////////////
    // 1028: 
    // 1029: 
    // 1030: ; ////////////////////////////////////////////////////////////////////////////
    // 1031: ;                   MODIFY MEMORY OR ACCUMULATOR INSTRUCTIONS
    // 1032: ; ////////////////////////////////////////////////////////////////////////////
    // 1033: ; //
    // 1034: 
    // 1035: ; //////////////////////////////////////////// ASL LSL
    // 1036: ; //
    // 1037: ASL_LSL:
    // 1038:   decode pg1_JTA ASL_LSL $48         ; ASLA LSLA (inh)
    // 1039:   decode pg1_R1  A       $48         ; ASLA LSLA (inh)
    // 1040:                                         
    // 1041:   decode pg1_JTA ASL_LSL $58         ; ASLB LSLB (inh)
    // 1042:   decode pg1_R1  B       $58         ; ASLB LSLB (inh)
    // 1043:                              
    // 1044:   decode pg1_JTB ASL_LSL $08 $68 $78 ; ASL LSL (dir idx ext)
    // 1045:   decode pg1_R1  DMEM_RD $08 $68 $78 ; ASL LSL (dir idx ext)
    // 1046: 
    // 1047:   DATA_LSHIFT_W   R1, ZERO_BIT
    // 1048:   DATA_WRITE      R1
    // 1049: 
    // 1050:   SET_DATA_WIDTH  W_R1
    // 1051: 
    // 1052:   CCR_OP_W        OP_ooooXXXX ; INFO: Spec H Undefined, Turbo9 H not affected
    // 1053: 
    // 1054:   ADDR_PASS       EA
    // 1055:   DMEM_STORE_W ; Disabled for inherent addressing modes
    // 1056: 
    // 1057:   JUMP_TABLE_A_NEXT_PC
    // 1058:   end_state
    9'h023: begin
      CV_MICRO_SEQ_OP_O = 3'h5;  // OP_JUMP_TABLE_A_NEXT_PC
      CV_DATA_ALU_A_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_B_SEL_O = 3'h7;  // ZERO
      CV_DATA_ALU_WR_SEL_O = 4'h8;  // R1
      CV_ADDR_ALU_REG_SEL_O = 4'hc;  // EA
      CV_DATA_ALU_OP_O = 3'h2;  // LSHIFT_A
      CV_DATA_WIDTH_SEL_O = 3'h0;  // W_R1
      CV_CCR_OP_O = 4'h2;  // OP_OOOOXXXX
      CV_DATA_ALU_COND_SEL_O = 2'h0;  // ZERO_BIT
      CV_DMEM_OP_O = 2'h3;  // DMEM_OP_WR
    end


    // 1059: 
    // 1060: ; //////////////////////////////////////////// ASR
    // 1061: ; //
    // 1062: ASR:
    // 1063:   decode pg1_JTA ASR     $47         ; ASRA (inh)
    // 1064:   decode pg1_R1  A       $47         ; ASRA (inh)
    // 1065:                                          
    // 1066:   decode pg1_JTA ASR     $57         ; ASRB (inh)
    // 1067:   decode pg1_R1  B       $57         ; ASRB (inh)
    // 1068:                              
    // 1069:   decode pg1_JTB ASR     $07 $67 $77 ; ASR (dir idx ext)
    // 1070:   decode pg1_R1  DMEM_RD $07 $67 $77 ; ASR (dir idx ext)
    // 1071: 
    // 1072:   DATA_RSHIFT_W   SIGN_BIT, R1
    // 1073:   DATA_WRITE      R1
    // 1074: 
    // 1075:   SET_DATA_WIDTH  W_R1
    // 1076: 
    // 1077:   CCR_OP_W        OP_ooooXXoX ; INFO: Spec H Undefined, Turbo9 H not affected
    // 1078: 
    // 1079:   ADDR_PASS       EA
    // 1080:   DMEM_STORE_W  ; Disabled for inherent addressing modes
    // 1081: 
    // 1082:   JUMP_TABLE_A_NEXT_PC
    // 1083:   end_state
    9'h024: begin
      CV_MICRO_SEQ_OP_O = 3'h5;  // OP_JUMP_TABLE_A_NEXT_PC
      CV_DATA_ALU_A_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_B_SEL_O = 3'h7;  // ZERO
      CV_DATA_ALU_WR_SEL_O = 4'h8;  // R1
      CV_ADDR_ALU_REG_SEL_O = 4'hc;  // EA
      CV_DATA_ALU_OP_O = 3'h3;  // RSHIFT_A
      CV_DATA_WIDTH_SEL_O = 3'h0;  // W_R1
      CV_CCR_OP_O = 4'h6;  // OP_OOOOXXOX
      CV_DATA_ALU_COND_SEL_O = 2'h3;  // SIGN_BIT
      CV_DMEM_OP_O = 2'h3;  // DMEM_OP_WR
    end


    // 1084: 
    // 1085: ; //////////////////////////////////////////// CLR
    // 1086: ; //
    // 1087: ; // This is a little different than other memory modify
    // 1088: ; // instructions. It does not load the memory first like
    // 1089: ; // the 6809. It just writes a zero to be more efficient
    // 1090: CLR:
    // 1091: 
    // 1092:   decode pg1_JTA CLR     $4F     ; CLRA (inh)
    // 1093:   decode pg1_R1  A       $4F     ; CLRA (inh)
    // 1094:                                      
    // 1095:   decode pg1_JTA CLR     $5F     ; CLRB (inh)
    // 1096:   decode pg1_R1  B       $5F     ; CLRB (inh)
    // 1097:                            
    // 1098:   decode pg1_JTA CLR     $0F $7F ; CLR (dir ext)
    // 1099:   decode pg1_R1  DMEM_RD $0F $7F ; CLR (dir ext) sets 8bit width
    // 1100:   decode pg1_AR  IDATA   $0F $7F ; CLR (dir ext)
    // 1101:                            
    // 1102:   decode pg1_JTB CLR     $6F     ; CLR (idx)
    // 1103:   decode pg1_R1  DMEM_RD $6F     ; CLR (idx) sets 8bit width
    // 1104:   decode pg1_AR  EA      $6F     ; CLR (idx)
    // 1105: 
    // 1106:   DATA_PASS_B     ZERO 
    // 1107:   DATA_WRITE      R1
    // 1108: 
    // 1109:   SET_DATA_WIDTH  W_R1
    // 1110: 
    // 1111:   CCR_OP_W        OP_ooooXXXX
    // 1112: 
    // 1113:   ADDR_PASS       AR
    // 1114:   DMEM_STORE_W  ; Disabled for inherent addressing modes
    // 1115: 
    // 1116:   JUMP_TABLE_A_NEXT_PC
    // 1117:   end_state
    9'h025: begin
      CV_MICRO_SEQ_OP_O = 3'h5;  // OP_JUMP_TABLE_A_NEXT_PC
      CV_DATA_ALU_A_SEL_O = 4'hf;  // ZERO
      CV_DATA_ALU_B_SEL_O = 3'h7;  // ZERO
      CV_DATA_ALU_WR_SEL_O = 4'h8;  // R1
      CV_ADDR_ALU_REG_SEL_O = 4'h8;  // AR
      CV_DATA_ALU_OP_O = 3'h0;  // A_PLUS_B
      CV_DATA_WIDTH_SEL_O = 3'h0;  // W_R1
      CV_CCR_OP_O = 4'h2;  // OP_OOOOXXXX
      CV_DATA_ALU_COND_SEL_O = 2'h0;  // ZERO_BIT
      CV_DMEM_OP_O = 2'h3;  // DMEM_OP_WR
    end


    // 1118: 
    // 1119: ; //////////////////////////////////////////// COM
    // 1120: ; //
    // 1121: COM:
    // 1122:   decode pg1_JTA COM     $43         ; COMA (inh)
    // 1123:   decode pg1_R1  A       $43         ; COMA (inh)
    // 1124:   decode pg1_R2  A       $43         ; COMA (inh)
    // 1125:                                          
    // 1126:   decode pg1_JTA COM     $53         ; COMB (inh)
    // 1127:   decode pg1_R1  B       $53         ; COMB (inh)
    // 1128:   decode pg1_R2  B       $53         ; COMB (inh)
    // 1129:                              
    // 1130:   decode pg1_JTB COM     $03 $63 $73 ; COM (dir idx ext)
    // 1131:   decode pg1_R1  DMEM_RD $03 $63 $73 ; COM (dir idx ext) sets 8bit width
    // 1132:   decode pg1_R2  DMEM_RD $03 $63 $73 ; COM (dir idx ext)
    // 1133: 
    // 1134:   DATA_INVERT_B   R2
    // 1135:   DATA_WRITE      R1
    // 1136: 
    // 1137:   SET_DATA_WIDTH  W_R1
    // 1138: 
    // 1139:   CCR_OP_W        OP_ooooXXXX ; INFO Carry should be set to 1 for 6800 compatibility
    // 1140: 
    // 1141:   ADDR_PASS       EA
    // 1142:   DMEM_STORE_W ; Disabled for inherent addressing modes
    // 1143: 
    // 1144:   JUMP_TABLE_A_NEXT_PC
    // 1145:   end_state
    9'h026: begin
      CV_MICRO_SEQ_OP_O = 3'h5;  // OP_JUMP_TABLE_A_NEXT_PC
      CV_DATA_ALU_A_SEL_O = 4'hf;  // ZERO
      CV_DATA_ALU_B_SEL_O = 3'h0;  // R2
      CV_DATA_ALU_WR_SEL_O = 4'h8;  // R1
      CV_ADDR_ALU_REG_SEL_O = 4'hc;  // EA
      CV_DATA_ALU_OP_O = 3'h1;  // A_PLUS_NOT_B
      CV_DATA_WIDTH_SEL_O = 3'h0;  // W_R1
      CV_CCR_OP_O = 4'h2;  // OP_OOOOXXXX
      CV_DATA_ALU_COND_SEL_O = 2'h1;  // ONE_BIT
      CV_DMEM_OP_O = 2'h3;  // DMEM_OP_WR
    end


    // 1146: 
    // 1147: ; //////////////////////////////////////////// DEC
    // 1148: ; //
    // 1149: DEC:
    // 1150:   decode pg1_JTA DEC     $4A         ; DECA (inh)
    // 1151:   decode pg1_R1  A       $4A         ; DECA (inh)
    // 1152:                                          
    // 1153:   decode pg1_JTA DEC     $5A         ; DECB (inh)
    // 1154:   decode pg1_R1  B       $5A         ; DECB (inh)
    // 1155:                              
    // 1156:   decode pg1_JTB DEC     $0A $6A $7A ; DEC (dir idx ext)
    // 1157:   decode pg1_R1  DMEM_RD $0A $6A $7A ; DEC (dir idx ext)
    // 1158: 
    // 1159:   DATA_DEC        R1
    // 1160:   DATA_WRITE      R1
    // 1161: 
    // 1162:   SET_DATA_WIDTH  W_R1
    // 1163:   
    // 1164:   CCR_OP_W        OP_ooooXXXo
    // 1165: 
    // 1166:   ADDR_PASS       EA
    // 1167:   DMEM_STORE_W ; Disabled for inherent addressing modes
    // 1168: 
    // 1169:   JUMP_TABLE_A_NEXT_PC
    // 1170:   end_state
    9'h027: begin
      CV_MICRO_SEQ_OP_O = 3'h5;  // OP_JUMP_TABLE_A_NEXT_PC
      CV_DATA_ALU_A_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_B_SEL_O = 3'h7;  // ZERO
      CV_DATA_ALU_WR_SEL_O = 4'h8;  // R1
      CV_ADDR_ALU_REG_SEL_O = 4'hc;  // EA
      CV_DATA_ALU_OP_O = 3'h1;  // A_PLUS_NOT_B
      CV_DATA_WIDTH_SEL_O = 3'h0;  // W_R1
      CV_CCR_OP_O = 4'h4;  // OP_OOOOXXXO
      CV_DATA_ALU_COND_SEL_O = 2'h1;  // ONE_BIT
      CV_DMEM_OP_O = 2'h3;  // DMEM_OP_WR
    end


    // 1171: 
    // 1172: ; //////////////////////////////////////////// INC
    // 1173: ; //
    // 1174: INC:
    // 1175:   decode pg1_JTA INC     $4C         ; INCA (inh)
    // 1176:   decode pg1_R1  A       $4C         ; INCA (inh)
    // 1177:                                          
    // 1178:   decode pg1_JTA INC     $5C         ; INCB (inh)
    // 1179:   decode pg1_R1  B       $5C         ; INCB (inh)
    // 1180:                              
    // 1181:   decode pg1_JTB INC     $0C $6C $7C ; INC (dir idx ext)
    // 1182:   decode pg1_R1  DMEM_RD $0C $6C $7C ; INC (dir idx ext)
    // 1183: 
    // 1184:   DATA_INC        R1
    // 1185:   DATA_WRITE      R1
    // 1186: 
    // 1187:   SET_DATA_WIDTH  W_R1
    // 1188: 
    // 1189:   CCR_OP_W        OP_ooooXXXo
    // 1190: 
    // 1191:   ADDR_PASS       EA
    // 1192:   DMEM_STORE_W ; Disabled for inherent addressing modes
    // 1193: 
    // 1194:   JUMP_TABLE_A_NEXT_PC
    // 1195:   end_state
    9'h028: begin
      CV_MICRO_SEQ_OP_O = 3'h5;  // OP_JUMP_TABLE_A_NEXT_PC
      CV_DATA_ALU_A_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_B_SEL_O = 3'h7;  // ZERO
      CV_DATA_ALU_WR_SEL_O = 4'h8;  // R1
      CV_ADDR_ALU_REG_SEL_O = 4'hc;  // EA
      CV_DATA_ALU_OP_O = 3'h0;  // A_PLUS_B
      CV_DATA_WIDTH_SEL_O = 3'h0;  // W_R1
      CV_CCR_OP_O = 4'h4;  // OP_OOOOXXXO
      CV_DATA_ALU_COND_SEL_O = 2'h1;  // ONE_BIT
      CV_DMEM_OP_O = 2'h3;  // DMEM_OP_WR
    end


    // 1196: 
    // 1197: ; //////////////////////////////////////////// LSR
    // 1198: ; //
    // 1199: LSR:
    // 1200:   decode pg1_JTA LSR     $44         ; LSRA (inh)
    // 1201:   decode pg1_R1  A       $44         ; LSRA (inh)
    // 1202:                                          
    // 1203:   decode pg1_JTA LSR     $54         ; LSRB (inh)
    // 1204:   decode pg1_R1  B       $54         ; LSRB (inh)
    // 1205:                              
    // 1206:   decode pg1_JTB LSR     $04 $64 $74 ; LSR (dir idx ext)
    // 1207:   decode pg1_R1  DMEM_RD $04 $64 $74 ; LSR (dir idx ext)
    // 1208: 
    // 1209:   DATA_RSHIFT_W   ZERO_BIT, R1
    // 1210:   DATA_WRITE      R1
    // 1211: 
    // 1212:   SET_DATA_WIDTH  W_R1
    // 1213: 
    // 1214:   CCR_OP_W        OP_ooooXXoX
    // 1215: 
    // 1216:   ADDR_PASS       EA
    // 1217:   DMEM_STORE_W ; Disabled for inherent addressing modes
    // 1218: 
    // 1219:   JUMP_TABLE_A_NEXT_PC
    // 1220:   end_state
    9'h029: begin
      CV_MICRO_SEQ_OP_O = 3'h5;  // OP_JUMP_TABLE_A_NEXT_PC
      CV_DATA_ALU_A_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_B_SEL_O = 3'h7;  // ZERO
      CV_DATA_ALU_WR_SEL_O = 4'h8;  // R1
      CV_ADDR_ALU_REG_SEL_O = 4'hc;  // EA
      CV_DATA_ALU_OP_O = 3'h3;  // RSHIFT_A
      CV_DATA_WIDTH_SEL_O = 3'h0;  // W_R1
      CV_CCR_OP_O = 4'h6;  // OP_OOOOXXOX
      CV_DATA_ALU_COND_SEL_O = 2'h0;  // ZERO_BIT
      CV_DMEM_OP_O = 2'h3;  // DMEM_OP_WR
    end


    // 1221: 
    // 1222: ; //////////////////////////////////////////// NEG
    // 1223: ; //
    // 1224: NEG:
    // 1225:   decode pg1_JTA NEG     $40         ; NEGA (inh)
    // 1226:   decode pg1_R1  A       $40         ; NEGA (inh)
    // 1227:   decode pg1_R2  A       $40         ; NEGA (inh)
    // 1228:                                          
    // 1229:   decode pg1_JTA NEG     $50         ; NEGB (inh)
    // 1230:   decode pg1_R1  B       $50         ; NEGB (inh)
    // 1231:   decode pg1_R2  B       $50         ; NEGB (inh)
    // 1232:                                          
    // 1233:   decode pg1_JTB NEG     $00 $60 $70 ; NEG (dir idx ext)
    // 1234:   decode pg1_R1  DMEM_RD $00 $60 $70 ; NEG (dir idx ext) sets 8bit width
    // 1235:   decode pg1_R2  DMEM_RD $00 $60 $70 ; NEG (dir idx ext)
    // 1236: 
    // 1237:   DATA_SUB        ZERO, R2
    // 1238:   DATA_WRITE      R1
    // 1239: 
    // 1240:   SET_DATA_WIDTH  W_R1
    // 1241: 
    // 1242:   CCR_OP_W        OP_ooooXXXX ; INFO: Spec H Undefined, Turbo9 H not affected
    // 1243: 
    // 1244:   ADDR_PASS       EA
    // 1245:   DMEM_STORE_W ; Disabled for inherent addressing modes
    // 1246: 
    // 1247:   JUMP_TABLE_A_NEXT_PC
    // 1248:   end_state
    9'h02a: begin
      CV_MICRO_SEQ_OP_O = 3'h5;  // OP_JUMP_TABLE_A_NEXT_PC
      CV_DATA_ALU_A_SEL_O = 4'hf;  // ZERO
      CV_DATA_ALU_B_SEL_O = 3'h0;  // R2
      CV_DATA_ALU_WR_SEL_O = 4'h8;  // R1
      CV_ADDR_ALU_REG_SEL_O = 4'hc;  // EA
      CV_DATA_ALU_OP_O = 3'h1;  // A_PLUS_NOT_B
      CV_DATA_WIDTH_SEL_O = 3'h0;  // W_R1
      CV_CCR_OP_O = 4'h2;  // OP_OOOOXXXX
      CV_DATA_ALU_COND_SEL_O = 2'h0;  // ZERO_BIT
      CV_DMEM_OP_O = 2'h3;  // DMEM_OP_WR
    end


    // 1249: 
    // 1250: ; //////////////////////////////////////////// ROL
    // 1251: ; //
    // 1252: ROL:
    // 1253:   decode pg1_JTA ROL     $49         ; ROLA (inh)
    // 1254:   decode pg1_R1  A       $49         ; ROLA (inh)
    // 1255:                                          
    // 1256:   decode pg1_JTA ROL     $59         ; ROLB (inh)
    // 1257:   decode pg1_R1  B       $59         ; ROLB (inh)
    // 1258:                                          
    // 1259:   decode pg1_JTB ROL     $09 $69 $79 ; ROL (dir idx ext)
    // 1260:   decode pg1_R1  DMEM_RD $09 $69 $79 ; ROL (dir idx ext)
    // 1261: 
    // 1262:   DATA_LSHIFT_W   R1, CARRY_BIT
    // 1263:   DATA_WRITE      R1
    // 1264: 
    // 1265:   SET_DATA_WIDTH  W_R1
    // 1266: 
    // 1267:   CCR_OP_W        OP_ooooXXXX
    // 1268: 
    // 1269:   ADDR_PASS       EA
    // 1270:   DMEM_STORE_W ; Disabled for inherent addressing modes
    // 1271: 
    // 1272:   JUMP_TABLE_A_NEXT_PC
    // 1273:   end_state
    9'h02b: begin
      CV_MICRO_SEQ_OP_O = 3'h5;  // OP_JUMP_TABLE_A_NEXT_PC
      CV_DATA_ALU_A_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_B_SEL_O = 3'h7;  // ZERO
      CV_DATA_ALU_WR_SEL_O = 4'h8;  // R1
      CV_ADDR_ALU_REG_SEL_O = 4'hc;  // EA
      CV_DATA_ALU_OP_O = 3'h2;  // LSHIFT_A
      CV_DATA_WIDTH_SEL_O = 3'h0;  // W_R1
      CV_CCR_OP_O = 4'h2;  // OP_OOOOXXXX
      CV_DATA_ALU_COND_SEL_O = 2'h2;  // CARRY_BIT
      CV_DMEM_OP_O = 2'h3;  // DMEM_OP_WR
    end


    // 1274: 
    // 1275: ; //////////////////////////////////////////// ROR
    // 1276: ; //
    // 1277: ROR:
    // 1278:   decode pg1_JTA ROR     $46         ; RORA (inh)
    // 1279:   decode pg1_R1  A       $46         ; RORA (inh)
    // 1280:                                                    
    // 1281:   decode pg1_JTA ROR     $56         ; RORB (inh)
    // 1282:   decode pg1_R1  B       $56         ; RORB (inh)
    // 1283:                              
    // 1284:   decode pg1_JTB ROR     $06 $66 $76 ; ROR (dir idx ext)
    // 1285:   decode pg1_R1  DMEM_RD $06 $66 $76 ; ROR (dir idx ext)
    // 1286: 
    // 1287:   DATA_RSHIFT_W   CARRY_BIT, R1
    // 1288:   DATA_WRITE      R1
    // 1289: 
    // 1290:   SET_DATA_WIDTH  W_R1
    // 1291: 
    // 1292:   CCR_OP_W        OP_ooooXXoX
    // 1293: 
    // 1294:   ADDR_PASS       EA
    // 1295:   DMEM_STORE_W ; Disabled for inherent addressing modes
    // 1296: 
    // 1297:   JUMP_TABLE_A_NEXT_PC
    // 1298:   end_state
    9'h02c: begin
      CV_MICRO_SEQ_OP_O = 3'h5;  // OP_JUMP_TABLE_A_NEXT_PC
      CV_DATA_ALU_A_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_B_SEL_O = 3'h7;  // ZERO
      CV_DATA_ALU_WR_SEL_O = 4'h8;  // R1
      CV_ADDR_ALU_REG_SEL_O = 4'hc;  // EA
      CV_DATA_ALU_OP_O = 3'h3;  // RSHIFT_A
      CV_DATA_WIDTH_SEL_O = 3'h0;  // W_R1
      CV_CCR_OP_O = 4'h6;  // OP_OOOOXXOX
      CV_DATA_ALU_COND_SEL_O = 2'h2;  // CARRY_BIT
      CV_DMEM_OP_O = 2'h3;  // DMEM_OP_WR
    end


    // 1299: 
    // 1300: ; //////////////////////////////////////////// TST
    // 1301: ; //
    // 1302: TST:
    // 1303:   decode pg1_JTA TST     $4D         ; TSTA (inh)
    // 1304:   decode pg1_R1  A       $4D         ; TSTA (inh)
    // 1305:                                          
    // 1306:   decode pg1_JTA TST     $5D         ; TSTB (inh)
    // 1307:   decode pg1_R1  B       $5D         ; TSTB (inh)
    // 1308:                              
    // 1309:   decode pg1_JTB TST     $0D $6D $7D ; TST (dir idx ext)
    // 1310:   decode pg1_R1  DMEM_RD $0D $6D $7D ; TST (dir idx ext)
    // 1311: 
    // 1312:   DATA_PASS_A     R1 ; Pass A, B or DMEM
    // 1313: 
    // 1314:   SET_DATA_WIDTH  W_R1
    // 1315: 
    // 1316:   CCR_OP_W        OP_ooooXXXo
    // 1317: 
    // 1318:   JUMP_TABLE_A_NEXT_PC
    // 1319:   end_state
    9'h02d: begin
      CV_MICRO_SEQ_OP_O = 3'h5;  // OP_JUMP_TABLE_A_NEXT_PC
      CV_DATA_ALU_A_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_B_SEL_O = 3'h7;  // ZERO
      CV_DATA_ALU_OP_O = 3'h0;  // A_PLUS_B
      CV_DATA_WIDTH_SEL_O = 3'h0;  // W_R1
      CV_CCR_OP_O = 4'h4;  // OP_OOOOXXXO
      CV_DATA_ALU_COND_SEL_O = 2'h0;  // ZERO_BIT
    end


    // 1320: 
    // 1321: ; //
    // 1322: ; ////////////////////////////////////////////////////////////////////////////
    // 1323: 
    // 1324: 
    // 1325: 
    // 1326: ; ////////////////////////////////////////////////////////////////////////////
    // 1327: ;                        JUMP & BRANCH INSTRUCTIONS
    // 1328: ; ////////////////////////////////////////////////////////////////////////////
    // 1329: ; //
    // 1330: 
    // 1331: ; //////////////////////////////////////////// BRANCH
    // 1332: ; //
    // 1333: BRANCH:
    // 1334:   decode pg1_JTA BRANCH $20 $21 $22 $23 ; BRA BRN BHI BLS
    // 1335:   decode pg1_JTB JMP    $20 $21 $22 $23 ; BRA BRN BHI BLS
    // 1336:   decode pg1_R1  PC     $20 $21 $22 $23 ; BRA BRN BHI BLS
    // 1337:   decode pg1_R2  EA     $20 $21 $22 $23 ; BRA BRN BHI BLS
    // 1338:                                             
    // 1339:   decode pg1_JTA BRANCH $24 $25 $26 $27 ; BCC BCS BNE BEQ
    // 1340:   decode pg1_JTB JMP    $24 $25 $26 $27 ; BCC BCS BNE BEQ
    // 1341:   decode pg1_R1  PC     $24 $25 $26 $27 ; BCC BCS BNE BEQ
    // 1342:   decode pg1_R2  EA     $24 $25 $26 $27 ; BCC BCS BNE BEQ
    // 1343:                                             
    // 1344:   decode pg1_JTA BRANCH $28 $29 $2A $2B ; BVC BVS BPL BMI
    // 1345:   decode pg1_JTB JMP    $28 $29 $2A $2B ; BVC BVS BPL BMI
    // 1346:   decode pg1_R1  PC     $28 $29 $2A $2B ; BVC BVS BPL BMI
    // 1347:   decode pg1_R2  EA     $28 $29 $2A $2B ; BVC BVS BPL BMI
    // 1348:                                             
    // 1349:   decode pg1_JTA BRANCH $2C $2D $2E $2F ; BGE BLT BGT BLE
    // 1350:   decode pg1_JTB JMP    $2C $2D $2E $2F ; BGE BLT BGT BLE
    // 1351:   decode pg1_R1  PC     $2C $2D $2E $2F ; BGE BLT BGT BLE
    // 1352:   decode pg1_R2  EA     $2C $2D $2E $2F ; BGE BLT BGT BLE
    // 1353:                                             
    // 1354:   decode pg1_JTA BRANCH $16             ; LBRA On page 1!
    // 1355:   decode pg1_JTB JMP    $16             ; LBRA
    // 1356:   decode pg1_R1  PC     $16             ; LBRA 
    // 1357:   decode pg1_R2  EA     $16             ; LBRA 
    // 1358:                 
    // 1359:   decode pg1_JTA BRANCH $8D $17         ; BSR LBSR // FIXME could do this without JUMP_TABLE_A
    // 1360:   decode pg1_JTB JSR    $8D $17         ; BSR LBSR // FIXME check if smaller area
    // 1361:   decode pg1_R1  PC     $8D $17         ; BSR LBSR
    // 1362:   decode pg1_R2  EA     $8D $17         ; BSR LBSR
    // 1363:   decode pg1_AR  S      $8D $17         ; BSR LBSR
    // 1364:                             
    // 1365: ; Another LBRA hidden on Page 2!
    // 1366:   decode pg2_JTA BRANCH $20 $21 $22 $23 ; LBRA LBRN LBHI LBLS
    // 1367:   decode pg2_JTB JMP    $20 $21 $22 $23 ; LBRA LBRN LBHI LBLS
    // 1368:   decode pg2_R1  PC     $20 $21 $22 $23 ; LBRA LBRN LBHI LBLS
    // 1369:   decode pg2_R2  EA     $20 $21 $22 $23 ; LBRA LBRN LBHI LBLS
    // 1370:                                                                   
    // 1371:   decode pg2_JTA BRANCH $24 $25 $26 $27 ; LBCC LBCS LBNE LBEQ
    // 1372:   decode pg2_JTB JMP    $24 $25 $26 $27 ; LBCC LBCS LBNE LBEQ
    // 1373:   decode pg2_R1  PC     $24 $25 $26 $27 ; LBCC LBCS LBNE LBEQ
    // 1374:   decode pg2_R2  EA     $24 $25 $26 $27 ; LBCC LBCS LBNE LBEQ
    // 1375:                                                                   
    // 1376:   decode pg2_JTA BRANCH $28 $29 $2A $2B ; LBVC LBVS LBPL LBMI
    // 1377:   decode pg2_JTB JMP    $28 $29 $2A $2B ; LBVC LBVS LBPL LBMI
    // 1378:   decode pg2_R1  PC     $28 $29 $2A $2B ; LBVC LBVS LBPL LBMI
    // 1379:   decode pg2_R2  EA     $28 $29 $2A $2B ; LBVC LBVS LBPL LBMI
    // 1380:                                                                   
    // 1381:   decode pg2_JTA BRANCH $2C $2D $2E $2F ; LBGE LBLT LBGT LBLE
    // 1382:   decode pg2_JTB JMP    $2C $2D $2E $2F ; LBGE LBLT LBGT LBLE
    // 1383:   decode pg2_R1  PC     $2C $2D $2E $2F ; LBGE LBLT LBGT LBLE
    // 1384:   decode pg2_R2  EA     $2C $2D $2E $2F ; LBGE LBLT LBGT LBLE
    // 1385: 
    // 1386:   DATA_ADD        R1, IDATA ; PC + signed offset
    // 1387:   DATA_WRITE      EA
    // 1388: 
    // 1389:   SET_DATA_WIDTH  W_R1
    // 1390: 
    // 1391:   IF              BRANCH_COND
    // 1392:   JUMP_TABLE_B
    // 1393:   end_state
    9'h02e: begin
      CV_MICRO_SEQ_OP_O = 3'h4;  // OP_JUMP_TABLE_B
      CV_DATA_ALU_A_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_B_SEL_O = 3'h6;  // IDATA
      CV_DATA_ALU_WR_SEL_O = 4'hc;  // EA
      CV_DATA_ALU_OP_O = 3'h0;  // A_PLUS_B
      CV_DATA_WIDTH_SEL_O = 3'h0;  // W_R1
      CV_DATA_ALU_COND_SEL_O = 2'h0;  // ZERO_BIT
      CV_MICRO_SEQ_COND_SEL_O = 4'h8;  // BRANCH_COND
    end


    // 1394: 
    // 1395: GO_NEW_PC:
    // 1396:   JUMP_TABLE_A_NEXT_PC
    // 1397:   end_state
    9'h02f: begin
      CV_MICRO_SEQ_OP_O = 3'h5;  // OP_JUMP_TABLE_A_NEXT_PC
    end


    // 1398: 
    // 1399: ; //////////////////////////////////////////// JMP
    // 1400: ; //
    // 1401: JMP:
    // 1402:   decode pg1_JTA JMP   $0E $7E ; JMP (dir ext)
    // 1403:   decode pg1_R1  PC    $0E $7E ; JMP (dir ext)
    // 1404:   decode pg1_R2  IDATA $0E $7E ; JMP (dir ext)
    // 1405:                                    
    // 1406:   decode pg1_JTB JMP   $6E     ; JMP (idx)
    // 1407:   decode pg1_R1  PC    $6E     ; JMP (idx)
    // 1408:   decode pg1_R2  EA    $6E     ; JMP (idx)
    // 1409: 
    // 1410:   DATA_PASS_B     R2 ; IDATA or EA
    // 1411:   DATA_WRITE      R1 ; PC
    // 1412: 
    // 1413:   JUMP            GO_NEW_PC ; PC must be written before "JUMP_TABLE_A_NEXT_PC"
    // 1414:   end_state
    9'h030: begin
      CV_MICRO_SEQ_OP_O = 3'h1;  // OP_JUMP
      CV_MICRO_SEQ_BRANCH_ADDR_O = 8'h2f;  // GO_NEW_PC
      CV_DATA_ALU_A_SEL_O = 4'hf;  // ZERO
      CV_DATA_ALU_B_SEL_O = 3'h0;  // R2
      CV_DATA_ALU_WR_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_OP_O = 3'h0;  // A_PLUS_B
      CV_DATA_ALU_COND_SEL_O = 2'h0;  // ZERO_BIT
    end


    // 1415: 
    // 1416: 
    // 1417: ; ////////////////////////////////////////////////////////////////////////////
    // 1418: 
    // 1419: 
    // 1420: 
    // 1421: ; ////////////////////////////////////////////////////////////////////////////
    // 1422: ;                        STACK INSTRUCTIONS
    // 1423: ; ////////////////////////////////////////////////////////////////////////////
    // 1424: ; //
    // 1425: 
    // 1426: 
    // 1427: ; //////////////////////////////////////////// JSR
    // 1428: ; //
    // 1429: JSR:
    // 1430:   decode pg1_JTA JSR   $9D $BD ; JSR (dir ext)
    // 1431:   decode pg1_R1  PC    $9D $BD ; JSR (dir ext)
    // 1432:   decode pg1_R2  IDATA $9D $BD ; JSR (dir ext)
    // 1433:   decode pg1_AR  S     $9D $BD ; JSR (dir ext)
    // 1434:                                  
    // 1435:   decode pg1_JTB JSR   $AD     ; JSR (idx)
    // 1436:   decode pg1_R1  PC    $AD     ; JSR (idx)
    // 1437:   decode pg1_R2  EA    $AD     ; JSR (idx)
    // 1438:   decode pg1_AR  S     $AD     ; JSR (idx)
    // 1439: 
    // 1440:   DATA_PASS_A     R1 ; PC
    // 1441: 
    // 1442:   SET_DATA_WIDTH  W_R1
    // 1443: 
    // 1444:   STACK_PUSH      AR
    // 1445:   DMEM_STORE_W
    // 1446: 
    // 1447:   JUMP            JMP 
    // 1448:   end_state
    9'h031: begin
      CV_MICRO_SEQ_OP_O = 3'h1;  // OP_JUMP
      CV_MICRO_SEQ_BRANCH_ADDR_O = 8'h30;  // JMP
      CV_DATA_ALU_A_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_B_SEL_O = 3'h7;  // ZERO
      CV_ADDR_ALU_REG_SEL_O = 4'h8;  // AR
      CV_DATA_ALU_OP_O = 3'h0;  // A_PLUS_B
      CV_DATA_WIDTH_SEL_O = 3'h0;  // W_R1
      CV_DATA_ALU_COND_SEL_O = 2'h0;  // ZERO_BIT
      CV_DMEM_OP_O = 2'h3;  // DMEM_OP_WR
      CV_STACK_OP_O = 2'h2;  // STACK_OP_PUSH
    end


    // 1449: 
    // 1450: ; //////////////////////////////////////////// RTS
    // 1451: ; //
    // 1452: RTS:
    // 1453:   decode pg1_JTA RTS      $39 ; RTS
    // 1454:   decode pg1_R1  PC       $39 ; RTS
    // 1455:   decode pg1_R2  DMEM_RD  $39 ; RTS
    // 1456:   decode pg1_AR  S        $39 ; RTS
    // 1457: 
    // 1458:   SET_DATA_WIDTH  W_R1
    // 1459:   
    // 1460:   STACK_PULL      AR
    // 1461:   DMEM_LOAD_W
    // 1462:   
    // 1463:   JUMP            JMP
    // 1464:   end_state
    9'h032: begin
      CV_MICRO_SEQ_OP_O = 3'h1;  // OP_JUMP
      CV_MICRO_SEQ_BRANCH_ADDR_O = 8'h30;  // JMP
      CV_ADDR_ALU_REG_SEL_O = 4'h8;  // AR
      CV_DATA_WIDTH_SEL_O = 3'h0;  // W_R1
      CV_DMEM_OP_O = 2'h2;  // DMEM_OP_RD
      CV_STACK_OP_O = 2'h1;  // STACK_OP_PULL
    end


    // 1465: 
    // 1466: ; //////////////////////////////////////////// RTI
    // 1467: ; //
    // 1468: RTI:
    // 1469:   decode pg1_JTA RTI      $3B ; RTI
    // 1470:   decode pg1_R1  PC       $3B ; RTI
    // 1471:   decode pg1_R2  DMEM_RD  $3B ; RTI
    // 1472:   decode pg1_AR  S        $3B ; RTI
    // 1473:   
    // 1474:   STACK_PULL      ZERO  ; Prime the decode pipeline!
    // 1475:   end_state
    9'h033: begin
      CV_ADDR_ALU_REG_SEL_O = 4'hf;  // ZERO
      CV_STACK_OP_O = 2'h1;  // STACK_OP_PULL
    end


    // 1476: 
    // 1477:   SET_DATA_WIDTH  W_STACK_REG
    // 1478:   
    // 1479:   STACK_PULL      AR
    // 1480:   DMEM_LOAD_W
    // 1481:   end_state
    9'h034: begin
      CV_ADDR_ALU_REG_SEL_O = 4'h8;  // AR
      CV_DATA_WIDTH_SEL_O = 3'h2;  // W_STACK_REG
      CV_DMEM_OP_O = 2'h2;  // DMEM_OP_RD
      CV_STACK_OP_O = 2'h1;  // STACK_OP_PULL
    end


    // 1482: 
    // 1483: RTI_CCR:
    // 1484:   DATA_PASS_B     DMEM_RD
    // 1485:   DATA_WRITE      STACK_REG
    // 1486: 
    // 1487:   CCR_OP_W        OP_XXXXXXXX ; FIXME get rid of this requirement
    // 1488:   end_state
    9'h035: begin
      CV_DATA_ALU_A_SEL_O = 4'hf;  // ZERO
      CV_DATA_ALU_B_SEL_O = 3'h5;  // DMEM_RD
      CV_DATA_ALU_WR_SEL_O = 4'h0;  // STACK_REG
      CV_DATA_ALU_OP_O = 3'h0;  // A_PLUS_B
      CV_CCR_OP_O = 4'h9;  // OP_XXXXXXXX
      CV_DATA_ALU_COND_SEL_O = 2'h0;  // ZERO_BIT
    end


    // 1489: 
    // 1490: RTI_TEST_E:
    // 1491:   IF              E_CLEAR
    // 1492:   JUMP            RTS
    // 1493:   end_state
    9'h036: begin
      CV_MICRO_SEQ_OP_O = 3'h1;  // OP_JUMP
      CV_MICRO_SEQ_BRANCH_ADDR_O = 8'h32;  // RTS
      CV_MICRO_SEQ_COND_SEL_O = 4'h6;  // E_CLEAR
    end


    // 1494: 
    // 1495: RTI_PUL_ALL:
    // 1496:   SET_DATA_WIDTH  W_STACK_REG
    // 1497:   
    // 1498:   STACK_PULL      AR
    // 1499:   DMEM_LOAD_W
    // 1500:   
    // 1501:   JUMP            PUL_LOOP
    // 1502:   end_state
    9'h037: begin
      CV_MICRO_SEQ_OP_O = 3'h1;  // OP_JUMP
      CV_MICRO_SEQ_BRANCH_ADDR_O = 8'h3a;  // PUL_LOOP
      CV_ADDR_ALU_REG_SEL_O = 4'h8;  // AR
      CV_DATA_WIDTH_SEL_O = 3'h2;  // W_STACK_REG
      CV_DMEM_OP_O = 2'h2;  // DMEM_OP_RD
      CV_STACK_OP_O = 2'h1;  // STACK_OP_PULL
    end


    // 1503: 
    // 1504: 
    // 1505: ; //////////////////////////////////////////// PULS PULU
    // 1506: ; //
    // 1507: PUL:
    // 1508:   decode pg1_JTA PUL  $35 ; PULS
    // 1509:   decode pg1_AR  S    $35 ; PULS
    // 1510: 
    // 1511:   decode pg1_JTA PUL  $37 ; PULU
    // 1512:   decode pg1_AR  U    $37 ; PULU
    // 1513: 
    // 1514:   
    // 1515:   STACK_PULL      ZERO  ; Prime the decode pipeline!
    // 1516:   
    // 1517:   IF              STACK_DONE
    // 1518:   JUMP            NOP
    // 1519:   end_state
    9'h038: begin
      CV_MICRO_SEQ_OP_O = 3'h1;  // OP_JUMP
      CV_MICRO_SEQ_BRANCH_ADDR_O = 8'hc;  // NOP
      CV_ADDR_ALU_REG_SEL_O = 4'hf;  // ZERO
      CV_MICRO_SEQ_COND_SEL_O = 4'h2;  // STACK_DONE
      CV_STACK_OP_O = 2'h1;  // STACK_OP_PULL
    end


    // 1520:   
    // 1521:   SET_DATA_WIDTH  W_STACK_REG
    // 1522:   
    // 1523:   STACK_PULL      AR
    // 1524:   DMEM_LOAD_W
    // 1525:   
    // 1526:   IF              STACK_DONE
    // 1527:   JUMP            PUL_DONE
    // 1528:   end_state
    9'h039: begin
      CV_MICRO_SEQ_OP_O = 3'h1;  // OP_JUMP
      CV_MICRO_SEQ_BRANCH_ADDR_O = 8'h3b;  // PUL_DONE
      CV_ADDR_ALU_REG_SEL_O = 4'h8;  // AR
      CV_DATA_WIDTH_SEL_O = 3'h2;  // W_STACK_REG
      CV_MICRO_SEQ_COND_SEL_O = 4'h2;  // STACK_DONE
      CV_DMEM_OP_O = 2'h2;  // DMEM_OP_RD
      CV_STACK_OP_O = 2'h1;  // STACK_OP_PULL
    end


    // 1529: 
    // 1530: PUL_LOOP:
    // 1531:   DATA_PASS_B     DMEM_RD
    // 1532:   DATA_WRITE      STACK_REG
    // 1533: 
    // 1534:   CCR_OP_W        OP_XXXXXXXX ; FIXME get rid of this requirement
    // 1535:   
    // 1536:   SET_DATA_WIDTH  W_STACK_REG
    // 1537: 
    // 1538:   STACK_PULL      AR
    // 1539:   DMEM_LOAD_W
    // 1540: 
    // 1541:   IF              STACK_NEXT
    // 1542:   JUMP            PUL_LOOP
    // 1543:   end_state
    9'h03a: begin
      CV_MICRO_SEQ_OP_O = 3'h1;  // OP_JUMP
      CV_MICRO_SEQ_BRANCH_ADDR_O = 8'h3a;  // PUL_LOOP
      CV_DATA_ALU_A_SEL_O = 4'hf;  // ZERO
      CV_DATA_ALU_B_SEL_O = 3'h5;  // DMEM_RD
      CV_DATA_ALU_WR_SEL_O = 4'h0;  // STACK_REG
      CV_ADDR_ALU_REG_SEL_O = 4'h8;  // AR
      CV_DATA_ALU_OP_O = 3'h0;  // A_PLUS_B
      CV_DATA_WIDTH_SEL_O = 3'h2;  // W_STACK_REG
      CV_CCR_OP_O = 4'h9;  // OP_XXXXXXXX
      CV_DATA_ALU_COND_SEL_O = 2'h0;  // ZERO_BIT
      CV_MICRO_SEQ_COND_SEL_O = 4'h3;  // STACK_NEXT
      CV_DMEM_OP_O = 2'h2;  // DMEM_OP_RD
      CV_STACK_OP_O = 2'h1;  // STACK_OP_PULL
    end


    // 1544: 
    // 1545: PUL_DONE:
    // 1546:   DATA_PASS_B     DMEM_RD
    // 1547:   DATA_WRITE      STACK_REG
    // 1548: 
    // 1549:   CCR_OP_W        OP_XXXXXXXX ; FIXME get rid of this requirement
    // 1550: 
    // 1551:   JUMP            GO_NEW_PC ; PC must be written before "JUMP_TABLE_A_NEXT_PC" FIXME?
    // 1552:   end_state
    9'h03b: begin
      CV_MICRO_SEQ_OP_O = 3'h1;  // OP_JUMP
      CV_MICRO_SEQ_BRANCH_ADDR_O = 8'h2f;  // GO_NEW_PC
      CV_DATA_ALU_A_SEL_O = 4'hf;  // ZERO
      CV_DATA_ALU_B_SEL_O = 3'h5;  // DMEM_RD
      CV_DATA_ALU_WR_SEL_O = 4'h0;  // STACK_REG
      CV_DATA_ALU_OP_O = 3'h0;  // A_PLUS_B
      CV_CCR_OP_O = 4'h9;  // OP_XXXXXXXX
      CV_DATA_ALU_COND_SEL_O = 2'h0;  // ZERO_BIT
    end


    // 1553: 
    // 1554: 
    // 1555: ; //////////////////////////////////////////// PSHS PSHU
    // 1556: ; //
    // 1557: PSH:
    // 1558:   decode pg1_JTA PSH   $34 ; PSHS
    // 1559:   decode pg1_AR  S     $34 ; PSHS
    // 1560: 
    // 1561:   decode pg1_JTA PSH   $36 ; PSHU
    // 1562:   decode pg1_AR  U     $36 ; PSHU
    // 1563:   
    // 1564:   STACK_PUSH      ZERO  ; Prime the decode pipeline!
    // 1565: 
    // 1566:   IF              STACK_DONE
    // 1567:   JUMP            NOP
    // 1568:   end_state
    9'h03c: begin
      CV_MICRO_SEQ_OP_O = 3'h1;  // OP_JUMP
      CV_MICRO_SEQ_BRANCH_ADDR_O = 8'hc;  // NOP
      CV_ADDR_ALU_REG_SEL_O = 4'hf;  // ZERO
      CV_MICRO_SEQ_COND_SEL_O = 4'h2;  // STACK_DONE
      CV_STACK_OP_O = 2'h2;  // STACK_OP_PUSH
    end


    // 1569:   
    // 1570: PSH_LOOP:
    // 1571:   DATA_PASS_A     STACK_REG
    // 1572:   
    // 1573:   SET_DATA_WIDTH  W_STACK_REG
    // 1574: 
    // 1575:   STACK_PUSH      AR
    // 1576:   DMEM_STORE_W
    // 1577: 
    // 1578:   IF              STACK_NEXT
    // 1579:   JUMP            PSH_LOOP
    // 1580:   end_state
    9'h03d: begin
      CV_MICRO_SEQ_OP_O = 3'h1;  // OP_JUMP
      CV_MICRO_SEQ_BRANCH_ADDR_O = 8'h3d;  // PSH_LOOP
      CV_DATA_ALU_A_SEL_O = 4'h0;  // STACK_REG
      CV_DATA_ALU_B_SEL_O = 3'h7;  // ZERO
      CV_ADDR_ALU_REG_SEL_O = 4'h8;  // AR
      CV_DATA_ALU_OP_O = 3'h0;  // A_PLUS_B
      CV_DATA_WIDTH_SEL_O = 3'h2;  // W_STACK_REG
      CV_DATA_ALU_COND_SEL_O = 2'h0;  // ZERO_BIT
      CV_MICRO_SEQ_COND_SEL_O = 4'h3;  // STACK_NEXT
      CV_DMEM_OP_O = 2'h3;  // DMEM_OP_WR
      CV_STACK_OP_O = 2'h2;  // STACK_OP_PUSH
    end


    // 1581: 
    // 1582:   JUMP_TABLE_A_NEXT_PC
    // 1583:   end_state
    9'h03e: begin
      CV_MICRO_SEQ_OP_O = 3'h5;  // OP_JUMP_TABLE_A_NEXT_PC
    end


    // 1584: 
    // 1585: 
    // 1586: ; //////////////////////////////////////////// SWI
    // 1587: ; //
    // 1588: SWI:
    // 1589:   decode pg1_JTA SWI      $3F ; SWI
    // 1590:   decode pg1_AR  S        $3F ; SWI
    // 1591:   decode pg1_R1  PC       $3F ; SWI
    // 1592:   decode pg1_R2  DMEM_RD  $3F ; SWI
    // 1593:   
    // 1594:   STACK_PUSH      ZERO  ; Prime the decode pipeline!
    // 1595: 
    // 1596:   CCR_OP_W        OP_1ooooooo ; Set E
    // 1597:   end_state
    9'h03f: begin
      CV_ADDR_ALU_REG_SEL_O = 4'hf;  // ZERO
      CV_CCR_OP_O = 4'h7;  // OP_1OOOOOOO
      CV_STACK_OP_O = 2'h2;  // STACK_OP_PUSH
    end


    // 1598:   
    // 1599: SWI_LOOP:
    // 1600:   DATA_PASS_A     STACK_REG
    // 1601:   
    // 1602:   SET_DATA_WIDTH  W_STACK_REG
    // 1603: 
    // 1604:   STACK_PUSH      AR
    // 1605:   DMEM_STORE_W
    // 1606: 
    // 1607:   IF              STACK_NEXT
    // 1608:   JUMP            SWI_LOOP
    // 1609:   end_state
    9'h040: begin
      CV_MICRO_SEQ_OP_O = 3'h1;  // OP_JUMP
      CV_MICRO_SEQ_BRANCH_ADDR_O = 8'h40;  // SWI_LOOP
      CV_DATA_ALU_A_SEL_O = 4'h0;  // STACK_REG
      CV_DATA_ALU_B_SEL_O = 3'h7;  // ZERO
      CV_ADDR_ALU_REG_SEL_O = 4'h8;  // AR
      CV_DATA_ALU_OP_O = 3'h0;  // A_PLUS_B
      CV_DATA_WIDTH_SEL_O = 3'h2;  // W_STACK_REG
      CV_DATA_ALU_COND_SEL_O = 2'h0;  // ZERO_BIT
      CV_MICRO_SEQ_COND_SEL_O = 4'h3;  // STACK_NEXT
      CV_DMEM_OP_O = 2'h3;  // DMEM_OP_WR
      CV_STACK_OP_O = 2'h2;  // STACK_OP_PUSH
    end


    // 1610: 
    // 1611:   ; R1 is PC
    // 1612:   ; R2 is DMEM_RD
    // 1613: 
    // 1614:   SET_DATA_WIDTH  W_16
    // 1615: 
    // 1616:   ADDR_PASS       IDATA ; SWI vector
    // 1617:   DMEM_LOAD_W
    // 1618:   
    // 1619:   CCR_OP_W        OP_o1o1oooo ; Set I & F
    // 1620: 
    // 1621:   JUMP            JMP
    // 1622:   end_state
    9'h041: begin
      CV_MICRO_SEQ_OP_O = 3'h1;  // OP_JUMP
      CV_MICRO_SEQ_BRANCH_ADDR_O = 8'h30;  // JMP
      CV_ADDR_ALU_REG_SEL_O = 4'he;  // IDATA
      CV_DATA_WIDTH_SEL_O = 3'h3;  // W_16
      CV_CCR_OP_O = 4'h8;  // OP_O1O1OOOO
      CV_DMEM_OP_O = 2'h2;  // DMEM_OP_RD
    end


    // 1623: 
    // 1624: 
    // 1625: 
    // 1626: ; ////////////////////////////////////////////////////////////////////////////
    // 1627: 
    // 1628: 
    // 1629:   ORG  $FF
    // 1630: 
    // 1631: TRAP:
    // 1632: 
    // 1633:   JUMP            TRAP
    // 1634:   end_state
    9'h0ff: begin
      CV_MICRO_SEQ_OP_O = 3'h1;  // OP_JUMP
      CV_MICRO_SEQ_BRANCH_ADDR_O = 8'hff;  // TRAP
    end


    // 1635: 
    default: begin
      //
      // Control Logic Defaults
      CV_MICRO_SEQ_OP_O = 3'h0;  // OP_CONTINUE
      CV_MICRO_SEQ_BRANCH_ADDR_O = 8'h0;  // RESET
      CV_DATA_ALU_A_SEL_O = 4'hf;  // ZERO
      CV_DATA_ALU_B_SEL_O = 3'h7;  // ZERO
      CV_DATA_ALU_WR_SEL_O = 4'hf;  // ZERO
      CV_ADDR_ALU_REG_SEL_O = 4'hf;  // ZERO
      CV_DATA_ALU_OP_O = 3'h0;  // A_PLUS_B
      CV_DATA_WIDTH_SEL_O = 3'h0;  // W_R1
      CV_DATA_ALU_SAU_EN_O = 1'h0;  // FALSE
      CV_CCR_OP_O = 4'h0;  // OP_OOOOOOOO
      CV_DATA_ALU_COND_SEL_O = 2'h0;  // ZERO_BIT
      CV_MICRO_SEQ_COND_SEL_O = 4'h1;  // TRUE
      CV_DMEM_OP_O = 2'h0;  // DMEM_OP_IDLE
      CV_STACK_OP_O = 2'h0;  // STACK_OP_IDLE
    end
  endcase
end

/////////////////////////////////////////////////////////////////////////////

endmodule

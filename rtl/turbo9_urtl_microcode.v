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
  output reg [1:0] CV_DATA_WIDTH_SEL_O,
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
  CV_DATA_WIDTH_SEL_O = 2'h0;  // W_R1
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
    // 0035: ; Engineer:
    // 0036: ; Description:
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
      CV_MICRO_SEQ_BRANCH_ADDR_O = 8'h2d;  // JMP
      CV_ADDR_ALU_REG_SEL_O = 4'hf;  // ZERO
      CV_DATA_WIDTH_SEL_O = 2'h3;  // W_16
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
      CV_DATA_WIDTH_SEL_O = 2'h0;  // W_R1
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
      CV_DATA_WIDTH_SEL_O = 2'h1;  // W_R1_OR_IND
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
      CV_DATA_WIDTH_SEL_O = 2'h0;  // W_R1
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
      CV_DATA_WIDTH_SEL_O = 2'h1;  // W_R1_OR_IND
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
      CV_MICRO_SEQ_BRANCH_ADDR_O = 8'h2c;  // GO_NEW_PC
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
      CV_DATA_WIDTH_SEL_O = 2'h0;  // W_R1
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
      CV_MICRO_SEQ_COND_SEL_O = 4'h4;  // SAU_NOT_DONE
    end


    // 0416: 
    // 0417: SAU16_DONE:
    // 0418: 
    // 0419:   DATA_SAU_DONE
    // 0420:   DATA_WRITE      R2
    // 0421: 
    // 0422:   JUMP            SAU8_DONE
    // 0423:   end_state
    9'h00e: begin
      CV_MICRO_SEQ_OP_O = 3'h1;  // OP_JUMP
      CV_MICRO_SEQ_BRANCH_ADDR_O = 8'h10;  // SAU8_DONE
      CV_DATA_ALU_WR_SEL_O = 4'h4;  // R2
      CV_DATA_ALU_OP_O = 3'h7;  // SAU
    end


    // 0424: 
    // 0425: ; //////////////////////////////////////////// DAA MUL
    // 0426: ; //
    // 0427: SAU8:
    // 0428:   decode pg1_JTA SAU8 $19 ; DAA (inh)
    // 0429:   decode pg1_R1  D    $19 ; DAA (inh)
    // 0430: 
    // 0431:   decode pg1_JTA SAU8 $3D ; MUL (inh)
    // 0432:   decode pg1_R1  D    $3D ; MUL (inh)
    // 0433: 
    // 0434:   DATA_SAU_EN
    // 0435: 
    // 0436:   IF              SAU_NOT_DONE
    // 0437:   JUMP            SAU8
    // 0438:   end_state
    9'h00f: begin
      CV_MICRO_SEQ_OP_O = 3'h1;  // OP_JUMP
      CV_MICRO_SEQ_BRANCH_ADDR_O = 8'hf;  // SAU8
      CV_DATA_ALU_SAU_EN_O = 1'h1;  // TRUE
      CV_MICRO_SEQ_COND_SEL_O = 4'h4;  // SAU_NOT_DONE
    end


    // 0439: 
    // 0440: SAU8_DONE:
    // 0441: 
    // 0442:   DATA_SAU_DONE
    // 0443:   DATA_WRITE      R1
    // 0444: 
    // 0445:   CCR_OP_W        OP_ooooXXXX ; SAU masks correct bits
    // 0446: 
    // 0447:   JUMP_TABLE_A_NEXT_PC
    // 0448:   end_state
    9'h010: begin
      CV_MICRO_SEQ_OP_O = 3'h5;  // OP_JUMP_TABLE_A_NEXT_PC
      CV_DATA_ALU_WR_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_OP_O = 3'h7;  // SAU
      CV_CCR_OP_O = 4'h2;  // OP_OOOOXXXX
    end


    // 0449: 
    // 0450: ; //////////////////////////////////////////// SEX (in 1 micro-cycle!)
    // 0451: ; //
    // 0452: SEX:
    // 0453:   decode pg1_JTA SEX  $1D ; SEX(inh)
    // 0454:   decode pg1_R1  D    $1D ; SEX(inh)
    // 0455:   decode pg1_R2  SEXB $1D ; SEX(inh)
    // 0456: 
    // 0457:   DATA_PASS_B     R2
    // 0458:   DATA_WRITE      R1
    // 0459:   
    // 0460:   SET_DATA_WIDTH  W_R1
    // 0461: 
    // 0462:   CCR_OP_W        OP_ooooXXXo ; INFO Prog Man says V unaffected, datasheet says v=0
    // 0463: 
    // 0464:   JUMP_TABLE_A_NEXT_PC
    // 0465:   end_state
    9'h011: begin
      CV_MICRO_SEQ_OP_O = 3'h5;  // OP_JUMP_TABLE_A_NEXT_PC
      CV_DATA_ALU_A_SEL_O = 4'hf;  // ZERO
      CV_DATA_ALU_B_SEL_O = 3'h0;  // R2
      CV_DATA_ALU_WR_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_OP_O = 3'h0;  // A_PLUS_B
      CV_DATA_WIDTH_SEL_O = 2'h0;  // W_R1
      CV_CCR_OP_O = 4'h4;  // OP_OOOOXXXO
      CV_DATA_ALU_COND_SEL_O = 2'h0;  // ZERO_BIT
    end


    // 0466: 
    // 0467: ; //////////////////////////////////////////// TFR
    // 0468: ; //
    // 0469: TFR:
    // 0470:   decode pg1_JTA TFR $1F ; TFR(inh)
    // 0471: ; R1 = postbyte[7:0] $1F ; TFR(inh)
    // 0472: ; R2 = postbyte[3:0] $1F ; TFR(inh)
    // 0473: 
    // 0474:   DATA_PASS_A     R1
    // 0475:   DATA_WRITE      R2
    // 0476: 
    // 0477:   CCR_OP_W        OP_XXXXXXXX ; Just in case CCR is destination
    // 0478: 
    // 0479:   JUMP            GO_NEW_PC ; Just in case PC is destination
    // 0480:   end_state
    9'h012: begin
      CV_MICRO_SEQ_OP_O = 3'h1;  // OP_JUMP
      CV_MICRO_SEQ_BRANCH_ADDR_O = 8'h2c;  // GO_NEW_PC
      CV_DATA_ALU_A_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_B_SEL_O = 3'h7;  // ZERO
      CV_DATA_ALU_WR_SEL_O = 4'h4;  // R2
      CV_DATA_ALU_OP_O = 3'h0;  // A_PLUS_B
      CV_CCR_OP_O = 4'h9;  // OP_XXXXXXXX
      CV_DATA_ALU_COND_SEL_O = 2'h0;  // ZERO_BIT
    end


    // 0481: 
    // 0482: ; //
    // 0483: ; ////////////////////////////////////////////////////////////////////////////
    // 0484: 
    // 0485: 
    // 0486: ; ////////////////////////////////////////////////////////////////////////////
    // 0487: ;                        LOAD TYPE INSTRUCTIONS
    // 0488: ; ////////////////////////////////////////////////////////////////////////////
    // 0489: 
    // 0490: ; //////////////////////////////////////////// ADC
    // 0491: ; //
    // 0492: ADC:
    // 0493:   decode pg1_JTA ADC     $89         ; ADCA (imm)
    // 0494:   decode pg1_R1  A       $89         ; ADCA (imm)
    // 0495:   decode pg1_R2  IDATA   $89         ; ADCA (imm)
    // 0496:                                                    
    // 0497:   decode pg1_JTA ADC     $C9         ; ADCB (imm)
    // 0498:   decode pg1_R1  B       $C9         ; ADCB (imm)
    // 0499:   decode pg1_R2  IDATA   $C9         ; ADCB (imm)
    // 0500:                                          
    // 0501:   decode pg1_JTB ADC     $99 $A9 $B9 ; ADCA (dir idx ext)
    // 0502:   decode pg1_R1  A       $99 $A9 $B9 ; ADCA (dir idx ext)
    // 0503:   decode pg1_R2  DMEM_RD $99 $A9 $B9 ; ADCA (dir idx ext)
    // 0504:                                          
    // 0505:   decode pg1_JTB ADC     $D9 $E9 $F9 ; ADCB (dir idx ext)
    // 0506:   decode pg1_R1  B       $D9 $E9 $F9 ; ADCB (dir idx ext)
    // 0507:   decode pg1_R2  DMEM_RD $D9 $E9 $F9 ; ADCB (dir idx ext)
    // 0508: 
    // 0509:   DATA_ADDC       R1, R2
    // 0510:   DATA_WRITE      R1
    // 0511: 
    // 0512:   SET_DATA_WIDTH  W_R1
    // 0513: 
    // 0514:   CCR_OP_W        OP_ooXoXXXX ; H is masked for 16bit
    // 0515: 
    // 0516:   JUMP_TABLE_A_NEXT_PC
    // 0517:   end_state
    9'h013: begin
      CV_MICRO_SEQ_OP_O = 3'h5;  // OP_JUMP_TABLE_A_NEXT_PC
      CV_DATA_ALU_A_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_B_SEL_O = 3'h0;  // R2
      CV_DATA_ALU_WR_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_OP_O = 3'h0;  // A_PLUS_B
      CV_DATA_WIDTH_SEL_O = 2'h0;  // W_R1
      CV_CCR_OP_O = 4'h5;  // OP_OOXOXXXX
      CV_DATA_ALU_COND_SEL_O = 2'h2;  // CARRY_BIT
    end


    // 0518: 
    // 0519: ; //////////////////////////////////////////// ADD
    // 0520: ; //
    // 0521: ADD:
    // 0522:   decode pg1_JTA ADD     $8B         ; ADDA (imm)
    // 0523:   decode pg1_R1  A       $8B         ; ADDA (imm)
    // 0524:   decode pg1_R2  IDATA   $8B         ; ADDA (imm)
    // 0525:                                                    
    // 0526:   decode pg1_JTA ADD     $CB         ; ADDB (imm)
    // 0527:   decode pg1_R1  B       $CB         ; ADDB (imm)
    // 0528:   decode pg1_R2  IDATA   $CB         ; ADDB (imm)
    // 0529:                                                    
    // 0530:   decode pg1_JTA ADD     $C3         ; ADDD (imm)
    // 0531:   decode pg1_R1  D       $C3         ; ADDD (imm)
    // 0532:   decode pg1_R2  IDATA   $C3         ; ADDD (imm)
    // 0533:                              
    // 0534:   decode pg1_JTB ADD     $9B $AB $BB ; ADDA (dir idx ext)
    // 0535:   decode pg1_R1  A       $9B $AB $BB ; ADDA (dir idx ext)
    // 0536:   decode pg1_R2  DMEM_RD $9B $AB $BB ; ADDA (dir idx ext)
    // 0537:                              
    // 0538:   decode pg1_JTB ADD     $DB $EB $FB ; ADDB (dir idx ext)
    // 0539:   decode pg1_R1  B       $DB $EB $FB ; ADDB (dir idx ext)
    // 0540:   decode pg1_R2  DMEM_RD $DB $EB $FB ; ADDB (dir idx ext)
    // 0541:                              
    // 0542:   decode pg1_JTB ADD     $D3 $E3 $F3 ; ADDD (dir idx ext)
    // 0543:   decode pg1_R1  D       $D3 $E3 $F3 ; ADDD (dir idx ext)
    // 0544:   decode pg1_R2  DMEM_RD $D3 $E3 $F3 ; ADDD (dir idx ext)
    // 0545: 
    // 0546:   DATA_ADD        R1, R2
    // 0547:   DATA_WRITE      R1
    // 0548: 
    // 0549:   SET_DATA_WIDTH  W_R1
    // 0550: 
    // 0551:   CCR_OP_W        OP_ooXoXXXX ; H is masked for 16bit
    // 0552: 
    // 0553:   JUMP_TABLE_A_NEXT_PC
    // 0554:   end_state
    9'h014: begin
      CV_MICRO_SEQ_OP_O = 3'h5;  // OP_JUMP_TABLE_A_NEXT_PC
      CV_DATA_ALU_A_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_B_SEL_O = 3'h0;  // R2
      CV_DATA_ALU_WR_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_OP_O = 3'h0;  // A_PLUS_B
      CV_DATA_WIDTH_SEL_O = 2'h0;  // W_R1
      CV_CCR_OP_O = 4'h5;  // OP_OOXOXXXX
      CV_DATA_ALU_COND_SEL_O = 2'h0;  // ZERO_BIT
    end


    // 0555: 
    // 0556: 
    // 0557: ; //////////////////////////////////////////// AND
    // 0558: ; //
    // 0559: AND:
    // 0560:   decode pg1_JTA AND     $84         ; ANDA (imm)
    // 0561:   decode pg1_R1  A       $84         ; ANDA (imm)
    // 0562:   decode pg1_R2  IDATA   $84         ; ANDA (imm)
    // 0563:                                                    
    // 0564:   decode pg1_JTA AND     $C4         ; ANDB (imm)
    // 0565:   decode pg1_R1  B       $C4         ; ANDB (imm)
    // 0566:   decode pg1_R2  IDATA   $C4         ; ANDB (imm)
    // 0567:                                      
    // 0568:   decode pg1_JTB AND     $94 $A4 $B4 ; ANDA (dir idx ext)
    // 0569:   decode pg1_R1  A       $94 $A4 $B4 ; ANDA (dir idx ext)
    // 0570:   decode pg1_R2  DMEM_RD $94 $A4 $B4 ; ANDA (dir idx ext)
    // 0571:                                      
    // 0572:   decode pg1_JTB AND     $D4 $E4 $F4 ; ANDB (dir idx ext)
    // 0573:   decode pg1_R1  B       $D4 $E4 $F4 ; ANDB (dir idx ext)
    // 0574:   decode pg1_R2  DMEM_RD $D4 $E4 $F4 ; ANDB (dir idx ext)
    // 0575: 
    // 0576:   DATA_AND        R1, R2
    // 0577:   DATA_WRITE      R1
    // 0578: 
    // 0579:   SET_DATA_WIDTH  W_R1
    // 0580: 
    // 0581:   CCR_OP_W        OP_ooooXXXo 
    // 0582: 
    // 0583:   JUMP_TABLE_A_NEXT_PC
    // 0584:   end_state
    9'h015: begin
      CV_MICRO_SEQ_OP_O = 3'h5;  // OP_JUMP_TABLE_A_NEXT_PC
      CV_DATA_ALU_A_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_B_SEL_O = 3'h0;  // R2
      CV_DATA_ALU_WR_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_OP_O = 3'h4;  // A_AND_B
      CV_DATA_WIDTH_SEL_O = 2'h0;  // W_R1
      CV_CCR_OP_O = 4'h4;  // OP_OOOOXXXO
      CV_DATA_ALU_COND_SEL_O = 2'h0;  // ZERO_BIT
    end


    // 0585: 
    // 0586: ANDCC:
    // 0587:   decode pg1_JTA ANDCC $1C ; ANDCC (imm)
    // 0588:   decode pg1_R1  CCR   $1C ; ANDCC (imm)
    // 0589:   decode pg1_R2  IDATA $1C ; ANDCC (imm)
    // 0590: 
    // 0591:   DATA_AND        R1, R2
    // 0592:   DATA_WRITE      R1
    // 0593: 
    // 0594:   SET_DATA_WIDTH  W_R1
    // 0595: 
    // 0596:   CCR_OP_W        OP_XXXXXXXX 
    // 0597: 
    // 0598:   JUMP_TABLE_A_NEXT_PC
    // 0599:   end_state
    9'h016: begin
      CV_MICRO_SEQ_OP_O = 3'h5;  // OP_JUMP_TABLE_A_NEXT_PC
      CV_DATA_ALU_A_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_B_SEL_O = 3'h0;  // R2
      CV_DATA_ALU_WR_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_OP_O = 3'h4;  // A_AND_B
      CV_DATA_WIDTH_SEL_O = 2'h0;  // W_R1
      CV_CCR_OP_O = 4'h9;  // OP_XXXXXXXX
      CV_DATA_ALU_COND_SEL_O = 2'h0;  // ZERO_BIT
    end


    // 0600: 
    // 0601: ; //////////////////////////////////////////// BIT
    // 0602: ; //
    // 0603: BIT:
    // 0604:   decode pg1_JTA BIT     $85         ; BITA (imm)
    // 0605:   decode pg1_R1  A       $85         ; BITA (imm)
    // 0606:   decode pg1_R2  IDATA   $85         ; BITA (imm)
    // 0607:                                                 
    // 0608:   decode pg1_JTA BIT     $C5         ; BITB (imm)
    // 0609:   decode pg1_R1  B       $C5         ; BITB (imm)
    // 0610:   decode pg1_R2  IDATA   $C5         ; BITB (imm)
    // 0611:                              
    // 0612:   decode pg1_JTB BIT     $95 $A5 $B5 ; BITA (dir idx ext)
    // 0613:   decode pg1_R1  A       $95 $A5 $B5 ; BITA (dir idx ext)
    // 0614:   decode pg1_R2  DMEM_RD $95 $A5 $B5 ; BITA (dir idx ext)
    // 0615:                              
    // 0616:   decode pg1_JTB BIT     $D5 $E5 $F5 ; BITB (dir idx ext)
    // 0617:   decode pg1_R1  B       $D5 $E5 $F5 ; BITB (dir idx ext)
    // 0618:   decode pg1_R2  DMEM_RD $D5 $E5 $F5 ; BITB (dir idx ext)
    // 0619: 
    // 0620:   DATA_AND        R1, R2
    // 0621: 
    // 0622:   SET_DATA_WIDTH  W_R1
    // 0623: 
    // 0624:   CCR_OP_W        OP_ooooXXXo 
    // 0625: 
    // 0626:   JUMP_TABLE_A_NEXT_PC
    // 0627:   end_state
    9'h017: begin
      CV_MICRO_SEQ_OP_O = 3'h5;  // OP_JUMP_TABLE_A_NEXT_PC
      CV_DATA_ALU_A_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_B_SEL_O = 3'h0;  // R2
      CV_DATA_ALU_OP_O = 3'h4;  // A_AND_B
      CV_DATA_WIDTH_SEL_O = 2'h0;  // W_R1
      CV_CCR_OP_O = 4'h4;  // OP_OOOOXXXO
      CV_DATA_ALU_COND_SEL_O = 2'h0;  // ZERO_BIT
    end


    // 0628: 
    // 0629: ; //////////////////////////////////////////// CMP
    // 0630: ; //
    // 0631: CMP:
    // 0632:   decode pg1_JTA CMP     $81         ; CMPA (imm)
    // 0633:   decode pg1_R1  A       $81         ; CMPA (imm)
    // 0634:   decode pg1_R2  IDATA   $81         ; CMPA (imm)
    // 0635:                                                
    // 0636:   decode pg1_JTA CMP     $C1         ; CMPB (imm)
    // 0637:   decode pg1_R1  B       $C1         ; CMPB (imm)
    // 0638:   decode pg1_R2  IDATA   $C1         ; CMPB (imm)
    // 0639:                                                
    // 0640:   decode pg2_JTA CMP     $83         ; CMPD (imm)
    // 0641:   decode pg2_R1  D       $83         ; CMPD (imm)
    // 0642:   decode pg2_R2  IDATA   $83         ; CMPD (imm)
    // 0643:                                                
    // 0644:   decode pg3_JTA CMP     $8C         ; CMPS (imm)
    // 0645:   decode pg3_R1  S       $8C         ; CMPS (imm)
    // 0646:   decode pg3_R2  IDATA   $8C         ; CMPS (imm)
    // 0647:                                                
    // 0648:   decode pg3_JTA CMP     $83         ; CMPU (imm)
    // 0649:   decode pg3_R1  U       $83         ; CMPU (imm)
    // 0650:   decode pg3_R2  IDATA   $83         ; CMPU (imm)
    // 0651:                                                
    // 0652:   decode pg1_JTA CMP     $8C         ; CMPX (imm)
    // 0653:   decode pg1_R1  X       $8C         ; CMPX (imm)
    // 0654:   decode pg1_R2  IDATA   $8C         ; CMPX (imm)
    // 0655:                                                
    // 0656:   decode pg2_JTA CMP     $8C         ; CMPY (imm)
    // 0657:   decode pg2_R1  Y       $8C         ; CMPY (imm)
    // 0658:   decode pg2_R2  IDATA   $8C         ; CMPY (imm)
    // 0659:                              
    // 0660:   decode pg1_JTB CMP     $91 $A1 $B1 ; CMPA (dir idx ext)
    // 0661:   decode pg1_R1  A       $91 $A1 $B1 ; CMPA (dir idx ext)
    // 0662:   decode pg1_R2  DMEM_RD $91 $A1 $B1 ; CMPA (dir idx ext)
    // 0663:                              
    // 0664:   decode pg1_JTB CMP     $D1 $E1 $F1 ; CMPB (dir idx ext)
    // 0665:   decode pg1_R1  B       $D1 $E1 $F1 ; CMPB (dir idx ext)
    // 0666:   decode pg1_R2  DMEM_RD $D1 $E1 $F1 ; CMPB (dir idx ext)
    // 0667:                              
    // 0668:   decode pg2_JTB CMP     $93 $A3 $B3 ; CMPD (dir idx ext)
    // 0669:   decode pg2_R1  D       $93 $A3 $B3 ; CMPD (dir idx ext)
    // 0670:   decode pg2_R2  DMEM_RD $93 $A3 $B3 ; CMPD (dir idx ext)
    // 0671:                              
    // 0672:   decode pg3_JTB CMP     $9C $AC $BC ; CMPS (dir idx ext)
    // 0673:   decode pg3_R1  S       $9C $AC $BC ; CMPS (dir idx ext)
    // 0674:   decode pg3_R2  DMEM_RD $9C $AC $BC ; CMPS (dir idx ext)
    // 0675:                              
    // 0676:   decode pg3_JTB CMP     $93 $A3 $B3 ; CMPU (dir idx ext)
    // 0677:   decode pg3_R1  U       $93 $A3 $B3 ; CMPU (dir idx ext)
    // 0678:   decode pg3_R2  DMEM_RD $93 $A3 $B3 ; CMPU (dir idx ext)
    // 0679:                              
    // 0680:   decode pg1_JTB CMP     $9C $AC $BC ; CMPX (dir idx ext)
    // 0681:   decode pg1_R1  X       $9C $AC $BC ; CMPX (dir idx ext)
    // 0682:   decode pg1_R2  DMEM_RD $9C $AC $BC ; CMPX (dir idx ext)
    // 0683:                              
    // 0684:   decode pg2_JTB CMP     $9C $AC $BC ; CMPY (dir idx ext)
    // 0685:   decode pg2_R1  Y       $9C $AC $BC ; CMPY (dir idx ext)
    // 0686:   decode pg2_R2  DMEM_RD $9C $AC $BC ; CMPY (dir idx ext)
    // 0687: 
    // 0688:   DATA_SUB        R1, R2
    // 0689: 
    // 0690:   SET_DATA_WIDTH  W_R1
    // 0691: 
    // 0692:   CCR_OP_W        OP_ooooXXXX ; INFO: Spec H Undefined, Turbo9 H not affected
    // 0693: 
    // 0694:   JUMP_TABLE_A_NEXT_PC
    // 0695:   end_state
    9'h018: begin
      CV_MICRO_SEQ_OP_O = 3'h5;  // OP_JUMP_TABLE_A_NEXT_PC
      CV_DATA_ALU_A_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_B_SEL_O = 3'h0;  // R2
      CV_DATA_ALU_OP_O = 3'h1;  // A_PLUS_NOT_B
      CV_DATA_WIDTH_SEL_O = 2'h0;  // W_R1
      CV_CCR_OP_O = 4'h2;  // OP_OOOOXXXX
      CV_DATA_ALU_COND_SEL_O = 2'h0;  // ZERO_BIT
    end


    // 0696: 
    // 0697: ; //////////////////////////////////////////// EOR
    // 0698: ; //
    // 0699: EOR:
    // 0700:   decode pg1_JTA EOR     $88         ; EORA (imm)
    // 0701:   decode pg1_R1  A       $88         ; EORA (imm)
    // 0702:   decode pg1_R2  IDATA   $88         ; EORA (imm)
    // 0703:                                                 
    // 0704:   decode pg1_JTA EOR     $C8         ; EORB (imm)
    // 0705:   decode pg1_R1  B       $C8         ; EORB (imm)
    // 0706:   decode pg1_R2  IDATA   $C8         ; EORB (imm)
    // 0707:                              
    // 0708:   decode pg1_JTB EOR     $98 $A8 $B8 ; EORA (dir idx ext)
    // 0709:   decode pg1_R1  A       $98 $A8 $B8 ; EORA (dir idx ext)
    // 0710:   decode pg1_R2  DMEM_RD $98 $A8 $B8 ; EORA (dir idx ext)
    // 0711:                              
    // 0712:   decode pg1_JTB EOR     $D8 $E8 $F8 ; EORB (dir idx ext)
    // 0713:   decode pg1_R1  B       $D8 $E8 $F8 ; EORB (dir idx ext)
    // 0714:   decode pg1_R2  DMEM_RD $D8 $E8 $F8 ; EORB (dir idx ext)
    // 0715: 
    // 0716:   DATA_XOR        R1, R2
    // 0717:   DATA_WRITE      R1
    // 0718: 
    // 0719:   SET_DATA_WIDTH  W_R1
    // 0720: 
    // 0721:   CCR_OP_W        OP_ooooXXXo 
    // 0722: 
    // 0723:   JUMP_TABLE_A_NEXT_PC
    // 0724:   end_state
    9'h019: begin
      CV_MICRO_SEQ_OP_O = 3'h5;  // OP_JUMP_TABLE_A_NEXT_PC
      CV_DATA_ALU_A_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_B_SEL_O = 3'h0;  // R2
      CV_DATA_ALU_WR_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_OP_O = 3'h6;  // A_XOR_B
      CV_DATA_WIDTH_SEL_O = 2'h0;  // W_R1
      CV_CCR_OP_O = 4'h4;  // OP_OOOOXXXO
      CV_DATA_ALU_COND_SEL_O = 2'h0;  // ZERO_BIT
    end


    // 0725: 
    // 0726: ; //////////////////////////////////////////// LD
    // 0727: ; //
    // 0728: LD:
    // 0729:   decode pg1_JTA LD      $86         ; LDA (imm)
    // 0730:   decode pg1_R1  A       $86         ; LDA (imm)
    // 0731:   decode pg1_R2  IDATA   $86         ; LDA (imm)
    // 0732:                                                 
    // 0733:   decode pg1_JTA LD      $C6         ; LDB (imm)
    // 0734:   decode pg1_R1  B       $C6         ; LDB (imm)
    // 0735:   decode pg1_R2  IDATA   $C6         ; LDB (imm)
    // 0736:                                                 
    // 0737:   decode pg1_JTA LD      $CC         ; LDD (imm)
    // 0738:   decode pg1_R1  D       $CC         ; LDD (imm)
    // 0739:   decode pg1_R2  IDATA   $CC         ; LDD (imm)
    // 0740:                                                 
    // 0741:   decode pg2_JTA LD      $CE         ; LDS (imm)
    // 0742:   decode pg2_R1  S       $CE         ; LDS (imm)
    // 0743:   decode pg2_R2  IDATA   $CE         ; LDS (imm)
    // 0744:                                                 
    // 0745:   decode pg1_JTA LD      $CE         ; LDU (imm)
    // 0746:   decode pg1_R1  U       $CE         ; LDU (imm)
    // 0747:   decode pg1_R2  IDATA   $CE         ; LDU (imm)
    // 0748:                                                 
    // 0749:   decode pg1_JTA LD      $8E         ; LDX (imm)
    // 0750:   decode pg1_R1  X       $8E         ; LDX (imm)
    // 0751:   decode pg1_R2  IDATA   $8E         ; LDX (imm)
    // 0752:                                                 
    // 0753:   decode pg2_JTA LD      $8E         ; LDY (imm)
    // 0754:   decode pg2_R1  Y       $8E         ; LDY (imm)
    // 0755:   decode pg2_R2  IDATA   $8E         ; LDY (imm)
    // 0756:                              
    // 0757:   decode pg1_JTB LD      $96 $A6 $B6 ; LDA (dir idx ext)
    // 0758:   decode pg1_R1  A       $96 $A6 $B6 ; LDA (dir idx ext)
    // 0759:   decode pg1_R2  DMEM_RD $96 $A6 $B6 ; LDA (dir idx ext)
    // 0760:                              
    // 0761:   decode pg1_JTB LD      $D6 $E6 $F6 ; LDB (dir idx ext)
    // 0762:   decode pg1_R1  B       $D6 $E6 $F6 ; LDB (dir idx ext)
    // 0763:   decode pg1_R2  DMEM_RD $D6 $E6 $F6 ; LDB (dir idx ext)
    // 0764:                              
    // 0765:   decode pg1_JTB LD      $DC $EC $FC ; LDD (dir idx ext)
    // 0766:   decode pg1_R1  D       $DC $EC $FC ; LDD (dir idx ext)
    // 0767:   decode pg1_R2  DMEM_RD $DC $EC $FC ; LDD (dir idx ext)
    // 0768:                              
    // 0769:   decode pg2_JTB LD      $DE $EE $FE ; LDS (dir idx ext)
    // 0770:   decode pg2_R1  S       $DE $EE $FE ; LDS (dir idx ext)
    // 0771:   decode pg2_R2  DMEM_RD $DE $EE $FE ; LDS (dir idx ext)
    // 0772:                              
    // 0773:   decode pg1_JTB LD      $DE $EE $FE ; LDU (dir idx ext)
    // 0774:   decode pg1_R1  U       $DE $EE $FE ; LDU (dir idx ext)
    // 0775:   decode pg1_R2  DMEM_RD $DE $EE $FE ; LDU (dir idx ext)
    // 0776:                              
    // 0777:   decode pg1_JTB LD      $9E $AE $BE ; LDX (dir idx ext)
    // 0778:   decode pg1_R1  X       $9E $AE $BE ; LDX (dir idx ext)
    // 0779:   decode pg1_R2  DMEM_RD $9E $AE $BE ; LDX (dir idx ext)
    // 0780:                              
    // 0781:   decode pg2_JTB LD      $9E $AE $BE ; LDY (dir idx ext)
    // 0782:   decode pg2_R1  Y       $9E $AE $BE ; LDY (dir idx ext)
    // 0783:   decode pg2_R2  DMEM_RD $9E $AE $BE ; LDY (dir idx ext)
    // 0784: 
    // 0785:   DATA_PASS_B     R2
    // 0786:   DATA_WRITE      R1
    // 0787: 
    // 0788:   SET_DATA_WIDTH  W_R1
    // 0789: 
    // 0790:   CCR_OP_W        OP_ooooXXXo
    // 0791: 
    // 0792:   JUMP_TABLE_A_NEXT_PC
    // 0793:   end_state
    9'h01a: begin
      CV_MICRO_SEQ_OP_O = 3'h5;  // OP_JUMP_TABLE_A_NEXT_PC
      CV_DATA_ALU_A_SEL_O = 4'hf;  // ZERO
      CV_DATA_ALU_B_SEL_O = 3'h0;  // R2
      CV_DATA_ALU_WR_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_OP_O = 3'h0;  // A_PLUS_B
      CV_DATA_WIDTH_SEL_O = 2'h0;  // W_R1
      CV_CCR_OP_O = 4'h4;  // OP_OOOOXXXO
      CV_DATA_ALU_COND_SEL_O = 2'h0;  // ZERO_BIT
    end


    // 0794: 
    // 0795: ; //////////////////////////////////////////// OR
    // 0796: ; //
    // 0797: OR:
    // 0798:   decode pg1_JTA OR      $8A         ; ORA (imm)
    // 0799:   decode pg1_R1  A       $8A         ; ORA (imm)
    // 0800:   decode pg1_R2  IDATA   $8A         ; ORA (imm)
    // 0801:                                                 
    // 0802:   decode pg1_JTA OR      $CA         ; ORB (imm)
    // 0803:   decode pg1_R1  B       $CA         ; ORB (imm)
    // 0804:   decode pg1_R2  IDATA   $CA         ; ORB (imm)
    // 0805:                              
    // 0806:   decode pg1_JTB OR      $9A $AA $BA ; ORA (dir idx ext)
    // 0807:   decode pg1_R1  A       $9A $AA $BA ; ORA (dir idx ext)
    // 0808:   decode pg1_R2  DMEM_RD $9A $AA $BA ; ORA (dir idx ext)
    // 0809:                              
    // 0810:   decode pg1_JTB OR      $DA $EA $FA ; ORB (dir idx ext)
    // 0811:   decode pg1_R1  B       $DA $EA $FA ; ORB (dir idx ext)
    // 0812:   decode pg1_R2  DMEM_RD $DA $EA $FA ; ORB (dir idx ext)
    // 0813: 
    // 0814:   DATA_OR         R1, R2
    // 0815:   DATA_WRITE      R1
    // 0816: 
    // 0817:   SET_DATA_WIDTH  W_R1
    // 0818: 
    // 0819:   CCR_OP_W        OP_ooooXXXo 
    // 0820: 
    // 0821:   JUMP_TABLE_A_NEXT_PC
    // 0822:   end_state
    9'h01b: begin
      CV_MICRO_SEQ_OP_O = 3'h5;  // OP_JUMP_TABLE_A_NEXT_PC
      CV_DATA_ALU_A_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_B_SEL_O = 3'h0;  // R2
      CV_DATA_ALU_WR_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_OP_O = 3'h5;  // A_OR_B
      CV_DATA_WIDTH_SEL_O = 2'h0;  // W_R1
      CV_CCR_OP_O = 4'h4;  // OP_OOOOXXXO
      CV_DATA_ALU_COND_SEL_O = 2'h0;  // ZERO_BIT
    end


    // 0823: 
    // 0824: ORCC:
    // 0825:   decode pg1_JTA ORCC  $1A ; ORCC (imm)
    // 0826:   decode pg1_R1  CCR   $1A ; ORCC (imm)
    // 0827:   decode pg1_R2  IDATA $1A ; ORCC (imm)
    // 0828: 
    // 0829:   DATA_OR         R1, R2   
    // 0830:   DATA_WRITE      R1
    // 0831: 
    // 0832:   SET_DATA_WIDTH  W_R1
    // 0833: 
    // 0834:   CCR_OP_W        OP_XXXXXXXX 
    // 0835: 
    // 0836:   JUMP_TABLE_A_NEXT_PC
    // 0837:   end_state
    9'h01c: begin
      CV_MICRO_SEQ_OP_O = 3'h5;  // OP_JUMP_TABLE_A_NEXT_PC
      CV_DATA_ALU_A_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_B_SEL_O = 3'h0;  // R2
      CV_DATA_ALU_WR_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_OP_O = 3'h5;  // A_OR_B
      CV_DATA_WIDTH_SEL_O = 2'h0;  // W_R1
      CV_CCR_OP_O = 4'h9;  // OP_XXXXXXXX
      CV_DATA_ALU_COND_SEL_O = 2'h0;  // ZERO_BIT
    end


    // 0838: 
    // 0839: ; //////////////////////////////////////////// SBC
    // 0840: ; //
    // 0841: SBC:
    // 0842:   decode pg1_JTA SBC     $82         ; SBCA (imm)
    // 0843:   decode pg1_R1  A       $82         ; SBCA (imm)
    // 0844:   decode pg1_R2  IDATA   $82         ; SBCA (imm)
    // 0845:                                                 
    // 0846:   decode pg1_JTA SBC     $C2         ; SBCB (imm)
    // 0847:   decode pg1_R1  B       $C2         ; SBCB (imm)
    // 0848:   decode pg1_R2  IDATA   $C2         ; SBCB (imm)
    // 0849:                              
    // 0850:   decode pg1_JTB SBC     $92 $A2 $B2 ; SBCA (dir idx ext)
    // 0851:   decode pg1_R1  A       $92 $A2 $B2 ; SBCA (dir idx ext)
    // 0852:   decode pg1_R2  DMEM_RD $92 $A2 $B2 ; SBCA (dir idx ext)
    // 0853:                                                      
    // 0854:   decode pg1_JTB SBC     $D2 $E2 $F2 ; SBCB (dir idx ext)
    // 0855:   decode pg1_R1  B       $D2 $E2 $F2 ; SBCB (dir idx ext)
    // 0856:   decode pg1_R2  DMEM_RD $D2 $E2 $F2 ; SBCB (dir idx ext)
    // 0857: 
    // 0858:   DATA_SUBC       R1, R2
    // 0859:   DATA_WRITE      R1
    // 0860: 
    // 0861:   SET_DATA_WIDTH  W_R1
    // 0862: 
    // 0863:   CCR_OP_W        OP_ooooXXXX ; INFO: Spec H Undefined, Turbo9 H not affected
    // 0864: 
    // 0865:   JUMP_TABLE_A_NEXT_PC
    // 0866:   end_state
    9'h01d: begin
      CV_MICRO_SEQ_OP_O = 3'h5;  // OP_JUMP_TABLE_A_NEXT_PC
      CV_DATA_ALU_A_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_B_SEL_O = 3'h0;  // R2
      CV_DATA_ALU_WR_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_OP_O = 3'h1;  // A_PLUS_NOT_B
      CV_DATA_WIDTH_SEL_O = 2'h0;  // W_R1
      CV_CCR_OP_O = 4'h2;  // OP_OOOOXXXX
      CV_DATA_ALU_COND_SEL_O = 2'h2;  // CARRY_BIT
    end


    // 0867: 
    // 0868: ; //////////////////////////////////////////// SUB
    // 0869: ; //
    // 0870: SUB:
    // 0871:   decode pg1_JTA SUB     $80         ; SUBA (imm)
    // 0872:   decode pg1_R1  A       $80         ; SUBA (imm)
    // 0873:   decode pg1_R2  IDATA   $80         ; SUBA (imm)
    // 0874:                                                 
    // 0875:   decode pg1_JTA SUB     $C0         ; SUBB (imm)
    // 0876:   decode pg1_R1  B       $C0         ; SUBB (imm)
    // 0877:   decode pg1_R2  IDATA   $C0         ; SUBB (imm)
    // 0878:                                                 
    // 0879:   decode pg1_JTA SUB     $83         ; SUBD (imm)
    // 0880:   decode pg1_R1  D       $83         ; SUBD (imm)
    // 0881:   decode pg1_R2  IDATA   $83         ; SUBD (imm)
    // 0882:                              
    // 0883:   decode pg1_JTB SUB     $90 $A0 $B0 ; SUBA (dir idx ext)
    // 0884:   decode pg1_R1  A       $90 $A0 $B0 ; SUBA (dir idx ext)
    // 0885:   decode pg1_R2  DMEM_RD $90 $A0 $B0 ; SUBA (dir idx ext)
    // 0886:                                                       
    // 0887:   decode pg1_JTB SUB     $D0 $E0 $F0 ; SUBB (dir idx ext)
    // 0888:   decode pg1_R1  B       $D0 $E0 $F0 ; SUBB (dir idx ext)
    // 0889:   decode pg1_R2  DMEM_RD $D0 $E0 $F0 ; SUBB (dir idx ext)
    // 0890:                                                       
    // 0891:   decode pg1_JTB SUB     $93 $A3 $B3 ; SUBD (dir idx ext)
    // 0892:   decode pg1_R1  D       $93 $A3 $B3 ; SUBD (dir idx ext)
    // 0893:   decode pg1_R2  DMEM_RD $93 $A3 $B3 ; SUBD (dir idx ext)
    // 0894: 
    // 0895:   DATA_SUB        R1, R2
    // 0896:   DATA_WRITE      R1
    // 0897: 
    // 0898:   SET_DATA_WIDTH  W_R1
    // 0899: 
    // 0900:   CCR_OP_W        OP_ooooXXXX ; INFO: Spec H Undefined, Turbo9 H not affected (8-bit)
    // 0901: 
    // 0902:   JUMP_TABLE_A_NEXT_PC
    // 0903:   end_state
    9'h01e: begin
      CV_MICRO_SEQ_OP_O = 3'h5;  // OP_JUMP_TABLE_A_NEXT_PC
      CV_DATA_ALU_A_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_B_SEL_O = 3'h0;  // R2
      CV_DATA_ALU_WR_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_OP_O = 3'h1;  // A_PLUS_NOT_B
      CV_DATA_WIDTH_SEL_O = 2'h0;  // W_R1
      CV_CCR_OP_O = 4'h2;  // OP_OOOOXXXX
      CV_DATA_ALU_COND_SEL_O = 2'h0;  // ZERO_BIT
    end


    // 0904: 
    // 0905: 
    // 0906: ; //
    // 0907: ; ////////////////////////////////////////////////////////////////////////////
    // 0908: 
    // 0909: 
    // 0910: ; ////////////////////////////////////////////////////////////////////////////
    // 0911: ;                        STORE INSTRUCTIONS
    // 0912: ; ////////////////////////////////////////////////////////////////////////////
    // 0913: ; //
    // 0914: 
    // 0915: ; //////////////////////////////////////////// ST
    // 0916: ; //
    // 0917: ST:
    // 0918:   decode pg1_JTA ST    $97 $B7 ; STA (dir ext)
    // 0919:   decode pg1_R1  A     $97 $B7 ; STA (dir ext)
    // 0920:   decode pg1_AR  IDATA $97 $B7 ; STA (dir ext)
    // 0921:                            
    // 0922:   decode pg1_JTA ST    $D7 $F7 ; STB (dir ext)
    // 0923:   decode pg1_R1  B     $D7 $F7 ; STB (dir ext)
    // 0924:   decode pg1_AR  IDATA $D7 $F7 ; STB (dir ext)
    // 0925:                            
    // 0926:   decode pg1_JTA ST    $DD $FD ; STD (dir ext)
    // 0927:   decode pg1_R1  D     $DD $FD ; STD (dir ext)
    // 0928:   decode pg1_AR  IDATA $DD $FD ; STD (dir ext)
    // 0929:                            
    // 0930:   decode pg2_JTA ST    $DF $FF ; STS (dir ext)
    // 0931:   decode pg2_R1  S     $DF $FF ; STS (dir ext)
    // 0932:   decode pg2_AR  IDATA $DF $FF ; STS (dir ext)
    // 0933:                            
    // 0934:   decode pg1_JTA ST    $DF $FF ; STU (dir ext)
    // 0935:   decode pg1_R1  U     $DF $FF ; STU (dir ext)
    // 0936:   decode pg1_AR  IDATA $DF $FF ; STU (dir ext)
    // 0937:                            
    // 0938:   decode pg1_JTA ST    $9F $BF ; STX (dir ext)
    // 0939:   decode pg1_R1  X     $9F $BF ; STX (dir ext)
    // 0940:   decode pg1_AR  IDATA $9F $BF ; STX (dir ext)
    // 0941:                            
    // 0942:   decode pg2_JTA ST    $9F $BF ; STY (dir ext)
    // 0943:   decode pg2_R1  Y     $9F $BF ; STY (dir ext)
    // 0944:   decode pg2_AR  IDATA $9F $BF ; STY (dir ext)
    // 0945:                            
    // 0946:   decode pg1_JTB ST    $A7     ; STA (idx)
    // 0947:   decode pg1_R1  A     $A7     ; STA (idx)
    // 0948:   decode pg1_AR  EA    $A7     ; STA (idx)
    // 0949:                                    
    // 0950:   decode pg1_JTB ST    $E7     ; STB (idx)
    // 0951:   decode pg1_R1  B     $E7     ; STB (idx)
    // 0952:   decode pg1_AR  EA    $E7     ; STB (idx)
    // 0953:                                    
    // 0954:   decode pg1_JTB ST    $ED     ; STD (idx)
    // 0955:   decode pg1_R1  D     $ED     ; STD (idx)
    // 0956:   decode pg1_AR  EA    $ED     ; STD (idx)
    // 0957:                                    
    // 0958:   decode pg2_JTB ST    $EF     ; STS (idx)
    // 0959:   decode pg2_R1  S     $EF     ; STS (idx)
    // 0960:   decode pg2_AR  EA    $EF     ; STS (idx)
    // 0961:                                    
    // 0962:   decode pg1_JTB ST    $EF     ; STU (idx)
    // 0963:   decode pg1_R1  U     $EF     ; STU (idx)
    // 0964:   decode pg1_AR  EA    $EF     ; STU (idx)
    // 0965:                                    
    // 0966:   decode pg1_JTB ST    $AF     ; STX (idx)
    // 0967:   decode pg1_R1  X     $AF     ; STX (idx)
    // 0968:   decode pg1_AR  EA    $AF     ; STX (idx)
    // 0969:                                    
    // 0970:   decode pg2_JTB ST    $AF     ; STY (idx)
    // 0971:   decode pg2_R1  Y     $AF     ; STY (idx)
    // 0972:   decode pg2_AR  EA    $AF     ; STY (idx)
    // 0973: 
    // 0974:   DATA_PASS_A     R1
    // 0975: 
    // 0976:   SET_DATA_WIDTH  W_R1
    // 0977: 
    // 0978:   CCR_OP_W        OP_ooooXXXo
    // 0979: 
    // 0980:   ADDR_PASS       AR
    // 0981:   DMEM_STORE_W
    // 0982: 
    // 0983:   JUMP_TABLE_A_NEXT_PC
    // 0984:   end_state
    9'h01f: begin
      CV_MICRO_SEQ_OP_O = 3'h5;  // OP_JUMP_TABLE_A_NEXT_PC
      CV_DATA_ALU_A_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_B_SEL_O = 3'h7;  // ZERO
      CV_ADDR_ALU_REG_SEL_O = 4'h8;  // AR
      CV_DATA_ALU_OP_O = 3'h0;  // A_PLUS_B
      CV_DATA_WIDTH_SEL_O = 2'h0;  // W_R1
      CV_CCR_OP_O = 4'h4;  // OP_OOOOXXXO
      CV_DATA_ALU_COND_SEL_O = 2'h0;  // ZERO_BIT
      CV_DMEM_OP_O = 2'h3;  // DMEM_OP_WR
    end


    // 0985: 
    // 0986: ; //
    // 0987: ; ////////////////////////////////////////////////////////////////////////////
    // 0988: 
    // 0989: 
    // 0990: ; ////////////////////////////////////////////////////////////////////////////
    // 0991: ;                   MODIFY MEMORY OR ACCUMULATOR INSTRUCTIONS
    // 0992: ; ////////////////////////////////////////////////////////////////////////////
    // 0993: ; //
    // 0994: 
    // 0995: ; //////////////////////////////////////////// ASL LSL
    // 0996: ; //
    // 0997: ASL_LSL:
    // 0998:   decode pg1_JTA ASL_LSL $48         ; ASLA LSLA (inh)
    // 0999:   decode pg1_R1  A       $48         ; ASLA LSLA (inh)
    // 1000:                                         
    // 1001:   decode pg1_JTA ASL_LSL $58         ; ASLB LSLB (inh)
    // 1002:   decode pg1_R1  B       $58         ; ASLB LSLB (inh)
    // 1003:                              
    // 1004:   decode pg1_JTB ASL_LSL $08 $68 $78 ; ASL LSL (dir idx ext)
    // 1005:   decode pg1_R1  DMEM_RD $08 $68 $78 ; ASL LSL (dir idx ext)
    // 1006: 
    // 1007:   DATA_LSHIFT_W   R1, ZERO_BIT
    // 1008:   DATA_WRITE      R1
    // 1009: 
    // 1010:   SET_DATA_WIDTH  W_R1
    // 1011: 
    // 1012:   CCR_OP_W        OP_ooooXXXX ; INFO: Spec H Undefined, Turbo9 H not affected
    // 1013: 
    // 1014:   ADDR_PASS       EA
    // 1015:   DMEM_STORE_W ; Disabled for inherent addressing modes
    // 1016: 
    // 1017:   JUMP_TABLE_A_NEXT_PC
    // 1018:   end_state
    9'h020: begin
      CV_MICRO_SEQ_OP_O = 3'h5;  // OP_JUMP_TABLE_A_NEXT_PC
      CV_DATA_ALU_A_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_B_SEL_O = 3'h7;  // ZERO
      CV_DATA_ALU_WR_SEL_O = 4'h8;  // R1
      CV_ADDR_ALU_REG_SEL_O = 4'hc;  // EA
      CV_DATA_ALU_OP_O = 3'h2;  // LSHIFT_A
      CV_DATA_WIDTH_SEL_O = 2'h0;  // W_R1
      CV_CCR_OP_O = 4'h2;  // OP_OOOOXXXX
      CV_DATA_ALU_COND_SEL_O = 2'h0;  // ZERO_BIT
      CV_DMEM_OP_O = 2'h3;  // DMEM_OP_WR
    end


    // 1019: 
    // 1020: ; //////////////////////////////////////////// ASR
    // 1021: ; //
    // 1022: ASR:
    // 1023:   decode pg1_JTA ASR     $47         ; ASRA (inh)
    // 1024:   decode pg1_R1  A       $47         ; ASRA (inh)
    // 1025:                                          
    // 1026:   decode pg1_JTA ASR     $57         ; ASRB (inh)
    // 1027:   decode pg1_R1  B       $57         ; ASRB (inh)
    // 1028:                              
    // 1029:   decode pg1_JTB ASR     $07 $67 $77 ; ASR (dir idx ext)
    // 1030:   decode pg1_R1  DMEM_RD $07 $67 $77 ; ASR (dir idx ext)
    // 1031: 
    // 1032:   DATA_RSHIFT_W   SIGN_BIT, R1
    // 1033:   DATA_WRITE      R1
    // 1034: 
    // 1035:   SET_DATA_WIDTH  W_R1
    // 1036: 
    // 1037:   CCR_OP_W        OP_ooooXXoX ; INFO: Spec H Undefined, Turbo9 H not affected
    // 1038: 
    // 1039:   ADDR_PASS       EA
    // 1040:   DMEM_STORE_W  ; Disabled for inherent addressing modes
    // 1041: 
    // 1042:   JUMP_TABLE_A_NEXT_PC
    // 1043:   end_state
    9'h021: begin
      CV_MICRO_SEQ_OP_O = 3'h5;  // OP_JUMP_TABLE_A_NEXT_PC
      CV_DATA_ALU_A_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_B_SEL_O = 3'h7;  // ZERO
      CV_DATA_ALU_WR_SEL_O = 4'h8;  // R1
      CV_ADDR_ALU_REG_SEL_O = 4'hc;  // EA
      CV_DATA_ALU_OP_O = 3'h3;  // RSHIFT_A
      CV_DATA_WIDTH_SEL_O = 2'h0;  // W_R1
      CV_CCR_OP_O = 4'h6;  // OP_OOOOXXOX
      CV_DATA_ALU_COND_SEL_O = 2'h3;  // SIGN_BIT
      CV_DMEM_OP_O = 2'h3;  // DMEM_OP_WR
    end


    // 1044: 
    // 1045: ; //////////////////////////////////////////// CLR
    // 1046: ; //
    // 1047: ; // This is a little different than other memory modify
    // 1048: ; // instructions. It does not load the memory first like
    // 1049: ; // the 6809. It just writes a zero to be more efficient
    // 1050: CLR:
    // 1051: 
    // 1052:   decode pg1_JTA CLR     $4F     ; CLRA (inh)
    // 1053:   decode pg1_R1  A       $4F     ; CLRA (inh)
    // 1054:                                      
    // 1055:   decode pg1_JTA CLR     $5F     ; CLRB (inh)
    // 1056:   decode pg1_R1  B       $5F     ; CLRB (inh)
    // 1057:                            
    // 1058:   decode pg1_JTA CLR     $0F $7F ; CLR (dir ext)
    // 1059:   decode pg1_R1  DMEM_RD $0F $7F ; CLR (dir ext) sets 8bit width
    // 1060:   decode pg1_AR  IDATA   $0F $7F ; CLR (dir ext)
    // 1061:                            
    // 1062:   decode pg1_JTB CLR     $6F     ; CLR (idx)
    // 1063:   decode pg1_R1  DMEM_RD $6F     ; CLR (idx) sets 8bit width
    // 1064:   decode pg1_AR  EA      $6F     ; CLR (idx)
    // 1065: 
    // 1066:   DATA_PASS_B     ZERO 
    // 1067:   DATA_WRITE      R1
    // 1068: 
    // 1069:   SET_DATA_WIDTH  W_R1
    // 1070: 
    // 1071:   CCR_OP_W        OP_ooooXXXX
    // 1072: 
    // 1073:   ADDR_PASS       AR
    // 1074:   DMEM_STORE_W  ; Disabled for inherent addressing modes
    // 1075: 
    // 1076:   JUMP_TABLE_A_NEXT_PC
    // 1077:   end_state
    9'h022: begin
      CV_MICRO_SEQ_OP_O = 3'h5;  // OP_JUMP_TABLE_A_NEXT_PC
      CV_DATA_ALU_A_SEL_O = 4'hf;  // ZERO
      CV_DATA_ALU_B_SEL_O = 3'h7;  // ZERO
      CV_DATA_ALU_WR_SEL_O = 4'h8;  // R1
      CV_ADDR_ALU_REG_SEL_O = 4'h8;  // AR
      CV_DATA_ALU_OP_O = 3'h0;  // A_PLUS_B
      CV_DATA_WIDTH_SEL_O = 2'h0;  // W_R1
      CV_CCR_OP_O = 4'h2;  // OP_OOOOXXXX
      CV_DATA_ALU_COND_SEL_O = 2'h0;  // ZERO_BIT
      CV_DMEM_OP_O = 2'h3;  // DMEM_OP_WR
    end


    // 1078: 
    // 1079: ; //////////////////////////////////////////// COM
    // 1080: ; //
    // 1081: COM:
    // 1082:   decode pg1_JTA COM     $43         ; COMA (inh)
    // 1083:   decode pg1_R1  A       $43         ; COMA (inh)
    // 1084:   decode pg1_R2  A       $43         ; COMA (inh)
    // 1085:                                          
    // 1086:   decode pg1_JTA COM     $53         ; COMB (inh)
    // 1087:   decode pg1_R1  B       $53         ; COMB (inh)
    // 1088:   decode pg1_R2  B       $53         ; COMB (inh)
    // 1089:                              
    // 1090:   decode pg1_JTB COM     $03 $63 $73 ; COM (dir idx ext)
    // 1091:   decode pg1_R1  DMEM_RD $03 $63 $73 ; COM (dir idx ext) sets 8bit width
    // 1092:   decode pg1_R2  DMEM_RD $03 $63 $73 ; COM (dir idx ext)
    // 1093: 
    // 1094:   DATA_INVERT_B   R2
    // 1095:   DATA_WRITE      R1
    // 1096: 
    // 1097:   SET_DATA_WIDTH  W_R1
    // 1098: 
    // 1099:   CCR_OP_W        OP_ooooXXXX ; INFO Carry should be set to 1 for 6800 compatibility
    // 1100: 
    // 1101:   ADDR_PASS       EA
    // 1102:   DMEM_STORE_W ; Disabled for inherent addressing modes
    // 1103: 
    // 1104:   JUMP_TABLE_A_NEXT_PC
    // 1105:   end_state
    9'h023: begin
      CV_MICRO_SEQ_OP_O = 3'h5;  // OP_JUMP_TABLE_A_NEXT_PC
      CV_DATA_ALU_A_SEL_O = 4'hf;  // ZERO
      CV_DATA_ALU_B_SEL_O = 3'h0;  // R2
      CV_DATA_ALU_WR_SEL_O = 4'h8;  // R1
      CV_ADDR_ALU_REG_SEL_O = 4'hc;  // EA
      CV_DATA_ALU_OP_O = 3'h1;  // A_PLUS_NOT_B
      CV_DATA_WIDTH_SEL_O = 2'h0;  // W_R1
      CV_CCR_OP_O = 4'h2;  // OP_OOOOXXXX
      CV_DATA_ALU_COND_SEL_O = 2'h1;  // ONE_BIT
      CV_DMEM_OP_O = 2'h3;  // DMEM_OP_WR
    end


    // 1106: 
    // 1107: ; //////////////////////////////////////////// DEC
    // 1108: ; //
    // 1109: DEC:
    // 1110:   decode pg1_JTA DEC     $4A         ; DECA (inh)
    // 1111:   decode pg1_R1  A       $4A         ; DECA (inh)
    // 1112:                                          
    // 1113:   decode pg1_JTA DEC     $5A         ; DECB (inh)
    // 1114:   decode pg1_R1  B       $5A         ; DECB (inh)
    // 1115:                              
    // 1116:   decode pg1_JTB DEC     $0A $6A $7A ; DEC (dir idx ext)
    // 1117:   decode pg1_R1  DMEM_RD $0A $6A $7A ; DEC (dir idx ext)
    // 1118: 
    // 1119:   DATA_DEC        R1
    // 1120:   DATA_WRITE      R1
    // 1121: 
    // 1122:   SET_DATA_WIDTH  W_R1
    // 1123:   
    // 1124:   CCR_OP_W        OP_ooooXXXo
    // 1125: 
    // 1126:   ADDR_PASS       EA
    // 1127:   DMEM_STORE_W ; Disabled for inherent addressing modes
    // 1128: 
    // 1129:   JUMP_TABLE_A_NEXT_PC
    // 1130:   end_state
    9'h024: begin
      CV_MICRO_SEQ_OP_O = 3'h5;  // OP_JUMP_TABLE_A_NEXT_PC
      CV_DATA_ALU_A_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_B_SEL_O = 3'h7;  // ZERO
      CV_DATA_ALU_WR_SEL_O = 4'h8;  // R1
      CV_ADDR_ALU_REG_SEL_O = 4'hc;  // EA
      CV_DATA_ALU_OP_O = 3'h1;  // A_PLUS_NOT_B
      CV_DATA_WIDTH_SEL_O = 2'h0;  // W_R1
      CV_CCR_OP_O = 4'h4;  // OP_OOOOXXXO
      CV_DATA_ALU_COND_SEL_O = 2'h1;  // ONE_BIT
      CV_DMEM_OP_O = 2'h3;  // DMEM_OP_WR
    end


    // 1131: 
    // 1132: ; //////////////////////////////////////////// INC
    // 1133: ; //
    // 1134: INC:
    // 1135:   decode pg1_JTA INC     $4C         ; INCA (inh)
    // 1136:   decode pg1_R1  A       $4C         ; INCA (inh)
    // 1137:                                          
    // 1138:   decode pg1_JTA INC     $5C         ; INCB (inh)
    // 1139:   decode pg1_R1  B       $5C         ; INCB (inh)
    // 1140:                              
    // 1141:   decode pg1_JTB INC     $0C $6C $7C ; INC (dir idx ext)
    // 1142:   decode pg1_R1  DMEM_RD $0C $6C $7C ; INC (dir idx ext)
    // 1143: 
    // 1144:   DATA_INC        R1
    // 1145:   DATA_WRITE      R1
    // 1146: 
    // 1147:   SET_DATA_WIDTH  W_R1
    // 1148: 
    // 1149:   CCR_OP_W        OP_ooooXXXo
    // 1150: 
    // 1151:   ADDR_PASS       EA
    // 1152:   DMEM_STORE_W ; Disabled for inherent addressing modes
    // 1153: 
    // 1154:   JUMP_TABLE_A_NEXT_PC
    // 1155:   end_state
    9'h025: begin
      CV_MICRO_SEQ_OP_O = 3'h5;  // OP_JUMP_TABLE_A_NEXT_PC
      CV_DATA_ALU_A_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_B_SEL_O = 3'h7;  // ZERO
      CV_DATA_ALU_WR_SEL_O = 4'h8;  // R1
      CV_ADDR_ALU_REG_SEL_O = 4'hc;  // EA
      CV_DATA_ALU_OP_O = 3'h0;  // A_PLUS_B
      CV_DATA_WIDTH_SEL_O = 2'h0;  // W_R1
      CV_CCR_OP_O = 4'h4;  // OP_OOOOXXXO
      CV_DATA_ALU_COND_SEL_O = 2'h1;  // ONE_BIT
      CV_DMEM_OP_O = 2'h3;  // DMEM_OP_WR
    end


    // 1156: 
    // 1157: ; //////////////////////////////////////////// LSR
    // 1158: ; //
    // 1159: LSR:
    // 1160:   decode pg1_JTA LSR     $44         ; LSRA (inh)
    // 1161:   decode pg1_R1  A       $44         ; LSRA (inh)
    // 1162:                                          
    // 1163:   decode pg1_JTA LSR     $54         ; LSRB (inh)
    // 1164:   decode pg1_R1  B       $54         ; LSRB (inh)
    // 1165:                              
    // 1166:   decode pg1_JTB LSR     $04 $64 $74 ; LSR (dir idx ext)
    // 1167:   decode pg1_R1  DMEM_RD $04 $64 $74 ; LSR (dir idx ext)
    // 1168: 
    // 1169:   DATA_RSHIFT_W   ZERO_BIT, R1
    // 1170:   DATA_WRITE      R1
    // 1171: 
    // 1172:   SET_DATA_WIDTH  W_R1
    // 1173: 
    // 1174:   CCR_OP_W        OP_ooooXXoX
    // 1175: 
    // 1176:   ADDR_PASS       EA
    // 1177:   DMEM_STORE_W ; Disabled for inherent addressing modes
    // 1178: 
    // 1179:   JUMP_TABLE_A_NEXT_PC
    // 1180:   end_state
    9'h026: begin
      CV_MICRO_SEQ_OP_O = 3'h5;  // OP_JUMP_TABLE_A_NEXT_PC
      CV_DATA_ALU_A_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_B_SEL_O = 3'h7;  // ZERO
      CV_DATA_ALU_WR_SEL_O = 4'h8;  // R1
      CV_ADDR_ALU_REG_SEL_O = 4'hc;  // EA
      CV_DATA_ALU_OP_O = 3'h3;  // RSHIFT_A
      CV_DATA_WIDTH_SEL_O = 2'h0;  // W_R1
      CV_CCR_OP_O = 4'h6;  // OP_OOOOXXOX
      CV_DATA_ALU_COND_SEL_O = 2'h0;  // ZERO_BIT
      CV_DMEM_OP_O = 2'h3;  // DMEM_OP_WR
    end


    // 1181: 
    // 1182: ; //////////////////////////////////////////// NEG
    // 1183: ; //
    // 1184: NEG:
    // 1185:   decode pg1_JTA NEG     $40         ; NEGA (inh)
    // 1186:   decode pg1_R1  A       $40         ; NEGA (inh)
    // 1187:   decode pg1_R2  A       $40         ; NEGA (inh)
    // 1188:                                          
    // 1189:   decode pg1_JTA NEG     $50         ; NEGB (inh)
    // 1190:   decode pg1_R1  B       $50         ; NEGB (inh)
    // 1191:   decode pg1_R2  B       $50         ; NEGB (inh)
    // 1192:                                          
    // 1193:   decode pg1_JTB NEG     $00 $60 $70 ; NEG (dir idx ext)
    // 1194:   decode pg1_R1  DMEM_RD $00 $60 $70 ; NEG (dir idx ext) sets 8bit width
    // 1195:   decode pg1_R2  DMEM_RD $00 $60 $70 ; NEG (dir idx ext)
    // 1196: 
    // 1197:   DATA_SUB        ZERO, R2
    // 1198:   DATA_WRITE      R1
    // 1199: 
    // 1200:   SET_DATA_WIDTH  W_R1
    // 1201: 
    // 1202:   CCR_OP_W        OP_ooooXXXX ; INFO: Spec H Undefined, Turbo9 H not affected
    // 1203: 
    // 1204:   ADDR_PASS       EA
    // 1205:   DMEM_STORE_W ; Disabled for inherent addressing modes
    // 1206: 
    // 1207:   JUMP_TABLE_A_NEXT_PC
    // 1208:   end_state
    9'h027: begin
      CV_MICRO_SEQ_OP_O = 3'h5;  // OP_JUMP_TABLE_A_NEXT_PC
      CV_DATA_ALU_A_SEL_O = 4'hf;  // ZERO
      CV_DATA_ALU_B_SEL_O = 3'h0;  // R2
      CV_DATA_ALU_WR_SEL_O = 4'h8;  // R1
      CV_ADDR_ALU_REG_SEL_O = 4'hc;  // EA
      CV_DATA_ALU_OP_O = 3'h1;  // A_PLUS_NOT_B
      CV_DATA_WIDTH_SEL_O = 2'h0;  // W_R1
      CV_CCR_OP_O = 4'h2;  // OP_OOOOXXXX
      CV_DATA_ALU_COND_SEL_O = 2'h0;  // ZERO_BIT
      CV_DMEM_OP_O = 2'h3;  // DMEM_OP_WR
    end


    // 1209: 
    // 1210: ; //////////////////////////////////////////// ROL
    // 1211: ; //
    // 1212: ROL:
    // 1213:   decode pg1_JTA ROL     $49         ; ROLA (inh)
    // 1214:   decode pg1_R1  A       $49         ; ROLA (inh)
    // 1215:                                          
    // 1216:   decode pg1_JTA ROL     $59         ; ROLB (inh)
    // 1217:   decode pg1_R1  B       $59         ; ROLB (inh)
    // 1218:                                          
    // 1219:   decode pg1_JTB ROL     $09 $69 $79 ; ROL (dir idx ext)
    // 1220:   decode pg1_R1  DMEM_RD $09 $69 $79 ; ROL (dir idx ext)
    // 1221: 
    // 1222:   DATA_LSHIFT_W   R1, CARRY_BIT
    // 1223:   DATA_WRITE      R1
    // 1224: 
    // 1225:   SET_DATA_WIDTH  W_R1
    // 1226: 
    // 1227:   CCR_OP_W        OP_ooooXXXX
    // 1228: 
    // 1229:   ADDR_PASS       EA
    // 1230:   DMEM_STORE_W ; Disabled for inherent addressing modes
    // 1231: 
    // 1232:   JUMP_TABLE_A_NEXT_PC
    // 1233:   end_state
    9'h028: begin
      CV_MICRO_SEQ_OP_O = 3'h5;  // OP_JUMP_TABLE_A_NEXT_PC
      CV_DATA_ALU_A_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_B_SEL_O = 3'h7;  // ZERO
      CV_DATA_ALU_WR_SEL_O = 4'h8;  // R1
      CV_ADDR_ALU_REG_SEL_O = 4'hc;  // EA
      CV_DATA_ALU_OP_O = 3'h2;  // LSHIFT_A
      CV_DATA_WIDTH_SEL_O = 2'h0;  // W_R1
      CV_CCR_OP_O = 4'h2;  // OP_OOOOXXXX
      CV_DATA_ALU_COND_SEL_O = 2'h2;  // CARRY_BIT
      CV_DMEM_OP_O = 2'h3;  // DMEM_OP_WR
    end


    // 1234: 
    // 1235: ; //////////////////////////////////////////// ROR
    // 1236: ; //
    // 1237: ROR:
    // 1238:   decode pg1_JTA ROR     $46         ; RORA (inh)
    // 1239:   decode pg1_R1  A       $46         ; RORA (inh)
    // 1240:                                                    
    // 1241:   decode pg1_JTA ROR     $56         ; RORB (inh)
    // 1242:   decode pg1_R1  B       $56         ; RORB (inh)
    // 1243:                              
    // 1244:   decode pg1_JTB ROR     $06 $66 $76 ; ROR (dir idx ext)
    // 1245:   decode pg1_R1  DMEM_RD $06 $66 $76 ; ROR (dir idx ext)
    // 1246: 
    // 1247:   DATA_RSHIFT_W   CARRY_BIT, R1
    // 1248:   DATA_WRITE      R1
    // 1249: 
    // 1250:   SET_DATA_WIDTH  W_R1
    // 1251: 
    // 1252:   CCR_OP_W        OP_ooooXXoX
    // 1253: 
    // 1254:   ADDR_PASS       EA
    // 1255:   DMEM_STORE_W ; Disabled for inherent addressing modes
    // 1256: 
    // 1257:   JUMP_TABLE_A_NEXT_PC
    // 1258:   end_state
    9'h029: begin
      CV_MICRO_SEQ_OP_O = 3'h5;  // OP_JUMP_TABLE_A_NEXT_PC
      CV_DATA_ALU_A_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_B_SEL_O = 3'h7;  // ZERO
      CV_DATA_ALU_WR_SEL_O = 4'h8;  // R1
      CV_ADDR_ALU_REG_SEL_O = 4'hc;  // EA
      CV_DATA_ALU_OP_O = 3'h3;  // RSHIFT_A
      CV_DATA_WIDTH_SEL_O = 2'h0;  // W_R1
      CV_CCR_OP_O = 4'h6;  // OP_OOOOXXOX
      CV_DATA_ALU_COND_SEL_O = 2'h2;  // CARRY_BIT
      CV_DMEM_OP_O = 2'h3;  // DMEM_OP_WR
    end


    // 1259: 
    // 1260: ; //////////////////////////////////////////// TST
    // 1261: ; //
    // 1262: TST:
    // 1263:   decode pg1_JTA TST     $4D         ; TSTA (inh)
    // 1264:   decode pg1_R1  A       $4D         ; TSTA (inh)
    // 1265:                                          
    // 1266:   decode pg1_JTA TST     $5D         ; TSTB (inh)
    // 1267:   decode pg1_R1  B       $5D         ; TSTB (inh)
    // 1268:                              
    // 1269:   decode pg1_JTB TST     $0D $6D $7D ; TST (dir idx ext)
    // 1270:   decode pg1_R1  DMEM_RD $0D $6D $7D ; TST (dir idx ext)
    // 1271: 
    // 1272:   DATA_PASS_A     R1 ; Pass A, B or DMEM
    // 1273: 
    // 1274:   SET_DATA_WIDTH  W_R1
    // 1275: 
    // 1276:   CCR_OP_W        OP_ooooXXXo
    // 1277: 
    // 1278:   JUMP_TABLE_A_NEXT_PC
    // 1279:   end_state
    9'h02a: begin
      CV_MICRO_SEQ_OP_O = 3'h5;  // OP_JUMP_TABLE_A_NEXT_PC
      CV_DATA_ALU_A_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_B_SEL_O = 3'h7;  // ZERO
      CV_DATA_ALU_OP_O = 3'h0;  // A_PLUS_B
      CV_DATA_WIDTH_SEL_O = 2'h0;  // W_R1
      CV_CCR_OP_O = 4'h4;  // OP_OOOOXXXO
      CV_DATA_ALU_COND_SEL_O = 2'h0;  // ZERO_BIT
    end


    // 1280: 
    // 1281: ; //
    // 1282: ; ////////////////////////////////////////////////////////////////////////////
    // 1283: 
    // 1284: 
    // 1285: 
    // 1286: ; ////////////////////////////////////////////////////////////////////////////
    // 1287: ;                        JUMP & BRANCH INSTRUCTIONS
    // 1288: ; ////////////////////////////////////////////////////////////////////////////
    // 1289: ; //
    // 1290: 
    // 1291: ; //////////////////////////////////////////// BRANCH
    // 1292: ; //
    // 1293: BRANCH:
    // 1294:   decode pg1_JTA BRANCH $20 $21 $22 $23 ; BRA BRN BHI BLS
    // 1295:   decode pg1_JTB JMP    $20 $21 $22 $23 ; BRA BRN BHI BLS
    // 1296:   decode pg1_R1  PC     $20 $21 $22 $23 ; BRA BRN BHI BLS
    // 1297:   decode pg1_R2  EA     $20 $21 $22 $23 ; BRA BRN BHI BLS
    // 1298:                                             
    // 1299:   decode pg1_JTA BRANCH $24 $25 $26 $27 ; BCC BCS BNE BEQ
    // 1300:   decode pg1_JTB JMP    $24 $25 $26 $27 ; BCC BCS BNE BEQ
    // 1301:   decode pg1_R1  PC     $24 $25 $26 $27 ; BCC BCS BNE BEQ
    // 1302:   decode pg1_R2  EA     $24 $25 $26 $27 ; BCC BCS BNE BEQ
    // 1303:                                             
    // 1304:   decode pg1_JTA BRANCH $28 $29 $2A $2B ; BVC BVS BPL BMI
    // 1305:   decode pg1_JTB JMP    $28 $29 $2A $2B ; BVC BVS BPL BMI
    // 1306:   decode pg1_R1  PC     $28 $29 $2A $2B ; BVC BVS BPL BMI
    // 1307:   decode pg1_R2  EA     $28 $29 $2A $2B ; BVC BVS BPL BMI
    // 1308:                                             
    // 1309:   decode pg1_JTA BRANCH $2C $2D $2E $2F ; BGE BLT BGT BLE
    // 1310:   decode pg1_JTB JMP    $2C $2D $2E $2F ; BGE BLT BGT BLE
    // 1311:   decode pg1_R1  PC     $2C $2D $2E $2F ; BGE BLT BGT BLE
    // 1312:   decode pg1_R2  EA     $2C $2D $2E $2F ; BGE BLT BGT BLE
    // 1313:                                             
    // 1314:   decode pg1_JTA BRANCH $16             ; LBRA On page 1!
    // 1315:   decode pg1_JTB JMP    $16             ; LBRA
    // 1316:   decode pg1_R1  PC     $16             ; LBRA 
    // 1317:   decode pg1_R2  EA     $16             ; LBRA 
    // 1318:                 
    // 1319:   decode pg1_JTA BRANCH $8D $17         ; BSR LBSR // FIXME could do this without JUMP_TABLE_A
    // 1320:   decode pg1_JTB JSR    $8D $17         ; BSR LBSR // FIXME check if smaller area
    // 1321:   decode pg1_R1  PC     $8D $17         ; BSR LBSR
    // 1322:   decode pg1_R2  EA     $8D $17         ; BSR LBSR
    // 1323:   decode pg1_AR  S      $8D $17         ; BSR LBSR
    // 1324:                             
    // 1325: ; Another LBRA hidden on Page 2!
    // 1326:   decode pg2_JTA BRANCH $20 $21 $22 $23 ; LBRA LBRN LBHI LBLS
    // 1327:   decode pg2_JTB JMP    $20 $21 $22 $23 ; LBRA LBRN LBHI LBLS
    // 1328:   decode pg2_R1  PC     $20 $21 $22 $23 ; LBRA LBRN LBHI LBLS
    // 1329:   decode pg2_R2  EA     $20 $21 $22 $23 ; LBRA LBRN LBHI LBLS
    // 1330:                                                                   
    // 1331:   decode pg2_JTA BRANCH $24 $25 $26 $27 ; LBCC LBCS LBNE LBEQ
    // 1332:   decode pg2_JTB JMP    $24 $25 $26 $27 ; LBCC LBCS LBNE LBEQ
    // 1333:   decode pg2_R1  PC     $24 $25 $26 $27 ; LBCC LBCS LBNE LBEQ
    // 1334:   decode pg2_R2  EA     $24 $25 $26 $27 ; LBCC LBCS LBNE LBEQ
    // 1335:                                                                   
    // 1336:   decode pg2_JTA BRANCH $28 $29 $2A $2B ; LBVC LBVS LBPL LBMI
    // 1337:   decode pg2_JTB JMP    $28 $29 $2A $2B ; LBVC LBVS LBPL LBMI
    // 1338:   decode pg2_R1  PC     $28 $29 $2A $2B ; LBVC LBVS LBPL LBMI
    // 1339:   decode pg2_R2  EA     $28 $29 $2A $2B ; LBVC LBVS LBPL LBMI
    // 1340:                                                                   
    // 1341:   decode pg2_JTA BRANCH $2C $2D $2E $2F ; LBGE LBLT LBGT LBLE
    // 1342:   decode pg2_JTB JMP    $2C $2D $2E $2F ; LBGE LBLT LBGT LBLE
    // 1343:   decode pg2_R1  PC     $2C $2D $2E $2F ; LBGE LBLT LBGT LBLE
    // 1344:   decode pg2_R2  EA     $2C $2D $2E $2F ; LBGE LBLT LBGT LBLE
    // 1345: 
    // 1346:   DATA_ADD        R1, IDATA ; PC + signed offset
    // 1347:   DATA_WRITE      EA
    // 1348: 
    // 1349:   SET_DATA_WIDTH  W_R1
    // 1350: 
    // 1351:   IF              BRANCH_COND
    // 1352:   JUMP_TABLE_B
    // 1353:   end_state
    9'h02b: begin
      CV_MICRO_SEQ_OP_O = 3'h4;  // OP_JUMP_TABLE_B
      CV_DATA_ALU_A_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_B_SEL_O = 3'h6;  // IDATA
      CV_DATA_ALU_WR_SEL_O = 4'hc;  // EA
      CV_DATA_ALU_OP_O = 3'h0;  // A_PLUS_B
      CV_DATA_WIDTH_SEL_O = 2'h0;  // W_R1
      CV_DATA_ALU_COND_SEL_O = 2'h0;  // ZERO_BIT
      CV_MICRO_SEQ_COND_SEL_O = 4'h8;  // BRANCH_COND
    end


    // 1354: 
    // 1355: GO_NEW_PC:
    // 1356:   JUMP_TABLE_A_NEXT_PC
    // 1357:   end_state
    9'h02c: begin
      CV_MICRO_SEQ_OP_O = 3'h5;  // OP_JUMP_TABLE_A_NEXT_PC
    end


    // 1358: 
    // 1359: ; //////////////////////////////////////////// JMP
    // 1360: ; //
    // 1361: JMP:
    // 1362:   decode pg1_JTA JMP   $0E $7E ; JMP (dir ext)
    // 1363:   decode pg1_R1  PC    $0E $7E ; JMP (dir ext)
    // 1364:   decode pg1_R2  IDATA $0E $7E ; JMP (dir ext)
    // 1365:                                    
    // 1366:   decode pg1_JTB JMP   $6E     ; JMP (idx)
    // 1367:   decode pg1_R1  PC    $6E     ; JMP (idx)
    // 1368:   decode pg1_R2  EA    $6E     ; JMP (idx)
    // 1369: 
    // 1370:   DATA_PASS_B     R2 ; IDATA or EA
    // 1371:   DATA_WRITE      R1 ; PC
    // 1372: 
    // 1373:   JUMP            GO_NEW_PC ; PC must be written before "JUMP_TABLE_A_NEXT_PC"
    // 1374:   end_state
    9'h02d: begin
      CV_MICRO_SEQ_OP_O = 3'h1;  // OP_JUMP
      CV_MICRO_SEQ_BRANCH_ADDR_O = 8'h2c;  // GO_NEW_PC
      CV_DATA_ALU_A_SEL_O = 4'hf;  // ZERO
      CV_DATA_ALU_B_SEL_O = 3'h0;  // R2
      CV_DATA_ALU_WR_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_OP_O = 3'h0;  // A_PLUS_B
      CV_DATA_ALU_COND_SEL_O = 2'h0;  // ZERO_BIT
    end


    // 1375: 
    // 1376: 
    // 1377: ; ////////////////////////////////////////////////////////////////////////////
    // 1378: 
    // 1379: 
    // 1380: 
    // 1381: ; ////////////////////////////////////////////////////////////////////////////
    // 1382: ;                        STACK INSTRUCTIONS
    // 1383: ; ////////////////////////////////////////////////////////////////////////////
    // 1384: ; //
    // 1385: 
    // 1386: 
    // 1387: ; //////////////////////////////////////////// JSR
    // 1388: ; //
    // 1389: JSR:
    // 1390:   decode pg1_JTA JSR   $9D $BD ; JSR (dir ext)
    // 1391:   decode pg1_R1  PC    $9D $BD ; JSR (dir ext)
    // 1392:   decode pg1_R2  IDATA $9D $BD ; JSR (dir ext)
    // 1393:   decode pg1_AR  S     $9D $BD ; JSR (dir ext)
    // 1394:                                  
    // 1395:   decode pg1_JTB JSR   $AD     ; JSR (idx)
    // 1396:   decode pg1_R1  PC    $AD     ; JSR (idx)
    // 1397:   decode pg1_R2  EA    $AD     ; JSR (idx)
    // 1398:   decode pg1_AR  S     $AD     ; JSR (idx)
    // 1399: 
    // 1400:   DATA_PASS_A     R1 ; PC
    // 1401: 
    // 1402:   SET_DATA_WIDTH  W_R1
    // 1403: 
    // 1404:   STACK_PUSH      AR
    // 1405:   DMEM_STORE_W
    // 1406: 
    // 1407:   JUMP            JMP 
    // 1408:   end_state
    9'h02e: begin
      CV_MICRO_SEQ_OP_O = 3'h1;  // OP_JUMP
      CV_MICRO_SEQ_BRANCH_ADDR_O = 8'h2d;  // JMP
      CV_DATA_ALU_A_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_B_SEL_O = 3'h7;  // ZERO
      CV_ADDR_ALU_REG_SEL_O = 4'h8;  // AR
      CV_DATA_ALU_OP_O = 3'h0;  // A_PLUS_B
      CV_DATA_WIDTH_SEL_O = 2'h0;  // W_R1
      CV_DATA_ALU_COND_SEL_O = 2'h0;  // ZERO_BIT
      CV_DMEM_OP_O = 2'h3;  // DMEM_OP_WR
      CV_STACK_OP_O = 2'h2;  // STACK_OP_PUSH
    end


    // 1409: 
    // 1410: ; //////////////////////////////////////////// RTS
    // 1411: ; //
    // 1412: RTS:
    // 1413:   decode pg1_JTA RTS      $39 ; RTS
    // 1414:   decode pg1_R1  PC       $39 ; RTS
    // 1415:   decode pg1_R2  DMEM_RD  $39 ; RTS
    // 1416:   decode pg1_AR  S        $39 ; RTS
    // 1417: 
    // 1418:   SET_DATA_WIDTH  W_R1
    // 1419:   
    // 1420:   STACK_PULL      AR
    // 1421:   DMEM_LOAD_W
    // 1422:   
    // 1423:   JUMP            JMP
    // 1424:   end_state
    9'h02f: begin
      CV_MICRO_SEQ_OP_O = 3'h1;  // OP_JUMP
      CV_MICRO_SEQ_BRANCH_ADDR_O = 8'h2d;  // JMP
      CV_ADDR_ALU_REG_SEL_O = 4'h8;  // AR
      CV_DATA_WIDTH_SEL_O = 2'h0;  // W_R1
      CV_DMEM_OP_O = 2'h2;  // DMEM_OP_RD
      CV_STACK_OP_O = 2'h1;  // STACK_OP_PULL
    end


    // 1425: 
    // 1426: ; //////////////////////////////////////////// RTI
    // 1427: ; //
    // 1428: RTI:
    // 1429:   decode pg1_JTA RTI      $3B ; RTI
    // 1430:   decode pg1_R1  PC       $3B ; RTI
    // 1431:   decode pg1_R2  DMEM_RD  $3B ; RTI
    // 1432:   decode pg1_AR  S        $3B ; RTI
    // 1433:   
    // 1434:   STACK_PULL      ZERO  ; Prime the decode pipeline!
    // 1435:   end_state
    9'h030: begin
      CV_ADDR_ALU_REG_SEL_O = 4'hf;  // ZERO
      CV_STACK_OP_O = 2'h1;  // STACK_OP_PULL
    end


    // 1436: 
    // 1437:   SET_DATA_WIDTH  W_STACK_REG
    // 1438:   
    // 1439:   STACK_PULL      AR
    // 1440:   DMEM_LOAD_W
    // 1441:   end_state
    9'h031: begin
      CV_ADDR_ALU_REG_SEL_O = 4'h8;  // AR
      CV_DATA_WIDTH_SEL_O = 2'h2;  // W_STACK_REG
      CV_DMEM_OP_O = 2'h2;  // DMEM_OP_RD
      CV_STACK_OP_O = 2'h1;  // STACK_OP_PULL
    end


    // 1442: 
    // 1443: RTI_CCR:
    // 1444:   DATA_PASS_B     DMEM_RD
    // 1445:   DATA_WRITE      STACK_REG
    // 1446: 
    // 1447:   CCR_OP_W        OP_XXXXXXXX ; FIXME get rid of this requirement
    // 1448:   end_state
    9'h032: begin
      CV_DATA_ALU_A_SEL_O = 4'hf;  // ZERO
      CV_DATA_ALU_B_SEL_O = 3'h5;  // DMEM_RD
      CV_DATA_ALU_WR_SEL_O = 4'h0;  // STACK_REG
      CV_DATA_ALU_OP_O = 3'h0;  // A_PLUS_B
      CV_CCR_OP_O = 4'h9;  // OP_XXXXXXXX
      CV_DATA_ALU_COND_SEL_O = 2'h0;  // ZERO_BIT
    end


    // 1449: 
    // 1450: RTI_TEST_E:
    // 1451:   IF              E_CLEAR
    // 1452:   JUMP            RTS
    // 1453:   end_state
    9'h033: begin
      CV_MICRO_SEQ_OP_O = 3'h1;  // OP_JUMP
      CV_MICRO_SEQ_BRANCH_ADDR_O = 8'h2f;  // RTS
      CV_MICRO_SEQ_COND_SEL_O = 4'h5;  // E_CLEAR
    end


    // 1454: 
    // 1455: RTI_PUL_ALL:
    // 1456:   SET_DATA_WIDTH  W_STACK_REG
    // 1457:   
    // 1458:   STACK_PULL      AR
    // 1459:   DMEM_LOAD_W
    // 1460:   
    // 1461:   JUMP            PUL_LOOP
    // 1462:   end_state
    9'h034: begin
      CV_MICRO_SEQ_OP_O = 3'h1;  // OP_JUMP
      CV_MICRO_SEQ_BRANCH_ADDR_O = 8'h37;  // PUL_LOOP
      CV_ADDR_ALU_REG_SEL_O = 4'h8;  // AR
      CV_DATA_WIDTH_SEL_O = 2'h2;  // W_STACK_REG
      CV_DMEM_OP_O = 2'h2;  // DMEM_OP_RD
      CV_STACK_OP_O = 2'h1;  // STACK_OP_PULL
    end


    // 1463: 
    // 1464: 
    // 1465: ; //////////////////////////////////////////// PULS PULU
    // 1466: ; //
    // 1467: PUL:
    // 1468:   decode pg1_JTA PUL  $35 ; PULS
    // 1469:   decode pg1_AR  S    $35 ; PULS
    // 1470: 
    // 1471:   decode pg1_JTA PUL  $37 ; PULU
    // 1472:   decode pg1_AR  U    $37 ; PULU
    // 1473: 
    // 1474:   
    // 1475:   STACK_PULL      ZERO  ; Prime the decode pipeline!
    // 1476:   
    // 1477:   IF              STACK_DONE
    // 1478:   JUMP            NOP
    // 1479:   end_state
    9'h035: begin
      CV_MICRO_SEQ_OP_O = 3'h1;  // OP_JUMP
      CV_MICRO_SEQ_BRANCH_ADDR_O = 8'hc;  // NOP
      CV_ADDR_ALU_REG_SEL_O = 4'hf;  // ZERO
      CV_MICRO_SEQ_COND_SEL_O = 4'h2;  // STACK_DONE
      CV_STACK_OP_O = 2'h1;  // STACK_OP_PULL
    end


    // 1480:   
    // 1481:   SET_DATA_WIDTH  W_STACK_REG
    // 1482:   
    // 1483:   STACK_PULL      AR
    // 1484:   DMEM_LOAD_W
    // 1485:   
    // 1486:   IF              STACK_DONE
    // 1487:   JUMP            PUL_DONE
    // 1488:   end_state
    9'h036: begin
      CV_MICRO_SEQ_OP_O = 3'h1;  // OP_JUMP
      CV_MICRO_SEQ_BRANCH_ADDR_O = 8'h38;  // PUL_DONE
      CV_ADDR_ALU_REG_SEL_O = 4'h8;  // AR
      CV_DATA_WIDTH_SEL_O = 2'h2;  // W_STACK_REG
      CV_MICRO_SEQ_COND_SEL_O = 4'h2;  // STACK_DONE
      CV_DMEM_OP_O = 2'h2;  // DMEM_OP_RD
      CV_STACK_OP_O = 2'h1;  // STACK_OP_PULL
    end


    // 1489: 
    // 1490: PUL_LOOP:
    // 1491:   DATA_PASS_B     DMEM_RD
    // 1492:   DATA_WRITE      STACK_REG
    // 1493: 
    // 1494:   CCR_OP_W        OP_XXXXXXXX ; FIXME get rid of this requirement
    // 1495:   
    // 1496:   SET_DATA_WIDTH  W_STACK_REG
    // 1497: 
    // 1498:   STACK_PULL      AR
    // 1499:   DMEM_LOAD_W
    // 1500: 
    // 1501:   IF              STACK_NEXT
    // 1502:   JUMP            PUL_LOOP
    // 1503:   end_state
    9'h037: begin
      CV_MICRO_SEQ_OP_O = 3'h1;  // OP_JUMP
      CV_MICRO_SEQ_BRANCH_ADDR_O = 8'h37;  // PUL_LOOP
      CV_DATA_ALU_A_SEL_O = 4'hf;  // ZERO
      CV_DATA_ALU_B_SEL_O = 3'h5;  // DMEM_RD
      CV_DATA_ALU_WR_SEL_O = 4'h0;  // STACK_REG
      CV_ADDR_ALU_REG_SEL_O = 4'h8;  // AR
      CV_DATA_ALU_OP_O = 3'h0;  // A_PLUS_B
      CV_DATA_WIDTH_SEL_O = 2'h2;  // W_STACK_REG
      CV_CCR_OP_O = 4'h9;  // OP_XXXXXXXX
      CV_DATA_ALU_COND_SEL_O = 2'h0;  // ZERO_BIT
      CV_MICRO_SEQ_COND_SEL_O = 4'h3;  // STACK_NEXT
      CV_DMEM_OP_O = 2'h2;  // DMEM_OP_RD
      CV_STACK_OP_O = 2'h1;  // STACK_OP_PULL
    end


    // 1504: 
    // 1505: PUL_DONE:
    // 1506:   DATA_PASS_B     DMEM_RD
    // 1507:   DATA_WRITE      STACK_REG
    // 1508: 
    // 1509:   CCR_OP_W        OP_XXXXXXXX ; FIXME get rid of this requirement
    // 1510: 
    // 1511:   JUMP            GO_NEW_PC ; PC must be written before "JUMP_TABLE_A_NEXT_PC" FIXME?
    // 1512:   end_state
    9'h038: begin
      CV_MICRO_SEQ_OP_O = 3'h1;  // OP_JUMP
      CV_MICRO_SEQ_BRANCH_ADDR_O = 8'h2c;  // GO_NEW_PC
      CV_DATA_ALU_A_SEL_O = 4'hf;  // ZERO
      CV_DATA_ALU_B_SEL_O = 3'h5;  // DMEM_RD
      CV_DATA_ALU_WR_SEL_O = 4'h0;  // STACK_REG
      CV_DATA_ALU_OP_O = 3'h0;  // A_PLUS_B
      CV_CCR_OP_O = 4'h9;  // OP_XXXXXXXX
      CV_DATA_ALU_COND_SEL_O = 2'h0;  // ZERO_BIT
    end


    // 1513: 
    // 1514: 
    // 1515: ; //////////////////////////////////////////// PSHS PSHU
    // 1516: ; //
    // 1517: PSH:
    // 1518:   decode pg1_JTA PSH   $34 ; PSHS
    // 1519:   decode pg1_AR  S     $34 ; PSHS
    // 1520: 
    // 1521:   decode pg1_JTA PSH   $36 ; PSHU
    // 1522:   decode pg1_AR  U     $36 ; PSHU
    // 1523:   
    // 1524:   STACK_PUSH      ZERO  ; Prime the decode pipeline!
    // 1525: 
    // 1526:   IF              STACK_DONE
    // 1527:   JUMP            NOP
    // 1528:   end_state
    9'h039: begin
      CV_MICRO_SEQ_OP_O = 3'h1;  // OP_JUMP
      CV_MICRO_SEQ_BRANCH_ADDR_O = 8'hc;  // NOP
      CV_ADDR_ALU_REG_SEL_O = 4'hf;  // ZERO
      CV_MICRO_SEQ_COND_SEL_O = 4'h2;  // STACK_DONE
      CV_STACK_OP_O = 2'h2;  // STACK_OP_PUSH
    end


    // 1529:   
    // 1530: PSH_LOOP:
    // 1531:   DATA_PASS_A     STACK_REG
    // 1532:   
    // 1533:   SET_DATA_WIDTH  W_STACK_REG
    // 1534: 
    // 1535:   STACK_PUSH      AR
    // 1536:   DMEM_STORE_W
    // 1537: 
    // 1538:   IF              STACK_NEXT
    // 1539:   JUMP            PSH_LOOP
    // 1540:   end_state
    9'h03a: begin
      CV_MICRO_SEQ_OP_O = 3'h1;  // OP_JUMP
      CV_MICRO_SEQ_BRANCH_ADDR_O = 8'h3a;  // PSH_LOOP
      CV_DATA_ALU_A_SEL_O = 4'h0;  // STACK_REG
      CV_DATA_ALU_B_SEL_O = 3'h7;  // ZERO
      CV_ADDR_ALU_REG_SEL_O = 4'h8;  // AR
      CV_DATA_ALU_OP_O = 3'h0;  // A_PLUS_B
      CV_DATA_WIDTH_SEL_O = 2'h2;  // W_STACK_REG
      CV_DATA_ALU_COND_SEL_O = 2'h0;  // ZERO_BIT
      CV_MICRO_SEQ_COND_SEL_O = 4'h3;  // STACK_NEXT
      CV_DMEM_OP_O = 2'h3;  // DMEM_OP_WR
      CV_STACK_OP_O = 2'h2;  // STACK_OP_PUSH
    end


    // 1541: 
    // 1542:   JUMP_TABLE_A_NEXT_PC
    // 1543:   end_state
    9'h03b: begin
      CV_MICRO_SEQ_OP_O = 3'h5;  // OP_JUMP_TABLE_A_NEXT_PC
    end


    // 1544: 
    // 1545: 
    // 1546: ; //////////////////////////////////////////// SWI
    // 1547: ; //
    // 1548: SWI:
    // 1549:   decode pg1_JTA SWI      $3F ; SWI
    // 1550:   decode pg1_AR  S        $3F ; SWI
    // 1551:   decode pg1_R1  PC       $3F ; SWI
    // 1552:   decode pg1_R2  DMEM_RD  $3F ; SWI
    // 1553:   
    // 1554:   STACK_PUSH      ZERO  ; Prime the decode pipeline!
    // 1555: 
    // 1556:   CCR_OP_W        OP_1ooooooo ; Set E
    // 1557:   end_state
    9'h03c: begin
      CV_ADDR_ALU_REG_SEL_O = 4'hf;  // ZERO
      CV_CCR_OP_O = 4'h7;  // OP_1OOOOOOO
      CV_STACK_OP_O = 2'h2;  // STACK_OP_PUSH
    end


    // 1558:   
    // 1559: SWI_LOOP:
    // 1560:   DATA_PASS_A     STACK_REG
    // 1561:   
    // 1562:   SET_DATA_WIDTH  W_STACK_REG
    // 1563: 
    // 1564:   STACK_PUSH      AR
    // 1565:   DMEM_STORE_W
    // 1566: 
    // 1567:   IF              STACK_NEXT
    // 1568:   JUMP            SWI_LOOP
    // 1569:   end_state
    9'h03d: begin
      CV_MICRO_SEQ_OP_O = 3'h1;  // OP_JUMP
      CV_MICRO_SEQ_BRANCH_ADDR_O = 8'h3d;  // SWI_LOOP
      CV_DATA_ALU_A_SEL_O = 4'h0;  // STACK_REG
      CV_DATA_ALU_B_SEL_O = 3'h7;  // ZERO
      CV_ADDR_ALU_REG_SEL_O = 4'h8;  // AR
      CV_DATA_ALU_OP_O = 3'h0;  // A_PLUS_B
      CV_DATA_WIDTH_SEL_O = 2'h2;  // W_STACK_REG
      CV_DATA_ALU_COND_SEL_O = 2'h0;  // ZERO_BIT
      CV_MICRO_SEQ_COND_SEL_O = 4'h3;  // STACK_NEXT
      CV_DMEM_OP_O = 2'h3;  // DMEM_OP_WR
      CV_STACK_OP_O = 2'h2;  // STACK_OP_PUSH
    end


    // 1570: 
    // 1571:   ; R1 is PC
    // 1572:   ; R2 is DMEM_RD
    // 1573: 
    // 1574:   SET_DATA_WIDTH  W_16
    // 1575: 
    // 1576:   ADDR_PASS       IDATA ; SWI vector
    // 1577:   DMEM_LOAD_W
    // 1578:   
    // 1579:   CCR_OP_W        OP_o1o1oooo ; Set I & F
    // 1580: 
    // 1581:   JUMP            JMP
    // 1582:   end_state
    9'h03e: begin
      CV_MICRO_SEQ_OP_O = 3'h1;  // OP_JUMP
      CV_MICRO_SEQ_BRANCH_ADDR_O = 8'h2d;  // JMP
      CV_ADDR_ALU_REG_SEL_O = 4'he;  // IDATA
      CV_DATA_WIDTH_SEL_O = 2'h3;  // W_16
      CV_CCR_OP_O = 4'h8;  // OP_O1O1OOOO
      CV_DMEM_OP_O = 2'h2;  // DMEM_OP_RD
    end


    // 1583: 
    // 1584: 
    // 1585: 
    // 1586: ; ////////////////////////////////////////////////////////////////////////////
    // 1587: 
    // 1588: 
    // 1589:   ORG  $FF
    // 1590: 
    // 1591: TRAP:
    // 1592: 
    // 1593:   JUMP            TRAP
    // 1594:   end_state
    9'h0ff: begin
      CV_MICRO_SEQ_OP_O = 3'h1;  // OP_JUMP
      CV_MICRO_SEQ_BRANCH_ADDR_O = 8'hff;  // TRAP
    end


    // 1595: 
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
      CV_DATA_WIDTH_SEL_O = 2'h0;  // W_R1
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

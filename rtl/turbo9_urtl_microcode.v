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
    // 0038: ; vim syntax :set syn=asm68k
    // 0039: ;
    // 0040: ; ////////////////////////////////////////////////////////////////////////////
    // 0041: ; History:
    // 0042: ; 07.14.2023 - Kevin Phillipson
    // 0043: ;   File header added
    // 0044: ;
    // 0045: ; ////////////////////////////////////////////////////////////////////////////
    // 0046: ; [TURBO9_HEADER_END]
    // 0047: 
    // 0048: ; decode_init <tablename> <ctrl_vec> <default_string> ; Comment
    // 0049: 
    // 0050:   ; Jump Table A
    // 0051:   decode_init pg1_JTA cv_MICRO_SEQ_BRANCH_ADDR FF ; Page 1
    // 0052:   decode_init pg2_JTA cv_MICRO_SEQ_BRANCH_ADDR FF ; Page 2
    // 0053:   decode_init pg3_JTA cv_MICRO_SEQ_BRANCH_ADDR FF ; Page 3
    // 0054:   
    // 0055:   ; Jump Table B
    // 0056:   decode_init pg1_JTB cv_MICRO_SEQ_BRANCH_ADDR FF ; Page 1
    // 0057:   decode_init pg2_JTB cv_MICRO_SEQ_BRANCH_ADDR FF ; Page 2
    // 0058:   decode_init pg3_JTB cv_MICRO_SEQ_BRANCH_ADDR FF ; Page 3
    // 0059:   
    // 0060:   ; Register A Decode
    // 0061:   ; A side of ALU and ALU write
    // 0062:   decode_init pg1_R1  cv_R1_SEL x ; Page 1 
    // 0063:   decode_init pg2_R1  cv_R1_SEL x ; Page 2 
    // 0064:   decode_init pg3_R1  cv_R1_SEL x ; Page 3 
    // 0065: 
    // 0066:   ; Register B Decode
    // 0067:   ; B side of ALU
    // 0068:   decode_init pg1_R2  cv_R2_SEL x ; Page 1 
    // 0069:   decode_init pg2_R2  cv_R2_SEL x ; Page 2 
    // 0070:   decode_init pg3_R2  cv_R2_SEL x ; Page 3 
    // 0071: 
    // 0072:   ; Address Register Decode
    // 0073:   decode_init pg1_AR  cv_AR_SEL x ; Page 1 
    // 0074:   decode_init pg2_AR  cv_AR_SEL x ; Page 2 
    // 0075:   decode_init pg3_AR  cv_AR_SEL x ; Page 3 
    // 0076: 
    // 0077: ; decode <tablename> <equ> <opcode0...opcodeN> ; Comment
    // 0078: ;
    // 0079: ; EXAMPLE:
    // 0080: ; decode pg1_JTA ABX $3A ; ABX(inh)
    // 0081: 
    // 0082: 
    // 0083: 
    // 0084:   ORG  $00
    // 0085: RESET:
    // 0086:   ; R1 is reset to PC
    // 0087:   ; R2 is reset to DMEM_RD
    // 0088: 
    // 0089:   SET_DATA_WIDTH  W_16
    // 0090: 
    // 0091:   STACK_PUSH      ZERO ; a cute way of creating EA=$FFFE
    // 0092:   DMEM_LOAD_W
    // 0093: 
    // 0094:   JUMP            JMP
    // 0095:   micro_op_end
    9'h000: begin
      CV_MICRO_SEQ_OP_O = 3'h1;  // OP_JUMP
      CV_MICRO_SEQ_BRANCH_ADDR_O = 8'h30;  // JMP
      CV_ADDR_ALU_REG_SEL_O = 4'hf;  // ZERO
      CV_DATA_WIDTH_SEL_O = 3'h3;  // W_16
      CV_DMEM_OP_O = 2'h2;  // DMEM_OP_RD
      CV_STACK_OP_O = 2'h2;  // STACK_OP_PUSH
    end


    // 0096: 
    // 0097: ; ////////////////////////////////////////////////////////////////////////////
    // 0098: ;                           LOAD ADDRESSING MODES
    // 0099: ; ////////////////////////////////////////////////////////////////////////////
    // 0100: ; //
    // 0101: LD_DIR_EXT:
    // 0102:   decode pg1_JTA LD_DIR_EXT $99 $B9 ; ADCA (dir ext)
    // 0103:   decode pg1_JTA LD_DIR_EXT $D9 $F9 ; ADCB (dir ext)
    // 0104:   ;                               
    // 0105:   decode pg1_JTA LD_DIR_EXT $9B $BB ; ADDA (dir ext)
    // 0106:   decode pg1_JTA LD_DIR_EXT $DB $FB ; ADDB (dir ext)
    // 0107:   decode pg1_JTA LD_DIR_EXT $D3 $F3 ; ADDD (dir ext)
    // 0108: ; //                              
    // 0109:   decode pg1_JTA LD_DIR_EXT $94 $B4 ; ANDA (dir ext)
    // 0110:   decode pg1_JTA LD_DIR_EXT $D4 $F4 ; ANDB (dir ext)
    // 0111: ; //                              
    // 0112:   decode pg1_JTA LD_DIR_EXT $08 $78 ; ASL LSL (dir ext)
    // 0113: ; //                              
    // 0114:   decode pg1_JTA LD_DIR_EXT $07 $77 ; ASR (dir ext)
    // 0115: ; //                              
    // 0116:   decode pg1_JTA LD_DIR_EXT $95 $B5 ; BITA (dir ext)
    // 0117:   decode pg1_JTA LD_DIR_EXT $D5 $F5 ; BITB (dir ext)
    // 0118: ; //                              
    // 0119:   decode pg1_JTA LD_DIR_EXT $91 $B1 ; CMPA (dir ext)
    // 0120:   decode pg1_JTA LD_DIR_EXT $D1 $F1 ; CMPB (dir ext)
    // 0121:   decode pg2_JTA LD_DIR_EXT $93 $B3 ; CMPD (dir ext)
    // 0122:   decode pg3_JTA LD_DIR_EXT $9C $BC ; CMPS (dir ext)
    // 0123:   decode pg3_JTA LD_DIR_EXT $93 $B3 ; CMPU (dir ext)
    // 0124:   decode pg1_JTA LD_DIR_EXT $9C $BC ; CMPX (dir ext)
    // 0125:   decode pg2_JTA LD_DIR_EXT $9C $BC ; CMPY (dir ext)
    // 0126: ; //                              
    // 0127:   decode pg1_JTA LD_DIR_EXT $03 $73 ; COM (dir ext)
    // 0128: ; //                              
    // 0129:   decode pg1_JTA LD_DIR_EXT $0A $7A ; DEC (dir ext)
    // 0130: ; //                              
    // 0131:   decode pg1_JTA LD_DIR_EXT $98 $B8 ; EORA (dir ext)
    // 0132:   decode pg1_JTA LD_DIR_EXT $D8 $F8 ; EORB (dir ext)
    // 0133: ; //                              
    // 0134:   decode pg1_JTA LD_DIR_EXT $0C $7C ; INC (dir ext)
    // 0135: ; //                              
    // 0136:   decode pg1_JTA LD_DIR_EXT $96 $B6 ; LDA (dir ext)
    // 0137:   decode pg1_JTA LD_DIR_EXT $D6 $F6 ; LDB (dir ext)
    // 0138:   decode pg1_JTA LD_DIR_EXT $DC $FC ; LDD (dir ext)
    // 0139:   decode pg2_JTA LD_DIR_EXT $DE $FE ; LDS (dir ext)
    // 0140:   decode pg1_JTA LD_DIR_EXT $DE $FE ; LDU (dir ext)
    // 0141:   decode pg1_JTA LD_DIR_EXT $9E $BE ; LDX (dir ext)
    // 0142:   decode pg2_JTA LD_DIR_EXT $9E $BE ; LDY (dir ext)
    // 0143: ; //                              
    // 0144:   decode pg1_JTA LD_DIR_EXT $04 $74 ; LSR (dir ext)
    // 0145: ; //                              
    // 0146:   decode pg1_JTA LD_DIR_EXT $00 $70 ; NEG (dir ext)
    // 0147: ; //                              
    // 0148:   decode pg1_JTA LD_DIR_EXT $9A $BA ; ORA (dir ext)
    // 0149:   decode pg1_JTA LD_DIR_EXT $DA $FA ; ORB (dir ext)
    // 0150: ; //                              
    // 0151:   decode pg1_JTA LD_DIR_EXT $09 $79 ; ROL (dir ext)
    // 0152:   decode pg1_JTA LD_DIR_EXT $06 $76 ; ROR (dir ext)
    // 0153: ; //                              
    // 0154:   decode pg1_JTA LD_DIR_EXT $92 $B2 ; SBCA (dir ext)
    // 0155:   decode pg1_JTA LD_DIR_EXT $D2 $F2 ; SBCB (dir ext)
    // 0156: ; //                              
    // 0157:   decode pg1_JTA LD_DIR_EXT $90 $B0 ; SUBA (dir ext)
    // 0158:   decode pg1_JTA LD_DIR_EXT $D0 $F0 ; SUBB (dir ext)
    // 0159:   decode pg1_JTA LD_DIR_EXT $93 $B3 ; SUBD (dir ext)
    // 0160: ; //                              
    // 0161:   decode pg1_JTA LD_DIR_EXT $0D $7D ; TST (dir ext)
    // 0162: 
    // 0163:   DATA_PASS_B     IDATA
    // 0164:   DATA_WRITE      EA
    // 0165: 
    // 0166:   SET_DATA_WIDTH  W_R1
    // 0167: 
    // 0168:   ADDR_PASS       IDATA
    // 0169:   DMEM_LOAD_W
    // 0170: 
    // 0171:   JUMP_TABLE_B
    // 0172:   micro_op_end
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


    // 0173: 
    // 0174: 
    // 0175: LD_INDEXED:
    // 0176:   decode pg1_JTA LD_INDEXED $A9 ; ADCA (idx)
    // 0177:   decode pg1_JTA LD_INDEXED $E9 ; ADCB (idx)
    // 0178: ; //                            
    // 0179:   decode pg1_JTA LD_INDEXED $AB ; ADDA (idx)
    // 0180:   decode pg1_JTA LD_INDEXED $EB ; ADDB (idx)
    // 0181:   decode pg1_JTA LD_INDEXED $E3 ; ADDD (idx)
    // 0182: ; //                            
    // 0183:   decode pg1_JTA LD_INDEXED $A4 ; ANDA (idx)
    // 0184:   decode pg1_JTA LD_INDEXED $E4 ; ANDB (idx)
    // 0185: ; //                            
    // 0186:   decode pg1_JTA LD_INDEXED $68 ; ASL LSL (idx)
    // 0187: ; //                            
    // 0188:   decode pg1_JTA LD_INDEXED $67 ; ASR (idx)
    // 0189: ; //                            
    // 0190:   decode pg1_JTA LD_INDEXED $A5 ; BITA (idx)
    // 0191:   decode pg1_JTA LD_INDEXED $E5 ; BITB (idx)
    // 0192: ; //                            
    // 0193:   decode pg1_JTA LD_INDEXED $A1 ; CMPA (idx)
    // 0194:   decode pg1_JTA LD_INDEXED $E1 ; CMPB (idx)
    // 0195:   decode pg2_JTA LD_INDEXED $A3 ; CMPD (idx)
    // 0196:   decode pg3_JTA LD_INDEXED $AC ; CMPS (idx)
    // 0197:   decode pg3_JTA LD_INDEXED $A3 ; CMPU (idx)
    // 0198:   decode pg1_JTA LD_INDEXED $AC ; CMPX (idx)
    // 0199:   decode pg2_JTA LD_INDEXED $AC ; CMPY (idx)
    // 0200: ; //                            
    // 0201:   decode pg1_JTA LD_INDEXED $63 ; COM (idx)
    // 0202: ; //                            
    // 0203:   decode pg1_JTA LD_INDEXED $6A ; DEC (idx)
    // 0204: ; //                            
    // 0205:   decode pg1_JTA LD_INDEXED $A8 ; EORA (idx)
    // 0206:   decode pg1_JTA LD_INDEXED $E8 ; EORB (idx)
    // 0207: ; //                            
    // 0208:   decode pg1_JTA LD_INDEXED $6C ; INC (idx)
    // 0209: ; //                            
    // 0210:   decode pg1_JTA LD_INDEXED $A6 ; LDA (idx)
    // 0211:   decode pg1_JTA LD_INDEXED $E6 ; LDB (idx)
    // 0212:   decode pg1_JTA LD_INDEXED $EC ; LDD (idx)
    // 0213:   decode pg2_JTA LD_INDEXED $EE ; LDS (idx)
    // 0214:   decode pg1_JTA LD_INDEXED $EE ; LDU (idx)
    // 0215:   decode pg1_JTA LD_INDEXED $AE ; LDX (idx)
    // 0216:   decode pg2_JTA LD_INDEXED $AE ; LDY (idx)
    // 0217: ; //                            
    // 0218:   decode pg1_JTA LD_INDEXED $64 ; LSR (idx)
    // 0219: ; //                            
    // 0220:   decode pg1_JTA LD_INDEXED $60 ; NEG (idx)
    // 0221: ; //                            
    // 0222:   decode pg1_JTA LD_INDEXED $AA ; ORA (idx)
    // 0223:   decode pg1_JTA LD_INDEXED $EA ; ORB (idx)
    // 0224: ; //                            
    // 0225:   decode pg1_JTA LD_INDEXED $69 ; ROL (idx)
    // 0226:   decode pg1_JTA LD_INDEXED $66 ; ROR (idx)
    // 0227: ; //                            
    // 0228:   decode pg1_JTA LD_INDEXED $A2 ; SBCA (idx)
    // 0229:   decode pg1_JTA LD_INDEXED $E2 ; SBCB (idx)
    // 0230: ; //                            
    // 0231:   decode pg1_JTA LD_INDEXED $A0 ; SUBA (idx)
    // 0232:   decode pg1_JTA LD_INDEXED $E0 ; SUBB (idx)
    // 0233:   decode pg1_JTA LD_INDEXED $A3 ; SUBD (idx)
    // 0234: ; //                            
    // 0235:   decode pg1_JTA LD_INDEXED $6D ; TST (idx)
    // 0236:   
    // 0237:   SET_DATA_WIDTH  W_R1_OR_IND
    // 0238: 
    // 0239:   ADDR_INX_OR_LOAD_IND
    // 0240:   DMEM_LOAD_W ; LOAD_IND can override
    // 0241: 
    // 0242:   IF              NOT_INDIRECT
    // 0243:   JUMP_TABLE_B
    // 0244:   micro_op_end
    9'h002: begin
      CV_MICRO_SEQ_OP_O = 3'h4;  // OP_JUMP_TABLE_B
      CV_ADDR_ALU_REG_SEL_O = 4'h0;  // INDEXED
      CV_DATA_WIDTH_SEL_O = 3'h1;  // W_R1_OR_IND
      CV_MICRO_SEQ_COND_SEL_O = 4'h0;  // NOT_INDIRECT
      CV_DMEM_OP_O = 2'h2;  // DMEM_OP_RD
    end


    // 0245: 
    // 0246: LD_INDIRECT:
    // 0247:   DATA_PASS_B     DMEM_RD
    // 0248:   DATA_WRITE      EA
    // 0249:   
    // 0250:   SET_DATA_WIDTH  W_R1
    // 0251: 
    // 0252:   ADDR_PASS       DMEM_RD
    // 0253:   DMEM_LOAD_W
    // 0254: 
    // 0255:   JUMP_TABLE_B
    // 0256:   micro_op_end
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


    // 0257: ; //
    // 0258: ; ////////////////////////////////////////////////////////////////////////////
    // 0259: 
    // 0260: 
    // 0261: ; ////////////////////////////////////////////////////////////////////////////
    // 0262: ;                           STORE ADDRESSING MODES
    // 0263: ; ////////////////////////////////////////////////////////////////////////////
    // 0264: ; //
    // 0265: ST_INDEXED:
    // 0266:   decode pg1_JTA ST_INDEXED $6F ; CLR(idx)
    // 0267: ; //                                
    // 0268:   decode pg1_JTA ST_INDEXED $6E ; JMP(idx)
    // 0269: ; //                                
    // 0270:   decode pg1_JTA ST_INDEXED $AD ; JSR (idx)
    // 0271: ; //                                
    // 0272:   decode pg1_JTA ST_INDEXED $32 ; LEAS(inh)
    // 0273:   decode pg1_JTA ST_INDEXED $33 ; LEAU(inh)
    // 0274:   decode pg1_JTA ST_INDEXED $30 ; LEAX(inh)
    // 0275:   decode pg1_JTA ST_INDEXED $31 ; LEAY(inh)
    // 0276: ; //                                
    // 0277:   decode pg1_JTA ST_INDEXED $A7 ; STA (idx)
    // 0278:   decode pg1_JTA ST_INDEXED $E7 ; STB (idx)
    // 0279:   decode pg1_JTA ST_INDEXED $ED ; STD (idx)
    // 0280:   decode pg2_JTA ST_INDEXED $EF ; STS (idx)
    // 0281:   decode pg1_JTA ST_INDEXED $EF ; STU (idx)
    // 0282:   decode pg1_JTA ST_INDEXED $AF ; STX (idx)
    // 0283:   decode pg2_JTA ST_INDEXED $AF ; STY (idx)
    // 0284:   
    // 0285:   SET_DATA_WIDTH  W_R1_OR_IND
    // 0286: 
    // 0287:   ADDR_INX_OR_LOAD_IND
    // 0288: 
    // 0289:   IF              NOT_INDIRECT
    // 0290:   JUMP_TABLE_B
    // 0291:   micro_op_end
    9'h004: begin
      CV_MICRO_SEQ_OP_O = 3'h4;  // OP_JUMP_TABLE_B
      CV_ADDR_ALU_REG_SEL_O = 4'h0;  // INDEXED
      CV_DATA_WIDTH_SEL_O = 3'h1;  // W_R1_OR_IND
      CV_MICRO_SEQ_COND_SEL_O = 4'h0;  // NOT_INDIRECT
    end


    // 0292: 
    // 0293: ST_INDIRECT:
    // 0294:   DATA_PASS_B     DMEM_RD
    // 0295:   DATA_WRITE      EA
    // 0296:   
    // 0297:   JUMP_TABLE_B
    // 0298:   micro_op_end
    9'h005: begin
      CV_MICRO_SEQ_OP_O = 3'h4;  // OP_JUMP_TABLE_B
      CV_DATA_ALU_A_SEL_O = 4'hf;  // ZERO
      CV_DATA_ALU_B_SEL_O = 3'h5;  // DMEM_RD
      CV_DATA_ALU_WR_SEL_O = 4'hc;  // EA
      CV_DATA_ALU_OP_O = 3'h0;  // A_PLUS_B
      CV_DATA_ALU_COND_SEL_O = 2'h0;  // ZERO_BIT
    end


    // 0299: 
    // 0300: ; //
    // 0301: ; ////////////////////////////////////////////////////////////////////////////
    // 0302: 
    // 0303: 
    // 0304: ; ////////////////////////////////////////////////////////////////////////////
    // 0305: ;                           INHERENT INSTRUCTIONS
    // 0306: ; ////////////////////////////////////////////////////////////////////////////
    // 0307: ; //
    // 0308: 
    // 0309: ; //////////////////////////////////////////// ABX
    // 0310: ; //
    // 0311: ABX:
    // 0312:   decode pg1_JTA ABX $3A ; ABX(inh)
    // 0313:   decode pg1_R1  X   $3A ; ABX(inh)
    // 0314:   decode pg1_R2  B   $3A ; ABX(inh)
    // 0315: 
    // 0316:   DATA_ADD        R1, R2
    // 0317:   DATA_WRITE      R1
    // 0318: 
    // 0319:   JUMP_TABLE_A_NEXT_PC
    // 0320:   micro_op_end
    9'h006: begin
      CV_MICRO_SEQ_OP_O = 3'h5;  // OP_JUMP_TABLE_A_NEXT_PC
      CV_DATA_ALU_A_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_B_SEL_O = 3'h0;  // R2
      CV_DATA_ALU_WR_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_OP_O = 3'h0;  // A_PLUS_B
      CV_DATA_ALU_COND_SEL_O = 2'h0;  // ZERO_BIT
    end


    // 0321: 
    // 0322: ; //////////////////////////////////////////// EXG
    // 0323: ; //
    // 0324: EXG:
    // 0325:   decode pg1_JTA EXG $1E ; EXG(inh)
    // 0326: ; R1 = postbyte[7:0] $1E ; EXG(inh)
    // 0327: ; R2 = postbyte[3:0] $1E ; EXG(inh)
    // 0328: 
    // 0329:   DATA_PASS_A     R1
    // 0330:   DATA_WRITE      EA
    // 0331:   micro_op_end
    9'h007: begin
      CV_DATA_ALU_A_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_B_SEL_O = 3'h7;  // ZERO
      CV_DATA_ALU_WR_SEL_O = 4'hc;  // EA
      CV_DATA_ALU_OP_O = 3'h0;  // A_PLUS_B
      CV_DATA_ALU_COND_SEL_O = 2'h0;  // ZERO_BIT
    end


    // 0332: 
    // 0333:   DATA_PASS_A     R2
    // 0334:   DATA_WRITE      R1
    // 0335:   
    // 0336:   CCR_OP_W        OP_XXXXXXXX ; Just in case CCR is destination
    // 0337:   micro_op_end
    9'h008: begin
      CV_DATA_ALU_A_SEL_O = 4'h4;  // R2
      CV_DATA_ALU_B_SEL_O = 3'h7;  // ZERO
      CV_DATA_ALU_WR_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_OP_O = 3'h0;  // A_PLUS_B
      CV_CCR_OP_O = 4'h9;  // OP_XXXXXXXX
      CV_DATA_ALU_COND_SEL_O = 2'h0;  // ZERO_BIT
    end


    // 0338: 
    // 0339:   DATA_PASS_A     EA
    // 0340:   DATA_WRITE      R2
    // 0341: 
    // 0342:   CCR_OP_W        OP_XXXXXXXX ; Just in case CCR is destination
    // 0343: 
    // 0344:   JUMP            GO_NEW_PC ; Just in case PC is destination
    // 0345:   micro_op_end
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


    // 0346: 
    // 0347: 
    // 0348: ; //////////////////////////////////////////// LEA S or U
    // 0349: ; //
    // 0350: LEA_SU:
    // 0351:   decode pg1_JTB LEA_SU $32 ; LEAS(inh)
    // 0352:   decode pg1_R1  S      $32 ; LEAS(inh)
    // 0353:                             
    // 0354:   decode pg1_JTB LEA_SU $33 ; LEAU(inh)
    // 0355:   decode pg1_R1  U      $33 ; LEAU(inh)
    // 0356: 
    // 0357:   DATA_PASS_B     EA
    // 0358:   DATA_WRITE      R1
    // 0359: 
    // 0360:   JUMP_TABLE_A_NEXT_PC
    // 0361:   micro_op_end
    9'h00a: begin
      CV_MICRO_SEQ_OP_O = 3'h5;  // OP_JUMP_TABLE_A_NEXT_PC
      CV_DATA_ALU_A_SEL_O = 4'hf;  // ZERO
      CV_DATA_ALU_B_SEL_O = 3'h4;  // EA
      CV_DATA_ALU_WR_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_OP_O = 3'h0;  // A_PLUS_B
      CV_DATA_ALU_COND_SEL_O = 2'h0;  // ZERO_BIT
    end


    // 0362: 
    // 0363: ; //////////////////////////////////////////// LEA X or Y
    // 0364: ; //
    // 0365: LEA_XY:
    // 0366:   decode pg1_JTB LEA_XY $30 ; LEAX(inh)
    // 0367:   decode pg1_R1  X      $30 ; LEAX(inh)
    // 0368:                             
    // 0369:   decode pg1_JTB LEA_XY $31 ; LEAY(inh)
    // 0370:   decode pg1_R1  Y      $31 ; LEAY(inh)
    // 0371: 
    // 0372:   DATA_PASS_B     EA
    // 0373:   DATA_WRITE      R1
    // 0374: 
    // 0375:   SET_DATA_WIDTH  W_R1
    // 0376: 
    // 0377:   CCR_OP_W        OP_oooooXoo 
    // 0378: 
    // 0379:   JUMP_TABLE_A_NEXT_PC
    // 0380:   micro_op_end
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


    // 0381: 
    // 0382: ; //////////////////////////////////////////// NOP
    // 0383: ; //
    // 0384: ; // Prebytes are sent here if the execute stage has nothing
    // 0385: ; // else better to do. However, this is unnecessary given
    // 0386: ; // prebyte processing logic is contained in the decode stage
    // 0387: ; // and prebytes are decoded independently without delay if
    // 0388: ; // the execute stage is busy. It's called pipelining ;-)
    // 0389: ; //
    // 0390: NOP:
    // 0391:   decode pg1_JTA NOP $12 ; NOP(inh)
    // 0392:   decode pg1_JTA NOP $11 ; page3 (prebyte)
    // 0393:   decode pg1_JTA NOP $10 ; page2 (prebyte)
    // 0394: 
    // 0395:   JUMP_TABLE_A_NEXT_PC
    // 0396:   micro_op_end
    9'h00c: begin
      CV_MICRO_SEQ_OP_O = 3'h5;  // OP_JUMP_TABLE_A_NEXT_PC
    end


    // 0397: 
    // 0398: ; //////////////////////////////////////////// EMUL EMULS IDIV EDIV EDIVS IDIVS FDIV
    // 0399: ; //
    // 0400: SAU16:
    // 0401:   decode pg1_JTA SAU16 $14 ; EMUL (inh)
    // 0402:   decode pg1_R2  Y     $14 ; EMUL (inh)
    // 0403:   decode pg1_R1  D     $14 ; EMUL (inh)
    // 0404: 
    // 0405:   decode pg1_JTA SAU16 $15 ; EMULS (inh)
    // 0406:   decode pg1_R2  Y     $15 ; EMULS (inh)
    // 0407:   decode pg1_R1  D     $15 ; EMULS (inh)
    // 0408: 
    // 0409:   decode pg1_JTA SAU16 $18 ; IDIV (inh)
    // 0410:   decode pg1_R2  D     $18 ; IDIV (inh)
    // 0411:   decode pg1_R1  X     $18 ; IDIV (inh)
    // 0412: 
    // 0413:   decode pg2_JTA SAU16 $18 ; IDIVS (inh)
    // 0414:   decode pg2_R2  D     $18 ; IDIVS (inh)
    // 0415:   decode pg2_R1  X     $18 ; IDIVS (inh)
    // 0416: 
    // 0417:   DATA_SAU_EN
    // 0418: 
    // 0419:   IF              SAU_NOT_DONE
    // 0420:   JUMP            SAU16
    // 0421:   micro_op_end
    9'h00d: begin
      CV_MICRO_SEQ_OP_O = 3'h1;  // OP_JUMP
      CV_MICRO_SEQ_BRANCH_ADDR_O = 8'hd;  // SAU16
      CV_DATA_ALU_SAU_EN_O = 1'h1;  // TRUE
      CV_MICRO_SEQ_COND_SEL_O = 4'h5;  // SAU_NOT_DONE
    end


    // 0422: 
    // 0423: SAU16_DONE:
    // 0424: 
    // 0425:   DATA_SAU_EN
    // 0426:   DATA_SAU_DONE
    // 0427:   DATA_WRITE      R2
    // 0428: 
    // 0429:   JUMP            SAU8_DONE
    // 0430:   micro_op_end
    9'h00e: begin
      CV_MICRO_SEQ_OP_O = 3'h1;  // OP_JUMP
      CV_MICRO_SEQ_BRANCH_ADDR_O = 8'h10;  // SAU8_DONE
      CV_DATA_ALU_WR_SEL_O = 4'h4;  // R2
      CV_DATA_ALU_OP_O = 3'h7;  // SAU
      CV_DATA_ALU_SAU_EN_O = 1'h1;  // TRUE
    end


    // 0431: 
    // 0432: ; //////////////////////////////////////////// DAA MUL
    // 0433: ; //
    // 0434: SAU8:
    // 0435:   decode pg1_JTA SAU8 $19 ; DAA (inh)
    // 0436:   decode pg1_R1  D    $19 ; DAA (inh)
    // 0437: 
    // 0438:   decode pg1_JTA SAU8 $3D ; MUL (inh)
    // 0439:   decode pg1_R1  D    $3D ; MUL (inh)
    // 0440: 
    // 0441:   DATA_SAU_EN
    // 0442: 
    // 0443:   IF              SAU_NOT_DONE
    // 0444:   JUMP            SAU8
    // 0445:   micro_op_end
    9'h00f: begin
      CV_MICRO_SEQ_OP_O = 3'h1;  // OP_JUMP
      CV_MICRO_SEQ_BRANCH_ADDR_O = 8'hf;  // SAU8
      CV_DATA_ALU_SAU_EN_O = 1'h1;  // TRUE
      CV_MICRO_SEQ_COND_SEL_O = 4'h5;  // SAU_NOT_DONE
    end


    // 0446: 
    // 0447: SAU8_DONE:
    // 0448: 
    // 0449:   DATA_SAU_EN
    // 0450:   DATA_SAU_DONE
    // 0451:   DATA_WRITE      R1
    // 0452: 
    // 0453:   CCR_OP_W        OP_ooooXXXX ; SAU masks correct bits
    // 0454: 
    // 0455:   JUMP_TABLE_A_NEXT_PC
    // 0456:   micro_op_end
    9'h010: begin
      CV_MICRO_SEQ_OP_O = 3'h5;  // OP_JUMP_TABLE_A_NEXT_PC
      CV_DATA_ALU_WR_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_OP_O = 3'h7;  // SAU
      CV_DATA_ALU_SAU_EN_O = 1'h1;  // TRUE
      CV_CCR_OP_O = 4'h2;  // OP_OOOOXXXX
    end


    // 0457: 
    // 0458: ; //////////////////////////////////////////// SEX (in 1 micro-cycle!)
    // 0459: ; //
    // 0460: SEX:
    // 0461:   decode pg1_JTA SEX  $1D ; SEX(inh)
    // 0462:   decode pg1_R1  D    $1D ; SEX(inh)
    // 0463:   decode pg1_R2  SEXB $1D ; SEX(inh)
    // 0464: 
    // 0465:   DATA_PASS_B     R2
    // 0466:   DATA_WRITE      R1
    // 0467:   
    // 0468:   SET_DATA_WIDTH  W_R1
    // 0469: 
    // 0470:   CCR_OP_W        OP_ooooXXXo ; INFO Prog Man says V unaffected, datasheet says v=0
    // 0471: 
    // 0472:   JUMP_TABLE_A_NEXT_PC
    // 0473:   micro_op_end
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


    // 0474: 
    // 0475: ; //////////////////////////////////////////// CPY
    // 0476: ; //
    // 0477: CPY:
    // 0478:   decode pg2_JTA CPY $1F ; CPY (inh)
    // 0479: ; R1 = postbyte[7:0] $1F ; CPY (inh)
    // 0480: ; R2 = postbyte[3:0] $1F ; CPY (inh)
    // 0481: 
    // 0482: ; TODO INFO: could combine this state with SAU states
    // 0483: 
    // 0484:   DATA_SAU_EN ; initalize byte counter from D register
    // 0485:   micro_op_end
    9'h012: begin
      CV_DATA_ALU_SAU_EN_O = 1'h1;  // TRUE
    end


    // 0486:   
    // 0487: CPY_LOOP:
    // 0488:   DATA_SAU_EN ; enable byte counter
    // 0489: 
    // 0490:   SET_DATA_WIDTH  W_8
    // 0491: 
    // 0492:   ADDR_PASS       RR1_WR2
    // 0493:   DMEM_LOAD_W
    // 0494: 
    // 0495:   IF              SAU_DONE
    // 0496:   JUMP            GO_NEW_PC
    // 0497:   micro_op_end
    9'h013: begin
      CV_MICRO_SEQ_OP_O = 3'h1;  // OP_JUMP
      CV_MICRO_SEQ_BRANCH_ADDR_O = 8'h2f;  // GO_NEW_PC
      CV_ADDR_ALU_REG_SEL_O = 4'h4;  // RR1_WR2
      CV_DATA_WIDTH_SEL_O = 3'h4;  // W_8
      CV_DATA_ALU_SAU_EN_O = 1'h1;  // TRUE
      CV_MICRO_SEQ_COND_SEL_O = 4'h4;  // SAU_DONE
      CV_DMEM_OP_O = 2'h2;  // DMEM_OP_RD
    end


    // 0498:   
    // 0499:   DATA_SAU_EN ; enable byte counter
    // 0500: 
    // 0501:   SET_DATA_WIDTH  W_8
    // 0502: 
    // 0503:   DATA_PASS_B     DMEM_RD
    // 0504: 
    // 0505:   ADDR_PASS       RR1_WR2
    // 0506:   DMEM_STORE_W
    // 0507: 
    // 0508:   JUMP            CPY_LOOP
    // 0509:   micro_op_end
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


    // 0510: 
    // 0511: 
    // 0512: 
    // 0513: ; //////////////////////////////////////////// TFR
    // 0514: ; //
    // 0515: TFR:
    // 0516:   decode pg1_JTA TFR $1F ; TFR(inh)
    // 0517: ; R1 = postbyte[7:0] $1F ; TFR(inh)
    // 0518: ; R2 = postbyte[3:0] $1F ; TFR(inh)
    // 0519: 
    // 0520:   DATA_PASS_A     R1
    // 0521:   DATA_WRITE      R2
    // 0522: 
    // 0523:   CCR_OP_W        OP_XXXXXXXX ; Just in case CCR is destination
    // 0524: 
    // 0525:   JUMP            GO_NEW_PC ; Just in case PC is destination
    // 0526:   micro_op_end
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


    // 0527: 
    // 0528: ; //
    // 0529: ; ////////////////////////////////////////////////////////////////////////////
    // 0530: 
    // 0531: 
    // 0532: ; ////////////////////////////////////////////////////////////////////////////
    // 0533: ;                        LOAD TYPE INSTRUCTIONS
    // 0534: ; ////////////////////////////////////////////////////////////////////////////
    // 0535: 
    // 0536: ; //////////////////////////////////////////// ADC
    // 0537: ; //
    // 0538: ADC:
    // 0539:   decode pg1_JTA ADC     $89         ; ADCA (imm)
    // 0540:   decode pg1_R1  A       $89         ; ADCA (imm)
    // 0541:   decode pg1_R2  IDATA   $89         ; ADCA (imm)
    // 0542:                                                    
    // 0543:   decode pg1_JTA ADC     $C9         ; ADCB (imm)
    // 0544:   decode pg1_R1  B       $C9         ; ADCB (imm)
    // 0545:   decode pg1_R2  IDATA   $C9         ; ADCB (imm)
    // 0546:                                          
    // 0547:   decode pg1_JTB ADC     $99 $A9 $B9 ; ADCA (dir idx ext)
    // 0548:   decode pg1_R1  A       $99 $A9 $B9 ; ADCA (dir idx ext)
    // 0549:   decode pg1_R2  DMEM_RD $99 $A9 $B9 ; ADCA (dir idx ext)
    // 0550:                                          
    // 0551:   decode pg1_JTB ADC     $D9 $E9 $F9 ; ADCB (dir idx ext)
    // 0552:   decode pg1_R1  B       $D9 $E9 $F9 ; ADCB (dir idx ext)
    // 0553:   decode pg1_R2  DMEM_RD $D9 $E9 $F9 ; ADCB (dir idx ext)
    // 0554: 
    // 0555:   DATA_ADDC       R1, R2
    // 0556:   DATA_WRITE      R1
    // 0557: 
    // 0558:   SET_DATA_WIDTH  W_R1
    // 0559: 
    // 0560:   CCR_OP_W        OP_ooXoXXXX ; H is masked for 16bit
    // 0561: 
    // 0562:   JUMP_TABLE_A_NEXT_PC
    // 0563:   micro_op_end
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


    // 0564: 
    // 0565: ; //////////////////////////////////////////// ADD
    // 0566: ; //
    // 0567: ADD:
    // 0568:   decode pg1_JTA ADD     $8B         ; ADDA (imm)
    // 0569:   decode pg1_R1  A       $8B         ; ADDA (imm)
    // 0570:   decode pg1_R2  IDATA   $8B         ; ADDA (imm)
    // 0571:                                                    
    // 0572:   decode pg1_JTA ADD     $CB         ; ADDB (imm)
    // 0573:   decode pg1_R1  B       $CB         ; ADDB (imm)
    // 0574:   decode pg1_R2  IDATA   $CB         ; ADDB (imm)
    // 0575:                                                    
    // 0576:   decode pg1_JTA ADD     $C3         ; ADDD (imm)
    // 0577:   decode pg1_R1  D       $C3         ; ADDD (imm)
    // 0578:   decode pg1_R2  IDATA   $C3         ; ADDD (imm)
    // 0579:                              
    // 0580:   decode pg1_JTB ADD     $9B $AB $BB ; ADDA (dir idx ext)
    // 0581:   decode pg1_R1  A       $9B $AB $BB ; ADDA (dir idx ext)
    // 0582:   decode pg1_R2  DMEM_RD $9B $AB $BB ; ADDA (dir idx ext)
    // 0583:                              
    // 0584:   decode pg1_JTB ADD     $DB $EB $FB ; ADDB (dir idx ext)
    // 0585:   decode pg1_R1  B       $DB $EB $FB ; ADDB (dir idx ext)
    // 0586:   decode pg1_R2  DMEM_RD $DB $EB $FB ; ADDB (dir idx ext)
    // 0587:                              
    // 0588:   decode pg1_JTB ADD     $D3 $E3 $F3 ; ADDD (dir idx ext)
    // 0589:   decode pg1_R1  D       $D3 $E3 $F3 ; ADDD (dir idx ext)
    // 0590:   decode pg1_R2  DMEM_RD $D3 $E3 $F3 ; ADDD (dir idx ext)
    // 0591: 
    // 0592:   DATA_ADD        R1, R2
    // 0593:   DATA_WRITE      R1
    // 0594: 
    // 0595:   SET_DATA_WIDTH  W_R1
    // 0596: 
    // 0597:   CCR_OP_W        OP_ooXoXXXX ; H is masked for 16bit
    // 0598: 
    // 0599:   JUMP_TABLE_A_NEXT_PC
    // 0600:   micro_op_end
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


    // 0601: 
    // 0602: 
    // 0603: ; //////////////////////////////////////////// AND
    // 0604: ; //
    // 0605: AND:
    // 0606:   decode pg1_JTA AND     $84         ; ANDA (imm)
    // 0607:   decode pg1_R1  A       $84         ; ANDA (imm)
    // 0608:   decode pg1_R2  IDATA   $84         ; ANDA (imm)
    // 0609:                                                    
    // 0610:   decode pg1_JTA AND     $C4         ; ANDB (imm)
    // 0611:   decode pg1_R1  B       $C4         ; ANDB (imm)
    // 0612:   decode pg1_R2  IDATA   $C4         ; ANDB (imm)
    // 0613:                                      
    // 0614:   decode pg1_JTB AND     $94 $A4 $B4 ; ANDA (dir idx ext)
    // 0615:   decode pg1_R1  A       $94 $A4 $B4 ; ANDA (dir idx ext)
    // 0616:   decode pg1_R2  DMEM_RD $94 $A4 $B4 ; ANDA (dir idx ext)
    // 0617:                                      
    // 0618:   decode pg1_JTB AND     $D4 $E4 $F4 ; ANDB (dir idx ext)
    // 0619:   decode pg1_R1  B       $D4 $E4 $F4 ; ANDB (dir idx ext)
    // 0620:   decode pg1_R2  DMEM_RD $D4 $E4 $F4 ; ANDB (dir idx ext)
    // 0621: 
    // 0622:   DATA_AND        R1, R2
    // 0623:   DATA_WRITE      R1
    // 0624: 
    // 0625:   SET_DATA_WIDTH  W_R1
    // 0626: 
    // 0627:   CCR_OP_W        OP_ooooXXXo 
    // 0628: 
    // 0629:   JUMP_TABLE_A_NEXT_PC
    // 0630:   micro_op_end
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


    // 0631: 
    // 0632: ANDCC:
    // 0633:   decode pg1_JTA ANDCC $1C ; ANDCC (imm)
    // 0634:   decode pg1_R1  CCR   $1C ; ANDCC (imm)
    // 0635:   decode pg1_R2  IDATA $1C ; ANDCC (imm)
    // 0636: 
    // 0637:   DATA_AND        R1, R2
    // 0638:   DATA_WRITE      R1
    // 0639: 
    // 0640:   SET_DATA_WIDTH  W_R1
    // 0641: 
    // 0642:   CCR_OP_W        OP_XXXXXXXX 
    // 0643: 
    // 0644:   JUMP_TABLE_A_NEXT_PC
    // 0645:   micro_op_end
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


    // 0646: 
    // 0647: ; //////////////////////////////////////////// BIT
    // 0648: ; //
    // 0649: BIT:
    // 0650:   decode pg1_JTA BIT     $85         ; BITA (imm)
    // 0651:   decode pg1_R1  A       $85         ; BITA (imm)
    // 0652:   decode pg1_R2  IDATA   $85         ; BITA (imm)
    // 0653:                                                 
    // 0654:   decode pg1_JTA BIT     $C5         ; BITB (imm)
    // 0655:   decode pg1_R1  B       $C5         ; BITB (imm)
    // 0656:   decode pg1_R2  IDATA   $C5         ; BITB (imm)
    // 0657:                              
    // 0658:   decode pg1_JTB BIT     $95 $A5 $B5 ; BITA (dir idx ext)
    // 0659:   decode pg1_R1  A       $95 $A5 $B5 ; BITA (dir idx ext)
    // 0660:   decode pg1_R2  DMEM_RD $95 $A5 $B5 ; BITA (dir idx ext)
    // 0661:                              
    // 0662:   decode pg1_JTB BIT     $D5 $E5 $F5 ; BITB (dir idx ext)
    // 0663:   decode pg1_R1  B       $D5 $E5 $F5 ; BITB (dir idx ext)
    // 0664:   decode pg1_R2  DMEM_RD $D5 $E5 $F5 ; BITB (dir idx ext)
    // 0665: 
    // 0666:   DATA_AND        R1, R2
    // 0667: 
    // 0668:   SET_DATA_WIDTH  W_R1
    // 0669: 
    // 0670:   CCR_OP_W        OP_ooooXXXo 
    // 0671: 
    // 0672:   JUMP_TABLE_A_NEXT_PC
    // 0673:   micro_op_end
    9'h01a: begin
      CV_MICRO_SEQ_OP_O = 3'h5;  // OP_JUMP_TABLE_A_NEXT_PC
      CV_DATA_ALU_A_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_B_SEL_O = 3'h0;  // R2
      CV_DATA_ALU_OP_O = 3'h4;  // A_AND_B
      CV_DATA_WIDTH_SEL_O = 3'h0;  // W_R1
      CV_CCR_OP_O = 4'h4;  // OP_OOOOXXXO
      CV_DATA_ALU_COND_SEL_O = 2'h0;  // ZERO_BIT
    end


    // 0674: 
    // 0675: ; //////////////////////////////////////////// CMP
    // 0676: ; //
    // 0677: CMP:
    // 0678:   decode pg1_JTA CMP     $81         ; CMPA (imm)
    // 0679:   decode pg1_R1  A       $81         ; CMPA (imm)
    // 0680:   decode pg1_R2  IDATA   $81         ; CMPA (imm)
    // 0681:                                                
    // 0682:   decode pg1_JTA CMP     $C1         ; CMPB (imm)
    // 0683:   decode pg1_R1  B       $C1         ; CMPB (imm)
    // 0684:   decode pg1_R2  IDATA   $C1         ; CMPB (imm)
    // 0685:                                                
    // 0686:   decode pg2_JTA CMP     $83         ; CMPD (imm)
    // 0687:   decode pg2_R1  D       $83         ; CMPD (imm)
    // 0688:   decode pg2_R2  IDATA   $83         ; CMPD (imm)
    // 0689:                                                
    // 0690:   decode pg3_JTA CMP     $8C         ; CMPS (imm)
    // 0691:   decode pg3_R1  S       $8C         ; CMPS (imm)
    // 0692:   decode pg3_R2  IDATA   $8C         ; CMPS (imm)
    // 0693:                                                
    // 0694:   decode pg3_JTA CMP     $83         ; CMPU (imm)
    // 0695:   decode pg3_R1  U       $83         ; CMPU (imm)
    // 0696:   decode pg3_R2  IDATA   $83         ; CMPU (imm)
    // 0697:                                                
    // 0698:   decode pg1_JTA CMP     $8C         ; CMPX (imm)
    // 0699:   decode pg1_R1  X       $8C         ; CMPX (imm)
    // 0700:   decode pg1_R2  IDATA   $8C         ; CMPX (imm)
    // 0701:                                                
    // 0702:   decode pg2_JTA CMP     $8C         ; CMPY (imm)
    // 0703:   decode pg2_R1  Y       $8C         ; CMPY (imm)
    // 0704:   decode pg2_R2  IDATA   $8C         ; CMPY (imm)
    // 0705:                              
    // 0706:   decode pg1_JTB CMP     $91 $A1 $B1 ; CMPA (dir idx ext)
    // 0707:   decode pg1_R1  A       $91 $A1 $B1 ; CMPA (dir idx ext)
    // 0708:   decode pg1_R2  DMEM_RD $91 $A1 $B1 ; CMPA (dir idx ext)
    // 0709:                              
    // 0710:   decode pg1_JTB CMP     $D1 $E1 $F1 ; CMPB (dir idx ext)
    // 0711:   decode pg1_R1  B       $D1 $E1 $F1 ; CMPB (dir idx ext)
    // 0712:   decode pg1_R2  DMEM_RD $D1 $E1 $F1 ; CMPB (dir idx ext)
    // 0713:                              
    // 0714:   decode pg2_JTB CMP     $93 $A3 $B3 ; CMPD (dir idx ext)
    // 0715:   decode pg2_R1  D       $93 $A3 $B3 ; CMPD (dir idx ext)
    // 0716:   decode pg2_R2  DMEM_RD $93 $A3 $B3 ; CMPD (dir idx ext)
    // 0717:                              
    // 0718:   decode pg3_JTB CMP     $9C $AC $BC ; CMPS (dir idx ext)
    // 0719:   decode pg3_R1  S       $9C $AC $BC ; CMPS (dir idx ext)
    // 0720:   decode pg3_R2  DMEM_RD $9C $AC $BC ; CMPS (dir idx ext)
    // 0721:                              
    // 0722:   decode pg3_JTB CMP     $93 $A3 $B3 ; CMPU (dir idx ext)
    // 0723:   decode pg3_R1  U       $93 $A3 $B3 ; CMPU (dir idx ext)
    // 0724:   decode pg3_R2  DMEM_RD $93 $A3 $B3 ; CMPU (dir idx ext)
    // 0725:                              
    // 0726:   decode pg1_JTB CMP     $9C $AC $BC ; CMPX (dir idx ext)
    // 0727:   decode pg1_R1  X       $9C $AC $BC ; CMPX (dir idx ext)
    // 0728:   decode pg1_R2  DMEM_RD $9C $AC $BC ; CMPX (dir idx ext)
    // 0729:                              
    // 0730:   decode pg2_JTB CMP     $9C $AC $BC ; CMPY (dir idx ext)
    // 0731:   decode pg2_R1  Y       $9C $AC $BC ; CMPY (dir idx ext)
    // 0732:   decode pg2_R2  DMEM_RD $9C $AC $BC ; CMPY (dir idx ext)
    // 0733: 
    // 0734:   DATA_SUB        R1, R2
    // 0735: 
    // 0736:   SET_DATA_WIDTH  W_R1
    // 0737: 
    // 0738:   CCR_OP_W        OP_ooooXXXX ; INFO: Spec H Undefined, Turbo9 H not affected
    // 0739: 
    // 0740:   JUMP_TABLE_A_NEXT_PC
    // 0741:   micro_op_end
    9'h01b: begin
      CV_MICRO_SEQ_OP_O = 3'h5;  // OP_JUMP_TABLE_A_NEXT_PC
      CV_DATA_ALU_A_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_B_SEL_O = 3'h0;  // R2
      CV_DATA_ALU_OP_O = 3'h1;  // A_PLUS_NOT_B
      CV_DATA_WIDTH_SEL_O = 3'h0;  // W_R1
      CV_CCR_OP_O = 4'h2;  // OP_OOOOXXXX
      CV_DATA_ALU_COND_SEL_O = 2'h0;  // ZERO_BIT
    end


    // 0742: 
    // 0743: ; //////////////////////////////////////////// EOR
    // 0744: ; //
    // 0745: EOR:
    // 0746:   decode pg1_JTA EOR     $88         ; EORA (imm)
    // 0747:   decode pg1_R1  A       $88         ; EORA (imm)
    // 0748:   decode pg1_R2  IDATA   $88         ; EORA (imm)
    // 0749:                                                 
    // 0750:   decode pg1_JTA EOR     $C8         ; EORB (imm)
    // 0751:   decode pg1_R1  B       $C8         ; EORB (imm)
    // 0752:   decode pg1_R2  IDATA   $C8         ; EORB (imm)
    // 0753:                              
    // 0754:   decode pg1_JTB EOR     $98 $A8 $B8 ; EORA (dir idx ext)
    // 0755:   decode pg1_R1  A       $98 $A8 $B8 ; EORA (dir idx ext)
    // 0756:   decode pg1_R2  DMEM_RD $98 $A8 $B8 ; EORA (dir idx ext)
    // 0757:                              
    // 0758:   decode pg1_JTB EOR     $D8 $E8 $F8 ; EORB (dir idx ext)
    // 0759:   decode pg1_R1  B       $D8 $E8 $F8 ; EORB (dir idx ext)
    // 0760:   decode pg1_R2  DMEM_RD $D8 $E8 $F8 ; EORB (dir idx ext)
    // 0761: 
    // 0762:   DATA_XOR        R1, R2
    // 0763:   DATA_WRITE      R1
    // 0764: 
    // 0765:   SET_DATA_WIDTH  W_R1
    // 0766: 
    // 0767:   CCR_OP_W        OP_ooooXXXo 
    // 0768: 
    // 0769:   JUMP_TABLE_A_NEXT_PC
    // 0770:   micro_op_end
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


    // 0771: 
    // 0772: ; //////////////////////////////////////////// LD
    // 0773: ; //
    // 0774: LD:
    // 0775:   decode pg1_JTA LD      $86         ; LDA (imm)
    // 0776:   decode pg1_R1  A       $86         ; LDA (imm)
    // 0777:   decode pg1_R2  IDATA   $86         ; LDA (imm)
    // 0778:                                                 
    // 0779:   decode pg1_JTA LD      $C6         ; LDB (imm)
    // 0780:   decode pg1_R1  B       $C6         ; LDB (imm)
    // 0781:   decode pg1_R2  IDATA   $C6         ; LDB (imm)
    // 0782:                                                 
    // 0783:   decode pg1_JTA LD      $CC         ; LDD (imm)
    // 0784:   decode pg1_R1  D       $CC         ; LDD (imm)
    // 0785:   decode pg1_R2  IDATA   $CC         ; LDD (imm)
    // 0786:                                                 
    // 0787:   decode pg2_JTA LD      $CE         ; LDS (imm)
    // 0788:   decode pg2_R1  S       $CE         ; LDS (imm)
    // 0789:   decode pg2_R2  IDATA   $CE         ; LDS (imm)
    // 0790:                                                 
    // 0791:   decode pg1_JTA LD      $CE         ; LDU (imm)
    // 0792:   decode pg1_R1  U       $CE         ; LDU (imm)
    // 0793:   decode pg1_R2  IDATA   $CE         ; LDU (imm)
    // 0794:                                                 
    // 0795:   decode pg1_JTA LD      $8E         ; LDX (imm)
    // 0796:   decode pg1_R1  X       $8E         ; LDX (imm)
    // 0797:   decode pg1_R2  IDATA   $8E         ; LDX (imm)
    // 0798:                                                 
    // 0799:   decode pg2_JTA LD      $8E         ; LDY (imm)
    // 0800:   decode pg2_R1  Y       $8E         ; LDY (imm)
    // 0801:   decode pg2_R2  IDATA   $8E         ; LDY (imm)
    // 0802:                              
    // 0803:   decode pg1_JTB LD      $96 $A6 $B6 ; LDA (dir idx ext)
    // 0804:   decode pg1_R1  A       $96 $A6 $B6 ; LDA (dir idx ext)
    // 0805:   decode pg1_R2  DMEM_RD $96 $A6 $B6 ; LDA (dir idx ext)
    // 0806:                              
    // 0807:   decode pg1_JTB LD      $D6 $E6 $F6 ; LDB (dir idx ext)
    // 0808:   decode pg1_R1  B       $D6 $E6 $F6 ; LDB (dir idx ext)
    // 0809:   decode pg1_R2  DMEM_RD $D6 $E6 $F6 ; LDB (dir idx ext)
    // 0810:                              
    // 0811:   decode pg1_JTB LD      $DC $EC $FC ; LDD (dir idx ext)
    // 0812:   decode pg1_R1  D       $DC $EC $FC ; LDD (dir idx ext)
    // 0813:   decode pg1_R2  DMEM_RD $DC $EC $FC ; LDD (dir idx ext)
    // 0814:                              
    // 0815:   decode pg2_JTB LD      $DE $EE $FE ; LDS (dir idx ext)
    // 0816:   decode pg2_R1  S       $DE $EE $FE ; LDS (dir idx ext)
    // 0817:   decode pg2_R2  DMEM_RD $DE $EE $FE ; LDS (dir idx ext)
    // 0818:                              
    // 0819:   decode pg1_JTB LD      $DE $EE $FE ; LDU (dir idx ext)
    // 0820:   decode pg1_R1  U       $DE $EE $FE ; LDU (dir idx ext)
    // 0821:   decode pg1_R2  DMEM_RD $DE $EE $FE ; LDU (dir idx ext)
    // 0822:                              
    // 0823:   decode pg1_JTB LD      $9E $AE $BE ; LDX (dir idx ext)
    // 0824:   decode pg1_R1  X       $9E $AE $BE ; LDX (dir idx ext)
    // 0825:   decode pg1_R2  DMEM_RD $9E $AE $BE ; LDX (dir idx ext)
    // 0826:                              
    // 0827:   decode pg2_JTB LD      $9E $AE $BE ; LDY (dir idx ext)
    // 0828:   decode pg2_R1  Y       $9E $AE $BE ; LDY (dir idx ext)
    // 0829:   decode pg2_R2  DMEM_RD $9E $AE $BE ; LDY (dir idx ext)
    // 0830: 
    // 0831:   DATA_PASS_B     R2
    // 0832:   DATA_WRITE      R1
    // 0833: 
    // 0834:   SET_DATA_WIDTH  W_R1
    // 0835: 
    // 0836:   CCR_OP_W        OP_ooooXXXo
    // 0837: 
    // 0838:   JUMP_TABLE_A_NEXT_PC
    // 0839:   micro_op_end
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


    // 0840: 
    // 0841: ; //////////////////////////////////////////// OR
    // 0842: ; //
    // 0843: OR:
    // 0844:   decode pg1_JTA OR      $8A         ; ORA (imm)
    // 0845:   decode pg1_R1  A       $8A         ; ORA (imm)
    // 0846:   decode pg1_R2  IDATA   $8A         ; ORA (imm)
    // 0847:                                                 
    // 0848:   decode pg1_JTA OR      $CA         ; ORB (imm)
    // 0849:   decode pg1_R1  B       $CA         ; ORB (imm)
    // 0850:   decode pg1_R2  IDATA   $CA         ; ORB (imm)
    // 0851:                              
    // 0852:   decode pg1_JTB OR      $9A $AA $BA ; ORA (dir idx ext)
    // 0853:   decode pg1_R1  A       $9A $AA $BA ; ORA (dir idx ext)
    // 0854:   decode pg1_R2  DMEM_RD $9A $AA $BA ; ORA (dir idx ext)
    // 0855:                              
    // 0856:   decode pg1_JTB OR      $DA $EA $FA ; ORB (dir idx ext)
    // 0857:   decode pg1_R1  B       $DA $EA $FA ; ORB (dir idx ext)
    // 0858:   decode pg1_R2  DMEM_RD $DA $EA $FA ; ORB (dir idx ext)
    // 0859: 
    // 0860:   DATA_OR         R1, R2
    // 0861:   DATA_WRITE      R1
    // 0862: 
    // 0863:   SET_DATA_WIDTH  W_R1
    // 0864: 
    // 0865:   CCR_OP_W        OP_ooooXXXo 
    // 0866: 
    // 0867:   JUMP_TABLE_A_NEXT_PC
    // 0868:   micro_op_end
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


    // 0869: 
    // 0870: ORCC:
    // 0871:   decode pg1_JTA ORCC  $1A ; ORCC (imm)
    // 0872:   decode pg1_R1  CCR   $1A ; ORCC (imm)
    // 0873:   decode pg1_R2  IDATA $1A ; ORCC (imm)
    // 0874: 
    // 0875:   DATA_OR         R1, R2   
    // 0876:   DATA_WRITE      R1
    // 0877: 
    // 0878:   SET_DATA_WIDTH  W_R1
    // 0879: 
    // 0880:   CCR_OP_W        OP_XXXXXXXX 
    // 0881: 
    // 0882:   JUMP_TABLE_A_NEXT_PC
    // 0883:   micro_op_end
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


    // 0884: 
    // 0885: ; //////////////////////////////////////////// SBC
    // 0886: ; //
    // 0887: SBC:
    // 0888:   decode pg1_JTA SBC     $82         ; SBCA (imm)
    // 0889:   decode pg1_R1  A       $82         ; SBCA (imm)
    // 0890:   decode pg1_R2  IDATA   $82         ; SBCA (imm)
    // 0891:                                                 
    // 0892:   decode pg1_JTA SBC     $C2         ; SBCB (imm)
    // 0893:   decode pg1_R1  B       $C2         ; SBCB (imm)
    // 0894:   decode pg1_R2  IDATA   $C2         ; SBCB (imm)
    // 0895:                              
    // 0896:   decode pg1_JTB SBC     $92 $A2 $B2 ; SBCA (dir idx ext)
    // 0897:   decode pg1_R1  A       $92 $A2 $B2 ; SBCA (dir idx ext)
    // 0898:   decode pg1_R2  DMEM_RD $92 $A2 $B2 ; SBCA (dir idx ext)
    // 0899:                                                      
    // 0900:   decode pg1_JTB SBC     $D2 $E2 $F2 ; SBCB (dir idx ext)
    // 0901:   decode pg1_R1  B       $D2 $E2 $F2 ; SBCB (dir idx ext)
    // 0902:   decode pg1_R2  DMEM_RD $D2 $E2 $F2 ; SBCB (dir idx ext)
    // 0903: 
    // 0904:   DATA_SUBC       R1, R2
    // 0905:   DATA_WRITE      R1
    // 0906: 
    // 0907:   SET_DATA_WIDTH  W_R1
    // 0908: 
    // 0909:   CCR_OP_W        OP_ooooXXXX ; INFO: Spec H Undefined, Turbo9 H not affected
    // 0910: 
    // 0911:   JUMP_TABLE_A_NEXT_PC
    // 0912:   micro_op_end
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


    // 0913: 
    // 0914: ; //////////////////////////////////////////// SUB
    // 0915: ; //
    // 0916: SUB:
    // 0917:   decode pg1_JTA SUB     $80         ; SUBA (imm)
    // 0918:   decode pg1_R1  A       $80         ; SUBA (imm)
    // 0919:   decode pg1_R2  IDATA   $80         ; SUBA (imm)
    // 0920:                                                 
    // 0921:   decode pg1_JTA SUB     $C0         ; SUBB (imm)
    // 0922:   decode pg1_R1  B       $C0         ; SUBB (imm)
    // 0923:   decode pg1_R2  IDATA   $C0         ; SUBB (imm)
    // 0924:                                                 
    // 0925:   decode pg1_JTA SUB     $83         ; SUBD (imm)
    // 0926:   decode pg1_R1  D       $83         ; SUBD (imm)
    // 0927:   decode pg1_R2  IDATA   $83         ; SUBD (imm)
    // 0928:                              
    // 0929:   decode pg1_JTB SUB     $90 $A0 $B0 ; SUBA (dir idx ext)
    // 0930:   decode pg1_R1  A       $90 $A0 $B0 ; SUBA (dir idx ext)
    // 0931:   decode pg1_R2  DMEM_RD $90 $A0 $B0 ; SUBA (dir idx ext)
    // 0932:                                                       
    // 0933:   decode pg1_JTB SUB     $D0 $E0 $F0 ; SUBB (dir idx ext)
    // 0934:   decode pg1_R1  B       $D0 $E0 $F0 ; SUBB (dir idx ext)
    // 0935:   decode pg1_R2  DMEM_RD $D0 $E0 $F0 ; SUBB (dir idx ext)
    // 0936:                                                       
    // 0937:   decode pg1_JTB SUB     $93 $A3 $B3 ; SUBD (dir idx ext)
    // 0938:   decode pg1_R1  D       $93 $A3 $B3 ; SUBD (dir idx ext)
    // 0939:   decode pg1_R2  DMEM_RD $93 $A3 $B3 ; SUBD (dir idx ext)
    // 0940: 
    // 0941:   DATA_SUB        R1, R2
    // 0942:   DATA_WRITE      R1
    // 0943: 
    // 0944:   SET_DATA_WIDTH  W_R1
    // 0945: 
    // 0946:   CCR_OP_W        OP_ooooXXXX ; INFO: Spec H Undefined, Turbo9 H not affected (8-bit)
    // 0947: 
    // 0948:   JUMP_TABLE_A_NEXT_PC
    // 0949:   micro_op_end
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


    // 0950: 
    // 0951: 
    // 0952: ; //
    // 0953: ; ////////////////////////////////////////////////////////////////////////////
    // 0954: 
    // 0955: 
    // 0956: ; ////////////////////////////////////////////////////////////////////////////
    // 0957: ;                        STORE INSTRUCTIONS
    // 0958: ; ////////////////////////////////////////////////////////////////////////////
    // 0959: ; //
    // 0960: 
    // 0961: ; //////////////////////////////////////////// ST
    // 0962: ; //
    // 0963: ST:
    // 0964:   decode pg1_JTA ST    $97 $B7 ; STA (dir ext)
    // 0965:   decode pg1_R1  A     $97 $B7 ; STA (dir ext)
    // 0966:   decode pg1_AR  IDATA $97 $B7 ; STA (dir ext)
    // 0967:                            
    // 0968:   decode pg1_JTA ST    $D7 $F7 ; STB (dir ext)
    // 0969:   decode pg1_R1  B     $D7 $F7 ; STB (dir ext)
    // 0970:   decode pg1_AR  IDATA $D7 $F7 ; STB (dir ext)
    // 0971:                            
    // 0972:   decode pg1_JTA ST    $DD $FD ; STD (dir ext)
    // 0973:   decode pg1_R1  D     $DD $FD ; STD (dir ext)
    // 0974:   decode pg1_AR  IDATA $DD $FD ; STD (dir ext)
    // 0975:                            
    // 0976:   decode pg2_JTA ST    $DF $FF ; STS (dir ext)
    // 0977:   decode pg2_R1  S     $DF $FF ; STS (dir ext)
    // 0978:   decode pg2_AR  IDATA $DF $FF ; STS (dir ext)
    // 0979:                            
    // 0980:   decode pg1_JTA ST    $DF $FF ; STU (dir ext)
    // 0981:   decode pg1_R1  U     $DF $FF ; STU (dir ext)
    // 0982:   decode pg1_AR  IDATA $DF $FF ; STU (dir ext)
    // 0983:                            
    // 0984:   decode pg1_JTA ST    $9F $BF ; STX (dir ext)
    // 0985:   decode pg1_R1  X     $9F $BF ; STX (dir ext)
    // 0986:   decode pg1_AR  IDATA $9F $BF ; STX (dir ext)
    // 0987:                            
    // 0988:   decode pg2_JTA ST    $9F $BF ; STY (dir ext)
    // 0989:   decode pg2_R1  Y     $9F $BF ; STY (dir ext)
    // 0990:   decode pg2_AR  IDATA $9F $BF ; STY (dir ext)
    // 0991:                            
    // 0992:   decode pg1_JTB ST    $A7     ; STA (idx)
    // 0993:   decode pg1_R1  A     $A7     ; STA (idx)
    // 0994:   decode pg1_AR  EA    $A7     ; STA (idx)
    // 0995:                                    
    // 0996:   decode pg1_JTB ST    $E7     ; STB (idx)
    // 0997:   decode pg1_R1  B     $E7     ; STB (idx)
    // 0998:   decode pg1_AR  EA    $E7     ; STB (idx)
    // 0999:                                    
    // 1000:   decode pg1_JTB ST    $ED     ; STD (idx)
    // 1001:   decode pg1_R1  D     $ED     ; STD (idx)
    // 1002:   decode pg1_AR  EA    $ED     ; STD (idx)
    // 1003:                                    
    // 1004:   decode pg2_JTB ST    $EF     ; STS (idx)
    // 1005:   decode pg2_R1  S     $EF     ; STS (idx)
    // 1006:   decode pg2_AR  EA    $EF     ; STS (idx)
    // 1007:                                    
    // 1008:   decode pg1_JTB ST    $EF     ; STU (idx)
    // 1009:   decode pg1_R1  U     $EF     ; STU (idx)
    // 1010:   decode pg1_AR  EA    $EF     ; STU (idx)
    // 1011:                                    
    // 1012:   decode pg1_JTB ST    $AF     ; STX (idx)
    // 1013:   decode pg1_R1  X     $AF     ; STX (idx)
    // 1014:   decode pg1_AR  EA    $AF     ; STX (idx)
    // 1015:                                    
    // 1016:   decode pg2_JTB ST    $AF     ; STY (idx)
    // 1017:   decode pg2_R1  Y     $AF     ; STY (idx)
    // 1018:   decode pg2_AR  EA    $AF     ; STY (idx)
    // 1019: 
    // 1020:   DATA_PASS_A     R1
    // 1021: 
    // 1022:   SET_DATA_WIDTH  W_R1
    // 1023: 
    // 1024:   CCR_OP_W        OP_ooooXXXo
    // 1025: 
    // 1026:   ADDR_PASS       AR
    // 1027:   DMEM_STORE_W
    // 1028: 
    // 1029:   JUMP_TABLE_A_NEXT_PC
    // 1030:   micro_op_end
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


    // 1031: 
    // 1032: ; //
    // 1033: ; ////////////////////////////////////////////////////////////////////////////
    // 1034: 
    // 1035: 
    // 1036: ; ////////////////////////////////////////////////////////////////////////////
    // 1037: ;                   MODIFY MEMORY OR ACCUMULATOR INSTRUCTIONS
    // 1038: ; ////////////////////////////////////////////////////////////////////////////
    // 1039: ; //
    // 1040: 
    // 1041: ; //////////////////////////////////////////// ASL LSL
    // 1042: ; //
    // 1043: ASL_LSL:
    // 1044:   decode pg1_JTA ASL_LSL $48         ; ASLA LSLA (inh)
    // 1045:   decode pg1_R1  A       $48         ; ASLA LSLA (inh)
    // 1046:                                         
    // 1047:   decode pg1_JTA ASL_LSL $58         ; ASLB LSLB (inh)
    // 1048:   decode pg1_R1  B       $58         ; ASLB LSLB (inh)
    // 1049:                              
    // 1050:   decode pg1_JTB ASL_LSL $08 $68 $78 ; ASL LSL (dir idx ext)
    // 1051:   decode pg1_R1  DMEM_RD $08 $68 $78 ; ASL LSL (dir idx ext)
    // 1052: 
    // 1053:   DATA_LSHIFT_W   R1, ZERO_BIT
    // 1054:   DATA_WRITE      R1
    // 1055: 
    // 1056:   SET_DATA_WIDTH  W_R1
    // 1057: 
    // 1058:   CCR_OP_W        OP_ooooXXXX ; INFO: Spec H Undefined, Turbo9 H not affected
    // 1059: 
    // 1060:   ADDR_PASS       EA
    // 1061:   DMEM_STORE_W ; Disabled for inherent addressing modes
    // 1062: 
    // 1063:   JUMP_TABLE_A_NEXT_PC
    // 1064:   micro_op_end
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


    // 1065: 
    // 1066: ; //////////////////////////////////////////// ASR
    // 1067: ; //
    // 1068: ASR:
    // 1069:   decode pg1_JTA ASR     $47         ; ASRA (inh)
    // 1070:   decode pg1_R1  A       $47         ; ASRA (inh)
    // 1071:                                          
    // 1072:   decode pg1_JTA ASR     $57         ; ASRB (inh)
    // 1073:   decode pg1_R1  B       $57         ; ASRB (inh)
    // 1074:                              
    // 1075:   decode pg1_JTB ASR     $07 $67 $77 ; ASR (dir idx ext)
    // 1076:   decode pg1_R1  DMEM_RD $07 $67 $77 ; ASR (dir idx ext)
    // 1077: 
    // 1078:   DATA_RSHIFT_W   SIGN_BIT, R1
    // 1079:   DATA_WRITE      R1
    // 1080: 
    // 1081:   SET_DATA_WIDTH  W_R1
    // 1082: 
    // 1083:   CCR_OP_W        OP_ooooXXoX ; INFO: Spec H Undefined, Turbo9 H not affected
    // 1084: 
    // 1085:   ADDR_PASS       EA
    // 1086:   DMEM_STORE_W  ; Disabled for inherent addressing modes
    // 1087: 
    // 1088:   JUMP_TABLE_A_NEXT_PC
    // 1089:   micro_op_end
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


    // 1090: 
    // 1091: ; //////////////////////////////////////////// CLR
    // 1092: ; //
    // 1093: ; // This is a little different than other memory modify
    // 1094: ; // instructions. It does not load the memory first like
    // 1095: ; // the 6809. It just writes a zero to be more efficient
    // 1096: CLR:
    // 1097: 
    // 1098:   decode pg1_JTA CLR     $4F     ; CLRA (inh)
    // 1099:   decode pg1_R1  A       $4F     ; CLRA (inh)
    // 1100:                                      
    // 1101:   decode pg1_JTA CLR     $5F     ; CLRB (inh)
    // 1102:   decode pg1_R1  B       $5F     ; CLRB (inh)
    // 1103:                            
    // 1104:   decode pg1_JTA CLR     $0F $7F ; CLR (dir ext)
    // 1105:   decode pg1_R1  DMEM_RD $0F $7F ; CLR (dir ext) sets 8bit width
    // 1106:   decode pg1_AR  IDATA   $0F $7F ; CLR (dir ext)
    // 1107:                            
    // 1108:   decode pg1_JTB CLR     $6F     ; CLR (idx)
    // 1109:   decode pg1_R1  DMEM_RD $6F     ; CLR (idx) sets 8bit width
    // 1110:   decode pg1_AR  EA      $6F     ; CLR (idx)
    // 1111: 
    // 1112:   DATA_PASS_B     ZERO 
    // 1113:   DATA_WRITE      R1
    // 1114: 
    // 1115:   SET_DATA_WIDTH  W_R1
    // 1116: 
    // 1117:   CCR_OP_W        OP_ooooXXXX
    // 1118: 
    // 1119:   ADDR_PASS       AR
    // 1120:   DMEM_STORE_W  ; Disabled for inherent addressing modes
    // 1121: 
    // 1122:   JUMP_TABLE_A_NEXT_PC
    // 1123:   micro_op_end
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


    // 1124: 
    // 1125: ; //////////////////////////////////////////// COM
    // 1126: ; //
    // 1127: COM:
    // 1128:   decode pg1_JTA COM     $43         ; COMA (inh)
    // 1129:   decode pg1_R1  A       $43         ; COMA (inh)
    // 1130:   decode pg1_R2  A       $43         ; COMA (inh)
    // 1131:                                          
    // 1132:   decode pg1_JTA COM     $53         ; COMB (inh)
    // 1133:   decode pg1_R1  B       $53         ; COMB (inh)
    // 1134:   decode pg1_R2  B       $53         ; COMB (inh)
    // 1135:                              
    // 1136:   decode pg1_JTB COM     $03 $63 $73 ; COM (dir idx ext)
    // 1137:   decode pg1_R1  DMEM_RD $03 $63 $73 ; COM (dir idx ext) sets 8bit width
    // 1138:   decode pg1_R2  DMEM_RD $03 $63 $73 ; COM (dir idx ext)
    // 1139: 
    // 1140:   DATA_INVERT_B   R2
    // 1141:   DATA_WRITE      R1
    // 1142: 
    // 1143:   SET_DATA_WIDTH  W_R1
    // 1144: 
    // 1145:   CCR_OP_W        OP_ooooXXXX ; INFO Carry should be set to 1 for 6800 compatibility
    // 1146: 
    // 1147:   ADDR_PASS       EA
    // 1148:   DMEM_STORE_W ; Disabled for inherent addressing modes
    // 1149: 
    // 1150:   JUMP_TABLE_A_NEXT_PC
    // 1151:   micro_op_end
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


    // 1152: 
    // 1153: ; //////////////////////////////////////////// DEC
    // 1154: ; //
    // 1155: DEC:
    // 1156:   decode pg1_JTA DEC     $4A         ; DECA (inh)
    // 1157:   decode pg1_R1  A       $4A         ; DECA (inh)
    // 1158:                                          
    // 1159:   decode pg1_JTA DEC     $5A         ; DECB (inh)
    // 1160:   decode pg1_R1  B       $5A         ; DECB (inh)
    // 1161:                              
    // 1162:   decode pg1_JTB DEC     $0A $6A $7A ; DEC (dir idx ext)
    // 1163:   decode pg1_R1  DMEM_RD $0A $6A $7A ; DEC (dir idx ext)
    // 1164: 
    // 1165:   DATA_DEC        R1
    // 1166:   DATA_WRITE      R1
    // 1167: 
    // 1168:   SET_DATA_WIDTH  W_R1
    // 1169:   
    // 1170:   CCR_OP_W        OP_ooooXXXo
    // 1171: 
    // 1172:   ADDR_PASS       EA
    // 1173:   DMEM_STORE_W ; Disabled for inherent addressing modes
    // 1174: 
    // 1175:   JUMP_TABLE_A_NEXT_PC
    // 1176:   micro_op_end
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


    // 1177: 
    // 1178: ; //////////////////////////////////////////// INC
    // 1179: ; //
    // 1180: INC:
    // 1181:   decode pg1_JTA INC     $4C         ; INCA (inh)
    // 1182:   decode pg1_R1  A       $4C         ; INCA (inh)
    // 1183:                                          
    // 1184:   decode pg1_JTA INC     $5C         ; INCB (inh)
    // 1185:   decode pg1_R1  B       $5C         ; INCB (inh)
    // 1186:                              
    // 1187:   decode pg1_JTB INC     $0C $6C $7C ; INC (dir idx ext)
    // 1188:   decode pg1_R1  DMEM_RD $0C $6C $7C ; INC (dir idx ext)
    // 1189: 
    // 1190:   DATA_INC        R1
    // 1191:   DATA_WRITE      R1
    // 1192: 
    // 1193:   SET_DATA_WIDTH  W_R1
    // 1194: 
    // 1195:   CCR_OP_W        OP_ooooXXXo
    // 1196: 
    // 1197:   ADDR_PASS       EA
    // 1198:   DMEM_STORE_W ; Disabled for inherent addressing modes
    // 1199: 
    // 1200:   JUMP_TABLE_A_NEXT_PC
    // 1201:   micro_op_end
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


    // 1202: 
    // 1203: ; //////////////////////////////////////////// LSR
    // 1204: ; //
    // 1205: LSR:
    // 1206:   decode pg1_JTA LSR     $44         ; LSRA (inh)
    // 1207:   decode pg1_R1  A       $44         ; LSRA (inh)
    // 1208:                                          
    // 1209:   decode pg1_JTA LSR     $54         ; LSRB (inh)
    // 1210:   decode pg1_R1  B       $54         ; LSRB (inh)
    // 1211:                              
    // 1212:   decode pg1_JTB LSR     $04 $64 $74 ; LSR (dir idx ext)
    // 1213:   decode pg1_R1  DMEM_RD $04 $64 $74 ; LSR (dir idx ext)
    // 1214: 
    // 1215:   DATA_RSHIFT_W   ZERO_BIT, R1
    // 1216:   DATA_WRITE      R1
    // 1217: 
    // 1218:   SET_DATA_WIDTH  W_R1
    // 1219: 
    // 1220:   CCR_OP_W        OP_ooooXXoX
    // 1221: 
    // 1222:   ADDR_PASS       EA
    // 1223:   DMEM_STORE_W ; Disabled for inherent addressing modes
    // 1224: 
    // 1225:   JUMP_TABLE_A_NEXT_PC
    // 1226:   micro_op_end
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


    // 1227: 
    // 1228: ; //////////////////////////////////////////// NEG
    // 1229: ; //
    // 1230: NEG:
    // 1231:   decode pg1_JTA NEG     $40         ; NEGA (inh)
    // 1232:   decode pg1_R1  A       $40         ; NEGA (inh)
    // 1233:   decode pg1_R2  A       $40         ; NEGA (inh)
    // 1234:                                          
    // 1235:   decode pg1_JTA NEG     $50         ; NEGB (inh)
    // 1236:   decode pg1_R1  B       $50         ; NEGB (inh)
    // 1237:   decode pg1_R2  B       $50         ; NEGB (inh)
    // 1238:                                          
    // 1239:   decode pg1_JTB NEG     $00 $60 $70 ; NEG (dir idx ext)
    // 1240:   decode pg1_R1  DMEM_RD $00 $60 $70 ; NEG (dir idx ext) sets 8bit width
    // 1241:   decode pg1_R2  DMEM_RD $00 $60 $70 ; NEG (dir idx ext)
    // 1242: 
    // 1243:   DATA_SUB        ZERO, R2
    // 1244:   DATA_WRITE      R1
    // 1245: 
    // 1246:   SET_DATA_WIDTH  W_R1
    // 1247: 
    // 1248:   CCR_OP_W        OP_ooooXXXX ; INFO: Spec H Undefined, Turbo9 H not affected
    // 1249: 
    // 1250:   ADDR_PASS       EA
    // 1251:   DMEM_STORE_W ; Disabled for inherent addressing modes
    // 1252: 
    // 1253:   JUMP_TABLE_A_NEXT_PC
    // 1254:   micro_op_end
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


    // 1255: 
    // 1256: ; //////////////////////////////////////////// ROL
    // 1257: ; //
    // 1258: ROL:
    // 1259:   decode pg1_JTA ROL     $49         ; ROLA (inh)
    // 1260:   decode pg1_R1  A       $49         ; ROLA (inh)
    // 1261:                                          
    // 1262:   decode pg1_JTA ROL     $59         ; ROLB (inh)
    // 1263:   decode pg1_R1  B       $59         ; ROLB (inh)
    // 1264:                                          
    // 1265:   decode pg1_JTB ROL     $09 $69 $79 ; ROL (dir idx ext)
    // 1266:   decode pg1_R1  DMEM_RD $09 $69 $79 ; ROL (dir idx ext)
    // 1267: 
    // 1268:   DATA_LSHIFT_W   R1, CARRY_BIT
    // 1269:   DATA_WRITE      R1
    // 1270: 
    // 1271:   SET_DATA_WIDTH  W_R1
    // 1272: 
    // 1273:   CCR_OP_W        OP_ooooXXXX
    // 1274: 
    // 1275:   ADDR_PASS       EA
    // 1276:   DMEM_STORE_W ; Disabled for inherent addressing modes
    // 1277: 
    // 1278:   JUMP_TABLE_A_NEXT_PC
    // 1279:   micro_op_end
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


    // 1280: 
    // 1281: ; //////////////////////////////////////////// ROR
    // 1282: ; //
    // 1283: ROR:
    // 1284:   decode pg1_JTA ROR     $46         ; RORA (inh)
    // 1285:   decode pg1_R1  A       $46         ; RORA (inh)
    // 1286:                                                    
    // 1287:   decode pg1_JTA ROR     $56         ; RORB (inh)
    // 1288:   decode pg1_R1  B       $56         ; RORB (inh)
    // 1289:                              
    // 1290:   decode pg1_JTB ROR     $06 $66 $76 ; ROR (dir idx ext)
    // 1291:   decode pg1_R1  DMEM_RD $06 $66 $76 ; ROR (dir idx ext)
    // 1292: 
    // 1293:   DATA_RSHIFT_W   CARRY_BIT, R1
    // 1294:   DATA_WRITE      R1
    // 1295: 
    // 1296:   SET_DATA_WIDTH  W_R1
    // 1297: 
    // 1298:   CCR_OP_W        OP_ooooXXoX
    // 1299: 
    // 1300:   ADDR_PASS       EA
    // 1301:   DMEM_STORE_W ; Disabled for inherent addressing modes
    // 1302: 
    // 1303:   JUMP_TABLE_A_NEXT_PC
    // 1304:   micro_op_end
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


    // 1305: 
    // 1306: ; //////////////////////////////////////////// TST
    // 1307: ; //
    // 1308: TST:
    // 1309:   decode pg1_JTA TST     $4D         ; TSTA (inh)
    // 1310:   decode pg1_R1  A       $4D         ; TSTA (inh)
    // 1311:                                          
    // 1312:   decode pg1_JTA TST     $5D         ; TSTB (inh)
    // 1313:   decode pg1_R1  B       $5D         ; TSTB (inh)
    // 1314:                              
    // 1315:   decode pg1_JTB TST     $0D $6D $7D ; TST (dir idx ext)
    // 1316:   decode pg1_R1  DMEM_RD $0D $6D $7D ; TST (dir idx ext)
    // 1317: 
    // 1318:   DATA_PASS_A     R1 ; Pass A, B or DMEM
    // 1319: 
    // 1320:   SET_DATA_WIDTH  W_R1
    // 1321: 
    // 1322:   CCR_OP_W        OP_ooooXXXo
    // 1323: 
    // 1324:   JUMP_TABLE_A_NEXT_PC
    // 1325:   micro_op_end
    9'h02d: begin
      CV_MICRO_SEQ_OP_O = 3'h5;  // OP_JUMP_TABLE_A_NEXT_PC
      CV_DATA_ALU_A_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_B_SEL_O = 3'h7;  // ZERO
      CV_DATA_ALU_OP_O = 3'h0;  // A_PLUS_B
      CV_DATA_WIDTH_SEL_O = 3'h0;  // W_R1
      CV_CCR_OP_O = 4'h4;  // OP_OOOOXXXO
      CV_DATA_ALU_COND_SEL_O = 2'h0;  // ZERO_BIT
    end


    // 1326: 
    // 1327: ; //
    // 1328: ; ////////////////////////////////////////////////////////////////////////////
    // 1329: 
    // 1330: 
    // 1331: 
    // 1332: ; ////////////////////////////////////////////////////////////////////////////
    // 1333: ;                        JUMP & BRANCH INSTRUCTIONS
    // 1334: ; ////////////////////////////////////////////////////////////////////////////
    // 1335: ; //
    // 1336: 
    // 1337: ; //////////////////////////////////////////// BRANCH
    // 1338: ; //
    // 1339: BRANCH:
    // 1340:   decode pg1_JTA BRANCH $20 $21 $22 $23 ; BRA BRN BHI BLS
    // 1341:   decode pg1_JTB JMP    $20 $21 $22 $23 ; BRA BRN BHI BLS
    // 1342:   decode pg1_R1  PC     $20 $21 $22 $23 ; BRA BRN BHI BLS
    // 1343:   decode pg1_R2  EA     $20 $21 $22 $23 ; BRA BRN BHI BLS
    // 1344:                                             
    // 1345:   decode pg1_JTA BRANCH $24 $25 $26 $27 ; BCC BCS BNE BEQ
    // 1346:   decode pg1_JTB JMP    $24 $25 $26 $27 ; BCC BCS BNE BEQ
    // 1347:   decode pg1_R1  PC     $24 $25 $26 $27 ; BCC BCS BNE BEQ
    // 1348:   decode pg1_R2  EA     $24 $25 $26 $27 ; BCC BCS BNE BEQ
    // 1349:                                             
    // 1350:   decode pg1_JTA BRANCH $28 $29 $2A $2B ; BVC BVS BPL BMI
    // 1351:   decode pg1_JTB JMP    $28 $29 $2A $2B ; BVC BVS BPL BMI
    // 1352:   decode pg1_R1  PC     $28 $29 $2A $2B ; BVC BVS BPL BMI
    // 1353:   decode pg1_R2  EA     $28 $29 $2A $2B ; BVC BVS BPL BMI
    // 1354:                                             
    // 1355:   decode pg1_JTA BRANCH $2C $2D $2E $2F ; BGE BLT BGT BLE
    // 1356:   decode pg1_JTB JMP    $2C $2D $2E $2F ; BGE BLT BGT BLE
    // 1357:   decode pg1_R1  PC     $2C $2D $2E $2F ; BGE BLT BGT BLE
    // 1358:   decode pg1_R2  EA     $2C $2D $2E $2F ; BGE BLT BGT BLE
    // 1359:                                             
    // 1360:   decode pg1_JTA BRANCH $16             ; LBRA On page 1!
    // 1361:   decode pg1_JTB JMP    $16             ; LBRA
    // 1362:   decode pg1_R1  PC     $16             ; LBRA 
    // 1363:   decode pg1_R2  EA     $16             ; LBRA 
    // 1364:                 
    // 1365:   decode pg1_JTA BRANCH $8D $17         ; BSR LBSR // FIXME could do this without JUMP_TABLE_A
    // 1366:   decode pg1_JTB JSR    $8D $17         ; BSR LBSR // FIXME check if smaller area
    // 1367:   decode pg1_R1  PC     $8D $17         ; BSR LBSR
    // 1368:   decode pg1_R2  EA     $8D $17         ; BSR LBSR
    // 1369:   decode pg1_AR  S      $8D $17         ; BSR LBSR
    // 1370:                             
    // 1371: ; Another LBRA hidden on Page 2!
    // 1372:   decode pg2_JTA BRANCH $20 $21 $22 $23 ; LBRA LBRN LBHI LBLS
    // 1373:   decode pg2_JTB JMP    $20 $21 $22 $23 ; LBRA LBRN LBHI LBLS
    // 1374:   decode pg2_R1  PC     $20 $21 $22 $23 ; LBRA LBRN LBHI LBLS
    // 1375:   decode pg2_R2  EA     $20 $21 $22 $23 ; LBRA LBRN LBHI LBLS
    // 1376:                                                                   
    // 1377:   decode pg2_JTA BRANCH $24 $25 $26 $27 ; LBCC LBCS LBNE LBEQ
    // 1378:   decode pg2_JTB JMP    $24 $25 $26 $27 ; LBCC LBCS LBNE LBEQ
    // 1379:   decode pg2_R1  PC     $24 $25 $26 $27 ; LBCC LBCS LBNE LBEQ
    // 1380:   decode pg2_R2  EA     $24 $25 $26 $27 ; LBCC LBCS LBNE LBEQ
    // 1381:                                                                   
    // 1382:   decode pg2_JTA BRANCH $28 $29 $2A $2B ; LBVC LBVS LBPL LBMI
    // 1383:   decode pg2_JTB JMP    $28 $29 $2A $2B ; LBVC LBVS LBPL LBMI
    // 1384:   decode pg2_R1  PC     $28 $29 $2A $2B ; LBVC LBVS LBPL LBMI
    // 1385:   decode pg2_R2  EA     $28 $29 $2A $2B ; LBVC LBVS LBPL LBMI
    // 1386:                                                                   
    // 1387:   decode pg2_JTA BRANCH $2C $2D $2E $2F ; LBGE LBLT LBGT LBLE
    // 1388:   decode pg2_JTB JMP    $2C $2D $2E $2F ; LBGE LBLT LBGT LBLE
    // 1389:   decode pg2_R1  PC     $2C $2D $2E $2F ; LBGE LBLT LBGT LBLE
    // 1390:   decode pg2_R2  EA     $2C $2D $2E $2F ; LBGE LBLT LBGT LBLE
    // 1391: 
    // 1392:   DATA_ADD        R1, IDATA ; PC + signed offset
    // 1393:   DATA_WRITE      EA
    // 1394: 
    // 1395:   SET_DATA_WIDTH  W_R1
    // 1396: 
    // 1397:   IF              BRANCH_COND
    // 1398:   JUMP_TABLE_B
    // 1399:   micro_op_end
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


    // 1400: 
    // 1401: GO_NEW_PC:
    // 1402:   JUMP_TABLE_A_NEXT_PC
    // 1403:   micro_op_end
    9'h02f: begin
      CV_MICRO_SEQ_OP_O = 3'h5;  // OP_JUMP_TABLE_A_NEXT_PC
    end


    // 1404: 
    // 1405: ; //////////////////////////////////////////// JMP
    // 1406: ; //
    // 1407: JMP:
    // 1408:   decode pg1_JTA JMP   $0E $7E ; JMP (dir ext)
    // 1409:   decode pg1_R1  PC    $0E $7E ; JMP (dir ext)
    // 1410:   decode pg1_R2  IDATA $0E $7E ; JMP (dir ext)
    // 1411:                                    
    // 1412:   decode pg1_JTB JMP   $6E     ; JMP (idx)
    // 1413:   decode pg1_R1  PC    $6E     ; JMP (idx)
    // 1414:   decode pg1_R2  EA    $6E     ; JMP (idx)
    // 1415: 
    // 1416:   DATA_PASS_B     R2 ; IDATA or EA
    // 1417:   DATA_WRITE      R1 ; PC
    // 1418: 
    // 1419:   JUMP            GO_NEW_PC ; PC must be written before "JUMP_TABLE_A_NEXT_PC"
    // 1420:   micro_op_end
    9'h030: begin
      CV_MICRO_SEQ_OP_O = 3'h1;  // OP_JUMP
      CV_MICRO_SEQ_BRANCH_ADDR_O = 8'h2f;  // GO_NEW_PC
      CV_DATA_ALU_A_SEL_O = 4'hf;  // ZERO
      CV_DATA_ALU_B_SEL_O = 3'h0;  // R2
      CV_DATA_ALU_WR_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_OP_O = 3'h0;  // A_PLUS_B
      CV_DATA_ALU_COND_SEL_O = 2'h0;  // ZERO_BIT
    end


    // 1421: 
    // 1422: 
    // 1423: ; ////////////////////////////////////////////////////////////////////////////
    // 1424: 
    // 1425: 
    // 1426: 
    // 1427: ; ////////////////////////////////////////////////////////////////////////////
    // 1428: ;                        STACK INSTRUCTIONS
    // 1429: ; ////////////////////////////////////////////////////////////////////////////
    // 1430: ; //
    // 1431: 
    // 1432: 
    // 1433: ; //////////////////////////////////////////// JSR
    // 1434: ; //
    // 1435: JSR:
    // 1436:   decode pg1_JTA JSR   $9D $BD ; JSR (dir ext)
    // 1437:   decode pg1_R1  PC    $9D $BD ; JSR (dir ext)
    // 1438:   decode pg1_R2  IDATA $9D $BD ; JSR (dir ext)
    // 1439:   decode pg1_AR  S     $9D $BD ; JSR (dir ext)
    // 1440:                                  
    // 1441:   decode pg1_JTB JSR   $AD     ; JSR (idx)
    // 1442:   decode pg1_R1  PC    $AD     ; JSR (idx)
    // 1443:   decode pg1_R2  EA    $AD     ; JSR (idx)
    // 1444:   decode pg1_AR  S     $AD     ; JSR (idx)
    // 1445: 
    // 1446:   DATA_PASS_A     R1 ; PC
    // 1447: 
    // 1448:   SET_DATA_WIDTH  W_R1
    // 1449: 
    // 1450:   STACK_PUSH      AR
    // 1451:   DMEM_STORE_W
    // 1452: 
    // 1453:   JUMP            JMP 
    // 1454:   micro_op_end
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


    // 1455: 
    // 1456: ; //////////////////////////////////////////// RTS
    // 1457: ; //
    // 1458: RTS:
    // 1459:   decode pg1_JTA RTS      $39 ; RTS
    // 1460:   decode pg1_R1  PC       $39 ; RTS
    // 1461:   decode pg1_R2  DMEM_RD  $39 ; RTS
    // 1462:   decode pg1_AR  S        $39 ; RTS
    // 1463: 
    // 1464:   SET_DATA_WIDTH  W_R1
    // 1465:   
    // 1466:   STACK_PULL      AR
    // 1467:   DMEM_LOAD_W
    // 1468:   
    // 1469:   JUMP            JMP
    // 1470:   micro_op_end
    9'h032: begin
      CV_MICRO_SEQ_OP_O = 3'h1;  // OP_JUMP
      CV_MICRO_SEQ_BRANCH_ADDR_O = 8'h30;  // JMP
      CV_ADDR_ALU_REG_SEL_O = 4'h8;  // AR
      CV_DATA_WIDTH_SEL_O = 3'h0;  // W_R1
      CV_DMEM_OP_O = 2'h2;  // DMEM_OP_RD
      CV_STACK_OP_O = 2'h1;  // STACK_OP_PULL
    end


    // 1471: 
    // 1472: ; //////////////////////////////////////////// RTI
    // 1473: ; //
    // 1474: RTI:
    // 1475:   decode pg1_JTA RTI      $3B ; RTI
    // 1476:   decode pg1_R1  PC       $3B ; RTI
    // 1477:   decode pg1_R2  DMEM_RD  $3B ; RTI
    // 1478:   decode pg1_AR  S        $3B ; RTI
    // 1479:   
    // 1480:   STACK_PULL      ZERO  ; Prime the decode pipeline!
    // 1481:   micro_op_end
    9'h033: begin
      CV_ADDR_ALU_REG_SEL_O = 4'hf;  // ZERO
      CV_STACK_OP_O = 2'h1;  // STACK_OP_PULL
    end


    // 1482: 
    // 1483:   SET_DATA_WIDTH  W_STACK_REG
    // 1484:   
    // 1485:   STACK_PULL      AR
    // 1486:   DMEM_LOAD_W
    // 1487:   micro_op_end
    9'h034: begin
      CV_ADDR_ALU_REG_SEL_O = 4'h8;  // AR
      CV_DATA_WIDTH_SEL_O = 3'h2;  // W_STACK_REG
      CV_DMEM_OP_O = 2'h2;  // DMEM_OP_RD
      CV_STACK_OP_O = 2'h1;  // STACK_OP_PULL
    end


    // 1488: 
    // 1489: RTI_CCR:
    // 1490:   DATA_PASS_B     DMEM_RD
    // 1491:   DATA_WRITE      STACK_REG
    // 1492: 
    // 1493:   CCR_OP_W        OP_XXXXXXXX ; FIXME get rid of this requirement
    // 1494:   micro_op_end
    9'h035: begin
      CV_DATA_ALU_A_SEL_O = 4'hf;  // ZERO
      CV_DATA_ALU_B_SEL_O = 3'h5;  // DMEM_RD
      CV_DATA_ALU_WR_SEL_O = 4'h0;  // STACK_REG
      CV_DATA_ALU_OP_O = 3'h0;  // A_PLUS_B
      CV_CCR_OP_O = 4'h9;  // OP_XXXXXXXX
      CV_DATA_ALU_COND_SEL_O = 2'h0;  // ZERO_BIT
    end


    // 1495: 
    // 1496: RTI_TEST_E:
    // 1497:   IF              E_CLEAR
    // 1498:   JUMP            RTS
    // 1499:   micro_op_end
    9'h036: begin
      CV_MICRO_SEQ_OP_O = 3'h1;  // OP_JUMP
      CV_MICRO_SEQ_BRANCH_ADDR_O = 8'h32;  // RTS
      CV_MICRO_SEQ_COND_SEL_O = 4'h6;  // E_CLEAR
    end


    // 1500: 
    // 1501: RTI_PUL_ALL:
    // 1502:   SET_DATA_WIDTH  W_STACK_REG
    // 1503:   
    // 1504:   STACK_PULL      AR
    // 1505:   DMEM_LOAD_W
    // 1506:   
    // 1507:   JUMP            PUL_LOOP
    // 1508:   micro_op_end
    9'h037: begin
      CV_MICRO_SEQ_OP_O = 3'h1;  // OP_JUMP
      CV_MICRO_SEQ_BRANCH_ADDR_O = 8'h3a;  // PUL_LOOP
      CV_ADDR_ALU_REG_SEL_O = 4'h8;  // AR
      CV_DATA_WIDTH_SEL_O = 3'h2;  // W_STACK_REG
      CV_DMEM_OP_O = 2'h2;  // DMEM_OP_RD
      CV_STACK_OP_O = 2'h1;  // STACK_OP_PULL
    end


    // 1509: 
    // 1510: 
    // 1511: ; //////////////////////////////////////////// PULS PULU
    // 1512: ; //
    // 1513: PUL:
    // 1514:   decode pg1_JTA PUL  $35 ; PULS
    // 1515:   decode pg1_AR  S    $35 ; PULS
    // 1516: 
    // 1517:   decode pg1_JTA PUL  $37 ; PULU
    // 1518:   decode pg1_AR  U    $37 ; PULU
    // 1519: 
    // 1520:   
    // 1521:   STACK_PULL      ZERO  ; Prime the decode pipeline!
    // 1522:   
    // 1523:   IF              STACK_DONE
    // 1524:   JUMP            NOP
    // 1525:   micro_op_end
    9'h038: begin
      CV_MICRO_SEQ_OP_O = 3'h1;  // OP_JUMP
      CV_MICRO_SEQ_BRANCH_ADDR_O = 8'hc;  // NOP
      CV_ADDR_ALU_REG_SEL_O = 4'hf;  // ZERO
      CV_MICRO_SEQ_COND_SEL_O = 4'h2;  // STACK_DONE
      CV_STACK_OP_O = 2'h1;  // STACK_OP_PULL
    end


    // 1526:   
    // 1527:   SET_DATA_WIDTH  W_STACK_REG
    // 1528:   
    // 1529:   STACK_PULL      AR
    // 1530:   DMEM_LOAD_W
    // 1531:   
    // 1532:   IF              STACK_DONE
    // 1533:   JUMP            PUL_DONE
    // 1534:   micro_op_end
    9'h039: begin
      CV_MICRO_SEQ_OP_O = 3'h1;  // OP_JUMP
      CV_MICRO_SEQ_BRANCH_ADDR_O = 8'h3b;  // PUL_DONE
      CV_ADDR_ALU_REG_SEL_O = 4'h8;  // AR
      CV_DATA_WIDTH_SEL_O = 3'h2;  // W_STACK_REG
      CV_MICRO_SEQ_COND_SEL_O = 4'h2;  // STACK_DONE
      CV_DMEM_OP_O = 2'h2;  // DMEM_OP_RD
      CV_STACK_OP_O = 2'h1;  // STACK_OP_PULL
    end


    // 1535: 
    // 1536: PUL_LOOP:
    // 1537:   DATA_PASS_B     DMEM_RD
    // 1538:   DATA_WRITE      STACK_REG
    // 1539: 
    // 1540:   CCR_OP_W        OP_XXXXXXXX ; FIXME get rid of this requirement
    // 1541:   
    // 1542:   SET_DATA_WIDTH  W_STACK_REG
    // 1543: 
    // 1544:   STACK_PULL      AR
    // 1545:   DMEM_LOAD_W
    // 1546: 
    // 1547:   IF              STACK_NEXT
    // 1548:   JUMP            PUL_LOOP
    // 1549:   micro_op_end
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


    // 1550: 
    // 1551: PUL_DONE:
    // 1552:   DATA_PASS_B     DMEM_RD
    // 1553:   DATA_WRITE      STACK_REG
    // 1554: 
    // 1555:   CCR_OP_W        OP_XXXXXXXX ; FIXME get rid of this requirement
    // 1556: 
    // 1557:   JUMP            GO_NEW_PC ; PC must be written before "JUMP_TABLE_A_NEXT_PC" FIXME?
    // 1558:   micro_op_end
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


    // 1559: 
    // 1560: 
    // 1561: ; //////////////////////////////////////////// PSHS PSHU
    // 1562: ; //
    // 1563: PSH:
    // 1564:   decode pg1_JTA PSH   $34 ; PSHS
    // 1565:   decode pg1_AR  S     $34 ; PSHS
    // 1566: 
    // 1567:   decode pg1_JTA PSH   $36 ; PSHU
    // 1568:   decode pg1_AR  U     $36 ; PSHU
    // 1569:   
    // 1570:   STACK_PUSH      ZERO  ; Prime the decode pipeline!
    // 1571: 
    // 1572:   IF              STACK_DONE
    // 1573:   JUMP            NOP
    // 1574:   micro_op_end
    9'h03c: begin
      CV_MICRO_SEQ_OP_O = 3'h1;  // OP_JUMP
      CV_MICRO_SEQ_BRANCH_ADDR_O = 8'hc;  // NOP
      CV_ADDR_ALU_REG_SEL_O = 4'hf;  // ZERO
      CV_MICRO_SEQ_COND_SEL_O = 4'h2;  // STACK_DONE
      CV_STACK_OP_O = 2'h2;  // STACK_OP_PUSH
    end


    // 1575:   
    // 1576: PSH_LOOP:
    // 1577:   DATA_PASS_A     STACK_REG
    // 1578:   
    // 1579:   SET_DATA_WIDTH  W_STACK_REG
    // 1580: 
    // 1581:   STACK_PUSH      AR
    // 1582:   DMEM_STORE_W
    // 1583: 
    // 1584:   IF              STACK_NEXT
    // 1585:   JUMP            PSH_LOOP
    // 1586:   micro_op_end
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


    // 1587: 
    // 1588:   JUMP_TABLE_A_NEXT_PC
    // 1589:   micro_op_end
    9'h03e: begin
      CV_MICRO_SEQ_OP_O = 3'h5;  // OP_JUMP_TABLE_A_NEXT_PC
    end


    // 1590: 
    // 1591: 
    // 1592: ; //////////////////////////////////////////// SWI
    // 1593: ; //
    // 1594: SWI:
    // 1595:   decode pg1_JTA SWI      $3F ; SWI
    // 1596:   decode pg1_AR  S        $3F ; SWI
    // 1597:   decode pg1_R1  PC       $3F ; SWI
    // 1598:   decode pg1_R2  DMEM_RD  $3F ; SWI
    // 1599:   
    // 1600:   STACK_PUSH      ZERO  ; Prime the decode pipeline!
    // 1601: 
    // 1602:   CCR_OP_W        OP_1ooooooo ; Set E
    // 1603:   micro_op_end
    9'h03f: begin
      CV_ADDR_ALU_REG_SEL_O = 4'hf;  // ZERO
      CV_CCR_OP_O = 4'h7;  // OP_1OOOOOOO
      CV_STACK_OP_O = 2'h2;  // STACK_OP_PUSH
    end


    // 1604:   
    // 1605: SWI_LOOP:
    // 1606:   DATA_PASS_A     STACK_REG
    // 1607:   
    // 1608:   SET_DATA_WIDTH  W_STACK_REG
    // 1609: 
    // 1610:   STACK_PUSH      AR
    // 1611:   DMEM_STORE_W
    // 1612: 
    // 1613:   IF              STACK_NEXT
    // 1614:   JUMP            SWI_LOOP
    // 1615:   micro_op_end
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


    // 1616: 
    // 1617:   ; R1 is PC
    // 1618:   ; R2 is DMEM_RD
    // 1619: 
    // 1620:   SET_DATA_WIDTH  W_16
    // 1621: 
    // 1622:   ADDR_PASS       IDATA ; SWI vector
    // 1623:   DMEM_LOAD_W
    // 1624:   
    // 1625:   CCR_OP_W        OP_o1o1oooo ; Set I & F
    // 1626: 
    // 1627:   JUMP            JMP
    // 1628:   micro_op_end
    9'h041: begin
      CV_MICRO_SEQ_OP_O = 3'h1;  // OP_JUMP
      CV_MICRO_SEQ_BRANCH_ADDR_O = 8'h30;  // JMP
      CV_ADDR_ALU_REG_SEL_O = 4'he;  // IDATA
      CV_DATA_WIDTH_SEL_O = 3'h3;  // W_16
      CV_CCR_OP_O = 4'h8;  // OP_O1O1OOOO
      CV_DMEM_OP_O = 2'h2;  // DMEM_OP_RD
    end


    // 1629: 
    // 1630: 
    // 1631: 
    // 1632: ; ////////////////////////////////////////////////////////////////////////////
    // 1633: 
    // 1634: 
    // 1635:   ORG  $FF
    // 1636: 
    // 1637: TRAP:
    // 1638: 
    // 1639:   JUMP            TRAP
    // 1640:   micro_op_end
    9'h0ff: begin
      CV_MICRO_SEQ_OP_O = 3'h1;  // OP_JUMP
      CV_MICRO_SEQ_BRANCH_ADDR_O = 8'hff;  // TRAP
    end


    // 1641: 
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

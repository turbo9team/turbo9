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
`include "turbo9_rtl_config.vh"

module turbo9_urtl_microcode
(
  // Inputs:
  input     [7:0] MICROCODE_ADR_I,

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
    // 0048: ; decode_init <tablename> <ctrl_vec> <default_string> <input width> ; Comment
    // 0049: 
    // 0050:   ; Jump Table A
    // 0051:   decode_init pg1_JTA cv_MICRO_SEQ_BRANCH_ADDR FF 8 ; Page 1
    // 0052:   decode_init pg2_JTA cv_MICRO_SEQ_BRANCH_ADDR FF 8 ; Page 2
    // 0053:   decode_init pg3_JTA cv_MICRO_SEQ_BRANCH_ADDR FF 8 ; Page 3
    // 0054:   
    // 0055:   ; Jump Table B
    // 0056:   decode_init pg1_JTB cv_MICRO_SEQ_BRANCH_ADDR FF 8 ; Page 1
    // 0057:   decode_init pg2_JTB cv_MICRO_SEQ_BRANCH_ADDR FF 8 ; Page 2
    // 0058:   decode_init pg3_JTB cv_MICRO_SEQ_BRANCH_ADDR FF 8 ; Page 3
    // 0059:   
    // 0060:   ; Register A Decode
    // 0061:   ; A side of ALU and ALU write
    // 0062:   decode_init pg1_R1  cv_R1_SEL x 8 ; Page 1 
    // 0063:   decode_init pg2_R1  cv_R1_SEL x 8 ; Page 2 
    // 0064:   decode_init pg3_R1  cv_R1_SEL x 8 ; Page 3 
    // 0065: 
    // 0066:   ; Register B Decode
    // 0067:   ; B side of ALU
    // 0068:   decode_init pg1_R2  cv_R2_SEL x 8 ; Page 1 
    // 0069:   decode_init pg2_R2  cv_R2_SEL x 8 ; Page 2 
    // 0070:   decode_init pg3_R2  cv_R2_SEL x 8 ; Page 3 
    // 0071: 
    // 0072:   ; Address Register Decode
    // 0073:   decode_init pg1_AR  cv_AR_SEL x 8 ; Page 1 
    // 0074:   decode_init pg2_AR  cv_AR_SEL x 8 ; Page 2 
    // 0075:   decode_init pg3_AR  cv_AR_SEL x 8 ; Page 3 
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
    8'h00: begin
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
    8'h01: begin
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
    8'h02: begin
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
    8'h03: begin
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
    8'h04: begin
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
    8'h05: begin
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
    8'h06: begin
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
    8'h07: begin
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
    8'h08: begin
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
    8'h09: begin
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
    8'h0a: begin
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
    8'h0b: begin
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
    8'h0c: begin
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
    // 0413:   decode pg2_JTA SAU16 $14 ; EDIV (inh)
    // 0414:   decode pg2_R2  D     $14 ; EDIV (inh)
    // 0415:   decode pg2_R1  Y     $14 ; EDIV (inh)
    // 0416:  
    // 0417:   decode pg2_JTA SAU16 $15 ; EDIVS (inh)
    // 0418:   decode pg2_R2  D     $15 ; EDIVS (inh)
    // 0419:   decode pg2_R1  Y     $15 ; EDIVS (inh)
    // 0420:   
    // 0421:   decode pg2_JTA SAU16 $19 ; FDIV (inh)
    // 0422:   decode pg2_R2  D     $19 ; FDIV (inh)
    // 0423:   decode pg2_R1  X     $19 ; FDIV (inh)
    // 0424: 
    // 0425:   decode pg2_JTA SAU16 $18 ; IDIVS (inh)
    // 0426:   decode pg2_R2  D     $18 ; IDIVS (inh)
    // 0427:   decode pg2_R1  X     $18 ; IDIVS (inh)
    // 0428: 
    // 0429:   DATA_SAU_EN
    // 0430: 
    // 0431:   IF              SAU_NOT_DONE
    // 0432:   JUMP            SAU16
    // 0433:   micro_op_end
    8'h0d: begin
      CV_MICRO_SEQ_OP_O = 3'h1;  // OP_JUMP
      CV_MICRO_SEQ_BRANCH_ADDR_O = 8'hd;  // SAU16
      CV_DATA_ALU_SAU_EN_O = 1'h1;  // TRUE
      CV_MICRO_SEQ_COND_SEL_O = 4'h5;  // SAU_NOT_DONE
    end


    // 0434: 
    // 0435: SAU16_DONE:
    // 0436: 
    // 0437:   DATA_SAU_DONE
    // 0438:   DATA_WRITE      R2
    // 0439: 
    // 0440:   JUMP            SAU8_DONE
    // 0441:   micro_op_end
    8'h0e: begin
      CV_MICRO_SEQ_OP_O = 3'h1;  // OP_JUMP
      CV_MICRO_SEQ_BRANCH_ADDR_O = 8'h10;  // SAU8_DONE
      CV_DATA_ALU_WR_SEL_O = 4'h4;  // R2
      CV_DATA_ALU_OP_O = 3'h7;  // SAU
    end


    // 0442: 
    // 0443: ; //////////////////////////////////////////// DAA MUL
    // 0444: ; //
    // 0445: SAU8:
    // 0446:   decode pg1_JTA SAU8 $19 ; DAA (inh)
    // 0447:   decode pg1_R1  D    $19 ; DAA (inh)
    // 0448: 
    // 0449:   decode pg1_JTA SAU8 $3D ; MUL (inh)
    // 0450:   decode pg1_R1  D    $3D ; MUL (inh)
    // 0451: 
    // 0452:   DATA_SAU_EN
    // 0453: 
    // 0454:   IF              SAU_NOT_DONE
    // 0455:   JUMP            SAU8
    // 0456:   micro_op_end
    8'h0f: begin
      CV_MICRO_SEQ_OP_O = 3'h1;  // OP_JUMP
      CV_MICRO_SEQ_BRANCH_ADDR_O = 8'hf;  // SAU8
      CV_DATA_ALU_SAU_EN_O = 1'h1;  // TRUE
      CV_MICRO_SEQ_COND_SEL_O = 4'h5;  // SAU_NOT_DONE
    end


    // 0457: 
    // 0458: SAU8_DONE:
    // 0459: 
    // 0460:   DATA_SAU_DONE
    // 0461:   DATA_WRITE      R1
    // 0462: 
    // 0463:   CCR_OP_W        OP_ooooXXXX ; SAU masks correct bits
    // 0464: 
    // 0465:   JUMP_TABLE_A_NEXT_PC
    // 0466:   micro_op_end
    8'h10: begin
      CV_MICRO_SEQ_OP_O = 3'h5;  // OP_JUMP_TABLE_A_NEXT_PC
      CV_DATA_ALU_WR_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_OP_O = 3'h7;  // SAU
      CV_CCR_OP_O = 4'h2;  // OP_OOOOXXXX
    end


    // 0467: 
    // 0468: ; //////////////////////////////////////////// SEX (in 1 micro-cycle!)
    // 0469: ; //
    // 0470: SEX:
    // 0471:   decode pg1_JTA SEX  $1D ; SEX(inh)
    // 0472:   decode pg1_R1  D    $1D ; SEX(inh)
    // 0473:   decode pg1_R2  SEXB $1D ; SEX(inh)
    // 0474: 
    // 0475:   DATA_PASS_B     R2
    // 0476:   DATA_WRITE      R1
    // 0477:   
    // 0478:   SET_DATA_WIDTH  W_R1
    // 0479: 
    // 0480:   CCR_OP_W        OP_ooooXXXo ; INFO Prog Man says V unaffected, datasheet says v=0
    // 0481: 
    // 0482:   JUMP_TABLE_A_NEXT_PC
    // 0483:   micro_op_end
    8'h11: begin
      CV_MICRO_SEQ_OP_O = 3'h5;  // OP_JUMP_TABLE_A_NEXT_PC
      CV_DATA_ALU_A_SEL_O = 4'hf;  // ZERO
      CV_DATA_ALU_B_SEL_O = 3'h0;  // R2
      CV_DATA_ALU_WR_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_OP_O = 3'h0;  // A_PLUS_B
      CV_DATA_WIDTH_SEL_O = 3'h0;  // W_R1
      CV_CCR_OP_O = 4'h4;  // OP_OOOOXXXO
      CV_DATA_ALU_COND_SEL_O = 2'h0;  // ZERO_BIT
    end


    // 0484: 
    // 0485: ; //////////////////////////////////////////// CPY
    // 0486: ; //
    // 0487: CPY:
    // 0488:   decode pg2_JTA CPY $1F ; CPY (inh)
    // 0489: ; R1 = postbyte[7:0] $1F ; CPY (inh)
    // 0490: ; R2 = postbyte[3:0] $1F ; CPY (inh)
    // 0491: 
    // 0492: ; TODO INFO: could combine this state with SAU states
    // 0493: 
    // 0494:   DATA_SAU_EN ; initalize byte counter from D register
    // 0495:   micro_op_end
    8'h12: begin
      CV_DATA_ALU_SAU_EN_O = 1'h1;  // TRUE
    end


    // 0496:   
    // 0497: CPY_LOOP:
    // 0498:   DATA_SAU_EN ; enable byte counter
    // 0499: 
    // 0500:   SET_DATA_WIDTH  W_8
    // 0501: 
    // 0502:   ADDR_PASS       RR1_WR2
    // 0503:   DMEM_LOAD_W
    // 0504: 
    // 0505:   IF              SAU_DONE
    // 0506:   JUMP            GO_NEW_PC
    // 0507:   micro_op_end
    8'h13: begin
      CV_MICRO_SEQ_OP_O = 3'h1;  // OP_JUMP
      CV_MICRO_SEQ_BRANCH_ADDR_O = 8'h2f;  // GO_NEW_PC
      CV_ADDR_ALU_REG_SEL_O = 4'h4;  // RR1_WR2
      CV_DATA_WIDTH_SEL_O = 3'h4;  // W_8
      CV_DATA_ALU_SAU_EN_O = 1'h1;  // TRUE
      CV_MICRO_SEQ_COND_SEL_O = 4'h4;  // SAU_DONE
      CV_DMEM_OP_O = 2'h2;  // DMEM_OP_RD
    end


    // 0508:   
    // 0509:   DATA_SAU_EN ; enable byte counter
    // 0510: 
    // 0511:   SET_DATA_WIDTH  W_8
    // 0512: 
    // 0513:   DATA_PASS_B     DMEM_RD
    // 0514: 
    // 0515:   ADDR_PASS       RR1_WR2
    // 0516:   DMEM_STORE_W
    // 0517: 
    // 0518:   JUMP            CPY_LOOP
    // 0519:   micro_op_end
    8'h14: begin
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


    // 0520: 
    // 0521: 
    // 0522: 
    // 0523: ; //////////////////////////////////////////// TFR
    // 0524: ; //
    // 0525: TFR:
    // 0526:   decode pg1_JTA TFR $1F ; TFR(inh)
    // 0527: ; R1 = postbyte[7:0] $1F ; TFR(inh)
    // 0528: ; R2 = postbyte[3:0] $1F ; TFR(inh)
    // 0529: 
    // 0530:   DATA_PASS_A     R1
    // 0531:   DATA_WRITE      R2
    // 0532: 
    // 0533:   CCR_OP_W        OP_XXXXXXXX ; Just in case CCR is destination
    // 0534: 
    // 0535:   JUMP            GO_NEW_PC ; Just in case PC is destination
    // 0536:   micro_op_end
    8'h15: begin
      CV_MICRO_SEQ_OP_O = 3'h1;  // OP_JUMP
      CV_MICRO_SEQ_BRANCH_ADDR_O = 8'h2f;  // GO_NEW_PC
      CV_DATA_ALU_A_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_B_SEL_O = 3'h7;  // ZERO
      CV_DATA_ALU_WR_SEL_O = 4'h4;  // R2
      CV_DATA_ALU_OP_O = 3'h0;  // A_PLUS_B
      CV_CCR_OP_O = 4'h9;  // OP_XXXXXXXX
      CV_DATA_ALU_COND_SEL_O = 2'h0;  // ZERO_BIT
    end


    // 0537: 
    // 0538: ; //
    // 0539: ; ////////////////////////////////////////////////////////////////////////////
    // 0540: 
    // 0541: 
    // 0542: ; ////////////////////////////////////////////////////////////////////////////
    // 0543: ;                        LOAD TYPE INSTRUCTIONS
    // 0544: ; ////////////////////////////////////////////////////////////////////////////
    // 0545: 
    // 0546: ; //////////////////////////////////////////// ADC
    // 0547: ; //
    // 0548: ADC:
    // 0549:   decode pg1_JTA ADC     $89         ; ADCA (imm)
    // 0550:   decode pg1_R1  A       $89         ; ADCA (imm)
    // 0551:   decode pg1_R2  IDATA   $89         ; ADCA (imm)
    // 0552:                                                    
    // 0553:   decode pg1_JTA ADC     $C9         ; ADCB (imm)
    // 0554:   decode pg1_R1  B       $C9         ; ADCB (imm)
    // 0555:   decode pg1_R2  IDATA   $C9         ; ADCB (imm)
    // 0556:                                          
    // 0557:   decode pg1_JTB ADC     $99 $A9 $B9 ; ADCA (dir idx ext)
    // 0558:   decode pg1_R1  A       $99 $A9 $B9 ; ADCA (dir idx ext)
    // 0559:   decode pg1_R2  DMEM_RD $99 $A9 $B9 ; ADCA (dir idx ext)
    // 0560:                                          
    // 0561:   decode pg1_JTB ADC     $D9 $E9 $F9 ; ADCB (dir idx ext)
    // 0562:   decode pg1_R1  B       $D9 $E9 $F9 ; ADCB (dir idx ext)
    // 0563:   decode pg1_R2  DMEM_RD $D9 $E9 $F9 ; ADCB (dir idx ext)
    // 0564: 
    // 0565:   DATA_ADDC       R1, R2
    // 0566:   DATA_WRITE      R1
    // 0567: 
    // 0568:   SET_DATA_WIDTH  W_R1
    // 0569: 
    // 0570:   CCR_OP_W        OP_ooXoXXXX ; H is masked for 16bit
    // 0571: 
    // 0572:   JUMP_TABLE_A_NEXT_PC
    // 0573:   micro_op_end
    8'h16: begin
      CV_MICRO_SEQ_OP_O = 3'h5;  // OP_JUMP_TABLE_A_NEXT_PC
      CV_DATA_ALU_A_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_B_SEL_O = 3'h0;  // R2
      CV_DATA_ALU_WR_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_OP_O = 3'h0;  // A_PLUS_B
      CV_DATA_WIDTH_SEL_O = 3'h0;  // W_R1
      CV_CCR_OP_O = 4'h5;  // OP_OOXOXXXX
      CV_DATA_ALU_COND_SEL_O = 2'h2;  // CARRY_BIT
    end


    // 0574: 
    // 0575: ; //////////////////////////////////////////// ADD
    // 0576: ; //
    // 0577: ADD:
    // 0578:   decode pg1_JTA ADD     $8B         ; ADDA (imm)
    // 0579:   decode pg1_R1  A       $8B         ; ADDA (imm)
    // 0580:   decode pg1_R2  IDATA   $8B         ; ADDA (imm)
    // 0581:                                                    
    // 0582:   decode pg1_JTA ADD     $CB         ; ADDB (imm)
    // 0583:   decode pg1_R1  B       $CB         ; ADDB (imm)
    // 0584:   decode pg1_R2  IDATA   $CB         ; ADDB (imm)
    // 0585:                                                    
    // 0586:   decode pg1_JTA ADD     $C3         ; ADDD (imm)
    // 0587:   decode pg1_R1  D       $C3         ; ADDD (imm)
    // 0588:   decode pg1_R2  IDATA   $C3         ; ADDD (imm)
    // 0589:                              
    // 0590:   decode pg1_JTB ADD     $9B $AB $BB ; ADDA (dir idx ext)
    // 0591:   decode pg1_R1  A       $9B $AB $BB ; ADDA (dir idx ext)
    // 0592:   decode pg1_R2  DMEM_RD $9B $AB $BB ; ADDA (dir idx ext)
    // 0593:                              
    // 0594:   decode pg1_JTB ADD     $DB $EB $FB ; ADDB (dir idx ext)
    // 0595:   decode pg1_R1  B       $DB $EB $FB ; ADDB (dir idx ext)
    // 0596:   decode pg1_R2  DMEM_RD $DB $EB $FB ; ADDB (dir idx ext)
    // 0597:                              
    // 0598:   decode pg1_JTB ADD     $D3 $E3 $F3 ; ADDD (dir idx ext)
    // 0599:   decode pg1_R1  D       $D3 $E3 $F3 ; ADDD (dir idx ext)
    // 0600:   decode pg1_R2  DMEM_RD $D3 $E3 $F3 ; ADDD (dir idx ext)
    // 0601: 
    // 0602:   DATA_ADD        R1, R2
    // 0603:   DATA_WRITE      R1
    // 0604: 
    // 0605:   SET_DATA_WIDTH  W_R1
    // 0606: 
    // 0607:   CCR_OP_W        OP_ooXoXXXX ; H is masked for 16bit
    // 0608: 
    // 0609:   JUMP_TABLE_A_NEXT_PC
    // 0610:   micro_op_end
    8'h17: begin
      CV_MICRO_SEQ_OP_O = 3'h5;  // OP_JUMP_TABLE_A_NEXT_PC
      CV_DATA_ALU_A_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_B_SEL_O = 3'h0;  // R2
      CV_DATA_ALU_WR_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_OP_O = 3'h0;  // A_PLUS_B
      CV_DATA_WIDTH_SEL_O = 3'h0;  // W_R1
      CV_CCR_OP_O = 4'h5;  // OP_OOXOXXXX
      CV_DATA_ALU_COND_SEL_O = 2'h0;  // ZERO_BIT
    end


    // 0611: 
    // 0612: 
    // 0613: ; //////////////////////////////////////////// AND
    // 0614: ; //
    // 0615: AND:
    // 0616:   decode pg1_JTA AND     $84         ; ANDA (imm)
    // 0617:   decode pg1_R1  A       $84         ; ANDA (imm)
    // 0618:   decode pg1_R2  IDATA   $84         ; ANDA (imm)
    // 0619:                                                    
    // 0620:   decode pg1_JTA AND     $C4         ; ANDB (imm)
    // 0621:   decode pg1_R1  B       $C4         ; ANDB (imm)
    // 0622:   decode pg1_R2  IDATA   $C4         ; ANDB (imm)
    // 0623:                                      
    // 0624:   decode pg1_JTB AND     $94 $A4 $B4 ; ANDA (dir idx ext)
    // 0625:   decode pg1_R1  A       $94 $A4 $B4 ; ANDA (dir idx ext)
    // 0626:   decode pg1_R2  DMEM_RD $94 $A4 $B4 ; ANDA (dir idx ext)
    // 0627:                                      
    // 0628:   decode pg1_JTB AND     $D4 $E4 $F4 ; ANDB (dir idx ext)
    // 0629:   decode pg1_R1  B       $D4 $E4 $F4 ; ANDB (dir idx ext)
    // 0630:   decode pg1_R2  DMEM_RD $D4 $E4 $F4 ; ANDB (dir idx ext)
    // 0631: 
    // 0632:   DATA_AND        R1, R2
    // 0633:   DATA_WRITE      R1
    // 0634: 
    // 0635:   SET_DATA_WIDTH  W_R1
    // 0636: 
    // 0637:   CCR_OP_W        OP_ooooXXXo 
    // 0638: 
    // 0639:   JUMP_TABLE_A_NEXT_PC
    // 0640:   micro_op_end
    8'h18: begin
      CV_MICRO_SEQ_OP_O = 3'h5;  // OP_JUMP_TABLE_A_NEXT_PC
      CV_DATA_ALU_A_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_B_SEL_O = 3'h0;  // R2
      CV_DATA_ALU_WR_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_OP_O = 3'h4;  // A_AND_B
      CV_DATA_WIDTH_SEL_O = 3'h0;  // W_R1
      CV_CCR_OP_O = 4'h4;  // OP_OOOOXXXO
      CV_DATA_ALU_COND_SEL_O = 2'h0;  // ZERO_BIT
    end


    // 0641: 
    // 0642: ANDCC:
    // 0643:   decode pg1_JTA ANDCC $1C ; ANDCC (imm)
    // 0644:   decode pg1_R1  CCR   $1C ; ANDCC (imm)
    // 0645:   decode pg1_R2  IDATA $1C ; ANDCC (imm)
    // 0646: 
    // 0647:   DATA_AND        R1, R2
    // 0648:   DATA_WRITE      R1
    // 0649: 
    // 0650:   SET_DATA_WIDTH  W_R1
    // 0651: 
    // 0652:   CCR_OP_W        OP_XXXXXXXX 
    // 0653: 
    // 0654:   JUMP_TABLE_A_NEXT_PC
    // 0655:   micro_op_end
    8'h19: begin
      CV_MICRO_SEQ_OP_O = 3'h5;  // OP_JUMP_TABLE_A_NEXT_PC
      CV_DATA_ALU_A_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_B_SEL_O = 3'h0;  // R2
      CV_DATA_ALU_WR_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_OP_O = 3'h4;  // A_AND_B
      CV_DATA_WIDTH_SEL_O = 3'h0;  // W_R1
      CV_CCR_OP_O = 4'h9;  // OP_XXXXXXXX
      CV_DATA_ALU_COND_SEL_O = 2'h0;  // ZERO_BIT
    end


    // 0656: 
    // 0657: ; //////////////////////////////////////////// BIT
    // 0658: ; //
    // 0659: BIT:
    // 0660:   decode pg1_JTA BIT     $85         ; BITA (imm)
    // 0661:   decode pg1_R1  A       $85         ; BITA (imm)
    // 0662:   decode pg1_R2  IDATA   $85         ; BITA (imm)
    // 0663:                                                 
    // 0664:   decode pg1_JTA BIT     $C5         ; BITB (imm)
    // 0665:   decode pg1_R1  B       $C5         ; BITB (imm)
    // 0666:   decode pg1_R2  IDATA   $C5         ; BITB (imm)
    // 0667:                              
    // 0668:   decode pg1_JTB BIT     $95 $A5 $B5 ; BITA (dir idx ext)
    // 0669:   decode pg1_R1  A       $95 $A5 $B5 ; BITA (dir idx ext)
    // 0670:   decode pg1_R2  DMEM_RD $95 $A5 $B5 ; BITA (dir idx ext)
    // 0671:                              
    // 0672:   decode pg1_JTB BIT     $D5 $E5 $F5 ; BITB (dir idx ext)
    // 0673:   decode pg1_R1  B       $D5 $E5 $F5 ; BITB (dir idx ext)
    // 0674:   decode pg1_R2  DMEM_RD $D5 $E5 $F5 ; BITB (dir idx ext)
    // 0675: 
    // 0676:   DATA_AND        R1, R2
    // 0677: 
    // 0678:   SET_DATA_WIDTH  W_R1
    // 0679: 
    // 0680:   CCR_OP_W        OP_ooooXXXo 
    // 0681: 
    // 0682:   JUMP_TABLE_A_NEXT_PC
    // 0683:   micro_op_end
    8'h1a: begin
      CV_MICRO_SEQ_OP_O = 3'h5;  // OP_JUMP_TABLE_A_NEXT_PC
      CV_DATA_ALU_A_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_B_SEL_O = 3'h0;  // R2
      CV_DATA_ALU_OP_O = 3'h4;  // A_AND_B
      CV_DATA_WIDTH_SEL_O = 3'h0;  // W_R1
      CV_CCR_OP_O = 4'h4;  // OP_OOOOXXXO
      CV_DATA_ALU_COND_SEL_O = 2'h0;  // ZERO_BIT
    end


    // 0684: 
    // 0685: ; //////////////////////////////////////////// CMP
    // 0686: ; //
    // 0687: CMP:
    // 0688:   decode pg1_JTA CMP     $81         ; CMPA (imm)
    // 0689:   decode pg1_R1  A       $81         ; CMPA (imm)
    // 0690:   decode pg1_R2  IDATA   $81         ; CMPA (imm)
    // 0691:                                                
    // 0692:   decode pg1_JTA CMP     $C1         ; CMPB (imm)
    // 0693:   decode pg1_R1  B       $C1         ; CMPB (imm)
    // 0694:   decode pg1_R2  IDATA   $C1         ; CMPB (imm)
    // 0695:                                                
    // 0696:   decode pg2_JTA CMP     $83         ; CMPD (imm)
    // 0697:   decode pg2_R1  D       $83         ; CMPD (imm)
    // 0698:   decode pg2_R2  IDATA   $83         ; CMPD (imm)
    // 0699:                                                
    // 0700:   decode pg3_JTA CMP     $8C         ; CMPS (imm)
    // 0701:   decode pg3_R1  S       $8C         ; CMPS (imm)
    // 0702:   decode pg3_R2  IDATA   $8C         ; CMPS (imm)
    // 0703:                                                
    // 0704:   decode pg3_JTA CMP     $83         ; CMPU (imm)
    // 0705:   decode pg3_R1  U       $83         ; CMPU (imm)
    // 0706:   decode pg3_R2  IDATA   $83         ; CMPU (imm)
    // 0707:                                                
    // 0708:   decode pg1_JTA CMP     $8C         ; CMPX (imm)
    // 0709:   decode pg1_R1  X       $8C         ; CMPX (imm)
    // 0710:   decode pg1_R2  IDATA   $8C         ; CMPX (imm)
    // 0711:                                                
    // 0712:   decode pg2_JTA CMP     $8C         ; CMPY (imm)
    // 0713:   decode pg2_R1  Y       $8C         ; CMPY (imm)
    // 0714:   decode pg2_R2  IDATA   $8C         ; CMPY (imm)
    // 0715:                              
    // 0716:   decode pg1_JTB CMP     $91 $A1 $B1 ; CMPA (dir idx ext)
    // 0717:   decode pg1_R1  A       $91 $A1 $B1 ; CMPA (dir idx ext)
    // 0718:   decode pg1_R2  DMEM_RD $91 $A1 $B1 ; CMPA (dir idx ext)
    // 0719:                              
    // 0720:   decode pg1_JTB CMP     $D1 $E1 $F1 ; CMPB (dir idx ext)
    // 0721:   decode pg1_R1  B       $D1 $E1 $F1 ; CMPB (dir idx ext)
    // 0722:   decode pg1_R2  DMEM_RD $D1 $E1 $F1 ; CMPB (dir idx ext)
    // 0723:                              
    // 0724:   decode pg2_JTB CMP     $93 $A3 $B3 ; CMPD (dir idx ext)
    // 0725:   decode pg2_R1  D       $93 $A3 $B3 ; CMPD (dir idx ext)
    // 0726:   decode pg2_R2  DMEM_RD $93 $A3 $B3 ; CMPD (dir idx ext)
    // 0727:                              
    // 0728:   decode pg3_JTB CMP     $9C $AC $BC ; CMPS (dir idx ext)
    // 0729:   decode pg3_R1  S       $9C $AC $BC ; CMPS (dir idx ext)
    // 0730:   decode pg3_R2  DMEM_RD $9C $AC $BC ; CMPS (dir idx ext)
    // 0731:                              
    // 0732:   decode pg3_JTB CMP     $93 $A3 $B3 ; CMPU (dir idx ext)
    // 0733:   decode pg3_R1  U       $93 $A3 $B3 ; CMPU (dir idx ext)
    // 0734:   decode pg3_R2  DMEM_RD $93 $A3 $B3 ; CMPU (dir idx ext)
    // 0735:                              
    // 0736:   decode pg1_JTB CMP     $9C $AC $BC ; CMPX (dir idx ext)
    // 0737:   decode pg1_R1  X       $9C $AC $BC ; CMPX (dir idx ext)
    // 0738:   decode pg1_R2  DMEM_RD $9C $AC $BC ; CMPX (dir idx ext)
    // 0739:                              
    // 0740:   decode pg2_JTB CMP     $9C $AC $BC ; CMPY (dir idx ext)
    // 0741:   decode pg2_R1  Y       $9C $AC $BC ; CMPY (dir idx ext)
    // 0742:   decode pg2_R2  DMEM_RD $9C $AC $BC ; CMPY (dir idx ext)
    // 0743: 
    // 0744:   DATA_SUB        R1, R2
    // 0745: 
    // 0746:   SET_DATA_WIDTH  W_R1
    // 0747: 
    // 0748:   CCR_OP_W        OP_ooooXXXX ; INFO: Spec H Undefined, Turbo9 H not affected
    // 0749: 
    // 0750:   JUMP_TABLE_A_NEXT_PC
    // 0751:   micro_op_end
    8'h1b: begin
      CV_MICRO_SEQ_OP_O = 3'h5;  // OP_JUMP_TABLE_A_NEXT_PC
      CV_DATA_ALU_A_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_B_SEL_O = 3'h0;  // R2
      CV_DATA_ALU_OP_O = 3'h1;  // A_PLUS_NOT_B
      CV_DATA_WIDTH_SEL_O = 3'h0;  // W_R1
      CV_CCR_OP_O = 4'h2;  // OP_OOOOXXXX
      CV_DATA_ALU_COND_SEL_O = 2'h0;  // ZERO_BIT
    end


    // 0752: 
    // 0753: ; //////////////////////////////////////////// EOR
    // 0754: ; //
    // 0755: EOR:
    // 0756:   decode pg1_JTA EOR     $88         ; EORA (imm)
    // 0757:   decode pg1_R1  A       $88         ; EORA (imm)
    // 0758:   decode pg1_R2  IDATA   $88         ; EORA (imm)
    // 0759:                                                 
    // 0760:   decode pg1_JTA EOR     $C8         ; EORB (imm)
    // 0761:   decode pg1_R1  B       $C8         ; EORB (imm)
    // 0762:   decode pg1_R2  IDATA   $C8         ; EORB (imm)
    // 0763:                              
    // 0764:   decode pg1_JTB EOR     $98 $A8 $B8 ; EORA (dir idx ext)
    // 0765:   decode pg1_R1  A       $98 $A8 $B8 ; EORA (dir idx ext)
    // 0766:   decode pg1_R2  DMEM_RD $98 $A8 $B8 ; EORA (dir idx ext)
    // 0767:                              
    // 0768:   decode pg1_JTB EOR     $D8 $E8 $F8 ; EORB (dir idx ext)
    // 0769:   decode pg1_R1  B       $D8 $E8 $F8 ; EORB (dir idx ext)
    // 0770:   decode pg1_R2  DMEM_RD $D8 $E8 $F8 ; EORB (dir idx ext)
    // 0771: 
    // 0772:   DATA_XOR        R1, R2
    // 0773:   DATA_WRITE      R1
    // 0774: 
    // 0775:   SET_DATA_WIDTH  W_R1
    // 0776: 
    // 0777:   CCR_OP_W        OP_ooooXXXo 
    // 0778: 
    // 0779:   JUMP_TABLE_A_NEXT_PC
    // 0780:   micro_op_end
    8'h1c: begin
      CV_MICRO_SEQ_OP_O = 3'h5;  // OP_JUMP_TABLE_A_NEXT_PC
      CV_DATA_ALU_A_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_B_SEL_O = 3'h0;  // R2
      CV_DATA_ALU_WR_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_OP_O = 3'h6;  // A_XOR_B
      CV_DATA_WIDTH_SEL_O = 3'h0;  // W_R1
      CV_CCR_OP_O = 4'h4;  // OP_OOOOXXXO
      CV_DATA_ALU_COND_SEL_O = 2'h0;  // ZERO_BIT
    end


    // 0781: 
    // 0782: ; //////////////////////////////////////////// LD
    // 0783: ; //
    // 0784: LD:
    // 0785:   decode pg1_JTA LD      $86         ; LDA (imm)
    // 0786:   decode pg1_R1  A       $86         ; LDA (imm)
    // 0787:   decode pg1_R2  IDATA   $86         ; LDA (imm)
    // 0788:                                                 
    // 0789:   decode pg1_JTA LD      $C6         ; LDB (imm)
    // 0790:   decode pg1_R1  B       $C6         ; LDB (imm)
    // 0791:   decode pg1_R2  IDATA   $C6         ; LDB (imm)
    // 0792:                                                 
    // 0793:   decode pg1_JTA LD      $CC         ; LDD (imm)
    // 0794:   decode pg1_R1  D       $CC         ; LDD (imm)
    // 0795:   decode pg1_R2  IDATA   $CC         ; LDD (imm)
    // 0796:                                                 
    // 0797:   decode pg2_JTA LD      $CE         ; LDS (imm)
    // 0798:   decode pg2_R1  S       $CE         ; LDS (imm)
    // 0799:   decode pg2_R2  IDATA   $CE         ; LDS (imm)
    // 0800:                                                 
    // 0801:   decode pg1_JTA LD      $CE         ; LDU (imm)
    // 0802:   decode pg1_R1  U       $CE         ; LDU (imm)
    // 0803:   decode pg1_R2  IDATA   $CE         ; LDU (imm)
    // 0804:                                                 
    // 0805:   decode pg1_JTA LD      $8E         ; LDX (imm)
    // 0806:   decode pg1_R1  X       $8E         ; LDX (imm)
    // 0807:   decode pg1_R2  IDATA   $8E         ; LDX (imm)
    // 0808:                                                 
    // 0809:   decode pg2_JTA LD      $8E         ; LDY (imm)
    // 0810:   decode pg2_R1  Y       $8E         ; LDY (imm)
    // 0811:   decode pg2_R2  IDATA   $8E         ; LDY (imm)
    // 0812:                              
    // 0813:   decode pg1_JTB LD      $96 $A6 $B6 ; LDA (dir idx ext)
    // 0814:   decode pg1_R1  A       $96 $A6 $B6 ; LDA (dir idx ext)
    // 0815:   decode pg1_R2  DMEM_RD $96 $A6 $B6 ; LDA (dir idx ext)
    // 0816:                              
    // 0817:   decode pg1_JTB LD      $D6 $E6 $F6 ; LDB (dir idx ext)
    // 0818:   decode pg1_R1  B       $D6 $E6 $F6 ; LDB (dir idx ext)
    // 0819:   decode pg1_R2  DMEM_RD $D6 $E6 $F6 ; LDB (dir idx ext)
    // 0820:                              
    // 0821:   decode pg1_JTB LD      $DC $EC $FC ; LDD (dir idx ext)
    // 0822:   decode pg1_R1  D       $DC $EC $FC ; LDD (dir idx ext)
    // 0823:   decode pg1_R2  DMEM_RD $DC $EC $FC ; LDD (dir idx ext)
    // 0824:                              
    // 0825:   decode pg2_JTB LD      $DE $EE $FE ; LDS (dir idx ext)
    // 0826:   decode pg2_R1  S       $DE $EE $FE ; LDS (dir idx ext)
    // 0827:   decode pg2_R2  DMEM_RD $DE $EE $FE ; LDS (dir idx ext)
    // 0828:                              
    // 0829:   decode pg1_JTB LD      $DE $EE $FE ; LDU (dir idx ext)
    // 0830:   decode pg1_R1  U       $DE $EE $FE ; LDU (dir idx ext)
    // 0831:   decode pg1_R2  DMEM_RD $DE $EE $FE ; LDU (dir idx ext)
    // 0832:                              
    // 0833:   decode pg1_JTB LD      $9E $AE $BE ; LDX (dir idx ext)
    // 0834:   decode pg1_R1  X       $9E $AE $BE ; LDX (dir idx ext)
    // 0835:   decode pg1_R2  DMEM_RD $9E $AE $BE ; LDX (dir idx ext)
    // 0836:                              
    // 0837:   decode pg2_JTB LD      $9E $AE $BE ; LDY (dir idx ext)
    // 0838:   decode pg2_R1  Y       $9E $AE $BE ; LDY (dir idx ext)
    // 0839:   decode pg2_R2  DMEM_RD $9E $AE $BE ; LDY (dir idx ext)
    // 0840: 
    // 0841:   DATA_PASS_B     R2
    // 0842:   DATA_WRITE      R1
    // 0843: 
    // 0844:   SET_DATA_WIDTH  W_R1
    // 0845: 
    // 0846:   CCR_OP_W        OP_ooooXXXo
    // 0847: 
    // 0848:   JUMP_TABLE_A_NEXT_PC
    // 0849:   micro_op_end
    8'h1d: begin
      CV_MICRO_SEQ_OP_O = 3'h5;  // OP_JUMP_TABLE_A_NEXT_PC
      CV_DATA_ALU_A_SEL_O = 4'hf;  // ZERO
      CV_DATA_ALU_B_SEL_O = 3'h0;  // R2
      CV_DATA_ALU_WR_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_OP_O = 3'h0;  // A_PLUS_B
      CV_DATA_WIDTH_SEL_O = 3'h0;  // W_R1
      CV_CCR_OP_O = 4'h4;  // OP_OOOOXXXO
      CV_DATA_ALU_COND_SEL_O = 2'h0;  // ZERO_BIT
    end


    // 0850: 
    // 0851: ; //////////////////////////////////////////// OR
    // 0852: ; //
    // 0853: OR:
    // 0854:   decode pg1_JTA OR      $8A         ; ORA (imm)
    // 0855:   decode pg1_R1  A       $8A         ; ORA (imm)
    // 0856:   decode pg1_R2  IDATA   $8A         ; ORA (imm)
    // 0857:                                                 
    // 0858:   decode pg1_JTA OR      $CA         ; ORB (imm)
    // 0859:   decode pg1_R1  B       $CA         ; ORB (imm)
    // 0860:   decode pg1_R2  IDATA   $CA         ; ORB (imm)
    // 0861:                              
    // 0862:   decode pg1_JTB OR      $9A $AA $BA ; ORA (dir idx ext)
    // 0863:   decode pg1_R1  A       $9A $AA $BA ; ORA (dir idx ext)
    // 0864:   decode pg1_R2  DMEM_RD $9A $AA $BA ; ORA (dir idx ext)
    // 0865:                              
    // 0866:   decode pg1_JTB OR      $DA $EA $FA ; ORB (dir idx ext)
    // 0867:   decode pg1_R1  B       $DA $EA $FA ; ORB (dir idx ext)
    // 0868:   decode pg1_R2  DMEM_RD $DA $EA $FA ; ORB (dir idx ext)
    // 0869: 
    // 0870:   DATA_OR         R1, R2
    // 0871:   DATA_WRITE      R1
    // 0872: 
    // 0873:   SET_DATA_WIDTH  W_R1
    // 0874: 
    // 0875:   CCR_OP_W        OP_ooooXXXo 
    // 0876: 
    // 0877:   JUMP_TABLE_A_NEXT_PC
    // 0878:   micro_op_end
    8'h1e: begin
      CV_MICRO_SEQ_OP_O = 3'h5;  // OP_JUMP_TABLE_A_NEXT_PC
      CV_DATA_ALU_A_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_B_SEL_O = 3'h0;  // R2
      CV_DATA_ALU_WR_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_OP_O = 3'h5;  // A_OR_B
      CV_DATA_WIDTH_SEL_O = 3'h0;  // W_R1
      CV_CCR_OP_O = 4'h4;  // OP_OOOOXXXO
      CV_DATA_ALU_COND_SEL_O = 2'h0;  // ZERO_BIT
    end


    // 0879: 
    // 0880: ORCC:
    // 0881:   decode pg1_JTA ORCC  $1A ; ORCC (imm)
    // 0882:   decode pg1_R1  CCR   $1A ; ORCC (imm)
    // 0883:   decode pg1_R2  IDATA $1A ; ORCC (imm)
    // 0884: 
    // 0885:   DATA_OR         R1, R2   
    // 0886:   DATA_WRITE      R1
    // 0887: 
    // 0888:   SET_DATA_WIDTH  W_R1
    // 0889: 
    // 0890:   CCR_OP_W        OP_XXXXXXXX 
    // 0891: 
    // 0892:   JUMP_TABLE_A_NEXT_PC
    // 0893:   micro_op_end
    8'h1f: begin
      CV_MICRO_SEQ_OP_O = 3'h5;  // OP_JUMP_TABLE_A_NEXT_PC
      CV_DATA_ALU_A_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_B_SEL_O = 3'h0;  // R2
      CV_DATA_ALU_WR_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_OP_O = 3'h5;  // A_OR_B
      CV_DATA_WIDTH_SEL_O = 3'h0;  // W_R1
      CV_CCR_OP_O = 4'h9;  // OP_XXXXXXXX
      CV_DATA_ALU_COND_SEL_O = 2'h0;  // ZERO_BIT
    end


    // 0894: 
    // 0895: ; //////////////////////////////////////////// SBC
    // 0896: ; //
    // 0897: SBC:
    // 0898:   decode pg1_JTA SBC     $82         ; SBCA (imm)
    // 0899:   decode pg1_R1  A       $82         ; SBCA (imm)
    // 0900:   decode pg1_R2  IDATA   $82         ; SBCA (imm)
    // 0901:                                                 
    // 0902:   decode pg1_JTA SBC     $C2         ; SBCB (imm)
    // 0903:   decode pg1_R1  B       $C2         ; SBCB (imm)
    // 0904:   decode pg1_R2  IDATA   $C2         ; SBCB (imm)
    // 0905:                              
    // 0906:   decode pg1_JTB SBC     $92 $A2 $B2 ; SBCA (dir idx ext)
    // 0907:   decode pg1_R1  A       $92 $A2 $B2 ; SBCA (dir idx ext)
    // 0908:   decode pg1_R2  DMEM_RD $92 $A2 $B2 ; SBCA (dir idx ext)
    // 0909:                                                      
    // 0910:   decode pg1_JTB SBC     $D2 $E2 $F2 ; SBCB (dir idx ext)
    // 0911:   decode pg1_R1  B       $D2 $E2 $F2 ; SBCB (dir idx ext)
    // 0912:   decode pg1_R2  DMEM_RD $D2 $E2 $F2 ; SBCB (dir idx ext)
    // 0913: 
    // 0914:   DATA_SUBC       R1, R2
    // 0915:   DATA_WRITE      R1
    // 0916: 
    // 0917:   SET_DATA_WIDTH  W_R1
    // 0918: 
    // 0919:   CCR_OP_W        OP_ooooXXXX ; INFO: Spec H Undefined, Turbo9 H not affected
    // 0920: 
    // 0921:   JUMP_TABLE_A_NEXT_PC
    // 0922:   micro_op_end
    8'h20: begin
      CV_MICRO_SEQ_OP_O = 3'h5;  // OP_JUMP_TABLE_A_NEXT_PC
      CV_DATA_ALU_A_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_B_SEL_O = 3'h0;  // R2
      CV_DATA_ALU_WR_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_OP_O = 3'h1;  // A_PLUS_NOT_B
      CV_DATA_WIDTH_SEL_O = 3'h0;  // W_R1
      CV_CCR_OP_O = 4'h2;  // OP_OOOOXXXX
      CV_DATA_ALU_COND_SEL_O = 2'h2;  // CARRY_BIT
    end


    // 0923: 
    // 0924: ; //////////////////////////////////////////// SUB
    // 0925: ; //
    // 0926: SUB:
    // 0927:   decode pg1_JTA SUB     $80         ; SUBA (imm)
    // 0928:   decode pg1_R1  A       $80         ; SUBA (imm)
    // 0929:   decode pg1_R2  IDATA   $80         ; SUBA (imm)
    // 0930:                                                 
    // 0931:   decode pg1_JTA SUB     $C0         ; SUBB (imm)
    // 0932:   decode pg1_R1  B       $C0         ; SUBB (imm)
    // 0933:   decode pg1_R2  IDATA   $C0         ; SUBB (imm)
    // 0934:                                                 
    // 0935:   decode pg1_JTA SUB     $83         ; SUBD (imm)
    // 0936:   decode pg1_R1  D       $83         ; SUBD (imm)
    // 0937:   decode pg1_R2  IDATA   $83         ; SUBD (imm)
    // 0938:                              
    // 0939:   decode pg1_JTB SUB     $90 $A0 $B0 ; SUBA (dir idx ext)
    // 0940:   decode pg1_R1  A       $90 $A0 $B0 ; SUBA (dir idx ext)
    // 0941:   decode pg1_R2  DMEM_RD $90 $A0 $B0 ; SUBA (dir idx ext)
    // 0942:                                                       
    // 0943:   decode pg1_JTB SUB     $D0 $E0 $F0 ; SUBB (dir idx ext)
    // 0944:   decode pg1_R1  B       $D0 $E0 $F0 ; SUBB (dir idx ext)
    // 0945:   decode pg1_R2  DMEM_RD $D0 $E0 $F0 ; SUBB (dir idx ext)
    // 0946:                                                       
    // 0947:   decode pg1_JTB SUB     $93 $A3 $B3 ; SUBD (dir idx ext)
    // 0948:   decode pg1_R1  D       $93 $A3 $B3 ; SUBD (dir idx ext)
    // 0949:   decode pg1_R2  DMEM_RD $93 $A3 $B3 ; SUBD (dir idx ext)
    // 0950: 
    // 0951:   DATA_SUB        R1, R2
    // 0952:   DATA_WRITE      R1
    // 0953: 
    // 0954:   SET_DATA_WIDTH  W_R1
    // 0955: 
    // 0956:   CCR_OP_W        OP_ooooXXXX ; INFO: Spec H Undefined, Turbo9 H not affected (8-bit)
    // 0957: 
    // 0958:   JUMP_TABLE_A_NEXT_PC
    // 0959:   micro_op_end
    8'h21: begin
      CV_MICRO_SEQ_OP_O = 3'h5;  // OP_JUMP_TABLE_A_NEXT_PC
      CV_DATA_ALU_A_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_B_SEL_O = 3'h0;  // R2
      CV_DATA_ALU_WR_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_OP_O = 3'h1;  // A_PLUS_NOT_B
      CV_DATA_WIDTH_SEL_O = 3'h0;  // W_R1
      CV_CCR_OP_O = 4'h2;  // OP_OOOOXXXX
      CV_DATA_ALU_COND_SEL_O = 2'h0;  // ZERO_BIT
    end


    // 0960: 
    // 0961: 
    // 0962: ; //
    // 0963: ; ////////////////////////////////////////////////////////////////////////////
    // 0964: 
    // 0965: 
    // 0966: ; ////////////////////////////////////////////////////////////////////////////
    // 0967: ;                        STORE INSTRUCTIONS
    // 0968: ; ////////////////////////////////////////////////////////////////////////////
    // 0969: ; //
    // 0970: 
    // 0971: ; //////////////////////////////////////////// ST
    // 0972: ; //
    // 0973: ST:
    // 0974:   decode pg1_JTA ST    $97 $B7 ; STA (dir ext)
    // 0975:   decode pg1_R1  A     $97 $B7 ; STA (dir ext)
    // 0976:   decode pg1_AR  IDATA $97 $B7 ; STA (dir ext)
    // 0977:                            
    // 0978:   decode pg1_JTA ST    $D7 $F7 ; STB (dir ext)
    // 0979:   decode pg1_R1  B     $D7 $F7 ; STB (dir ext)
    // 0980:   decode pg1_AR  IDATA $D7 $F7 ; STB (dir ext)
    // 0981:                            
    // 0982:   decode pg1_JTA ST    $DD $FD ; STD (dir ext)
    // 0983:   decode pg1_R1  D     $DD $FD ; STD (dir ext)
    // 0984:   decode pg1_AR  IDATA $DD $FD ; STD (dir ext)
    // 0985:                            
    // 0986:   decode pg2_JTA ST    $DF $FF ; STS (dir ext)
    // 0987:   decode pg2_R1  S     $DF $FF ; STS (dir ext)
    // 0988:   decode pg2_AR  IDATA $DF $FF ; STS (dir ext)
    // 0989:                            
    // 0990:   decode pg1_JTA ST    $DF $FF ; STU (dir ext)
    // 0991:   decode pg1_R1  U     $DF $FF ; STU (dir ext)
    // 0992:   decode pg1_AR  IDATA $DF $FF ; STU (dir ext)
    // 0993:                            
    // 0994:   decode pg1_JTA ST    $9F $BF ; STX (dir ext)
    // 0995:   decode pg1_R1  X     $9F $BF ; STX (dir ext)
    // 0996:   decode pg1_AR  IDATA $9F $BF ; STX (dir ext)
    // 0997:                            
    // 0998:   decode pg2_JTA ST    $9F $BF ; STY (dir ext)
    // 0999:   decode pg2_R1  Y     $9F $BF ; STY (dir ext)
    // 1000:   decode pg2_AR  IDATA $9F $BF ; STY (dir ext)
    // 1001:                            
    // 1002:   decode pg1_JTB ST    $A7     ; STA (idx)
    // 1003:   decode pg1_R1  A     $A7     ; STA (idx)
    // 1004:   decode pg1_AR  EA    $A7     ; STA (idx)
    // 1005:                                    
    // 1006:   decode pg1_JTB ST    $E7     ; STB (idx)
    // 1007:   decode pg1_R1  B     $E7     ; STB (idx)
    // 1008:   decode pg1_AR  EA    $E7     ; STB (idx)
    // 1009:                                    
    // 1010:   decode pg1_JTB ST    $ED     ; STD (idx)
    // 1011:   decode pg1_R1  D     $ED     ; STD (idx)
    // 1012:   decode pg1_AR  EA    $ED     ; STD (idx)
    // 1013:                                    
    // 1014:   decode pg2_JTB ST    $EF     ; STS (idx)
    // 1015:   decode pg2_R1  S     $EF     ; STS (idx)
    // 1016:   decode pg2_AR  EA    $EF     ; STS (idx)
    // 1017:                                    
    // 1018:   decode pg1_JTB ST    $EF     ; STU (idx)
    // 1019:   decode pg1_R1  U     $EF     ; STU (idx)
    // 1020:   decode pg1_AR  EA    $EF     ; STU (idx)
    // 1021:                                    
    // 1022:   decode pg1_JTB ST    $AF     ; STX (idx)
    // 1023:   decode pg1_R1  X     $AF     ; STX (idx)
    // 1024:   decode pg1_AR  EA    $AF     ; STX (idx)
    // 1025:                                    
    // 1026:   decode pg2_JTB ST    $AF     ; STY (idx)
    // 1027:   decode pg2_R1  Y     $AF     ; STY (idx)
    // 1028:   decode pg2_AR  EA    $AF     ; STY (idx)
    // 1029: 
    // 1030:   DATA_PASS_A     R1
    // 1031: 
    // 1032:   SET_DATA_WIDTH  W_R1
    // 1033: 
    // 1034:   CCR_OP_W        OP_ooooXXXo
    // 1035: 
    // 1036:   ADDR_PASS       AR
    // 1037:   DMEM_STORE_W
    // 1038: 
    // 1039:   JUMP_TABLE_A_NEXT_PC
    // 1040:   micro_op_end
    8'h22: begin
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


    // 1041: 
    // 1042: ; //
    // 1043: ; ////////////////////////////////////////////////////////////////////////////
    // 1044: 
    // 1045: 
    // 1046: ; ////////////////////////////////////////////////////////////////////////////
    // 1047: ;                   MODIFY MEMORY OR ACCUMULATOR INSTRUCTIONS
    // 1048: ; ////////////////////////////////////////////////////////////////////////////
    // 1049: ; //
    // 1050: 
    // 1051: ; //////////////////////////////////////////// ASL LSL
    // 1052: ; //
    // 1053: ASL_LSL:
    // 1054:   decode pg1_JTA ASL_LSL $48         ; ASLA LSLA (inh)
    // 1055:   decode pg1_R1  A       $48         ; ASLA LSLA (inh)
    // 1056:                                         
    // 1057:   decode pg1_JTA ASL_LSL $58         ; ASLB LSLB (inh)
    // 1058:   decode pg1_R1  B       $58         ; ASLB LSLB (inh)
    // 1059:                              
    // 1060:   decode pg1_JTB ASL_LSL $08 $68 $78 ; ASL LSL (dir idx ext)
    // 1061:   decode pg1_R1  DMEM_RD $08 $68 $78 ; ASL LSL (dir idx ext)
    // 1062: 
    // 1063:   DATA_LSHIFT_W   R1, ZERO_BIT
    // 1064:   DATA_WRITE      R1
    // 1065: 
    // 1066:   SET_DATA_WIDTH  W_R1
    // 1067: 
    // 1068:   CCR_OP_W        OP_ooooXXXX ; INFO: Spec H Undefined, Turbo9 H not affected
    // 1069: 
    // 1070:   ADDR_PASS       EA
    // 1071:   DMEM_STORE_W ; Disabled for inherent addressing modes
    // 1072: 
    // 1073:   JUMP_TABLE_A_NEXT_PC
    // 1074:   micro_op_end
    8'h23: begin
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


    // 1075: 
    // 1076: ; //////////////////////////////////////////// ASR
    // 1077: ; //
    // 1078: ASR:
    // 1079:   decode pg1_JTA ASR     $47         ; ASRA (inh)
    // 1080:   decode pg1_R1  A       $47         ; ASRA (inh)
    // 1081:                                          
    // 1082:   decode pg1_JTA ASR     $57         ; ASRB (inh)
    // 1083:   decode pg1_R1  B       $57         ; ASRB (inh)
    // 1084:                              
    // 1085:   decode pg1_JTB ASR     $07 $67 $77 ; ASR (dir idx ext)
    // 1086:   decode pg1_R1  DMEM_RD $07 $67 $77 ; ASR (dir idx ext)
    // 1087: 
    // 1088:   DATA_RSHIFT_W   SIGN_BIT, R1
    // 1089:   DATA_WRITE      R1
    // 1090: 
    // 1091:   SET_DATA_WIDTH  W_R1
    // 1092: 
    // 1093:   CCR_OP_W        OP_ooooXXoX ; INFO: Spec H Undefined, Turbo9 H not affected
    // 1094: 
    // 1095:   ADDR_PASS       EA
    // 1096:   DMEM_STORE_W  ; Disabled for inherent addressing modes
    // 1097: 
    // 1098:   JUMP_TABLE_A_NEXT_PC
    // 1099:   micro_op_end
    8'h24: begin
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


    // 1100: 
    // 1101: ; //////////////////////////////////////////// CLR
    // 1102: ; //
    // 1103: ; // This is a little different than other memory modify
    // 1104: ; // instructions. It does not load the memory first like
    // 1105: ; // the 6809. It just writes a zero to be more efficient
    // 1106: CLR:
    // 1107: 
    // 1108:   decode pg1_JTA CLR     $4F     ; CLRA (inh)
    // 1109:   decode pg1_R1  A       $4F     ; CLRA (inh)
    // 1110:                                      
    // 1111:   decode pg1_JTA CLR     $5F     ; CLRB (inh)
    // 1112:   decode pg1_R1  B       $5F     ; CLRB (inh)
    // 1113:                            
    // 1114:   decode pg1_JTA CLR     $0F $7F ; CLR (dir ext)
    // 1115:   decode pg1_R1  DMEM_RD $0F $7F ; CLR (dir ext) sets 8bit width
    // 1116:   decode pg1_AR  IDATA   $0F $7F ; CLR (dir ext)
    // 1117:                            
    // 1118:   decode pg1_JTB CLR     $6F     ; CLR (idx)
    // 1119:   decode pg1_R1  DMEM_RD $6F     ; CLR (idx) sets 8bit width
    // 1120:   decode pg1_AR  EA      $6F     ; CLR (idx)
    // 1121: 
    // 1122:   DATA_PASS_B     ZERO 
    // 1123:   DATA_WRITE      R1
    // 1124: 
    // 1125:   SET_DATA_WIDTH  W_R1
    // 1126: 
    // 1127:   CCR_OP_W        OP_ooooXXXX
    // 1128: 
    // 1129:   ADDR_PASS       AR
    // 1130:   DMEM_STORE_W  ; Disabled for inherent addressing modes
    // 1131: 
    // 1132:   JUMP_TABLE_A_NEXT_PC
    // 1133:   micro_op_end
    8'h25: begin
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


    // 1134: 
    // 1135: ; //////////////////////////////////////////// COM
    // 1136: ; //
    // 1137: COM:
    // 1138:   decode pg1_JTA COM     $43         ; COMA (inh)
    // 1139:   decode pg1_R1  A       $43         ; COMA (inh)
    // 1140:   decode pg1_R2  A       $43         ; COMA (inh)
    // 1141:                                          
    // 1142:   decode pg1_JTA COM     $53         ; COMB (inh)
    // 1143:   decode pg1_R1  B       $53         ; COMB (inh)
    // 1144:   decode pg1_R2  B       $53         ; COMB (inh)
    // 1145:                              
    // 1146:   decode pg1_JTB COM     $03 $63 $73 ; COM (dir idx ext)
    // 1147:   decode pg1_R1  DMEM_RD $03 $63 $73 ; COM (dir idx ext) sets 8bit width
    // 1148:   decode pg1_R2  DMEM_RD $03 $63 $73 ; COM (dir idx ext)
    // 1149: 
    // 1150:   DATA_INVERT_B   R2
    // 1151:   DATA_WRITE      R1
    // 1152: 
    // 1153:   SET_DATA_WIDTH  W_R1
    // 1154: 
    // 1155:   CCR_OP_W        OP_ooooXXXX ; INFO Carry should be set to 1 for 6800 compatibility
    // 1156: 
    // 1157:   ADDR_PASS       EA
    // 1158:   DMEM_STORE_W ; Disabled for inherent addressing modes
    // 1159: 
    // 1160:   JUMP_TABLE_A_NEXT_PC
    // 1161:   micro_op_end
    8'h26: begin
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


    // 1162: 
    // 1163: ; //////////////////////////////////////////// DEC
    // 1164: ; //
    // 1165: DEC:
    // 1166:   decode pg1_JTA DEC     $4A         ; DECA (inh)
    // 1167:   decode pg1_R1  A       $4A         ; DECA (inh)
    // 1168:                                          
    // 1169:   decode pg1_JTA DEC     $5A         ; DECB (inh)
    // 1170:   decode pg1_R1  B       $5A         ; DECB (inh)
    // 1171:                              
    // 1172:   decode pg1_JTB DEC     $0A $6A $7A ; DEC (dir idx ext)
    // 1173:   decode pg1_R1  DMEM_RD $0A $6A $7A ; DEC (dir idx ext)
    // 1174: 
    // 1175:   DATA_DEC        R1
    // 1176:   DATA_WRITE      R1
    // 1177: 
    // 1178:   SET_DATA_WIDTH  W_R1
    // 1179:   
    // 1180:   CCR_OP_W        OP_ooooXXXo
    // 1181: 
    // 1182:   ADDR_PASS       EA
    // 1183:   DMEM_STORE_W ; Disabled for inherent addressing modes
    // 1184: 
    // 1185:   JUMP_TABLE_A_NEXT_PC
    // 1186:   micro_op_end
    8'h27: begin
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


    // 1187: 
    // 1188: ; //////////////////////////////////////////// INC
    // 1189: ; //
    // 1190: INC:
    // 1191:   decode pg1_JTA INC     $4C         ; INCA (inh)
    // 1192:   decode pg1_R1  A       $4C         ; INCA (inh)
    // 1193:                                          
    // 1194:   decode pg1_JTA INC     $5C         ; INCB (inh)
    // 1195:   decode pg1_R1  B       $5C         ; INCB (inh)
    // 1196:                              
    // 1197:   decode pg1_JTB INC     $0C $6C $7C ; INC (dir idx ext)
    // 1198:   decode pg1_R1  DMEM_RD $0C $6C $7C ; INC (dir idx ext)
    // 1199: 
    // 1200:   DATA_INC        R1
    // 1201:   DATA_WRITE      R1
    // 1202: 
    // 1203:   SET_DATA_WIDTH  W_R1
    // 1204: 
    // 1205:   CCR_OP_W        OP_ooooXXXo
    // 1206: 
    // 1207:   ADDR_PASS       EA
    // 1208:   DMEM_STORE_W ; Disabled for inherent addressing modes
    // 1209: 
    // 1210:   JUMP_TABLE_A_NEXT_PC
    // 1211:   micro_op_end
    8'h28: begin
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


    // 1212: 
    // 1213: ; //////////////////////////////////////////// LSR
    // 1214: ; //
    // 1215: LSR:
    // 1216:   decode pg1_JTA LSR     $44         ; LSRA (inh)
    // 1217:   decode pg1_R1  A       $44         ; LSRA (inh)
    // 1218:                                          
    // 1219:   decode pg1_JTA LSR     $54         ; LSRB (inh)
    // 1220:   decode pg1_R1  B       $54         ; LSRB (inh)
    // 1221:                              
    // 1222:   decode pg1_JTB LSR     $04 $64 $74 ; LSR (dir idx ext)
    // 1223:   decode pg1_R1  DMEM_RD $04 $64 $74 ; LSR (dir idx ext)
    // 1224: 
    // 1225:   DATA_RSHIFT_W   ZERO_BIT, R1
    // 1226:   DATA_WRITE      R1
    // 1227: 
    // 1228:   SET_DATA_WIDTH  W_R1
    // 1229: 
    // 1230:   CCR_OP_W        OP_ooooXXoX
    // 1231: 
    // 1232:   ADDR_PASS       EA
    // 1233:   DMEM_STORE_W ; Disabled for inherent addressing modes
    // 1234: 
    // 1235:   JUMP_TABLE_A_NEXT_PC
    // 1236:   micro_op_end
    8'h29: begin
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


    // 1237: 
    // 1238: ; //////////////////////////////////////////// NEG
    // 1239: ; //
    // 1240: NEG:
    // 1241:   decode pg1_JTA NEG     $40         ; NEGA (inh)
    // 1242:   decode pg1_R1  A       $40         ; NEGA (inh)
    // 1243:   decode pg1_R2  A       $40         ; NEGA (inh)
    // 1244:                                          
    // 1245:   decode pg1_JTA NEG     $50         ; NEGB (inh)
    // 1246:   decode pg1_R1  B       $50         ; NEGB (inh)
    // 1247:   decode pg1_R2  B       $50         ; NEGB (inh)
    // 1248:                                          
    // 1249:   decode pg1_JTB NEG     $00 $60 $70 ; NEG (dir idx ext)
    // 1250:   decode pg1_R1  DMEM_RD $00 $60 $70 ; NEG (dir idx ext) sets 8bit width
    // 1251:   decode pg1_R2  DMEM_RD $00 $60 $70 ; NEG (dir idx ext)
    // 1252: 
    // 1253:   DATA_SUB        ZERO, R2
    // 1254:   DATA_WRITE      R1
    // 1255: 
    // 1256:   SET_DATA_WIDTH  W_R1
    // 1257: 
    // 1258:   CCR_OP_W        OP_ooooXXXX ; INFO: Spec H Undefined, Turbo9 H not affected
    // 1259: 
    // 1260:   ADDR_PASS       EA
    // 1261:   DMEM_STORE_W ; Disabled for inherent addressing modes
    // 1262: 
    // 1263:   JUMP_TABLE_A_NEXT_PC
    // 1264:   micro_op_end
    8'h2a: begin
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


    // 1265: 
    // 1266: ; //////////////////////////////////////////// ROL
    // 1267: ; //
    // 1268: ROL:
    // 1269:   decode pg1_JTA ROL     $49         ; ROLA (inh)
    // 1270:   decode pg1_R1  A       $49         ; ROLA (inh)
    // 1271:                                          
    // 1272:   decode pg1_JTA ROL     $59         ; ROLB (inh)
    // 1273:   decode pg1_R1  B       $59         ; ROLB (inh)
    // 1274:                                          
    // 1275:   decode pg1_JTB ROL     $09 $69 $79 ; ROL (dir idx ext)
    // 1276:   decode pg1_R1  DMEM_RD $09 $69 $79 ; ROL (dir idx ext)
    // 1277: 
    // 1278:   DATA_LSHIFT_W   R1, CARRY_BIT
    // 1279:   DATA_WRITE      R1
    // 1280: 
    // 1281:   SET_DATA_WIDTH  W_R1
    // 1282: 
    // 1283:   CCR_OP_W        OP_ooooXXXX
    // 1284: 
    // 1285:   ADDR_PASS       EA
    // 1286:   DMEM_STORE_W ; Disabled for inherent addressing modes
    // 1287: 
    // 1288:   JUMP_TABLE_A_NEXT_PC
    // 1289:   micro_op_end
    8'h2b: begin
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


    // 1290: 
    // 1291: ; //////////////////////////////////////////// ROR
    // 1292: ; //
    // 1293: ROR:
    // 1294:   decode pg1_JTA ROR     $46         ; RORA (inh)
    // 1295:   decode pg1_R1  A       $46         ; RORA (inh)
    // 1296:                                                    
    // 1297:   decode pg1_JTA ROR     $56         ; RORB (inh)
    // 1298:   decode pg1_R1  B       $56         ; RORB (inh)
    // 1299:                              
    // 1300:   decode pg1_JTB ROR     $06 $66 $76 ; ROR (dir idx ext)
    // 1301:   decode pg1_R1  DMEM_RD $06 $66 $76 ; ROR (dir idx ext)
    // 1302: 
    // 1303:   DATA_RSHIFT_W   CARRY_BIT, R1
    // 1304:   DATA_WRITE      R1
    // 1305: 
    // 1306:   SET_DATA_WIDTH  W_R1
    // 1307: 
    // 1308:   CCR_OP_W        OP_ooooXXoX
    // 1309: 
    // 1310:   ADDR_PASS       EA
    // 1311:   DMEM_STORE_W ; Disabled for inherent addressing modes
    // 1312: 
    // 1313:   JUMP_TABLE_A_NEXT_PC
    // 1314:   micro_op_end
    8'h2c: begin
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


    // 1315: 
    // 1316: ; //////////////////////////////////////////// TST
    // 1317: ; //
    // 1318: TST:
    // 1319:   decode pg1_JTA TST     $4D         ; TSTA (inh)
    // 1320:   decode pg1_R1  A       $4D         ; TSTA (inh)
    // 1321:                                          
    // 1322:   decode pg1_JTA TST     $5D         ; TSTB (inh)
    // 1323:   decode pg1_R1  B       $5D         ; TSTB (inh)
    // 1324:                              
    // 1325:   decode pg1_JTB TST     $0D $6D $7D ; TST (dir idx ext)
    // 1326:   decode pg1_R1  DMEM_RD $0D $6D $7D ; TST (dir idx ext)
    // 1327: 
    // 1328:   DATA_PASS_A     R1 ; Pass A, B or DMEM
    // 1329: 
    // 1330:   SET_DATA_WIDTH  W_R1
    // 1331: 
    // 1332:   CCR_OP_W        OP_ooooXXXo
    // 1333: 
    // 1334:   JUMP_TABLE_A_NEXT_PC
    // 1335:   micro_op_end
    8'h2d: begin
      CV_MICRO_SEQ_OP_O = 3'h5;  // OP_JUMP_TABLE_A_NEXT_PC
      CV_DATA_ALU_A_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_B_SEL_O = 3'h7;  // ZERO
      CV_DATA_ALU_OP_O = 3'h0;  // A_PLUS_B
      CV_DATA_WIDTH_SEL_O = 3'h0;  // W_R1
      CV_CCR_OP_O = 4'h4;  // OP_OOOOXXXO
      CV_DATA_ALU_COND_SEL_O = 2'h0;  // ZERO_BIT
    end


    // 1336: 
    // 1337: ; //
    // 1338: ; ////////////////////////////////////////////////////////////////////////////
    // 1339: 
    // 1340: 
    // 1341: 
    // 1342: ; ////////////////////////////////////////////////////////////////////////////
    // 1343: ;                        JUMP & BRANCH INSTRUCTIONS
    // 1344: ; ////////////////////////////////////////////////////////////////////////////
    // 1345: ; //
    // 1346: 
    // 1347: ; //////////////////////////////////////////// BRANCH
    // 1348: ; //
    // 1349: BRANCH:
    // 1350:   decode pg1_JTA BRANCH $20 $21 $22 $23 ; BRA BRN BHI BLS
    // 1351:   decode pg1_JTB JMP    $20 $21 $22 $23 ; BRA BRN BHI BLS
    // 1352:   decode pg1_R1  PC     $20 $21 $22 $23 ; BRA BRN BHI BLS
    // 1353:   decode pg1_R2  EA     $20 $21 $22 $23 ; BRA BRN BHI BLS
    // 1354:                                             
    // 1355:   decode pg1_JTA BRANCH $24 $25 $26 $27 ; BCC BCS BNE BEQ
    // 1356:   decode pg1_JTB JMP    $24 $25 $26 $27 ; BCC BCS BNE BEQ
    // 1357:   decode pg1_R1  PC     $24 $25 $26 $27 ; BCC BCS BNE BEQ
    // 1358:   decode pg1_R2  EA     $24 $25 $26 $27 ; BCC BCS BNE BEQ
    // 1359:                                             
    // 1360:   decode pg1_JTA BRANCH $28 $29 $2A $2B ; BVC BVS BPL BMI
    // 1361:   decode pg1_JTB JMP    $28 $29 $2A $2B ; BVC BVS BPL BMI
    // 1362:   decode pg1_R1  PC     $28 $29 $2A $2B ; BVC BVS BPL BMI
    // 1363:   decode pg1_R2  EA     $28 $29 $2A $2B ; BVC BVS BPL BMI
    // 1364:                                             
    // 1365:   decode pg1_JTA BRANCH $2C $2D $2E $2F ; BGE BLT BGT BLE
    // 1366:   decode pg1_JTB JMP    $2C $2D $2E $2F ; BGE BLT BGT BLE
    // 1367:   decode pg1_R1  PC     $2C $2D $2E $2F ; BGE BLT BGT BLE
    // 1368:   decode pg1_R2  EA     $2C $2D $2E $2F ; BGE BLT BGT BLE
    // 1369:                                             
    // 1370:   decode pg1_JTA BRANCH $16             ; LBRA On page 1!
    // 1371:   decode pg1_JTB JMP    $16             ; LBRA
    // 1372:   decode pg1_R1  PC     $16             ; LBRA 
    // 1373:   decode pg1_R2  EA     $16             ; LBRA 
    // 1374:                 
    // 1375:   decode pg1_JTA BRANCH $8D $17         ; BSR LBSR // FIXME could do this without JUMP_TABLE_A
    // 1376:   decode pg1_JTB JSR    $8D $17         ; BSR LBSR // FIXME check if smaller area
    // 1377:   decode pg1_R1  PC     $8D $17         ; BSR LBSR
    // 1378:   decode pg1_R2  EA     $8D $17         ; BSR LBSR
    // 1379:   decode pg1_AR  S      $8D $17         ; BSR LBSR
    // 1380:                             
    // 1381: ; Another LBRA hidden on Page 2!
    // 1382:   decode pg2_JTA BRANCH $20 $21 $22 $23 ; LBRA LBRN LBHI LBLS
    // 1383:   decode pg2_JTB JMP    $20 $21 $22 $23 ; LBRA LBRN LBHI LBLS
    // 1384:   decode pg2_R1  PC     $20 $21 $22 $23 ; LBRA LBRN LBHI LBLS
    // 1385:   decode pg2_R2  EA     $20 $21 $22 $23 ; LBRA LBRN LBHI LBLS
    // 1386:                                                                   
    // 1387:   decode pg2_JTA BRANCH $24 $25 $26 $27 ; LBCC LBCS LBNE LBEQ
    // 1388:   decode pg2_JTB JMP    $24 $25 $26 $27 ; LBCC LBCS LBNE LBEQ
    // 1389:   decode pg2_R1  PC     $24 $25 $26 $27 ; LBCC LBCS LBNE LBEQ
    // 1390:   decode pg2_R2  EA     $24 $25 $26 $27 ; LBCC LBCS LBNE LBEQ
    // 1391:                                                                   
    // 1392:   decode pg2_JTA BRANCH $28 $29 $2A $2B ; LBVC LBVS LBPL LBMI
    // 1393:   decode pg2_JTB JMP    $28 $29 $2A $2B ; LBVC LBVS LBPL LBMI
    // 1394:   decode pg2_R1  PC     $28 $29 $2A $2B ; LBVC LBVS LBPL LBMI
    // 1395:   decode pg2_R2  EA     $28 $29 $2A $2B ; LBVC LBVS LBPL LBMI
    // 1396:                                                                   
    // 1397:   decode pg2_JTA BRANCH $2C $2D $2E $2F ; LBGE LBLT LBGT LBLE
    // 1398:   decode pg2_JTB JMP    $2C $2D $2E $2F ; LBGE LBLT LBGT LBLE
    // 1399:   decode pg2_R1  PC     $2C $2D $2E $2F ; LBGE LBLT LBGT LBLE
    // 1400:   decode pg2_R2  EA     $2C $2D $2E $2F ; LBGE LBLT LBGT LBLE
    // 1401: 
    // 1402:   DATA_ADD        R1, IDATA ; PC + signed offset
    // 1403:   DATA_WRITE      EA
    // 1404: 
    // 1405:   SET_DATA_WIDTH  W_R1
    // 1406: 
    // 1407:   IF              BRANCH_COND
    // 1408:   JUMP_TABLE_B
    // 1409:   micro_op_end
    8'h2e: begin
      CV_MICRO_SEQ_OP_O = 3'h4;  // OP_JUMP_TABLE_B
      CV_DATA_ALU_A_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_B_SEL_O = 3'h6;  // IDATA
      CV_DATA_ALU_WR_SEL_O = 4'hc;  // EA
      CV_DATA_ALU_OP_O = 3'h0;  // A_PLUS_B
      CV_DATA_WIDTH_SEL_O = 3'h0;  // W_R1
      CV_DATA_ALU_COND_SEL_O = 2'h0;  // ZERO_BIT
      CV_MICRO_SEQ_COND_SEL_O = 4'h8;  // BRANCH_COND
    end


    // 1410: 
    // 1411: GO_NEW_PC:
    // 1412:   JUMP_TABLE_A_NEXT_PC
    // 1413:   micro_op_end
    8'h2f: begin
      CV_MICRO_SEQ_OP_O = 3'h5;  // OP_JUMP_TABLE_A_NEXT_PC
    end


    // 1414: 
    // 1415: ; //////////////////////////////////////////// JMP
    // 1416: ; //
    // 1417: JMP:
    // 1418:   decode pg1_JTA JMP   $0E $7E ; JMP (dir ext)
    // 1419:   decode pg1_R1  PC    $0E $7E ; JMP (dir ext)
    // 1420:   decode pg1_R2  IDATA $0E $7E ; JMP (dir ext)
    // 1421:                                    
    // 1422:   decode pg1_JTB JMP   $6E     ; JMP (idx)
    // 1423:   decode pg1_R1  PC    $6E     ; JMP (idx)
    // 1424:   decode pg1_R2  EA    $6E     ; JMP (idx)
    // 1425: 
    // 1426:   DATA_PASS_B     R2 ; IDATA or EA
    // 1427:   DATA_WRITE      R1 ; PC
    // 1428: 
    // 1429:   JUMP            GO_NEW_PC ; PC must be written before "JUMP_TABLE_A_NEXT_PC"
    // 1430:   micro_op_end
    8'h30: begin
      CV_MICRO_SEQ_OP_O = 3'h1;  // OP_JUMP
      CV_MICRO_SEQ_BRANCH_ADDR_O = 8'h2f;  // GO_NEW_PC
      CV_DATA_ALU_A_SEL_O = 4'hf;  // ZERO
      CV_DATA_ALU_B_SEL_O = 3'h0;  // R2
      CV_DATA_ALU_WR_SEL_O = 4'h8;  // R1
      CV_DATA_ALU_OP_O = 3'h0;  // A_PLUS_B
      CV_DATA_ALU_COND_SEL_O = 2'h0;  // ZERO_BIT
    end


    // 1431: 
    // 1432: 
    // 1433: ; ////////////////////////////////////////////////////////////////////////////
    // 1434: 
    // 1435: 
    // 1436: 
    // 1437: ; ////////////////////////////////////////////////////////////////////////////
    // 1438: ;                        STACK INSTRUCTIONS
    // 1439: ; ////////////////////////////////////////////////////////////////////////////
    // 1440: ; //
    // 1441: 
    // 1442: 
    // 1443: ; //////////////////////////////////////////// JSR
    // 1444: ; //
    // 1445: JSR:
    // 1446:   decode pg1_JTA JSR   $9D $BD ; JSR (dir ext)
    // 1447:   decode pg1_R1  PC    $9D $BD ; JSR (dir ext)
    // 1448:   decode pg1_R2  IDATA $9D $BD ; JSR (dir ext)
    // 1449:   decode pg1_AR  S     $9D $BD ; JSR (dir ext)
    // 1450:                                  
    // 1451:   decode pg1_JTB JSR   $AD     ; JSR (idx)
    // 1452:   decode pg1_R1  PC    $AD     ; JSR (idx)
    // 1453:   decode pg1_R2  EA    $AD     ; JSR (idx)
    // 1454:   decode pg1_AR  S     $AD     ; JSR (idx)
    // 1455: 
    // 1456:   DATA_PASS_A     R1 ; PC
    // 1457: 
    // 1458:   SET_DATA_WIDTH  W_R1
    // 1459: 
    // 1460:   STACK_PUSH      AR
    // 1461:   DMEM_STORE_W
    // 1462: 
    // 1463:   JUMP            JMP 
    // 1464:   micro_op_end
    8'h31: begin
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


    // 1465: 
    // 1466: ; //////////////////////////////////////////// RTS
    // 1467: ; //
    // 1468: RTS:
    // 1469:   decode pg1_JTA RTS      $39 ; RTS
    // 1470:   decode pg1_R1  PC       $39 ; RTS
    // 1471:   decode pg1_R2  DMEM_RD  $39 ; RTS
    // 1472:   decode pg1_AR  S        $39 ; RTS
    // 1473: 
    // 1474:   SET_DATA_WIDTH  W_R1
    // 1475:   
    // 1476:   STACK_PULL      AR
    // 1477:   DMEM_LOAD_W
    // 1478:   
    // 1479:   JUMP            JMP
    // 1480:   micro_op_end
    8'h32: begin
      CV_MICRO_SEQ_OP_O = 3'h1;  // OP_JUMP
      CV_MICRO_SEQ_BRANCH_ADDR_O = 8'h30;  // JMP
      CV_ADDR_ALU_REG_SEL_O = 4'h8;  // AR
      CV_DATA_WIDTH_SEL_O = 3'h0;  // W_R1
      CV_DMEM_OP_O = 2'h2;  // DMEM_OP_RD
      CV_STACK_OP_O = 2'h1;  // STACK_OP_PULL
    end


    // 1481: 
    // 1482: ; //////////////////////////////////////////// RTI
    // 1483: ; //
    // 1484: RTI:
    // 1485:   decode pg1_JTA RTI      $3B ; RTI
    // 1486:   decode pg1_R1  PC       $3B ; RTI
    // 1487:   decode pg1_R2  DMEM_RD  $3B ; RTI
    // 1488:   decode pg1_AR  S        $3B ; RTI
    // 1489:   
    // 1490:   STACK_PULL      ZERO  ; Prime the decode pipeline!
    // 1491:   micro_op_end
    8'h33: begin
      CV_ADDR_ALU_REG_SEL_O = 4'hf;  // ZERO
      CV_STACK_OP_O = 2'h1;  // STACK_OP_PULL
    end


    // 1492: 
    // 1493:   SET_DATA_WIDTH  W_STACK_REG
    // 1494:   
    // 1495:   STACK_PULL      AR
    // 1496:   DMEM_LOAD_W
    // 1497:   micro_op_end
    8'h34: begin
      CV_ADDR_ALU_REG_SEL_O = 4'h8;  // AR
      CV_DATA_WIDTH_SEL_O = 3'h2;  // W_STACK_REG
      CV_DMEM_OP_O = 2'h2;  // DMEM_OP_RD
      CV_STACK_OP_O = 2'h1;  // STACK_OP_PULL
    end


    // 1498: 
    // 1499: RTI_CCR:
    // 1500:   DATA_PASS_B     DMEM_RD
    // 1501:   DATA_WRITE      STACK_REG
    // 1502: 
    // 1503:   CCR_OP_W        OP_XXXXXXXX ; FIXME get rid of this requirement
    // 1504:   micro_op_end
    8'h35: begin
      CV_DATA_ALU_A_SEL_O = 4'hf;  // ZERO
      CV_DATA_ALU_B_SEL_O = 3'h5;  // DMEM_RD
      CV_DATA_ALU_WR_SEL_O = 4'h0;  // STACK_REG
      CV_DATA_ALU_OP_O = 3'h0;  // A_PLUS_B
      CV_CCR_OP_O = 4'h9;  // OP_XXXXXXXX
      CV_DATA_ALU_COND_SEL_O = 2'h0;  // ZERO_BIT
    end


    // 1505: 
    // 1506: RTI_TEST_E:
    // 1507:   IF              E_CLEAR
    // 1508:   JUMP            RTS
    // 1509:   micro_op_end
    8'h36: begin
      CV_MICRO_SEQ_OP_O = 3'h1;  // OP_JUMP
      CV_MICRO_SEQ_BRANCH_ADDR_O = 8'h32;  // RTS
      CV_MICRO_SEQ_COND_SEL_O = 4'h6;  // E_CLEAR
    end


    // 1510: 
    // 1511: RTI_PUL_ALL:
    // 1512:   SET_DATA_WIDTH  W_STACK_REG
    // 1513:   
    // 1514:   STACK_PULL      AR
    // 1515:   DMEM_LOAD_W
    // 1516:   
    // 1517:   JUMP            PUL_LOOP
    // 1518:   micro_op_end
    8'h37: begin
      CV_MICRO_SEQ_OP_O = 3'h1;  // OP_JUMP
      CV_MICRO_SEQ_BRANCH_ADDR_O = 8'h3a;  // PUL_LOOP
      CV_ADDR_ALU_REG_SEL_O = 4'h8;  // AR
      CV_DATA_WIDTH_SEL_O = 3'h2;  // W_STACK_REG
      CV_DMEM_OP_O = 2'h2;  // DMEM_OP_RD
      CV_STACK_OP_O = 2'h1;  // STACK_OP_PULL
    end


    // 1519: 
    // 1520: 
    // 1521: ; //////////////////////////////////////////// PULS PULU
    // 1522: ; //
    // 1523: PUL:
    // 1524:   decode pg1_JTA PUL  $35 ; PULS
    // 1525:   decode pg1_AR  S    $35 ; PULS
    // 1526: 
    // 1527:   decode pg1_JTA PUL  $37 ; PULU
    // 1528:   decode pg1_AR  U    $37 ; PULU
    // 1529: 
    // 1530:   
    // 1531:   STACK_PULL      ZERO  ; Prime the decode pipeline!
    // 1532:   
    // 1533:   IF              STACK_DONE
    // 1534:   JUMP            NOP
    // 1535:   micro_op_end
    8'h38: begin
      CV_MICRO_SEQ_OP_O = 3'h1;  // OP_JUMP
      CV_MICRO_SEQ_BRANCH_ADDR_O = 8'hc;  // NOP
      CV_ADDR_ALU_REG_SEL_O = 4'hf;  // ZERO
      CV_MICRO_SEQ_COND_SEL_O = 4'h2;  // STACK_DONE
      CV_STACK_OP_O = 2'h1;  // STACK_OP_PULL
    end


    // 1536:   
    // 1537:   SET_DATA_WIDTH  W_STACK_REG
    // 1538:   
    // 1539:   STACK_PULL      AR
    // 1540:   DMEM_LOAD_W
    // 1541:   
    // 1542:   IF              STACK_DONE
    // 1543:   JUMP            PUL_DONE
    // 1544:   micro_op_end
    8'h39: begin
      CV_MICRO_SEQ_OP_O = 3'h1;  // OP_JUMP
      CV_MICRO_SEQ_BRANCH_ADDR_O = 8'h3b;  // PUL_DONE
      CV_ADDR_ALU_REG_SEL_O = 4'h8;  // AR
      CV_DATA_WIDTH_SEL_O = 3'h2;  // W_STACK_REG
      CV_MICRO_SEQ_COND_SEL_O = 4'h2;  // STACK_DONE
      CV_DMEM_OP_O = 2'h2;  // DMEM_OP_RD
      CV_STACK_OP_O = 2'h1;  // STACK_OP_PULL
    end


    // 1545: 
    // 1546: PUL_LOOP:
    // 1547:   DATA_PASS_B     DMEM_RD
    // 1548:   DATA_WRITE      STACK_REG
    // 1549: 
    // 1550:   CCR_OP_W        OP_XXXXXXXX ; FIXME get rid of this requirement
    // 1551:   
    // 1552:   SET_DATA_WIDTH  W_STACK_REG
    // 1553: 
    // 1554:   STACK_PULL      AR
    // 1555:   DMEM_LOAD_W
    // 1556: 
    // 1557:   IF              STACK_NEXT
    // 1558:   JUMP            PUL_LOOP
    // 1559:   micro_op_end
    8'h3a: begin
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


    // 1560: 
    // 1561: PUL_DONE:
    // 1562:   DATA_PASS_B     DMEM_RD
    // 1563:   DATA_WRITE      STACK_REG
    // 1564: 
    // 1565:   CCR_OP_W        OP_XXXXXXXX ; FIXME get rid of this requirement
    // 1566: 
    // 1567:   JUMP            GO_NEW_PC ; PC must be written before "JUMP_TABLE_A_NEXT_PC" FIXME?
    // 1568:   micro_op_end
    8'h3b: begin
      CV_MICRO_SEQ_OP_O = 3'h1;  // OP_JUMP
      CV_MICRO_SEQ_BRANCH_ADDR_O = 8'h2f;  // GO_NEW_PC
      CV_DATA_ALU_A_SEL_O = 4'hf;  // ZERO
      CV_DATA_ALU_B_SEL_O = 3'h5;  // DMEM_RD
      CV_DATA_ALU_WR_SEL_O = 4'h0;  // STACK_REG
      CV_DATA_ALU_OP_O = 3'h0;  // A_PLUS_B
      CV_CCR_OP_O = 4'h9;  // OP_XXXXXXXX
      CV_DATA_ALU_COND_SEL_O = 2'h0;  // ZERO_BIT
    end


    // 1569: 
    // 1570: 
    // 1571: ; //////////////////////////////////////////// PSHS PSHU
    // 1572: ; //
    // 1573: PSH:
    // 1574:   decode pg1_JTA PSH   $34 ; PSHS
    // 1575:   decode pg1_AR  S     $34 ; PSHS
    // 1576: 
    // 1577:   decode pg1_JTA PSH   $36 ; PSHU
    // 1578:   decode pg1_AR  U     $36 ; PSHU
    // 1579:   
    // 1580:   STACK_PUSH      ZERO  ; Prime the decode pipeline!
    // 1581: 
    // 1582:   IF              STACK_DONE
    // 1583:   JUMP            NOP
    // 1584:   micro_op_end
    8'h3c: begin
      CV_MICRO_SEQ_OP_O = 3'h1;  // OP_JUMP
      CV_MICRO_SEQ_BRANCH_ADDR_O = 8'hc;  // NOP
      CV_ADDR_ALU_REG_SEL_O = 4'hf;  // ZERO
      CV_MICRO_SEQ_COND_SEL_O = 4'h2;  // STACK_DONE
      CV_STACK_OP_O = 2'h2;  // STACK_OP_PUSH
    end


    // 1585:   
    // 1586: PSH_LOOP:
    // 1587:   DATA_PASS_A     STACK_REG
    // 1588:   
    // 1589:   SET_DATA_WIDTH  W_STACK_REG
    // 1590: 
    // 1591:   STACK_PUSH      AR
    // 1592:   DMEM_STORE_W
    // 1593: 
    // 1594:   IF              STACK_NEXT
    // 1595:   JUMP            PSH_LOOP
    // 1596:   micro_op_end
    8'h3d: begin
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


    // 1597: 
    // 1598:   JUMP_TABLE_A_NEXT_PC
    // 1599:   micro_op_end
    8'h3e: begin
      CV_MICRO_SEQ_OP_O = 3'h5;  // OP_JUMP_TABLE_A_NEXT_PC
    end


    // 1600: 
    // 1601: 
    // 1602: ; //////////////////////////////////////////// SWI
    // 1603: ; //
    // 1604: SWI:
    // 1605:   decode pg1_JTA SWI      $3F ; SWI
    // 1606:   decode pg1_AR  S        $3F ; SWI
    // 1607:   decode pg1_R1  PC       $3F ; SWI
    // 1608:   decode pg1_R2  DMEM_RD  $3F ; SWI
    // 1609:   
    // 1610:   STACK_PUSH      ZERO  ; Prime the decode pipeline!
    // 1611: 
    // 1612:   CCR_OP_W        OP_1ooooooo ; Set E
    // 1613:   micro_op_end
    8'h3f: begin
      CV_ADDR_ALU_REG_SEL_O = 4'hf;  // ZERO
      CV_CCR_OP_O = 4'h7;  // OP_1OOOOOOO
      CV_STACK_OP_O = 2'h2;  // STACK_OP_PUSH
    end


    // 1614:   
    // 1615: SWI_LOOP:
    // 1616:   DATA_PASS_A     STACK_REG
    // 1617:   
    // 1618:   SET_DATA_WIDTH  W_STACK_REG
    // 1619: 
    // 1620:   STACK_PUSH      AR
    // 1621:   DMEM_STORE_W
    // 1622: 
    // 1623:   IF              STACK_NEXT
    // 1624:   JUMP            SWI_LOOP
    // 1625:   micro_op_end
    8'h40: begin
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


    // 1626: 
    // 1627:   ; R1 is PC
    // 1628:   ; R2 is DMEM_RD
    // 1629: 
    // 1630:   SET_DATA_WIDTH  W_16
    // 1631: 
    // 1632:   ADDR_PASS       IDATA ; SWI vector
    // 1633:   DMEM_LOAD_W
    // 1634:   
    // 1635:   CCR_OP_W        OP_o1o1oooo ; Set I & F
    // 1636: 
    // 1637:   JUMP            JMP
    // 1638:   micro_op_end
    8'h41: begin
      CV_MICRO_SEQ_OP_O = 3'h1;  // OP_JUMP
      CV_MICRO_SEQ_BRANCH_ADDR_O = 8'h30;  // JMP
      CV_ADDR_ALU_REG_SEL_O = 4'he;  // IDATA
      CV_DATA_WIDTH_SEL_O = 3'h3;  // W_16
      CV_CCR_OP_O = 4'h8;  // OP_O1O1OOOO
      CV_DMEM_OP_O = 2'h2;  // DMEM_OP_RD
    end


    // 1639: 
    // 1640: 
    // 1641: 
    // 1642: ; ////////////////////////////////////////////////////////////////////////////
    // 1643: 
    // 1644: 
    // 1645:   ORG  $FF
    // 1646: 
    // 1647: TRAP:
    // 1648: 
    // 1649:   JUMP            TRAP
    // 1650:   micro_op_end
    8'hff: begin
      CV_MICRO_SEQ_OP_O = 3'h1;  // OP_JUMP
      CV_MICRO_SEQ_BRANCH_ADDR_O = 8'hff;  // TRAP
    end


    // 1651: 
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

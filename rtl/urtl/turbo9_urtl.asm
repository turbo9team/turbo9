; [TURBO9_HEADER_START]
; ////////////////////////////////////////////////////////////////////////////
;                          Turbo9 Microprocessor IP
; ////////////////////////////////////////////////////////////////////////////
; Website: www.turbo9.org
; Contact: team[at]turbo9[dot]org
; ////////////////////////////////////////////////////////////////////////////
; [TURBO9_LICENSE_START]
; BSD-1-Clause
;
; Copyright (c) 2020-2023
; Kevin Phillipson
; Michael Rywalt
; All rights reserved.
;
; Redistribution and use in source and binary forms, with or without
; modification, are permitted provided that the following conditions are met:
;
; 1. Redistributions of source code must retain the above copyright notice,
;    this list of conditions and the following disclaimer.
;
; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
; AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
; IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
; ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS AND CONTRIBUTORS BE
; LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
; CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
; SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
; INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
; CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
; ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
; POSSIBILITY OF SUCH DAMAGE.
; [TURBO9_LICENSE_END]
; ////////////////////////////////////////////////////////////////////////////
; Engineer: Kevin Phillipson
; Description: Turbo9 uRTL microcode 
;
; ////////////////////////////////////////////////////////////////////////////
; History:
; 07.14.2023 - Kevin Phillipson
;   File header added
;
; ////////////////////////////////////////////////////////////////////////////
; [TURBO9_HEADER_END]

; decode_init <tablename> <ctrl_vec> <default_string> ; Comment

  ; Jump Table A
  decode_init pg1_JTA cv_MICRO_SEQ_BRANCH_ADDR FF ; Page 1
  decode_init pg2_JTA cv_MICRO_SEQ_BRANCH_ADDR FF ; Page 2
  decode_init pg3_JTA cv_MICRO_SEQ_BRANCH_ADDR FF ; Page 3
  
  ; Jump Table B
  decode_init pg1_JTB cv_MICRO_SEQ_BRANCH_ADDR FF ; Page 1
  decode_init pg2_JTB cv_MICRO_SEQ_BRANCH_ADDR FF ; Page 2
  decode_init pg3_JTB cv_MICRO_SEQ_BRANCH_ADDR FF ; Page 3
  
  ; Register A Decode
  ; A side of ALU and ALU write
  decode_init pg1_R1  cv_R1_SEL x ; Page 1 
  decode_init pg2_R1  cv_R1_SEL x ; Page 2 
  decode_init pg3_R1  cv_R1_SEL x ; Page 3 

  ; Register B Decode
  ; B side of ALU
  decode_init pg1_R2  cv_R2_SEL x ; Page 1 
  decode_init pg2_R2  cv_R2_SEL x ; Page 2 
  decode_init pg3_R2  cv_R2_SEL x ; Page 3 

  ; Address Register Decode
  decode_init pg1_AR  cv_AR_SEL x ; Page 1 
  decode_init pg2_AR  cv_AR_SEL x ; Page 2 
  decode_init pg3_AR  cv_AR_SEL x ; Page 3 

; decode <tablename> <equ> <opcode0...opcodeN> ; Comment
;
; EXAMPLE:
; decode pg1_JTA ABX $3A ; ABX(inh)



  ORG  $00
RESET:
  ; R1 is reset to PC
  ; R2 is reset to DMEM_RD

  SET_DATA_WIDTH  W_16

  STACK_PUSH      ZERO ; a cute way of creating EA=$FFFE
  DMEM_LOAD_W

  JUMP            JMP
  end_state

; ////////////////////////////////////////////////////////////////////////////
;                           LOAD ADDRESSING MODES
; ////////////////////////////////////////////////////////////////////////////
; //
LD_DIR_EXT:
  decode pg1_JTA LD_DIR_EXT $99 $B9 ; ADCA (dir ext)
  decode pg1_JTA LD_DIR_EXT $D9 $F9 ; ADCB (dir ext)
  ;                               
  decode pg1_JTA LD_DIR_EXT $9B $BB ; ADDA (dir ext)
  decode pg1_JTA LD_DIR_EXT $DB $FB ; ADDB (dir ext)
  decode pg1_JTA LD_DIR_EXT $D3 $F3 ; ADDD (dir ext)
; //                              
  decode pg1_JTA LD_DIR_EXT $94 $B4 ; ANDA (dir ext)
  decode pg1_JTA LD_DIR_EXT $D4 $F4 ; ANDB (dir ext)
; //                              
  decode pg1_JTA LD_DIR_EXT $08 $78 ; ASL LSL (dir ext)
; //                              
  decode pg1_JTA LD_DIR_EXT $07 $77 ; ASR (dir ext)
; //                              
  decode pg1_JTA LD_DIR_EXT $95 $B5 ; BITA (dir ext)
  decode pg1_JTA LD_DIR_EXT $D5 $F5 ; BITB (dir ext)
; //                              
  decode pg1_JTA LD_DIR_EXT $91 $B1 ; CMPA (dir ext)
  decode pg1_JTA LD_DIR_EXT $D1 $F1 ; CMPB (dir ext)
  decode pg2_JTA LD_DIR_EXT $93 $B3 ; CMPD (dir ext)
  decode pg3_JTA LD_DIR_EXT $9C $BC ; CMPS (dir ext)
  decode pg3_JTA LD_DIR_EXT $93 $B3 ; CMPU (dir ext)
  decode pg1_JTA LD_DIR_EXT $9C $BC ; CMPX (dir ext)
  decode pg2_JTA LD_DIR_EXT $9C $BC ; CMPY (dir ext)
; //                              
  decode pg1_JTA LD_DIR_EXT $03 $73 ; COM (dir ext)
; //                              
  decode pg1_JTA LD_DIR_EXT $0A $7A ; DEC (dir ext)
; //                              
  decode pg1_JTA LD_DIR_EXT $98 $B8 ; EORA (dir ext)
  decode pg1_JTA LD_DIR_EXT $D8 $F8 ; EORB (dir ext)
; //                              
  decode pg1_JTA LD_DIR_EXT $0C $7C ; INC (dir ext)
; //                              
  decode pg1_JTA LD_DIR_EXT $96 $B6 ; LDA (dir ext)
  decode pg1_JTA LD_DIR_EXT $D6 $F6 ; LDB (dir ext)
  decode pg1_JTA LD_DIR_EXT $DC $FC ; LDD (dir ext)
  decode pg2_JTA LD_DIR_EXT $DE $FE ; LDS (dir ext)
  decode pg1_JTA LD_DIR_EXT $DE $FE ; LDU (dir ext)
  decode pg1_JTA LD_DIR_EXT $9E $BE ; LDX (dir ext)
  decode pg2_JTA LD_DIR_EXT $9E $BE ; LDY (dir ext)
; //                              
  decode pg1_JTA LD_DIR_EXT $04 $74 ; LSR (dir ext)
; //                              
  decode pg1_JTA LD_DIR_EXT $00 $70 ; NEG (dir ext)
; //                              
  decode pg1_JTA LD_DIR_EXT $9A $BA ; ORA (dir ext)
  decode pg1_JTA LD_DIR_EXT $DA $FA ; ORB (dir ext)
; //                              
  decode pg1_JTA LD_DIR_EXT $09 $79 ; ROL (dir ext)
  decode pg1_JTA LD_DIR_EXT $06 $76 ; ROR (dir ext)
; //                              
  decode pg1_JTA LD_DIR_EXT $92 $B2 ; SBCA (dir ext)
  decode pg1_JTA LD_DIR_EXT $D2 $F2 ; SBCB (dir ext)
; //                              
  decode pg1_JTA LD_DIR_EXT $90 $B0 ; SUBA (dir ext)
  decode pg1_JTA LD_DIR_EXT $D0 $F0 ; SUBB (dir ext)
  decode pg1_JTA LD_DIR_EXT $93 $B3 ; SUBD (dir ext)
; //                              
  decode pg1_JTA LD_DIR_EXT $0D $7D ; TST (dir ext)

  DATA_PASS_B     IDATA
  DATA_WRITE      EA

  SET_DATA_WIDTH  W_R1

  ADDR_PASS       IDATA
  DMEM_LOAD_W

  JUMP_TABLE_B
  end_state


LD_INDEXED:
  decode pg1_JTA LD_INDEXED $A9 ; ADCA (idx)
  decode pg1_JTA LD_INDEXED $E9 ; ADCB (idx)
; //                            
  decode pg1_JTA LD_INDEXED $AB ; ADDA (idx)
  decode pg1_JTA LD_INDEXED $EB ; ADDB (idx)
  decode pg1_JTA LD_INDEXED $E3 ; ADDD (idx)
; //                            
  decode pg1_JTA LD_INDEXED $A4 ; ANDA (idx)
  decode pg1_JTA LD_INDEXED $E4 ; ANDB (idx)
; //                            
  decode pg1_JTA LD_INDEXED $68 ; ASL LSL (idx)
; //                            
  decode pg1_JTA LD_INDEXED $67 ; ASR (idx)
; //                            
  decode pg1_JTA LD_INDEXED $A5 ; BITA (idx)
  decode pg1_JTA LD_INDEXED $E5 ; BITB (idx)
; //                            
  decode pg1_JTA LD_INDEXED $A1 ; CMPA (idx)
  decode pg1_JTA LD_INDEXED $E1 ; CMPB (idx)
  decode pg2_JTA LD_INDEXED $A3 ; CMPD (idx)
  decode pg3_JTA LD_INDEXED $AC ; CMPS (idx)
  decode pg3_JTA LD_INDEXED $A3 ; CMPU (idx)
  decode pg1_JTA LD_INDEXED $AC ; CMPX (idx)
  decode pg2_JTA LD_INDEXED $AC ; CMPY (idx)
; //                            
  decode pg1_JTA LD_INDEXED $63 ; COM (idx)
; //                            
  decode pg1_JTA LD_INDEXED $6A ; DEC (idx)
; //                            
  decode pg1_JTA LD_INDEXED $A8 ; EORA (idx)
  decode pg1_JTA LD_INDEXED $E8 ; EORB (idx)
; //                            
  decode pg1_JTA LD_INDEXED $6C ; INC (idx)
; //                            
  decode pg1_JTA LD_INDEXED $A6 ; LDA (idx)
  decode pg1_JTA LD_INDEXED $E6 ; LDB (idx)
  decode pg1_JTA LD_INDEXED $EC ; LDD (idx)
  decode pg2_JTA LD_INDEXED $EE ; LDS (idx)
  decode pg1_JTA LD_INDEXED $EE ; LDU (idx)
  decode pg1_JTA LD_INDEXED $AE ; LDX (idx)
  decode pg2_JTA LD_INDEXED $AE ; LDY (idx)
; //                            
  decode pg1_JTA LD_INDEXED $64 ; LSR (idx)
; //                            
  decode pg1_JTA LD_INDEXED $60 ; NEG (idx)
; //                            
  decode pg1_JTA LD_INDEXED $AA ; ORA (idx)
  decode pg1_JTA LD_INDEXED $EA ; ORB (idx)
; //                            
  decode pg1_JTA LD_INDEXED $69 ; ROL (idx)
  decode pg1_JTA LD_INDEXED $66 ; ROR (idx)
; //                            
  decode pg1_JTA LD_INDEXED $A2 ; SBCA (idx)
  decode pg1_JTA LD_INDEXED $E2 ; SBCB (idx)
; //                            
  decode pg1_JTA LD_INDEXED $A0 ; SUBA (idx)
  decode pg1_JTA LD_INDEXED $E0 ; SUBB (idx)
  decode pg1_JTA LD_INDEXED $A3 ; SUBD (idx)
; //                            
  decode pg1_JTA LD_INDEXED $6D ; TST (idx)
  
  SET_DATA_WIDTH  W_R1_OR_IND

  ADDR_INX_OR_LOAD_IND
  DMEM_LOAD_W ; LOAD_IND can override

  IF              NOT_INDIRECT
  JUMP_TABLE_B
  end_state

LD_INDIRECT:
  DATA_PASS_B     DMEM_RD
  DATA_WRITE      EA
  
  SET_DATA_WIDTH  W_R1

  ADDR_PASS       DMEM_RD
  DMEM_LOAD_W

  JUMP_TABLE_B
  end_state
; //
; ////////////////////////////////////////////////////////////////////////////


; ////////////////////////////////////////////////////////////////////////////
;                           STORE ADDRESSING MODES
; ////////////////////////////////////////////////////////////////////////////
; //
ST_INDEXED:
  decode pg1_JTA ST_INDEXED $6F ; CLR(idx)
; //                                
  decode pg1_JTA ST_INDEXED $6E ; JMP(idx)
; //                                
  decode pg1_JTA ST_INDEXED $AD ; JSR (idx)
; //                                
  decode pg1_JTA ST_INDEXED $32 ; LEAS(inh)
  decode pg1_JTA ST_INDEXED $33 ; LEAU(inh)
  decode pg1_JTA ST_INDEXED $30 ; LEAX(inh)
  decode pg1_JTA ST_INDEXED $31 ; LEAY(inh)
; //                                
  decode pg1_JTA ST_INDEXED $A7 ; STA (idx)
  decode pg1_JTA ST_INDEXED $E7 ; STB (idx)
  decode pg1_JTA ST_INDEXED $ED ; STD (idx)
  decode pg2_JTA ST_INDEXED $EF ; STS (idx)
  decode pg1_JTA ST_INDEXED $EF ; STU (idx)
  decode pg1_JTA ST_INDEXED $AF ; STX (idx)
  decode pg2_JTA ST_INDEXED $AF ; STY (idx)
  
  SET_DATA_WIDTH  W_R1_OR_IND

  ADDR_INX_OR_LOAD_IND

  IF              NOT_INDIRECT
  JUMP_TABLE_B
  end_state

ST_INDIRECT:
  DATA_PASS_B     DMEM_RD
  DATA_WRITE      EA
  
  JUMP_TABLE_B
  end_state

; //
; ////////////////////////////////////////////////////////////////////////////


; ////////////////////////////////////////////////////////////////////////////
;                           INHERENT INSTRUCTIONS
; ////////////////////////////////////////////////////////////////////////////
; //

; //////////////////////////////////////////// ABX
; //
ABX:
  decode pg1_JTA ABX $3A ; ABX(inh)
  decode pg1_R1  X   $3A ; ABX(inh)
  decode pg1_R2  B   $3A ; ABX(inh)

  DATA_ADD        R1, R2
  DATA_WRITE      R1

  JUMP_TABLE_A_NEXT_PC
  end_state

; //////////////////////////////////////////// EXG
; //
EXG:
  decode pg1_JTA EXG $1E ; EXG(inh)
; R1 = postbyte[7:0] $1E ; EXG(inh)
; R2 = postbyte[3:0] $1E ; EXG(inh)

  DATA_PASS_A     R1
  DATA_WRITE      EA
  end_state

  DATA_PASS_A     R2
  DATA_WRITE      R1
  
  CCR_OP_W        OP_XXXXXXXX ; Just in case CCR is destination
  end_state

  DATA_PASS_A     EA
  DATA_WRITE      R2

  CCR_OP_W        OP_XXXXXXXX ; Just in case CCR is destination

  JUMP            GO_NEW_PC ; Just in case PC is destination
  end_state


; //////////////////////////////////////////// LEA S or U
; //
LEA_SU:
  decode pg1_JTB LEA_SU $32 ; LEAS(inh)
  decode pg1_R1  S      $32 ; LEAS(inh)
                            
  decode pg1_JTB LEA_SU $33 ; LEAU(inh)
  decode pg1_R1  U      $33 ; LEAU(inh)

  DATA_PASS_B     EA
  DATA_WRITE      R1

  JUMP_TABLE_A_NEXT_PC
  end_state

; //////////////////////////////////////////// LEA X or Y
; //
LEA_XY:
  decode pg1_JTB LEA_XY $30 ; LEAX(inh)
  decode pg1_R1  X      $30 ; LEAX(inh)
                            
  decode pg1_JTB LEA_XY $31 ; LEAY(inh)
  decode pg1_R1  Y      $31 ; LEAY(inh)

  DATA_PASS_B     EA
  DATA_WRITE      R1

  SET_DATA_WIDTH  W_R1

  CCR_OP_W        OP_oooooXoo 

  JUMP_TABLE_A_NEXT_PC
  end_state

; //////////////////////////////////////////// NOP
; //
; // Prebytes are sent here if the execute stage has nothing
; // else better to do. However, this is unnecessary given
; // prebyte processing logic is contained in the decode stage
; // and prebytes are decoded independently without delay if
; // the execute stage is busy. It's called pipelining ;-)
; //
NOP:
  decode pg1_JTA NOP $12 ; NOP(inh)
  decode pg1_JTA NOP $11 ; page3 (prebyte)
  decode pg1_JTA NOP $10 ; page2 (prebyte)

  JUMP_TABLE_A_NEXT_PC
  end_state

; //////////////////////////////////////////// EMUL EMULS IDIV EDIV EDIVS IDIVS FDIV
; //
SAU16:
  decode pg1_JTA SAU16 $14 ; EMUL (inh)
  decode pg1_R2  Y     $14 ; EMUL (inh)
  decode pg1_R1  D     $14 ; EMUL (inh)

  decode pg1_JTA SAU16 $18 ; IDIV (inh)
  decode pg1_R2  D     $18 ; IDIV (inh)
  decode pg1_R1  X     $18 ; IDIV (inh)

  decode pg2_JTA SAU16 $18 ; IDIVS (inh)
  decode pg2_R2  D     $18 ; IDIVS (inh)
  decode pg2_R1  X     $18 ; IDIVS (inh)

  DATA_SAU_EN

  IF              SAU_NOT_DONE
  JUMP            SAU16
  end_state

SAU16_DONE:

  DATA_SAU_DONE
  DATA_WRITE      R2

  JUMP            SAU8_DONE
  end_state

; //////////////////////////////////////////// DAA MUL
; //
SAU8:
  decode pg1_JTA SAU8 $19 ; DAA (inh)
  decode pg1_R1  D    $19 ; DAA (inh)

  decode pg1_JTA SAU8 $3D ; MUL (inh)
  decode pg1_R1  D    $3D ; MUL (inh)

  DATA_SAU_EN

  IF              SAU_NOT_DONE
  JUMP            SAU8
  end_state

SAU8_DONE:

  DATA_SAU_DONE
  DATA_WRITE      R1

  CCR_OP_W        OP_ooooXXXX ; SAU masks correct bits

  JUMP_TABLE_A_NEXT_PC
  end_state

; //////////////////////////////////////////// SEX (in 1 micro-cycle!)
; //
SEX:
  decode pg1_JTA SEX  $1D ; SEX(inh)
  decode pg1_R1  D    $1D ; SEX(inh)
  decode pg1_R2  SEXB $1D ; SEX(inh)

  DATA_PASS_B     R2
  DATA_WRITE      R1
  
  SET_DATA_WIDTH  W_R1

  CCR_OP_W        OP_ooooXXXo ; INFO Prog Man says V unaffected, datasheet says v=0

  JUMP_TABLE_A_NEXT_PC
  end_state

; //////////////////////////////////////////// TFR
; //
TFR:
  decode pg1_JTA TFR $1F ; TFR(inh)
; R1 = postbyte[7:0] $1F ; TFR(inh)
; R2 = postbyte[3:0] $1F ; TFR(inh)

  DATA_PASS_A     R1
  DATA_WRITE      R2

  CCR_OP_W        OP_XXXXXXXX ; Just in case CCR is destination

  JUMP            GO_NEW_PC ; Just in case PC is destination
  end_state

; //
; ////////////////////////////////////////////////////////////////////////////


; ////////////////////////////////////////////////////////////////////////////
;                        LOAD TYPE INSTRUCTIONS
; ////////////////////////////////////////////////////////////////////////////

; //////////////////////////////////////////// ADC
; //
ADC:
  decode pg1_JTA ADC     $89         ; ADCA (imm)
  decode pg1_R1  A       $89         ; ADCA (imm)
  decode pg1_R2  IDATA   $89         ; ADCA (imm)
                                                   
  decode pg1_JTA ADC     $C9         ; ADCB (imm)
  decode pg1_R1  B       $C9         ; ADCB (imm)
  decode pg1_R2  IDATA   $C9         ; ADCB (imm)
                                         
  decode pg1_JTB ADC     $99 $A9 $B9 ; ADCA (dir idx ext)
  decode pg1_R1  A       $99 $A9 $B9 ; ADCA (dir idx ext)
  decode pg1_R2  DMEM_RD $99 $A9 $B9 ; ADCA (dir idx ext)
                                         
  decode pg1_JTB ADC     $D9 $E9 $F9 ; ADCB (dir idx ext)
  decode pg1_R1  B       $D9 $E9 $F9 ; ADCB (dir idx ext)
  decode pg1_R2  DMEM_RD $D9 $E9 $F9 ; ADCB (dir idx ext)

  DATA_ADDC       R1, R2
  DATA_WRITE      R1

  SET_DATA_WIDTH  W_R1

  CCR_OP_W        OP_ooXoXXXX ; H is masked for 16bit

  JUMP_TABLE_A_NEXT_PC
  end_state

; //////////////////////////////////////////// ADD
; //
ADD:
  decode pg1_JTA ADD     $8B         ; ADDA (imm)
  decode pg1_R1  A       $8B         ; ADDA (imm)
  decode pg1_R2  IDATA   $8B         ; ADDA (imm)
                                                   
  decode pg1_JTA ADD     $CB         ; ADDB (imm)
  decode pg1_R1  B       $CB         ; ADDB (imm)
  decode pg1_R2  IDATA   $CB         ; ADDB (imm)
                                                   
  decode pg1_JTA ADD     $C3         ; ADDD (imm)
  decode pg1_R1  D       $C3         ; ADDD (imm)
  decode pg1_R2  IDATA   $C3         ; ADDD (imm)
                             
  decode pg1_JTB ADD     $9B $AB $BB ; ADDA (dir idx ext)
  decode pg1_R1  A       $9B $AB $BB ; ADDA (dir idx ext)
  decode pg1_R2  DMEM_RD $9B $AB $BB ; ADDA (dir idx ext)
                             
  decode pg1_JTB ADD     $DB $EB $FB ; ADDB (dir idx ext)
  decode pg1_R1  B       $DB $EB $FB ; ADDB (dir idx ext)
  decode pg1_R2  DMEM_RD $DB $EB $FB ; ADDB (dir idx ext)
                             
  decode pg1_JTB ADD     $D3 $E3 $F3 ; ADDD (dir idx ext)
  decode pg1_R1  D       $D3 $E3 $F3 ; ADDD (dir idx ext)
  decode pg1_R2  DMEM_RD $D3 $E3 $F3 ; ADDD (dir idx ext)

  DATA_ADD        R1, R2
  DATA_WRITE      R1

  SET_DATA_WIDTH  W_R1

  CCR_OP_W        OP_ooXoXXXX ; H is masked for 16bit

  JUMP_TABLE_A_NEXT_PC
  end_state


; //////////////////////////////////////////// AND
; //
AND:
  decode pg1_JTA AND     $84         ; ANDA (imm)
  decode pg1_R1  A       $84         ; ANDA (imm)
  decode pg1_R2  IDATA   $84         ; ANDA (imm)
                                                   
  decode pg1_JTA AND     $C4         ; ANDB (imm)
  decode pg1_R1  B       $C4         ; ANDB (imm)
  decode pg1_R2  IDATA   $C4         ; ANDB (imm)
                                     
  decode pg1_JTB AND     $94 $A4 $B4 ; ANDA (dir idx ext)
  decode pg1_R1  A       $94 $A4 $B4 ; ANDA (dir idx ext)
  decode pg1_R2  DMEM_RD $94 $A4 $B4 ; ANDA (dir idx ext)
                                     
  decode pg1_JTB AND     $D4 $E4 $F4 ; ANDB (dir idx ext)
  decode pg1_R1  B       $D4 $E4 $F4 ; ANDB (dir idx ext)
  decode pg1_R2  DMEM_RD $D4 $E4 $F4 ; ANDB (dir idx ext)

  DATA_AND        R1, R2
  DATA_WRITE      R1

  SET_DATA_WIDTH  W_R1

  CCR_OP_W        OP_ooooXXXo 

  JUMP_TABLE_A_NEXT_PC
  end_state

ANDCC:
  decode pg1_JTA ANDCC $1C ; ANDCC (imm)
  decode pg1_R1  CCR   $1C ; ANDCC (imm)
  decode pg1_R2  IDATA $1C ; ANDCC (imm)

  DATA_AND        R1, R2
  DATA_WRITE      R1

  SET_DATA_WIDTH  W_R1

  CCR_OP_W        OP_XXXXXXXX 

  JUMP_TABLE_A_NEXT_PC
  end_state

; //////////////////////////////////////////// BIT
; //
BIT:
  decode pg1_JTA BIT     $85         ; BITA (imm)
  decode pg1_R1  A       $85         ; BITA (imm)
  decode pg1_R2  IDATA   $85         ; BITA (imm)
                                                
  decode pg1_JTA BIT     $C5         ; BITB (imm)
  decode pg1_R1  B       $C5         ; BITB (imm)
  decode pg1_R2  IDATA   $C5         ; BITB (imm)
                             
  decode pg1_JTB BIT     $95 $A5 $B5 ; BITA (dir idx ext)
  decode pg1_R1  A       $95 $A5 $B5 ; BITA (dir idx ext)
  decode pg1_R2  DMEM_RD $95 $A5 $B5 ; BITA (dir idx ext)
                             
  decode pg1_JTB BIT     $D5 $E5 $F5 ; BITB (dir idx ext)
  decode pg1_R1  B       $D5 $E5 $F5 ; BITB (dir idx ext)
  decode pg1_R2  DMEM_RD $D5 $E5 $F5 ; BITB (dir idx ext)

  DATA_AND        R1, R2

  SET_DATA_WIDTH  W_R1

  CCR_OP_W        OP_ooooXXXo 

  JUMP_TABLE_A_NEXT_PC
  end_state

; //////////////////////////////////////////// CMP
; //
CMP:
  decode pg1_JTA CMP     $81         ; CMPA (imm)
  decode pg1_R1  A       $81         ; CMPA (imm)
  decode pg1_R2  IDATA   $81         ; CMPA (imm)
                                               
  decode pg1_JTA CMP     $C1         ; CMPB (imm)
  decode pg1_R1  B       $C1         ; CMPB (imm)
  decode pg1_R2  IDATA   $C1         ; CMPB (imm)
                                               
  decode pg2_JTA CMP     $83         ; CMPD (imm)
  decode pg2_R1  D       $83         ; CMPD (imm)
  decode pg2_R2  IDATA   $83         ; CMPD (imm)
                                               
  decode pg3_JTA CMP     $8C         ; CMPS (imm)
  decode pg3_R1  S       $8C         ; CMPS (imm)
  decode pg3_R2  IDATA   $8C         ; CMPS (imm)
                                               
  decode pg3_JTA CMP     $83         ; CMPU (imm)
  decode pg3_R1  U       $83         ; CMPU (imm)
  decode pg3_R2  IDATA   $83         ; CMPU (imm)
                                               
  decode pg1_JTA CMP     $8C         ; CMPX (imm)
  decode pg1_R1  X       $8C         ; CMPX (imm)
  decode pg1_R2  IDATA   $8C         ; CMPX (imm)
                                               
  decode pg2_JTA CMP     $8C         ; CMPY (imm)
  decode pg2_R1  Y       $8C         ; CMPY (imm)
  decode pg2_R2  IDATA   $8C         ; CMPY (imm)
                             
  decode pg1_JTB CMP     $91 $A1 $B1 ; CMPA (dir idx ext)
  decode pg1_R1  A       $91 $A1 $B1 ; CMPA (dir idx ext)
  decode pg1_R2  DMEM_RD $91 $A1 $B1 ; CMPA (dir idx ext)
                             
  decode pg1_JTB CMP     $D1 $E1 $F1 ; CMPB (dir idx ext)
  decode pg1_R1  B       $D1 $E1 $F1 ; CMPB (dir idx ext)
  decode pg1_R2  DMEM_RD $D1 $E1 $F1 ; CMPB (dir idx ext)
                             
  decode pg2_JTB CMP     $93 $A3 $B3 ; CMPD (dir idx ext)
  decode pg2_R1  D       $93 $A3 $B3 ; CMPD (dir idx ext)
  decode pg2_R2  DMEM_RD $93 $A3 $B3 ; CMPD (dir idx ext)
                             
  decode pg3_JTB CMP     $9C $AC $BC ; CMPS (dir idx ext)
  decode pg3_R1  S       $9C $AC $BC ; CMPS (dir idx ext)
  decode pg3_R2  DMEM_RD $9C $AC $BC ; CMPS (dir idx ext)
                             
  decode pg3_JTB CMP     $93 $A3 $B3 ; CMPU (dir idx ext)
  decode pg3_R1  U       $93 $A3 $B3 ; CMPU (dir idx ext)
  decode pg3_R2  DMEM_RD $93 $A3 $B3 ; CMPU (dir idx ext)
                             
  decode pg1_JTB CMP     $9C $AC $BC ; CMPX (dir idx ext)
  decode pg1_R1  X       $9C $AC $BC ; CMPX (dir idx ext)
  decode pg1_R2  DMEM_RD $9C $AC $BC ; CMPX (dir idx ext)
                             
  decode pg2_JTB CMP     $9C $AC $BC ; CMPY (dir idx ext)
  decode pg2_R1  Y       $9C $AC $BC ; CMPY (dir idx ext)
  decode pg2_R2  DMEM_RD $9C $AC $BC ; CMPY (dir idx ext)

  DATA_SUB        R1, R2

  SET_DATA_WIDTH  W_R1

  CCR_OP_W        OP_ooooXXXX ; INFO: Spec H Undefined, Turbo9 H not affected

  JUMP_TABLE_A_NEXT_PC
  end_state

; //////////////////////////////////////////// EOR
; //
EOR:
  decode pg1_JTA EOR     $88         ; EORA (imm)
  decode pg1_R1  A       $88         ; EORA (imm)
  decode pg1_R2  IDATA   $88         ; EORA (imm)
                                                
  decode pg1_JTA EOR     $C8         ; EORB (imm)
  decode pg1_R1  B       $C8         ; EORB (imm)
  decode pg1_R2  IDATA   $C8         ; EORB (imm)
                             
  decode pg1_JTB EOR     $98 $A8 $B8 ; EORA (dir idx ext)
  decode pg1_R1  A       $98 $A8 $B8 ; EORA (dir idx ext)
  decode pg1_R2  DMEM_RD $98 $A8 $B8 ; EORA (dir idx ext)
                             
  decode pg1_JTB EOR     $D8 $E8 $F8 ; EORB (dir idx ext)
  decode pg1_R1  B       $D8 $E8 $F8 ; EORB (dir idx ext)
  decode pg1_R2  DMEM_RD $D8 $E8 $F8 ; EORB (dir idx ext)

  DATA_XOR        R1, R2
  DATA_WRITE      R1

  SET_DATA_WIDTH  W_R1

  CCR_OP_W        OP_ooooXXXo 

  JUMP_TABLE_A_NEXT_PC
  end_state

; //////////////////////////////////////////// LD
; //
LD:
  decode pg1_JTA LD      $86         ; LDA (imm)
  decode pg1_R1  A       $86         ; LDA (imm)
  decode pg1_R2  IDATA   $86         ; LDA (imm)
                                                
  decode pg1_JTA LD      $C6         ; LDB (imm)
  decode pg1_R1  B       $C6         ; LDB (imm)
  decode pg1_R2  IDATA   $C6         ; LDB (imm)
                                                
  decode pg1_JTA LD      $CC         ; LDD (imm)
  decode pg1_R1  D       $CC         ; LDD (imm)
  decode pg1_R2  IDATA   $CC         ; LDD (imm)
                                                
  decode pg2_JTA LD      $CE         ; LDS (imm)
  decode pg2_R1  S       $CE         ; LDS (imm)
  decode pg2_R2  IDATA   $CE         ; LDS (imm)
                                                
  decode pg1_JTA LD      $CE         ; LDU (imm)
  decode pg1_R1  U       $CE         ; LDU (imm)
  decode pg1_R2  IDATA   $CE         ; LDU (imm)
                                                
  decode pg1_JTA LD      $8E         ; LDX (imm)
  decode pg1_R1  X       $8E         ; LDX (imm)
  decode pg1_R2  IDATA   $8E         ; LDX (imm)
                                                
  decode pg2_JTA LD      $8E         ; LDY (imm)
  decode pg2_R1  Y       $8E         ; LDY (imm)
  decode pg2_R2  IDATA   $8E         ; LDY (imm)
                             
  decode pg1_JTB LD      $96 $A6 $B6 ; LDA (dir idx ext)
  decode pg1_R1  A       $96 $A6 $B6 ; LDA (dir idx ext)
  decode pg1_R2  DMEM_RD $96 $A6 $B6 ; LDA (dir idx ext)
                             
  decode pg1_JTB LD      $D6 $E6 $F6 ; LDB (dir idx ext)
  decode pg1_R1  B       $D6 $E6 $F6 ; LDB (dir idx ext)
  decode pg1_R2  DMEM_RD $D6 $E6 $F6 ; LDB (dir idx ext)
                             
  decode pg1_JTB LD      $DC $EC $FC ; LDD (dir idx ext)
  decode pg1_R1  D       $DC $EC $FC ; LDD (dir idx ext)
  decode pg1_R2  DMEM_RD $DC $EC $FC ; LDD (dir idx ext)
                             
  decode pg2_JTB LD      $DE $EE $FE ; LDS (dir idx ext)
  decode pg2_R1  S       $DE $EE $FE ; LDS (dir idx ext)
  decode pg2_R2  DMEM_RD $DE $EE $FE ; LDS (dir idx ext)
                             
  decode pg1_JTB LD      $DE $EE $FE ; LDU (dir idx ext)
  decode pg1_R1  U       $DE $EE $FE ; LDU (dir idx ext)
  decode pg1_R2  DMEM_RD $DE $EE $FE ; LDU (dir idx ext)
                             
  decode pg1_JTB LD      $9E $AE $BE ; LDX (dir idx ext)
  decode pg1_R1  X       $9E $AE $BE ; LDX (dir idx ext)
  decode pg1_R2  DMEM_RD $9E $AE $BE ; LDX (dir idx ext)
                             
  decode pg2_JTB LD      $9E $AE $BE ; LDY (dir idx ext)
  decode pg2_R1  Y       $9E $AE $BE ; LDY (dir idx ext)
  decode pg2_R2  DMEM_RD $9E $AE $BE ; LDY (dir idx ext)

  DATA_PASS_B     R2
  DATA_WRITE      R1

  SET_DATA_WIDTH  W_R1

  CCR_OP_W        OP_ooooXXXo

  JUMP_TABLE_A_NEXT_PC
  end_state

; //////////////////////////////////////////// OR
; //
OR:
  decode pg1_JTA OR      $8A         ; ORA (imm)
  decode pg1_R1  A       $8A         ; ORA (imm)
  decode pg1_R2  IDATA   $8A         ; ORA (imm)
                                                
  decode pg1_JTA OR      $CA         ; ORB (imm)
  decode pg1_R1  B       $CA         ; ORB (imm)
  decode pg1_R2  IDATA   $CA         ; ORB (imm)
                             
  decode pg1_JTB OR      $9A $AA $BA ; ORA (dir idx ext)
  decode pg1_R1  A       $9A $AA $BA ; ORA (dir idx ext)
  decode pg1_R2  DMEM_RD $9A $AA $BA ; ORA (dir idx ext)
                             
  decode pg1_JTB OR      $DA $EA $FA ; ORB (dir idx ext)
  decode pg1_R1  B       $DA $EA $FA ; ORB (dir idx ext)
  decode pg1_R2  DMEM_RD $DA $EA $FA ; ORB (dir idx ext)

  DATA_OR         R1, R2
  DATA_WRITE      R1

  SET_DATA_WIDTH  W_R1

  CCR_OP_W        OP_ooooXXXo 

  JUMP_TABLE_A_NEXT_PC
  end_state

ORCC:
  decode pg1_JTA ORCC  $1A ; ORCC (imm)
  decode pg1_R1  CCR   $1A ; ORCC (imm)
  decode pg1_R2  IDATA $1A ; ORCC (imm)

  DATA_OR         R1, R2   
  DATA_WRITE      R1

  SET_DATA_WIDTH  W_R1

  CCR_OP_W        OP_XXXXXXXX 

  JUMP_TABLE_A_NEXT_PC
  end_state

; //////////////////////////////////////////// SBC
; //
SBC:
  decode pg1_JTA SBC     $82         ; SBCA (imm)
  decode pg1_R1  A       $82         ; SBCA (imm)
  decode pg1_R2  IDATA   $82         ; SBCA (imm)
                                                
  decode pg1_JTA SBC     $C2         ; SBCB (imm)
  decode pg1_R1  B       $C2         ; SBCB (imm)
  decode pg1_R2  IDATA   $C2         ; SBCB (imm)
                             
  decode pg1_JTB SBC     $92 $A2 $B2 ; SBCA (dir idx ext)
  decode pg1_R1  A       $92 $A2 $B2 ; SBCA (dir idx ext)
  decode pg1_R2  DMEM_RD $92 $A2 $B2 ; SBCA (dir idx ext)
                                                     
  decode pg1_JTB SBC     $D2 $E2 $F2 ; SBCB (dir idx ext)
  decode pg1_R1  B       $D2 $E2 $F2 ; SBCB (dir idx ext)
  decode pg1_R2  DMEM_RD $D2 $E2 $F2 ; SBCB (dir idx ext)

  DATA_SUBC       R1, R2
  DATA_WRITE      R1

  SET_DATA_WIDTH  W_R1

  CCR_OP_W        OP_ooooXXXX ; INFO: Spec H Undefined, Turbo9 H not affected

  JUMP_TABLE_A_NEXT_PC
  end_state

; //////////////////////////////////////////// SUB
; //
SUB:
  decode pg1_JTA SUB     $80         ; SUBA (imm)
  decode pg1_R1  A       $80         ; SUBA (imm)
  decode pg1_R2  IDATA   $80         ; SUBA (imm)
                                                
  decode pg1_JTA SUB     $C0         ; SUBB (imm)
  decode pg1_R1  B       $C0         ; SUBB (imm)
  decode pg1_R2  IDATA   $C0         ; SUBB (imm)
                                                
  decode pg1_JTA SUB     $83         ; SUBD (imm)
  decode pg1_R1  D       $83         ; SUBD (imm)
  decode pg1_R2  IDATA   $83         ; SUBD (imm)
                             
  decode pg1_JTB SUB     $90 $A0 $B0 ; SUBA (dir idx ext)
  decode pg1_R1  A       $90 $A0 $B0 ; SUBA (dir idx ext)
  decode pg1_R2  DMEM_RD $90 $A0 $B0 ; SUBA (dir idx ext)
                                                      
  decode pg1_JTB SUB     $D0 $E0 $F0 ; SUBB (dir idx ext)
  decode pg1_R1  B       $D0 $E0 $F0 ; SUBB (dir idx ext)
  decode pg1_R2  DMEM_RD $D0 $E0 $F0 ; SUBB (dir idx ext)
                                                      
  decode pg1_JTB SUB     $93 $A3 $B3 ; SUBD (dir idx ext)
  decode pg1_R1  D       $93 $A3 $B3 ; SUBD (dir idx ext)
  decode pg1_R2  DMEM_RD $93 $A3 $B3 ; SUBD (dir idx ext)

  DATA_SUB        R1, R2
  DATA_WRITE      R1

  SET_DATA_WIDTH  W_R1

  CCR_OP_W        OP_ooooXXXX ; INFO: Spec H Undefined, Turbo9 H not affected (8-bit)

  JUMP_TABLE_A_NEXT_PC
  end_state


; //
; ////////////////////////////////////////////////////////////////////////////


; ////////////////////////////////////////////////////////////////////////////
;                        STORE INSTRUCTIONS
; ////////////////////////////////////////////////////////////////////////////
; //

; //////////////////////////////////////////// ST
; //
ST:
  decode pg1_JTA ST    $97 $B7 ; STA (dir ext)
  decode pg1_R1  A     $97 $B7 ; STA (dir ext)
  decode pg1_AR  IDATA $97 $B7 ; STA (dir ext)
                           
  decode pg1_JTA ST    $D7 $F7 ; STB (dir ext)
  decode pg1_R1  B     $D7 $F7 ; STB (dir ext)
  decode pg1_AR  IDATA $D7 $F7 ; STB (dir ext)
                           
  decode pg1_JTA ST    $DD $FD ; STD (dir ext)
  decode pg1_R1  D     $DD $FD ; STD (dir ext)
  decode pg1_AR  IDATA $DD $FD ; STD (dir ext)
                           
  decode pg2_JTA ST    $DF $FF ; STS (dir ext)
  decode pg2_R1  S     $DF $FF ; STS (dir ext)
  decode pg2_AR  IDATA $DF $FF ; STS (dir ext)
                           
  decode pg1_JTA ST    $DF $FF ; STU (dir ext)
  decode pg1_R1  U     $DF $FF ; STU (dir ext)
  decode pg1_AR  IDATA $DF $FF ; STU (dir ext)
                           
  decode pg1_JTA ST    $9F $BF ; STX (dir ext)
  decode pg1_R1  X     $9F $BF ; STX (dir ext)
  decode pg1_AR  IDATA $9F $BF ; STX (dir ext)
                           
  decode pg2_JTA ST    $9F $BF ; STY (dir ext)
  decode pg2_R1  Y     $9F $BF ; STY (dir ext)
  decode pg2_AR  IDATA $9F $BF ; STY (dir ext)
                           
  decode pg1_JTB ST    $A7     ; STA (idx)
  decode pg1_R1  A     $A7     ; STA (idx)
  decode pg1_AR  EA    $A7     ; STA (idx)
                                   
  decode pg1_JTB ST    $E7     ; STB (idx)
  decode pg1_R1  B     $E7     ; STB (idx)
  decode pg1_AR  EA    $E7     ; STB (idx)
                                   
  decode pg1_JTB ST    $ED     ; STD (idx)
  decode pg1_R1  D     $ED     ; STD (idx)
  decode pg1_AR  EA    $ED     ; STD (idx)
                                   
  decode pg2_JTB ST    $EF     ; STS (idx)
  decode pg2_R1  S     $EF     ; STS (idx)
  decode pg2_AR  EA    $EF     ; STS (idx)
                                   
  decode pg1_JTB ST    $EF     ; STU (idx)
  decode pg1_R1  U     $EF     ; STU (idx)
  decode pg1_AR  EA    $EF     ; STU (idx)
                                   
  decode pg1_JTB ST    $AF     ; STX (idx)
  decode pg1_R1  X     $AF     ; STX (idx)
  decode pg1_AR  EA    $AF     ; STX (idx)
                                   
  decode pg2_JTB ST    $AF     ; STY (idx)
  decode pg2_R1  Y     $AF     ; STY (idx)
  decode pg2_AR  EA    $AF     ; STY (idx)

  DATA_PASS_A     R1

  SET_DATA_WIDTH  W_R1

  CCR_OP_W        OP_ooooXXXo

  ADDR_PASS       AR
  DMEM_STORE_W

  JUMP_TABLE_A_NEXT_PC
  end_state

; //
; ////////////////////////////////////////////////////////////////////////////


; ////////////////////////////////////////////////////////////////////////////
;                   MODIFY MEMORY OR ACCUMULATOR INSTRUCTIONS
; ////////////////////////////////////////////////////////////////////////////
; //

; //////////////////////////////////////////// ASL LSL
; //
ASL_LSL:
  decode pg1_JTA ASL_LSL $48         ; ASLA LSLA (inh)
  decode pg1_R1  A       $48         ; ASLA LSLA (inh)
                                        
  decode pg1_JTA ASL_LSL $58         ; ASLB LSLB (inh)
  decode pg1_R1  B       $58         ; ASLB LSLB (inh)
                             
  decode pg1_JTB ASL_LSL $08 $68 $78 ; ASL LSL (dir idx ext)
  decode pg1_R1  DMEM_RD $08 $68 $78 ; ASL LSL (dir idx ext)

  DATA_LSHIFT_W   R1, ZERO_BIT
  DATA_WRITE      R1

  SET_DATA_WIDTH  W_R1

  CCR_OP_W        OP_ooooXXXX ; INFO: Spec H Undefined, Turbo9 H not affected

  ADDR_PASS       EA
  DMEM_STORE_W ; Disabled for inherent addressing modes

  JUMP_TABLE_A_NEXT_PC
  end_state

; //////////////////////////////////////////// ASR
; //
ASR:
  decode pg1_JTA ASR     $47         ; ASRA (inh)
  decode pg1_R1  A       $47         ; ASRA (inh)
                                         
  decode pg1_JTA ASR     $57         ; ASRB (inh)
  decode pg1_R1  B       $57         ; ASRB (inh)
                             
  decode pg1_JTB ASR     $07 $67 $77 ; ASR (dir idx ext)
  decode pg1_R1  DMEM_RD $07 $67 $77 ; ASR (dir idx ext)

  DATA_RSHIFT_W   SIGN_BIT, R1
  DATA_WRITE      R1

  SET_DATA_WIDTH  W_R1

  CCR_OP_W        OP_ooooXXoX ; INFO: Spec H Undefined, Turbo9 H not affected

  ADDR_PASS       EA
  DMEM_STORE_W  ; Disabled for inherent addressing modes

  JUMP_TABLE_A_NEXT_PC
  end_state

; //////////////////////////////////////////// CLR
; //
; // This is a little different than other memory modify
; // instructions. It does not load the memory first like
; // the 6809. It just writes a zero to be more efficient
CLR:

  decode pg1_JTA CLR     $4F     ; CLRA (inh)
  decode pg1_R1  A       $4F     ; CLRA (inh)
                                     
  decode pg1_JTA CLR     $5F     ; CLRB (inh)
  decode pg1_R1  B       $5F     ; CLRB (inh)
                           
  decode pg1_JTA CLR     $0F $7F ; CLR (dir ext)
  decode pg1_R1  DMEM_RD $0F $7F ; CLR (dir ext) sets 8bit width
  decode pg1_AR  IDATA   $0F $7F ; CLR (dir ext)
                           
  decode pg1_JTB CLR     $6F     ; CLR (idx)
  decode pg1_R1  DMEM_RD $6F     ; CLR (idx) sets 8bit width
  decode pg1_AR  EA      $6F     ; CLR (idx)

  DATA_PASS_B     ZERO 
  DATA_WRITE      R1

  SET_DATA_WIDTH  W_R1

  CCR_OP_W        OP_ooooXXXX

  ADDR_PASS       AR
  DMEM_STORE_W  ; Disabled for inherent addressing modes

  JUMP_TABLE_A_NEXT_PC
  end_state

; //////////////////////////////////////////// COM
; //
COM:
  decode pg1_JTA COM     $43         ; COMA (inh)
  decode pg1_R1  A       $43         ; COMA (inh)
  decode pg1_R2  A       $43         ; COMA (inh)
                                         
  decode pg1_JTA COM     $53         ; COMB (inh)
  decode pg1_R1  B       $53         ; COMB (inh)
  decode pg1_R2  B       $53         ; COMB (inh)
                             
  decode pg1_JTB COM     $03 $63 $73 ; COM (dir idx ext)
  decode pg1_R1  DMEM_RD $03 $63 $73 ; COM (dir idx ext) sets 8bit width
  decode pg1_R2  DMEM_RD $03 $63 $73 ; COM (dir idx ext)

  DATA_INVERT_B   R2
  DATA_WRITE      R1

  SET_DATA_WIDTH  W_R1

  CCR_OP_W        OP_ooooXXXX ; INFO Carry should be set to 1 for 6800 compatibility

  ADDR_PASS       EA
  DMEM_STORE_W ; Disabled for inherent addressing modes

  JUMP_TABLE_A_NEXT_PC
  end_state

; //////////////////////////////////////////// DEC
; //
DEC:
  decode pg1_JTA DEC     $4A         ; DECA (inh)
  decode pg1_R1  A       $4A         ; DECA (inh)
                                         
  decode pg1_JTA DEC     $5A         ; DECB (inh)
  decode pg1_R1  B       $5A         ; DECB (inh)
                             
  decode pg1_JTB DEC     $0A $6A $7A ; DEC (dir idx ext)
  decode pg1_R1  DMEM_RD $0A $6A $7A ; DEC (dir idx ext)

  DATA_DEC        R1
  DATA_WRITE      R1

  SET_DATA_WIDTH  W_R1
  
  CCR_OP_W        OP_ooooXXXo

  ADDR_PASS       EA
  DMEM_STORE_W ; Disabled for inherent addressing modes

  JUMP_TABLE_A_NEXT_PC
  end_state

; //////////////////////////////////////////// INC
; //
INC:
  decode pg1_JTA INC     $4C         ; INCA (inh)
  decode pg1_R1  A       $4C         ; INCA (inh)
                                         
  decode pg1_JTA INC     $5C         ; INCB (inh)
  decode pg1_R1  B       $5C         ; INCB (inh)
                             
  decode pg1_JTB INC     $0C $6C $7C ; INC (dir idx ext)
  decode pg1_R1  DMEM_RD $0C $6C $7C ; INC (dir idx ext)

  DATA_INC        R1
  DATA_WRITE      R1

  SET_DATA_WIDTH  W_R1

  CCR_OP_W        OP_ooooXXXo

  ADDR_PASS       EA
  DMEM_STORE_W ; Disabled for inherent addressing modes

  JUMP_TABLE_A_NEXT_PC
  end_state

; //////////////////////////////////////////// LSR
; //
LSR:
  decode pg1_JTA LSR     $44         ; LSRA (inh)
  decode pg1_R1  A       $44         ; LSRA (inh)
                                         
  decode pg1_JTA LSR     $54         ; LSRB (inh)
  decode pg1_R1  B       $54         ; LSRB (inh)
                             
  decode pg1_JTB LSR     $04 $64 $74 ; LSR (dir idx ext)
  decode pg1_R1  DMEM_RD $04 $64 $74 ; LSR (dir idx ext)

  DATA_RSHIFT_W   ZERO_BIT, R1
  DATA_WRITE      R1

  SET_DATA_WIDTH  W_R1

  CCR_OP_W        OP_ooooXXoX

  ADDR_PASS       EA
  DMEM_STORE_W ; Disabled for inherent addressing modes

  JUMP_TABLE_A_NEXT_PC
  end_state

; //////////////////////////////////////////// NEG
; //
NEG:
  decode pg1_JTA NEG     $40         ; NEGA (inh)
  decode pg1_R1  A       $40         ; NEGA (inh)
  decode pg1_R2  A       $40         ; NEGA (inh)
                                         
  decode pg1_JTA NEG     $50         ; NEGB (inh)
  decode pg1_R1  B       $50         ; NEGB (inh)
  decode pg1_R2  B       $50         ; NEGB (inh)
                                         
  decode pg1_JTB NEG     $00 $60 $70 ; NEG (dir idx ext)
  decode pg1_R1  DMEM_RD $00 $60 $70 ; NEG (dir idx ext) sets 8bit width
  decode pg1_R2  DMEM_RD $00 $60 $70 ; NEG (dir idx ext)

  DATA_SUB        ZERO, R2
  DATA_WRITE      R1

  SET_DATA_WIDTH  W_R1

  CCR_OP_W        OP_ooooXXXX ; INFO: Spec H Undefined, Turbo9 H not affected

  ADDR_PASS       EA
  DMEM_STORE_W ; Disabled for inherent addressing modes

  JUMP_TABLE_A_NEXT_PC
  end_state

; //////////////////////////////////////////// ROL
; //
ROL:
  decode pg1_JTA ROL     $49         ; ROLA (inh)
  decode pg1_R1  A       $49         ; ROLA (inh)
                                         
  decode pg1_JTA ROL     $59         ; ROLB (inh)
  decode pg1_R1  B       $59         ; ROLB (inh)
                                         
  decode pg1_JTB ROL     $09 $69 $79 ; ROL (dir idx ext)
  decode pg1_R1  DMEM_RD $09 $69 $79 ; ROL (dir idx ext)

  DATA_LSHIFT_W   R1, CARRY_BIT
  DATA_WRITE      R1

  SET_DATA_WIDTH  W_R1

  CCR_OP_W        OP_ooooXXXX

  ADDR_PASS       EA
  DMEM_STORE_W ; Disabled for inherent addressing modes

  JUMP_TABLE_A_NEXT_PC
  end_state

; //////////////////////////////////////////// ROR
; //
ROR:
  decode pg1_JTA ROR     $46         ; RORA (inh)
  decode pg1_R1  A       $46         ; RORA (inh)
                                                   
  decode pg1_JTA ROR     $56         ; RORB (inh)
  decode pg1_R1  B       $56         ; RORB (inh)
                             
  decode pg1_JTB ROR     $06 $66 $76 ; ROR (dir idx ext)
  decode pg1_R1  DMEM_RD $06 $66 $76 ; ROR (dir idx ext)

  DATA_RSHIFT_W   CARRY_BIT, R1
  DATA_WRITE      R1

  SET_DATA_WIDTH  W_R1

  CCR_OP_W        OP_ooooXXoX

  ADDR_PASS       EA
  DMEM_STORE_W ; Disabled for inherent addressing modes

  JUMP_TABLE_A_NEXT_PC
  end_state

; //////////////////////////////////////////// TST
; //
TST:
  decode pg1_JTA TST     $4D         ; TSTA (inh)
  decode pg1_R1  A       $4D         ; TSTA (inh)
                                         
  decode pg1_JTA TST     $5D         ; TSTB (inh)
  decode pg1_R1  B       $5D         ; TSTB (inh)
                             
  decode pg1_JTB TST     $0D $6D $7D ; TST (dir idx ext)
  decode pg1_R1  DMEM_RD $0D $6D $7D ; TST (dir idx ext)

  DATA_PASS_A     R1 ; Pass A, B or DMEM

  SET_DATA_WIDTH  W_R1

  CCR_OP_W        OP_ooooXXXo

  JUMP_TABLE_A_NEXT_PC
  end_state

; //
; ////////////////////////////////////////////////////////////////////////////



; ////////////////////////////////////////////////////////////////////////////
;                        JUMP & BRANCH INSTRUCTIONS
; ////////////////////////////////////////////////////////////////////////////
; //

; //////////////////////////////////////////// BRANCH
; //
BRANCH:
  decode pg1_JTA BRANCH $20 $21 $22 $23 ; BRA BRN BHI BLS
  decode pg1_JTB JMP    $20 $21 $22 $23 ; BRA BRN BHI BLS
  decode pg1_R1  PC     $20 $21 $22 $23 ; BRA BRN BHI BLS
  decode pg1_R2  EA     $20 $21 $22 $23 ; BRA BRN BHI BLS
                                            
  decode pg1_JTA BRANCH $24 $25 $26 $27 ; BCC BCS BNE BEQ
  decode pg1_JTB JMP    $24 $25 $26 $27 ; BCC BCS BNE BEQ
  decode pg1_R1  PC     $24 $25 $26 $27 ; BCC BCS BNE BEQ
  decode pg1_R2  EA     $24 $25 $26 $27 ; BCC BCS BNE BEQ
                                            
  decode pg1_JTA BRANCH $28 $29 $2A $2B ; BVC BVS BPL BMI
  decode pg1_JTB JMP    $28 $29 $2A $2B ; BVC BVS BPL BMI
  decode pg1_R1  PC     $28 $29 $2A $2B ; BVC BVS BPL BMI
  decode pg1_R2  EA     $28 $29 $2A $2B ; BVC BVS BPL BMI
                                            
  decode pg1_JTA BRANCH $2C $2D $2E $2F ; BGE BLT BGT BLE
  decode pg1_JTB JMP    $2C $2D $2E $2F ; BGE BLT BGT BLE
  decode pg1_R1  PC     $2C $2D $2E $2F ; BGE BLT BGT BLE
  decode pg1_R2  EA     $2C $2D $2E $2F ; BGE BLT BGT BLE
                                            
  decode pg1_JTA BRANCH $16             ; LBRA On page 1!
  decode pg1_JTB JMP    $16             ; LBRA
  decode pg1_R1  PC     $16             ; LBRA 
  decode pg1_R2  EA     $16             ; LBRA 
                
  decode pg1_JTA BRANCH $8D $17         ; BSR LBSR // FIXME could do this without JUMP_TABLE_A
  decode pg1_JTB JSR    $8D $17         ; BSR LBSR // FIXME check if smaller area
  decode pg1_R1  PC     $8D $17         ; BSR LBSR
  decode pg1_R2  EA     $8D $17         ; BSR LBSR
  decode pg1_AR  S      $8D $17         ; BSR LBSR
                            
; Another LBRA hidden on Page 2!
  decode pg2_JTA BRANCH $20 $21 $22 $23 ; LBRA LBRN LBHI LBLS
  decode pg2_JTB JMP    $20 $21 $22 $23 ; LBRA LBRN LBHI LBLS
  decode pg2_R1  PC     $20 $21 $22 $23 ; LBRA LBRN LBHI LBLS
  decode pg2_R2  EA     $20 $21 $22 $23 ; LBRA LBRN LBHI LBLS
                                                                  
  decode pg2_JTA BRANCH $24 $25 $26 $27 ; LBCC LBCS LBNE LBEQ
  decode pg2_JTB JMP    $24 $25 $26 $27 ; LBCC LBCS LBNE LBEQ
  decode pg2_R1  PC     $24 $25 $26 $27 ; LBCC LBCS LBNE LBEQ
  decode pg2_R2  EA     $24 $25 $26 $27 ; LBCC LBCS LBNE LBEQ
                                                                  
  decode pg2_JTA BRANCH $28 $29 $2A $2B ; LBVC LBVS LBPL LBMI
  decode pg2_JTB JMP    $28 $29 $2A $2B ; LBVC LBVS LBPL LBMI
  decode pg2_R1  PC     $28 $29 $2A $2B ; LBVC LBVS LBPL LBMI
  decode pg2_R2  EA     $28 $29 $2A $2B ; LBVC LBVS LBPL LBMI
                                                                  
  decode pg2_JTA BRANCH $2C $2D $2E $2F ; LBGE LBLT LBGT LBLE
  decode pg2_JTB JMP    $2C $2D $2E $2F ; LBGE LBLT LBGT LBLE
  decode pg2_R1  PC     $2C $2D $2E $2F ; LBGE LBLT LBGT LBLE
  decode pg2_R2  EA     $2C $2D $2E $2F ; LBGE LBLT LBGT LBLE

  DATA_ADD        R1, IDATA ; PC + signed offset
  DATA_WRITE      EA

  SET_DATA_WIDTH  W_R1

  IF              BRANCH_COND
  JUMP_TABLE_B
  end_state

GO_NEW_PC:
  JUMP_TABLE_A_NEXT_PC
  end_state

; //////////////////////////////////////////// JMP
; //
JMP:
  decode pg1_JTA JMP   $0E $7E ; JMP (dir ext)
  decode pg1_R1  PC    $0E $7E ; JMP (dir ext)
  decode pg1_R2  IDATA $0E $7E ; JMP (dir ext)
                                   
  decode pg1_JTB JMP   $6E     ; JMP (idx)
  decode pg1_R1  PC    $6E     ; JMP (idx)
  decode pg1_R2  EA    $6E     ; JMP (idx)

  DATA_PASS_B     R2 ; IDATA or EA
  DATA_WRITE      R1 ; PC

  JUMP            GO_NEW_PC ; PC must be written before "JUMP_TABLE_A_NEXT_PC"
  end_state


; ////////////////////////////////////////////////////////////////////////////



; ////////////////////////////////////////////////////////////////////////////
;                        STACK INSTRUCTIONS
; ////////////////////////////////////////////////////////////////////////////
; //


; //////////////////////////////////////////// JSR
; //
JSR:
  decode pg1_JTA JSR   $9D $BD ; JSR (dir ext)
  decode pg1_R1  PC    $9D $BD ; JSR (dir ext)
  decode pg1_R2  IDATA $9D $BD ; JSR (dir ext)
  decode pg1_AR  S     $9D $BD ; JSR (dir ext)
                                 
  decode pg1_JTB JSR   $AD     ; JSR (idx)
  decode pg1_R1  PC    $AD     ; JSR (idx)
  decode pg1_R2  EA    $AD     ; JSR (idx)
  decode pg1_AR  S     $AD     ; JSR (idx)

  DATA_PASS_A     R1 ; PC

  SET_DATA_WIDTH  W_R1

  STACK_PUSH      AR
  DMEM_STORE_W

  JUMP            JMP 
  end_state

; //////////////////////////////////////////// RTS
; //
RTS:
  decode pg1_JTA RTS      $39 ; RTS
  decode pg1_R1  PC       $39 ; RTS
  decode pg1_R2  DMEM_RD  $39 ; RTS
  decode pg1_AR  S        $39 ; RTS

  SET_DATA_WIDTH  W_R1
  
  STACK_PULL      AR
  DMEM_LOAD_W
  
  JUMP            JMP
  end_state

; //////////////////////////////////////////// RTI
; //
RTI:
  decode pg1_JTA RTI      $3B ; RTI
  decode pg1_R1  PC       $3B ; RTI
  decode pg1_R2  DMEM_RD  $3B ; RTI
  decode pg1_AR  S        $3B ; RTI
  
  STACK_PULL      ZERO  ; Prime the decode pipeline!
  end_state

  SET_DATA_WIDTH  W_STACK_REG
  
  STACK_PULL      AR
  DMEM_LOAD_W
  end_state

RTI_CCR:
  DATA_PASS_B     DMEM_RD
  DATA_WRITE      STACK_REG

  CCR_OP_W        OP_XXXXXXXX ; FIXME get rid of this requirement
  end_state

RTI_TEST_E:
  IF              E_CLEAR
  JUMP            RTS
  end_state

RTI_PUL_ALL:
  SET_DATA_WIDTH  W_STACK_REG
  
  STACK_PULL      AR
  DMEM_LOAD_W
  
  JUMP            PUL_LOOP
  end_state


; //////////////////////////////////////////// PULS PULU
; //
PUL:
  decode pg1_JTA PUL  $35 ; PULS
  decode pg1_AR  S    $35 ; PULS

  decode pg1_JTA PUL  $37 ; PULU
  decode pg1_AR  U    $37 ; PULU

  
  STACK_PULL      ZERO  ; Prime the decode pipeline!
  
  IF              STACK_DONE
  JUMP            NOP
  end_state
  
  SET_DATA_WIDTH  W_STACK_REG
  
  STACK_PULL      AR
  DMEM_LOAD_W
  
  IF              STACK_DONE
  JUMP            PUL_DONE
  end_state

PUL_LOOP:
  DATA_PASS_B     DMEM_RD
  DATA_WRITE      STACK_REG

  CCR_OP_W        OP_XXXXXXXX ; FIXME get rid of this requirement
  
  SET_DATA_WIDTH  W_STACK_REG

  STACK_PULL      AR
  DMEM_LOAD_W

  IF              STACK_NEXT
  JUMP            PUL_LOOP
  end_state

PUL_DONE:
  DATA_PASS_B     DMEM_RD
  DATA_WRITE      STACK_REG

  CCR_OP_W        OP_XXXXXXXX ; FIXME get rid of this requirement

  JUMP            GO_NEW_PC ; PC must be written before "JUMP_TABLE_A_NEXT_PC" FIXME?
  end_state


; //////////////////////////////////////////// PSHS PSHU
; //
PSH:
  decode pg1_JTA PSH   $34 ; PSHS
  decode pg1_AR  S     $34 ; PSHS

  decode pg1_JTA PSH   $36 ; PSHU
  decode pg1_AR  U     $36 ; PSHU
  
  STACK_PUSH      ZERO  ; Prime the decode pipeline!

  IF              STACK_DONE
  JUMP            NOP
  end_state
  
PSH_LOOP:
  DATA_PASS_A     STACK_REG
  
  SET_DATA_WIDTH  W_STACK_REG

  STACK_PUSH      AR
  DMEM_STORE_W

  IF              STACK_NEXT
  JUMP            PSH_LOOP
  end_state

  JUMP_TABLE_A_NEXT_PC
  end_state


; //////////////////////////////////////////// SWI
; //
SWI:
  decode pg1_JTA SWI      $3F ; SWI
  decode pg1_AR  S        $3F ; SWI
  decode pg1_R1  PC       $3F ; SWI
  decode pg1_R2  DMEM_RD  $3F ; SWI
  
  STACK_PUSH      ZERO  ; Prime the decode pipeline!

  CCR_OP_W        OP_1ooooooo ; Set E
  end_state
  
SWI_LOOP:
  DATA_PASS_A     STACK_REG
  
  SET_DATA_WIDTH  W_STACK_REG

  STACK_PUSH      AR
  DMEM_STORE_W

  IF              STACK_NEXT
  JUMP            SWI_LOOP
  end_state

  ; R1 is PC
  ; R2 is DMEM_RD

  SET_DATA_WIDTH  W_16

  ADDR_PASS       IDATA ; SWI vector
  DMEM_LOAD_W
  
  CCR_OP_W        OP_o1o1oooo ; Set I & F

  JUMP            JMP
  end_state



; ////////////////////////////////////////////////////////////////////////////


  ORG  $FF

TRAP:

  JUMP            TRAP
  end_state


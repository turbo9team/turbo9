// [TURBO9_HEADER_START]
//////////////////////////////////////////////////////////////////////////////
//                          Turbo9 Microprocessor IP
//////////////////////////////////////////////////////////////////////////////
// Website: www.turbo9.org
// Contact: team[at]turbo9[dot]org
//////////////////////////////////////////////////////////////////////////////
// [TURBO9_LICENSE_START]
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
// [TURBO9_LICENSE_END]
//////////////////////////////////////////////////////////////////////////////
// Engineer: Kevin Phillipson
// Description: Turbo9 instruction pre-decoder
//
//////////////////////////////////////////////////////////////////////////////
// History:
// 07.14.2023 - Kevin Phillipson
//   File header added
//
//////////////////////////////////////////////////////////////////////////////
// [TURBO9_HEADER_END]

/////////////////////////////////////////////////////////////////////////////
//                                MODULE
/////////////////////////////////////////////////////////////////////////////
module turbo9_instr_format_decode
(
  input         [7:0] QUEUE_D3_I,
  input         [7:0] QUEUE_D2_I,
  input         [7:0] QUEUE_D1_I,
  input         [7:0] QUEUE_D0_I,
  input         [1:0] PAGE_SEL_I,
  output reg    [2:0] INSTR_LEN_O,
  output reg   [15:0] INSTR_DATA_O,
  output reg          INSTR_DIRECT_EN_O,
  output reg          INSTR_INH_EN_O,
  output reg    [3:0] INSTR_R1_SEL_O,
  output reg    [3:0] INSTR_R2_SEL_O,
  output reg    [3:0] INSTR_AR_SEL_O,
  output reg    [7:0] INSTR_JUMP_TABLE_A_O,
  output reg    [7:0] INSTR_JUMP_TABLE_B_O
);

/////////////////////////////////////////////////////////////////////////////
//                             INTERNAL SIGNALS
/////////////////////////////////////////////////////////////////////////////


// Instruction Data
wire [15:0] instr_data_x       = {8'hxx               , 8'hxx           }; // dont_care
wire [15:0] instr_data_s08     = {{8{QUEUE_D1_I[7]}}  , QUEUE_D1_I      }; // instr_data_s08
wire [15:0] instr_data_u08     = {8'h00               , QUEUE_D1_I      }; // instr_data_u08    
wire [15:0] instr_data_u16     = {QUEUE_D1_I          , QUEUE_D2_I      }; // instr_data_u16    
wire [15:0] instr_data_idx_s05 = {{11{QUEUE_D1_I[4]}} , QUEUE_D1_I[4:0] }; // instr_data_idx_s05
wire [15:0] instr_data_idx_s08 = {{8{QUEUE_D2_I[7]}}  , QUEUE_D2_I      }; // instr_data_idx_s08
wire [15:0] instr_data_idx_s16 = {QUEUE_D2_I          , QUEUE_D3_I      }; // instr_data_idx_s16
wire [15:0] swi_vector_u16     = {16'hFFFA                              }; // swi_vector_u16

localparam   len_1 = 3'h1;
localparam   len_2 = 3'h2;
localparam   len_3 = 3'h3;
localparam   len_4 = 3'h4;

localparam   dir_1 = 1'b1;
localparam   dir_0 = 1'b0;
localparam   dir_x = 1'bx;

localparam   inh_1 = 1'b1;
localparam   inh_0 = 1'b0;
localparam   inh_x = 1'bx;

localparam   page_sel_2 = 2'b10;
localparam   page_sel_3 = 2'b11;


////////////////// i_format
//  [20:5]  instr_data 
//  [   4]  inherent
//  [   3]  direct
//  [ 2:0]  length
reg  [20:0] i_format;
wire [20:0] direct_2               = { instr_data_u08     , inh_0 , dir_1 , len_2 };
wire [20:0] extended_3             = { instr_data_u16     , inh_0 , dir_0 , len_3 };
wire [20:0] immediate_2            = { instr_data_u08     , inh_0 , dir_0 , len_2 };
wire [20:0] immediate_3            = { instr_data_u16     , inh_0 , dir_0 , len_3 };
wire [20:0] inherent_1             = { instr_data_x       , inh_1 , dir_x , len_1 };
wire [20:0] swi_1                  = { swi_vector_u16     , inh_0 , dir_0 , len_1 };
wire [20:0] dont_care_1            = { instr_data_x       , inh_0 , dir_x , len_1 };
wire [20:0] dont_care_2            = { instr_data_x       , inh_0 , dir_x , len_2 };
                                                            
reg  [20:0] relative_2to3;                                           
wire [20:0] relative_2             = { instr_data_s08     , inh_0 , dir_0 , len_2 };
wire [20:0] relative_3             = { instr_data_u16     , inh_0 , dir_0 , len_3 };

reg  [20:0] indexed_2to4;                                           
wire [20:0] indexed_offset_8bit_3  = { instr_data_idx_s08 , inh_0 , dir_0 , len_3 };
wire [20:0] indexed_offset_16bit_4 = { instr_data_idx_s16 , inh_0 , dir_0 , len_4 };
wire [20:0] indexed_2              = { instr_data_idx_s05 , inh_0 , dir_0 , len_2 };

wire  [7:0] pg1_jta;
wire  [7:0] pg1_jtb;
wire  [3:0] pg1_r1;
wire  [3:0] pg1_r2;
wire  [3:0] pg1_ar;

wire  [3:0] pg1_r1_i;
wire  [3:0] pg1_r2_i;

wire  [7:0] pg2_jta;
wire  [7:0] pg2_jtb;
wire  [3:0] pg2_r1;
wire  [3:0] pg2_r2;
wire  [3:0] pg2_ar;

wire  [7:0] pg3_jta;
wire  [7:0] pg3_jtb;
wire  [3:0] pg3_r1;
wire  [3:0] pg3_r2;
wire  [3:0] pg3_ar;

/////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////
//                          PAGE 1, 2 & 3 DECODE LOGIC
/////////////////////////////////////////////////////////////////////////////

always @* begin    
  case (QUEUE_D0_I)
                                       ///////////////////////////////////////
                                       // Page 1    / Page 2    / Page 3    //
    //////////////////////////////////////////////////////////////////////////
    8'h00 : i_format = direct_2      ; // NEG       / --------- / --------- //
    //8'h01 : i_format =             ; // --------- / --------- / --------- //
    //8'h02 : i_format =             ; // --------- / --------- / --------- //
    8'h03 : i_format = direct_2      ; // COM       / --------- / --------- //
    8'h04 : i_format = direct_2      ; // LSR       / --------- / --------- //
    //8'h05 : i_format =             ; // --------- / --------- / --------- //
    8'h06 : i_format = direct_2      ; // ROR       / --------- / --------- //
    8'h07 : i_format = direct_2      ; // ASR       / --------- / --------- //
    8'h08 : i_format = direct_2      ; // ASL_LSL   / --------- / --------- //
    8'h09 : i_format = direct_2      ; // ROL       / --------- / --------- //
    8'h0A : i_format = direct_2      ; // DEC       / --------- / --------- //
    //8'h0B : i_format =             ; // --------- / --------- / --------- //
    8'h0C : i_format = direct_2      ; // INC       / --------- / --------- //
    8'h0D : i_format = direct_2      ; // TST       / --------- / --------- //
    8'h0E : i_format = direct_2      ; // JMP       / --------- / --------- //
    8'h0F : i_format = direct_2      ; // CLR       / --------- / --------- // Reg Pointer vs microcoded?
    //////////////////////////////////////////////////////////////////////////
    8'h10 : i_format = dont_care_1   ; // Prebyte_2 / --------- / --------- //
    8'h11 : i_format = dont_care_1   ; // Prebyte_3 / --------- / --------- //
    8'h12 : i_format = dont_care_1   ; // NOP       / --------- / --------- //
    8'h13 : i_format = dont_care_1   ; // SYNC      / --------- / --------- //
    8'h14 : i_format = dont_care_1   ; // EMUL *    / EDIV *    / --------- //
    8'h15 : i_format = dont_care_1   ; // EMULS *   / EDIVS *   / --------- //
    8'h16 : i_format = relative_3    ; // LBRA      / --------- / --------- //
    8'h17 : i_format = relative_3    ; // LBSR      / --------- / --------- //
    8'h18 : i_format = dont_care_1   ; // IDIV *    / IDIVS *   / --------- // 
    8'h19 : i_format = dont_care_1   ; // DAA       / FDIV *    / --------- //
    8'h1A : i_format = immediate_2   ; // ORCC      / --------- / --------- //
    //8'h1B : i_format =             ; // --------- / --------- / --------- //
    8'h1C : i_format = immediate_2   ; // ANDCC     / --------- / --------- //
    8'h1D : i_format = dont_care_1   ; // SEX       / --------- / --------- //
    8'h1E : i_format = dont_care_2   ; // EXG       / --------- / --------- //
    8'h1F : i_format = dont_care_2   ; // TFR       / --------- / --------- //
    //////////////////////////////////////////////////////////////////////////
    8'h20 : i_format = relative_2to3 ; // BRA       / LBRA *    / --------- //
    8'h21 : i_format = relative_2to3 ; // BRN       / LBRN      / --------- //
    8'h22 : i_format = relative_2to3 ; // BHI       / LBHI      / --------- //
    8'h23 : i_format = relative_2to3 ; // BLS       / LBLS      / --------- //
    8'h24 : i_format = relative_2to3 ; // BHS_BCC   / LBHS_LBCC / --------- //
    8'h25 : i_format = relative_2to3 ; // BLO_BCS   / LBLO_LBCS / --------- //
    8'h26 : i_format = relative_2to3 ; // BNE       / LBNE      / --------- //
    8'h27 : i_format = relative_2to3 ; // BEQ       / LBEQ      / --------- //
    8'h28 : i_format = relative_2to3 ; // BVC       / LBVC      / --------- //
    8'h29 : i_format = relative_2to3 ; // BVS       / LBVS      / --------- //
    8'h2A : i_format = relative_2to3 ; // BPL       / LBPL      / --------- //
    8'h2B : i_format = relative_2to3 ; // BMI       / LBMI      / --------- //
    8'h2C : i_format = relative_2to3 ; // BGE       / LBGE      / --------- //
    8'h2D : i_format = relative_2to3 ; // BLT       / LBLT      / --------- //
    8'h2E : i_format = relative_2to3 ; // BGT       / LBGT      / --------- //
    8'h2F : i_format = relative_2to3 ; // BLE       / LBLE      / --------- //
    //////////////////////////////////////////////////////////////////////////
    8'h30 : i_format = indexed_2to4  ; // LEAX      / --------- / --------- //
    8'h31 : i_format = indexed_2to4  ; // LEAY      / --------- / --------- //
    8'h32 : i_format = indexed_2to4  ; // LEAS      / --------- / --------- //
    8'h33 : i_format = indexed_2to4  ; // LEAU      / --------- / --------- //
    8'h34 : i_format = dont_care_2   ; // PSHS      / --------- / --------- //
    8'h35 : i_format = dont_care_2   ; // PULS      / --------- / --------- //
    8'h36 : i_format = dont_care_2   ; // PSHU      / --------- / --------- //
    8'h37 : i_format = dont_care_2   ; // PULU      / --------- / --------- //
    //8'h38 : i_format =             ; // --------- / --------- / --------- //
    8'h39 : i_format = dont_care_1   ; // RTS       / --------- / --------- //
    8'h3A : i_format = dont_care_1   ; // ABX       / --------- / --------- //
    8'h3B : i_format = dont_care_1   ; // RTI       / --------- / --------- //
    8'h3C : i_format = immediate_2   ; // CWAI      / --------- / --------- //
    8'h3D : i_format = dont_care_1   ; // MUL       / --------- / --------- //
    //8'h3E : i_format =             ; // --------- / --------- / --------- //
    8'h3F : i_format = swi_1         ; // SWI       / SWI2      / SWI3      //
    //////////////////////////////////////////////////////////////////////////
    8'h40 : i_format = inherent_1    ; // NEGA      / --------- / --------- //
    //8'h41 : i_format =             ; // --------- / --------- / --------- //
    //8'h42 : i_format =             ; // --------- / --------- / --------- //
    8'h43 : i_format = inherent_1    ; // COMA      / --------- / --------- //
    8'h44 : i_format = inherent_1    ; // LSRA      / --------- / --------- //
    //8'h45 : i_format =             ; // --------- / --------- / --------- //
    8'h46 : i_format = inherent_1    ; // RORA      / --------- / --------- //
    8'h47 : i_format = inherent_1    ; // ASRA      / --------- / --------- //
    8'h48 : i_format = inherent_1    ; // ASLA_LSLA / --------- / --------- //
    8'h49 : i_format = inherent_1    ; // ROLA      / --------- / --------- //
    8'h4A : i_format = inherent_1    ; // DECA      / --------- / --------- //
    //8'h4B : i_format =             ; // --------- / --------- / --------- //
    8'h4C : i_format = inherent_1    ; // INCA      / --------- / --------- //
    8'h4D : i_format = inherent_1    ; // TSTA      / --------- / --------- //
    //8'h4E : i_format =             ; // --------- / --------- / --------- //
    8'h4F : i_format = inherent_1    ; // CLRA      / --------- / --------- //
    //////////////////////////////////////////////////////////////////////////
    8'h50 : i_format = inherent_1    ; // NEGB      / --------- / --------- //
    //8'h51 : i_format =             ; // --------- / --------- / --------- //
    //8'h52 : i_format =             ; // --------- / --------- / --------- //
    8'h53 : i_format = inherent_1    ; // COMB      / --------- / --------- //
    8'h54 : i_format = inherent_1    ; // LSRB      / --------- / --------- //
    //8'h55 : i_format =             ; // --------- / --------- / --------- //
    8'h56 : i_format = inherent_1    ; // RORB      / --------- / --------- //
    8'h57 : i_format = inherent_1    ; // ASRB      / --------- / --------- //
    8'h58 : i_format = inherent_1    ; // ASLB_LSLB / --------- / --------- //
    8'h59 : i_format = inherent_1    ; // ROLB      / --------- / --------- //
    8'h5A : i_format = inherent_1    ; // DECB      / --------- / --------- //
    //8'h5B : i_format =             ; // --------- / --------- / --------- //
    8'h5C : i_format = inherent_1    ; // INCB      / --------- / --------- //
    8'h5D : i_format = inherent_1    ; // TSTB      / --------- / --------- //
    //8'h5E : i_format =             ; // --------- / --------- / --------- //
    8'h5F : i_format = inherent_1    ; // CLRB      / --------- / --------- //
    //////////////////////////////////////////////////////////////////////////
    8'h60 : i_format = indexed_2to4  ; // NEG       / --------- / --------- //
    //8'h61 : i_format =             ; // --------- / --------- / --------- //
    //8'h62 : i_format =             ; // --------- / --------- / --------- //
    8'h63 : i_format = indexed_2to4  ; // COM       / --------- / --------- //
    8'h64 : i_format = indexed_2to4  ; // LSR       / --------- / --------- //
    //8'h65 : i_format =             ; // --------- / --------- / --------- //
    8'h66 : i_format = indexed_2to4  ; // ROR       / --------- / --------- //
    8'h67 : i_format = indexed_2to4  ; // ASR       / --------- / --------- //
    8'h68 : i_format = indexed_2to4  ; // ASL_LSL   / --------- / --------- //
    8'h69 : i_format = indexed_2to4  ; // ROL       / --------- / --------- //
    8'h6A : i_format = indexed_2to4  ; // DEC       / --------- / --------- //
    //8'h6B : i_format =             ; // --------- / --------- / --------- //
    8'h6C : i_format = indexed_2to4  ; // INC       / --------- / --------- //
    8'h6D : i_format = indexed_2to4  ; // TST       / --------- / --------- //
    8'h6E : i_format = indexed_2to4  ; // JMP       / --------- / --------- //
    8'h6F : i_format = indexed_2to4  ; // CLR       / --------- / --------- //
    //////////////////////////////////////////////////////////////////////////
    8'h70 : i_format = extended_3    ; // NEG       / --------- / --------- //
    //8'h71 : i_format =             ; // --------- / --------- / --------- //
    //8'h72 : i_format =             ; // --------- / --------- / --------- //
    8'h73 : i_format = extended_3    ; // COM       / --------- / --------- //
    8'h74 : i_format = extended_3    ; // LSR       / --------- / --------- //
    //8'h75 : i_format =             ; // --------- / --------- / --------- //
    8'h76 : i_format = extended_3    ; // ROR       / --------- / --------- //
    8'h77 : i_format = extended_3    ; // ASR       / --------- / --------- //
    8'h78 : i_format = extended_3    ; // ASL_LSL   / --------- / --------- //
    8'h79 : i_format = extended_3    ; // ROL       / --------- / --------- //
    8'h7A : i_format = extended_3    ; // DEC       / --------- / --------- //
    //8'h7B : i_format =             ; // --------- / --------- / --------- //
    8'h7C : i_format = extended_3    ; // INC       / --------- / --------- //
    8'h7D : i_format = extended_3    ; // TST       / --------- / --------- //
    8'h7E : i_format = extended_3    ; // JMP       / --------- / --------- //
    8'h7F : i_format = extended_3    ; // CLR       / --------- / --------- //
    //////////////////////////////////////////////////////////////////////////
    8'h80 : i_format = immediate_2   ; // SUBA      / --------- / --------- //
    8'h81 : i_format = immediate_2   ; // CMPA      / --------- / --------- //
    8'h82 : i_format = immediate_2   ; // SBCA      / --------- / --------- //
    8'h83 : i_format = immediate_3   ; // SUBD      / CMPD      / CMPU      //
    8'h84 : i_format = immediate_2   ; // ANDA      / --------- / --------- //
    8'h85 : i_format = immediate_2   ; // BITA      / --------- / --------- //
    8'h86 : i_format = immediate_2   ; // LDA       / --------- / --------- //
    //8'h87 : i_format =             ; // --------- / --------- / --------- //
    8'h88 : i_format = immediate_2   ; // EORA      / --------- / --------- //
    8'h89 : i_format = immediate_2   ; // ADCA      / --------- / --------- //
    8'h8A : i_format = immediate_2   ; // ORA       / --------- / --------- //
    8'h8B : i_format = immediate_2   ; // ADDA      / --------- / --------- //
    8'h8C : i_format = immediate_3   ; // CMPX      / CMPY      / CMPS      //
    8'h8D : i_format = relative_2    ; // BSR       / --------- / --------- //
    8'h8E : i_format = immediate_3   ; // LDX       / LDY       / --------- //
    //8'h8F : i_format =             ; // --------- / --------- / --------- //
    //////////////////////////////////////////////////////////////////////////
    8'h90 : i_format = direct_2      ; // SUBA      / --------- / --------- //
    8'h91 : i_format = direct_2      ; // CMPA      / --------- / --------- //
    8'h92 : i_format = direct_2      ; // SBCA      / --------- / --------- //
    8'h93 : i_format = direct_2      ; // SUBD      / CMPD      / CMPU      //
    8'h94 : i_format = direct_2      ; // ANDA      / --------- / --------- //
    8'h95 : i_format = direct_2      ; // BITA      / --------- / --------- //
    8'h96 : i_format = direct_2      ; // LDA       / --------- / --------- //
    8'h97 : i_format = direct_2      ; // STA       / --------- / --------- //
    8'h98 : i_format = direct_2      ; // EORA      / --------- / --------- //
    8'h99 : i_format = direct_2      ; // ADCA      / --------- / --------- //
    8'h9A : i_format = direct_2      ; // ORA       / --------- / --------- //
    8'h9B : i_format = direct_2      ; // ADDA      / --------- / --------- //
    8'h9C : i_format = direct_2      ; // CMPX      / CMPY      / CMPS      //
    8'h9D : i_format = direct_2      ; // JSR       / --------- / --------- //
    8'h9E : i_format = direct_2      ; // LDX       / LDY       / --------- //
    8'h9F : i_format = direct_2      ; // STX       / STY       / --------- //
    //////////////////////////////////////////////////////////////////////////
    8'hA0 : i_format = indexed_2to4  ; // SUBA      / --------- / --------- //
    8'hA1 : i_format = indexed_2to4  ; // CMPA      / --------- / --------- //
    8'hA2 : i_format = indexed_2to4  ; // SBCA      / --------- / --------- //
    8'hA3 : i_format = indexed_2to4  ; // SUBD      / CMPD      / CMPU      //
    8'hA4 : i_format = indexed_2to4  ; // ANDA      / --------- / --------- //
    8'hA5 : i_format = indexed_2to4  ; // BITA      / --------- / --------- //
    8'hA6 : i_format = indexed_2to4  ; // LDA       / --------- / --------- //
    8'hA7 : i_format = indexed_2to4  ; // STA       / --------- / --------- //
    8'hA8 : i_format = indexed_2to4  ; // EORA      / --------- / --------- //
    8'hA9 : i_format = indexed_2to4  ; // ADCA      / --------- / --------- //
    8'hAA : i_format = indexed_2to4  ; // ORA       / --------- / --------- //
    8'hAB : i_format = indexed_2to4  ; // ADDA      / --------- / --------- //
    8'hAC : i_format = indexed_2to4  ; // CMPX      / CMPY      / CMPS      //
    8'hAD : i_format = indexed_2to4  ; // JSR       / --------- / --------- //
    8'hAE : i_format = indexed_2to4  ; // LDX       / LDY       / --------- //
    8'hAF : i_format = indexed_2to4  ; // STX       / STY       / --------- //
    //////////////////////////////////////////////////////////////////////////
    8'hB0 : i_format = extended_3    ; // SUBA      / --------- / --------- //
    8'hB1 : i_format = extended_3    ; // CMPA      / --------- / --------- //
    8'hB2 : i_format = extended_3    ; // SBCA      / --------- / --------- //
    8'hB3 : i_format = extended_3    ; // SUBD      / CMPD      / CMPU      //
    8'hB4 : i_format = extended_3    ; // ANDA      / --------- / --------- //
    8'hB5 : i_format = extended_3    ; // BITA      / --------- / --------- //
    8'hB6 : i_format = extended_3    ; // LDA       / --------- / --------- //
    8'hB7 : i_format = extended_3    ; // STA       / --------- / --------- //
    8'hB8 : i_format = extended_3    ; // EORA      / --------- / --------- //
    8'hB9 : i_format = extended_3    ; // ADCA      / --------- / --------- //
    8'hBA : i_format = extended_3    ; // ORA       / --------- / --------- //
    8'hBB : i_format = extended_3    ; // ADDA      / --------- / --------- //
    8'hBC : i_format = extended_3    ; // CMPX      / CMPY      / CMPS      //
    8'hBD : i_format = extended_3    ; // JSR       / --------- / --------- //
    8'hBE : i_format = extended_3    ; // LDX       / LDY       / --------- //
    8'hBF : i_format = extended_3    ; // STX       / STY       / --------- //
    //////////////////////////////////////////////////////////////////////////
    8'hC0 : i_format = immediate_2   ; // SUBB      / --------- / --------- //
    8'hC1 : i_format = immediate_2   ; // CMPB      / --------- / --------- //
    8'hC2 : i_format = immediate_2   ; // SBCB      / --------- / --------- //
    8'hC3 : i_format = immediate_3   ; // ADDD      / --------- / --------- //
    8'hC4 : i_format = immediate_2   ; // ANDB      / --------- / --------- //
    8'hC5 : i_format = immediate_2   ; // BITB      / --------- / --------- //
    8'hC6 : i_format = immediate_2   ; // LDB       / --------- / --------- //
    //8'hC7 : i_format =             ; // --------- / --------- / --------- //
    8'hC8 : i_format = immediate_2   ; // EORB      / --------- / --------- //
    8'hC9 : i_format = immediate_2   ; // ADCB      / --------- / --------- //
    8'hCA : i_format = immediate_2   ; // ORB       / --------- / --------- //
    8'hCB : i_format = immediate_2   ; // ADDB      / --------- / --------- //
    8'hCC : i_format = immediate_3   ; // LDD       / --------- / --------- //
    //8'hCD : i_format =             ; // --------- / --------- / --------- //
    8'hCE : i_format = immediate_3   ; // LDU       / LDS       / --------- //
    //8'hCF : i_format =             ; // --------- / --------- / --------- //
    //////////////////////////////////////////////////////////////////////////
    8'hD0 : i_format = direct_2      ; // SUBB      / --------- / --------- //
    8'hD1 : i_format = direct_2      ; // CMPB      / --------- / --------- //
    8'hD2 : i_format = direct_2      ; // SBCB      / --------- / --------- //
    8'hD3 : i_format = direct_2      ; // ADDD      / --------- / --------- //
    8'hD4 : i_format = direct_2      ; // ANDB      / --------- / --------- //
    8'hD5 : i_format = direct_2      ; // BITB      / --------- / --------- //
    8'hD6 : i_format = direct_2      ; // LDB       / --------- / --------- //
    8'hD7 : i_format = direct_2      ; // STB       / --------- / --------- //
    8'hD8 : i_format = direct_2      ; // EORB      / --------- / --------- //
    8'hD9 : i_format = direct_2      ; // ADCB      / --------- / --------- //
    8'hDA : i_format = direct_2      ; // ORB       / --------- / --------- //
    8'hDB : i_format = direct_2      ; // ADDB      / --------- / --------- //
    8'hDC : i_format = direct_2      ; // LDD       / --------- / --------- //
    8'hDD : i_format = direct_2      ; // STD       / --------- / --------- //
    8'hDE : i_format = direct_2      ; // LDU       / LDS       / --------- //
    8'hDF : i_format = direct_2      ; // STU       / STS       / --------- //
    //////////////////////////////////////////////////////////////////////////
    8'hE0 : i_format = indexed_2to4  ; // SUBB      / --------- / --------- //
    8'hE1 : i_format = indexed_2to4  ; // CMPB      / --------- / --------- //
    8'hE2 : i_format = indexed_2to4  ; // SBCB      / --------- / --------- //
    8'hE3 : i_format = indexed_2to4  ; // ADDD      / --------- / --------- //
    8'hE4 : i_format = indexed_2to4  ; // ANDB      / --------- / --------- //
    8'hE5 : i_format = indexed_2to4  ; // BITB      / --------- / --------- //
    8'hE6 : i_format = indexed_2to4  ; // LDB       / --------- / --------- //
    8'hE7 : i_format = indexed_2to4  ; // STB       / --------- / --------- //
    8'hE8 : i_format = indexed_2to4  ; // EORB      / --------- / --------- //
    8'hE9 : i_format = indexed_2to4  ; // ADCB      / --------- / --------- //
    8'hEA : i_format = indexed_2to4  ; // ORB       / --------- / --------- //
    8'hEB : i_format = indexed_2to4  ; // ADDB      / --------- / --------- //
    8'hEC : i_format = indexed_2to4  ; // LDD       / --------- / --------- //
    8'hED : i_format = indexed_2to4  ; // STD       / --------- / --------- //
    8'hEE : i_format = indexed_2to4  ; // LDU       / LDS       / --------- //
    8'hEF : i_format = indexed_2to4  ; // STU       / STS       / --------- //
    //////////////////////////////////////////////////////////////////////////
    8'hF0 : i_format = extended_3    ; // SUBB      / --------- / --------- //
    8'hF1 : i_format = extended_3    ; // CMPB      / --------- / --------- //
    8'hF2 : i_format = extended_3    ; // SBCB      / --------- / --------- //
    8'hF3 : i_format = extended_3    ; // ADDD      / --------- / --------- //
    8'hF4 : i_format = extended_3    ; // ANDB      / --------- / --------- //
    8'hF5 : i_format = extended_3    ; // BITB      / --------- / --------- //
    8'hF6 : i_format = extended_3    ; // LDB       / --------- / --------- //
    8'hF7 : i_format = extended_3    ; // STB       / --------- / --------- //
    8'hF8 : i_format = extended_3    ; // EORB      / --------- / --------- //
    8'hF9 : i_format = extended_3    ; // ADCB      / --------- / --------- //
    8'hFA : i_format = extended_3    ; // ORB       / --------- / --------- //
    8'hFB : i_format = extended_3    ; // ADDB      / --------- / --------- //
    8'hFC : i_format = extended_3    ; // LDD       / --------- / --------- //
    8'hFD : i_format = extended_3    ; // STD       / --------- / --------- //
    8'hFE : i_format = extended_3    ; // LDU       / LDS       / --------- //
    8'hFF : i_format = extended_3    ; // STU       / STS       / --------- //
    //////////////////////////////////////////////////////////////////////////
                                       // * New Turbo9 Instruction
                                       //
    default : i_format = dont_care_1 ; 
  endcase                              
end

always @* begin
  if (PAGE_SEL_I[1] == 1'b0) begin
    relative_2to3 = relative_2;
  end else begin
    relative_2to3 = relative_3;
  end
end

always @* begin
  if (QUEUE_D1_I[7] == 1'b1) begin
    case (QUEUE_D1_I[3:0])
      4'b1000 ,
      4'b1100 ,
      4'b1110 : indexed_2to4 = indexed_offset_8bit_3;
      4'b1001 ,
      4'b1101 ,
      4'b1111 : indexed_2to4 = indexed_offset_16bit_4;
      default : indexed_2to4 = indexed_2;
    endcase
  end else begin
    indexed_2to4 = indexed_2;
  end
end

/////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////
//                          PAGE 1 uRTL DECODE TABLES
/////////////////////////////////////////////////////////////////////////////
//
turbo9_urtl_decode_pg1_AR  I_turbo9_urtl_decode_pg1_AR
(
  .OPCODE_I (QUEUE_D0_I ),
  .PG1_AR_O (pg1_ar     )
);

turbo9_urtl_decode_pg1_JTA I_turbo9_urtl_decode_pg1_JTA
(
  .OPCODE_I  (QUEUE_D0_I ),
  .PG1_JTA_O (pg1_jta    )
);

turbo9_urtl_decode_pg1_JTB I_turbo9_urtl_decode_pg1_JTB
(
  .OPCODE_I  (QUEUE_D0_I ),
  .PG1_JTB_O (pg1_jtb    )
);

turbo9_urtl_decode_pg1_R1  I_turbo9_urtl_decode_pg1_R1
(
  .OPCODE_I  (QUEUE_D0_I      ),
  .PG1_R1_O  (pg1_r1_i        )
);
// Insert register pointer for TFR or EXG 
assign pg1_r1 = ((QUEUE_D0_I == 8'h1E) || (QUEUE_D0_I == 8'h1F)) ? QUEUE_D1_I[7:4] : pg1_r1_i;

turbo9_urtl_decode_pg1_R2  I_turbo9_urtl_decode_pg1_R2
(
  .OPCODE_I  (QUEUE_D0_I      ),
  .PG1_R2_O  (pg1_r2_i        )
);
// Insert register pointer for TFR or EXG 
assign pg1_r2 = ((QUEUE_D0_I == 8'h1E) || (QUEUE_D0_I == 8'h1F)) ? QUEUE_D1_I[3:0] : pg1_r2_i;

//
/////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////
//                          PAGE 2 uRTL DECODE TABLES
/////////////////////////////////////////////////////////////////////////////
//
turbo9_urtl_decode_pg2_AR  I_turbo9_urtl_decode_pg2_AR
(
  .OPCODE_I (QUEUE_D0_I ),
  .PG2_AR_O (pg2_ar     )
);

turbo9_urtl_decode_pg2_JTA I_turbo9_urtl_decode_pg2_JTA
(
  .OPCODE_I  (QUEUE_D0_I ),
  .PG2_JTA_O (pg2_jta    )
);

turbo9_urtl_decode_pg2_JTB I_turbo9_urtl_decode_pg2_JTB
(
  .OPCODE_I  (QUEUE_D0_I ),
  .PG2_JTB_O (pg2_jtb    )
);

turbo9_urtl_decode_pg2_R1  I_turbo9_urtl_decode_pg2_R1
(
  .OPCODE_I (QUEUE_D0_I ),
  .PG2_R1_O (pg2_r1     )
);

turbo9_urtl_decode_pg2_R2  I_turbo9_urtl_decode_pg2_R2
(
  .OPCODE_I (QUEUE_D0_I ),
  .PG2_R2_O (pg2_r2     )
);
//
/////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////
//                          PAGE 3 uRTL DECODE TABLES
/////////////////////////////////////////////////////////////////////////////
//
turbo9_urtl_decode_pg3_AR  I_turbo9_urtl_decode_pg3_AR
(
  .OPCODE_I (QUEUE_D0_I ),
  .PG3_AR_O (pg3_ar     )
);

turbo9_urtl_decode_pg3_JTA I_turbo9_urtl_decode_pg3_JTA
(
  .OPCODE_I  (QUEUE_D0_I ),
  .PG3_JTA_O (pg3_jta    )
);

turbo9_urtl_decode_pg3_JTB I_turbo9_urtl_decode_pg3_JTB
(
  .OPCODE_I  (QUEUE_D0_I ),
  .PG3_JTB_O (pg3_jtb    )
);

turbo9_urtl_decode_pg3_R1  I_turbo9_urtl_decode_pg3_R1
(
  .OPCODE_I (QUEUE_D0_I ),
  .PG3_R1_O (pg3_r1     )
);

turbo9_urtl_decode_pg3_R2  I_turbo9_urtl_decode_pg3_R2
(
  .OPCODE_I (QUEUE_D0_I ),
  .PG3_R2_O (pg3_r2     )
);
//
/////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////
//                            ASSIGN OUTPUTS
/////////////////////////////////////////////////////////////////////////////


////////////////// i_format
//  [20:5]  instr_data 
//  [   4]  inherent
//  [   3]  direct
//  [ 2:0]  length

// Select Page 1, 2 or 3 Decoding
always @* begin
  //
  INSTR_DATA_O      = i_format[20:5];
  INSTR_INH_EN_O    = i_format[4];
  INSTR_DIRECT_EN_O = i_format[3];
  INSTR_LEN_O       = i_format[2:0];
  //
  case (PAGE_SEL_I)
    //
    page_sel_3 : begin // Page 3 Instructions
      INSTR_JUMP_TABLE_A_O = pg3_jta;
      INSTR_JUMP_TABLE_B_O = pg3_jtb;
      INSTR_R1_SEL_O       = pg3_r1;
      INSTR_R2_SEL_O       = pg3_r2;
      INSTR_AR_SEL_O       = pg3_ar;
    end
    //
    page_sel_2 : begin // Page 2 Instructions
      INSTR_JUMP_TABLE_A_O = pg2_jta;
      INSTR_JUMP_TABLE_B_O = pg2_jtb;
      INSTR_R1_SEL_O       = pg2_r1;
      INSTR_R2_SEL_O       = pg2_r2;
      INSTR_AR_SEL_O       = pg2_ar;
    end
    //
    default : begin // Page 1 Instructions
      INSTR_JUMP_TABLE_A_O = pg1_jta;
      INSTR_JUMP_TABLE_B_O = pg1_jtb;
      INSTR_R1_SEL_O       = pg1_r1;
      INSTR_R2_SEL_O       = pg1_r2;
      INSTR_AR_SEL_O       = pg1_ar;
    end
    //
  endcase
end

/////////////////////////////////////////////////////////////////////////////

endmodule


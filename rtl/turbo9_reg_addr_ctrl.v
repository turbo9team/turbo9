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
// Description: Logic to control the register selects for the ALUs and the
// indexed addressing modes
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
module turbo9_reg_addr_ctrl
(
  // Inputs: Clock & Reset
  input              RST_I,
  input              CLK_I,

  // Stall & Next Instruction ACK
  input              STALL_MICROCYCLE_I,
  input              NEXT_INSTR_ACK_I,

  // Instruction Queue
  //input        [7:0] QUEUE_D2_I,
  input        [7:0] QUEUE_D1_I,
  input        [7:0] QUEUE_D0_I,
  input        [1:0] PAGE_SEL_I,

  // Instrution Decoded Controls
  input              INSTR_INH_EN_I,
  input        [3:0] INSTR_R1_SEL_I,
  input        [3:0] INSTR_R2_SEL_I,
  input        [3:0] INSTR_AR_SEL_I,

  // Control Vector Register Selects
  input        [1:0] CV_DATA_WIDTH_SEL_I,
  input        [3:0] CV_DATA_ALU_A_SEL_I,
  input        [2:0] CV_DATA_ALU_B_SEL_I,
  input        [3:0] CV_DATA_ALU_WR_SEL_I,
  input        [3:0] CV_ADDR_ALU_REG_SEL_I,
  input        [1:0] CV_DMEM_OP_I,
  input        [1:0] CV_STACK_OP_I,

  // Data ALU 
  output  reg        DATA_WIDTH_O,
  output  reg  [3:0] DATA_ALU_A_SEL_O,
  output  reg  [3:0] DATA_ALU_B_SEL_O,
  output  reg  [3:0] DATA_ALU_WR_SEL_O,
  output       [3:0] DATA_ALU_SAU_OP,

  // Address ALU 
  output  reg  [3:0] ADDR_ALU_REG_SEL_O,
  output  reg  [3:0] ADDR_ALU_OFFSET_SEL_O,
  output  reg        ADDR_ALU_EA_WR_EN_O,
  output  reg        ADDR_ALU_EA_OP_O,
  output  reg        ADDR_ALU_Y_OP_O,

  // Other
  output  reg  [1:0] DMEM_OP,
  output  reg  [3:0] BRANCH_SEL_O,
  output             IDX_INDIRECT_EN_O,
  output             STACK_DONE_O
);

/////////////////////////////////////////////////////////////////////////////
//                             INTERNAL SIGNALS
/////////////////////////////////////////////////////////////////////////////

///////////////////// SAU_OP_I defines
//
///////////////////// SAU_OP_I defines
// opcode[3:0] | (Page2_en<<1)
// Page1
localparam SAU_EMUL  = 4'b0100; // 4 opcode = $14
localparam SAU_EMULS = 4'b0101; // 5 opcode = $15
localparam SAU_IDIV  = 4'b1000; // 8 opcode = $18
localparam SAU_DAA   = 4'b1001; // 9 opcode = $19
localparam SAU_MUL   = 4'b1101; // D opcode = $1D
// Page2
localparam SAU_EDIV  = 4'b0110; // 6 opcode = $1014
localparam SAU_EDIVS = 4'b0111; // 7 opcode = $1015
localparam SAU_IDIVS = 4'b1010; // A opcode = $1018
localparam SAU_FDIV  = 4'b1011; // B opcode = $1019
//
//assign DATA_ALU_SAU_OP = (page2_en) ? {QUEUE_D1_I[3:2],page2_en,QUEUE_D1_I[0]} : // INFO: Partial decode
//                                      {QUEUE_D0_I[3:2],page2_en,QUEUE_D0_I[0]} ; // INFO: Partial decode


//////////////////////////////////////// CV_DMEM_OP_I defines
// Note this encoding is critical.
// MSB is a "one-hot"
localparam  DMEM_OP_IDLE  = 2'b00; // EQU $0
localparam  DMEM_OP_RD    = 2'b10; // EQU $2
localparam  DMEM_OP_WR    = 2'b11; // EQU $3

/*
; ///////////////////////////////////////// cv_DATA_ALU_A_SEL definition
ctrl_vec_begin cv_DATA_ALU_A_SEL 4
  ZERO         EQU $F ; = 4'b1111,
  IDATA        EQU $E ; = 4'b1110,
  DMEM_RD      EQU $D ; = 4'b1101,
  EA           EQU $C ; = 4'b1100,
  R1           EQU $8 ; = 4'b10xx, // Partially decoded!
  R2           EQU $4 ; = 4'b01xx, // Partially decoded!
  STACK_REG    EQU $0 ; = 4'b00xx, // Partially decoded!
ctrl_vec_end

; ///////////////////////////////////////// cv_DATA_ALU_B_SEL definition
ctrl_vec_begin cv_DATA_ALU_B_SEL 3
  ZERO         EQU $7 ; = 3'b111,
  IDATA        EQU $6 ; = 3'b110,
  DMEM_RD      EQU $5 ; = 3'b101,
  EA           EQU $4 ; = 3'b100,
  R2           EQU $0 ; = 3'b0xx, // Partially decoded!
ctrl_vec_end

; ///////////////////////////////////////// cv_DATA_ALU_WR_SEL definition
ctrl_vec_begin cv_DATA_ALU_WR_SEL 4
  ZERO         EQU $F ; = 4'b1111,
  IDATA        EQU $E ; = 4'b1110,
  DMEM_RD      EQU $D ; = 4'b1101,
  EA           EQU $C ; = 4'b1100,
  R1           EQU $8 ; = 4'b10xx, // Partially decoded!
  R2           EQU $4 ; = 4'b01xx, // Partially decoded!
  STACK_REG    EQU $0 ; = 4'b00xx, // Partially decoded!
ctrl_vec_end

; ///////////////////////////////////////// cv_ADDR_ALU_REG_SEL definition
ctrl_vec_begin cv_ADDR_ALU_REG_SEL 4
  ZERO         EQU $F ; = 4'b1111,
  IDATA        EQU $E ; = 4'b1110,
  DMEM_RD      EQU $D ; = 4'b1101,
  EA           EQU $C ; = 4'b1100,
  AR           EQU $8 ; = 4'b1000, // Partially decoded!
 ;INDEXED      EQU $4 ; = 4'b0100, // Partially decoded!
  INDEXED      EQU $0 ; = 4'b0000, // Partially decoded!
ctrl_vec_end
*/

//////////////////////////////////////// CV_DATA_WIDTH_SEL_I defines
//
localparam W_R1         = 2'h0;
localparam W_R1_OR_IND  = 2'h1;
localparam W_STACK_REG  = 2'h2;
localparam W_16         = 2'h3;

//////////////////////////////////////// DATA_ALU_WIDTH_I defines
//
// This must match the MSB of the *_REG_SEL control vectors
localparam  WIDTH_16 =  1'b0;
localparam  WIDTH_8  =  1'b1;


//////////////////////////////////////// CV_STACK_OP_I Defines
//
// Encoding is critical
localparam STACK_OP_IDLE = 2'b00;
localparam STACK_OP_PULL = 2'b01;
localparam STACK_OP_PUSH = 2'b10;


// ADDR_ALU_REG_SEL_O - Index Register Select Decoding 
localparam  ZERO                  = 4'b1111;
localparam  IDATA                 = 4'b1110;
localparam  DMEM_RD               = 4'b1101;
localparam  EA                    = 4'b1100;
localparam  DPR                   = 4'b1011;
localparam  CCR                   = 4'b1010;
localparam  B                     = 4'b1001;
localparam  A                     = 4'b1000;
localparam  SEXB                  = 4'b0111;
//localparam                      = 4'b0110;
localparam  PC                    = 4'b0101;
localparam  S                     = 4'b0100;
localparam  U                     = 4'b0011;
localparam  Y                     = 4'b0010;
localparam  X                     = 4'b0001;
localparam  D                     = 4'b0000;
localparam  IDX_REG_SEL_DONT_CARE = 4'bxxxx;


// ADDR_ALU_OFFSET_SEL_O - Index Offset Select Decoding
localparam  OFFSET_SEL_POS1      = 4'b0000;
localparam  OFFSET_SEL_POS2      = 4'b0001;
localparam  OFFSET_SEL_NEG1      = 4'b0010;
localparam  OFFSET_SEL_NEG2      = 4'b0011;
localparam  OFFSET_SEL_ZERO      = 4'b0100;
localparam  OFFSET_SEL_B         = 4'b0101;
localparam  OFFSET_SEL_A         = 4'b0110;
localparam  OFFSET_SEL_D         = 4'b0111;
localparam  OFFSET_SEL_IDATA     = 4'b1000;
localparam  OFFSET_SEL_DONT_CARE = 4'bxxxx;

//////////////////////////////////////// ADDR_ALU_EA_OP_I / ADDR_ALU_Y_OP_I defines
//
localparam  EQU_REG = 1'b0;
localparam  EQU_SUM = 1'b1;


reg [7:0] opcode;
reg [7:0] idx_postbyte;
reg       idx_indirect_en;
assign DATA_ALU_SAU_OP = {opcode[3:2],page2_en,opcode[0]} ; // INFO: Partial decode

reg [7:0]   stk_postbyte;
reg [7:0]   stk_postbyte_msk;
reg [7:0]   stk_postbyte_nxt;
reg [7:0]   stk_postbyte_reg;
localparam  stk_postbyte_rst = 8'h00;

reg  [3:0]  stk_a_sel_nxt;
reg  [3:0]  stk_a_sel_reg;
localparam  stk_a_sel_rst = 4'h0;

reg  [3:0]  stk_wr_sel_reg;
localparam  stk_wr_sel_rst = 4'h0;

reg         stack_done;

reg         page1_en;
reg         page2_en;
reg         page3_en;

//////////////////////////////////////// Instruction Decoded Fields
//
reg          instr_inh_en;
reg          instr_inh_en_reg;
localparam   instr_inh_en_rst = 1'b0; 

reg    [3:0] instr_r1_sel;
reg    [3:0] instr_r1_sel_reg;
localparam   instr_r1_sel_rst = 4'b0101; //INFO: PC reg_sel_type 

reg    [3:0] instr_r2_sel;
reg    [3:0] instr_r2_sel_reg;
localparam   instr_r2_sel_rst = 4'b1101; //INFO: DMEM_RD reg_sel_type

reg    [3:0] instr_ar_sel;
reg    [3:0] instr_ar_sel_reg;
localparam   instr_ar_sel_rst = 4'b0000;

/////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////
//                                LOGIC
/////////////////////////////////////////////////////////////////////////////

// Decode DATA_ALU_A_SEL_O
always @* begin
  case (CV_DATA_ALU_A_SEL_I[3:2]) // INFO: Partial decode 
    2'b00   : DATA_ALU_A_SEL_O = stk_a_sel_reg;
    2'b01   : DATA_ALU_A_SEL_O = instr_r2_sel;
    2'b10   : DATA_ALU_A_SEL_O = instr_r1_sel;
    default : DATA_ALU_A_SEL_O = CV_DATA_ALU_A_SEL_I; // 2'b11
  endcase
end

// Decode DATA_ALU_B_SEL_O
always @* begin
  case (CV_DATA_ALU_B_SEL_I[2]) // INFO: Partial decode 
    1'b0    : DATA_ALU_B_SEL_O = instr_r2_sel;
    default : DATA_ALU_B_SEL_O = {1'b1, CV_DATA_ALU_B_SEL_I}; // 1'b1
  endcase
end

// Decode DATA_ALU_WR_SEL_O
always @* begin
  case (CV_DATA_ALU_WR_SEL_I[3:2]) // INFO: Partial decode 
    2'b00   : DATA_ALU_WR_SEL_O = stk_wr_sel_reg;
    2'b01   : DATA_ALU_WR_SEL_O = instr_r2_sel;
    2'b10   : DATA_ALU_WR_SEL_O = instr_r1_sel;
    default : DATA_ALU_WR_SEL_O = CV_DATA_ALU_WR_SEL_I; // 2'b11
  endcase
end

// Decode DATA_WIDTH_O
always @* begin
  case (CV_DATA_WIDTH_SEL_I)
    W_R1          : DATA_WIDTH_O = instr_r1_sel[3];
    W_R1_OR_IND   : DATA_WIDTH_O = (idx_indirect_en) ? WIDTH_16 : instr_r1_sel[3];
    W_STACK_REG   : DATA_WIDTH_O = stk_a_sel_reg[3];
    default       : DATA_WIDTH_O = WIDTH_16; // W_16
  endcase
end

// Decode DMEM_OP
always @* begin
  if (idx_indirect_en) begin
    DMEM_OP = DMEM_OP_RD;
  end else if (instr_inh_en) begin
    DMEM_OP = DMEM_OP_IDLE;
  end else begin
    DMEM_OP = CV_DMEM_OP_I;
  end
end

// Decode ADDR_ALU_REG_SEL_O
always @* begin
  case (CV_ADDR_ALU_REG_SEL_I[3:2]) // INFO: Partial decode 
    2'b11   : ADDR_ALU_REG_SEL_O = CV_ADDR_ALU_REG_SEL_I;
    2'b10   : ADDR_ALU_REG_SEL_O = instr_ar_sel;
    default : begin // 2'b0x (INDEXED)
      if ((idx_postbyte[7] == 1'b1) && (idx_postbyte[3:2] == 2'b11)) begin
        case (idx_postbyte[1])
          1'b0    : ADDR_ALU_REG_SEL_O = PC;
          default : ADDR_ALU_REG_SEL_O = ZERO; // 1'b1
        endcase
      end else begin
        case (idx_postbyte[6:5])
          2'b00   : ADDR_ALU_REG_SEL_O = X;
          2'b01   : ADDR_ALU_REG_SEL_O = Y;
          2'b10   : ADDR_ALU_REG_SEL_O = U;
          default : ADDR_ALU_REG_SEL_O = S; // 2'b11
        endcase
      end
    end
  endcase
end

 
// Decode ADDR_ALU_OFFSET_SEL_O
always @* begin
  if (~CV_ADDR_ALU_REG_SEL_I[3]) begin // Partial decode for INDEXED
    if (idx_postbyte[7] == 1'b1) begin
      case (idx_postbyte[3:0]) // FIXME optimize undefined
        4'b0000 : ADDR_ALU_OFFSET_SEL_O = OFFSET_SEL_POS1;  
        4'b0001 : ADDR_ALU_OFFSET_SEL_O = OFFSET_SEL_POS2;
        4'b0010 : ADDR_ALU_OFFSET_SEL_O = OFFSET_SEL_NEG1; 
        4'b0011 : ADDR_ALU_OFFSET_SEL_O = OFFSET_SEL_NEG2;
        //
        4'b0100 : ADDR_ALU_OFFSET_SEL_O = OFFSET_SEL_ZERO;
        4'b0101 : ADDR_ALU_OFFSET_SEL_O = OFFSET_SEL_B;
        4'b0110 : ADDR_ALU_OFFSET_SEL_O = OFFSET_SEL_A;
        4'b0111 : ADDR_ALU_OFFSET_SEL_O = OFFSET_SEL_D;    
        //
        4'b1000 : ADDR_ALU_OFFSET_SEL_O = OFFSET_SEL_IDATA; //  8 bit (signed)
        4'b1001 : ADDR_ALU_OFFSET_SEL_O = OFFSET_SEL_IDATA; // 16 bit (signed)
        4'b1010 : ADDR_ALU_OFFSET_SEL_O = OFFSET_SEL_D;
        4'b1011 : ADDR_ALU_OFFSET_SEL_O = OFFSET_SEL_D;
        //
        4'b1100 : ADDR_ALU_OFFSET_SEL_O = OFFSET_SEL_IDATA; //  8 bit (signed)
        4'b1101 : ADDR_ALU_OFFSET_SEL_O = OFFSET_SEL_IDATA; // 16 bit (signed)
        4'b1110 : ADDR_ALU_OFFSET_SEL_O = OFFSET_SEL_IDATA; //  8 bit (signed)
        default : ADDR_ALU_OFFSET_SEL_O = OFFSET_SEL_IDATA; // 16 bit (signed) 4'b1111
      endcase
    end else begin
      ADDR_ALU_OFFSET_SEL_O = OFFSET_SEL_IDATA; //  5 bit (signed)
    end
  end else if (CV_STACK_OP_I[1]) begin // INFO: Partial decode for STACK_OP_PUSH
    if (DATA_WIDTH_O == WIDTH_16) begin
      ADDR_ALU_OFFSET_SEL_O = OFFSET_SEL_NEG2;
    end else begin
      ADDR_ALU_OFFSET_SEL_O = OFFSET_SEL_NEG1;
    end
  end else if (CV_STACK_OP_I[0]) begin // INFO: Partial decode for STACK_OP_PULL
    if (DATA_WIDTH_O == WIDTH_16) begin
      ADDR_ALU_OFFSET_SEL_O = OFFSET_SEL_POS2;
    end else begin
      ADDR_ALU_OFFSET_SEL_O = OFFSET_SEL_POS1;
    end
  end else begin
    ADDR_ALU_OFFSET_SEL_O = OFFSET_SEL_ZERO;
  end
end                
                   

// ADDR_ALU EA & Y Decoding
always @* begin
  if (~CV_ADDR_ALU_REG_SEL_I[3]) begin // INFO: Partial decode for INDEXED
    //
    ADDR_ALU_EA_WR_EN_O = 1'b1; // Write EA for all indexed addressing
    //
    if ((idx_postbyte[7] == 1'b1) && (idx_postbyte[3:2] == 2'b00)) begin
      //
      ADDR_ALU_Y_OP_O  = EQU_SUM; // Update Reg, Pre or Post
      //
      case (idx_postbyte[1])
        1'b0    : ADDR_ALU_EA_OP_O = EQU_REG; // POST
        default : ADDR_ALU_EA_OP_O = EQU_SUM; // PRE 1'b1
      endcase
    end else begin
      ADDR_ALU_EA_OP_O = EQU_SUM; // EA = REG + OFFSET
      ADDR_ALU_Y_OP_O  = EQU_REG; // REG not updated
    end
  end else if (CV_STACK_OP_I[1]) begin // INFO: Partial decode for STACK_OP_PUSH
    ADDR_ALU_EA_WR_EN_O = 1'b0; // Dont write EA for stack addressing
    ADDR_ALU_Y_OP_O     = EQU_SUM; // Update Reg, Pre or Post
    ADDR_ALU_EA_OP_O    = EQU_SUM; // PRE
  end else if (CV_STACK_OP_I[0]) begin // INFO: Partial decode for STACK_OP_PULL
    ADDR_ALU_EA_WR_EN_O = 1'b0; // Dont write EA for stack addressing
    ADDR_ALU_Y_OP_O     = EQU_SUM; // Update Reg, Pre or Post
    ADDR_ALU_EA_OP_O    = EQU_REG; // POST
  end else begin // Not Indexed, just pass the REG as address
    ADDR_ALU_EA_WR_EN_O  = 1'b0;
    ADDR_ALU_EA_OP_O     = EQU_REG; // EA = Pass REG
    ADDR_ALU_Y_OP_O      = EQU_REG; // REG not updated
  end
end

// Index Indirect Decoding
always @* begin
  if (~CV_ADDR_ALU_REG_SEL_I[3]) begin // INFO: Partial decode for INDEXED
    if ((idx_postbyte[7] == 1'b1) &&  (idx_postbyte[4] == 1'b1)) begin
      idx_indirect_en = 1'b1;
    end else begin
      idx_indirect_en = 1'b0;
    end
  end else begin
    idx_indirect_en = 1'b0;
  end
end

// Branch Pointer Decoding
always @* begin
  if (opcode[7:4] == 4'h2) begin
    BRANCH_SEL_O = opcode[3:0];
  end else begin
    BRANCH_SEL_O = 4'b0000; // LBRA LBSR BSR
  end
end

// Sequential Arithmetic Unit Decoding
//
// DAA  19  0001_1001
// MUL  3D  0011_1101
//

/////////////////////////////////////////////////////////////////////////////
//                       Prebyte Logic 
/////////////////////////////////////////////////////////////////////////////
// Select Page 1, 2 or 3 Decoding
always @* begin
/*
  case (QUEUE_D0_I)
    stk_postbyte  = QUEUE_D1_I;
    //
    8'h11,        // Page 3 Instructions
    8'h10 : begin // Page 2 Instructions
      opcode        = QUEUE_D1_I;
      idx_postbyte  = QUEUE_D2_I;
      page1_en      = 1'b0;
      page2_en      = ~QUEUE_D0_I[0];
      page3_en      =  QUEUE_D0_I[0];
    end
    //
    default : begin // Page 1 Instructions
      opcode        = QUEUE_D0_I;
      idx_postbyte  = QUEUE_D1_I;
      page1_en      = 1'b1;
      page2_en      = 1'b0;
      page3_en      = 1'b0;
    end
    //
  endcase
*/
  stk_postbyte  = QUEUE_D1_I;
  opcode        = QUEUE_D0_I;
  idx_postbyte  = QUEUE_D1_I;
  page1_en      = ~PAGE_SEL_I[1];
  page2_en      =  PAGE_SEL_I[1] & ~PAGE_SEL_I[0];
  page3_en      =  PAGE_SEL_I[1] &  PAGE_SEL_I[0];
end
//
/////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////
//        Maintain Instruction Decodes for Multiple Micro Cycles
/////////////////////////////////////////////////////////////////////////////
//
always @(posedge CLK_I, posedge RST_I) begin
  if (RST_I) begin
    //
    instr_inh_en_reg      <= instr_inh_en_rst;
    instr_r1_sel_reg      <= instr_r1_sel_rst;
    instr_r2_sel_reg      <= instr_r2_sel_rst;
    instr_ar_sel_reg      <= instr_ar_sel_rst;
    //
  end else begin
    //
    if (~STALL_MICROCYCLE_I & NEXT_INSTR_ACK_I) begin
      //
      instr_inh_en_reg      <= INSTR_INH_EN_I; 
      instr_r1_sel_reg      <= INSTR_R1_SEL_I;
      instr_r2_sel_reg      <= INSTR_R2_SEL_I;
      instr_ar_sel_reg      <= INSTR_AR_SEL_I;
      //
    end
  end
end

always @* begin
  if (~STALL_MICROCYCLE_I & NEXT_INSTR_ACK_I) begin // FIXME ~STALL_MICROCYCLE_I needed?
    instr_inh_en   = INSTR_INH_EN_I;
    instr_r1_sel   = INSTR_R1_SEL_I;
    instr_r2_sel   = INSTR_R2_SEL_I;
    instr_ar_sel   = INSTR_AR_SEL_I;
  end else begin
    instr_inh_en   = instr_inh_en_reg;
    instr_r1_sel   = instr_r1_sel_reg;
    instr_r2_sel   = instr_r2_sel_reg;
    instr_ar_sel   = instr_ar_sel_reg;
  end
end
//
/////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////
//                    Stack Postbyte Decode Logic
/////////////////////////////////////////////////////////////////////////////
//
always @* begin
  if (NEXT_INSTR_ACK_I) begin 
    if (QUEUE_D0_I[3] == 1'b0) begin // INFO: Partial decode for PSHS,PULS,PSHU,PULU opcode
      stk_postbyte_nxt = stk_postbyte;
    end else begin
      stk_postbyte_nxt = 8'hFF;
    end
    //
    stack_done = (stk_postbyte == 8'h00);
  end else begin
    stk_postbyte_nxt = stk_postbyte_reg;
    //
    stack_done = (stk_postbyte_reg == 8'h00);
  end
end                

always @* begin
  //Defaults
  stk_postbyte_msk   = 8'b1111_1111;
  stk_a_sel_nxt   = 4'hx; //INFO: Don't care!

  if (CV_STACK_OP_I[0]) begin // INFO: Partial Decode STACK_OP_PULL! // FIXME maybe seperate this logic
         if (stk_postbyte_nxt[0]) begin stk_postbyte_msk[0] = 1'b0; stk_a_sel_nxt =  CCR;                       end
    else if (stk_postbyte_nxt[1]) begin stk_postbyte_msk[1] = 1'b0; stk_a_sel_nxt =  A;                         end
    else if (stk_postbyte_nxt[2]) begin stk_postbyte_msk[2] = 1'b0; stk_a_sel_nxt =  B;                         end
    else if (stk_postbyte_nxt[3]) begin stk_postbyte_msk[3] = 1'b0; stk_a_sel_nxt =  DPR;                       end
    else if (stk_postbyte_nxt[4]) begin stk_postbyte_msk[4] = 1'b0; stk_a_sel_nxt =  X;                         end 
    else if (stk_postbyte_nxt[5]) begin stk_postbyte_msk[5] = 1'b0; stk_a_sel_nxt =  Y;                         end
    else if (stk_postbyte_nxt[6]) begin stk_postbyte_msk[6] = 1'b0; stk_a_sel_nxt =  (instr_ar_sel[0]) ? S : U; end  
    else if (stk_postbyte_nxt[7]) begin stk_postbyte_msk[7] = 1'b0; stk_a_sel_nxt =  PC;                        end
  end else if (CV_STACK_OP_I[1]) begin // INFO: Partial Decode STACK_OP_PUSH!
         if (stk_postbyte_nxt[7]) begin stk_postbyte_msk[7] = 1'b0; stk_a_sel_nxt =  PC;                        end
    else if (stk_postbyte_nxt[6]) begin stk_postbyte_msk[6] = 1'b0; stk_a_sel_nxt =  (instr_ar_sel[0]) ? S : U; end  
    else if (stk_postbyte_nxt[5]) begin stk_postbyte_msk[5] = 1'b0; stk_a_sel_nxt =  Y;                         end
    else if (stk_postbyte_nxt[4]) begin stk_postbyte_msk[4] = 1'b0; stk_a_sel_nxt =  X;                         end 
    else if (stk_postbyte_nxt[3]) begin stk_postbyte_msk[3] = 1'b0; stk_a_sel_nxt =  DPR;                       end
    else if (stk_postbyte_nxt[2]) begin stk_postbyte_msk[2] = 1'b0; stk_a_sel_nxt =  B;                         end
    else if (stk_postbyte_nxt[1]) begin stk_postbyte_msk[1] = 1'b0; stk_a_sel_nxt =  A;                         end
    else if (stk_postbyte_nxt[0]) begin stk_postbyte_msk[0] = 1'b0; stk_a_sel_nxt =  CCR;                       end
  end

end

always @(posedge CLK_I, posedge RST_I) begin
  if (RST_I) begin
    //
    stk_postbyte_reg  <= stk_postbyte_rst;
    stk_a_sel_reg     <= stk_a_sel_rst;
    stk_wr_sel_reg    <= stk_wr_sel_rst;
    //
  end else begin
    //
    if (~STALL_MICROCYCLE_I) begin
      //
      stk_postbyte_reg  <= stk_postbyte_nxt & stk_postbyte_msk;
      stk_a_sel_reg     <= stk_a_sel_nxt;
      if (CV_STACK_OP_I[0]) begin // INFO: Partial Decode STACK_OP_PULL!
        stk_wr_sel_reg  <= stk_a_sel_reg;
      end
      //
    end
  end
end
//
/////////////////////////////////////////////////////////////////////////////

/*

/////////////////// Stack Postbyte Notes
bit7 PC
bit6 U or S
bit5 Y
bit4 X
bit3 DP
bit2 B
bit1 A
bit0 CCR

                   postbyte_exg
EXG       'h1E     stk_postbyte                  // bit[7:4] = src, bit[3:0] = des
TFR       'h1F     stk_postbyte                  // bit[7:4] = src, bit[3:0] = des
                  
                   postbyte_stk
PSHS      'h34     stk_postbyte                  // push bit7 -> bit0
PULS      'h35     stk_postbyte                  // pull bit0 -> bit7
PSHU      'h36     stk_postbyte                  // push bit7 -> bit0
PULU      'h37     stk_postbyte                  // pull bit0 -> bit7

BSR       'h8D     8'h80                       // push, PC
JSR (dir) 'h9D     8'h80                       // push, PC
JSR (idx) 'hAD     8'h80                       // push, PC
JSR (ext) 'hBD     8'h80                       // push, PC
LBSR      'h17     8'h80                       // push, PC
RTS       'h39     8'h80                       // pull, PC
RTI       'h3B     if (cc.e) 8'hFF else 8'h80  // pull, must wait for E from previous instruction
CWAI      'h3C     8'hFF                       // push, QUEUE_D1 anded with CC, E always set
SWI       'h3F     8'hFF                       // Set E, push all regs, set I & F
SWI2      'h103F   8'hFF                       // Set E, push all regs
SWI3      'h113F   8'hFF                       // Set E, push all regs
RESET     '3E      

/////////////////// Partial Decoding for postbyte
00   0000 0000 
33   0011 0011
     00?? 00?? Page2 or Page3 SWI2,SWI3 (8'hFF)
                                       
04   0000 0100                          
17   0001 0111                         
     000? 01?? LBSR (8'h80)
                                       
24   0010 0100                          
37   0011 0111                         
     001? 01?? PSHS,PULS,PSHU,PULU (stk_postbyte)
                                       
08   0000 1000                          
3B   0011 1011                         
     00?? 10?? RTS,RTI (8'h80)
                                       
0C   0000 1100                          
1F   0001 1111                         
     000? 11?? EXG,TFR (stk_postbyte)
                                       
2C   0010 1100                          
3F   0011 1111                         
     001? 11?? CWAI,SWI (8'hFF)
                                       
40   0100 0000                          
FF   1111 1111                         
     ?1?? ???? BSR,JSR (8'h80)

06   0000 0110
FF   1111 1111

0F   0000 1111
F6   1111 0110
     ???? ?11? U Stack pointer
 

*/

/////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////
//                            ASSIGN OUPUTS
/////////////////////////////////////////////////////////////////////////////
//

assign IDX_INDIRECT_EN_O = idx_indirect_en;
assign STACK_DONE_O      = stack_done;

//
/////////////////////////////////////////////////////////////////////////////

endmodule


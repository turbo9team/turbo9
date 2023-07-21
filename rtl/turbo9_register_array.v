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
// Description: Register file for the Turbo9 Execute Stage
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
module turbo9_register_array
(
  // Inputs: Clock & Reset
  input               RST_I,
  input               CLK_I,
  input               STALL_MICROCYCLE_I,
  output              REGISTER_ARRAY_READY_O,

  // PC Interface to Fetch & Decode
  input               NXT_PC_WR_EN_I,
  input        [15:0] NXT_PC_I,
  output              NEW_PC_WR_EN_O,
  output       [15:0] NEW_PC_O,

  // Data ALU
  input         [3:0] DATA_ALU_A_SEL_I,
  input         [3:0] DATA_ALU_B_SEL_I,
  input         [3:0] DATA_ALU_WR_SEL_I,
  output reg   [15:0] DATA_ALU_A_O,
  output reg   [15:0] DATA_ALU_B_O,
  input        [15:0] DATA_ALU_Y_I,
  output       [47:0] DATA_ALU_SAU_ABXY_O,

  // Register Array ALU Selects
  input         [3:0] ADDR_ALU_REG_SEL_I,
  input         [3:0] ADDR_ALU_OFFSET_SEL_I,
  input               ADDR_ALU_EA_WR_EN_I,

  // Address ALU Data Inputs / Outputs
  output reg   [15:0] ADDR_ALU_REG_O,
  output reg   [15:0] ADDR_ALU_OFFSET_O,
  input        [15:0] ADDR_ALU_Y_I,
  input        [15:0] ADDR_ALU_EA_I,

  input               DMEM_RD_DATA_READY_I,
  input        [15:0] DMEM_RD_DATA_REG_I,
  input        [15:0] INSTR_DATA_I,
  input               INSTR_DIRECT_EN_I,
  //
  // CCR to Register Array
  output              RA_CCR_WR_EN_O,
  output        [7:0] RA_CCR_WR_DATA_O,
  input         [7:0] RA_CCR_RD_DATA_I
);

/////////////////////////////////////////////////////////////////////////////
//                             INTERNAL SIGNALS
/////////////////////////////////////////////////////////////////////////////

// Register Select Defines
localparam ZERO              = 4'b1111;
localparam IDATA             = 4'b1110;
localparam DMEM_RD           = 4'b1101;
localparam EA                = 4'b1100;
localparam DPR               = 4'b1011;
localparam CCR               = 4'b1010;
localparam B                 = 4'b1001;
localparam A                 = 4'b1000;
localparam SEXB              = 4'b0111;
//localparam                 = 4'b0110;
localparam PC                = 4'b0101;
localparam S                 = 4'b0100;
localparam U                 = 4'b0011;
localparam Y                 = 4'b0010;
localparam X                 = 4'b0001;
localparam D                 = 4'b0000;


// Index Offset Select Decoding (matches postbyte[3:0])
localparam ADDR_OFFSET_SEL_POS1      = 4'b0000; 
localparam ADDR_OFFSET_SEL_POS2      = 4'b0001;
localparam ADDR_OFFSET_SEL_NEG1      = 4'b0010;
localparam ADDR_OFFSET_SEL_NEG2      = 4'b0011;
localparam ADDR_OFFSET_SEL_ZERO      = 4'b0100;
localparam ADDR_OFFSET_SEL_B         = 4'b0101;
localparam ADDR_OFFSET_SEL_A         = 4'b0110;
localparam ADDR_OFFSET_SEL_D         = 4'b0111;
localparam ADDR_OFFSET_SEL_IDATA     = 4'b1000;


reg    [7:0] a_reg;
localparam   a_rst = 8'h00;

reg    [7:0] b_reg;
localparam   b_rst = 8'h00;

reg   [15:0] x_reg;
localparam   x_rst = 16'h0000;

reg   [15:0] y_reg;
localparam   y_rst = 16'h0000;

reg   [15:0] u_reg;
localparam   u_rst = 16'h0000;

reg   [15:0] s_reg;
localparam   s_rst = 16'h0000;

reg   [15:0] pc_reg;
localparam   pc_rst = 16'h0000;

reg    [7:0] dpr_reg;
localparam   dpr_rst = 8'h00;

reg   [15:0] ea_reg;
localparam   ea_rst = 16'h0000;

reg          new_pc_wr_en_reg;
localparam   new_pc_wr_en_rst = 1'b0;

wire [15:0] zero_u16 = 16'h0000;
wire [15:0] pos1_u16 = 16'h0001;   
wire [15:0] pos2_u16 = 16'h0002;
wire [15:0] neg1_s16 = 16'hFFFF;
wire [15:0] neg2_s16 = 16'hFFFE;
localparam REG_DONT_CARE = 16'hxxxx;

wire [15:0] a_reg_u16   = {8'h00, a_reg};
wire [15:0] a_reg_s16   = {{8{a_reg[7]}}, a_reg};
//
wire [15:0] b_reg_u16   = {8'h00, b_reg};
wire [15:0] b_reg_s16   = {{8{b_reg[7]}}, b_reg};
//
wire [15:0] d_reg       = {a_reg, b_reg};
//
wire [15:0] dpr_reg_u16 = {8'h00, dpr_reg};
//
wire [15:0] instr_data  = (INSTR_DIRECT_EN_I) ? {dpr_reg, INSTR_DATA_I[7:0]} :
                                                INSTR_DATA_I;

/////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////
//                                LOGIC
/////////////////////////////////////////////////////////////////////////////

always @(posedge CLK_I, posedge RST_I) begin
  if (RST_I) begin
    a_reg      <= a_rst;
    b_reg      <= b_rst;
    x_reg      <= x_rst;
    y_reg      <= y_rst;
    u_reg      <= u_rst;
    s_reg      <= s_rst;
    pc_reg     <= pc_rst;
    dpr_reg    <= dpr_rst;
    ea_reg     <= ea_rst;
    new_pc_wr_en_reg <= new_pc_wr_en_rst;
  end else begin

    if (~STALL_MICROCYCLE_I) begin
      //
      // A & D Register
      if        (DATA_ALU_WR_SEL_I   == A)  a_reg <= DATA_ALU_Y_I[ 7:0];
      else   if (DATA_ALU_WR_SEL_I   == D)  a_reg <= DATA_ALU_Y_I[15:8];
    //else   if (ADDR_ALU_REG_SEL_I == A) a_reg <= ADDR_ALU_Y_I[ 7:0];
    //else   if (ADDR_ALU_REG_SEL_I == D) a_reg <= ADDR_ALU_Y_I[15:8];
      else                               a_reg <= a_reg;
      //                                
      // B & D Register                 
      if        (DATA_ALU_WR_SEL_I   == B)  b_reg <= DATA_ALU_Y_I[ 7:0];
      else   if (DATA_ALU_WR_SEL_I   == D)  b_reg <= DATA_ALU_Y_I[ 7:0];
    //else   if (ADDR_ALU_REG_SEL_I == B) b_reg <= ADDR_ALU_Y_I[ 7:0];
    //else   if (ADDR_ALU_REG_SEL_I == D) b_reg <= ADDR_ALU_Y_I[ 7:0];
      else                               b_reg <= b_reg;
      //                                
      // X Register                     
      if        (DATA_ALU_WR_SEL_I  == X)  x_reg <= DATA_ALU_Y_I;
      else   if (ADDR_ALU_REG_SEL_I == X) x_reg <= ADDR_ALU_Y_I;
      else                               x_reg <= x_reg;
      //                                
      // Y Register                     
      if        (DATA_ALU_WR_SEL_I  == Y)  y_reg <= DATA_ALU_Y_I;
      else   if (ADDR_ALU_REG_SEL_I == Y) y_reg <= ADDR_ALU_Y_I;
      else                               y_reg <= y_reg;
      //                                
      // U Register                     
      if        (DATA_ALU_WR_SEL_I  == U)  u_reg <= DATA_ALU_Y_I;
      else   if (ADDR_ALU_REG_SEL_I == U) u_reg <= ADDR_ALU_Y_I;
      else                               u_reg <= u_reg;
      //                                
      // S Register                     
      if        (DATA_ALU_WR_SEL_I  == S)  s_reg <= DATA_ALU_Y_I;
      else   if (ADDR_ALU_REG_SEL_I == S) s_reg <= ADDR_ALU_Y_I;
      else                               s_reg <= s_reg;
      //
      // PC Register
      if (NXT_PC_WR_EN_I) begin
        pc_reg      <= NXT_PC_I;
        new_pc_wr_en_reg  <= 1'b0;
      end else if (DATA_ALU_WR_SEL_I == PC) begin   // FIXME could register new_pc_wr_en_reg one stage earlier
        pc_reg      <= DATA_ALU_Y_I;
        new_pc_wr_en_reg  <= 1'b1;
    //end else if (ADDR_ALU_REG_SEL_I == PC) begin
    //  pc_reg      <= ADDR_ALU_Y_I; //PC is never written from ADDR_ALU
    //  new_pc_wr_en_reg  <= 1'b1;
      end else begin
        pc_reg      <= pc_reg;
        new_pc_wr_en_reg  <= new_pc_wr_en_reg;
      end
      //                                 
      // DPR Register
    //if (data_alu_wr_sel  == DPR)  dpr_reg <= DATA_ALU_Y_I[ 7:0];
      if        (DATA_ALU_WR_SEL_I  == DPR)  dpr_reg <= DATA_ALU_Y_I[ 7:0];
    //else if   (ADDR_ALU_REG_SEL_I == DPR) dpr_reg <= ADDR_ALU_Y_I[ 7:0];
      else                                 dpr_reg <= dpr_reg;
      //                                 
      // EA Register                     
      if        (ADDR_ALU_EA_WR_EN_I)      ea_reg <= ADDR_ALU_EA_I;
      else   if (DATA_ALU_WR_SEL_I  == EA)   ea_reg <= DATA_ALU_Y_I;
      //else   if (ADDR_ALU_REG_SEL_I == EA)  ea_reg <= ADDR_ALU_Y_I; //Not needed
      else                                 ea_reg <= ea_reg;
      //
    end
 
  end
end
/////////////////////////////////////////////////////////////////////////////
 

/////////////////////////////////////////////////////////////////////////////
//                             ASSIGN OUTPUTS
/////////////////////////////////////////////////////////////////////////////

always @* begin
  case (DATA_ALU_A_SEL_I)
    ZERO    : DATA_ALU_A_O = zero_u16;
    IDATA   : DATA_ALU_A_O = instr_data;
    DMEM_RD : DATA_ALU_A_O = DMEM_RD_DATA_REG_I;
    EA      : DATA_ALU_A_O = ea_reg;
    //
    DPR     : DATA_ALU_A_O = dpr_reg_u16;
    CCR     : DATA_ALU_A_O = RA_CCR_RD_DATA_I;
    B       : DATA_ALU_A_O = b_reg_u16;
    A       : DATA_ALU_A_O = a_reg_u16;
    //
    SEXB    : DATA_ALU_A_O = b_reg_s16;
    //      : DATA_ALU_A_O = ;
    PC      : DATA_ALU_A_O = pc_reg;
    S       : DATA_ALU_A_O = s_reg;
    //
    U       : DATA_ALU_A_O = u_reg;
    Y       : DATA_ALU_A_O = y_reg;
    X       : DATA_ALU_A_O = x_reg;
    D       : DATA_ALU_A_O = d_reg;
    //
  //default : DATA_ALU_A_O = zero_u16;
    default : DATA_ALU_A_O = REG_DONT_CARE;
  endcase
end

always @* begin
  case (DATA_ALU_B_SEL_I)
    ZERO    : DATA_ALU_B_O = zero_u16;
    IDATA   : DATA_ALU_B_O = instr_data;
    DMEM_RD : DATA_ALU_B_O = DMEM_RD_DATA_REG_I;
    EA      : DATA_ALU_B_O = ea_reg;
    //
    DPR     : DATA_ALU_B_O = dpr_reg_u16;
    CCR     : DATA_ALU_B_O = RA_CCR_RD_DATA_I;
    B       : DATA_ALU_B_O = b_reg_u16;
    A       : DATA_ALU_B_O = a_reg_u16;
    //
    SEXB    : DATA_ALU_B_O = b_reg_s16;
    //      : DATA_ALU_B_O = ;
    PC      : DATA_ALU_B_O = pc_reg;
    S       : DATA_ALU_B_O = s_reg;
    //
    U       : DATA_ALU_B_O = u_reg;
    Y       : DATA_ALU_B_O = y_reg;
    X       : DATA_ALU_B_O = x_reg;
    D       : DATA_ALU_B_O = d_reg;
    //
  //default : DATA_ALU_B_O = zero_u16;
    default : DATA_ALU_B_O = REG_DONT_CARE;
  endcase
end

always @* begin
  case (ADDR_ALU_REG_SEL_I)
    ZERO    : ADDR_ALU_REG_O = zero_u16;
    IDATA   : ADDR_ALU_REG_O = instr_data;
    DMEM_RD : ADDR_ALU_REG_O = DMEM_RD_DATA_REG_I;
    EA      : ADDR_ALU_REG_O = ea_reg;
    //
  //DPR     : ADDR_ALU_REG_O = dpr_reg_u16;
  //CCR     : ADDR_ALU_REG_O = RA_CCR_RD_DATA_I;
  //B       : ADDR_ALU_REG_O = b_reg_u16;
  //A       : ADDR_ALU_REG_O = a_reg_u16;
    //
  //SEXB    : ADDR_ALU_REG_O = b_reg_s16;
    //      : ADDR_ALU_REG_O = ;
    PC      : ADDR_ALU_REG_O = pc_reg; // used in indexed mode
    S       : ADDR_ALU_REG_O = s_reg;
    //
    U       : ADDR_ALU_REG_O = u_reg;
    Y       : ADDR_ALU_REG_O = y_reg;
    X       : ADDR_ALU_REG_O = x_reg;
  //D       : ADDR_ALU_REG_O = d_reg;
    //
  //default : ADDR_ALU_REG_O = zero_u16;
    default : ADDR_ALU_REG_O = REG_DONT_CARE;
  endcase
end

// Index Offset Select Decoding
always @* begin
  case (ADDR_ALU_OFFSET_SEL_I)
    ADDR_OFFSET_SEL_POS1  : ADDR_ALU_OFFSET_O = pos1_u16;  
    ADDR_OFFSET_SEL_POS2  : ADDR_ALU_OFFSET_O = pos2_u16;
    ADDR_OFFSET_SEL_NEG1  : ADDR_ALU_OFFSET_O = neg1_s16;
    ADDR_OFFSET_SEL_NEG2  : ADDR_ALU_OFFSET_O = neg2_s16;
    ADDR_OFFSET_SEL_ZERO  : ADDR_ALU_OFFSET_O = zero_u16;
    ADDR_OFFSET_SEL_B     : ADDR_ALU_OFFSET_O = b_reg_s16;
    ADDR_OFFSET_SEL_A     : ADDR_ALU_OFFSET_O = a_reg_s16;
    ADDR_OFFSET_SEL_D     : ADDR_ALU_OFFSET_O = d_reg;
    ADDR_OFFSET_SEL_IDATA : ADDR_ALU_OFFSET_O = instr_data;
    //  
  //default              : ADDR_ALU_OFFSET_O = instr_data;
    default              : ADDR_ALU_OFFSET_O = REG_DONT_CARE;
  endcase
end

// Sequential Arithmetic Unit Registers
assign DATA_ALU_SAU_ABXY_O[47:40] = a_reg;
assign DATA_ALU_SAU_ABXY_O[39:32] = b_reg;
assign DATA_ALU_SAU_ABXY_O[31:16] = x_reg;
assign DATA_ALU_SAU_ABXY_O[15: 0] = y_reg;

// CCR Write Data
assign RA_CCR_WR_DATA_O = DATA_ALU_Y_I[7:0];
assign RA_CCR_WR_EN_O   = (DATA_ALU_WR_SEL_I == CCR);

assign REGISTER_ARRAY_READY_O = ((ADDR_ALU_REG_SEL_I == DMEM_RD) |   // FIXME Optimize this logic
                                 (DATA_ALU_A_SEL_I   == DMEM_RD) |
                                 (DATA_ALU_B_SEL_I   == DMEM_RD)) ? DMEM_RD_DATA_READY_I : 1'b1;

assign NEW_PC_WR_EN_O = new_pc_wr_en_reg;
assign NEW_PC_O = pc_reg;

/////////////////////////////////////////////////////////////////////////////

endmodule


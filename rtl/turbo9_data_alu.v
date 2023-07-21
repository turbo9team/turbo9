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
// Description: Data ALU with 8/16-bit capability
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
module turbo9_data_alu
(
  // Inputs: Clock & Reset
  input         CLK_I,
  input         RST_I,
  input         STALL_MICROCYCLE_I,

  // Inputs 
  input    [2:0] DATA_ALU_OP_I,
  input    [1:0] DATA_ALU_COND_SEL_I,
  input   [15:0] DATA_ALU_A_I,
  input   [15:0] DATA_ALU_B_I,
  input          DATA_ALU_WIDTH_I,
  input          DATA_ALU_SAU_EN_I,
  input    [3:0] DATA_ALU_SAU_OP_I,
  input   [47:0] DATA_ALU_SAU_ABXY_I,
  input    [4:0] CCR_FLAGS_I,

  // Outputs
  output  [15:0] DATA_ALU_Y_O,
  output   [4:0] DATA_ALU_FLAGS_O,
  output         DATA_ALU_SAU_DONE_O
);

/////////////////////////////////////////////////////////////////////////////
//                             INTERNAL SIGNALS
/////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////// DATA_ALU_OP_I defines
// Note this encoding is critical for partial decoding
localparam  A_PLUS_B      = 3'h0; // 3'b000
localparam  A_PLUS_NOT_B  = 3'h1; // 3'b001
localparam  LSHIFT_A      = 3'h2; // 3'b010
localparam  RSHIFT_A      = 3'h3; // 3'b011
localparam  A_AND_B       = 3'h4; // 3'b100
localparam  A_OR_B        = 3'h5; // 3'b101
localparam  A_XOR_B       = 3'h6; // 3'b110
localparam  SAU           = 3'h7; // 3'b111

//////////////////////////////////////// DATA_ALU_COND_SEL_I defines
//
localparam  ZERO_BIT  = 2'b00;
localparam  ONE_BIT   = 2'b01;
localparam  CARRY_BIT = 2'b10;
localparam  SIGN_BIT  = 2'b11;

//////////////////////////////////////// DATA_ALU_WIDTH_I defines
//
// This must match the MSB of the *_REG_SEL control vectors
localparam  WIDTH_16 =  1'b0;
localparam  WIDTH_8  =  1'b1;

reg          cond;

wire  [15:0] adder_a;
reg   [15:0] adder_b;
reg   [15:0] adder_c;
wire  [15:0] adder_y;

wire  [15:0] lshift_y;
wire  [15:0] rshift_y;
wire  [15:0] and_y;
wire  [15:0] or_y;
wire  [15:0] xor_y;

wire  [15:0] sau_y;
                  
reg   [15:0] alu_y;
                          
wire         n_flag_w;

wire         z_flag_hi;
wire         z_flag_lo;
wire         z_flag_w;
 
wire         c_flag_add_w8;
wire         c_flag_sub_w8;
wire         v_flag_add_w8;
wire         v_flag_sub_w8;
            
wire         c_flag_add_w16;
wire         c_flag_sub_w16;
wire         v_flag_add_w16;
wire         v_flag_sub_w16;

wire         c_flag_add_w;
wire         c_flag_sub_w;
wire         v_flag_add_w;
wire         v_flag_sub_w;

wire   [3:0] sau_flags;

wire         h_flag;   // Half Carry
reg          n_flag;   // Negative
reg          z_flag;   // Zero
reg          v_flag;   // Overflow
reg          c_flag;   // Carry
                      

/////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////
//                                LOGIC
/////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////// ALU Condition Select Logic
//
always @* begin
  case (DATA_ALU_COND_SEL_I)
    ZERO_BIT  :  cond = 1'b0;
    ONE_BIT   :  cond = 1'b1;
    CARRY_BIT :  cond = CCR_FLAGS_I[0];
    default   :  cond = DATA_ALU_A_I[7]; // SIGN_BIT FIXME ALU[7] not optimal (timing) only really need A,B, DMEM_RD
  endcase
end
//
////////////////////////////////////////


//////////////////////////////////////// Adder Logic
//
assign adder_a =  DATA_ALU_A_I;

always @* begin
  if (DATA_ALU_OP_I[0]) begin // Partial Decode for A_PLUS_NOT_B
    adder_b = ~DATA_ALU_B_I;
    adder_c = {15'd0, ~cond};
  end else begin// Partial Decode for A_PLUS_B
    adder_b =  DATA_ALU_B_I;
    adder_c = {15'd0,  cond};
  end
end

// Using a synthesis generated adder. Used my own Look ahead carry before,
// but that sometimes ended up being worse performance depending on the
// target standard library or FPGA. The downside of using a synthesis driven
// adder is it makes generating the C and V flags (especially the V) more
// difficult. The H,C,V "bolt-on" logic should work and there are other ways
// to do this (ex. extra bit adder for carry) but for right now this seems
// to work well, but I'll keep an eye on the timing path reports from
// backend tools to ensure this logic doesn't become to worst timing path.
assign adder_y = adder_a + adder_b + adder_c;

// Half carry logic
assign h_flag         = ( DATA_ALU_A_I[ 3] &  DATA_ALU_B_I[ 3]               ) |
                        (                     DATA_ALU_B_I[ 3] & ~adder_y[ 3]) |
                        ( DATA_ALU_A_I[ 3]                     & ~adder_y[ 3]) ;
                     
// Carry logic       
assign c_flag_add_w8  = ( DATA_ALU_A_I[ 7] &  DATA_ALU_B_I[ 7]               ) |
                        (                     DATA_ALU_B_I[ 7] & ~adder_y[ 7]) |
                        ( DATA_ALU_A_I[ 7]                     & ~adder_y[ 7]) ;

assign c_flag_add_w16 = ( DATA_ALU_A_I[15] &  DATA_ALU_B_I[15]               ) |
                        (                     DATA_ALU_B_I[15] & ~adder_y[15]) |
                        ( DATA_ALU_A_I[15]                     & ~adder_y[15]) ;

assign c_flag_sub_w8  = (~DATA_ALU_A_I[ 7] &  DATA_ALU_B_I[ 7]               ) |
                        (                     DATA_ALU_B_I[ 7] &  adder_y[ 7]) |
                        (~DATA_ALU_A_I[ 7]                     &  adder_y[ 7]) ;

assign c_flag_sub_w16 = (~DATA_ALU_A_I[15] &  DATA_ALU_B_I[15]               ) |
                        (                     DATA_ALU_B_I[15] &  adder_y[15]) |
                        (~DATA_ALU_A_I[15]                     &  adder_y[15]) ;

// Overflow logic
assign v_flag_add_w8  = ( DATA_ALU_A_I[ 7] &  DATA_ALU_B_I[ 7] & ~adder_y[ 7]) |
                        (~DATA_ALU_A_I[ 7] & ~DATA_ALU_B_I[ 7] &  adder_y[ 7]) ;

assign v_flag_add_w16 = ( DATA_ALU_A_I[15] &  DATA_ALU_B_I[15] & ~adder_y[15]) |
                        (~DATA_ALU_A_I[15] & ~DATA_ALU_B_I[15] &  adder_y[15]) ;

assign v_flag_sub_w8  = ( DATA_ALU_A_I[ 7] & ~DATA_ALU_B_I[ 7] & ~adder_y[ 7]) |
                        (~DATA_ALU_A_I[ 7] &  DATA_ALU_B_I[ 7] &  adder_y[ 7]) ;

assign v_flag_sub_w16 = ( DATA_ALU_A_I[15] & ~DATA_ALU_B_I[15] & ~adder_y[15]) |
                        (~DATA_ALU_A_I[15] &  DATA_ALU_B_I[15] &  adder_y[15]) ;
//
////////////////////////////////////////

//////////////////////////////////////// Boolean Logic
//
assign and_y  = {8'h00, (DATA_ALU_A_I[7:0] & DATA_ALU_B_I[7:0])}; // INFO: 8bit only
assign or_y   = {8'h00, (DATA_ALU_A_I[7:0] | DATA_ALU_B_I[7:0])}; // INFO: 8bit only
assign xor_y  = {8'h00, (DATA_ALU_A_I[7:0] ^ DATA_ALU_B_I[7:0])}; // INFO: 8bit only
//
////////////////////////////////////////

//////////////////////////////////////// Shifters
//
assign lshift_y = {8'h00, DATA_ALU_A_I[6:0], cond}; // INFO: 8bit only
assign rshift_y = {8'h00, cond, DATA_ALU_A_I[7:1]}; // INFO: 8bit only 
//
////////////////////////////////////////

//////////////////////////////////////// Sequential Arithmetic Unit
//
turbo9_seq_arithmetic_unit I_turbo9_seq_arithmetic_unit
(
  // Inputs: Clock & Reset
  .CLK_I              (CLK_I              ),
  .RST_I              (RST_I              ),
  .STALL_MICROCYCLE_I (STALL_MICROCYCLE_I ),

  .SAU_EN_I           (DATA_ALU_SAU_EN_I  ),
  .SAU_OP_I           (DATA_ALU_SAU_OP_I  ),
  .SAU_ABXY_I         (DATA_ALU_SAU_ABXY_I),

  .CCR_FLAGS_I        (CCR_FLAGS_I        ),

  .SAU_Y_O            (sau_y              ),
  .SAU_DONE_O         (DATA_ALU_SAU_DONE_O),
  .SAU_FLAGS_O        (sau_flags          )
);
//
////////////////////////////////////////

//////////////////////////////////////// ALU Operation Output Select
//
//
always @* begin
  case (DATA_ALU_OP_I)
    LSHIFT_A     : alu_y = lshift_y;
    RSHIFT_A     : alu_y = rshift_y;
    A_AND_B      : alu_y = and_y;
    A_OR_B       : alu_y = or_y;
    A_XOR_B      : alu_y = xor_y;
    SAU          : alu_y = sau_y;
    default      : alu_y = adder_y; // A_PLUS_B or A_PLUS_NOT_B
  endcase
end
//
////////////////////////////////////////

//////////////////////////////////////// Flags Width Select
//
assign n_flag_w     = (DATA_ALU_WIDTH_I == WIDTH_8) ? alu_y[7] : alu_y[15];
//
assign z_flag_hi    = (alu_y[15:8] == 8'h00);
assign z_flag_lo    = (alu_y[ 7:0] == 8'h00);
assign z_flag_w     = (DATA_ALU_WIDTH_I == WIDTH_8) ? z_flag_lo : (z_flag_hi & z_flag_lo);
//
assign v_flag_add_w = (DATA_ALU_WIDTH_I == WIDTH_8) ? v_flag_add_w8 : v_flag_add_w16;
assign v_flag_sub_w = (DATA_ALU_WIDTH_I == WIDTH_8) ? v_flag_sub_w8 : v_flag_sub_w16;
//
assign c_flag_add_w = (DATA_ALU_WIDTH_I == WIDTH_8) ? c_flag_add_w8 : c_flag_add_w16;
assign c_flag_sub_w = (DATA_ALU_WIDTH_I == WIDTH_8) ? c_flag_sub_w8 : c_flag_sub_w16;
//
////////////////////////////////////////

//////////////////////////////////////// Flags Operation Output Select
//
always @* begin
  case (DATA_ALU_OP_I)
    SAU          : n_flag = sau_flags[3];
    default      : n_flag = n_flag_w;
  endcase
end
//
always @* begin
  case (DATA_ALU_OP_I)
    SAU          : z_flag = sau_flags[2];
    default      : z_flag = z_flag_w;
  endcase
end
//
always @* begin
  case (DATA_ALU_OP_I)
    A_PLUS_B     : v_flag = v_flag_add_w;
    A_PLUS_NOT_B : v_flag = v_flag_sub_w;
    LSHIFT_A     : v_flag = DATA_ALU_A_I[7] ^ DATA_ALU_A_I[6];
    SAU          : v_flag = sau_flags[1];
    default      : v_flag = 1'b0;
  endcase
end
//
always @* begin
  case (DATA_ALU_OP_I)
    A_PLUS_B     : c_flag = c_flag_add_w;
    A_PLUS_NOT_B : c_flag = c_flag_sub_w;
    LSHIFT_A     : c_flag = DATA_ALU_A_I[7];
    RSHIFT_A     : c_flag = DATA_ALU_A_I[0];
    SAU          : c_flag = sau_flags[0];
    default      : c_flag = 1'b0;
  endcase
end
//
////////////////////////////////////////

//////////////////////////////////////// ALU Outputs
//
assign DATA_ALU_Y_O = alu_y;

assign DATA_ALU_FLAGS_O[4] = h_flag;
assign DATA_ALU_FLAGS_O[3] = n_flag;
assign DATA_ALU_FLAGS_O[2] = z_flag;
assign DATA_ALU_FLAGS_O[1] = v_flag;
assign DATA_ALU_FLAGS_O[0] = c_flag;
//
////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////

endmodule


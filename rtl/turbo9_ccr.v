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
// Description: Condition Code Register
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

module turbo9_ccr // Down on the corner, out in the street.
(
  // Inputs: Clock & Reset
  input         RST_I,
  input         CLK_I,
  input         STALL_MICROCYCLE_I,

  // Inputs
  input   [3:0] CCR_OP_I,
  input   [3:0] MICRO_SEQ_COND_SEL_I,
  input   [3:0] BRANCH_SEL_I,
  input         STACK_DONE_I,
  input         IDX_INDIRECT_EN_I,
  input         DATA_WIDTH_I,
              
  input   [4:0] DATA_ALU_FLAGS_I,
  input         DATA_ALU_SAU_DONE_I,
                                
  input         RA_CCR_WR_EN_I,
  input   [7:0] RA_CCR_WR_DATA_I,
  output  [7:0] RA_CCR_RD_DATA_O,
                     
  // Outputs
  output  [4:0] CCR_FLAGS_O,
  output reg    MICRO_SEQ_COND_O
                                  
);

/////////////////////////////////////////////////////////////////////////////
//                             INTERNAL SIGNALS
/////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////// CCR_OP_I defines
//
//             EFHINZVC
localparam  OP_oooooooo = 4'h0;
localparam  OP_oooooXoo = 4'h1;
localparam  OP_ooooXXXX = 4'h2;
localparam  OP_oooooXoX = 4'h3;
localparam  OP_ooooXXXo = 4'h4;
localparam  OP_ooXoXXXX = 4'h5;
localparam  OP_ooooXXoX = 4'h6;
localparam  OP_1ooooooo = 4'h7;
localparam  OP_o1o1oooo = 4'h8;
localparam  OP_XXXXXXXX = 4'h9;

//////////////////////////////////////// MICRO_SEQ_COND_SEL_I defines
//
localparam  NOT_INDIRECT  = 4'b0000;
localparam  TRUE          = 4'b0001;
localparam  STACK_DONE    = 4'b0010;
localparam  STACK_NEXT    = 4'b0011;
localparam  SAU_NOT_DONE  = 4'b0100;
localparam  BRANCH_COND   = 4'b1000; // One hot decoded

//////////////////////////////////////// BRANCH_SEL_I defines
//
localparam  BRA = 4'h0;
localparam  BRN = 4'h1;
localparam  BHI = 4'h2; 
localparam  BLS = 4'h3; 
localparam  BCC = 4'h4;  // BHS
localparam  BCS = 4'h5;  // BLO
localparam  BNE = 4'h6; 
localparam  BEQ = 4'h7; 
localparam  BVC = 4'h8; 
localparam  BVS = 4'h9; 
localparam  BPL = 4'hA; 
localparam  BMI = 4'hB; 
localparam  BGE = 4'hC; 
localparam  BLT = 4'hD; 
localparam  BGT = 4'hE; 
localparam  BLE = 4'hF; 

reg branch_sig;
//
////////////////////////////////////////


//////////////////////////////////////// Internal CCR Signals
//
wire    alu_c;       // Carry
wire    alu_v;       // Overflow
wire    alu_z;       // Zero
wire    alu_n;       // Negative
wire    alu_h;       // Half Carry
wire    masked_h;    // Half Carry masked for 16bit operations
                    
reg     c_reg;       // Carry
reg     v_reg;       // Overflow
reg     z_reg;       // Zero
reg     n_reg;       // Negative
reg     i_reg;       // IRQ Interrupt Mask
reg     h_reg;       // Half Carry
reg     f_reg;       // Fast Interrupt Mask
reg     e_reg;       // Entire State on Stack
                   
//
////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////
//                                   LOGIC
/////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////// ALU Flag Input
//
assign alu_h      = DATA_ALU_FLAGS_I[4];
assign alu_n      = DATA_ALU_FLAGS_I[3];
assign alu_z      = DATA_ALU_FLAGS_I[2];
assign alu_v      = DATA_ALU_FLAGS_I[1];
assign alu_c      = DATA_ALU_FLAGS_I[0];
//
assign masked_h = DATA_WIDTH_I ? alu_h : h_reg; // masked for 16bit operations
//
////////////////////////////////////////

//////////////////////////////////////// Condition Code Register
//
always @(posedge CLK_I, posedge RST_I) begin
  if (RST_I) begin
    // c_reg <=  alu_c;
    // v_reg <=  alu_v;
    // z_reg <=  alu_z;
    // n_reg <=  alu_n;
    i_reg <=  1'b1;
    // h_reg <=  masked_h;
    f_reg <=  1'b1;
    e_reg <=  1'b1;
  end else begin
    if (STALL_MICROCYCLE_I == 1'b0) begin
      //unique case (CCR_OP_I) // FIXME optimize logic
      case (CCR_OP_I)
        OP_oooooooo : begin
          // c_reg <=  alu_c;
          // v_reg <=  alu_v;
          // z_reg <=  alu_z;
          // n_reg <=  alu_n;
          // i_reg <=  1'b0;
          // h_reg <=  masked_h;
          // f_reg <=  1'b0;
          // e_reg <=  1'b0;
        end
        OP_oooooXoo : begin
          // c_reg <=  alu_c;
          // v_reg <=  alu_v;
          z_reg <=  alu_z;
          // n_reg <=  alu_n;
          // i_reg <=  1'b0;
          // h_reg <=  masked_h;
          // f_reg <=  1'b0;
          // e_reg <=  1'b0;
        end
        OP_ooooXXXX : begin
          c_reg <=  alu_c;
          v_reg <=  alu_v;
          z_reg <=  alu_z;
          n_reg <=  alu_n;
          // i_reg <=  1'b0;
          // h_reg <=  masked_h;
          // f_reg <=  1'b0;
          // e_reg <=  1'b0;
        end
        OP_oooooXoX : begin
          c_reg <=  alu_c;
          //v_reg <=  alu_v;
          z_reg <=  alu_z;
          //n_reg <=  alu_n;
          // i_reg <=  1'b0;
          //h_reg <=  masked_h;
          // f_reg <=  1'b0;
          // e_reg <=  1'b0;
        end
        OP_ooooXXXo : begin
          // c_reg <=  alu_c;
          v_reg <=  alu_v;
          z_reg <=  alu_z;
          n_reg <=  alu_n;
          // i_reg <=  1'b0;
          // h_reg <=  masked_h;
          // f_reg <=  1'b0;
          // e_reg <=  1'b0;
        end
        OP_ooXoXXXX : begin
          c_reg <=  alu_c;
          v_reg <=  alu_v;
          z_reg <=  alu_z;
          n_reg <=  alu_n;
          // i_reg <=  1'b0;
          h_reg <= masked_h;
          // f_reg <=  1'b0;
          // e_reg <=  1'b0;
        end
        OP_ooooXXoX : begin
          c_reg <=  alu_c;
          // v_reg <=  alu_v;
          z_reg <=  alu_z;
          n_reg <=  alu_n;
          // i_reg <=  1'b0;
          // h_reg <=  masked_h;
          // f_reg <=  1'b0;
          // e_reg <=  1'b0;
        end
        OP_1ooooooo : begin
          // c_reg <=  alu_c;
          // v_reg <=  alu_v;
          // z_reg <=  alu_z;
          // n_reg <=  alu_n;
          // i_reg <=  1'b0;
          // h_reg <=  masked_h;
          // f_reg <=  1'b0;
          e_reg <=  1'b1;
        end
        OP_o1o1oooo : begin
          // c_reg <=  alu_c;
          // v_reg <=  alu_v;
          // z_reg <=  alu_z;
          // n_reg <=  alu_n;
          i_reg <=  1'b1;
          // h_reg <=  masked_h;
          f_reg <=  1'b1;
          // e_reg <=  1'b1;
        end
        OP_XXXXXXXX : begin // FIXME: push this logic into the decode stage
          if (RA_CCR_WR_EN_I) begin
              c_reg <=  RA_CCR_WR_DATA_I[0];
              v_reg <=  RA_CCR_WR_DATA_I[1];
              z_reg <=  RA_CCR_WR_DATA_I[2];
              n_reg <=  RA_CCR_WR_DATA_I[3];
              i_reg <=  RA_CCR_WR_DATA_I[4];
              h_reg <=  RA_CCR_WR_DATA_I[5];
              f_reg <=  RA_CCR_WR_DATA_I[6];
              e_reg <=  RA_CCR_WR_DATA_I[7];
          end 
        end
      endcase
    end
  end
end
//
////////////////////////////////////////


//////////////////////////////////////// Microsquencer Condition Select Logic
//
wire bra_sig = ~(1'b0);
wire brn_sig =  (1'b0);
//
wire bhi_sig = ~(c_reg | z_reg);
wire bls_sig =  (c_reg | z_reg);
//
wire bcc_sig = ~(c_reg); // bhs_sig
wire bcs_sig =  (c_reg); // blo_sig
//
wire bne_sig = ~(z_reg);
wire beq_sig =  (z_reg);
//
wire bvc_sig = ~(v_reg);
wire bvs_sig =  (v_reg);
//
wire bpl_sig = ~(n_reg);
wire bmi_sig =  (n_reg);
//
wire bge_sig = ~(n_reg ^ v_reg);
wire blt_sig =  (n_reg ^ v_reg);
//
wire bgt_sig = ~(z_reg | (n_reg ^ v_reg));
wire ble_sig =  (z_reg | (n_reg ^ v_reg));

always @* begin
  //unique case (BRANCH_SEL_I) // FIXME optimize logic
  case (BRANCH_SEL_I)
    BRA : branch_sig = bra_sig;
    BRN : branch_sig = brn_sig;
    BHI : branch_sig = bhi_sig;
    BLS : branch_sig = bls_sig;
    BCC : branch_sig = bcc_sig; // BHS
    BCS : branch_sig = bcs_sig; // BLO
    BNE : branch_sig = bne_sig;
    BEQ : branch_sig = beq_sig;
    BVC : branch_sig = bvc_sig;
    BVS : branch_sig = bvs_sig;
    BPL : branch_sig = bpl_sig;
    BMI : branch_sig = bmi_sig;
    BGE : branch_sig = bge_sig;
    BLT : branch_sig = blt_sig;
    BGT : branch_sig = bgt_sig;
    BLE : branch_sig = ble_sig;
  endcase
end

always @* begin // FIXME we could use an XOR to produce inverted conditions
  if (MICRO_SEQ_COND_SEL_I[3]) begin
    MICRO_SEQ_COND_O = branch_sig; // BRANCH_COND = 4'b1xxx
  end else begin
    case (MICRO_SEQ_COND_SEL_I[2:0])
      3'b000  : MICRO_SEQ_COND_O = ~IDX_INDIRECT_EN_I;    // NOT_INDIRECT  = 3'b000
      3'b001  : MICRO_SEQ_COND_O = 1'b1;                  // TRUE          = 3'b001
      3'b010  : MICRO_SEQ_COND_O = STACK_DONE_I;          // STACK_DONE    = 3'b010
      3'b011  : MICRO_SEQ_COND_O = ~STACK_DONE_I;         // STACK_NEXT    = 3'b011
      3'b100  : MICRO_SEQ_COND_O = ~DATA_ALU_SAU_DONE_I;  // SAU_NOT_DONE  = 3'b100
      default : MICRO_SEQ_COND_O = ~e_reg;                // E_CLEAR       = 3'b101
    endcase
  end
end

//
////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////



/////////////////////////////////////////////////////////////////////////////
//                              ASSIGN OUTPUTS
/////////////////////////////////////////////////////////////////////////////

assign RA_CCR_RD_DATA_O[7] = e_reg;
assign RA_CCR_RD_DATA_O[6] = f_reg;
assign RA_CCR_RD_DATA_O[5] = h_reg;
assign RA_CCR_RD_DATA_O[4] = i_reg;
assign RA_CCR_RD_DATA_O[3] = n_reg;
assign RA_CCR_RD_DATA_O[2] = z_reg;
assign RA_CCR_RD_DATA_O[1] = v_reg;
assign RA_CCR_RD_DATA_O[0] = c_reg;

assign CCR_FLAGS_O[4] = h_reg;
assign CCR_FLAGS_O[3] = n_reg;
assign CCR_FLAGS_O[2] = z_reg;
assign CCR_FLAGS_O[1] = v_reg;
assign CCR_FLAGS_O[0] = c_reg;

/////////////////////////////////////////////////////////////////////////////

endmodule


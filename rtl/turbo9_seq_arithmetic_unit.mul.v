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
// Description:
// This module executes sequential or irregular math operations and isolates
// them from the critical timing path. There are registers on the inputs and
// outputs. Functions are parameterized so they can be removed to save area.
// 
// //////////// Currently Implemented
// //                                                          NZVC
// MUL     8 by 8 unsigned multiply        D = A * B           oXoX  6809 ISA
// DAA     BCD correction                  A = A + BDC_CF      XXoX  6809 ISA
// 
// //////////// Future
// //                                                          NZVC
// IDIV    16 by 16 unsigned int divide    X = D / X, D = R    oXXX  HC11 ISA
// FDIV    16 by 16 unsigned frac divide   X = D / X, D = R    oXXX  HC11 ISA
// 
// EMUL    16 by 16 unsigned multiply      Y:D = D * Y         XXoX  HC12 ISA
// EMULS   16 by 16 signed multiply        Y:D = D * Y         XXoX  HC12 ISA
// 
// EDIV    32 by 16 unsigned int divide    Y = Y:D / X, D = R  XXXX  HC12 ISA
// EDIVS   32 by 16 signed int divide      Y = Y:D / X, D = R  XXXX  HC12 ISA
// IDIVS   16 by 16 signed int divide      X = D / X,   D = R  XXXX  HC12 ISA
// 
// COS     CORDIC cosine implemtation
// SIN     CORDIC sine implemtation
// 
// SQRT    square root implemation
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
module turbo9_seq_arithmetic_unit
(
  // Inputs: Clock & Reset
  input         CLK_I,
  input         RST_I,
  input         STALL_MICROCYCLE_I,

  input         SAU_EN_I,
  input         SAU_OP_I,
  input  [47:0] SAU_ABXY_I,

  input   [4:0] CCR_FLAGS_I,

  output [15:0] SAU_Y_O,
  output        SAU_DONE_O,
  output  [3:0] SAU_FLAGS_O
);

/////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////
//                             INTERNAL SIGNALS
/////////////////////////////////////////////////////////////////////////////
//
wire  [7:0] a_acc_in = SAU_ABXY_I[47:40];
wire  [7:0] b_acc_in = SAU_ABXY_I[39:32];
//wire [15:0] x_reg_in = SAU_ABXY_I[31:16];
//wire [15:0] y_reg_in = SAU_ABXY_I[15: 0];

wire  ccr_h = CCR_FLAGS_I[4];
wire  ccr_n = CCR_FLAGS_I[3];
wire  ccr_z = CCR_FLAGS_I[2];
wire  ccr_v = CCR_FLAGS_I[1];
wire  ccr_c = CCR_FLAGS_I[0];

///////////////////// SAU_OP_I defines
//
localparam SAU_MUL = 1'b0;
localparam SAU_DAA = 1'b1;

///////////////////// A register
//
reg   [1:0] a_op;
localparam  a_idle       = 2'b00;
localparam  a_load_a_acc = 2'b01;
localparam  a_clear      = 2'b10;
localparam  a_update     = 2'b11;
reg   [7:0] a_reg;
reg   [7:0] a_nxt;
localparam  a_rst = 8'h00;

///////////////////// B register
//
reg         b_op;
localparam  b_idle        = 1'b0;
localparam  b_load_b_acc  = 1'b1;
reg   [7:0] b_reg;
reg   [7:0] b_nxt;
localparam  b_rst = 8'h00;

///////////////////// Q register
//
reg   [1:0] q_op;
localparam  q_idle        = 2'b00;
localparam  q_load_a_acc  = 2'b01;
localparam  q_update      = 2'b10;
reg   [7:0] q_reg;
reg   [7:0] q_nxt;
localparam  q_rst = 8'h00;

///////////////////// Flags
//
reg   [1:0] flags_op;
localparam  flags_idle  = 2'b00;
localparam  flags_mul   = 2'b01;
localparam  flags_daa   = 2'b10;

reg         n_reg;
reg         n_nxt;
localparam  n_rst = 1'b0;

reg         z_reg;
reg         z_nxt;
localparam  z_rst = 1'b0;

reg         v_reg;
reg         v_nxt;
localparam  v_rst = 1'b0;

reg         c_reg;
reg         c_nxt;
localparam  c_rst = 1'b0;

wire        z_hi8;
wire        z_w8;
wire        z_w16;

///////////////////// Adder
//
reg   [1:0] adder_op;
localparam  adder_pass_a        = 2'b00;
localparam  adder_a_plus_b      = 2'b01;
localparam  adder_a_plus_bcd_cf = 2'b10;
reg   [7:0] adder_a_in;
reg   [7:0] adder_b_in;
reg         adder_c_in;
wire  [8:0] adder_y;

///////////////////// Shifter
//
reg         shifter_op;
localparam  shifter_pass  = 1'b0;
localparam  shifter_shift = 1'b1;
reg  [15:0] shifter_y;

///////////////////// State Counter & Done
//
reg         cnt_load;
reg   [3:0] cnt_reg;
reg   [3:0] cnt_nxt;
localparam  cnt_rst = 4'h0;
//
reg         done_reg;
reg         done_nxt;
localparam  done_rst = 1'h0;

///////////////////// BCD Adjust Logic for DAA
//
wire       lsn_gt_9 = (a_reg[3:0] > 4'h9);
wire       msn_gt_9 = (a_reg[7:4] > 4'h9);
wire       msn_gt_8 = (a_reg[7:4] > 4'h8);
wire [3:0] lsn_cf   = (ccr_h || lsn_gt_9) ? 4'h6 : 4'h0; 
wire [3:0] msn_cf   = (ccr_c || msn_gt_9 || (msn_gt_8 && lsn_gt_9)) ? 4'h6 : 4'h0;
wire [7:0] bcd_cf   = {msn_cf, lsn_cf}; // BCD Correction Factor

//
/////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////
//                                Control
/////////////////////////////////////////////////////////////////////////////
//
always @* begin
  //
  // Defaults
  a_op        = a_idle;
  b_op        = b_idle;
  q_op        = q_idle;
  flags_op    = flags_idle;
  adder_op    = adder_pass_a;
  shifter_op  = shifter_pass;
  cnt_load    = 1'b0;
  cnt_nxt     = 4'h8;
  done_nxt    = 1'b0;
  //
  case (SAU_OP_I)
    //
    SAU_DAA : begin //////////////////// SAU_DAA
      case (cnt_reg)
        4'h0 : begin
          if (SAU_EN_I) begin
            a_op      = a_load_a_acc;
            cnt_load  = 1'b1;
            cnt_nxt   = 3'h1;
            done_nxt  = 1'b1;
          end
        end
        default : begin
          adder_op    = adder_a_plus_bcd_cf;
          shifter_op  = shifter_pass;
          a_op        = a_clear;
          q_op        = q_update;
          flags_op    = flags_daa;
        end
      endcase
    end
    //
    default : begin //////////////////// SAU_MUL
      case (cnt_reg)
        4'h0 : begin
          if (SAU_EN_I) begin
            a_op  = a_clear;
            b_op  = b_load_b_acc;
            q_op  = q_load_a_acc;
            cnt_load    = 1'b1;
            cnt_nxt     = 4'h8;
          end
        end
        default : begin
          if (q_reg[0]) begin
            adder_op  = adder_a_plus_b;
          end
          shifter_op  = shifter_shift;
          a_op        = a_update;
          q_op        = q_update;
          done_nxt    = (cnt_reg == 4'h2); // Optimal for min cycles
          if (cnt_reg == 4'h1) begin
            flags_op  = flags_mul;
          end
        end
      endcase
    end
    //
  endcase
end
//
/////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////
//                             Datapath
/////////////////////////////////////////////////////////////////////////////
//
///////////////////// A Register Logic
//
always @* begin
  case (a_op)
    a_load_a_acc : a_nxt = a_acc_in;
    a_clear      : a_nxt = 8'h00;
    a_update     : a_nxt = shifter_y[15:8];
    default      : a_nxt = a_reg; // a_idle
  endcase
end

///////////////////// B Register Logic
//
always @* begin
  case (b_op)
    b_load_b_acc : b_nxt = b_acc_in;
    default      : b_nxt = b_reg; // a_idle
  endcase
end

///////////////////// Adder
//
always @* begin
  case (adder_op)
    adder_a_plus_b      : adder_a_in = a_reg;
    adder_a_plus_bcd_cf : adder_a_in = a_reg;
    default             : adder_a_in = a_reg; // adder_pass_a
  endcase
  case (adder_op)
    adder_a_plus_b      : adder_b_in = b_reg;
    adder_a_plus_bcd_cf : adder_b_in = bcd_cf;
    default             : adder_b_in = 8'h00; // adder_pass_a
  endcase
  case (adder_op)
    adder_a_plus_b      : adder_c_in = 1'b0;
    adder_a_plus_bcd_cf : adder_c_in = 1'b0;
    default             : adder_c_in = 1'b0; // adder_pass_a
  endcase
end
assign adder_y = {1'b0,adder_a_in} + {1'b0,adder_b_in} + {8'h00,adder_c_in};

///////////////////// Shifter
//
always @* begin
  case (shifter_op)
    shifter_shift : shifter_y = {adder_y, q_reg[7:1]  };
    default       : shifter_y = {8'h00,   adder_y[7:0]}; // shifter_pass
  endcase
end

///////////////////// Q Register Logic
//
always @* begin
  case (q_op)
    q_load_a_acc  : q_nxt = a_acc_in;
    q_update      : q_nxt = shifter_y[7:0];
    default       : q_nxt = q_reg; // q_idle
  endcase
end
//
/////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////
//                              Flags
/////////////////////////////////////////////////////////////////////////////
//
assign z_hi8  = (shifter_y[15:8] == 8'h00);
assign z_w8   = (shifter_y[7:0]  == 8'h00);
assign z_w16  = z_hi8 & z_w8;
//
///////////////////// Flag Logic
//
always @* begin
  case (flags_op)
    //
    flags_mul : begin
      n_nxt = ccr_n; // Not affected
      z_nxt = z_w16;
      v_nxt = ccr_v; // Not affected
      c_nxt = shifter_y[7];
    end
    //
    flags_daa : begin
      n_nxt = shifter_y[7];
      z_nxt = z_w8;
      v_nxt = ccr_v; // INFO: Spec Undefined, Turbo9 not affected
      c_nxt = (ccr_c | adder_y[8]);
    end
    //
    default : begin // flags_idle
      n_nxt = n_reg;
      z_nxt = z_reg;
      v_nxt = v_reg;
      c_nxt = c_reg;
    end
    //
  endcase
end
//
/////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////
//                             Registers
/////////////////////////////////////////////////////////////////////////////
//
always @(posedge CLK_I, posedge RST_I) begin
  if (RST_I) begin
    a_reg    <= a_rst;
    b_reg    <= b_rst;
    q_reg    <= q_rst;
    n_reg    <= n_rst;
    z_reg    <= z_rst;
    v_reg    <= v_rst;
    c_reg    <= c_rst;
    cnt_reg  <= cnt_rst;
    done_reg <= done_rst;
  end else begin
    if (~STALL_MICROCYCLE_I) begin
      a_reg    <= a_nxt;
      b_reg    <= b_nxt;
      q_reg    <= q_nxt;
      n_reg    <= n_nxt;
      z_reg    <= z_nxt;
      v_reg    <= v_nxt;
      c_reg    <= c_nxt;
      done_reg <= done_nxt;
      //
      if (cnt_load) begin
        cnt_reg <= cnt_nxt;
      end else if (cnt_reg != 4'h0) begin
        cnt_reg <= cnt_reg - 4'h1;
      end
    end
  end
end
//
/////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////
//                             ASSIGN OUTPUTS
/////////////////////////////////////////////////////////////////////////////
//
assign SAU_Y_O      = {a_reg, q_reg};

assign SAU_FLAGS_O[3] = n_reg;
assign SAU_FLAGS_O[2] = z_reg;
assign SAU_FLAGS_O[1] = v_reg;
assign SAU_FLAGS_O[0] = c_reg;

assign SAU_DONE_O   = done_reg;
//
/////////////////////////////////////////////////////////////////////////////

endmodule


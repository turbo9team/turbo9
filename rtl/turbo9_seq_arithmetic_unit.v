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
// MUL     8 by 8 unsigned multiply        D = A * B           oXoX  6809 ISA -
// DAA     BCD correction                  A = A + BDC_CF      XXoX  6809 ISA
// 
// //////////// Future
// //                                                          NZVC
// IDIV    16 by 16 unsigned int divide    X = D / X, D = R    oXXX  HC11 ISA
// FDIV    16 by 16 unsigned frac divide   X = D / X, D = R    oXXX  HC11 ISA
// 
// EMUL    16 by 16 unsigned multiply      Y:D = D * Y         XXoX  HC12 ISA -
// EMULS   16 by 16 signed multiply        Y:D = D * Y         XXoX  HC12 ISA
// 
// EDIV    32 by 16 unsigned int divide    Y = Y:D / X, D = R  XXXX  HC12 ISA -
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
  input         SAU_DEC_I,
  input   [3:0] SAU_OP_I,
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
wire [15:0] d_acc_in = SAU_ABXY_I[47:32];
//
wire  [7:0] a_acc_in = SAU_ABXY_I[47:40];
wire  [7:0] b_acc_in = SAU_ABXY_I[39:32];
wire [15:0] x_reg_in = SAU_ABXY_I[31:16];
wire [15:0] y_reg_in = SAU_ABXY_I[15: 0];

wire  ccr_h = CCR_FLAGS_I[4];
wire  ccr_n = CCR_FLAGS_I[3];
wire  ccr_z = CCR_FLAGS_I[2];
wire  ccr_v = CCR_FLAGS_I[1];
wire  ccr_c = CCR_FLAGS_I[0];

///////////////////// SAU_OP_I defines
// opcode[3:0] | (Page2_en<<1)
// Page1
localparam SAU_EMUL  = 4'b0100; // 4 opcode = $14
localparam SAU_EMULS = 4'b0101; // 5 opcode = $15
localparam SAU_IDIV  = 4'b1000; // 8 opcode = $18
localparam SAU_DAA   = 4'b1001; // 9 opcode = $19
localparam SAU_MUL   = 4'b1101; // D opcode = $3D
// Page2
localparam SAU_EDIV  = 4'b0110; // 6 opcode = $1014
localparam SAU_EDIVS = 4'b0111; // 7 opcode = $1015
localparam SAU_IDIVS = 4'b1010; // A opcode = $1018
localparam SAU_FDIV  = 4'b1011; // B opcode = $1019
localparam SAU_CPY   = 4'b1111; // F opcode = $101F

///////////////////// A register
//
reg   [3:0] a_op;
localparam  a_idle          = 4'b0000;
localparam  a_clear         = 4'b0001;
localparam  a_rshift        = 4'b0010;
localparam  a_rshift_signed = 4'b0011;
localparam  a_update        = 4'b0100;
localparam  a_update_div    = 4'b1000; // One-Hot
reg  [15:0] a_reg;
reg  [15:0] a_nxt;
localparam  a_rst = 16'h0000;

///////////////////// A Restore Register
//
wire [15:0] aq_lshift;

///////////////////// M register
//
reg  [2:0]  m_op;
localparam  m_idle        = 3'h0;
localparam  m_load_b_acc  = 3'h1;
localparam  m_load_y_reg  = 3'h2;
localparam  m_load_x_reg  = 3'h3;
localparam  m_load_bcd_cf = 3'h4;
localparam  m_load_neg1   = 3'h5;
reg  [15:0] m_reg;
reg  [15:0] m_nxt;
localparam  m_rst = 16'h0000;

///////////////////// Q register
//
reg   [2:0] q_op;
localparam  q_idle        = 3'h0;
localparam  q_load_d_acc  = 3'h1;
localparam  q_lshift      = 3'h2;
localparam  q_rshift      = 3'h3;
localparam  q_update      = 3'h4;
reg  [15:0] q_reg;
reg  [15:0] q_nxt;
localparam  q_rst = 16'h0000;

///////////////////// S register
//
reg   [1:0] s_op;
localparam  s_idle        = 3'h0;
localparam  s_clear       = 3'h1;
localparam  s_load_q0     = 3'h2;
reg         s_reg;
reg         s_nxt;
localparam  s_rst = 1'b0;

///////////////////// Flags
//
reg   [2:0] flags_op;
localparam  flags_idle  = 3'h0;
localparam  flags_mul   = 3'h1;
localparam  flags_daa   = 3'h2;
localparam  flags_emul  = 3'h3;
localparam  flags_idiv  = 3'h4;

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

///////////////////// Adder
//
reg   [2:0] adder_op;
localparam  adder_pass_a      = 3'h0;
localparam  adder_a_plus_m    = 3'h1;
localparam  adder_a_minus_m   = 3'h2;
localparam  adder_aq_minus_m  = 3'h3;
localparam  adder_q_plus_m    = 3'h4;
localparam  adder_pass_q      = 3'h5;
reg  [16:0] adder_a_in;
reg  [16:0] adder_m_in;
reg         adder_c_in;
wire [15:0] adder_y;
wire        adder_c_out;

///////////////////// State Counter & Done
//
reg         cycle_load;
reg   [4:0] cycle_reg;
reg   [4:0] cycle_nxt;
localparam  cycle_rst = 5'h1F;
//
reg         done_reg;
reg         done_nxt;
localparam  done_rst = 1'h0;

///////////////////// BCD Adjust Logic for DAA
//
wire       lsn_gt_9 = (q_reg[11: 8] > 4'h9);
wire       msn_gt_9 = (q_reg[15:12] > 4'h9);
wire       msn_gt_8 = (q_reg[15:12] > 4'h8);
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
  a_op          = a_idle;
  m_op          = m_idle;
  q_op          = q_idle;
  s_op          = s_idle;
  flags_op      = flags_idle;
  adder_op      = adder_pass_a;
  cycle_load      = 1'b0;
  cycle_nxt       = 5'h0;
  done_nxt      = done_reg;
  //
  case (SAU_OP_I)
    //
    SAU_EMULS,
    SAU_EMUL  : begin //////////////////// SAU_EMUL / SAU EMULS
      case (cycle_reg)
        5'h1F : begin
          a_op  = a_clear;
          m_op  = m_load_y_reg;
          q_op  = q_load_d_acc;
          s_op  = s_clear;
          cycle_load    = 1'b1;
          cycle_nxt     = 5'd17;
        end
        default : begin
          if (SAU_OP_I[0]) begin // INFO SAU_EMULS One Hot! 
            if (~q_reg[0] && s_reg) begin
              adder_op  = adder_a_plus_m;
            end else if (q_reg[0] && ~s_reg) begin
              adder_op  = adder_a_minus_m;
            end
            a_op      = a_rshift_signed;
          end else begin
            if (q_reg[0]) begin
              adder_op  = adder_a_plus_m;
            end
            a_op        = a_rshift;
          end
          q_op        = q_rshift;
          s_op        = s_load_q0;
          done_nxt    = (cycle_reg == 5'h3); // Optimal for min cycles
          if (cycle_reg == 5'h2) begin
            flags_op  = flags_emul;
          end
        end
        5'h1 : begin
          adder_op    = adder_pass_q;
          a_op        = a_update;
        end
        5'h0 : begin
          cycle_nxt   = 5'h0; // do nothing
        end
      endcase
    end
    //
    SAU_IDIVS,
    SAU_IDIV : begin //////////////////// SAU_IDIV
      case (cycle_reg)
        5'h1F : begin
          a_op      = a_clear;
          m_op      = m_load_x_reg;
          q_op      = q_load_d_acc;
          cycle_load  = 1'b1;
          cycle_nxt   = 5'd17;
        end
        default : begin
          q_op          = q_lshift;
          adder_op      = adder_aq_minus_m;
          a_op          = a_update_div;
          done_nxt      = (cycle_reg == 5'h3); // Optimal for min cycles
          if (cycle_reg == 5'h2) begin
            flags_op  = flags_idiv;
          end
        end
        5'h1 : begin
          adder_op    = adder_pass_q;
          a_op        = a_update;
        end
        5'h0 : begin
          cycle_nxt   = 5'h0; // do nothing
        end
      endcase
    end
    //
    SAU_CPY : begin //////////////////// SAU_CPY
      case (cycle_reg)
        5'h1F : begin
          q_op      = q_load_d_acc;
          m_op      = m_load_neg1;
          done_nxt  = z_q_w16;
          cycle_load  = 1'b1;
          cycle_nxt   = 5'h0;
        end
        default : begin // 5'h0
          adder_op  = adder_q_plus_m;
          if (SAU_DEC_I) begin
            q_op      = q_update;
          end
          if (~done_reg) begin
            done_nxt  = z_q_w16;
          end
        end
      endcase
    end
    //
    SAU_DAA : begin //////////////////// SAU_DAA
      case (cycle_reg)
        5'h1F : begin
          q_op      = q_load_d_acc;
          cycle_load  = 1'b1;
          cycle_nxt   = 5'h2;
        end
        5'h2 : begin
          m_op      = m_load_bcd_cf;
          done_nxt  = 1'b1;
        end
        default : begin
          adder_op    = adder_q_plus_m;
          a_op        = a_update;
          flags_op    = flags_daa;
        end
        5'h0 : begin
          cycle_nxt   = 5'h0; // do nothing
        end
      endcase
    end
    //
    default : begin //////////////////// SAU_MUL
      case (cycle_reg)
        5'h1F : begin
          a_op  = a_clear;
          m_op  = m_load_b_acc;
          q_op  = q_load_d_acc;
          cycle_load    = 1'b1;
          cycle_nxt     = 5'h8;
        end
        default : begin
          if (q_reg[8]) begin
            adder_op  = adder_a_plus_m;
          end
          a_op        = a_rshift;
          q_op        = q_rshift;
          done_nxt    = (cycle_reg == 5'h2); // Optimal for min cycles
          if (cycle_reg == 5'h1) begin
            flags_op  = flags_mul;
          end
        end
        5'h0 : begin
          cycle_nxt   = 5'h0; // do nothing
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
  if (a_op[3] == 1'b1) begin  // a_update_div
    a_nxt = (~adder_c_out) ? aq_lshift : adder_y;
  end else begin
    case (a_op[2:0])
      a_clear           : a_nxt = 16'd0;
      a_rshift          : a_nxt = {adder_c_out, adder_y[15:1]};
      a_rshift_signed   : a_nxt = {adder_y[15], adder_y[15:1]};
      a_update          : a_nxt = adder_y;
      default           : a_nxt = a_reg; // a_idle
    endcase
  end
end

///////////////////// M Register Logic
//
always @* begin
  case (m_op)
    m_load_b_acc  : m_nxt = {b_acc_in, 8'h00};
    m_load_y_reg  : m_nxt = y_reg_in;
    m_load_x_reg  : m_nxt = x_reg_in;
    m_load_bcd_cf : m_nxt = {bcd_cf, 8'h00};
    m_load_neg1   : m_nxt = 16'hFFFF;
    default       : m_nxt = m_reg; // m_idle
  endcase
end

///////////////////// Q Register Logic
//
always @* begin
  case (q_op)
    q_load_d_acc  : q_nxt = d_acc_in;
    q_lshift      : q_nxt = {q_reg[14:0], adder_c_out};
    q_rshift      : q_nxt = {adder_y[0], q_reg[15:1]};
    q_update      : q_nxt = adder_y;
    default       : q_nxt = q_reg; // q_idle
  endcase
end

///////////////////// AQ Left Shift
//
assign  aq_lshift = {a_reg[14:0], q_reg[15]};

///////////////////// S Register Logic
//
always @* begin
  case (s_op)
    s_clear       : s_nxt = 1'b0;
    s_load_q0     : s_nxt = q_reg[0];
    default       : s_nxt = s_reg; // s_idle
  endcase
end

///////////////////// Adder
//
always @* begin
  case (adder_op)
    adder_a_plus_m    : adder_a_in = {1'b0, a_reg};
    adder_a_minus_m   : adder_a_in = {1'b0, a_reg};
    adder_aq_minus_m  : adder_a_in = {1'b0, aq_lshift};
    adder_q_plus_m    : adder_a_in = {1'b0, q_reg};
    adder_pass_q      : adder_a_in = {1'b0, q_reg};
    default           : adder_a_in = {1'b0, a_reg}; // adder_pass_a
  endcase
  case (adder_op)
    adder_a_plus_m    : adder_m_in = {1'b0, m_reg};
    adder_a_minus_m   : adder_m_in = {1'b0,~m_reg}; //m_reg is always positive do not sign extend
    adder_aq_minus_m  : adder_m_in = {1'b0,~m_reg}; //m_reg is always positive do not sign extend
    adder_q_plus_m    : adder_m_in = {1'b0, m_reg};
    adder_pass_q      : adder_m_in = 17'd0;
    default           : adder_m_in = 17'd0; // adder_pass_a
  endcase
  case (adder_op)
    adder_a_plus_m    : adder_c_in = 1'b0;
    adder_a_minus_m   : adder_c_in = 1'b1;
    adder_aq_minus_m  : adder_c_in = 1'b1;
    adder_q_plus_m    : adder_c_in = 1'b0;
    adder_pass_q      : adder_c_in = 1'b0;
    default           : adder_c_in = 1'b0; // adder_pass_a
  endcase
end
assign {adder_c_out, adder_y} = adder_a_in + adder_m_in + {16'h0000,adder_c_in};

//
/////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////
//                              Flags
/////////////////////////////////////////////////////////////////////////////
//
wire  z_a_h8  = (a_nxt[15:8] == 8'h00);
wire  z_a_l8  = (a_nxt[ 7:0] == 8'h00);
wire  z_a_w16 = z_a_h8 & z_a_l8;
//
wire  z_q_h8  = (q_nxt[15:8] == 8'h00);
wire  z_q_l8  = (q_nxt[ 7:0] == 8'h00);
wire  z_q_w16 = z_q_h8 & z_q_l8;
//
wire  z_w32   = z_q_w16 & z_a_w16;
//
wire  div_by_zero = (m_reg == 16'h0000); // FIXME needs to be sampled before operation.
//
///////////////////// Flag Logic
//
always @* begin
  case (flags_op)
    //
    flags_mul : begin
      n_nxt = ccr_n; // Not affected
      z_nxt = z_a_w16;
      v_nxt = ccr_v; // Not affected
      c_nxt = a_nxt[7];
    end
    //
    flags_emul : begin
      n_nxt = a_nxt[15]; // MSB of result;
      z_nxt = z_w32;
      v_nxt = ccr_v; // Not affected
      c_nxt = q_nxt[15];
    end
    //
    flags_idiv : begin
      n_nxt = ccr_n; // Not affected
      z_nxt = z_q_w16;
      v_nxt = 1'b0; // Cleared
      c_nxt = div_by_zero;
    end
    //
    flags_daa : begin
      n_nxt = a_nxt[15];
      z_nxt = z_a_h8;
      v_nxt = ccr_v; // INFO: Spec Undefined, Turbo9 not affected
      c_nxt = (ccr_c | adder_c_out);
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
always @(posedge CLK_I) begin
  //   a_reg          <= a_rst;         // NO_INIT
  //   m_reg          <= m_rst;         // NO_INIT
  //   q_reg          <= q_rst;         // NO_INIT
  //   s_reg          <= s_rst;         // NO_INIT
  //   n_reg          <= n_rst;         // NO_INIT
  //   z_reg          <= z_rst;         // NO_INIT
  //   v_reg          <= v_rst;         // NO_INIT
  //   c_reg          <= c_rst;         // NO_INIT
  //   cycle_reg      <= cycle_rst;     // NO_INIT
  //   done_reg       <= done_rst;      // NO_INIT
  if (~STALL_MICROCYCLE_I) begin
    a_reg         <= a_nxt;
    m_reg         <= m_nxt;
    q_reg         <= q_nxt;
    s_reg         <= s_nxt;
    n_reg         <= n_nxt;
    z_reg         <= z_nxt;
    v_reg         <= v_nxt;
    c_reg         <= c_nxt;
    //
    if (SAU_EN_I) begin
      done_reg  <= done_nxt;
      if (cycle_load) begin
        cycle_reg <= cycle_nxt;
      end else if (cycle_reg != 5'h0) begin
        cycle_reg <= cycle_reg - 5'd1;
      end
    end else begin
      cycle_reg <= cycle_rst;
      done_reg  <= done_rst;
    end
  end
end
//
/////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////
//                             ASSIGN OUTPUTS
/////////////////////////////////////////////////////////////////////////////
//
assign SAU_Y_O        = a_reg;

assign SAU_FLAGS_O[3] = n_reg;
assign SAU_FLAGS_O[2] = z_reg;
assign SAU_FLAGS_O[1] = v_reg;
assign SAU_FLAGS_O[0] = c_reg;

assign SAU_DONE_O   = done_reg;
//
/////////////////////////////////////////////////////////////////////////////

endmodule


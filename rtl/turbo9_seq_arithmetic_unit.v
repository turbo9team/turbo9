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
// outputs.
// 
// //////////// Currently Implemented
// //                                                          NZVC
// MUL     8 by 8 unsigned multiply        D = A * B           oXoX  6809 ISA -
// DAA     BCD correction                  A = A + BDC_CF      XXoX  6809 ISA
// 
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
// //////////// Beta
// //
// CPY     Memory copy loop counter
//
//////////////////////////////////////////////////////////////////////////////

  
  ///////////////////////////////////////////// EMUL
  //
  // 16 by 16 unsigned integer multiply
  //
  // Y:D = D * Y
  //
  // N   = MSB of product
  //    
  // Z   = 1 if product = 0x0000_0000
  //    
  // C   = bit 15 of product

  ///////////////////////////////////////////// EMULS
  //
  // 16 by 16 signed integer multiply
  //
  // Y:D = D * Y
  //
  // N   = MSB of product
  //    
  // Z   = 1 if product = 0x0000_0000
  //    
  // C   = bit 15 of product

  ///////////////////////////////////////////// IDIVS
  //
  // 16 by 16 signed integer divide 
  //
  // X = D / X
  //     X input when div_by_0 or overflow
  //
  // D = remainder
  //     D input when div_by_0 or overflow
  //
  // N = MSB of quotient
  //     MSB of Y input when div_by_0 or overflow (HC12 undefined)
  //
  // Z = 1 if quotient = 0x0000
  //     1 if Y input  = 0x0000, when div_by_0 or overflow (HC12 undefined)
  //
  // V = 1 if quotient > 0x7FFF (+32767) or 0x8000 (-32768)
  //     1 when div_by_0 (HC12 undefined)
  //
  // C = 1 if divisor = 0x0000
  

  ///////////////////////////////////////////// EDIV
  //
  // 32 by 16 unsigned integer divide 
  //
  // Y = Y:D / X
  //     Y input when div_by_0 or overflow
  //
  // D = remainder
  //     D input when div_by_0 or overflow
  //
  // N = MSB of quotient
  //     MSB of Y input when div_by_0 or overflow (HC12 undefined)
  //
  // Z = 1 if quotient = 0x0000
  //     1 if Y input  = 0x0000, when div_by_0 or overflow (HC12 undefined)
  //
  // V = 1 if quotient > 0xFFFF
  //     1 when div_by_0 (HC12 undefined)
  //
  // C = 1 if divisor = 0x0000
  
  
  ///////////////////////////////////////////// IDIV
  //
  // 16 by 16 unsigned integer divide
  //
  // X = D / X
  //     0xFFFF when div_by_0
  //
  // D = remainder
  //     D input when div_by_0 (HC12 undefined)
  //
  // Z = 1 if quotient = 0x0000
  //     0 when div_by_0
  //
  // V = 0
  //
  // C = 1 if divisor = 0x0000
  
  
  ///////////////////////////////////////////// FDIV
  //
  // 16 by 16 unsigned fractional divide
  // 0.16 = 0.16 / 16.0
  //
  // X = D / X 
  //     0xFFFF when div_by_0
  //
  // D = remainder
  //     D input when div_by_0 (HC12 undefined)
  //
  // Z = 1 if quotient = 0x0000
  //     0 when div_by_0
  //
  // V = 1 if X <= D
  //
  // C = 1 if divisor = 0x0000
 

//////////////////////////////////////////////////////////////////////////////
// History:
// 07.14.2023 - Kevin Phillipson
//   File header added
//
// 07.30.2025 - Kevin Phillipson
//   Everything works
//   All instructions with condition codes verified
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
wire  [7:0] a_acc_in = SAU_ABXY_I[47:40];
wire  [7:0] b_acc_in = SAU_ABXY_I[39:32];
wire [15:0] d_acc_in = SAU_ABXY_I[47:32];
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

wire sau_op_is_emul  = (SAU_OP_I == SAU_EMUL);
wire sau_op_is_emuls = (SAU_OP_I == SAU_EMULS);
wire sau_op_is_idiv  = (SAU_OP_I == SAU_IDIV);
wire sau_op_is_daa   = (SAU_OP_I == SAU_DAA);
wire sau_op_is_mul   = (SAU_OP_I == SAU_MUL);

wire sau_op_is_ediv  = (SAU_OP_I == SAU_EDIV);
wire sau_op_is_edivs = (SAU_OP_I == SAU_EDIVS);
wire sau_op_is_idivs = (SAU_OP_I == SAU_IDIVS);
wire sau_op_is_fdiv  = (SAU_OP_I == SAU_FDIV);
wire sau_op_is_cpy   = (SAU_OP_I == SAU_CPY);

wire sau_op_is_emul_or_emuls;
wire sau_op_is_ediv_or_edivs;
wire sau_op_is_idivs_or_edivs;
wire sau_op_is_idiv_or_fdiv;
wire sau_op_is_idiv_or_fdiv_or_ediv;

wire divisor_sign;
wire dividend_sign;
wire quotient_sign;

///////////////////// A register
//
reg   [2:0] a_op;
localparam  a_idle        = 3'b000; // INFO a_op[2] is one hot!
localparam  a_load_d_acc  = 3'b100;
localparam  a_load_y_reg  = 3'b101;
localparam  a_rshift      = 3'b110;
localparam  a_adder_out   = 3'b111;
reg  [15:0] a_reg;
reg  [15:0] a_nxt;
localparam  a_rst = 16'h0000;

///////////////////// A Restore Register
//
wire [16:0] aq_lshift;

///////////////////// M register
//
reg  [2:0]  m_op;
localparam  m_idle        = 3'b000; // INFO m_op[2] is one hot!
localparam  m_load_b_acc  = 3'b100;
localparam  m_load_y_reg  = 3'b101;
localparam  m_load_x_reg  = 3'b110;
localparam  m_load_bcd_cf = 3'b111;
reg  [15:0] m_reg;
reg  [15:0] m_nxt;
localparam  m_rst = 16'h0000;

///////////////////// Q register
//
reg   [2:0] q_op;
localparam  q_idle        = 3'b000; // INFO q_op[2] is one hot!
localparam  q_load_d_acc  = 3'b100;
localparam  q_lshift      = 3'b101;
localparam  q_rshift      = 3'b110;
localparam  q_adder_out   = 3'b111;
reg  [15:0] q_reg;
reg  [15:0] q_nxt;
localparam  q_rst = 16'h0000;

///////////////////// S register
//
reg   [1:0] s_op;
localparam  s_idle        = 2'h0;
localparam  s_clear       = 2'h1;
localparam  s_load_q0     = 2'h2;
localparam  s_load_c_out  = 2'h3;
reg         s_reg;
reg         s_nxt;
localparam  s_rst = 1'b0;

///////////////////// Flags
//
reg   [2:0] flags_op;
localparam  flags_idle          = 3'h0;
localparam  flags_init          = 3'h1;
localparam  flags_mul           = 3'h2;
localparam  flags_div_nz        = 3'h3;
localparam  flags_div_vc        = 3'h4; 
localparam  flags_daa           = 3'h5;

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

wire        c_nor_v;
wire        z_adder_15_8;
wire        z_adder_15_1;
wire        z_adder_15_0;
           
wire        z_q_14_0;
wire        z_q_15_0;
                    
wire        z_m_15_0;
                      
wire        z_mul_15_0;
wire        z_mul_31_0;
           
wire        v_div_pos;
wire        v_div_neg;
wire        v_div;

///////////////////// Left and Right Muxes
//
reg   [1:0] l_mux_sel;
localparam  l_mux_zero      = 2'h0;
localparam  l_mux_a_reg     = 2'h1;
localparam  l_mux_aq_lshift = 2'h2;
localparam  l_mux_q_reg     = 2'h3;
reg  [15:0] l_mux;
//
reg   [1:0] r_mux_sel;
localparam  r_mux_zero  = 2'h0;
localparam  r_mux_a_reg = 2'h1;     
localparam  r_mux_m_reg = 2'h2;     
localparam  r_mux_q_reg = 2'h3;     
reg  [15:0] r_mux;
  
///////////////////// Sign Extension
//
reg   [1:0] ext_op;
localparam  ext_zero      = 2'h0;
localparam  ext_sign      = 2'h1;
localparam  ext_aq_lshift = 2'h2;
reg         l_ext;
reg         r_ext;

///////////////////// Adder
//
reg   [1:0] adder_op;
localparam  adder_l_plus_r        = 2'h0;
localparam  adder_l_minus_r       = 2'h1;
localparam  adder_l_minus_r_dec1  = 2'h2;
localparam  adder_l_minus_r_carry = 2'h3;
reg  [16:0] adder_l_in;
reg  [16:0] adder_r_in;
reg         adder_c_in;
wire [15:0] adder_out;
wire        adder_c_out;

///////////////////// State, Counter & Done
//
localparam  SAU_STATE_IDLE              = 4'h0; 
localparam  SAU_STATE_DIV_ABS           = 4'h1; 
localparam  SAU_STATE_DIV_ABS_EXT       = 4'h2; 
localparam  SAU_STATE_DIV_SET_CV        = 4'h3; 
localparam  SAU_STATE_DIV_LOOP          = 4'h4; 
localparam  SAU_STATE_DIV_CORRECTION    = 4'h5; 
localparam  SAU_STATE_DIV_FIX_REM_SIGN  = 4'h6; 
localparam  SAU_STATE_DIV_FIX_QUO_SIGN  = 4'h7; 
localparam  SAU_STATE_DAA_LOAD_BCD_CF   = 4'h8;
localparam  SAU_STATE_DAA_BCD_ADJUST    = 4'h9; 
localparam  SAU_STATE_CPY_LOOP          = 4'hA; 
localparam  SAU_STATE_MUL_LOOP          = 4'hB;  
localparam  SAU_STATE_MUL_Q_OUT         = 4'hC; 
reg   [3:0] state_nxt;
reg   [3:0] state_reg;
localparam  state_rst = SAU_STATE_IDLE;
//
reg         cycle_load;
reg   [3:0] cycle_reg;
reg   [3:0] cycle_nxt;
localparam  cycle_rst = 4'b0000;
//
wire        cycle_reg_3_1_z;
wire        cycle_reg_is_0;
wire        cycle_reg_is_1;
//
reg         done_reg;
reg         done_nxt;
localparam  done_rst = 1'h0;
/////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////
//                             SIMPLE LOGIC
/////////////////////////////////////////////////////////////////////////////
//
assign sau_op_is_emul_or_emuls  = (sau_op_is_emul | sau_op_is_emuls);
assign sau_op_is_ediv_or_edivs  = (sau_op_is_ediv | sau_op_is_edivs);
assign sau_op_is_idivs_or_edivs = (sau_op_is_idivs | sau_op_is_edivs);
assign sau_op_is_idiv_or_fdiv   = (sau_op_is_idiv | sau_op_is_fdiv);
assign sau_op_is_idiv_or_fdiv_or_ediv = (sau_op_is_idiv_or_fdiv | sau_op_is_ediv);

assign divisor_sign  = (m_reg[15] & sau_op_is_idivs_or_edivs);
assign dividend_sign = (n_reg & sau_op_is_idivs_or_edivs);
assign quotient_sign = (dividend_sign ^ divisor_sign);

assign c_nor_v = ~(c_reg | v_reg);

assign cycle_reg_3_1_z = ~|cycle_reg[3:1];
assign cycle_reg_is_0  = cycle_reg_3_1_z & ~cycle_reg[0];
assign cycle_reg_is_1  = cycle_reg_3_1_z &  cycle_reg[0];
//
/////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////
//                                Control
/////////////////////////////////////////////////////////////////////////////
//
always @* begin
  
  /////////////////////// Defaults
  //
  a_op          = a_idle;
  m_op          = m_idle;
  q_op          = q_idle;
  s_op          = s_idle;
  //
  l_mux_sel     = l_mux_zero;
  r_mux_sel     = r_mux_zero;
  ext_op        = ext_zero;
  adder_op      = adder_l_plus_r;
  flags_op      = flags_idle;
  //
  cycle_load    = 1'b0;
  cycle_nxt     = 4'd0;
  done_nxt      = 1'b0;
  state_nxt     = SAU_STATE_IDLE; 

  case (state_reg)
    
    /////////////////////// Idle State
    //
    // When SAU enabled, initialize registers
    // and jump to correct state.
    //
    SAU_STATE_IDLE : begin
      //
      l_mux_sel   = l_mux_zero;
      r_mux_sel   = r_mux_zero;
      adder_op    = adder_l_plus_r; // = 0
      s_op        = s_clear;
      //
      if (SAU_EN_I) begin // && ~done_reg) begin
        //
        flags_op    = flags_init;
        //
        if (sau_op_is_idiv_or_fdiv_or_ediv) begin // Unsigned Divide: IDIV FDIV EDIV
          if (sau_op_is_idiv) begin // IDIV
            a_op    = a_adder_out;  // A = 0
            q_op    = q_load_d_acc;
          end else if (sau_op_is_fdiv) begin // FDIV
            a_op    = a_load_d_acc;
            q_op    = q_adder_out; // Q = 0
          end else begin // sau_op_is_ediv EDIV
            a_op    = a_load_y_reg;
            q_op    = q_load_d_acc;
          end
          m_op      = m_load_x_reg;
          state_nxt = SAU_STATE_DIV_SET_CV;
        end else if (sau_op_is_idivs_or_edivs) begin // Signed Divide: IDIVS EDIVS
          if (sau_op_is_idivs) begin // IDIVS
            a_op    = a_adder_out;   // A = 0
            q_op    = q_load_d_acc;
          end else begin // sau_op_is_edivs // EDIVS
            a_op    = a_load_y_reg;
            q_op    = q_load_d_acc;
          end
          m_op      = m_load_x_reg;
          state_nxt = SAU_STATE_DIV_ABS;
        end else if (sau_op_is_daa) begin // Binary Decimal Adjust: DAA
          q_op       = q_load_d_acc;
          state_nxt  = SAU_STATE_DAA_LOAD_BCD_CF;
        end else if (sau_op_is_cpy) begin // Memory Copy Counter: CPY
          q_op       = q_load_d_acc;
          done_nxt   = z_q_15_0;
          state_nxt  = SAU_STATE_CPY_LOOP;
        end else begin                    // Multiply: MUL EMUL EMULS
          if (sau_op_is_mul) begin
            m_op       = m_load_b_acc;
            cycle_nxt  = 4'd7;
          end else begin // sau_op_is_emul_or_emuls
            m_op       = m_load_y_reg;
            cycle_nxt  = 4'd15;
          end
          a_op       = a_adder_out; // A = 0
          q_op       = q_load_d_acc;
          cycle_load = 1'b1;
          state_nxt  = SAU_STATE_MUL_LOOP;
        end
      end
    end

    /////////////////////// Absolute value dividend
    //
    // IDIVS, EDIVS start here
    // absolute value for dividend[15:0]
    //
    SAU_STATE_DIV_ABS : begin
      l_mux_sel = l_mux_zero;
      r_mux_sel = r_mux_q_reg;
      if (dividend_sign) begin
        adder_op  = adder_l_minus_r; // Q = 0 - -Q 
      end else begin
        adder_op  = adder_l_plus_r; // Q = 0 + +Q
      end
      q_op        = q_adder_out;
      s_op        = s_load_c_out;
      if (sau_op_is_idivs) begin
        state_nxt = SAU_STATE_DIV_SET_CV;
      end else begin
        state_nxt = SAU_STATE_DIV_ABS_EXT;
      end
    end

    /////////////////////// Extended absolute value dividend
    //
    // EDIVS absolute value for dividend[31:16]
    //
    SAU_STATE_DIV_ABS_EXT : begin
      l_mux_sel = l_mux_zero;
      r_mux_sel = r_mux_a_reg;
      if (dividend_sign) begin
        adder_op  = adder_l_minus_r_carry; // A = 0 - -A w/ borrow
      end else begin
        adder_op  = adder_l_plus_r; // A = 0 + +A
      end
      a_op        = a_adder_out;
      state_nxt   = SAU_STATE_DIV_SET_CV;
    end

    /////////////////////// Check Overflow / Divide-by-zero state
    //
    // IDIV, FDIV, EDIV start here
    //
    // For EDIV:
    // dividend[31:16] (Y) >= divisor[15:0] (X) then overflow
    // therefore if borrow from A(Y) minus M(X) then no overflow
    // if div-by-zero V will be set via adder_c_out
    //
    // For IDIV:
    // A=0
    // M=divisor (X)
    // so v=0 always (forced in flag_op logic b/c of div-by-zero condition)
    //
    // For FDIV
    // A=dividend (D)
    // M=divisor (X)
    // V with be evaluated the same as EDIV
    // 
    // A - M
    SAU_STATE_DIV_SET_CV : begin
      if (sau_op_is_idivs_or_edivs) begin
        l_mux_sel = l_mux_aq_lshift;
        ext_op    = ext_aq_lshift;
      end else begin
        l_mux_sel = l_mux_a_reg;
        ext_op    = ext_zero;
      end
      r_mux_sel = r_mux_m_reg;
      if (divisor_sign) begin
        adder_op  = adder_l_plus_r; // A + -M
      end else begin
        adder_op  = adder_l_minus_r; // A - +M
      end
      //
      flags_op  = flags_div_vc;
      s_op      = s_clear;
      cycle_load  = 1'b1;
      cycle_nxt   = 4'd15;
      state_nxt   = SAU_STATE_DIV_LOOP;
    end

    /////////////////////// Non-restoring Division Loop
    //
    SAU_STATE_DIV_LOOP : begin
      if (c_nor_v) begin // if no (div-by-0 or overflow) do non-restoring division
        if (s_reg ^ divisor_sign) begin // Sign of A negative? Sign of M negative?
          adder_op  = adder_l_plus_r; // AQ + M
        end else begin
          adder_op  = adder_l_minus_r; // AQ - M
        end
        l_mux_sel = l_mux_aq_lshift;
        r_mux_sel = r_mux_m_reg;
        ext_op    = ext_aq_lshift;
        a_op      = a_adder_out;
        q_op      = q_lshift;
        s_op      = s_load_c_out;
        //
      end else begin // if (div_by_0 or overflow)
        l_mux_sel = l_mux_zero;
        if (sau_op_is_ediv_or_edivs) begin // EDIV: don't change Y & D
          r_mux_sel = r_mux_a_reg;
          adder_op  = adder_l_plus_r; // Pass A
          if (cycle_reg_is_0) begin
            a_op      = a_load_d_acc;
            q_op      = q_adder_out; // = Y
          end else begin
            a_op      = a_load_y_reg;
          end
        end else if (sau_op_is_idivs) begin // IDIVS: don't change X & D
          r_mux_sel = r_mux_m_reg;
          adder_op  = adder_l_plus_r; // 0 + M
          a_op      = a_load_d_acc;
          q_op      = q_adder_out;
        end else begin // IDIV/FDIV: X=FFFF and don't change D
          r_mux_sel = r_mux_zero;
          adder_op  = adder_l_minus_r_dec1; // = FFFF
          a_op      = a_load_d_acc;
          q_op      = q_adder_out;
        end
        cycle_load = 1'b0;
        cycle_nxt  = 4'd0; // stay here for only one more cycle
      end
      //
      if (cycle_reg_is_0) begin
        done_nxt  = ~sau_op_is_idivs_or_edivs; // Optimal for min cycles
        state_nxt = SAU_STATE_DIV_CORRECTION;
      end else begin
        state_nxt = SAU_STATE_DIV_LOOP;
      end
    end

    /////////////////////// Correction step for non-restoring division
    //
    SAU_STATE_DIV_CORRECTION : begin 
      l_mux_sel = l_mux_a_reg;
      r_mux_sel = r_mux_m_reg;
      if (divisor_sign) begin
        adder_op  = adder_l_minus_r; // A - -M
      end else begin
        adder_op  = adder_l_plus_r; // A + +M
      end
      //
      if (s_reg && c_nor_v) begin // Sign of A negative?
        a_op = a_adder_out;
      end
      //
      done_nxt    = 1'b1;
      if (sau_op_is_idivs_or_edivs) begin
        state_nxt   = SAU_STATE_DIV_FIX_REM_SIGN;
      end else begin 
        state_nxt   = SAU_STATE_DIV_FIX_QUO_SIGN;
      end
    end

    /////////////////////// Remainder (A) sign correction for IDIVS/EDIVS
    //
    SAU_STATE_DIV_FIX_REM_SIGN : begin
      l_mux_sel   = l_mux_zero;
      r_mux_sel   = r_mux_a_reg;
      if (dividend_sign && c_nor_v) begin // do not correct sign if no (div-by-0 or overflow)
        adder_op  = adder_l_minus_r; // 0 - A
      end else begin
        adder_op  = adder_l_plus_r; // 0 + A
      end
      a_op        = a_adder_out;
      state_nxt   = SAU_STATE_DIV_FIX_QUO_SIGN;
    end

    /////////////////////// Pass Q or if IDIVS/EDIVS restore quotient sign
    //
    SAU_STATE_DIV_FIX_QUO_SIGN : begin
      l_mux_sel   = l_mux_zero;
      r_mux_sel   = r_mux_q_reg;
      if (quotient_sign && c_nor_v) begin // do not correct sign if no (div-by-0 or overflow)
        adder_op  = adder_l_minus_r; // 0 - Q
      end else begin
        adder_op  = adder_l_plus_r; // 0 + Q
      end
      a_op        = a_adder_out;
      flags_op    = flags_div_nz;
      state_nxt   = SAU_STATE_IDLE;
    end

    /////////////////////// Load Binary Coded Decimal Correction Factor
    //
    // DAA starts here
    //
    SAU_STATE_DAA_LOAD_BCD_CF : begin
      m_op      = m_load_bcd_cf;
      done_nxt  = 1'b1;
      state_nxt = SAU_STATE_DAA_BCD_ADJUST;
    end

    /////////////////////// Perform Binary Coded Decimal Adjustment
    //
    SAU_STATE_DAA_BCD_ADJUST : begin
      l_mux_sel = l_mux_q_reg;
      r_mux_sel = r_mux_m_reg;
      adder_op  = adder_l_plus_r; // Q + BCD_CF
      a_op      = a_adder_out;
      flags_op  = flags_daa;
      state_nxt = SAU_STATE_IDLE;
    end

    /////////////////////// Memory Copy Loop
    //
    // CPY starts here
    //
    SAU_STATE_CPY_LOOP : begin
      l_mux_sel = l_mux_q_reg;
      r_mux_sel = r_mux_zero;
      adder_op  = adder_l_minus_r_dec1;
      if (SAU_DEC_I) begin
        q_op  = q_adder_out; // Dec Q
      end
      done_nxt  = z_q_15_0;
      if (done_reg) begin
        state_nxt = SAU_STATE_IDLE;
      end else begin
        state_nxt = SAU_STATE_CPY_LOOP;
      end
    end

    /////////////////////// Multiply Loop for Signed and Unsigned
    //
    // MUL, EMUL, EMULS start here
    //
    SAU_STATE_MUL_LOOP : begin
      l_mux_sel = l_mux_a_reg;
      if (sau_op_is_emuls) begin // signed multiply
        ext_op  = ext_sign;
        if (~q_reg[0] && s_reg) begin
          r_mux_sel = r_mux_m_reg;
          adder_op  = adder_l_plus_r; // A + M (sign extended)
        end else if (q_reg[0] && ~s_reg) begin
          r_mux_sel = r_mux_m_reg;
          adder_op  = adder_l_minus_r; // A - M (sign extended)
        end else begin
          r_mux_sel = r_mux_zero;
          adder_op  = adder_l_plus_r; // Pass A
        end
      end else begin // unsigned multiply
        ext_op  = ext_zero;
        if ((sau_op_is_mul && q_reg[8]) || (sau_op_is_emul && q_reg[0])) begin
          r_mux_sel = r_mux_m_reg;
          adder_op  = adder_l_plus_r; // A + M
        end else begin
          r_mux_sel = r_mux_zero;
          adder_op  = adder_l_plus_r; // Pass A
        end
      end
      a_op        = a_rshift;
      q_op        = q_rshift;
      s_op        = s_load_q0;
      done_nxt    = (cycle_reg_is_1); // Optimal for min cycles
      if (cycle_reg_is_0) begin
        flags_op  = flags_mul;
        if (sau_op_is_mul) begin
          state_nxt = SAU_STATE_IDLE; 
        end else begin
          state_nxt = SAU_STATE_MUL_Q_OUT;
        end
      end else begin
        state_nxt = SAU_STATE_MUL_LOOP;
      end
    end

    /////////////////////// Multiply output Q register 
    //
    default : begin // SAU_STATE_MUL_Q_OUT
      l_mux_sel = l_mux_q_reg;
      r_mux_sel = r_mux_zero;
      adder_op  = adder_l_plus_r;
      a_op      = a_adder_out; // Pass Q
      state_nxt = SAU_STATE_IDLE; 
    end
  
  endcase
end
//
/////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////
//                             Datapath
/////////////////////////////////////////////////////////////////////////////
//

///////////////////// BCD Adjust Logic for DAA
//
wire       lsn_gt_9 = (q_reg[11: 8] > 4'h9);
wire       msn_gt_9 = (q_reg[15:12] > 4'h9);
wire       msn_gt_8 = (q_reg[15:12] > 4'h8);
wire [3:0] lsn_cf   = (z_reg || lsn_gt_9) ? 4'h6 : 4'h0; // z_reg = half carry bit
wire [3:0] msn_cf   = (c_reg || msn_gt_9 || (msn_gt_8 && lsn_gt_9)) ? 4'h6 : 4'h0;
wire [7:0] bcd_cf   = {msn_cf, lsn_cf}; // BCD Correction Factor

///////////////////// A Register Logic
//
always @* begin
  case (a_op)
    default           : a_nxt = a_reg; // a_idle
    a_load_d_acc      : a_nxt = d_acc_in;
    a_load_y_reg      : a_nxt = y_reg_in;
    a_rshift          : a_nxt = {adder_c_out, adder_out[15:1]};
    a_adder_out       : a_nxt = adder_out;
  endcase
end

///////////////////// M Register Logic
//
always @* begin
  case (m_op)
    default       : m_nxt = m_reg; // m_idle
    m_load_b_acc  : m_nxt = {b_acc_in, 8'h00};
    m_load_y_reg  : m_nxt = y_reg_in;
    m_load_x_reg  : m_nxt = x_reg_in;
    m_load_bcd_cf : m_nxt = {bcd_cf, 8'h00};
  endcase
end

///////////////////// Q Register Logic
//
always @* begin
  case (q_op)
    default       : q_nxt = q_reg; // q_idle
    q_load_d_acc  : q_nxt = d_acc_in;
    q_lshift      : q_nxt = {q_reg[14:0], ~adder_c_out};
    q_rshift      : q_nxt = {adder_out[0], q_reg[15:1]};
    q_adder_out   : q_nxt = adder_out;
  endcase
end

///////////////////// AQ Left Shift
//
assign  aq_lshift = {a_reg[15:0], q_reg[15]};

///////////////////// S Register Logic
//
always @* begin
  case (s_op)
    default       : s_nxt = s_reg; // s_idle
    s_clear       : s_nxt = 1'b0;
    s_load_q0     : s_nxt = q_reg[0];
    s_load_c_out  : s_nxt = adder_c_out;
  endcase
end

///////////////////// Left and Right Muxes
//
always @* begin
  case (l_mux_sel)
    default          : l_mux = 16'h0000; // l_mux_zero
    l_mux_a_reg      : l_mux = a_reg;
    l_mux_aq_lshift  : l_mux = aq_lshift[15:0];
    l_mux_q_reg      : l_mux = q_reg;
  endcase
  //
  case (r_mux_sel)
    default          : r_mux = 16'h0000; // r_mux_zero
    r_mux_a_reg      : r_mux = a_reg;
    r_mux_m_reg      : r_mux = m_reg;
    r_mux_q_reg      : r_mux = q_reg;
  endcase
end

///////////////////// Sign Extension
//
always @* begin
  case (ext_op)
    default       : l_ext = 1'b0; // ext_zero
    ext_sign      : l_ext = l_mux[15];
    ext_aq_lshift : l_ext = aq_lshift[16];
  endcase
  //
  case (ext_op)
    default       : r_ext = 1'b0; // ext_zero
    ext_sign      : r_ext = r_mux[15];
    ext_aq_lshift : r_ext = (sau_op_is_idivs_or_edivs) ? r_mux[15] : 1'b0;
  endcase
end

///////////////////// Adder
//
always @* begin
  adder_l_in = {l_ext, l_mux};
  //
  case (adder_op)
    default               : adder_r_in = { r_ext,  r_mux}; // adder_l_plus_r      
    adder_l_minus_r       : adder_r_in = {~r_ext, ~r_mux};
    adder_l_minus_r_dec1  : adder_r_in = {~r_ext, ~r_mux};
    adder_l_minus_r_carry : adder_r_in = {~r_ext, ~r_mux};
  endcase
  //
  case (adder_op)
    default               : adder_c_in = 1'b0; // adder_l_plus_r      
    adder_l_minus_r       : adder_c_in = 1'b1;
    adder_l_minus_r_dec1  : adder_c_in = 1'b0; 
    adder_l_minus_r_carry : adder_c_in = ~s_reg;
  endcase
end
assign {adder_c_out, adder_out} = adder_l_in + adder_r_in + {16'h0000,adder_c_in};

//
/////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////
//                              Flags
/////////////////////////////////////////////////////////////////////////////
//
assign  z_adder_15_8 = ~|adder_out[15:8];
assign  z_adder_15_1 = z_adder_15_8 & ~|adder_out[7:1];
assign  z_adder_15_0 = z_adder_15_1 & ~adder_out[0];
//
assign  z_q_14_0     = ~|q_nxt[14:0];
assign  z_q_15_0     = ~q_nxt[15] & z_q_14_0; // FIXME
// FIXME (cont) adjust CPY to use q_reg for zero test not q_nxt
// FIXME (cont) q_nxt has a path to registers outside this block
//              
assign  z_m_15_0     = ~|m_reg[15:0];
//                
assign  z_mul_15_0   = ~adder_c_out & z_adder_15_1;
assign  z_mul_31_0   = z_q_15_0 & z_mul_15_0;
//
assign  v_div_pos    = ~quotient_sign & ~adder_c_out;
assign  v_div_neg    =  quotient_sign & ~adder_c_out & ~(z_adder_15_0 & z_q_14_0);
assign  v_div        =  v_div_pos | v_div_neg | z_m_15_0;
// 16 / 16 = 16
// 
// 16 / 16 = 16
// 
// 8000 / FFFF
// 
// -32678 / -1 = 32678
// 
// - x10000 / 1
// 
// 32bit / 16bit 
// 
// abs_dividend[31:16] - abs_divisor[15:0] if negative then no overflow
// 
// abs_dividend[30:15] - abs_divisor[15:0] if negative then no overflow
// 
// 1 - 1 = 0
// 
// 2 - 2 = 0

///////////////////// Flag Logic
//
always @* begin

  // Defaults
  n_nxt = n_reg;
  z_nxt = z_reg;
  v_nxt = v_reg;
  c_nxt = c_reg;

  case (flags_op)
    //
    flags_init : begin
      n_nxt = sau_op_is_idivs ? d_acc_in[15] : // use n_reg to hold dividend sign...
              sau_op_is_edivs ? y_reg_in[15] : ccr_n;
      z_nxt = sau_op_is_daa   ? ccr_h        : ccr_z; // Use z to hold the half carry
      v_nxt = ccr_v;
      c_nxt = ccr_c;
    end
    //
    flags_mul : begin
      if (sau_op_is_mul) begin
        n_nxt = n_reg;
        z_nxt = z_mul_15_0;
        c_nxt = adder_out[8]; // = a_nxt[7]
      end else begin
        n_nxt = adder_c_out;  // = a_nxt[15] (MSB of result)
        z_nxt = z_mul_31_0;
        c_nxt = adder_out[0]; // = q_nxt[15]
      end
    end
    //
    flags_div_nz : begin
      n_nxt = (sau_op_is_idiv_or_fdiv) ? n_reg : adder_out[15]; // = a_nxt[15] (MSB of result)
      z_nxt = z_adder_15_0;
    end
    //
    flags_div_vc : begin
      c_nxt = z_m_15_0; // if div-by-zero
      v_nxt = sau_op_is_idiv ? 1'b0 : v_div;
    end
    //
    flags_daa : begin
      n_nxt = adder_out[15];
      z_nxt = z_adder_15_8;
      //v_nxt = ccr_v; // INFO: Spec Undefined, Turbo9 not affected
      c_nxt = (c_reg | adder_c_out);
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
`ifdef TURBO9_SYNC_RESET
always @(posedge CLK_I) begin
`else
always @(posedge CLK_I, posedge RST_I) begin
`endif
  if (RST_I) begin
    //
`ifdef TURBO9_MIN_RESET 
    // a_reg     <= a_rst;     // INFO: RESET_NO
    // m_reg     <= m_rst;     // INFO: RESET_NO
    // q_reg     <= q_rst;     // INFO: RESET_NO
    // s_reg     <= s_rst;     // INFO: RESET_NO
    // n_reg     <= n_rst;     // INFO: RESET_NO
    // z_reg     <= z_rst;     // INFO: RESET_NO
    // v_reg     <= v_rst;     // INFO: RESET_NO
    // c_reg     <= c_rst;     // INFO: RESET_NO
    // cycle_reg <= cycle_rst; // INFO: RESET_NO
    // done_reg  <= done_rst;  // INFO: RESET_NO
    state_reg <= state_rst;    // INFO: RESET_YES
`else
    a_reg     <= a_rst;    
    m_reg     <= m_rst;    
    q_reg     <= q_rst;    
    s_reg     <= s_rst;    
    n_reg     <= n_rst;    
    z_reg     <= z_rst;    
    v_reg     <= v_rst;    
    c_reg     <= c_rst;    
    cycle_reg <= cycle_rst;
    done_reg  <= done_rst; 
    state_reg <= state_rst;
`endif
    //
  end else begin
    if (~STALL_MICROCYCLE_I) begin
      state_reg <= state_nxt;
      //
      a_reg     <= a_nxt;
      m_reg     <= m_nxt;
      q_reg     <= q_nxt;
      s_reg     <= s_nxt;
      n_reg     <= n_nxt;
      z_reg     <= z_nxt;
      v_reg     <= v_nxt;
      c_reg     <= c_nxt;
      //
      done_reg  <= done_nxt;
      //
      if (cycle_load) begin
        cycle_reg <= cycle_nxt;
      end else if (~cycle_reg_is_0) begin
        cycle_reg <= cycle_reg - 4'd1;
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
assign SAU_Y_O        = a_reg;

assign SAU_FLAGS_O[3] = n_reg;
assign SAU_FLAGS_O[2] = z_reg;
assign SAU_FLAGS_O[1] = v_reg;
assign SAU_FLAGS_O[0] = c_reg;

assign SAU_DONE_O     = done_reg;
//
/////////////////////////////////////////////////////////////////////////////

endmodule


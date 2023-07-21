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
// Description: Testbench: 6809 behavioral model
//
//////////////////////////////////////////////////////////////////////////////
// History:
// 07.14.2023 - Kevin Phillipson
//   File header added
//
//////////////////////////////////////////////////////////////////////////////
// [TURBO9_HEADER_END]

/////////////////////////////////////////////////////////////////////////////
//                        6809 Behavioral Model
/////////////////////////////////////////////////////////////////////////////

module tb_dv_6809_model
#(
  parameter MEM_ADDR_WIDTH = 12,
  parameter BREAK_COM_DIR_OP = 0
)
(
  // Inputs: Clock & Reset
  input         RST_N_I,
  input         CLK_I,

  // Inputs
  input         QUIET_I,
  input         FAST_CLK_I,

  // Outputs
  output        E_CLK_O,
  output        Q_CLK_O,
  output        ERROR_O,
  output [ 7:0] OUTPUT_PORT_O,
  input  [31:0] CYCLE_CNT_O
);

  tb_dv_memory
  #(
    MEM_ADDR_WIDTH
  )
  I_tb_dv_6809_memory ();

  reg [7:0] output_port;
  integer   cycle_cnt;

  wire quiet = QUIET_I;

  ////////////////////////////////////////////////////////////////////////////
  // 6809 Model Signals
  ////////////////////////////////////////////////////////////////////////////

  ///////////////////////////////////////////// Programmer Model Regs
  //
  reg [15:0]  d_model;
  reg [15:0]  x_model;
  reg [15:0]  y_model;
  reg [15:0]  u_model;
  reg [15:0]  s_model;
  reg [15:0]  pc_model;
  reg [ 7:0]  dp_model;
  reg [ 7:0]  cc_model;

  `define d   d_model
  `define a   d_model[15:8]
  `define b   d_model[ 7:0]

  `define x   x_model
  `define y   y_model
  `define u   u_model
  `define s   s_model
  `define pc  pc_model
  `define dp  dp_model

  `define cc    cc_model
  `define cc_e  cc_model[7]
  `define cc_f  cc_model[6]
  `define cc_h  cc_model[5]
  `define cc_i  cc_model[4]
  `define cc_n  cc_model[3]
  `define cc_z  cc_model[2]
  `define cc_v  cc_model[1]
  `define cc_c  cc_model[0]

  // For viewing in simulation
  wire [7:0] a_model = `a;
  wire [7:0] b_model = `b;
  wire cc_e_model    = `cc_e;
  wire cc_f_model    = `cc_f;
  wire cc_h_model    = `cc_h;
  wire cc_i_model    = `cc_i;
  wire cc_n_model    = `cc_n;
  wire cc_z_model    = `cc_z;
  wire cc_v_model    = `cc_v;
  wire cc_c_model    = `cc_c;

  ///////////////////////////////////////////// Other Model Regs & Signals
  //
  reg         exe_state;
  reg         reset_meta;
  reg         reset_sync;
  wire        e_clk_model;
  reg         e_clk_i;
  wire        q_clk_model;
  reg         q_clk_i;
  reg         error_model;
  reg [ 7:0]  prebyte_model;
  reg [ 7:0]  opcode_model;
  reg [ 7:0]  postbyte_model;
  reg [15:0]  ea_model;

  `define e_clk         e_clk_model
  `define q_clk         q_clk_model
  `define error         error_model
  `define prebyte       prebyte_model
  `define opcode        opcode_model
  `define postbyte      postbyte_model
  `define ea            ea_model
  `define memory        I_tb_dv_6809_memory.memory

  ////////////////////////////////////////////////////////////////////////////
  // Quaduature Clock Generation
  ////////////////////////////////////////////////////////////////////////////
  initial begin
    e_clk_i = 1'b0;
    q_clk_i = 1'b0;
    forever begin
      @ (negedge CLK_I) q_clk_i = ~q_clk_i;
      @ (negedge CLK_I) e_clk_i = ~e_clk_i;
    end
  end

  assign `q_clk = (FAST_CLK_I) ? ~CLK_I : q_clk_i;
  assign `e_clk = (FAST_CLK_I) ?  CLK_I : e_clk_i;

  ////////////////////////////////////////////////////////////////////////////
  // Reset Synchronizer (async set, sync release)
  ////////////////////////////////////////////////////////////////////////////
  always @(negedge RST_N_I or negedge `e_clk)
  begin
    if (~RST_N_I) begin
      reset_meta <= 1'b1;
      reset_sync <= 1'b1;
    end else begin
      if (~exe_state) begin
        reset_meta <= 1'b0;
        reset_sync <= reset_meta;
      end
    end
  end

  ////////////////////////////////////////////////////////////////////////////
  // Execute Model
  ////////////////////////////////////////////////////////////////////////////
  initial begin
    forever begin
      exe_state = 1'b0;
      //
      wait (reset_sync == 1'b1);
      `error       = 1'b0;
      output_port  = 8'h00;
      //
      @ (negedge reset_sync) exe_state = 1'b1;
      //
      if (~quiet) $display("[TB: tb_dv_6809_model] Reset released synchonized to falling edge of E clock");
      execute6809;
      //
    end
  end

  ////////////////////////////////////////////////////////////////////////////
  // 6809 Model Execution Task
  ////////////////////////////////////////////////////////////////////////////
  task execute6809;

    reg        tmp1;
    reg [ 7:0] tmp8;
    reg [15:0] tmp16;

    reg        cin;
    reg        cout;
    reg        hout;

    reg [ 7:0] data8_a;
    reg [ 7:0] data8_b;
    reg [ 7:0] data8_y;

    reg [15:0] data16_a;
    reg [15:0] data16_b;
    reg [15:0] data16_y;
    reg [31:0] data32_y;

    reg [ 7:0] instruction_reg;
    reg [ 7:0] instruction_reg2;

    integer bus_cycles;

  begin


    // Reset the 6809 model
    `d  = 16'h0;
    `x  = 16'h0;
    `y  = 16'h0;
    `u  = 16'h0;
    `s  = 16'h0;
    `pc = 16'h0;
    `dp = 8'h0;
    `cc = 8'h0;

    `cc_i = 1'b1;
    `cc_f = 1'b1;

    `pc = read_mem16(16'hfffe); // Read the reset vector

    if (~quiet) $display("[TB: tb_dv_6809_model] @ 0x%4x : Loading from reset vector, PC = 0x%4x", 16'hfffe, `pc);

    bus_cycles = 6; // reset syncho give 2 cycles so total is 8
    e_clock_cycles(bus_cycles);

    while (~reset_sync & ~`error) begin // While not in reset and no error
      
      bus_cycles = 0;

      `ea       = 16'hxxxx;
      `prebyte  = 8'hxx;
      `postbyte = 8'hxx;

      if (~quiet) $write("[TB: tb_dv_6809_model] @ 0x%4x : Executing ", `pc);
      `opcode   = read_mem8(`pc++);
      if (~quiet) print_opcode_info(`prebyte, `opcode, 1'b1);

      instruction_reg = `opcode;

      case (instruction_reg)

        ///////////////////////////////////////////// NEG
        8'h00, // NEG  (dir)
        8'h40, // NEGA (inh)
        8'h50, // NEGB (inh)
        8'h60, // NEG  (idx)
        8'h70: // NEG  (ext)
        begin 
          bus_cycles = 6; //dir
          data8_a = 8'h00;
          load_mm(`ea, data8_b, bus_cycles);
          {cout, data8_y} = {1'b0, data8_a} - {1'b0, data8_b};
          //`cc_h = 1'b0; // INFO: Spec H Undefined, Turbo9 H not affected
          `cc_n = data8_y[7];
          `cc_z = (data8_y == 8'h00);
          `cc_v = (data8_b == 8'h80);
          `cc_c = cout;
          store_mm(`ea, data8_y);
        end

        ///////////////////////////////////////////// COM
        8'h03, // COM  (dir)
        8'h43, // COMA (inh)
        8'h53, // COMB (inh)
        8'h63, // COM  (idx)
        8'h73: // COM  (ext)
        begin 
          bus_cycles = 6; //dir
          load_mm(`ea, data8_b, bus_cycles);
          if (BREAK_COM_DIR_OP) begin
            data8_y = data8_b;
          end else begin
            data8_y = ~data8_b;
          end
          //`cc_h = 1'b0; // Not affected
          `cc_n = data8_y[7];
          `cc_z = (data8_y == 8'h00);
          `cc_v = 1'b0;
          `cc_c = 1'b1;
          store_mm(`ea, data8_y);
        end

        ///////////////////////////////////////////// LSR
        8'h04, // LSR  (dir)
        8'h44, // LSRA (inh)
        8'h54, // LSRB (inh)
        8'h64, // LSR  (idx)
        8'h74: // LSR  (ext)
        begin 
          bus_cycles = 6; //dir
          load_mm(`ea, data8_b, bus_cycles);
          data8_y = {1'b0, data8_b[7:1]};
          //`cc_h = 1'b0; // Not affected
          `cc_n = 1'b0;
          `cc_z = (data8_y == 8'h00);
          //`cc_v = 1'b0; // Not affected
          `cc_c = data8_b[0];
          store_mm(`ea, data8_y);
        end

        ///////////////////////////////////////////// ROR
        8'h06, // ROR  (dir)
        8'h46, // RORA (inh)
        8'h56, // RORB (inh)
        8'h66, // ROR  (idx)
        8'h76: // ROR  (ext)
        begin 
          bus_cycles = 6; //dir
          load_mm(`ea, data8_b, bus_cycles);
          data8_y = {`cc_c, data8_b[7:1]};
          //`cc_h = 1'b0; // Not affected
          `cc_n = data8_y[7];
          `cc_z = (data8_y == 8'h00);
          //`cc_v = 1'b0; // Not affected
          `cc_c = data8_b[0];
          store_mm(`ea, data8_y);
        end

        ///////////////////////////////////////////// ASR
        8'h07, // ASR  (dir)
        8'h47, // ASRA (inh)
        8'h57, // ASRB (inh)
        8'h67, // ASR  (idx)
        8'h77: // ASR  (ext)
        begin 
          bus_cycles = 6; //dir
          load_mm(`ea, data8_b, bus_cycles);
          data8_y = {data8_b[7], data8_b[7:1]};
          //`cc_h = 1'b0; // INFO: Spec H Undefined, Turbo9 H not affected
          `cc_n = data8_y[7];
          `cc_z = (data8_y == 8'h00);
          //`cc_v = 1'b0;
          `cc_c = data8_b[0];
          store_mm(`ea, data8_y);
        end

        ///////////////////////////////////////////// ASL
        8'h08, // ASL  (dir)
        8'h48, // ASLA (inh)
        8'h58, // ASLB (inh)
        8'h68, // ASL  (idx)
        8'h78: // ASL  (ext)
        begin 
          bus_cycles = 6; //dir
          load_mm(`ea, data8_b, bus_cycles);
          data8_y = {data8_b[6:0], 1'b0};
          //`cc_h = 1'b0; // INFO: Spec H Undefined, Turbo9 H not affected
          `cc_n = data8_y[7];
          `cc_z = (data8_y == 8'h00);
          `cc_v = data8_b[7] ^ data8_b[6];
          `cc_c = data8_b[7];
          store_mm(`ea, data8_y);
        end

        ///////////////////////////////////////////// ROL
        8'h09, // ROL  (dir)
        8'h49, // ROLA (inh)
        8'h59, // ROLB (inh)
        8'h69, // ROL  (idx)
        8'h79: // ROL  (ext)
        begin 
          bus_cycles = 6; //dir
          load_mm(`ea, data8_b, bus_cycles);
          data8_y = {data8_b[6:0], `cc_c};
          //`cc_h = 1'b0; // Not affected
          `cc_n = data8_y[7];
          `cc_z = (data8_y == 8'h00);
          `cc_v = data8_b[7] ^ data8_b[6];
          `cc_c = data8_b[7];
          store_mm(`ea, data8_y);
        end

        ///////////////////////////////////////////// DEC
        8'h0A, // DEC  (dir)
        8'h4A, // DECA (inh)
        8'h5A, // DECB (inh)
        8'h6A, // DEC  (idx)
        8'h7A: // DEC  (ext)
        begin 
          bus_cycles = 6; //dir
          load_mm(`ea, data8_a, bus_cycles);
          data8_b = 8'h01;
          data8_y = data8_a - data8_b;
          //`cc_h = 1'b0; // Not affected
          `cc_n = data8_y[7];
          `cc_z = (data8_y == 8'h00);
          `cc_v = (data8_a == 8'h80);
          //`cc_c = 1'b0; // Not affected
          store_mm(`ea, data8_y);
        end

        ///////////////////////////////////////////// INC
        8'h0C, // INC  (dir)
        8'h4C, // INCA (inh)
        8'h5C, // INCB (inh)
        8'h6C, // INC  (idx)
        8'h7C: // INC  (ext)
        begin 
          bus_cycles = 6; //dir
          load_mm(`ea, data8_a, bus_cycles);
          data8_b = 8'h01;
          data8_y = data8_a + data8_b;
          //`cc_h = 1'b0; // Not affected
          `cc_n = data8_y[7];
          `cc_z = (data8_y == 8'h00);
          `cc_v = (data8_a == 8'h7F);
          //`cc_c = 1'b0; // Not affected
          store_mm(`ea, data8_y);
        end

        ///////////////////////////////////////////// TST
        8'h0D, // TST  (dir)
        8'h4D, // TSTA (inh)
        8'h5D, // TSTB (inh)
        8'h6D, // TST  (idx)
        8'h7D: // TST  (ext)
        begin 
          bus_cycles = 6; //dir
          load_mm(`ea, data8_b, bus_cycles);
          data8_y = data8_b;
          //`cc_h = 1'b0; // Not affected
          `cc_n = data8_y[7];
          `cc_z = (data8_y == 8'h00);
          `cc_v = 1'b0;
          //`cc_c = 1'b0; // Not affected
          //store_mm(`ea, data8_y);
        end

        ///////////////////////////////////////////// JMP
        8'h0E, // JMP  (dir)
        8'h6E, // JMP  (idx)
        8'h7E: // JMP  (ext)
        begin 
          bus_cycles = 3; //dir
          calc_ea16(`ea, bus_cycles);
          `pc = `ea;
        end

        ///////////////////////////////////////////// CLR
        8'h0F, // CLR  (dir)
        8'h4F, // CLRA (inh)
        8'h5F, // CLRB (inh)
        8'h6F, // CLR  (idx)
        8'h7F: // CLR  (ext)
        begin 
          bus_cycles = 6; //dir
          load_mm(`ea, data8_b, bus_cycles);
          data8_y = 8'h00;
          //`cc_h = 1'b0; // Not affected
          `cc_n = 1'b0;
          `cc_z = 1'b1;
          `cc_v = 1'b0;
          `cc_c = 1'b0;
          store_mm(`ea, data8_y);
        end

        ///////////////////////////////////////////// Page 2
        8'h10 : begin
          //
          `prebyte  = `opcode;
          `opcode   = read_mem8(`pc++);
          instruction_reg2 = `opcode;
          if (~quiet) print_opcode_info(`prebyte, `opcode, 1'b1);
          //
          case (instruction_reg2)

            ///////////////////////////////////////////// IDIVS //FIXME add signed divide
            8'h18 : // IDIVS (inh)
            begin 
              bus_cycles = 25;
              data16_a = `d;
              data16_b = `x;
              data16_y = $unsigned(data16_a) / $unsigned(data16_b);
              //`cc_h = 1'b0;
              //`cc_n = 1'b0;
              `cc_z = (data16_y == 16'h0000);
              `cc_v = 1'b0;
              `cc_c = (data16_b == 16'h0000);
              `x = data16_y;
              `d = $unsigned(data16_a) % $unsigned(data16_b);
            end

            ///////////////////////////////////////////// LBxx (rel)
            8'h20, // LBRA // Hidden
            8'h21, // LBRN
            8'h22, // LBHI
            8'h23, // LBLS
            8'h24, // LBHS, LBCC
            8'h25, // LBLO, LBCS
            8'h26, // LBNE
            8'h27, // LBEQ
            8'h28, // LBVC
            8'h29, // LBVS
            8'h2A, // LBPL
            8'h2B, // LBMI
            8'h2C, // LBGE
            8'h2D, // LBLT
            8'h2E, // LBGT
            8'h2F: // LBLE
            begin
              rel16_ea(`ea);
              if (eval_branch(`opcode[3:0])) begin
                `pc = `ea;
                bus_cycles = 6;
              end else begin
                bus_cycles = 5;
              end
            end

            ///////////////////////////////////////////// CMPD
            8'h83, // CMPD (imm)
            8'h93, // CMPD (dir)
            8'hA3, // CMPD (idx)
            8'hB3: // CMPD (ext)
            begin 
              bus_cycles = 7; // dir
              load_op16(`ea,data16_b,bus_cycles);
              data16_a = `d;
              {cout, data16_y} = {1'b0, data16_a} - {1'b0, data16_b};
              //`cc_h = 1'b0; // Not affected
              `cc_n = data16_y[15];
              `cc_z = (data16_y == 16'h00);
              `cc_v = sub_vout16(data16_y, data16_a, data16_b);
              `cc_c = cout;
            end
           
            ///////////////////////////////////////////// CMPY
            8'h8C, // CMPY (imm)
            8'h9C, // CMPY (dir)
            8'hAC, // CMPY (idx)
            8'hBC: // CMPY (ext)
            begin 
              bus_cycles = 7; // dir
              load_op16(`ea,data16_b,bus_cycles);
              data16_a = `y;
              {cout, data16_y} = {1'b0, data16_a} - {1'b0, data16_b};
              //`cc_h = 1'b0; // Not affected
              `cc_n = data16_y[15];
              `cc_z = (data16_y == 16'h00);
              `cc_v = sub_vout16(data16_y, data16_a, data16_b);
              `cc_c = cout;
            end
           
            ///////////////////////////////////////////// LDY
            8'h8E, // LDY (imm)
            8'h9E, // LDY (dir)
            8'hAE, // LDY (idx)
            8'hBE: // LDY (ext)
            begin 
              bus_cycles = 6; // dir
              load_op16(`ea,data16_y,bus_cycles);
              //`cc_h = 1'b0; // Not affected
              `cc_n = data16_y[15];
              `cc_z = (data16_y == 16'h00);
              `cc_v = 1'b0;
              // `cc_c = 1'b0; // Not affected
              `y = data16_y;
            end
           
            ///////////////////////////////////////////// STY
            8'h9F, // STY (dir)
            8'hAF, // STY (idx)
            8'hBF: // STY (ext)
            begin 
              bus_cycles = 6; // dir
              calc_ea16(`ea, bus_cycles);
              data16_y = `y;
              //`cc_h = 1'b0; // Not affected
              `cc_n = data16_y[15];
              `cc_z = (data16_y == 16'h00);
              `cc_v = 1'b0;
              //`cc_c = 1'b0; // Not affected
              write_mem16(`ea, data16_y);
            end
           
            ///////////////////////////////////////////// LDS
            8'hCE, // LDS (imm)
            8'hDE, // LDS (dir)
            8'hEE, // LDS (idx)
            8'hFE: // LDS (ext)
            begin 
              bus_cycles = 6; // dir
              load_op16(`ea,data16_y,bus_cycles);
              //`cc_h = 1'b0; // Not affected
              `cc_n = data16_y[15];
              `cc_z = (data16_y == 16'h00);
              `cc_v = 1'b0;
              // `cc_c = 1'b0; // Not affected
              `s = data16_y;
            end
           
            ///////////////////////////////////////////// STS
            8'hDF, // STS (dir)
            8'hEF, // STS (idx)
            8'hFF: // STS (ext)
            begin 
              bus_cycles = 6; // dir
              calc_ea16(`ea, bus_cycles);
              data16_y = `s;
              //`cc_h = 1'b0; // Not affected
              `cc_n = data16_y[15];
              `cc_z = (data16_y == 16'h00);
              `cc_v = 1'b0;
              //`cc_c = 1'b0; // Not affected
              write_mem16(`ea, data16_y);
            end

            default : begin // Unimplemented Page 2 Opcode
              $display("[TB: tb_dv_6809_model] ERROR: Unimplemented Page 2 opcode!");
              hasta_la_vista_baby;
            end

          endcase //
        end

        ///////////////////////////////////////////// Page 3
        8'h11 : begin
          //
          `prebyte  = `opcode;
          `opcode   = read_mem8(`pc++);
          instruction_reg2 = `opcode;
          if (~quiet) print_opcode_info(`prebyte, `opcode, 1'b1);
          //
          case (instruction_reg2)

            ///////////////////////////////////////////// CMPU
            8'h83, // CMPU (imm)
            8'h93, // CMPU (dir)
            8'hA3, // CMPU (idx)
            8'hB3: // CMPU (ext)
            begin 
              bus_cycles = 7; // dir
              load_op16(`ea,data16_b,bus_cycles);
              data16_a = `u;
              {cout, data16_y} = {1'b0, data16_a} - {1'b0, data16_b};
              //`cc_h = 1'b0; // Not affected
              `cc_n = data16_y[15];
              `cc_z = (data16_y == 16'h00);
              `cc_v = sub_vout16(data16_y, data16_a, data16_b);
              `cc_c = cout;
            end
           
            ///////////////////////////////////////////// CMPS
            8'h8C, // CMPS (imm)
            8'h9C, // CMPS (dir)
            8'hAC, // CMPS (idx)
            8'hBC: // CMPS (ext)
            begin 
              bus_cycles = 7; // dir
              load_op16(`ea,data16_b,bus_cycles);
              data16_a = `s;
              {cout, data16_y} = {1'b0, data16_a} - {1'b0, data16_b};
              //`cc_h = 1'b0; // Not affected
              `cc_n = data16_y[15];
              `cc_z = (data16_y == 16'h00);
              `cc_v = sub_vout16(data16_y, data16_a, data16_b);
              `cc_c = cout;
            end

            default : begin // Unimplemented Page 3 Opcode
              $display("[TB: tb_dv_6809_model] ERROR: Unimplemented Page 3 opcode!");
              hasta_la_vista_baby;
            end

          endcase //
        end

        ///////////////////////////////////////////// NOP (inh)
        8'h12 : begin 
          bus_cycles = 2;
        end

        ///////////////////////////////////////////// SYNC (inh) FIXME
        8'h13 : begin
          $display("[TB: tb_dv_6809_model] ERROR: Unimplemented SYNC opcode!");
          hasta_la_vista_baby;
        end

        ///////////////////////////////////////////// EMUL
        8'h14 : // EMUL (inh)
        begin 
          bus_cycles = 19;
          data16_a = `d;
          data16_b = `y;
          data32_y = $unsigned(data16_a) * $unsigned(data16_b);
          //`cc_h = 1'b0;
          `cc_n = data32_y[31];
          `cc_z = (data32_y == 32'h00000000);
          //`cc_v = sub_vout8(data8_y, data8_a, data8_b);
          `cc_c = data32_y[15];
          `y = data32_y[31:16];
          `d = data32_y[15:0];
        end

        ///////////////////////////////////////////// LBRA (rel)
        8'h16 : // LBRA
        begin
          rel16_ea(`ea);
          `pc = `ea;
          bus_cycles = 5;
        end

        ///////////////////////////////////////////// LBSR (rel)
        8'h17 : begin
          rel16_ea(`ea);
          write_mem8(--`s,`pc[ 7:0]);
          write_mem8(--`s,`pc[15:8]);
          `pc = `ea;
          bus_cycles = 9;
        end

        ///////////////////////////////////////////// IDIV
        8'h18 : // IDIV (inh)
        begin 
          bus_cycles = 19;
          data16_a = `d;
          data16_b = `x;
          data16_y = $unsigned(data16_a) / $unsigned(data16_b);
          //`cc_h = 1'b0;
          //`cc_n = 1'b0;
          `cc_z = (data16_y == 16'h0000);
          `cc_v = 1'b0;
          `cc_c = (data16_b == 16'h0000);
          `x = data16_y;
          `d = $unsigned(data16_a) % $unsigned(data16_b);
        end

        ///////////////////////////////////////////// DAA (inh)
        8'h19 : begin
          //
          data8_a = `a;
          //
          if ((data8_a[3:0] > 4'h9) || `cc_h)
            data8_b[3:0] = 4'h6;
          else
            data8_b[3:0] = 4'h0;
          //
          if (((data8_a[7:4] > 4'h9) || `cc_c) || ((data8_a[7:4] > 4'h8) && (data8_a[3:0] > 4'h9)))
            data8_b[7:4] = 4'h6;
          else
            data8_b[7:4] = 4'h0;
          //
          {tmp1, data8_y} = {1'b0, data8_a} + {1'b0, data8_b};
          //`cc_h = 1'b0; // INFO: Not affected
          `cc_n = data8_y[7];
          `cc_z = (data8_y == 8'h00);
          //`cc_v = 1'b0; // INFO: Undefined (Turbo9: Not affected)
          `cc_c |= tmp1;
          `a = data8_y;
          bus_cycles = 2;
        end

        ///////////////////////////////////////////// ORCC (imm)
        8'h1A : begin
          imm8_ea(`ea, bus_cycles);
          bus_cycles = 3; // set
          data8_a = read_mem8(`ea);
          `cc |= data8_a;
        end

        ///////////////////////////////////////////// ANDCC (imm)
        8'h1C : begin
          imm8_ea(`ea, bus_cycles);
          bus_cycles = 3; // set
          data8_a = read_mem8(`ea);
          `cc &= data8_a;
        end

        ///////////////////////////////////////////// SEX (inh)
        8'h1D : begin
          data8_b = `b;
          data16_y = {{8{data8_b[7]}}, data8_b};
          `d = data16_y;
          //`cc_h = 1'b0; // Not affected
          `cc_n = data16_y[15];
          `cc_z = (data16_y == 16'h00);
          `cc_v = 1'b0; // INFO Prog Man says V unaffected, datasheet says v=0
          //`cc_c = 1'b0; // Not affected
          bus_cycles = 2;
        end

        ///////////////////////////////////////////// EXG (inh)
        8'h1E : begin
          `ea = `pc++;
          tmp8 = read_mem8(`ea);
          //
          data16_a = read_reg(tmp8[7:4]);
          data16_b = read_reg(tmp8[3:0]);
          write_reg(tmp8[7:4],data16_b);
          write_reg(tmp8[3:0],data16_a);
          //
          bus_cycles = 8;
        end

        ///////////////////////////////////////////// TFR (inh)
        8'h1F : begin
          `ea = `pc++;
          tmp8 = read_mem8(`ea);
          //
          data16_a = read_reg(tmp8[7:4]);
          write_reg(tmp8[3:0],data16_a);
          //
          bus_cycles = 6;
        end

        ///////////////////////////////////////////// Bxx (rel)
        8'h20, // BRA
        8'h21, // BRN
        8'h22, // BHI
        8'h23, // BLS
        8'h24, // BHS, BCC
        8'h25, // BLO, BCS
        8'h26, // BNE
        8'h27, // BEQ
        8'h28, // BVC
        8'h29, // BVS
        8'h2A, // BPL
        8'h2B, // BMI
        8'h2C, // BGE
        8'h2D, // BLT
        8'h2E, // BGT
        8'h2F: // BLE
        begin
          rel8_ea(`ea);
          if (eval_branch(`opcode[3:0])) begin
            `pc = `ea;
            bus_cycles = 3;
          end else begin
            bus_cycles = 3;
          end
        end

        ///////////////////////////////////////////// LEAX
        8'h30 : // LEAX (idx)
        begin 
          bus_cycles = 4;
          idx_ea(`ea, bus_cycles);
          data16_y = `ea;
          //`cc_h = 1'b0; // Not affected
          //`cc_n = 1'b0; // Not affected
          `cc_z = (data16_y == 16'h0000);
          //`cc_v = 1'b0; // Not affected
          //`cc_c = 1'b0; // Not affected
          `x = data16_y;
        end

        ///////////////////////////////////////////// LEAY
        8'h31 : // LEAY (idx)
        begin 
          bus_cycles = 4;
          idx_ea(`ea, bus_cycles);
          data16_y = `ea;
          //`cc_h = 1'b0; // Not affected
          //`cc_n = 1'b0; // Not affected
          `cc_z = (data16_y == 16'h0000);
          //`cc_v = 1'b0; // Not affected
          //`cc_c = 1'b0; // Not affected
          `y = data16_y;
        end

        ///////////////////////////////////////////// LEAS
        8'h32 : // LEAS (idx)
        begin 
          bus_cycles = 4;
          idx_ea(`ea, bus_cycles);
          data16_y = `ea;
          //`cc_h = 1'b0; // Not affected
          //`cc_n = 1'b0; // Not affected
          //`cc_z = 1'b0; // Not affected
          //`cc_v = 1'b0; // Not affected
          //`cc_c = 1'b0; // Not affected
          `s = data16_y;
        end

        ///////////////////////////////////////////// LEAU
        8'h33 : // LEAU (idx)
        begin 
          bus_cycles = 4;
          idx_ea(`ea, bus_cycles);
          data16_y = `ea;
          //`cc_h = 1'b0; // Not affected
          //`cc_n = 1'b0; // Not affected
          //`cc_z = 1'b0; // Not affected
          //`cc_v = 1'b0; // Not affected
          //`cc_c = 1'b0; // Not affected
          `u = data16_y;
        end

        ///////////////////////////////////////////// PSHS (stack)
        8'h34 : begin
          `postbyte = read_mem8(`pc++);
          push_regs(`postbyte, `s, `u, tmp16, bus_cycles);
          `s = tmp16;
          bus_cycles += 5;
        end

        ///////////////////////////////////////////// PULS (stack)
        8'h35 : begin
          `postbyte = read_mem8(`pc++);
          pull_regs(`postbyte, `s, `u, tmp16, bus_cycles);
          `s = tmp16;
          bus_cycles += 5;
        end

        ///////////////////////////////////////////// PSHU (stack)
        8'h36 : begin
          `postbyte = read_mem8(`pc++);
          push_regs(`postbyte, `u, `s, tmp16, bus_cycles);
          `u = tmp16;
          bus_cycles += 5;
        end

        ///////////////////////////////////////////// PULU (stack)
        8'h37 : begin
          `postbyte = read_mem8(`pc++);
          pull_regs(`postbyte, `u, `s, tmp16, bus_cycles);
          `u = tmp16;
          bus_cycles += 5;
        end

        ///////////////////////////////////////////// RTS (stack)
        8'h39 : begin
          `pc[15:8] = read_mem8(`s++);
          `pc[ 7:0] = read_mem8(`s++);
          bus_cycles = 5;
        end

        ///////////////////////////////////////////// ABX
        8'h3A : // ABX (inh)
        begin 
          bus_cycles = 11;
          data16_a = `x;
          data16_b = {8'h00,`b};
          data16_y =  data16_a + data16_b;
          //`cc_h = 1'b0;
          //`cc_n = data8_y[7];
          //`cc_z = (data16_y == 16'h0000);
          //`cc_v = sub_vout8(data8_y, data8_a, data8_b);
          //`cc_c = data16_y[7];
          `x = data16_y;
        end

        ///////////////////////////////////////////// RTI (stack)
        8'h3B : begin
          pull_regs(8'h01, `s, `u, tmp16, bus_cycles);
          `s = tmp16;
          if (`cc_e) begin
            pull_regs(8'hFE, `s, `u, tmp16, bus_cycles);
            `s = tmp16;
            bus_cycles = 15;
          end else begin
            pull_regs(8'h80, `s, `u, tmp16, bus_cycles);
            `s = tmp16;
            bus_cycles = 6;
          end
        end

        ///////////////////////////////////////////// MUL
        8'h3D : // MUL (inh)
        begin 
          bus_cycles = 11;
          data8_a = `a;
          data8_b = `b;
          data16_y = $unsigned(data8_a) * $unsigned(data8_b);
          //`cc_h = 1'b0;
          //`cc_n = data8_y[7];
          `cc_z = (data16_y == 16'h0000);
          //`cc_v = sub_vout8(data8_y, data8_a, data8_b);
          `cc_c = data16_y[7];
          `d = data16_y;
        end

        ///////////////////////////////////////////// SWI (stack)
        8'h3F : begin
          `cc_e = 1'b1;
          push_regs(8'hFF, `s, `u, tmp16, bus_cycles);
          `s = tmp16;
          `cc_i = 1'b1;
          `cc_f = 1'b1;
          `pc = read_mem16(16'hFFFA);
          bus_cycles = 19;
        end

        ///////////////////////////////////////////// SUBA
        8'h80, // SUBA (imm)
        8'h90, // SUBA (dir)
        8'hA0, // SUBA (idx)
        8'hB0: // SUBA (ext)
        begin 
          bus_cycles = 4; // dir
          load_op8(`ea,data8_b,bus_cycles);
          data8_a = `a;
          {cout, data8_y} = {1'b0, data8_a} - {1'b0, data8_b};
          //`cc_h = 1'b0; // INFO: Undefined (Turbo9: Not affected)
          `cc_n = data8_y[7];
          `cc_z = (data8_y == 8'h00);
          `cc_v = sub_vout8(data8_y, data8_a, data8_b);
          `cc_c = cout;
          `a = data8_y;
        end

        ///////////////////////////////////////////// CMPA
        8'h81, // CMPA (imm)
        8'h91, // CMPA (dir)
        8'hA1, // CMPA (idx)
        8'hB1: // CMPA (ext)
        begin 
          bus_cycles = 4; // dir
          load_op8(`ea,data8_b,bus_cycles);
          data8_a = `a;
          {cout, data8_y} = {1'b0, data8_a} - {1'b0, data8_b};
          //`cc_h = 1'b0; // INFO: Undefined (Turbo9: Not affected)
          `cc_n = data8_y[7];
          `cc_z = (data8_y == 8'h00);
          `cc_v = sub_vout8(data8_y, data8_a, data8_b);
          `cc_c = cout;
        end

        ///////////////////////////////////////////// SBCA
        8'h82, // SBCA (imm)
        8'h92, // SBCA (dir)
        8'hA2, // SBCA (idx)
        8'hB2: // SBCA (ext)
        begin 
          bus_cycles = 4; // dir
          load_op8(`ea,data8_b,bus_cycles);
          data8_a = `a;
          cin = `cc_c;
          {cout, data8_y} = {1'b0, data8_a} - {1'b0, data8_b} - {8'h00, cin};
          //`cc_h = 1'b0; // INFO: Undefined (Turbo9: Not affected)
          `cc_n = data8_y[7];
          `cc_z = (data8_y == 8'h00);
          `cc_v = sub_vout8(data8_y, data8_a, data8_b);
          `cc_c = cout;
          `a = data8_y;
        end

        ///////////////////////////////////////////// SUBD
        8'h83, // SUBD (imm)
        8'h93, // SUBD (dir)
        8'hA3, // SUBD (idx)
        8'hB3: // SUBD (ext)
        begin 
          bus_cycles = 6; // dir
          load_op16(`ea,data16_b,bus_cycles);
          data16_a = `d;
          {cout, data16_y} = {1'b0, data16_a} - {1'b0, data16_b};
          //`cc_h = 1'b0; // Not affected
          `cc_n = data16_y[15];
          `cc_z = (data16_y == 16'h00);
          `cc_v = sub_vout16(data16_y, data16_a, data16_b);
          `cc_c = cout;
          `d = data16_y;
        end

        ///////////////////////////////////////////// ANDA
        8'h84, // ANDA (imm)
        8'h94, // ANDA (dir)
        8'hA4, // ANDA (idx)
        8'hB4: // ANDA (ext)
        begin 
          bus_cycles = 4; // dir
          load_op8(`ea,data8_b,bus_cycles);
          data8_a = `a;
          data8_y = data8_a & data8_b;
          //`cc_h = 1'b0; // Not affected
          `cc_n = data8_y[7];
          `cc_z = (data8_y == 8'h00);
          `cc_v = 1'b0;
          //`cc_c = 1'b0; // Not affected
          `a = data8_y;
        end

        ///////////////////////////////////////////// BITA
        8'h85, // BITA (imm)
        8'h95, // BITA (dir)
        8'hA5, // BITA (idx)
        8'hB5: // BITA (ext)
        begin 
          bus_cycles = 4; // dir
          load_op8(`ea,data8_b,bus_cycles);
          data8_a = `a;
          data8_y = data8_a & data8_b;
          //`cc_h = 1'b0; // Not affected
          `cc_n = data8_y[7];
          `cc_z = (data8_y == 8'h00);
          `cc_v = 1'b0;
          //`cc_c = 1'b0; // Not affected
        end

        ///////////////////////////////////////////// LDA
        8'h86, // LDA (imm)
        8'h96, // LDA (dir)
        8'hA6, // LDA (idx)
        8'hB6: // LDA (ext)
        begin 
          bus_cycles = 4; // dir
          load_op8(`ea,data8_y,bus_cycles);
          //`cc_h = 1'b0; // Not affected
          `cc_n = data8_y[7];
          `cc_z = (data8_y == 8'h00);
          `cc_v = 1'b0;
          //`cc_c = 1'b0; // Not affected
          `a = data8_y;
        end

        ///////////////////////////////////////////// STA
        8'h97, // STA (dir)
        8'hA7, // STA (idx)
        8'hB7: // STA (ext)
        begin 
          bus_cycles = 4; // dir
          calc_ea8(`ea, bus_cycles);
          data8_y = `a;
          //`cc_h = 1'b0; // Not affected
          `cc_n = data8_y[7];
          `cc_z = (data8_y == 8'h00);
          `cc_v = 1'b0;
          //`cc_c = 1'b0; // Not affected
          write_mem8(`ea, data8_y);
        end

        ///////////////////////////////////////////// EORA
        8'h88, // EORA (imm)
        8'h98, // EORA (dir)
        8'hA8, // EORA (idx)
        8'hB8: // EORA (ext)
        begin 
          bus_cycles = 4; // dir
          load_op8(`ea,data8_b,bus_cycles);
          data8_a = `a;
          data8_y = data8_a ^ data8_b;
          //`cc_h = 1'b0; // Not affected
          `cc_n = data8_y[7];
          `cc_z = (data8_y == 8'h00);
          `cc_v = 1'b0;
          //`cc_c = 1'b0; // Not affected
          `a = data8_y;
        end

        ///////////////////////////////////////////// ADCA
        8'h89, // ADCA (imm)
        8'h99, // ADCA (dir)
        8'hA9, // ADCA (idx)
        8'hB9: // ADCA (ext)
        begin 
          bus_cycles = 4; // dir
          load_op8(`ea,data8_b,bus_cycles);
          data8_a = `a;
          cin = `cc_c;
          {hout, data8_y[3:0]} = {1'b0, data8_a[3:0]} + {1'b0, data8_b[3:0]} + {4'h0, cin};
          {cout, data8_y} = {1'b0, data8_a} + {1'b0, data8_b} + {8'h00, cin};
          `cc_h = hout;
          `cc_n = data8_y[7];
          `cc_z = (data8_y == 8'h00);
          `cc_v = add_vout8(data8_y, data8_a, data8_b);
          `cc_c = cout;
          `a = data8_y;
        end

        ///////////////////////////////////////////// ORA
        8'h8A, // ORA (imm)
        8'h9A, // ORA (dir)
        8'hAA, // ORA (idx)
        8'hBA: // ORA (ext)
        begin
          bus_cycles = 4; // dir
          load_op8(`ea,data8_b,bus_cycles);
          data8_a = `a;
          data8_y = data8_a | data8_b;
          //`cc_h = 1'b0; // Not affected
          `cc_n = data8_y[7];
          `cc_z = (data8_y == 8'h00);
          `cc_v = 1'b0;
          //`cc_c = 1'b0; // Not affected
          `a = data8_y;
        end

        ///////////////////////////////////////////// ADDA
        8'h8B, // ADDA (imm)
        8'h9B, // ADDA (dir)
        8'hAB, // ADDA (idx)
        8'hBB: // ADDA (ext)
        begin 
          bus_cycles = 4; // dir
          load_op8(`ea,data8_b,bus_cycles);
          data8_a = `a;
          {hout, data8_y[3:0]} = {1'b0, data8_a[3:0]} + {1'b0, data8_b[3:0]};
          {cout, data8_y} = {1'b0, data8_a} + {1'b0, data8_b};
          `cc_h = hout;
          `cc_n = data8_y[7];
          `cc_z = (data8_y == 8'h00);
          `cc_v = add_vout8(data8_y, data8_a, data8_b);
          `cc_c = cout;
          `a = data8_y;
        end

        ///////////////////////////////////////////// CMPX
        8'h8C, // CMPX (imm)
        8'h9C, // CMPX (dir)
        8'hAC, // CMPX (idx)
        8'hBC: // CMPX (ext)
        begin 
          bus_cycles = 6; // dir
          load_op16(`ea,data16_b,bus_cycles);
          data16_a = `x;
          {cout, data16_y} = {1'b0, data16_a} - {1'b0, data16_b};
          //`cc_h = 1'b0; // Not affected
          `cc_n = data16_y[15];
          `cc_z = (data16_y == 16'h00);
          `cc_v = sub_vout16(data16_y, data16_a, data16_b);
          `cc_c = cout;
        end


        ///////////////////////////////////////////// BSR
        8'h8D: // BSR  (rel)
        begin
          rel8_ea(`ea);
          write_mem8(--`s,`pc[ 7:0]);
          write_mem8(--`s,`pc[15:8]);
          `pc = `ea;
          bus_cycles = 7;
        end

        ///////////////////////////////////////////// JSR
        8'h9D, // JSR  (dir)
        8'hAD, // JSR  (idx)
        8'hBD: // JSR  (ext)
        begin 
          bus_cycles = 7; //dir
          calc_ea16(`ea, bus_cycles);
          write_mem8(--`s,`pc[ 7:0]);
          write_mem8(--`s,`pc[15:8]);
          `pc = `ea;
        end

        ///////////////////////////////////////////// LDX
        8'h8E, // LDX (imm)
        8'h9E, // LDX (dir)
        8'hAE, // LDX (idx)
        8'hBE: // LDX (ext)
        begin 
          bus_cycles = 5; // dir
          load_op16(`ea,data16_y,bus_cycles);
          //`cc_h = 1'b0; // Not affected
          `cc_n = data16_y[15];
          `cc_z = (data16_y == 16'h00);
          `cc_v = 1'b0;
          // `cc_c = 1'b0; // Not affected
          `x = data16_y;
        end

        ///////////////////////////////////////////// STX
        8'h9F, // STX (dir)
        8'hAF, // STX (idx)
        8'hBF: // STX (ext)
        begin 
          bus_cycles = 5; // dir
          calc_ea16(`ea, bus_cycles);
          data16_y = `x;
          //`cc_h = 1'b0; // Not affected
          `cc_n = data16_y[15];
          `cc_z = (data16_y == 16'h00);
          `cc_v = 1'b0;
          //`cc_c = 1'b0; // Not affected
          write_mem16(`ea, data16_y);
        end

        ///////////////////////////////////////////// SUBB
        8'hC0, // SUBB (imm)
        8'hD0, // SUBB (dir)
        8'hE0, // SUBB (idx)
        8'hF0: // SUBB (ext)
        begin 
          bus_cycles = 4; // dir
          load_op8(`ea,data8_b,bus_cycles);
          data8_a = `b;
          {cout, data8_y} = {1'b0, data8_a} - {1'b0, data8_b};
          //`cc_h = 1'b0; // INFO: Undefined (Turbo9: Not affected)
          `cc_n = data8_y[7];
          `cc_z = (data8_y == 8'h00);
          `cc_v = sub_vout8(data8_y, data8_a, data8_b);
          `cc_c = cout;
          `b = data8_y;
        end

        ///////////////////////////////////////////// CMPB
        8'hC1, // CMPB (imm)
        8'hD1, // CMPB (dir)
        8'hE1, // CMPB (idx)
        8'hF1: // CMPB (ext)
        begin 
          bus_cycles = 4; // dir
          load_op8(`ea,data8_b,bus_cycles);
          data8_a = `b;
          {cout, data8_y} = {1'b0, data8_a} - {1'b0, data8_b};
          //`cc_h = 1'b0; // INFO: Undefined (Turbo9: Not affected)
          `cc_n = data8_y[7];
          `cc_z = (data8_y == 8'h00);
          `cc_v = sub_vout8(data8_y, data8_a, data8_b);
          `cc_c = cout;
        end

        ///////////////////////////////////////////// SBCB
        8'hC2, // SBCB (imm)
        8'hD2, // SBCB (dir)
        8'hE2, // SBCB (idx)
        8'hF2: // SBCB (ext)
        begin 
          bus_cycles = 4; // dir
          load_op8(`ea,data8_b,bus_cycles);
          data8_a = `b;
          cin = `cc_c;
          {cout, data8_y} = {1'b0, data8_a} - {1'b0, data8_b} - {8'h00, cin};
          //`cc_h = 1'b0; // INFO: Undefined (Turbo9: Not affected)
          `cc_n = data8_y[7];
          `cc_z = (data8_y == 8'h00);
          `cc_v = sub_vout8(data8_y, data8_a, data8_b);
          `cc_c = cout;
          `b = data8_y;
        end

        ///////////////////////////////////////////// ADDD
        8'hC3, // ADDD (imm)
        8'hD3, // ADDD (dir)
        8'hE3, // ADDD (idx)
        8'hF3: // ADDD (ext)
        begin 
          bus_cycles = 6; // dir
          load_op16(`ea,data16_b,bus_cycles);
          data16_a = `d;
          {cout, data16_y} = {1'b0, data16_a} + {1'b0, data16_b};
          //`cc_h = 1'b0; // Not affected
          `cc_n = data16_y[15];
          `cc_z = (data16_y == 16'h00);
          `cc_v = add_vout16(data16_y, data16_a, data16_b);
          `cc_c = cout;
          `d = data16_y;
        end

        ///////////////////////////////////////////// ANDB
        8'hC4, // ANDB (imm)
        8'hD4, // ANDB (dir)
        8'hE4, // ANDB (idx)
        8'hF4: // ANDB (ext)
        begin 
          bus_cycles = 4; // dir
          load_op8(`ea,data8_b,bus_cycles);
          data8_a = `b;
          data8_y = data8_a & data8_b;
          //`cc_h = 1'b0; // Not affected
          `cc_n = data8_y[7];
          `cc_z = (data8_y == 8'h00);
          `cc_v = 1'b0;
          //`cc_c = 1'b0; // Not affected
          `b = data8_y;
        end

        ///////////////////////////////////////////// BITB
        8'hC5, // BITB (imm)
        8'hD5, // BITB (dir)
        8'hE5, // BITB (idx)
        8'hF5: // BITB (ext)
        begin 
          bus_cycles = 4; // dir
          load_op8(`ea,data8_b,bus_cycles);
          data8_a = `b;
          data8_y = data8_a & data8_b;
          //`cc_h = 1'b0; // Not affected
          `cc_n = data8_y[7];
          `cc_z = (data8_y == 8'h00);
          `cc_v = 1'b0;
          //`cc_c = 1'b0; // Not affected
        end

        ///////////////////////////////////////////// LDB
        8'hC6, // LDB (imm)
        8'hD6, // LDB (dir)
        8'hE6, // LDB (idx)
        8'hF6: // LDB (ext)
        begin 
          bus_cycles = 4; // dir
          load_op8(`ea,data8_y,bus_cycles);
          //`cc_h = 1'b0; // Not affected
          `cc_n = data8_y[7];
          `cc_z = (data8_y == 8'h00);
          `cc_v = 1'b0;
          //`cc_c = 1'b0; // Not affected
          `b = data8_y;
        end

        ///////////////////////////////////////////// STB
        8'hD7, // STB (dir)
        8'hE7, // STB (idx)
        8'hF7: // STB (ext)
        begin 
          bus_cycles = 4; // dir
          calc_ea8(`ea, bus_cycles);
          data8_y = `b;
          //`cc_h = 1'b0; // Not affected
          `cc_n = data8_y[7];
          `cc_z = (data8_y == 8'h00);
          `cc_v = 1'b0;
          //`cc_c = 1'b0; // Not affected
          write_mem8(`ea, data8_y);
        end

        ///////////////////////////////////////////// EORB
        8'hC8, // EORB (imm)
        8'hD8, // EORB (dir)
        8'hE8, // EORB (idx)
        8'hF8: // EORB (ext)
        begin 
          bus_cycles = 4; // dir
          load_op8(`ea,data8_b,bus_cycles);
          data8_a = `b;
          data8_y = data8_a ^ data8_b;
          //`cc_h = 1'b0; // Not affected
          `cc_n = data8_y[7];
          `cc_z = (data8_y == 8'h00);
          `cc_v = 1'b0;
          //`cc_c = 1'b0; // Not affected
          `b = data8_y;
        end

        ///////////////////////////////////////////// ADCB
        8'hC9, // ADCB (imm)
        8'hD9, // ADCB (dir)
        8'hE9, // ADCB (idx)
        8'hF9: // ADCB (ext)
        begin 
          bus_cycles = 4; // dir
          load_op8(`ea,data8_b,bus_cycles);
          data8_a = `b;
          cin = `cc_c;
          {hout, data8_y[3:0]} = {1'b0, data8_a[3:0]} + {1'b0, data8_b[3:0]} + {4'h0, cin};
          {cout, data8_y} = {1'b0, data8_a} + {1'b0, data8_b} + {8'h00, cin};
          `cc_h = hout;
          `cc_n = data8_y[7];
          `cc_z = (data8_y == 8'h00);
          `cc_v = add_vout8(data8_y, data8_a, data8_b);
          `cc_c = cout;
          `b = data8_y;
        end

        ///////////////////////////////////////////// ORB
        8'hCA, // ORB (imm)
        8'hDA, // ORB (dir)
        8'hEA, // ORB (idx)
        8'hFA: // ORB (ext)
        begin
          bus_cycles = 4; // dir
          load_op8(`ea,data8_b,bus_cycles);
          data8_a = `b;
          data8_y = data8_a | data8_b;
          //`cc_h = 1'b0; // Not affected
          `cc_n = data8_y[7];
          `cc_z = (data8_y == 8'h00);
          `cc_v = 1'b0;
          //`cc_c = 1'b0; // Not affected
          `b = data8_y;
        end

        ///////////////////////////////////////////// ADDB
        8'hCB, // ADDB (imm)
        8'hDB, // ADDB (dir)
        8'hEB, // ADDB (idx)
        8'hFB: // ADDB (ext)
        begin 
          bus_cycles = 4; // dir
          load_op8(`ea,data8_b,bus_cycles);
          data8_a = `b;
          {hout, data8_y[3:0]} = {1'b0, data8_a[3:0]} + {1'b0, data8_b[3:0]};
          {cout, data8_y} = {1'b0, data8_a} + {1'b0, data8_b};
          `cc_h = hout;
          `cc_n = data8_y[7];
          `cc_z = (data8_y == 8'h00);
          `cc_v = add_vout8(data8_y, data8_a, data8_b);
          `cc_c = cout;
          `b = data8_y;
        end

        ///////////////////////////////////////////// LDD
        8'hCC, // LDD (imm)
        8'hDC, // LDD (dir)
        8'hEC, // LDD (idx)
        8'hFC: // LDD (ext)
        begin 
          bus_cycles = 5; // dir
          load_op16(`ea,data16_y,bus_cycles);
          //`cc_h = 1'b0; // Not affected
          `cc_n = data16_y[15];
          `cc_z = (data16_y == 16'h00);
          `cc_v = 1'b0;
          // `cc_c = 1'b0; // Not affected
          `d = data16_y;
        end

        ///////////////////////////////////////////// STD
        8'hDD, // STD (dir)
        8'hED, // STD (idx)
        8'hFD: // STD (ext)
        begin 
          bus_cycles = 5; // dir
          calc_ea16(`ea, bus_cycles);
          data16_y = `d;
          //`cc_h = 1'b0; // Not affected
          `cc_n = data16_y[15];
          `cc_z = (data16_y == 16'h00);
          `cc_v = 1'b0;
          //`cc_c = 1'b0; // Not affected
          write_mem16(`ea, data16_y);
        end

        ///////////////////////////////////////////// LDU
        8'hCE, // LDU (imm)
        8'hDE, // LDU (dir)
        8'hEE, // LDU (idx)
        8'hFE: // LDU (ext)
        begin 
          bus_cycles = 5; // dir
          load_op16(`ea,data16_y,bus_cycles);
          //`cc_h = 1'b0; // Not affected
          `cc_n = data16_y[15];
          `cc_z = (data16_y == 16'h00);
          `cc_v = 1'b0;
          // `cc_c = 1'b0; // Not affected
          `u = data16_y;
        end

        ///////////////////////////////////////////// STU
        8'hDF, // STU (dir)
        8'hEF, // STU (idx)
        8'hFF: // STU (ext)
        begin 
          bus_cycles = 5; // dir
          calc_ea16(`ea, bus_cycles);
          data16_y = `u;
          //`cc_h = 1'b0; // Not affected
          `cc_n = data16_y[15];
          `cc_z = (data16_y == 16'h00);
          `cc_v = 1'b0;
          //`cc_c = 1'b0; // Not affected
          write_mem16(`ea, data16_y);
        end

        default : begin // Unimplemented Opcode
          $display("[TB: tb_dv_6809_model] ERROR: Unimplemented opcode!");
          hasta_la_vista_baby;
        end
        
      endcase
      
      if (bus_cycles) begin
        e_clock_cycles(bus_cycles);
      end else begin
        $display("[TB: tb_dv_6809_model] ERROR: Bus cycles not set!");
        hasta_la_vista_baby;
      end

    end

  end
  endtask

  ////////////////////////////////////////////////////////////////////////////
  // Read Memory (8-bit)
  ////////////////////////////////////////////////////////////////////////////
  function reg [7:0] read_mem8(input [15:0] addr);
  begin
    if (addr == 16'h0000) begin
      read_mem8 = output_port;
    end else if (addr == 16'h0004) begin
      read_mem8 = cycle_cnt[31:24];
    end else if (addr == 16'h0005) begin
      read_mem8 = cycle_cnt[23:16];
    end else if (addr == 16'h0006) begin
      read_mem8 = cycle_cnt[15: 8];
    end else if (addr == 16'h0007) begin
      read_mem8 = cycle_cnt[ 7: 0];
    end else if (addr[15:MEM_ADDR_WIDTH] == {(16-MEM_ADDR_WIDTH){1'b1}}) begin // Place Memory at the end of the memory map
      read_mem8 = `memory[addr[(MEM_ADDR_WIDTH-1):0]];
    end else begin
      read_mem8 = 8'h00;
    end
  end
  endfunction

  ////////////////////////////////////////////////////////////////////////////
  // Read Memory (16-bit)
  ////////////////////////////////////////////////////////////////////////////
  function reg [15:0] read_mem16(input [15:0] addr);
    reg [15:0] addr_inc;
  begin
    addr_inc = addr + 'h1;
    read_mem16 = {read_mem8(addr), read_mem8(addr_inc)};
  end
  endfunction

  ////////////////////////////////////////////////////////////////////////////
  // Write Memory (8-bit)
  ////////////////////////////////////////////////////////////////////////////
  task write_mem8(input [15:0] addr, input [7:0] data);
  begin
    if (addr == 16'h0000) begin
      output_port = data;
    end else if (addr[15:MEM_ADDR_WIDTH] == {(16-MEM_ADDR_WIDTH){1'b1}}) begin // Place Memory at the end of the memory map
      `memory[addr[(MEM_ADDR_WIDTH-1):0]] = data;
    end
  end
  endtask

  ////////////////////////////////////////////////////////////////////////////
  // Write Memory (16-bit)
  ////////////////////////////////////////////////////////////////////////////
  task write_mem16(input [15:0] addr, input [15:0] data);
    reg [15:0] addr_inc;
  begin
    addr_inc = addr + 'h1;
    write_mem8(addr,data[15:8]);
    write_mem8(addr_inc,data[7:0]);
  end
  endtask

  ////////////////////////////////////////////////////////////////////////////
  // Run E clock
  ////////////////////////////////////////////////////////////////////////////
  task e_clock_cycles(input integer cycles);
    integer i;
  begin
    for (i=0; i<cycles; i=i+1) begin
      @ (negedge `e_clk);
    end
  end
  endtask

  ////////////////////////////////////////////////////////////////////////////
  // Report & Terminate
  ////////////////////////////////////////////////////////////////////////////
  task hasta_la_vista_baby;
    reg [15:0] addr;
  begin
    $write  ("[TB: tb_dv_6809_model] ERROR: Terminating simulation @ opcode 0x");
    if (`prebyte == 8'hxx) begin
      addr = `pc - 16'd1;
    end else begin
      addr = `pc - 16'd2;
      $write("%2x", `prebyte);
    end
    $display("%2x at address 0x%4x", `opcode, addr);
    $display("[TB: tb_dv_6809_model] ERROR: \"Hasta la vista, baby...\"\n");
    `error = 1'b1;
  end
  endtask

  ////////////////////////////////////////////////////////////////////////////
  // Read 6809 Register
  ////////////////////////////////////////////////////////////////////////////
  function reg [15:0] read_reg(input [3:0] idx);
  begin
    case (idx)
      4'b0000 : read_reg = `d;            // A:B 
      4'b0001 : read_reg = `x;            // X
      4'b0010 : read_reg = `y;            // Y
      4'b0011 : read_reg = `u;            // U
      4'b0100 : read_reg = `s;            // S
      4'b0101 : read_reg = `pc;           // PC
      4'b0110 : read_reg = 16'h0000;      // Undefined
      4'b0111 : read_reg = 16'h0000;      // Undefined
      4'b1000 : read_reg = {8'h00, `a };  // A
      4'b1001 : read_reg = {8'h00, `b };  // B
      4'b1010 : read_reg = {8'h00, `cc};  // CCR
      4'b1011 : read_reg = {8'h00, `dp};  // DPR
      4'b1100 : read_reg = 16'h0000;      // Undefined
      4'b1101 : read_reg = 16'h0000;      // Undefined
      4'b1110 : read_reg = 16'h0000;      // Undefined
      default : read_reg = 16'h0000;      // Undefined
    endcase
  end
  endfunction

  ////////////////////////////////////////////////////////////////////////////
  // Write 6809 Register
  ////////////////////////////////////////////////////////////////////////////
  task write_reg(input [3:0] idx, input [15:0] data16);
    reg [15:0] tmp;
  begin
    case (idx)
      4'b0000 : `d               = data16; // A:B 
      4'b0001 : `x               = data16; // X
      4'b0010 : `y               = data16; // Y
      4'b0011 : `u               = data16; // U
      4'b0100 : `s               = data16; // S
      4'b0101 : `pc              = data16; // PC
      4'b0110 : tmp              = data16; // Undefined
      4'b0111 : tmp              = data16; // Undefined
      4'b1000 : {tmp[15:8], `a } = data16; // A
      4'b1001 : {tmp[15:8], `b } = data16; // B
      4'b1010 : {tmp[15:8], `cc} = data16; // CCR
      4'b1011 : {tmp[15:8], `dp} = data16; // DPR
      4'b1100 : tmp              = data16; // Undefined
      4'b1101 : tmp              = data16; // Undefined
      4'b1110 : tmp              = data16; // Undefined
      default : tmp              = data16; // Undefined
    endcase
  end
  endtask

  ////////////////////////////////////////////////////////////////////////////
  // Evaluate Branch
  ////////////////////////////////////////////////////////////////////////////
  function reg eval_branch(input [3:0] tmp);
  begin
    case (tmp)
      4'h0    : eval_branch = 1'b1;                       // BRA
      4'h1    : eval_branch = 1'b0;                       // BRN
      4'h2    : eval_branch = ~(`cc_c | `cc_z);           // BHI 
      4'h3    : eval_branch =  (`cc_c | `cc_z);           // BLS
      4'h4    : eval_branch = ~`cc_c;                     // BCC
      4'h5    : eval_branch =  `cc_c;                     // BCS
      4'h6    : eval_branch = ~`cc_z;                     // BNE
      4'h7    : eval_branch =  `cc_z;                     // BEQ
      4'h8    : eval_branch = ~`cc_v;                     // BVC
      4'h9    : eval_branch =  `cc_v;                     // BVS
      4'hA    : eval_branch = ~`cc_n;                     // BPL
      4'hB    : eval_branch =  `cc_n;                     // BMI
      4'hC    : eval_branch = ~(`cc_n ^ `cc_v);           // BGE
      4'hD    : eval_branch =  (`cc_n ^ `cc_v);           // BLT
      4'hE    : eval_branch = ~(`cc_z | (`cc_n ^ `cc_v)); // BGT
      default : eval_branch =  (`cc_z | (`cc_n ^ `cc_v)); // BLE
    endcase
  end
  endfunction

  ////////////////////////////////////////////////////////////////////////////
  // Push Regs
  ////////////////////////////////////////////////////////////////////////////
  task push_regs(input [7:0] mask, input [15:0] push_ptr, input [15:0] save_ptr, output [15:0] push_ptr_update, output integer cycles);
    reg [15:0] ptr;
  begin
    ptr = push_ptr;
    cycles = 0;
    
    if (mask[7]) begin
      write_mem8(--ptr, `pc[ 7:0]);
      write_mem8(--ptr, `pc[15:8]);
      cycles += 2;
    end
    if (mask[6]) begin
      write_mem8(--ptr, save_ptr[ 7:0]);
      write_mem8(--ptr, save_ptr[15:8]);
      cycles += 2;
    end
    if (mask[5]) begin
      write_mem8(--ptr, `y[ 7:0]);
      write_mem8(--ptr, `y[15:8]);
      cycles += 2;
    end
    if (mask[4]) begin
      write_mem8(--ptr, `x[ 7:0]);
      write_mem8(--ptr, `x[15:8]);
      cycles += 2;
    end
    if (mask[3]) begin
      write_mem8(--ptr, `dp);
      cycles++;
    end
    if (mask[2]) begin
      write_mem8(--ptr, `b);
      cycles++;
    end
    if (mask[1]) begin
      write_mem8(--ptr, `a);
      cycles++;
    end
    if (mask[0]) begin
      write_mem8(--ptr, `cc);
      cycles++;
    end

    push_ptr_update = ptr;
  end
  endtask
 
  ////////////////////////////////////////////////////////////////////////////
  // Pull Regs
  ////////////////////////////////////////////////////////////////////////////
  task pull_regs(input [7:0] mask, input [15:0] pull_ptr, output [15:0] restore_ptr, output [15:0] pull_ptr_update, output integer cycles);
    reg [15:0] ptr;
  begin
    ptr = pull_ptr;
    cycles = 0;

    if (mask[0]) begin
      `cc = read_mem8(ptr++);
      cycles++;
    end
    if (mask[1]) begin
      `a = read_mem8(ptr++);
      cycles++;
    end
    if (mask[2]) begin
      `b = read_mem8(ptr++);
      cycles++;
    end
    if (mask[3]) begin
      `dp = read_mem8(ptr++);
      cycles++;
    end
    if (mask[4]) begin
      `x[15:8] = read_mem8(ptr++);
      `x[ 7:0] = read_mem8(ptr++);
      cycles += 2;
    end
    if (mask[5]) begin
      `y[15:8] = read_mem8(ptr++);
      `y[ 7:0] = read_mem8(ptr++);
      cycles += 2;
    end
    if (mask[6]) begin
      restore_ptr[15:8] = read_mem8(ptr++);
      restore_ptr[ 7:0] = read_mem8(ptr++);
      cycles += 2;
    end
    if (mask[7]) begin
      `pc[15:8] = read_mem8(ptr++);
      `pc[ 7:0] = read_mem8(ptr++);
      cycles += 2;
    end

    pull_ptr_update = ptr;
  end
  endtask


  ////////////////////////////////////////////////////////////////////////////
  // Memory Modify Load
  ////////////////////////////////////////////////////////////////////////////
  task load_mm(output reg [15:0] ea, output reg [7:0] op8, inout integer cycles);
  begin
    case (`opcode[7:4])
      4'h0    : begin //////////////////////// Direct
        dir_ea(ea, cycles);
        op8 = read_mem8(ea);
      end
      4'h4    : begin //////////////////////// Acc A
        ea = 16'hxxxx;
        op8 = `a;
        cycles -= 4; //(Direct used as base cycle count)
      end
      4'h5    : begin //////////////////////// Acc B
        ea = 16'hxxxx;
        op8 = `b;
        cycles -= 4; //(Direct used as base cycle count)
      end
      4'h6    : begin //////////////////////// Indexed
        idx_ea(ea, cycles);
        op8 = read_mem8(ea);
      end
      default : begin //////////////////////// Extended
        ext_ea(ea, cycles);
        op8 = read_mem8(ea);
      end
    endcase
  end
  endtask

  ////////////////////////////////////////////////////////////////////////////
  // Memory Modify Store
  ////////////////////////////////////////////////////////////////////////////
  task store_mm(input reg [15:0] ea, input reg [7:0] op8);
  begin
    case (`opcode[7:4])
      4'h4    : begin //////////////////////// Acc A
        `a = op8;
      end
      4'h5    : begin //////////////////////// Acc B
        `b = op8;
      end
      default : begin //////////////////////// Direct, Indexed, Extended
        write_mem8(ea, op8);
      end
    endcase
  end
  endtask

  ////////////////////////////////////////////////////////////////////////////
  // Load Operand 8-bit
  ////////////////////////////////////////////////////////////////////////////
  task load_op8(output reg [15:0] ea, output reg [7:0] op8, inout integer cycles);
  begin
    calc_ea8(ea, cycles);
    op8 = read_mem8(ea);
  end
  endtask

  ////////////////////////////////////////////////////////////////////////////
  // Load Operand 16-bit
  ////////////////////////////////////////////////////////////////////////////
  task load_op16(output reg [15:0] ea, output reg [15:0] op16, inout integer cycles);
  begin
    calc_ea16(ea, cycles);
    op16 = read_mem16(ea);
  end
  endtask

  ////////////////////////////////////////////////////////////////////////////
  // Calculate Effective Address 8-bit
  ////////////////////////////////////////////////////////////////////////////
  task calc_ea8(output reg [15:0] ea, inout integer cycles);
  begin
    case (`opcode[7:4])
      4'h8,
      4'hC    : begin //////////////////////// Immediate
        imm8_ea(ea, cycles);
      end
      4'h0,
      4'h9,
      4'hD    : begin //////////////////////// Direct
        dir_ea(ea, cycles);
      end
      4'h6,
      4'hA,
      4'hE    : begin //////////////////////// Indexed
        idx_ea(ea, cycles);
      end
      //4'h7,
      //4'hB,
      //4'hF,
      default : begin //////////////////////// Extended
        ext_ea(ea, cycles);
      end
    endcase
  end
  endtask

  ////////////////////////////////////////////////////////////////////////////
  // Calculate Effective Address 16-bit
  ////////////////////////////////////////////////////////////////////////////
  task calc_ea16(output reg [15:0] ea, inout integer cycles);
  begin
    case (`opcode[7:4])
      4'h8,
      4'hC    : begin //////////////////////// Immediate
        imm16_ea(ea, cycles);
      end
      4'h0,
      4'h9,
      4'hD    : begin //////////////////////// Direct
        dir_ea(ea, cycles);
      end
      4'h6,
      4'hA,
      4'hE    : begin //////////////////////// Indexed
        idx_ea(ea, cycles);
      end
      //4'h7,
      //4'hB,
      //4'hF,
      default : begin //////////////////////// Extended
        ext_ea(ea, cycles);
      end
    endcase
  end
  endtask

  ////////////////////////////////////////////////////////////////////////////
  // Relative 8-bit Effective Address
  ////////////////////////////////////////////////////////////////////////////
  task rel8_ea(output reg [15:0] ea);
    reg [15:0] offset;
  begin
    offset[ 7:0] = read_mem8(`pc++);
    offset[15:8] = {8{offset[7]}};
    ea = `pc + offset;
  end
  endtask

  ////////////////////////////////////////////////////////////////////////////
  // Relative 16-bit Effective Address
  ////////////////////////////////////////////////////////////////////////////
  task rel16_ea(output reg [15:0] ea);
    reg [15:0] offset;
  begin
    offset = read_mem16(`pc);
    `pc += 2;
    ea = `pc + offset;
  end
  endtask

  ////////////////////////////////////////////////////////////////////////////
  // Immediate 8-bit Effective Address
  ////////////////////////////////////////////////////////////////////////////
  task imm8_ea(output reg [15:0] ea, inout integer cycles);
  begin
    ea = `pc++;
    cycles -= 2; //(Direct used as base cycle count)
  end
  endtask

  ////////////////////////////////////////////////////////////////////////////
  // Immediate 16-bit Effective Address
  ////////////////////////////////////////////////////////////////////////////
  task imm16_ea(output reg [15:0] ea, inout integer cycles);
  begin
    ea = `pc;
    `pc += 2;
    cycles -= 2; //(Direct used as base cycle count)
  end
  endtask

  ////////////////////////////////////////////////////////////////////////////
  // Direct Effective Address
  ////////////////////////////////////////////////////////////////////////////
  task dir_ea(output reg [15:0] ea, inout integer cycles);
  begin
    ea[ 7:0] = read_mem8(`pc++);
    ea[15:8] = `dp;
    //cycles += 0; //(Direct used as base cycle count)
  end
  endtask

  ////////////////////////////////////////////////////////////////////////////
  // Extended Effective Address
  ////////////////////////////////////////////////////////////////////////////
  task ext_ea(output reg [15:0] ea, inout integer cycles);
  begin
    ea = read_mem16(`pc);
    `pc += 2;
    cycles += 1; //(Direct used as base cycle count)
  end
  endtask

  ////////////////////////////////////////////////////////////////////////////
  // Indexed Effective Address
  ////////////////////////////////////////////////////////////////////////////
  task idx_ea(output reg [15:0] ea, inout integer cycles);
    reg [ 7:0] postbyte_idx; 
    reg [15:0] base_reg;
    reg [15:0] offset;
    reg [15:0] idata;
    reg [15:0] temp_ea;
  begin

    //cycles += 0; //(Direct used as base cycle count)

    postbyte_idx = read_mem8(`pc++);

    // Decode Offset
    if (postbyte_idx[7] == 1'b1) begin
      case (postbyte_idx[3:0])
        //
        4'b0000 : begin //////////////////////////// Post Inc 1
          offset = 16'h0001; // pos1
          cycles += 2;
        end
        //
        4'b0001 : begin //////////////////////////// Post Inc 2
          offset = 16'h0002; // pos2
          cycles += 3;
        end
        //
        4'b0010 : begin //////////////////////////// Pre Dec 1
          offset = 16'hFFFF; // neg1
          cycles += 2;
        end
        //
        4'b0011 : begin //////////////////////////// Pre Dec 2
          offset = 16'hFFFE; // neg2
          cycles += 3;
        end
        //
        4'b0100 : begin //////////////////////////// No Offset
          offset = 16'h0000; // zero
          //cycles += 0;
        end
        //
        4'b0101 : begin //////////////////////////// Acc Offset B
          offset[7:0] = `b;
          offset[15:8] = {8{offset[7]}}; // 8-bit (signed)
          cycles += 1;
        end
        //
        4'b0110 : begin //////////////////////////// Acc Offset A
          offset[7:0] = `a;
          offset[15:8] = {8{offset[7]}}; // 8-bit (signed)
          cycles += 1;
        end
        //
        4'b0111 : begin //////////////////////////// Acc Offset D (Undefined)
          offset = `d;
          cycles += 4;
        end
        //
        4'b1000 : begin //////////////////////////// 8-bit Offset
          offset[7:0] = read_mem8(`pc++);
          offset[15:8] = {8{offset[7]}}; // 8-bit (signed)
          cycles += 1;
        end
        //
        4'b1001 : begin //////////////////////////// 16-bit Offset
          offset = read_mem16(`pc); // 16 bit (signed)
          `pc += 2;
          cycles += 4;
        end
        //
        4'b1010 : begin //////////////////////////// Acc Offset D (Undefined)
          offset = `d;
          cycles += 4;
        end
        //
        4'b1011 : begin //////////////////////////// Acc Offset D
          offset = `d;
          cycles += 4;
        end
        //
        4'b1100 : begin //////////////////////////// 8-bit Offset PC
          offset[7:0] = read_mem8(`pc++);
          offset[15:8] = {8{offset[7]}}; // 8-bit (signed)
          cycles += 1;
        end
        //
        4'b1101 : begin //////////////////////////// 16-bit Offset PC
          offset = read_mem16(`pc); // 16 bit (signed)
          `pc += 2;
          cycles += 5;
        end
        //
        4'b1110 : begin //////////////////////////// 8-bit (Undefined)
          offset[7:0] = read_mem8(`pc++);
          offset[15:8] = {8{offset[7]}}; // 8-bit (signed)
          cycles += 1;
        end
        //
        default : begin // 4'b1111 ///////////////// 16-bit (Undefined)
          offset = read_mem16(`pc); // 16 bit (signed)
          `pc += 2;
          cycles += 2;
        end
      endcase
    end else begin /////////////////// 5 bit (signed)
      offset[4:0] = postbyte_idx[4:0];
      offset[15:5] = {11{offset[4]}}; // 5-bit (signed)
      cycles += 1;
    end

    // Decode Base Reg
    if ((postbyte_idx[7] == 1'b1) && (postbyte_idx[3:2] == 2'b11)) begin
      case (postbyte_idx[1])
        1'b0    : base_reg = `pc;
        default : base_reg = 16'h0000; // 1'b1
      endcase
    end else begin
      case (postbyte_idx[6:5])
        2'b00   : base_reg = `x;
        2'b01   : base_reg = `y;
        2'b10   : base_reg = `u;
        default : base_reg = `s; // 2'b11
      endcase
    end

    // Calculate EA and Pre/Post Base Reg
    if ((postbyte_idx[7] == 1'b1) && (postbyte_idx[3:2] == 2'b00)) begin
      //
      // Update Reg, Pre or Post
      case (postbyte_idx[6:5])
        2'b00   : `x = base_reg + offset;
        2'b01   : `y = base_reg + offset;
        2'b10   : `u = base_reg + offset;
        default : `s = base_reg + offset; // 2'b11
      endcase
      //
      case (postbyte_idx[1])
        1'b0    : temp_ea = base_reg; // POST
        default : temp_ea = base_reg + offset; // PRE 1'b1
      endcase
    end else begin
      temp_ea = base_reg + offset;
    end

    // Indexed Indirect
    if ((postbyte_idx[7] == 1'b1) &&  (postbyte_idx[4] == 1'b1)) begin
      ea = read_mem16(temp_ea);
      cycles += 3;
    end else begin
      ea = temp_ea;
    end
  end
  endtask


  ////////////////////////////////////////////////////////////////////////////
  // Subraction 2's Comp Overflow 8-bit
  ////////////////////////////////////////////////////////////////////////////
  function reg sub_vout8(input reg [7:0] d8_y, input reg [7:0] d8_a, input reg [7:0] d8_b);
  begin
    sub_vout8 = ((~d8_y[7]) & ( d8_a[7]) & (~d8_b[7])) |
                (( d8_y[7]) & (~d8_a[7]) & ( d8_b[7])) ;
  end
  endfunction

  ////////////////////////////////////////////////////////////////////////////
  // Addition 2's Comp Overflow 8-bit
  ////////////////////////////////////////////////////////////////////////////
  function reg add_vout8(input reg [7:0] d8_y, input reg [7:0] d8_a, input reg [7:0] d8_b);
  begin
    add_vout8 = ((~d8_y[7]) & ( d8_a[7]) & ( d8_b[7])) |
                (( d8_y[7]) & (~d8_a[7]) & (~d8_b[7])) ;
  end
  endfunction

  ////////////////////////////////////////////////////////////////////////////
  // Subraction 2's Comp Overflow 16-bit
  ////////////////////////////////////////////////////////////////////////////
  function reg sub_vout16(input reg [15:0] d16_y, input reg [15:0] d16_a, input reg [15:0] d16_b);
  begin
    sub_vout16 = ((~d16_y[15]) & ( d16_a[15]) & (~d16_b[15])) |
                 (( d16_y[15]) & (~d16_a[15]) & ( d16_b[15])) ;
  end
  endfunction

  ////////////////////////////////////////////////////////////////////////////
  // Addition 2's Comp Overflow 16-bit
  ////////////////////////////////////////////////////////////////////////////
  function reg add_vout16(input reg [15:0] d16_y, input reg [15:0] d16_a, input reg [15:0] d16_b);
  begin
    add_vout16 = ((~d16_y[15]) & ( d16_a[15]) & ( d16_b[15])) |
                 (( d16_y[15]) & (~d16_a[15]) & (~d16_b[15])) ;
  end
  endfunction

  ////////////////////////////////////////////////////////////////////////////
  // Clock Counter
  ////////////////////////////////////////////////////////////////////////////
  always @(negedge `e_clk)
  begin
    if (output_port == 8'h00) begin
      cycle_cnt <= 0;
    end else if ((output_port[6] == 1'b0) && (output_port[1] == 1'b1)) begin
      cycle_cnt <= cycle_cnt + 1;
    end
  end

  ////////////////////////////////////////////////////////////////////////////
  // Outputs
  ////////////////////////////////////////////////////////////////////////////
  assign        E_CLK_O       = `e_clk;
  assign        Q_CLK_O       = `q_clk;
  assign        ERROR_O       = `error;
  assign        OUTPUT_PORT_O = output_port;
  assign        CYCLE_CNT_O   = cycle_cnt;

endmodule

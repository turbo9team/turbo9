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
// Description: Transmit section of 6551 compatible UART
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
module t6551_tx
(
  // Inputs: Clock & Reset
  input         RST_I,
  input         CLK_I,

  // Inputs
  input         BAUD_DIV_EN_I,
  input [ 7:0]  TX_DATA_I,
  input         TX_DATA_REG_WR_EN_I,

  // Outputs
  output        TXD_PIN_O,
  output        TX_DATA_REG_EMPTY_O
);


/////////////////////////////////////////////////////////////////////////////
//                             INTERNAL SIGNALS
/////////////////////////////////////////////////////////////////////////////
reg         clk_cnt_load;
reg         clk_cnt_dec;
wire        clk_cnt_zero;
reg [ 3:0]  clk_cnt_reg;
localparam  clk_cnt_rst = 4'hF;

reg         bit_cnt_load;
reg         bit_cnt_dec;
wire        bit_cnt_zero;
reg [ 3:0]  bit_cnt_reg;
localparam  bit_cnt_rst = 4'h0;

reg         tx_shifter_set;
reg         tx_shifter_load;
reg         tx_shifter_en;
reg [ 9:0]  tx_shifter_reg;
localparam  tx_shifter_rst = 10'h3FF;

reg         tx_data_reg_load;
reg         tx_data_reg_empty_reg;
localparam  tx_data_reg_empty_rst = 1'b1;

reg [ 7:0]  tx_data_reg;
localparam  tx_data_rst = 8'h00;

reg         tx_state_nxt;
reg         tx_state_reg;
localparam  TX_IDLE       = 1'b0;
localparam  TX_SHIFT_OUT  = 1'b1;

/////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////
//                            NEXT STATE LOGIC
/////////////////////////////////////////////////////////////////////////////
//

assign clk_cnt_zero = (clk_cnt_reg == 4'h0); 
assign bit_cnt_zero = (bit_cnt_reg == 4'h0); 

always @* begin

  // Defaults
  clk_cnt_load      = 1'b0;
  clk_cnt_dec       = 1'b0;
  bit_cnt_load      = 1'b0;
  bit_cnt_dec       = 1'b0;
  tx_shifter_set    = 1'b0;
  tx_shifter_load   = 1'b0;
  tx_shifter_en     = 1'b0;
  tx_data_reg_load  = 1'b0;
  tx_state_nxt      = TX_IDLE;

  case (tx_state_reg)
    //
    TX_IDLE : begin
      clk_cnt_load  = 1'b1;
      bit_cnt_load  = 1'b1;
      if (tx_data_reg_empty_reg == 1'b0) begin
        tx_shifter_load  = 1'b1;
        tx_state_nxt     = TX_SHIFT_OUT;
      end else begin    
        tx_shifter_set   = 1'b1;
        tx_state_nxt     = TX_IDLE;
      end
    end
    //
    default : begin // TX_SHIFT_OUT
      if (clk_cnt_zero) begin
        clk_cnt_load  = 1'b1;
        if (bit_cnt_zero) begin
          bit_cnt_load  = 1'b1;
          if (tx_data_reg_empty_reg == 1'b0) begin
            tx_shifter_load  = 1'b1;
            tx_state_nxt     = TX_SHIFT_OUT;
          end else begin    
            tx_shifter_set   = 1'b1;
            tx_state_nxt     = TX_IDLE;
          end
        end else begin
          tx_shifter_en = 1'b1;
          bit_cnt_dec   = 1'b1;
          tx_state_nxt  = TX_SHIFT_OUT;
        end
      end else begin
        clk_cnt_dec   = 1'b1;
        tx_state_nxt  = TX_SHIFT_OUT;
      end
    end
    //
  endcase
end
//
/////////////////////////////////////////////////////////////////////////////



/////////////////////////////////////////////////////////////////////////////
//                           REGISTERS
/////////////////////////////////////////////////////////////////////////////
//
always @(posedge CLK_I, posedge RST_I) begin
  if (RST_I) begin
    clk_cnt_reg           <= clk_cnt_rst;
    bit_cnt_reg           <= bit_cnt_rst;
    tx_shifter_reg        <= tx_shifter_rst;
    tx_data_reg_empty_reg <= tx_data_reg_empty_rst;
    tx_data_reg           <= tx_data_rst;
    tx_state_reg          <= TX_IDLE;
  end else begin
    
    if (BAUD_DIV_EN_I) begin
      //
      // State Register
      tx_state_reg <= tx_state_nxt;
      //
      // Clock Per Bit Counter
      if (clk_cnt_load) begin
        clk_cnt_reg <= clk_cnt_rst;
      end else if (clk_cnt_dec) begin
        clk_cnt_reg <= clk_cnt_reg - 4'd1;
      end
      //
      // Bit Counter
      if (bit_cnt_load) begin
        bit_cnt_reg <= 4'd9;
      end else if (bit_cnt_dec) begin
        bit_cnt_reg <= bit_cnt_reg - 3'd1;
      end
      //
      // Receive Shift Register
      if (tx_shifter_set) begin
        tx_shifter_reg <= tx_shifter_rst;
      end else if (tx_shifter_load) begin
        tx_shifter_reg <= {1'b1, tx_data_reg, 1'b0};
      end else if (tx_shifter_en) begin
        tx_shifter_reg <= {1'b1, tx_shifter_reg[9:1]};
      end
    end
    
    // Transmit Data Register
    if (TX_DATA_REG_WR_EN_I) begin
      tx_data_reg           <= TX_DATA_I;
    end
    if (TX_DATA_REG_WR_EN_I) begin
      tx_data_reg_empty_reg <= 1'b0;
    end else if (tx_shifter_load && BAUD_DIV_EN_I) begin
      tx_data_reg_empty_reg <= 1'b1;
    end
    
  end
end
//
/////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////
//                             ASSIGN OUTPUTS
/////////////////////////////////////////////////////////////////////////////
//
assign TXD_PIN_O            = tx_shifter_reg[0];
assign TX_DATA_REG_EMPTY_O  = tx_data_reg_empty_reg;
//
/////////////////////////////////////////////////////////////////////////////

endmodule


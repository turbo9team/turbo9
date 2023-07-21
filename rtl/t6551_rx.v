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
// Description: Receive module for 6551 compatiable UART
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
module t6551_rx
(
  // Inputs: Clock & Reset
  input         RST_I,
  input         CLK_I,

  // Inputs
  input         PROG_RST_I,
  input         RXD_PIN_I,
  input         BAUD_DIV_EN_I,
  input         RX_DATA_REG_RD_EN_I,

  // Outputs
  output        RX_OVERRUN_O,
  output        RX_FRAMING_ERROR_O,
  output        RX_DATA_REG_FULL_O,
  output [ 7:0] RX_DATA_REG_O
);


/////////////////////////////////////////////////////////////////////////////
//                             INTERNAL SIGNALS
/////////////////////////////////////////////////////////////////////////////

reg         rxd_meta_reg;
localparam  rxd_meta_rst = 1'b0;

reg         rxd_sync_reg;
localparam  rxd_sync_rst = 1'b0;

reg         clk_cnt_load;
reg         clk_cnt_half_load;
reg         clk_cnt_dec;
wire        clk_cnt_zero;
reg [ 3:0]  clk_cnt_reg;
localparam  clk_cnt_rst = 4'hF;

reg         bit_cnt_load;
reg         bit_cnt_dec;
wire        bit_cnt_zero;
reg [ 2:0]  bit_cnt_reg;
localparam  bit_cnt_rst = 3'h0;

reg         rx_shift_en;
reg [ 7:0]  rx_shift_reg;
localparam  rx_shift_rst = 8'h00;

reg         rx_data_reg_load;
reg         rx_data_reg_full_reg;
localparam  rx_data_reg_full_rst = 1'b0;

reg [ 7:0]  rx_data_reg;
localparam  rx_data_rst = 8'h00;

reg         rx_overrun_reg;
localparam  rx_overrun_rst = 1'b0;

reg         rx_framing_error_reg;
localparam  rx_framing_error_rst = 1'b0;

reg [ 1:0]  rx_state_nxt;
reg [ 1:0]  rx_state_reg;
localparam  RX_IDLE       = 2'b00;
localparam  RX_START_BIT  = 2'b01;
localparam  RX_SHIFT_IN   = 2'b10;
localparam  RX_STOP_BIT   = 2'b11;

/////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////
//                            NEXT STATE LOGIC
/////////////////////////////////////////////////////////////////////////////
//

assign clk_cnt_zero = (clk_cnt_reg == 4'h0); 
assign bit_cnt_zero = (bit_cnt_reg == 3'h0); 

always @* begin

  // Defaults
  clk_cnt_load      = 1'b0;
  clk_cnt_half_load = 1'b0;
  clk_cnt_dec       = 1'b0;
  bit_cnt_load      = 1'b0;
  bit_cnt_dec       = 1'b0;
  rx_shift_en       = 1'b0;
  rx_data_reg_load  = 1'b0;
  rx_state_nxt      = RX_IDLE;

  case (rx_state_reg)
    //
    RX_IDLE : begin
      clk_cnt_half_load = 1'b1;
      if (rxd_sync_reg == 1'b0) begin
        rx_state_nxt  = RX_START_BIT;
      end else begin
        rx_state_nxt      = RX_IDLE;
      end
    end
    //
    RX_START_BIT : begin
      bit_cnt_load  = 1'b1;
      if (rxd_sync_reg == 1'b1) begin
        rx_state_nxt  = RX_IDLE;
      end else if (clk_cnt_zero) begin
        clk_cnt_load  = 1'b1;
        rx_state_nxt  = RX_SHIFT_IN;
      end else begin
        clk_cnt_dec   = 1'b1;
        rx_state_nxt  = RX_START_BIT;
      end
    end
    //
    RX_SHIFT_IN : begin
      if (clk_cnt_zero) begin
        clk_cnt_load  = 1'b1;
        bit_cnt_dec   = 1'b1;
        rx_shift_en   = 1'b1;
        if (bit_cnt_zero) begin
          rx_state_nxt  = RX_STOP_BIT;
        end else begin
          rx_state_nxt  = RX_SHIFT_IN;
        end
      end else begin
        clk_cnt_dec   = 1'b1;
        rx_state_nxt  = RX_SHIFT_IN;
      end
    end
    //
    default : begin // RX_STOP_BIT
      if (clk_cnt_zero) begin
        clk_cnt_half_load = 1'b1;
        rx_data_reg_load  = 1'b1;
        rx_state_nxt      = RX_IDLE;
      end else begin
        clk_cnt_dec   = 1'b1;
        rx_state_nxt  = RX_STOP_BIT;
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
  //rxd_meta_reg          <= rxd_meta_rst;
  //rxd_sync_reg          <= rxd_sync_rst;
    clk_cnt_reg           <= clk_cnt_rst;
    bit_cnt_reg           <= bit_cnt_rst;
    rx_shift_reg          <= rx_shift_rst;
    rx_data_reg_full_reg  <= rx_data_reg_full_rst;
    rx_data_reg           <= rx_data_rst;
    rx_overrun_reg        <= rx_overrun_rst;
    rx_framing_error_reg  <= rx_framing_error_rst;
    rx_state_reg          <= RX_IDLE;
  end else begin
    
    // RXD Synchronizer
    rxd_meta_reg <= RXD_PIN_I;
    rxd_sync_reg <= rxd_meta_reg;
   

    if (BAUD_DIV_EN_I) begin
      //
      // State Register
      rx_state_reg <= rx_state_nxt;
      //
      // Clock Per Bit Counter
      if (clk_cnt_load) begin
        clk_cnt_reg <= clk_cnt_rst;
      end else if (clk_cnt_half_load) begin
        clk_cnt_reg <= {1'b0, clk_cnt_rst[3:1]};
      end else if (clk_cnt_dec) begin
        clk_cnt_reg <= clk_cnt_reg - 4'd1;
      end
      //
      // Bit Counter
      if (bit_cnt_load) begin
        bit_cnt_reg <= 3'd7;
      end else if (bit_cnt_dec) begin
        bit_cnt_reg <= bit_cnt_reg - 3'd1;
      end
      //
      // Receive Shift Register
      if (rx_shift_en) begin
        rx_shift_reg <= {rxd_sync_reg, rx_shift_reg[7:1]};
      end
    end
    
    // Receive Data Register
    if (BAUD_DIV_EN_I && rx_data_reg_load) begin
      if ((~rx_data_reg_full_reg) || RX_DATA_REG_RD_EN_I) begin
        rx_data_reg <= rx_shift_reg;
      end
    end
    
    // Receive Data Overrun Bit
    if (PROG_RST_I) begin
      rx_overrun_reg        <= rx_overrun_rst;
    end else if (BAUD_DIV_EN_I && rx_data_reg_load) begin
      rx_overrun_reg        <= rx_data_reg_full_reg & ~RX_DATA_REG_RD_EN_I;
    end else if (RX_DATA_REG_RD_EN_I) begin
      rx_overrun_reg        <= 1'b0;
    end
    
    // Receive Data Register Full Bit
    // Framing Error Bit
    if (BAUD_DIV_EN_I && rx_data_reg_load) begin
      rx_data_reg_full_reg  <= 1'b1;
      rx_framing_error_reg  <= ~rxd_sync_reg; // Sample stop bit
    end else if (RX_DATA_REG_RD_EN_I) begin
      rx_data_reg_full_reg  <= 1'b0;
      rx_framing_error_reg  <= 1'b0;
    end
    
  end
end
//
/////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////
//                             ASSIGN OUTPUTS
/////////////////////////////////////////////////////////////////////////////
//
assign RX_OVERRUN_O       = rx_overrun_reg;
assign RX_FRAMING_ERROR_O = rx_framing_error_reg;
assign RX_DATA_REG_FULL_O = rx_data_reg_full_reg;
assign RX_DATA_REG_O      = rx_data_reg;
//
/////////////////////////////////////////////////////////////////////////////

endmodule


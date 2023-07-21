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
// Description: Target independent top level for the Turbo9R
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
module soc_top_r
#(
  parameter MEM_ADDR_WIDTH = 15
)
(
  // Inputs: Clock & Reset
  input          RST_I, // Reset. Active high and synchronized to CLK_I
  input          CLK_I, // Clock

  // Inputs 
  input          RXD_PIN_I,
  
  // Outputs
  output         TXD_PIN_O,
  output   [7:0] OUTPUT_PORT_O
);

/////////////////////////////////////////////////////////////////////////////
//                             INTERNAL SIGNALS
/////////////////////////////////////////////////////////////////////////////

localparam FULL_MEM_ADDR_WIDTH = MEM_ADDR_WIDTH;
localparam EVEN_MEM_ADDR_WIDTH = MEM_ADDR_WIDTH-1;
localparam ODD_MEM_ADDR_WIDTH = MEM_ADDR_WIDTH-1;

wire  [4:0] even_turbo9_tgd_o;
reg   [4:0] even_turbo9_tgd_reg;
localparam  even_turbo9_tgd_rst = 5'b00000;

wire [14:0] even_turbo9_adr;
reg  [14:0] even_turbo9_adr_reg;
localparam  even_turbo9_adr_rst = 15'h0000;

wire [15:0] even_turbo9_adr_full     = {even_turbo9_adr, 1'b0};
wire [15:0] even_turbo9_adr_reg_full = {even_turbo9_adr_reg, 1'b0};

wire  [7:0] even_turbo9_wr_dat;
reg   [7:0] even_turbo9_rd_dat;

wire        even_turbo9_stb;
reg         even_turbo9_ack;
wire        even_turbo9_we;
reg         even_turbo9_we_reg;
localparam  even_turbo9_we_rst = 1'b0;

wire [14:0] odd_turbo9_adr;
reg  [14:0] odd_turbo9_adr_reg;
localparam  odd_turbo9_adr_rst = 15'h0000;

wire [15:0] odd_turbo9_adr_full     = {odd_turbo9_adr, 1'b1};
wire [15:0] odd_turbo9_adr_reg_full = {odd_turbo9_adr_reg, 1'b1};

wire  [7:0] odd_turbo9_wr_dat;
reg   [7:0] odd_turbo9_rd_dat;

wire        odd_turbo9_stb;
reg         odd_turbo9_ack;
wire        odd_turbo9_we;

wire  [7:0] acia_data_rd_dat;  
wire  [7:0] acia_status_rd_dat;

reg  acia_data_wr_en;
reg  acia_data_rd_en;

reg         even_ram_we;
wire  [7:0] even_ram_rd_dat;

reg         odd_ram_we;
wire  [7:0] odd_ram_rd_dat;

reg         port_we;
wire  [7:0] port_rd_dat;

wire [31:0] clk_cnt_rd_dat;

wire        ram_clk;

/////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////
//                                REGISTERS
/////////////////////////////////////////////////////////////////////////////

  // Turbo9R
  turbo9_r
  #(
    .REGISTER_WB_OUTPUTS  (0)
  )
  I_turbo9_r
  (
    // Inputs: Clock & Reset
    .RST_I  (RST_I),
    .CLK_I  (CLK_I),
    //                                 
    // Wishbone Interface (Even bytes)
    .EVEN_TGD_I       (even_turbo9_tgd_reg   ),
    .EVEN_TGD_O       (even_turbo9_tgd_o     ),
    //
    .EVEN_DAT_I       (even_turbo9_rd_dat    ),
    .EVEN_ACK_I       (even_turbo9_ack       ),
    .EVEN_STALL_I     (1'b0                  ),
    .EVEN_ADR_O       (even_turbo9_adr       ),
    .EVEN_DAT_O       (even_turbo9_wr_dat    ),
    .EVEN_WE_O        (even_turbo9_we        ),
    .EVEN_STB_O       (even_turbo9_stb       ),
    .EVEN_CYC_O       (    ),
    //
    // Wishbone Interface (Odd bytes)
    .ODD_DAT_I        (odd_turbo9_rd_dat    ),
    .ODD_ACK_I        (odd_turbo9_ack       ),
    .ODD_STALL_I      (1'b0                 ),
    .ODD_ADR_O        (odd_turbo9_adr       ),
    .ODD_DAT_O        (odd_turbo9_wr_dat    ),
    .ODD_WE_O         (odd_turbo9_we        ), 
    .ODD_STB_O        (odd_turbo9_stb       ),
    .ODD_CYC_O        (    )

  );

  /*
  assign ram_clk = CLK_I;

  // Wishbone Pipeline Registers (Even Bytes)
  always @(posedge CLK_I, posedge RST_I) begin
    if (RST_I) begin
      even_turbo9_adr_reg <= even_turbo9_adr_rst;
      even_turbo9_ack     <= 1'b0;
      even_turbo9_tgd_reg <= even_turbo9_tgd_rst; 
      even_turbo9_we_reg  <= even_turbo9_we_rst; 
    end else begin
      even_turbo9_adr_reg <= even_turbo9_adr;
      even_turbo9_ack     <= even_turbo9_stb;
      even_turbo9_tgd_reg <= even_turbo9_tgd_o;
      even_turbo9_we_reg  <= even_turbo9_we; 
    end
  end

  // Wishbone Pipeline Registers (Odd Bytes)
  always @(posedge CLK_I, posedge RST_I) begin
    if (RST_I) begin
      odd_turbo9_adr_reg <= odd_turbo9_adr_rst;
      odd_turbo9_ack     <= 1'b0;
    end else begin
      odd_turbo9_adr_reg <= odd_turbo9_adr;
      odd_turbo9_ack     <= odd_turbo9_stb;
    end
  end
  */

  assign ram_clk = ~CLK_I;

  always @* begin
    even_turbo9_adr_reg = even_turbo9_adr;
    even_turbo9_ack     = even_turbo9_stb;
    even_turbo9_tgd_reg = even_turbo9_tgd_o;
    even_turbo9_we_reg  = even_turbo9_we; 
    odd_turbo9_adr_reg  = odd_turbo9_adr;
    odd_turbo9_ack      = odd_turbo9_stb;
  end



  // Write Enables (Even Bytes)
  always @* begin
    // Defaults
    even_ram_we = 1'b0;
    port_we = 1'b0;
    acia_data_wr_en = 1'b0;
    //
    // Even Memory Bus Read Data Mux
    if (even_turbo9_adr_full[15:FULL_MEM_ADDR_WIDTH] == {(16-FULL_MEM_ADDR_WIDTH){1'b1}}) begin
      even_ram_we = even_turbo9_we;
    end else begin
      case (even_turbo9_adr_full[3:0])
        //
        4'h2: acia_data_wr_en = even_turbo9_we;
        4'h0: port_we         = even_turbo9_we;
      endcase
    end
  end

  // Write Enables (Odd Bytes)
  always @* begin
    // Defaults
    odd_ram_we = 1'b0;
    //
    // Odd Memory Bus Read Data Mux
    if (odd_turbo9_adr_full[15:FULL_MEM_ADDR_WIDTH] == {(16-FULL_MEM_ADDR_WIDTH){1'b1}}) begin
      odd_ram_we = odd_turbo9_we;
    end
  end
  
  // RAM (Even bytes)
  syncram_8bit
  #(
    .MEM_ADDR_WIDTH (EVEN_MEM_ADDR_WIDTH),
    .MEM_INIT_FILE  ("default_even.hex")
  )
  I_even_syncram_8bit
  (
    .CLK_I  (ram_clk),
    .WE_I   (even_ram_we),
    .ADR_I  (even_turbo9_adr[EVEN_MEM_ADDR_WIDTH-1:0]),
    .DAT_I  (even_turbo9_wr_dat),
    .DAT_O  (even_ram_rd_dat)
  );

  // RAM (Odd bytes)
  syncram_8bit
  #(
    .MEM_ADDR_WIDTH (ODD_MEM_ADDR_WIDTH),
    .MEM_INIT_FILE  ("default_odd.hex")
  )
  I_odd_syncram_8bit
  (
    .CLK_I  (ram_clk),
    .WE_I   (odd_ram_we),
    .ADR_I  (odd_turbo9_adr[ODD_MEM_ADDR_WIDTH-1:0]),
    .DAT_I  (odd_turbo9_wr_dat),
    .DAT_O  (odd_ram_rd_dat)
  );

  // Output Port
  output_port I_output_port
  (
    .CLK_I  (CLK_I),
    .RST_I  (RST_I),
    .WE_I   (port_we),
    .DAT_I  (even_turbo9_wr_dat),
    .DAT_O  (port_rd_dat),
    .PORT_O (OUTPUT_PORT_O)
  );

  // UART 
  t6551 I_t6551
  (
    // Inputs: Clock & Reset
    .RST_I            (RST_I              ),
    .CLK_I            (CLK_I              ),
                                          
    // Inputs                             
    .TX_DATA_I        (even_turbo9_wr_dat ),
    .TX_DATA_WR_EN_I  (acia_data_wr_en    ),
    .RXD_PIN_I        (RXD_PIN_I          ),
    .RX_DATA_RD_EN_I  (acia_data_rd_en    ),
                                     
    // Outputs                       
    .TXD_PIN_O        (TXD_PIN_O          ),
    .RX_DATA_O        (acia_data_rd_dat   ),
    .STATUS_DATA_O    (acia_status_rd_dat )
  );

  // Clock Count Timer
  clk_counter I_clk_counter
  (
    // Inputs: Clock & Reset
    .RST_I            (RST_I          ),
    .CLK_I            (CLK_I          ),
    // Inputs             
    .PORT_I           (OUTPUT_PORT_O  ),  
    .CLK_CNT_DATA_O   (clk_cnt_rd_dat )
  );


  // Read Data Muxes & Enables (Even Bytes)
  always @* begin
    // Defaults
    even_turbo9_rd_dat = 8'h00;
    acia_data_rd_en = 1'b0;
    //
    if (even_turbo9_adr_reg_full[15:FULL_MEM_ADDR_WIDTH] == {(16-FULL_MEM_ADDR_WIDTH){1'b1}}) begin
      even_turbo9_rd_dat = even_ram_rd_dat;
    end else begin
      case (even_turbo9_adr_reg_full[3:0])
        //
        4'h6:    even_turbo9_rd_dat = clk_cnt_rd_dat[15: 8];
        4'h4:    even_turbo9_rd_dat = clk_cnt_rd_dat[31:24];
        4'h2: begin
          even_turbo9_rd_dat = acia_data_rd_dat;
          acia_data_rd_en =  ~even_turbo9_we_reg;
        end
        4'h0:    even_turbo9_rd_dat = port_rd_dat;
        default: even_turbo9_rd_dat = 8'h00;
      endcase
    end
  end

  // Read Data Mux & Enables (Odd Bytes)
  always @* begin
    // Defaults
    odd_turbo9_rd_dat = 8'h00;
    //
    if (odd_turbo9_adr_reg_full[15:FULL_MEM_ADDR_WIDTH] == {(16-FULL_MEM_ADDR_WIDTH){1'b1}}) begin
      odd_turbo9_rd_dat = odd_ram_rd_dat;
    end else begin
      case (odd_turbo9_adr_reg_full[3:0])
        //
        4'h7:    odd_turbo9_rd_dat = clk_cnt_rd_dat[ 7: 0];
        4'h5:    odd_turbo9_rd_dat = clk_cnt_rd_dat[23:16];
        4'h3:    odd_turbo9_rd_dat = acia_status_rd_dat;
        default: odd_turbo9_rd_dat = 8'h00;
      endcase
    end
  end

/////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////
//                             ASSIGN OUTPUTS
/////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////

endmodule


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


  ////////////// Memory Map
  //
  //
  // Initialized RAM (Vector Table): FFFF - FFF0
  //
  // FFFE : FFFF   RESET_VECTOR
  // FFFC : FFFD   NMI_VECTOR
  // FFFA : FFFB   SWI_VECTOR
  // FFF8 : FFF9   IRQ_VECTOR
  // FFF6 : FFF7   FIRQ_VECTOR
  // FFF4 : FFF5   SWI2_VECTOR
  // FFF2 : FFF3   SWI3_VECTOR
  // FFF0 : FFF1   RESERVED_VECTOR
  //
  //
  // I/O Space: FFEF - FF00
  //
  // FF08          CLK_CNT_CTRL[1:0] (read)  /  CLK_CNT_CTRL (write)
  // FF04 : FF07   CLK_CNT[31:0]     (read)
  // FF03          ACIA_STATUS       (read)
  // FF02          ACIA_RX_DATA      (read)  /  ACIA_TX_DATA (write)
  // FF01          GPI PORT          (read)
  // FF00          GPO PORT          (read)  /  GPO_PORT    (write)
  //
  //
  // Initialized RAM: FEFF - 0000
  //
  //

//////////////////////////////////////////////////////////////////////////////
// [TURBO9_HEADER_END]

/////////////////////////////////////////////////////////////////////////////
//                                MODULE
/////////////////////////////////////////////////////////////////////////////
`include "turbo9_rtl_config.vh"

module soc_top_r
#(
  parameter TURBO9_SOC_MEM_ADDR_WIDTH = 16, // SoC Memory Address Width: 16=64KB
  parameter TURBO9_SOC_WB_PIPELINE_REG = 0, // SoC WB Pipeline Registers: True=1, False=0
  parameter TURBO9_CPU_WB_PIPELINE_REG = 0, // CPU WB Pipeline Registers: True=1, False=0
  parameter TURBO9_CPU_QUEUE_SIZE = 6 // CPU Fetch Queue Size: 6=Default, 4=Min, 7=Max
)
(
  // Inputs: Clock & Reset
  input          RST_I, // Reset. Active high and synchronized to CLK_I
  input          CLK_I, // Clock

  // Inputs
  input          RXD_PIN_I,
  input    [7:0] GPI_PORT_I,

  // Outputs
  output         TXD_PIN_O,
  output   [7:0] GPO_PORT_O
);

/////////////////////////////////////////////////////////////////////////////
//                             INTERNAL SIGNALS
/////////////////////////////////////////////////////////////////////////////

localparam WORD_MEM_ADDR_WIDTH = TURBO9_SOC_MEM_ADDR_WIDTH-1;

wire  [4:0] even_turbo9_tgd_o;
reg   [4:0] even_turbo9_tgd_reg;
localparam  even_turbo9_tgd_rst = 5'b00000;

wire [15:0] even_turbo9_adr;
reg  [15:0] even_turbo9_adr_reg;
localparam  even_turbo9_adr_rst = 16'h0000;

wire  [7:0] even_turbo9_wr_dat;
reg   [7:0] even_turbo9_rd_dat;

wire        even_turbo9_stb;
reg         even_turbo9_ack;
wire        even_turbo9_we;
reg         even_turbo9_we_reg;
localparam  even_turbo9_we_rst = 1'b0;

wire [15:0] odd_turbo9_adr;
reg  [15:0] odd_turbo9_adr_reg;
localparam  odd_turbo9_adr_rst = 16'h0000;

wire  [7:0] odd_turbo9_wr_dat;
reg   [7:0] odd_turbo9_rd_dat;

wire        odd_turbo9_stb;
reg         odd_turbo9_ack;
wire        odd_turbo9_we;

wire  [7:0] acia_data_rd_dat;
wire  [7:0] acia_status_rd_dat;

reg         acia_data_wr_en;
reg         acia_data_rd_en;

reg         even_ram_we;
wire  [7:0] even_ram_rd_dat;

reg         odd_ram_we;
wire  [7:0] odd_ram_rd_dat;

reg         clk_cnt_ctrl_wr_en;
wire  [7:0] clk_cnt_ctrl_dat;

reg         gpo_port_we;
wire  [7:0] gpo_port_rd_dat;
wire  [7:0] gpi_port_rd_dat;

wire [31:0] clk_cnt_rd_dat;

wire        ram_clk;

/////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////
//                                REGISTERS
/////////////////////////////////////////////////////////////////////////////

  // Turbo9R
  turbo9_r
  #(
    .TURBO9_CPU_WB_PIPELINE_REG (TURBO9_CPU_WB_PIPELINE_REG), // CPU WB Pipeline Registers: True=1, False=0
    .TURBO9_CPU_QUEUE_SIZE      (TURBO9_CPU_QUEUE_SIZE) // CPU Fetch Queue Size: 6=Default, 4=Min, 7=Max
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

generate
  if (TURBO9_SOC_WB_PIPELINE_REG) begin: gen_soc_pipeline_reg
  //
  assign ram_clk = CLK_I;
  //
  // Wishbone Pipeline Registers (Even Bytes)
`ifdef TURBO9_RTL_SYNC_RESET
  always @(posedge CLK_I) begin
`else
  always @(posedge CLK_I, posedge RST_I) begin
`endif
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
  //
  // Wishbone Pipeline Registers (Odd Bytes)
`ifdef TURBO9_RTL_SYNC_RESET
  always @(posedge CLK_I) begin
`else
  always @(posedge CLK_I, posedge RST_I) begin
`endif
    if (RST_I) begin
      odd_turbo9_adr_reg <= odd_turbo9_adr_rst;
      odd_turbo9_ack     <= 1'b0;
    end else begin
      odd_turbo9_adr_reg <= odd_turbo9_adr;
      odd_turbo9_ack     <= odd_turbo9_stb;
    end
  end
  //
  end else begin: gen_soc_no_pipeline_reg
  //
  assign ram_clk = ~CLK_I;
  //
  always @* begin
    even_turbo9_adr_reg = even_turbo9_adr;
    even_turbo9_ack     = even_turbo9_stb;
    even_turbo9_tgd_reg = even_turbo9_tgd_o;
    even_turbo9_we_reg  = even_turbo9_we;
    odd_turbo9_adr_reg  = odd_turbo9_adr;
    odd_turbo9_ack      = odd_turbo9_stb;
  end
  //
  end
endgenerate


  // Write Enables (Even Bytes)
  always @* begin
    // Defaults
    even_ram_we = 1'b0;
    gpo_port_we = 1'b0;
    acia_data_wr_en = 1'b0;
    clk_cnt_ctrl_wr_en = 1'b0;
    //
    // Even Memory Bus Read Data Mux
    if (even_turbo9_adr[15:8] == 8'hFF) begin
      if (even_turbo9_adr[7:4] == 4'hF) begin  /////////// FFFF - FFF0 : Vector Table
        even_ram_we = even_turbo9_we;
      end else begin
        case (even_turbo9_adr[3:0])            /////////// FFEF - FF00 : I/O Space
          4'h8: clk_cnt_ctrl_wr_en = even_turbo9_we;
          4'h2: acia_data_wr_en    = even_turbo9_we;
          4'h0: gpo_port_we        = even_turbo9_we;
        endcase
      end
    end else begin                                  /////////// FEFF - 0000 : RAM
      even_ram_we = even_turbo9_we;
    end
  end

  // Write Enables (Odd Bytes)
  always @* begin
    // Defaults
    odd_ram_we = 1'b0;
    //
    // Odd Memory Bus Read Data Mux
    if (odd_turbo9_adr[15:8] == 8'hFF) begin
      if (odd_turbo9_adr[7:4] == 4'hF) begin  /////////// FFFF - FFF0 : Vector Table
        odd_ram_we = odd_turbo9_we;
      end
    end else begin                                 /////////// FEFF - 0000 : RAM
      odd_ram_we = odd_turbo9_we;
    end
  end

  // RAM (Even bytes)
  syncram_8bit
  #(
    .MEM_ADDR_WIDTH (WORD_MEM_ADDR_WIDTH),   // RAM Address Width: word address excludes byte lane bit
    .MEM_INIT_FILE  ("default_even.hex")     // RAM Init File: default_even.hex
  )
  I_even_syncram_8bit
  (
    .CLK_I  (ram_clk),
    .WE_I   (even_ram_we),
    .ADR_I  (even_turbo9_adr[TURBO9_SOC_MEM_ADDR_WIDTH-1:1]),
    .DAT_I  (even_turbo9_wr_dat),
    .DAT_O  (even_ram_rd_dat)
  );

  // RAM (Odd bytes)
  syncram_8bit
  #(
    .MEM_ADDR_WIDTH (WORD_MEM_ADDR_WIDTH),   // RAM Address Width: word address excludes byte lane bit
    .MEM_INIT_FILE  ("default_odd.hex")      // RAM Init File: default_odd.hex
  )
  I_odd_syncram_8bit
  (
    .CLK_I  (ram_clk),
    .WE_I   (odd_ram_we),
    .ADR_I  (odd_turbo9_adr[TURBO9_SOC_MEM_ADDR_WIDTH-1:1]),
    .DAT_I  (odd_turbo9_wr_dat),
    .DAT_O  (odd_ram_rd_dat)
  );

  // Output Port
  gpo_port I_gpo_port
  (
    .CLK_I      (CLK_I),
    .RST_I      (RST_I),
    .WE_I       (gpo_port_we),
    .DAT_I      (even_turbo9_wr_dat),
    .DAT_O      (gpo_port_rd_dat),
    .GPO_PORT_O (GPO_PORT_O)
  );

  // Input Port
  gpi_port I_gpi_port
  (
    .CLK_I       (CLK_I           ),
    .GPI_PORT_I  (GPI_PORT_I      ),
    .DAT_O       (gpi_port_rd_dat )
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
    .RST_I                (RST_I          ),
    .CLK_I                (CLK_I          ),

    // Inputs
    .DATA_I               (even_turbo9_wr_dat ),
    .CLK_CNT_CTRL_WR_EN_I (clk_cnt_ctrl_wr_en ),

    // Outputs
    .CLK_CNT_CTRL_DATA_O  (clk_cnt_ctrl_dat   ),
    .CLK_CNT_DATA_O       (clk_cnt_rd_dat     )
  );


  // Read Data Muxes & Enables (Even Bytes)
  always @* begin
    // Defaults
    even_turbo9_rd_dat = 8'h00;
    acia_data_rd_en = 1'b0;
    //
    if (even_turbo9_adr_reg[15:8] == 8'hFF) begin
      if (even_turbo9_adr_reg[7:4] == 4'hF) begin  /////////// FFFF - FFF0 : Vector Table
        even_turbo9_rd_dat = even_ram_rd_dat;
      end else begin
        case (even_turbo9_adr_reg[3:0])            /////////// FFEF - FF00 : I/O Space
          //
          4'h8:    even_turbo9_rd_dat = clk_cnt_ctrl_dat;
          4'h6:    even_turbo9_rd_dat = clk_cnt_rd_dat[15: 8];
          4'h4:    even_turbo9_rd_dat = clk_cnt_rd_dat[31:24];
          4'h2: begin
            even_turbo9_rd_dat = acia_data_rd_dat;
            acia_data_rd_en =  ~even_turbo9_we_reg;
          end
          4'h0:    even_turbo9_rd_dat = gpo_port_rd_dat;
          default: even_turbo9_rd_dat = 8'h00;
        endcase
      end
    end else begin                                      /////////// FEFF - 0000 : RAM
      even_turbo9_rd_dat = even_ram_rd_dat;
    end
  end

  // Read Data Mux & Enables (Odd Bytes)
  always @* begin
    // Defaults
    odd_turbo9_rd_dat = 8'h00;
    //
    if (odd_turbo9_adr_reg[15:8] == 8'hFF) begin
      if (odd_turbo9_adr_reg[7:4] == 4'hF) begin  /////////// FFFF - FFF0 : Vector Table
        odd_turbo9_rd_dat = odd_ram_rd_dat;
      end else begin
        case (odd_turbo9_adr_reg[3:0])            /////////// FFEF - FF00 : I/O Space
          //
          4'h7:    odd_turbo9_rd_dat = clk_cnt_rd_dat[ 7: 0];
          4'h5:    odd_turbo9_rd_dat = clk_cnt_rd_dat[23:16];
          4'h3:    odd_turbo9_rd_dat = acia_status_rd_dat;
          4'h1:    odd_turbo9_rd_dat = gpi_port_rd_dat;
          default: odd_turbo9_rd_dat = 8'h00;
        endcase
      end
    end else begin                                     /////////// FEFF - 0000 : RAM
      odd_turbo9_rd_dat = odd_ram_rd_dat;
    end
  end

/////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////
//                             ASSIGN OUTPUTS
/////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////

endmodule

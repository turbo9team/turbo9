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
// Description: Target independent SoC top level for
// the Turbo9S (16-bit aligned bus)
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
// History:
// 07.14.2023 - Kevin Phillipson
//   File header added
//
//////////////////////////////////////////////////////////////////////////////
// [TURBO9_HEADER_END]

/////////////////////////////////////////////////////////////////////////////
//                                MODULE
/////////////////////////////////////////////////////////////////////////////
`include "turbo9_rtl_config.vh"

module soc_top_gts
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
  input   [7:0]  GPI_PORT_I,

  // Outputs
  output         TXD_PIN_O,
  output   [7:0] GPO_PORT_O
);

/////////////////////////////////////////////////////////////////////////////
//                             INTERNAL SIGNALS
/////////////////////////////////////////////////////////////////////////////

localparam WORD_MEM_ADDR_WIDTH = TURBO9_SOC_MEM_ADDR_WIDTH-1;

wire  [4:0] dmem_turbo9_tgd_o;
reg   [4:0] dmem_turbo9_tgd_reg;
localparam  dmem_turbo9_tgd_rst = 5'b00000;

wire [15:0] dmem_turbo9_adr;
reg  [15:0] dmem_turbo9_adr_reg;
localparam  dmem_turbo9_adr_rst = 16'h0000;

wire  [1:0] dmem_turbo9_sel;
reg   [1:0] dmem_turbo9_sel_reg;
localparam  dmem_turbo9_sel_rst = 2'b00;

wire [15:0] dmem_turbo9_wr_dat;
reg  [15:0] dmem_turbo9_rd_dat;

wire        dmem_turbo9_stb;
reg         dmem_turbo9_stb_reg;
localparam  dmem_turbo9_stb_rst = 1'b0;
wire        dmem_turbo9_ack = dmem_turbo9_stb_reg;
wire        dmem_turbo9_we;
reg         dmem_turbo9_we_reg;
localparam  dmem_turbo9_we_rst = 1'b0;

wire  [4:0] pmem_turbo9_tgd_o;
reg   [4:0] pmem_turbo9_tgd_reg;
localparam  pmem_turbo9_tgd_rst = 5'b00000;

wire [15:0] pmem_turbo9_adr;
reg  [15:0] pmem_turbo9_adr_reg;
localparam  pmem_turbo9_adr_rst = 16'h0000;

wire  [1:0] pmem_turbo9_sel;
reg   [1:0] pmem_turbo9_sel_reg;
localparam  pmem_turbo9_sel_rst = 2'b00;

wire [15:0] pmem_turbo9_wr_dat;
reg  [15:0] pmem_turbo9_rd_dat;

wire        pmem_turbo9_stb;
reg         pmem_turbo9_stb_reg;
localparam  pmem_turbo9_stb_rst = 1'b0;
wire        pmem_turbo9_ack = pmem_turbo9_stb_reg;
wire        pmem_turbo9_we;
reg         pmem_turbo9_we_reg;
localparam  pmem_turbo9_we_rst = 1'b0;

wire  [7:0] acia_data_rd_dat;
wire  [7:0] acia_status_rd_dat;

reg         acia_data_wr_en;
reg         acia_data_rd_en;

reg         clk_cnt_ctrl_wr_en;
wire  [7:0] clk_cnt_ctrl_dat;

reg         dmem_even_ram_we;
reg         dmem_odd_ram_we;
wire [15:0] dmem_ram_rd_dat;

wire [15:0] pmem_ram_rd_dat;

reg         gpo_port_we;
wire  [7:0] gpo_port_rd_dat;
wire  [7:0] gpi_port_rd_dat;

wire [31:0] clk_cnt_rd_dat;

wire        ram_clk;

/////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////
//                                REGISTERS
/////////////////////////////////////////////////////////////////////////////

  turbo9_gts
  #(
    .TURBO9_CPU_WB_PIPELINE_REG (TURBO9_CPU_WB_PIPELINE_REG), // CPU WB Pipeline Registers: True=1, False=0
    .TURBO9_CPU_QUEUE_SIZE      (TURBO9_CPU_QUEUE_SIZE) // CPU Fetch Queue Size: 6=Default, 4=Min, 7=Max
  )
  I_turbo9_gts
  (
    // Inputs: Clock & Reset
    .RST_I  (RST_I),
    .CLK_I  (CLK_I),

    // Inputs
    .PMEM_DAT_I   (pmem_ram_rd_dat),    //WAS pmem_turbo9_rd_dat
    .PMEM_TGD_I   (pmem_turbo9_tgd_reg),
    .PMEM_ACK_I   (pmem_turbo9_ack),
    .PMEM_STALL_I (1'b0),
    //
    .DMEM_DAT_I   (dmem_turbo9_rd_dat),
    .DMEM_TGD_I   (dmem_turbo9_tgd_reg),
    .DMEM_ACK_I   (dmem_turbo9_ack),
    .DMEM_STALL_I (1'b0),

    // Outputs
    .PMEM_ADR_O   (pmem_turbo9_adr),
    .PMEM_DAT_O   (pmem_turbo9_wr_dat),
    .PMEM_SEL_O   (pmem_turbo9_sel),
    .PMEM_TGD_O   (pmem_turbo9_tgd_o),
    .PMEM_WE_O    (pmem_turbo9_we),
    .PMEM_STB_O   (pmem_turbo9_stb),
    .PMEM_CYC_O   (),
    //
    .DMEM_ADR_O   (dmem_turbo9_adr),
    .DMEM_DAT_O   (dmem_turbo9_wr_dat),
    .DMEM_SEL_O   (dmem_turbo9_sel),
    .DMEM_TGD_O   (dmem_turbo9_tgd_o),
    .DMEM_WE_O    (dmem_turbo9_we),
    .DMEM_STB_O   (dmem_turbo9_stb),
    .DMEM_CYC_O   ()
  );

generate
  if (TURBO9_SOC_WB_PIPELINE_REG) begin: gen_soc_pipeline_reg
  //
  assign ram_clk = CLK_I;
  //
  // Wishbone Pipeline Registers
`ifdef TURBO9_RTL_SYNC_RESET
  always @(posedge CLK_I) begin
`else
  always @(posedge CLK_I, posedge RST_I) begin
`endif
    if (RST_I) begin
      dmem_turbo9_adr_reg <= dmem_turbo9_adr_rst;
      dmem_turbo9_stb_reg <= dmem_turbo9_stb_rst;
      dmem_turbo9_tgd_reg <= dmem_turbo9_tgd_rst;
      dmem_turbo9_sel_reg <= dmem_turbo9_sel_rst;
      dmem_turbo9_we_reg  <= dmem_turbo9_we_rst;
      //
      pmem_turbo9_adr_reg <= pmem_turbo9_adr_rst;
      pmem_turbo9_stb_reg <= pmem_turbo9_stb_rst;
      pmem_turbo9_tgd_reg <= pmem_turbo9_tgd_rst;
      pmem_turbo9_sel_reg <= pmem_turbo9_sel_rst;
      pmem_turbo9_we_reg  <= pmem_turbo9_we_rst;
    end else begin
      dmem_turbo9_adr_reg <= dmem_turbo9_adr;
      dmem_turbo9_stb_reg <= dmem_turbo9_stb;
      dmem_turbo9_tgd_reg <= dmem_turbo9_tgd_o;
      dmem_turbo9_sel_reg <= dmem_turbo9_sel;
      dmem_turbo9_we_reg  <= dmem_turbo9_we;
      //
      pmem_turbo9_adr_reg <= pmem_turbo9_adr;
      pmem_turbo9_stb_reg <= pmem_turbo9_stb;
      pmem_turbo9_tgd_reg <= pmem_turbo9_tgd_o;
      pmem_turbo9_sel_reg <= pmem_turbo9_sel;
      pmem_turbo9_we_reg  <= pmem_turbo9_we;
    end
  end
  //
  end else begin: gen_soc_no_pipeline_reg
  //
  assign ram_clk = ~CLK_I;
  //
  always @* begin
    dmem_turbo9_adr_reg = dmem_turbo9_adr;
    dmem_turbo9_stb_reg = dmem_turbo9_stb;
    dmem_turbo9_tgd_reg = dmem_turbo9_tgd_o;
    dmem_turbo9_sel_reg = dmem_turbo9_sel;
    dmem_turbo9_we_reg  = dmem_turbo9_we;
    //
    pmem_turbo9_adr_reg = pmem_turbo9_adr;
    pmem_turbo9_stb_reg = pmem_turbo9_stb;
    pmem_turbo9_tgd_reg = pmem_turbo9_tgd_o;
    pmem_turbo9_sel_reg = pmem_turbo9_sel;
    pmem_turbo9_we_reg  = pmem_turbo9_we;
  end
  //
  end
endgenerate


  // Write Enables
  always @* begin
    // Defaults
    dmem_even_ram_we = 1'b0;
    dmem_odd_ram_we = 1'b0;
    gpo_port_we = 1'b0;
    acia_data_wr_en = 1'b0;
    clk_cnt_ctrl_wr_en = 1'b0;
    //
    // Memory Bus Read Data Mux
    if (dmem_turbo9_adr[15:8] == 8'hFF) begin
      if (dmem_turbo9_adr[7:4] == 4'hF) begin  /////////// FFFF - FFF0 : Vector Table
        dmem_even_ram_we = dmem_turbo9_we & dmem_turbo9_sel[1];
        dmem_odd_ram_we  = dmem_turbo9_we & dmem_turbo9_sel[0];
      end else begin
        case (dmem_turbo9_adr[3:0])            /////////// FFEF - FF00 : I/O Space
          4'h8: clk_cnt_ctrl_wr_en = dmem_turbo9_we & dmem_turbo9_sel[1];
          4'h2: acia_data_wr_en    = dmem_turbo9_we & dmem_turbo9_sel[1];
          4'h0: gpo_port_we        = dmem_turbo9_we & dmem_turbo9_sel[1];
        endcase
      end
    end else begin                        /////////// FEFF - 0000 : RAM
      dmem_even_ram_we = dmem_turbo9_we & dmem_turbo9_sel[1];
      dmem_odd_ram_we  = dmem_turbo9_we & dmem_turbo9_sel[0];
    end
  end


  // RAM (Even bytes)
  syncram_dp_8bit
  #(
    .MEM_ADDR_WIDTH (WORD_MEM_ADDR_WIDTH),   // RAM Address Width: word address excludes byte lane bit
    .MEM_INIT_FILE  ("default_even.hex")     // RAM Init File: default_even.hex
  )
  I_even_syncram_8bit
  (
    .CLK_I    (ram_clk),

    .A_WE_I   (dmem_even_ram_we),
    .A_ADR_I  (dmem_turbo9_adr[TURBO9_SOC_MEM_ADDR_WIDTH-1:1]),
    .A_DAT_I  (dmem_turbo9_wr_dat[15:8]),
    .A_DAT_O  (dmem_ram_rd_dat[15:8]),

    .B_ADR_I  (pmem_turbo9_adr[TURBO9_SOC_MEM_ADDR_WIDTH-1:1]),
    .B_DAT_O  (pmem_ram_rd_dat[15:8])
  );

  // RAM (Odd bytes)
  syncram_dp_8bit
  #(
    .MEM_ADDR_WIDTH (WORD_MEM_ADDR_WIDTH),   // RAM Address Width: word address excludes byte lane bit
    .MEM_INIT_FILE  ("default_odd.hex")      // RAM Init File: default_odd.hex
  )
  I_odd_syncram_8bit
  (
    .CLK_I  (ram_clk),

    .A_WE_I   (dmem_odd_ram_we),
    .A_ADR_I  (dmem_turbo9_adr[TURBO9_SOC_MEM_ADDR_WIDTH-1:1]),
    .A_DAT_I  (dmem_turbo9_wr_dat[7:0]),
    .A_DAT_O  (dmem_ram_rd_dat[7:0]),

    .B_ADR_I  (pmem_turbo9_adr[TURBO9_SOC_MEM_ADDR_WIDTH-1:1]),
    .B_DAT_O  (pmem_ram_rd_dat[7:0])
  );





  // Output Port
  gpo_port I_gpo_port
  (
    .CLK_I      (CLK_I),
    .RST_I      (RST_I),
    .WE_I       (gpo_port_we         ),
    .DAT_I      (dmem_turbo9_wr_dat[15:8] ),
    .DAT_O      (gpo_port_rd_dat     ),
    .GPO_PORT_O (GPO_PORT_O          )
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
    .TX_DATA_I        (dmem_turbo9_wr_dat[15:8] ),
    .TX_DATA_WR_EN_I  (acia_data_wr_en     ),
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
    .DATA_I               (dmem_turbo9_wr_dat[15:8]),
    .CLK_CNT_CTRL_WR_EN_I (clk_cnt_ctrl_wr_en ),

    // Outputs
    .CLK_CNT_CTRL_DATA_O  (clk_cnt_ctrl_dat   ),
    .CLK_CNT_DATA_O       (clk_cnt_rd_dat     )
  );


  // Read Data Muxes & Enables
  always @* begin
    // Defaults
    dmem_turbo9_rd_dat = 16'h0000;
    acia_data_rd_en = 1'b0;
    //
    if (dmem_turbo9_adr_reg[15:8] == 8'hFF) begin
      if (dmem_turbo9_adr_reg[7:4] == 4'hF) begin  /////////// FFFF - FFF0 : Vector Table
        dmem_turbo9_rd_dat = dmem_ram_rd_dat;
      end else begin
        case (dmem_turbo9_adr_reg[3:0])     /////////// FFEF - FF00 : I/O Space
          //
          4'h8:    dmem_turbo9_rd_dat = {clk_cnt_ctrl_dat, 8'h00};
          4'h6:    dmem_turbo9_rd_dat = clk_cnt_rd_dat[15: 0];
          4'h4:    dmem_turbo9_rd_dat = clk_cnt_rd_dat[31:16];
          4'h2: begin
            dmem_turbo9_rd_dat   = {acia_data_rd_dat,  acia_status_rd_dat};
            acia_data_rd_en = ~dmem_turbo9_we_reg & dmem_turbo9_sel_reg[1] & dmem_turbo9_stb_reg;
          end
          4'h0:    dmem_turbo9_rd_dat = {gpo_port_rd_dat, gpi_port_rd_dat};
          default: dmem_turbo9_rd_dat = 16'h0000;
        endcase
      end
    end else begin                            /////////// FEFF - 0000 : RAM
      dmem_turbo9_rd_dat = dmem_ram_rd_dat;
    end
  end


  // Read Program Memory Muxes & Enables
//  always @* begin
//    pmem_turbo9_rd_dat = pmem_ram_rd_dat; //  end



/////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////
//                             ASSIGN OUTPUTS
/////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////

endmodule

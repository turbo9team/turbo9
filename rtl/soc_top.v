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
// Description: Target independent SoC top level for the Turbo9 (8-bit bus)
//
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
module soc_top
#(
  parameter MEM_ADDR_WIDTH = 16 // 64KB Memory
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

// Comment / Uncomment to remove / add pipeline register:
//`define SOC_PIPELINE_REG

wire  [3:0] turbo9_tgd_o;
reg   [3:0] turbo9_tgd_reg;
localparam  turbo9_tgd_rst = 4'b0000;

wire [15:0] turbo9_adr;
reg  [15:0] turbo9_adr_reg;
localparam  turbo9_adr_rst = 16'h0000;

wire  [7:0] turbo9_wr_dat;
reg   [7:0] turbo9_rd_dat;

wire        turbo9_stb;
reg         turbo9_ack;
wire        turbo9_we;
reg         turbo9_we_reg;
localparam  turbo9_we_rst = 1'b0;

wire  [7:0] acia_data_rd_dat;  
wire  [7:0] acia_status_rd_dat;

reg         acia_data_wr_en;
reg         acia_data_rd_en;

reg         clk_cnt_ctrl_wr_en;
wire  [7:0] clk_cnt_ctrl_dat;

reg         ram_we;
wire  [7:0] ram_rd_dat;

reg         gpo_port_we;
wire  [7:0] gpo_port_rd_dat;
wire  [7:0] gpi_port_rd_dat;

wire [31:0] clk_cnt_rd_dat;

wire        ram_clk;

/////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////
//                                REGISTERS
/////////////////////////////////////////////////////////////////////////////
  
  turbo9
  #(
    .REGISTER_WB_OUTPUTS  (0), // Register Wishbone Outputs: True=1, False=0
    .QUEUE_SIZE           (6)  // Fetch Queue Size: 6=Default, 4=Min, 7=Max                 
  )
  I_turbo9
  (
    // Inputs: Clock & Reset
    .RST_I  (RST_I),
    .CLK_I  (CLK_I),
 
    // Inputs 
    .DAT_I   (turbo9_rd_dat),
    .TGD_I   (turbo9_tgd_reg),
    .ACK_I   (turbo9_ack),
    .STALL_I (1'b0),
    
    // Outputs
    .ADR_O   (turbo9_adr),
    .DAT_O   (turbo9_wr_dat),
    .TGD_O   (turbo9_tgd_o),
    .WE_O    (turbo9_we), 
    .STB_O   (turbo9_stb),
    .CYC_O   ()
  );



`ifdef SOC_PIPELINE_REG
  //
  assign ram_clk = CLK_I;
  //
  // Wishbone Pipeline Registers
  always @(posedge CLK_I, posedge RST_I) begin
    if (RST_I) begin
      turbo9_adr_reg <= turbo9_adr_rst;
      turbo9_ack     <= 1'b0;
      turbo9_tgd_reg <= turbo9_tgd_rst; 
      turbo9_we_reg  <= turbo9_we_rst; 
    end else begin
      turbo9_adr_reg <= turbo9_adr;
      turbo9_ack     <= turbo9_stb;
      turbo9_tgd_reg <= turbo9_tgd_o;
      turbo9_we_reg  <= turbo9_we; 
    end
  end
  //
`else
  //
  assign ram_clk = ~CLK_I;
  //
  always @* begin
    turbo9_adr_reg = turbo9_adr;
    turbo9_ack     = turbo9_stb;
    turbo9_tgd_reg = turbo9_tgd_o;
    turbo9_we_reg  = turbo9_we; 
  end
  //
`endif


  // Write Enables
  always @* begin
    // Defaults
    ram_we = 1'b0;
    gpo_port_we = 1'b0;
    acia_data_wr_en = 1'b0;
    clk_cnt_ctrl_wr_en = 1'b0;
    //
    // Memory Bus Read Data Mux
    if (turbo9_adr[15:8] == 8'hFF) begin
      if (turbo9_adr[7:4] == 4'hF) begin  /////////// FFFF - FFF0 : Vector Table
        ram_we = turbo9_we;
      end else begin
        case (turbo9_adr[3:0])            /////////// FFEF - FF00 : I/O Space
          4'h8: clk_cnt_ctrl_wr_en = turbo9_we;
          4'h2: acia_data_wr_en    = turbo9_we;
          4'h0: gpo_port_we        = turbo9_we;
        endcase
      end
    end else begin                        /////////// FEFF - 0000 : RAM
      ram_we = turbo9_we;
    end
  end

  // RAM
  syncram_8bit
  #(
    .MEM_ADDR_WIDTH (MEM_ADDR_WIDTH),
    .MEM_INIT_FILE  ("default.hex")
  )
  I_syncram_8bit
  (
    .CLK_I  (ram_clk),
    .WE_I   (ram_we),
    .ADR_I  (turbo9_adr[MEM_ADDR_WIDTH-1:0]),
    .DAT_I  (turbo9_wr_dat),
    .DAT_O  (ram_rd_dat)
  );

  // Output Port
  gpo_port I_gpo_port
  (
    .CLK_I      (CLK_I),
    .RST_I      (RST_I),
    .WE_I       (gpo_port_we),
    .DAT_I      (turbo9_wr_dat),
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
    .TX_DATA_I        (turbo9_wr_dat      ),
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
    .DATA_I               (turbo9_wr_dat      ),
    .CLK_CNT_CTRL_WR_EN_I (clk_cnt_ctrl_wr_en ),

    // Outputs         
    .CLK_CNT_CTRL_DATA_O  (clk_cnt_ctrl_dat   ),
    .CLK_CNT_DATA_O       (clk_cnt_rd_dat     )
  );


  // Read Data Muxes & Enables
  always @* begin
    // Defaults
    turbo9_rd_dat = 8'h00;
    acia_data_rd_en = 1'b0;
    //
    if (turbo9_adr_reg[15:8] == 8'hFF) begin
      if (turbo9_adr_reg[7:4] == 4'hF) begin  /////////// FFFF - FFF0 : Vector Table
        turbo9_rd_dat = ram_rd_dat;
      end else begin
        case (turbo9_adr_reg[3:0])            /////////// FFEF - FF00 : I/O Space
          //
          4'h8:    turbo9_rd_dat = clk_cnt_ctrl_dat;
          4'h7:    turbo9_rd_dat = clk_cnt_rd_dat[ 7: 0];
          4'h6:    turbo9_rd_dat = clk_cnt_rd_dat[15: 8];
          4'h5:    turbo9_rd_dat = clk_cnt_rd_dat[23:16];
          4'h4:    turbo9_rd_dat = clk_cnt_rd_dat[31:24];
          4'h3:    turbo9_rd_dat = acia_status_rd_dat;
          4'h2: begin
            turbo9_rd_dat   = acia_data_rd_dat;
            acia_data_rd_en = ~turbo9_we_reg;
          end
          4'h1:    turbo9_rd_dat = gpi_port_rd_dat;
          4'h0:    turbo9_rd_dat = gpo_port_rd_dat;
          default: turbo9_rd_dat = 8'h00;
        endcase
      end
    end else begin                            /////////// FEFF - 0000 : RAM
      turbo9_rd_dat = ram_rd_dat;
    end
  end

/////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////
//                             ASSIGN OUTPUTS
/////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////

endmodule

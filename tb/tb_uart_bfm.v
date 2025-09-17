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
//
// UART Bus Functional Model with t6551 (Verilog-2001)
// - Instantiates t6551 to communicate over async serial
// - Captures console RX to a file
// - Sends an text file over TX with throttling
//
//////////////////////////////////////////////////////////////////////////////
// History:
// 07.14.2023 - Kevin Phillipson
//   File header added
//
//////////////////////////////////////////////////////////////////////////////
// [TURBO9_HEADER_END]

module tb_uart_bfm
#(
  // Filename bus widths (bytes*8)
  parameter integer CONSOLE_FILENAME_LEN   = 128,
  parameter integer UPLOAD_FILENAME_LEN    = 128
)
(
  // Filenames
  input  wire [(CONSOLE_FILENAME_LEN*8)-1:0] CONSOLE_FILENAME_I,
  input  wire [(UPLOAD_FILENAME_LEN*8)-1:0]  UPLOAD_FILENAME_I,

  // Inputs: Clock & Reset
  input  wire   RST_I,     // Active high
  input  wire   CLK_I,     // UART clock

  // TB Control Inputs
  input  wire   CONSOLE_EN_I,
  input  wire   UPLOAD_EN_I,
  input  wire   TB_DONE_I,

  // UART pins
  input  wire   RXD_PIN_I,        // Connect from soc_top*.TXD_PIN_O
  input  wire   CTS_PIN_I,

  output wire   TXD_PIN_O,        // Connect to soc_top*.RXD_PIN_I
  output reg    RX_IDLE_O,
  output reg    UPLOAD_DONE_O
);

  ////////////////////////////////////////////////////////////////////////////
  // Local wires/regs for the t6551
  ////////////////////////////////////////////////////////////////////////////
  wire [7:0] rx_data;
  wire [7:0] status_data;

  reg  [7:0] tx_data;
  reg        tx_data_wr_en;
  reg        rx_data_rd_en;

  // Idle counter
  localparam  RX_IDLE_CNT_MAX = 1024;
  integer rx_idle_cnt;

  // File I/O
  integer   console_file_ptr;

  integer   upload_file_ptr;
  integer   read_byte;

  ////////////////////////////////////////////////////////////////////////////
  // t6551 UART
  ////////////////////////////////////////////////////////////////////////////
  t6551 I_t6551_bfm
  (
    // Inputs: Clock & Reset
    .RST_I            (RST_I          ),
    .CLK_I            (CLK_I          ),

    // Inputs
    .TX_DATA_I        (tx_data        ),
    .TX_DATA_WR_EN_I  (tx_data_wr_en  ),
    .RXD_PIN_I        (RXD_PIN_I      ),
    .RX_DATA_RD_EN_I  (rx_data_rd_en  ),

    // Outputs
    .TXD_PIN_O        (TXD_PIN_O      ),
    .RX_DATA_O        (rx_data        ),
    .STATUS_DATA_O    (status_data    )
  );

  ////////////////////////////////////////////////////////////////////////////
  // Capture Console Data
  ////////////////////////////////////////////////////////////////////////////

  initial begin
    rx_idle_cnt    = 0;
    RX_IDLE_O      = 1'b0;
    rx_data_rd_en  = 1'b0;

    wait (CONSOLE_EN_I);

    // Use filename from port
    console_file_ptr  = $fopen(CONSOLE_FILENAME_I,"w");
    $display("[TB: UART BFM Console] Opening %0s for console output", CONSOLE_FILENAME_I);

    wait (!RST_I);

    while (!TB_DONE_I) begin
      rx_data_rd_en = 1'b0;
      @(posedge CLK_I);
      //
      if (status_data[3] == 1'b1) begin // if (rx_data_reg_full == 1)
        rx_idle_cnt = 0;
        if (rx_data != 8'h0d) begin // Drop carriage returns (used for VT-100)
          $fwrite(console_file_ptr, "%c", rx_data);
        end
        rx_data_rd_en = 1'b1;
      end else begin
        if (rx_idle_cnt < RX_IDLE_CNT_MAX) begin
          rx_idle_cnt++;
          RX_IDLE_O = 1'b0;
        end else begin
          RX_IDLE_O = 1'b1;
        end
      end
      //
      @(posedge CLK_I);
    end
    rx_data_rd_en = 1'b0;
    $fclose(console_file_ptr);
    //
    @(posedge CLK_I);
  end


  ////////////////////////////////////////////////////////////////////////////
  // Upload File
  ////////////////////////////////////////////////////////////////////////////

  initial begin
    UPLOAD_DONE_O = 1'b0;
    tx_data       = 8'h00;
    tx_data_wr_en = 1'b0;

    wait (UPLOAD_EN_I);

    $display("[TB: UART BFM Upload] Opening file for upload: %0s", UPLOAD_FILENAME_I);
    upload_file_ptr = $fopen(UPLOAD_FILENAME_I,"r");

    wait (!RST_I);

    read_byte    = $fgetc(upload_file_ptr);
    while ((read_byte > 0) && (!TB_DONE_I)) // ~EOF
    begin
      tx_data_wr_en = 1'b0;
      @(posedge CLK_I);
      //
      if (CTS_PIN_I && (status_data[4] == 1'b1) && (I_t6551_bfm.I_t6551_tx.tx_state_reg == 1'b0))  begin
        tx_data       = read_byte[7:0];
        tx_data_wr_en = 1'b1;
        read_byte     = $fgetc(upload_file_ptr);
      end
      //
      @(posedge CLK_I);
    end
    tx_data_wr_en = 1'b0;
    $fclose(upload_file_ptr);
    UPLOAD_DONE_O = 1'b1;
    //
    @(posedge CLK_I);
  end

endmodule



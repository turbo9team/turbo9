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
// Description: FPGA top level that instaniates the SoC
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
module fpga_top
(
  // Inputs: Clock & Reset
  input  CLK100MHZ,
  input  ck_rst, //active low

  // Inputs 
  input  uart_txd_in,
  
  // Outputs
  output uart_rxd_out,

  // Outputs
  output  [3:0] led,
  output        led0_b,
  output        led0_g,
  output        led0_r,
  output        led1_b,
  output        led1_g,
  output        led1_r,
  output        led2_b,
  output        led2_g,
  output        led2_r,
  output        led3_b,
  output        led3_g,
  output        led3_r

);

/////////////////////////////////////////////////////////////////////////////



/////////////////////////////////////////////////////////////////////////////
//                             INTERNAL SIGNALS
/////////////////////////////////////////////////////////////////////////////

reg         clk100_rst_meta;
reg         clk100_rst_sync;

wire        clk;
reg         rst_meta;
reg         rst_sync;

wire  [7:0] led_port;

/////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////
//                           CLOCK & RESET LOGIC
/////////////////////////////////////////////////////////////////////////////

//assign clk = CLK100MHZ;

// Reset Synchro
always @(posedge CLK100MHZ, negedge ck_rst) begin
  if (~ck_rst) begin
    clk100_rst_meta <= 1'b1;
    clk100_rst_sync <= 1'b1;
  end else begin
    clk100_rst_meta <= 1'b0;
    clk100_rst_sync <= clk100_rst_meta;
  end
end


clk_div I_clk_div
(
  // Inputs: Clock & Reset
  .CLK_I      (CLK100MHZ        ),
  .RST_I      (clk100_rst_sync  ),

  // Outputs
  .CLK_DIV2   (clk              )
);


// Reset Synchro
always @(posedge clk, negedge ck_rst) begin
  if (~ck_rst) begin
    rst_meta <= 1'b1;
    rst_sync <= 1'b1;
  end else begin
    rst_meta <= 1'b0;
    rst_sync <= rst_meta;
  end
end

/////////////////////////////////////////////////////////////////////////////
//                                LOGIC
/////////////////////////////////////////////////////////////////////////////

soc_top_r
//soc_top
#(
  15 // MEM_ADDR_WIDTH 
)
I_soc_top_r
//I_soc_top
(
  // Inputs: Clock & Reset
  .RST_I      (rst_sync ), // Reset. Active high and synchronized to CLK_I
  .CLK_I      (clk      ), // Clock

  .RXD_PIN_I  (uart_txd_in  ),
  
  // Outputs
  .TXD_PIN_O  (uart_rxd_out ),

  .OUTPUT_PORT_O (led_port )
);



fpga_leds I_fpga_leds
(
  // Inputs: Clock & Reset
  .CLK_I      (clk      ),
  .RST_I      (rst_sync ),
  //
  // Inputs 
  .LED_PORT_I (led_port ),
  //
  // Outputs
  .LED_O      (led      ),
  .LED0_B_O   (led0_b   ),
  .LED0_G_O   (led0_g   ),
  .LED0_R_O   (led0_r   ),
  .LED1_B_O   (led1_b   ),
  .LED1_G_O   (led1_g   ),
  .LED1_R_O   (led1_r   ),
  .LED2_B_O   (led2_b   ),
  .LED2_G_O   (led2_g   ),
  .LED2_R_O   (led2_r   ),
  .LED3_B_O   (led3_b   ),
  .LED3_G_O   (led3_g   ),
  .LED3_R_O   (led3_r   )
);
/////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////
//                             ASSIGN OUTPUTS
/////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////

endmodule


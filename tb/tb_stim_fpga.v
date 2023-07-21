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
// Description: Stimbench: simple simulation of fpga_top
//
//////////////////////////////////////////////////////////////////////////////
// History:
// 07.14.2023 - Kevin Phillipson
//   File header added
//
//////////////////////////////////////////////////////////////////////////////
// [TURBO9_HEADER_END]

/////////////////////////////////////////////////////////////////////////////
//                               Test FPGA
/////////////////////////////////////////////////////////////////////////////
  `define FPGA_CYCLES    200_000

task tb_stim_fpga;

  integer i;

begin

  fpga_reset = 1'b1;
  for (i=0; i<4; i=i+1) begin
    @ (posedge sys_clk);
  end

  fpga_reset = 1'b0;
  $display("[TB; tb_stim_fpga     ] Releasing fpga_reset...");
  $display("[TB; tb_stim_fpga     ] Running clock for %0d cycles", `FPGA_CYCLES);
  for (i=0; i<`FPGA_CYCLES; i=i+1) begin
    @ (posedge sys_clk);
  end

end
endtask

wire loop_back;

  /////////////////////////////////////////////////////////////////////////////
  // DUT
  /////////////////////////////////////////////////////////////////////////////
  fpga_top I_fpga_top
  (
  // Inputs: Clock & Reset
    .CLK100MHZ (sys_clk),
    .ck_rst    (~fpga_reset), //active low

  // Inputs 
    .uart_txd_in (loop_back),
  
  // Outputs
    .uart_rxd_out (loop_back),

  // Outputs
    .led       (),
    .led0_b    (),
    .led0_g    (),
    .led0_r    (),
    .led1_b    (),
    .led1_g    (),
    .led1_r    (),
    .led2_b    (),
    .led2_g    (),
    .led2_r    (),
    .led3_b    (),
    .led3_g    (),
    .led3_r    ()
  );





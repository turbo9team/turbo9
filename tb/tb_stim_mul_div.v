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
// Description: Stimbench: simple simulation of multiply divide algrorithms
//
//////////////////////////////////////////////////////////////////////////////
// History:
// 07.14.2023 - Kevin Phillipson
//   File header added
//
//////////////////////////////////////////////////////////////////////////////
// [TURBO9_HEADER_END]

/////////////////////////////////////////////////////////////////////////////
//                               Test SAU
/////////////////////////////////////////////////////////////////////////////
  `define SAU_CYCLES    10
  reg       mul_div_reset;
  reg       mul_div_en;

task tb_stim_mul_div;

  integer i;

begin
  mul_div_en = 1'b0;
  mul_div_reset = 1'b1;
  for (i=0; i<4; i=i+1) begin
    @ (posedge sys_clk);
  end

  mul_div_reset = 1'b0;
  $display("[TB; tb_stim_mul_div  ] Releasing mul_div_reset...");

  @ (posedge sys_clk);
  mul_div_en = 1'b1;

  @ (posedge sys_clk);
  mul_div_en = 1'b0;

  $display("[TB; tb_stim_mul_div  ] Running clock for %0d cycles", `SAU_CYCLES);
  for (i=0; i<`SAU_CYCLES; i=i+1) begin
    @ (posedge sys_clk);
  end

end
endtask



  /////////////////////////////////////////////////////////////////////////////
  // DUT
  /////////////////////////////////////////////////////////////////////////////
  turbo9_seq_arithmetic_unit I_turbo9_seq_arithmetic_unit
  (
    // Inputs: Clock & Reset
    .CLK_I              (sys_clk),
    .RST_I              (mul_div_reset),
    .STALL_MICROCYCLE_I (1'b0),

    .SAU_EN_I       (mul_div_en),
    .SAU_OP_I       (1'b1),
                       
    .CCR_H_I        (1'b1),
    .CCR_C_I        (1'b0),

    .SAU_ABXY_I     (48'h80ff_0000_0000),

    .SAU_Y_O        (),
    .SAU_DONE_O     (),
    .SAU_C_BIT_O    ()
  );



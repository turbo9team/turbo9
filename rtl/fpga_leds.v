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
// Description: LED interface with PWM dimming
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
module fpga_leds
(
  // Inputs: Clock & Reset
  input CLK_I,
  input RST_I,

  // Inputs 
  input  [7:0] LED_PORT_I,
  
  // Outputs
  output [3:0] LED_O,
  output       LED0_B_O,
  output       LED0_G_O,
  output       LED0_R_O,
  output       LED1_B_O,
  output       LED1_G_O,
  output       LED1_R_O,
  output       LED2_B_O,
  output       LED2_G_O,
  output       LED2_R_O,
  output       LED3_B_O,
  output       LED3_G_O,
  output       LED3_R_O

);

/////////////////////////////////////////////////////////////////////////////



/////////////////////////////////////////////////////////////////////////////
//                             INTERNAL SIGNALS
/////////////////////////////////////////////////////////////////////////////

wire  [7:0] led_pwm;
reg   [7:0] led_pwm_reg;
reg   [19:0] cnt_reg;

/////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////
//                                LOGIC
/////////////////////////////////////////////////////////////////////////////

always @(posedge CLK_I, posedge RST_I) begin
  if (RST_I) begin
    cnt_reg     <= 20'd0;
    led_pwm_reg <= 8'd0;
  end else begin
    cnt_reg     <= cnt_reg + 20'd1;
    led_pwm_reg <= led_pwm;
  end
end
assign led_pwm[7:4] = (cnt_reg[19]    == 1'd0) ? LED_PORT_I[7:4] : 4'h0;
assign led_pwm[3:0] = (cnt_reg[19:12] == 8'd0) ? LED_PORT_I[3:0] : 4'h0;

/////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////
//                             ASSIGN OUTPUTS
/////////////////////////////////////////////////////////////////////////////

assign LED0_B_O = 1'b0;
assign LED1_B_O = 1'b0;
assign LED2_B_O = 1'b0;
assign LED3_B_O = 1'b0;

assign LED0_R_O = 1'b0;
assign LED1_R_O = 1'b0;
assign LED2_R_O = 1'b0;
assign LED3_R_O = 1'b0;

assign LED0_G_O = led_pwm_reg[0];
assign LED1_G_O = led_pwm_reg[1];
assign LED2_G_O = led_pwm_reg[2];
assign LED3_G_O = led_pwm_reg[3];
assign LED_O[0] = led_pwm_reg[4];
assign LED_O[1] = led_pwm_reg[5];
assign LED_O[2] = led_pwm_reg[6];
assign LED_O[3] = led_pwm_reg[7];

/////////////////////////////////////////////////////////////////////////////

endmodule


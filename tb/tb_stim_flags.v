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
// Description: Stimbench: simple simulation of flag logic
//
//////////////////////////////////////////////////////////////////////////////
// History:
// 07.14.2023 - Kevin Phillipson
//   File header added
//
//////////////////////////////////////////////////////////////////////////////
// [TURBO9_HEADER_END]

/////////////////////////////////////////////////////////////////////////////
//                               Test Flags
/////////////////////////////////////////////////////////////////////////////

task tb_stim_flags;

  integer idx_a, idx_b, idx_c;

  reg signed [1:0] s2_a, s2_b, s2_y;
  reg signed [2:0] s3_y;
  reg unsigned [1:0] u2_a, u2_b, u2_y;
  reg unsigned [2:0] u3_y;
  reg cin, vout, cout;

begin
  $display("[TB; tb_stim_flags    ] Signed 2bit Addition");
  s2_a = 0;
  for (idx_a=0; idx_a<4; idx_a=idx_a+1) begin
    s2_b = 0;
    for (idx_b=0; idx_b<4; idx_b=idx_b+1) begin
      cin = 0;
      for (idx_c=0; idx_c<2; idx_c=idx_c+1) begin
        s3_y = {s2_a[1], s2_a} + {s2_b[1], s2_b} + {2'b00, cin};
        {cout, s2_y} = {1'b0, s2_a} + {1'b0, s2_b} + {2'b00, cin};
        //vout = cout^( s2_a[ 1] ^  s2_b[ 1] ^ s2_y[ 1]);
        vout = ( s2_a[ 1] &  s2_b[ 1] & ~s2_y[ 1]) |
               (~s2_a[ 1] & ~s2_b[ 1] &  s2_y[ 1]) ;
        $display("[TB; tb_stim_flags    ] %2d + %2d + %d = %2d (correct: %2d) ; %b + %b + %b = %b FLAG: %b V: %b", s2_a, s2_b, cin, s2_y, s3_y, s2_a, s2_b, cin, s2_y, (s3_y != {s2_y[1], s2_y}), vout);
        cin++;
      end
      s2_b++;
    end
    s2_a++;
  end
  
  $display("[TB; tb_stim_flags    ] ");
  $display("[TB; tb_stim_flags    ] Signed 2bit Subtraction");
  s2_a = 0;
  for (idx_a=0; idx_a<4; idx_a=idx_a+1) begin
    s2_b = 0;
    for (idx_b=0; idx_b<4; idx_b=idx_b+1) begin
      cin = 0;
      for (idx_c=0; idx_c<2; idx_c=idx_c+1) begin
        s3_y = {s2_a[1], s2_a} - {s2_b[1], s2_b} - {2'b00, cin};
        s2_y = s2_a + ~s2_b + {1'b0, ~cin};
        vout = ( s2_a[ 1] & ~s2_b[ 1] & ~s2_y[ 1]) |
               (~s2_a[ 1] &  s2_b[ 1] &  s2_y[ 1]) ;
        $display("[TB; tb_stim_flags    ] %2d - %2d - %d = %2d (correct: %2d) ; %b + %b + %b = %b FLAG: %b V: %b", s2_a, s2_b, cin, s2_y, s3_y, s2_a, s2_b, cin, s2_y, (s3_y != {s2_y[1], s2_y}), vout);
        cin++;
      end
      s2_b++;
    end
    s2_a++;
  end

  $display("[TB; tb_stim_flags    ] ");
  $display("[TB; tb_stim_flags    ] Unsigned 2bit Addition");
  u2_a = 0;
  for (idx_a=0; idx_a<4; idx_a=idx_a+1) begin
    u2_b = 0;
    for (idx_b=0; idx_b<4; idx_b=idx_b+1) begin
      cin = 0;
      for (idx_c=0; idx_c<2; idx_c=idx_c+1) begin
        u3_y = {1'b0, u2_a} + {1'b0, u2_b} + {2'b00, cin};
        u2_y = u2_a + u2_b + {1'b0, cin};
        cout = ( u2_a[ 1] &  u2_b[ 1]            ) |
               (             u2_b[ 1] & ~u2_y[ 1]) |
               ( u2_a[ 1]             & ~u2_y[ 1]) ;
        $display("[TB; tb_stim_flags    ] %2d + %2d + %d = %2d (correct: %2d) ; %b + %b + %b = %b FLAG: %b C: %b", u2_a, u2_b, cin, u2_y, u3_y, u2_a, u2_b, cin, u2_y, (u3_y != {1'b0, u2_y}), cout);
        cin++;
      end
      u2_b++;
    end
    u2_a++;
  end
  
  $display("[TB; tb_stim_flags    ] ");
  $display("[TB; tb_stim_flags    ] Unsigned 2bit Subtraction");
  u2_a = 0;
  for (idx_a=0; idx_a<4; idx_a=idx_a+1) begin
    u2_b = 0;
    for (idx_b=0; idx_b<4; idx_b=idx_b+1) begin
      cin = 0;
      for (idx_c=0; idx_c<2; idx_c=idx_c+1) begin
        u3_y = {1'b0, u2_a} - {1'b0, u2_b} - {2'b00, cin};
        u2_y = u2_a + ~u2_b + {1'b0, ~cin};
        cout = (~u2_a[ 1] &  u2_b[ 1]            ) |
               (             u2_b[ 1] &  u2_y[ 1]) |
               (~u2_a[ 1]             &  u2_y[ 1]) ;
        $display("[TB; tb_stim_flags    ] %2d - %2d - %d = %2d (correct: %2d) ; %b + %b + %b = %b FLAG: %b C: %b", u2_a, u2_b, cin, u2_y, u3_y, u2_a, u2_b, cin, u2_y, (u3_y != {1'b0, u2_y}), cout);
        cin++;
      end
      u2_b++;
    end
    u2_a++;
  end

end
endtask

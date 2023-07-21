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
// Description: Turbo9 with 8-bit pipelined Wishbone memory bus
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
module turbo9
#(
  parameter REGISTER_WB_OUTPUTS = 1
)
(
  // Inputs: Clock & Reset
  input          RST_I,
  input          CLK_I,

  // Inputs
  input    [7:0] DAT_I,
  input    [3:0] TGD_I,
  input          ACK_I,
  input          STALL_I,
  
  // Outputs
  output  [15:0] ADR_O,
  output   [7:0] DAT_O,
  output   [3:0] TGD_O,
  output         WE_O,
  output         STB_O,
  output         CYC_O

);


/////////////////////////////////////////////////////////////////////////////
//                             INTERNAL SIGNALS
/////////////////////////////////////////////////////////////////////////////
//
// This must match the MSB of the *_REG_SEL control vectors
localparam  WIDTH_16 =  1'b0;
localparam  WIDTH_8  =  1'b1;

wire [15:0] dmem_dat_o;   
wire [15:0] dmem_dat_i;  
wire [15:0] dmem_adr_o;   
wire        dmem_busy_i;
wire        dmem_req_o;   
wire        dmem_req_width_o;   
wire        dmem_we_o;
wire        dmem_rd_ack_i;
wire        dmem_wr_ack_i;
wire        dmem_ack_width_i;

wire [15:0] pmem_dat_i;   
wire [15:0] pmem_adr_o;   
wire        pmem_busy_i;  
wire        pmem_rd_req_o;   
wire        pmem_rd_ack_i;

/////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////
//                            CPU ARCHITECTURE
/////////////////////////////////////////////////////////////////////////////
  

  turbo9_pipeline
  #(
    .PMEM_16BIT_EN  (1)
  )
  I_turbo9_pipeline
  (
    // Inputs: Clock & Reset
    .RST_I            (RST_I            ),
    .CLK_I            (CLK_I            ),
    //
    // Data Memory Interface
    .DMEM_DAT_O       (dmem_dat_o       ),
    .DMEM_DAT_I       (dmem_dat_i       ),
    .DMEM_ADR_O       (dmem_adr_o       ),
    .DMEM_BUSY_I      (dmem_busy_i      ),
    .DMEM_REQ_O       (dmem_req_o       ),
    .DMEM_REQ_WIDTH_O (dmem_req_width_o ),
    .DMEM_WE_O        (dmem_we_o        ),
    .DMEM_RD_ACK_I    (dmem_rd_ack_i    ),
    .DMEM_WR_ACK_I    (dmem_wr_ack_i    ),
    .DMEM_ACK_WIDTH_I (dmem_ack_width_i ),
    //
    // Program Memory Interface
    .PMEM_DAT_I       (pmem_dat_i[15:0] ),
    .PMEM_ADR_O       (pmem_adr_o       ),
    .PMEM_BUSY_I      (pmem_busy_i      ),
    .PMEM_RD_REQ_O    (pmem_rd_req_o    ),
    .PMEM_RD_ACK_I    (pmem_rd_ack_i    )
  );


  turbo9_wishbone_8bit
  #(
    .REGISTER_WB_OUTPUTS  (REGISTER_WB_OUTPUTS)
  )
  I_turbo9_wishbone_8bit
  (
    // Inputs: Clock & Reset
    .RST_I            (RST_I            ),
    .CLK_I            (CLK_I            ),
    //                                 
    // External Wishbone Interface     
    .DAT_I            (DAT_I            ),
    .TGD_I            (TGD_I            ),
    .ACK_I            (ACK_I            ),
    .STALL_I          (STALL_I          ),
    .ADR_O            (ADR_O            ),
    .DAT_O            (DAT_O            ),
    .TGD_O            (TGD_O            ),
    .WE_O             (WE_O             ), 
    .STB_O            (STB_O            ),
    .CYC_O            (CYC_O            ),
    //                                 
    // Data Memory Interface           
    .DMEM_DAT_I       (dmem_dat_o       ),
    .DMEM_DAT_O       (dmem_dat_i       ),
    .DMEM_ADR_I       (dmem_adr_o       ),
    .DMEM_BUSY_O      (dmem_busy_i      ),
    .DMEM_REQ_I       (dmem_req_o       ),
    .DMEM_REQ_WIDTH_I (dmem_req_width_o ),
    .DMEM_WE_I        (dmem_we_o        ),
    .DMEM_RD_ACK_O    (dmem_rd_ack_i    ),
    .DMEM_WR_ACK_O    (dmem_wr_ack_i    ),
    .DMEM_ACK_WIDTH_O (dmem_ack_width_i ),
    //
    // Program Memory Interface
    .PMEM_DAT_O       (pmem_dat_i       ),
    .PMEM_ADR_I       (pmem_adr_o       ),
    .PMEM_BUSY_O      (pmem_busy_i      ),
    .PMEM_RD_REQ_I    (pmem_rd_req_o    ),
    .PMEM_REQ_WIDTH_I (WIDTH_16          ),
    .PMEM_RD_ACK_O    (pmem_rd_ack_i    ),
    .PMEM_ACK_WIDTH_O (                 )
  );


/////////////////////////////////////////////////////////////////////////////

endmodule


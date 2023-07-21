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
// Description: The Turbo9 Data Memory Controller for the execute stage
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
module turbo9_data_mem_ctrl
(
  // Inputs: Clock & Reset
  input          RST_I,
  input          CLK_I,
  input          STALL_MICROCYCLE_I, //FIXME using this is not optimal. We want the state machine to start ASAP.

  // Execution Stage Interface
  input    [1:0] DMEM_OP_I,
  output         DMEM_OP_READY_O,
  output  [15:0] DMEM_RD_DATA_REG_O,
  output         DMEM_RD_DATA_READY_O,
  input   [15:0] DMEM_DATA_ALU_Y_I,
  input   [15:0] DMEM_ADDR_ALU_EA_I,

  // Indirect Addressing / 8bit or 16bit Instruction
  input          DATA_WIDTH_I,

  // Data Memory Interface
  output  [15:0] DMEM_DAT_O,
  input   [15:0] DMEM_DAT_I,
  output  [15:0] DMEM_ADR_O,
  input          DMEM_BUSY_I,
  output         DMEM_REQ_O,
  output         DMEM_REQ_WIDTH_O,
  output         DMEM_WE_O,
  input          DMEM_RD_ACK_I,
  input          DMEM_WR_ACK_I,
  input          DMEM_ACK_WIDTH_I

);

/////////////////////////////////////////////////////////////////////////////
//                             INTERNAL SIGNALS
/////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////// DMEM_OP_I defines
//
// Note this encoding is critical.
// MSB is a "one-hot"
localparam  DMEM_OP_IDLE  = 2'b00; // EQU $0
localparam  DMEM_OP_RD    = 2'b10; // EQU $2
localparam  DMEM_OP_WR    = 2'b11; // EQU $3

//////////////////////////////////////// DATA_WIDTH_I defines
//
// This must match the MSB of the *_REG_SEL control vectors
localparam  WIDTH_16 =  1'b0;
localparam  WIDTH_8  =  1'b1;

reg   [15:0] dmem_dat_o_reg;
reg   [15:0] dmem_dat_o_nxt;
localparam   dmem_dat_o_rst = 16'h0000;

reg   [15:0] dmem_adr_o_reg;
reg   [15:0] dmem_adr_o_nxt;
localparam   dmem_adr_o_rst = 16'h0000;

reg          dmem_req_o_reg;
reg          dmem_req_o_nxt;
localparam   dmem_req_o_rst = 1'b0;

reg          dmem_we_o_reg;
reg          dmem_we_o_nxt;
localparam   dmem_we_o_rst = 1'b0;

reg          dmem_req_width_o_reg;
reg          dmem_req_width_o_nxt;
localparam   dmem_req_width_o_rst = WIDTH_8;

reg          dmem_state_reg;
reg          dmem_state_nxt;
localparam   DMEM_STATE_OP_ACCEPT   = 1'b0;
localparam   DMEM_STATE_OP_WAIT     = 1'b1;
localparam   dmem_state_rst = DMEM_STATE_OP_ACCEPT;

reg          dmem_rd_data_ready_reg;
reg          dmem_rd_data_ready_nxt;
localparam   dmem_rd_data_ready_rst = 1'b0;

reg   [15:0] dmem_rd_data_reg;
reg   [15:0] dmem_rd_data_nxt;
localparam   dmem_rd_data_rst = 16'h0000;

/////////////////////////////////////////////////////////////////////////////



/////////////////////////////////////////////////////////////////////////////
//                            NEXT STATE LOGIC
/////////////////////////////////////////////////////////////////////////////
//


always @* begin
  
  // Default State
  dmem_state_nxt        = DMEM_STATE_OP_ACCEPT;

  dmem_dat_o_nxt        = DMEM_DATA_ALU_Y_I;
  dmem_adr_o_nxt        = DMEM_ADDR_ALU_EA_I;
  dmem_req_o_nxt        = 1'b0;
  dmem_we_o_nxt         = 1'b0;
  dmem_req_width_o_nxt  = DATA_WIDTH_I;

  // Next State Logic
  case (dmem_state_reg)
    DMEM_STATE_OP_ACCEPT: begin
      //
      if (~STALL_MICROCYCLE_I) begin //FIXME Using this stall signal is safe but not optimal!!!!
        
        dmem_dat_o_nxt        = DMEM_DATA_ALU_Y_I;
        dmem_adr_o_nxt        = DMEM_ADDR_ALU_EA_I;
        dmem_req_o_nxt        = DMEM_OP_I[1];
        dmem_we_o_nxt         = DMEM_OP_I[0];
        dmem_req_width_o_nxt  = DATA_WIDTH_I;

        if (DMEM_BUSY_I) begin
          dmem_state_nxt = DMEM_STATE_OP_WAIT;
        end else begin
          dmem_state_nxt = DMEM_STATE_OP_ACCEPT;
        end

      end else begin
        dmem_state_nxt = DMEM_STATE_OP_ACCEPT;
      end
    end
    //
    DMEM_STATE_OP_WAIT: begin
        dmem_dat_o_nxt        = dmem_dat_o_reg;
        dmem_adr_o_nxt        = dmem_adr_o_reg;
        dmem_req_o_nxt        = dmem_req_o_reg;
        dmem_we_o_nxt         = dmem_we_o_reg;
        dmem_req_width_o_nxt  = dmem_req_width_o_reg;

        if (DMEM_BUSY_I) begin
          dmem_state_nxt = DMEM_STATE_OP_WAIT;
        end else begin
          dmem_state_nxt = DMEM_STATE_OP_ACCEPT;
        end
    end
    //
  endcase
end
/////////////////////////////////////////////////////////////////////////////



/////////////////////////////////////////////////////////////////////////////
//               MEMORY ACCESS TAG FIFO & WISHBONE OUTPUT REGISTERS
/////////////////////////////////////////////////////////////////////////////
//

always @(posedge CLK_I, posedge RST_I) begin
  if (RST_I) begin

    dmem_dat_o_reg         <= dmem_dat_o_rst;
    dmem_adr_o_reg         <= dmem_adr_o_rst;
    dmem_req_o_reg         <= dmem_req_o_rst;
    dmem_we_o_reg          <= dmem_we_o_rst;
    dmem_req_width_o_reg   <= dmem_req_width_o_rst;
                          
    dmem_state_reg         <= dmem_state_rst;

    dmem_rd_data_ready_reg <= dmem_rd_data_ready_rst;
    dmem_rd_data_reg       <= dmem_rd_data_rst;

  end else begin

    dmem_dat_o_reg        <= dmem_dat_o_nxt;
    dmem_adr_o_reg        <= dmem_adr_o_nxt;
    dmem_req_o_reg        <= dmem_req_o_nxt;
    dmem_we_o_reg         <= dmem_we_o_nxt;
    dmem_req_width_o_reg  <= dmem_req_width_o_nxt;

    dmem_state_reg        <= dmem_state_nxt;

    if (DMEM_RD_ACK_I) begin
      dmem_rd_data_ready_reg <= 1'b1;
    end else if (dmem_req_o_nxt & ~dmem_we_o_nxt) begin
      dmem_rd_data_ready_reg <= 1'b0;
    end

    if (DMEM_RD_ACK_I) begin
      dmem_rd_data_reg       <= DMEM_DAT_I;
    end
 
  end
end

//
/////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////
//                             ASSIGN OUTPUTS
/////////////////////////////////////////////////////////////////////////////
// Data Memory Interface
//
assign DMEM_OP_READY_O      = ~((dmem_state_reg == DMEM_STATE_OP_WAIT) & DMEM_OP_I[1]);
assign DMEM_RD_DATA_REG_O   = dmem_rd_data_reg;
assign DMEM_RD_DATA_READY_O = dmem_rd_data_ready_reg;

assign DMEM_DAT_O       =  dmem_dat_o_nxt;
assign DMEM_ADR_O       =  dmem_adr_o_nxt;
assign DMEM_REQ_O       =  dmem_req_o_nxt;
assign DMEM_REQ_WIDTH_O =  dmem_req_width_o_nxt;
assign DMEM_WE_O        =  dmem_we_o_nxt;

/////////////////////////////////////////////////////////////////////////////

endmodule




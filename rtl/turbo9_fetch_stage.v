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
// Description: Turbo9 Fetch Stage
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
module turbo9_fetch_stage
#(
  parameter PMEM_16BIT_EN = 1
)
(
  // Inputs: Clock & Reset
  input  RST_I,
  input  CLK_I,

  // Fetch Stage Interface
  input   [15:0] FET_DEC_PC_I,
  input          FET_DEC_LOAD_PC_I,
  input          FET_DEC_INSTR_RD_EN_I,
  input    [2:0] FET_DEC_INSTR_LEN_I,

  output  [15:0] FET_DEC_NXT_PC_O,
  output   [2:0] FET_DEC_REG_QUEUE_LVL_O,
  output   [7:0] FET_DEC_REG_QUEUE_D3_O,
  output   [7:0] FET_DEC_REG_QUEUE_D2_O,
  output   [7:0] FET_DEC_REG_QUEUE_D1_O,
  output   [7:0] FET_DEC_REG_QUEUE_D0_O,
  output         FET_DEC_REG_PREBYTE_EN_O,

  // Program Memory Interface
  input   [((PMEM_16BIT_EN*8)+7):0] PMEM_DAT_I,
  output  [15:0] PMEM_ADR_O,
  input          PMEM_BUSY_I,
  output         PMEM_RD_REQ_O,
  input          PMEM_RD_ACK_I

);

/////////////////////////////////////////////////////////////////////////////
//                             INTERNAL SIGNALS
/////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////// WIDTH_I defines
//
// This must match the MSB of the *_REG_SEL control vectors
localparam  WIDTH_16 =  1'b0;
localparam  WIDTH_8  =  1'b1;
localparam  QUEUE_SIZE  = 4'd6;

reg         fetch_state_reg;
reg         fetch_state_nxt;
localparam  FETCH_LOAD_QUEUE_STATE = 1'b0;
localparam  FETCH_FLUSH_ACKS_STATE = 1'b1;

wire   [2:0] ack_pending_add_a;
wire   [2:0] ack_pending_add_b;
wire   [2:0] ack_pending_add_y;
wire   [2:0] ack_pending_nxt;
reg    [2:0] ack_pending_reg;
localparam   ack_pending_rst = 3'b000;

wire         ack_1_pending_nxt;
reg          ack_1_pending_reg;
localparam   ack_1_pending_rst = 1'b0;

wire         ack_0_pending_nxt;
reg          ack_0_pending_reg;
localparam   ack_0_pending_rst = 1'b1;

wire   [2:0] ack_to_flush_add_a;
wire   [2:0] ack_to_flush_add_b;
wire   [2:0] ack_to_flush_add_y;
wire   [2:0] ack_to_flush_nxt;
reg    [2:0] ack_to_flush_reg;
localparam   ack_to_flush_rst = 3'b000;

reg          queue_wr_en;
wire   [2:0] queue_rd_len;
wire   [2:0] queue_reject_len;

wire   [3:0] pc_offset_add_a;
wire   [3:0] pc_offset_add_b;
wire   [3:0] pc_offset_add_c;
wire   [3:0] pc_offset_add_d;
wire   [3:0] pc_offset_add_y;
wire   [3:0] pc_offset_nxt;
reg    [3:0] pc_offset_reg;
localparam   pc_offset_rst = 4'b0000;

wire  [15:0] pc_base_add_a;
wire  [15:0] pc_base_add_b;
wire  [15:0] pc_base_add_y;
wire  [15:0] pc_base_nxt;
reg   [15:0] pc_base_reg;
localparam   pc_base_rst = 16'h0000;

wire  [15:0] pmem_adr_add_a;
wire  [15:0] pmem_adr_add_b;
wire  [15:0] pmem_adr_add_y; 

wire  [3:0]  pmem_rd_len;

wire  pmem_rd_en;
wire  pmem_rd_req;
reg   flush_ack;
/////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////
//                             LOGIC
/////////////////////////////////////////////////////////////////////////////
//
// Program Memory Interface Logic
assign pmem_rd_req         = (pc_offset_reg <= QUEUE_SIZE) | FET_DEC_LOAD_PC_I;
assign pmem_rd_en          = pmem_rd_req & ~PMEM_BUSY_I;

generate
  if (PMEM_16BIT_EN) begin
    assign pmem_rd_len         = 4'h2;
  end else begin
    assign pmem_rd_len         = 4'h1;
  end
endgenerate

assign PMEM_RD_REQ_O       = pmem_rd_req;
//                       
// QUEUE Read Length     
assign queue_rd_len        = (FET_DEC_INSTR_RD_EN_I) ? FET_DEC_INSTR_LEN_I :
                                                       3'b000              ;
//                       
// Program Counter Base Register
assign pc_base_add_a       = pc_base_reg ;
assign pc_base_add_b       = {13'd0, queue_rd_len};
assign pc_base_add_y       = pc_base_add_a + pc_base_add_b;
assign pc_base_nxt         = (FET_DEC_LOAD_PC_I) ? FET_DEC_PC_I  :
                                                   pc_base_add_y ;
assign FET_DEC_NXT_PC_O    = pc_base_nxt;
//                      
// Program Memory Address Calculation
assign pmem_adr_add_a      = pc_base_reg;
assign pmem_adr_add_b      = {12'h000, pc_offset_reg} ;
assign pmem_adr_add_y      = pmem_adr_add_a + pmem_adr_add_b; 
assign PMEM_ADR_O          = (FET_DEC_LOAD_PC_I) ? FET_DEC_PC_I   :
                                                   pmem_adr_add_y ;
//                      
// Program Counter Offset Calculation
assign pc_offset_add_a     = pc_offset_reg ;
assign pc_offset_add_b     = {1'b0, queue_rd_len};
assign pc_offset_add_c     = (pmem_rd_en) ? pmem_rd_len : 4'h0;
assign pc_offset_add_d     = {1'b0, queue_reject_len};
assign pc_offset_add_y     = pc_offset_add_a - pc_offset_add_b + pc_offset_add_c - pc_offset_add_d;
assign pc_offset_nxt       = (FET_DEC_LOAD_PC_I) ? pc_offset_add_c :
                                                   pc_offset_add_y ;
//
// Pending Read Acknowledgment Tracking Logic
assign ack_pending_add_a   = ack_pending_reg;
assign ack_pending_add_b   = ( pmem_rd_en & ~PMEM_RD_ACK_I) ? 3'b001 : //Inc
                             (~pmem_rd_en &  PMEM_RD_ACK_I) ? 3'b111 : //Dec
                                                              3'b000 ; //Hold
assign ack_pending_add_y   = ack_pending_add_a + ack_pending_add_b;
assign ack_pending_nxt     = ack_pending_add_y;
assign ack_1_pending_nxt   = (ack_pending_add_y == 3'b001);
assign ack_0_pending_nxt   = (ack_pending_add_y == 3'b000);
//
// Number Pending Ack's to Flush Logic
assign ack_to_flush_add_a  = (FET_DEC_LOAD_PC_I) ? ack_pending_reg  :
                                                   ack_to_flush_reg ;
assign ack_to_flush_add_b  = (FET_DEC_LOAD_PC_I & PMEM_RD_ACK_I) ? 3'b111 : //Dec
                             (flush_ack)                         ? 3'b111 : //Dec
                                                                   3'b000 ; //Hold
assign ack_to_flush_add_y  = ack_to_flush_add_a + ack_to_flush_add_b;
assign ack_to_flush_nxt    = ack_to_flush_add_y ;
//
// Load Queue / Flush Acks State Machine
always @* begin
  //
  // State Default
  fetch_state_nxt = FETCH_LOAD_QUEUE_STATE;
  //
  // Control Logic Default
  queue_wr_en = 1'b0;
  flush_ack  = 1'b0;
  //
  // Next State Logic
  case (fetch_state_reg)
    //
    FETCH_LOAD_QUEUE_STATE: begin
     //if (FET_DEC_LOAD_PC_I && (ack_pending_nxt != 3'b000)) begin
     //if (FET_DEC_LOAD_PC_I && ~((ack_pending_reg[2:1] == 2'b00) && (~ack_pending_reg[0] | PMEM_RD_ACK_I))) begin
     if (FET_DEC_LOAD_PC_I && ~(ack_0_pending_reg | (ack_1_pending_reg & PMEM_RD_ACK_I))) begin
     // ^ Fancy way to do (FET_DEC_LOAD_PC_I && ack_to_flush_nxt != 0), better
     // for timing closure
        fetch_state_nxt = FETCH_FLUSH_ACKS_STATE;
      end else begin
        fetch_state_nxt = FETCH_LOAD_QUEUE_STATE;
      end
      // If there are 0 ACKS pending and we recieve an ACK during
      // a LOAD_PC request, we have a latency of zero (async bus),
      // so allow the write. Otherwise block the write.
      //queue_wr_en = PMEM_RD_ACK_I & (ack_0_pending_reg|~FET_DEC_LOAD_PC_I);
      if (FET_DEC_LOAD_PC_I) begin
        queue_wr_en = PMEM_RD_ACK_I & ack_0_pending_reg;
      end else begin
        queue_wr_en = PMEM_RD_ACK_I;
      end
      //
      flush_ack = 1'b0;
    end
    //
    FETCH_FLUSH_ACKS_STATE: begin
      if (ack_to_flush_nxt == 3'b000) begin
        fetch_state_nxt = FETCH_LOAD_QUEUE_STATE;
      end else begin
        fetch_state_nxt = FETCH_FLUSH_ACKS_STATE;
      end
      queue_wr_en = 1'b0;
      flush_ack  = PMEM_RD_ACK_I;
    end
  endcase
end
/////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////
//                                REGISTERS
/////////////////////////////////////////////////////////////////////////////
//
always @(posedge CLK_I, posedge RST_I) begin
  if (RST_I) begin
    //
    pc_base_reg       <= pc_base_rst;
    fetch_state_reg   <= FETCH_LOAD_QUEUE_STATE;
    pc_offset_reg     <= pc_offset_rst;   
    ack_pending_reg   <= ack_pending_rst;
    ack_1_pending_reg <= ack_1_pending_rst;
    ack_0_pending_reg <= ack_0_pending_rst;
    ack_to_flush_reg  <= ack_to_flush_rst;
    //
  end else begin
    //
    pc_base_reg       <= pc_base_nxt;
    fetch_state_reg   <= fetch_state_nxt;
    pc_offset_reg     <= pc_offset_nxt;   
    ack_pending_reg   <= ack_pending_nxt;
    ack_1_pending_reg <= ack_1_pending_nxt;
    ack_0_pending_reg <= ack_0_pending_nxt;
    ack_to_flush_reg  <= ack_to_flush_nxt;
    //
  end
end
//
/////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////
//                             QUEUE BLOCK
/////////////////////////////////////////////////////////////////////////////
//


turbo9_fetch_queue
#(
  .ENABLE_16BIT   (PMEM_16BIT_EN),
  .SIZE           (QUEUE_SIZE)
)
I_turbo9_fetch_queue
(
  .RST_I              (RST_I                   ),
  .CLK_I              (CLK_I                   ),
  .QUEUE_RD_LEN_I     (queue_rd_len            ),
  .QUEUE_FLUSH_I      (FET_DEC_LOAD_PC_I       ),
  .QUEUE_WR_EN_I      (queue_wr_en             ),
  .QUEUE_DAT_I        (PMEM_DAT_I              ),
  .QUEUE_LEVEL_O      (FET_DEC_REG_QUEUE_LVL_O ),
  .QUEUE_REJECT_LEN_O (queue_reject_len        ),
  .QUEUE_DATA_3_O     (FET_DEC_REG_QUEUE_D3_O  ),
  .QUEUE_DATA_2_O     (FET_DEC_REG_QUEUE_D2_O  ),
  .QUEUE_DATA_1_O     (FET_DEC_REG_QUEUE_D1_O  ),
  .QUEUE_DATA_0_O     (FET_DEC_REG_QUEUE_D0_O  ),
  .PREBYTE_EN_O       (FET_DEC_REG_PREBYTE_EN_O)
);

/////////////////////////////////////////////////////////////////////////////


endmodule


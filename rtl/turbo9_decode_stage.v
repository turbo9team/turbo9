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
// Description: Turbo9 Decode Stage
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
module turbo9_decode_stage
(
  // Inputs: Clock & Reset
  input  RST_I,
  input  CLK_I,
  //                                                                              
  // Decode Execute Control Interface
  output        DEC_EXE_STALL_MICROCYCLE_O,
  input         DEC_EXE_DMEM_OP_READY_I,
  input         DEC_EXE_REGISTER_ARRAY_READY_I,
  input         DEC_EXE_MICRO_SEQ_COND_I,
  output        DEC_EXE_NEXT_INSTR_ACK_O,
  output [15:0] DEC_EXE_NXT_PC_O,
  input         DEC_EXE_NEW_PC_WR_EN_I,
  input  [15:0] DEC_EXE_NEW_PC_I,
  // 
  // Micro-Op
  output  [3:0] DEC_EXE_UOP_DATA_ALU_A_SEL_O,
  output  [3:0] DEC_EXE_UOP_DATA_ALU_B_SEL_O,
  output  [3:0] DEC_EXE_UOP_DATA_ALU_WR_SEL_O,
  output  [3:0] DEC_EXE_UOP_ADDR_ALU_REG_SEL_O,
  output  [3:0] DEC_EXE_UOP_ADDR_ALU_OFFSET_SEL_O,
  output        DEC_EXE_UOP_ADDR_ALU_EA_OP_O,
  output        DEC_EXE_UOP_ADDR_ALU_EA_WR_EN_O,
  output        DEC_EXE_UOP_ADDR_ALU_Y_OP_O,
  output  [2:0] DEC_EXE_UOP_DATA_ALU_OP_O,
  output  [3:0] DEC_EXE_UOP_CCR_OP_O,
  output  [1:0] DEC_EXE_UOP_DATA_ALU_COND_SEL_O,
  output  [3:0] DEC_EXE_UOP_MICRO_SEQ_COND_SEL_O,
  output  [1:0] DEC_EXE_UOP_DMEM_OP_O,
  output        DEC_EXE_UOP_DATA_WIDTH_O,
  output        DEC_EXE_UOP_DATA_ALU_SAU_EN_O,
  output  [3:0] DEC_EXE_UOP_DATA_ALU_SAU_OP_O,
  output        DEC_EXE_UOP_IDX_INDIRECT_EN_O,
  output  [3:0] DEC_EXE_UOP_BRANCH_SEL_O,
  output [15:0] DEC_EXE_UOP_DATA_O,
  output        DEC_EXE_UOP_DIRECT_EN_O,
  output        DEC_EXE_UOP_STACK_DONE_O,

  // Fetch/Decode Interface
  output [15:0] FET_DEC_PC_O,
  output        FET_DEC_LOAD_PC_O,
  output        FET_DEC_INSTR_RD_EN_O,
  output  [2:0] FET_DEC_INSTR_LEN_O,
  //
  input  [15:0] FET_DEC_NXT_PC_I,
  input   [2:0] FET_DEC_REG_QUEUE_LVL_I,
  input   [7:0] FET_DEC_REG_QUEUE_D3_I,
  input   [7:0] FET_DEC_REG_QUEUE_D2_I,
  input   [7:0] FET_DEC_REG_QUEUE_D1_I,
  input   [7:0] FET_DEC_REG_QUEUE_D0_I,
  input         FET_DEC_REG_PREBYTE_EN_I
);

/////////////////////////////////////////////////////////////////////////////
//                             INTERNAL SIGNALS
/////////////////////////////////////////////////////////////////////////////
wire   [2:0] instr_len;
wire         instr_len_valid;

wire         microcycle_start;
wire         next_instr_req;

wire         stall_microcycle;

reg          next_instr_ack;
reg          decode_ready;

wire   [7:0] jump_table_a;
wire   [7:0] jump_table_b;
wire  [15:0] instr_data;
wire         instr_direct_en;
wire         instr_inh_en;
wire   [3:0] instr_r1_sel;
wire   [3:0] instr_r2_sel;
wire   [3:0] instr_ar_sel;

reg          fet_dec_load_pc;

reg          page_sel_load;
reg          page_sel_clear;
reg    [1:0] page_sel_reg;
localparam   page_sel_rst = 2'b00;

/////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////
//                          DECODE CONTROL LOGIC
/////////////////////////////////////////////////////////////////////////////

assign instr_len_valid = (FET_DEC_REG_QUEUE_LVL_I >= instr_len); //FIXME optimize this path. Register instr_len!

assign stall_microcycle = ~(decode_ready & DEC_EXE_DMEM_OP_READY_I & DEC_EXE_REGISTER_ARRAY_READY_I);

always @* begin
  if (next_instr_req) begin
    if (DEC_EXE_NEW_PC_WR_EN_I & microcycle_start) begin
      //
      // Execute state is ready for next instruction but the PC was updated
      // (JUMP, BRANCH, etc)
      decode_ready      = 1'b0; // decode stage not ready
      next_instr_ack    = 1'b0;      
      fet_dec_load_pc   = 1'b1; // update fetch stage w/ new PC & flush instr queue
      page_sel_load     = 1'b0;
      page_sel_clear    = 1'b1;
      //
    end else if (instr_len_valid) begin
      //
      // Execute stage ready for next instruction & instruction is decoded
      decode_ready      = 1'b1; // decode stage ready
      next_instr_ack    = 1'b1; // update execute stage w/ next PC
                                // read next instruction from instruction queue
      fet_dec_load_pc   = 1'b0;
      if (FET_DEC_REG_PREBYTE_EN_I && ~page_sel_reg[1]) begin
        page_sel_load     = 1'b1; // decode prebyte in page_sel_reg
        page_sel_clear    = 1'b0;
      end else begin
        page_sel_load     = 1'b0;
        page_sel_clear    = 1'b1; // clear page_sel for next instr
      end
      //
    end else begin
      //
      // Execute stage ready for next instruction & instruction is NOT decoded
      decode_ready      = 1'b0; // decode stage not ready
      next_instr_ack    = 1'b0;
      fet_dec_load_pc   = 1'b0;
      page_sel_load     = 1'b0;
      page_sel_clear    = 1'b0;
      //
    end
  end else begin
    //
    // Execute stage NOT ready for next instruction
    decode_ready      = 1'b1; // no need to stall the execute stage
    next_instr_ack    = 1'b0;
    fet_dec_load_pc   = 1'b0;
    if (instr_len_valid && FET_DEC_REG_PREBYTE_EN_I && ~page_sel_reg[1]) begin
      page_sel_load     = 1'b1; // decode prebyte in page_sel_reg
    end else begin
      page_sel_load     = 1'b0;
    end
    page_sel_clear    = 1'b0;
  end
end

always @(posedge CLK_I, posedge RST_I) begin
  if (RST_I) begin
    //
    page_sel_reg  <= page_sel_rst;
    //
  end else begin
    //
    if (page_sel_load) begin
      page_sel_reg  <= {1'b1, FET_DEC_REG_QUEUE_D0_I[0]};
    end else if (page_sel_clear) begin
      page_sel_reg  <= page_sel_rst;
    end
    //
  end
end



/////////////////////////////////////////////////////////////////////////////



/////////////////////////////////////////////////////////////////////////////
//                             DECODE BLOCKS
/////////////////////////////////////////////////////////////////////////////
//

turbo9_instr_format_decode I_turbo9_instr_format_decode
(
  // Instruction Queue
  .QUEUE_D3_I            (FET_DEC_REG_QUEUE_D3_I ),
  .QUEUE_D2_I            (FET_DEC_REG_QUEUE_D2_I ),
  .QUEUE_D1_I            (FET_DEC_REG_QUEUE_D1_I ),
  .QUEUE_D0_I            (FET_DEC_REG_QUEUE_D0_I ),
  .PAGE_SEL_I            (page_sel_reg           ),

  // Instruction Length
  .INSTR_LEN_O           (instr_len              ),
                                                 
  // Decoded Instruction                         
  .INSTR_DATA_O          (instr_data             ),
  .INSTR_DIRECT_EN_O     (instr_direct_en        ),
  .INSTR_INH_EN_O        (instr_inh_en           ),
  .INSTR_R1_SEL_O        (instr_r1_sel           ),
  .INSTR_R2_SEL_O        (instr_r2_sel           ),
  .INSTR_AR_SEL_O        (instr_ar_sel           ),
  .INSTR_JUMP_TABLE_A_O  (jump_table_a           ),
  .INSTR_JUMP_TABLE_B_O  (jump_table_b           )
);

turbo9_uop_generator I_turbo9_uop_generator
(
  // Inputs: Clock & Reset
  .RST_I                       (RST_I                            ),
  .CLK_I                       (CLK_I                            ),
                                                         
  // Control Interface                                   
  .MICROCYCLE_START_O          (microcycle_start                 ),
  .NEXT_INSTR_REQ_O            (next_instr_req                   ),
  .STALL_MICROCYCLE_I          (stall_microcycle                 ),
  .MICRO_SEQ_COND_I            (DEC_EXE_MICRO_SEQ_COND_I         ),
  .NEXT_INSTR_ACK_I            (next_instr_ack                   ),

  // Instruction Queue
  //.QUEUE_D2_I                  (FET_DEC_REG_QUEUE_D2_I           ),
  .QUEUE_D1_I                  (FET_DEC_REG_QUEUE_D1_I           ),
  .QUEUE_D0_I                  (FET_DEC_REG_QUEUE_D0_I           ),
  .PAGE_SEL_I                  (page_sel_reg                     ),

  // Decoded Instruction                                        
  .INSTR_DATA_I                (instr_data                       ),
  .INSTR_DIRECT_EN_I           (instr_direct_en                  ),
  .INSTR_INH_EN_I              (instr_inh_en                     ),
  .INSTR_R1_SEL_I              (instr_r1_sel                     ),
  .INSTR_R2_SEL_I              (instr_r2_sel                     ),
  .INSTR_AR_SEL_I              (instr_ar_sel                     ),
  .INSTR_JUMP_TABLE_A_I        (jump_table_a                     ),
  .INSTR_JUMP_TABLE_B_I        (jump_table_b                     ),

  // Micro-Op
  .UOP_MICRO_SEQ_OP_O          (                                 ),
  .UOP_MICRO_SEQ_BRANCH_ADDR_O (                                 ),
  .UOP_DATA_ALU_A_SEL_O        (DEC_EXE_UOP_DATA_ALU_A_SEL_O     ),
  .UOP_DATA_ALU_B_SEL_O        (DEC_EXE_UOP_DATA_ALU_B_SEL_O     ),
  .UOP_DATA_ALU_WR_SEL_O       (DEC_EXE_UOP_DATA_ALU_WR_SEL_O    ),
  .UOP_ADDR_ALU_REG_SEL_O      (DEC_EXE_UOP_ADDR_ALU_REG_SEL_O   ),
  .UOP_ADDR_ALU_OFFSET_SEL_O   (DEC_EXE_UOP_ADDR_ALU_OFFSET_SEL_O),
  .UOP_ADDR_ALU_EA_OP_O        (DEC_EXE_UOP_ADDR_ALU_EA_OP_O     ),
  .UOP_ADDR_ALU_EA_WR_EN_O     (DEC_EXE_UOP_ADDR_ALU_EA_WR_EN_O  ),
  .UOP_ADDR_ALU_Y_OP_O         (DEC_EXE_UOP_ADDR_ALU_Y_OP_O      ),
  .UOP_DATA_ALU_OP_O           (DEC_EXE_UOP_DATA_ALU_OP_O        ),
  .UOP_CCR_OP_O                (DEC_EXE_UOP_CCR_OP_O             ),
  .UOP_DATA_ALU_COND_SEL_O     (DEC_EXE_UOP_DATA_ALU_COND_SEL_O  ),
  .UOP_MICRO_SEQ_COND_SEL_O    (DEC_EXE_UOP_MICRO_SEQ_COND_SEL_O ),
  .UOP_DMEM_OP_O               (DEC_EXE_UOP_DMEM_OP_O            ),
  .UOP_DATA_WIDTH_O            (DEC_EXE_UOP_DATA_WIDTH_O         ),
  .UOP_DATA_ALU_SAU_EN_O       (DEC_EXE_UOP_DATA_ALU_SAU_EN_O    ),
  .UOP_DATA_ALU_SAU_OP_O       (DEC_EXE_UOP_DATA_ALU_SAU_OP_O    ),
  .UOP_IDX_INDIRECT_EN_O       (DEC_EXE_UOP_IDX_INDIRECT_EN_O    ),
  .UOP_BRANCH_SEL_O            (DEC_EXE_UOP_BRANCH_SEL_O         ),
  .UOP_DATA_O                  (DEC_EXE_UOP_DATA_O               ),
  .UOP_DIRECT_EN_O             (DEC_EXE_UOP_DIRECT_EN_O          ),
  .UOP_JUMP_TABLE_B_O          (                                 ),
  .UOP_STACK_DONE_O            (DEC_EXE_UOP_STACK_DONE_O         )
);
//
/////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////
//                            ASSIGN OUTPUTS
/////////////////////////////////////////////////////////////////////////////
//

assign DEC_EXE_STALL_MICROCYCLE_O   = stall_microcycle;
assign DEC_EXE_NXT_PC_O             = FET_DEC_NXT_PC_I;
assign DEC_EXE_NEXT_INSTR_ACK_O     = next_instr_ack;

assign FET_DEC_LOAD_PC_O     = fet_dec_load_pc;
assign FET_DEC_PC_O          = DEC_EXE_NEW_PC_I;
assign FET_DEC_INSTR_RD_EN_O = (next_instr_ack & ~stall_microcycle) | page_sel_load;
assign FET_DEC_INSTR_LEN_O   = instr_len;

/////////////////////////////////////////////////////////////////////////////


endmodule


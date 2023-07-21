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
// Description: Turbo9 pipeline with generic memory interface with 16-bit
// program memory bus and 16-bit data memory bus
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
module turbo9_pipeline
#(
  parameter PMEM_16BIT_EN = 1
)
(
  // Inputs: Clock & Reset
  input          RST_I,
  input          CLK_I,
  //                                 
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
  input          DMEM_ACK_WIDTH_I,
  //
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

wire [15:0] fet_dec_pc;
wire        fet_dec_load_pc;
wire        fet_dec_instr_rd_en;
wire  [2:0] fet_dec_instr_len;

wire [15:0] fet_dec_nxt_pc;
wire  [2:0] fet_dec_reg_queue_lvl;
wire  [7:0] fet_dec_reg_queue_d3;
wire  [7:0] fet_dec_reg_queue_d2;
wire  [7:0] fet_dec_reg_queue_d1;
wire  [7:0] fet_dec_reg_queue_d0;
wire        fet_dec_reg_prebyte_en;

wire  [3:0] dec_exe_uop_data_alu_a_sel;
wire  [3:0] dec_exe_uop_data_alu_b_sel;
wire  [3:0] dec_exe_uop_data_alu_wr_sel;
wire  [3:0] dec_exe_uop_addr_alu_reg_sel;
wire  [3:0] dec_exe_uop_addr_alu_offset_sel;
wire        dec_exe_uop_addr_alu_ea_op;
wire        dec_exe_uop_addr_alu_ea_wr_en;
wire        dec_exe_uop_addr_alu_y_op;
wire  [2:0] dec_exe_uop_data_alu_op;
wire  [3:0] dec_exe_uop_ccr_op;
wire  [1:0] dec_exe_uop_data_alu_cond_sel;
wire  [3:0] dec_exe_uop_micro_seq_cond_sel;
wire  [1:0] dec_exe_uop_dmem_op;
wire        dec_exe_uop_data_width;
wire        dec_exe_uop_data_alu_sau_en;
wire  [3:0] dec_exe_uop_data_alu_sau_op;
wire        dec_exe_uop_idx_indirect_en;
wire  [3:0] dec_exe_uop_branch_sel;
wire [15:0] dec_exe_uop_data;
wire        dec_exe_uop_direct_en;
wire        dec_exe_uop_stack_done;

wire        dec_exe_stall_microcycle;
wire        dec_exe_dmem_op_ready;
wire        dec_exe_register_array_ready;
wire        dec_exe_micro_seq_cond;
wire        dec_exe_next_instr_ack;
wire [15:0] dec_exe_nxt_pc;
wire        dec_exe_new_pc_wr_en;
wire [15:0] dec_exe_new_pc;


/////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////
//                       Turbo9 Microprocessor Pipeline
/////////////////////////////////////////////////////////////////////////////


  //////////////////////////////////////// Fetch Stage
  turbo9_fetch_stage
  #(
    .PMEM_16BIT_EN  (PMEM_16BIT_EN)
  )
  I_turbo9_fetch_stage
  (
    // Inputs: Clock & Reset
    .RST_I                    (RST_I                  ),
    .CLK_I                    (CLK_I                  ),
    //                                                
    // Fetch/Decode Interface                         
    .FET_DEC_PC_I             (fet_dec_pc             ),
    .FET_DEC_LOAD_PC_I        (fet_dec_load_pc        ),
    .FET_DEC_INSTR_RD_EN_I    (fet_dec_instr_rd_en    ),
    .FET_DEC_INSTR_LEN_I      (fet_dec_instr_len      ),
    //                                                
    .FET_DEC_NXT_PC_O         (fet_dec_nxt_pc         ),
    .FET_DEC_REG_QUEUE_LVL_O  (fet_dec_reg_queue_lvl  ),
    .FET_DEC_REG_QUEUE_D3_O   (fet_dec_reg_queue_d3   ),
    .FET_DEC_REG_QUEUE_D2_O   (fet_dec_reg_queue_d2   ),
    .FET_DEC_REG_QUEUE_D1_O   (fet_dec_reg_queue_d1   ),
    .FET_DEC_REG_QUEUE_D0_O   (fet_dec_reg_queue_d0   ),
    .FET_DEC_REG_PREBYTE_EN_O (fet_dec_reg_prebyte_en ),
    //                                                
    // Program Memory Interface
    .PMEM_DAT_I               (PMEM_DAT_I             ),
    .PMEM_ADR_O               (PMEM_ADR_O             ),
    .PMEM_BUSY_I              (PMEM_BUSY_I            ),
    .PMEM_RD_REQ_O            (PMEM_RD_REQ_O          ),
    .PMEM_RD_ACK_I            (PMEM_RD_ACK_I          )
  );

  

  //////////////////////////////////////// Decode Stage
  turbo9_decode_stage I_turbo9_decode_stage
  (
    // Inputs: Clock & Reset
    .RST_I                               (RST_I                          ),
    .CLK_I                               (CLK_I                          ),
    //                                                                           
    // Decode Execute Control Interface
    .DEC_EXE_STALL_MICROCYCLE_O          (dec_exe_stall_microcycle       ),
    .DEC_EXE_DMEM_OP_READY_I             (dec_exe_dmem_op_ready          ),
    .DEC_EXE_REGISTER_ARRAY_READY_I      (dec_exe_register_array_ready   ),
    .DEC_EXE_MICRO_SEQ_COND_I            (dec_exe_micro_seq_cond         ),
    .DEC_EXE_NEXT_INSTR_ACK_O            (dec_exe_next_instr_ack         ),
    .DEC_EXE_NXT_PC_O                    (dec_exe_nxt_pc                 ),
    .DEC_EXE_NEW_PC_WR_EN_I              (dec_exe_new_pc_wr_en           ),
    .DEC_EXE_NEW_PC_I                    (dec_exe_new_pc                 ),
    // 
    // Micro-Op
    .DEC_EXE_UOP_DATA_ALU_A_SEL_O        (dec_exe_uop_data_alu_a_sel     ),
    .DEC_EXE_UOP_DATA_ALU_B_SEL_O        (dec_exe_uop_data_alu_b_sel     ),
    .DEC_EXE_UOP_DATA_ALU_WR_SEL_O       (dec_exe_uop_data_alu_wr_sel    ),
    .DEC_EXE_UOP_ADDR_ALU_REG_SEL_O      (dec_exe_uop_addr_alu_reg_sel   ),
    .DEC_EXE_UOP_ADDR_ALU_OFFSET_SEL_O   (dec_exe_uop_addr_alu_offset_sel),
    .DEC_EXE_UOP_ADDR_ALU_EA_OP_O        (dec_exe_uop_addr_alu_ea_op     ),
    .DEC_EXE_UOP_ADDR_ALU_EA_WR_EN_O     (dec_exe_uop_addr_alu_ea_wr_en  ),
    .DEC_EXE_UOP_ADDR_ALU_Y_OP_O         (dec_exe_uop_addr_alu_y_op      ),
    .DEC_EXE_UOP_DATA_ALU_OP_O           (dec_exe_uop_data_alu_op        ),
    .DEC_EXE_UOP_CCR_OP_O                (dec_exe_uop_ccr_op             ),
    .DEC_EXE_UOP_DATA_ALU_COND_SEL_O     (dec_exe_uop_data_alu_cond_sel  ),
    .DEC_EXE_UOP_MICRO_SEQ_COND_SEL_O    (dec_exe_uop_micro_seq_cond_sel ),
    .DEC_EXE_UOP_DMEM_OP_O               (dec_exe_uop_dmem_op            ),
    .DEC_EXE_UOP_DATA_WIDTH_O            (dec_exe_uop_data_width         ),
    .DEC_EXE_UOP_DATA_ALU_SAU_EN_O       (dec_exe_uop_data_alu_sau_en    ),
    .DEC_EXE_UOP_DATA_ALU_SAU_OP_O       (dec_exe_uop_data_alu_sau_op    ),
    .DEC_EXE_UOP_IDX_INDIRECT_EN_O       (dec_exe_uop_idx_indirect_en    ),
    .DEC_EXE_UOP_BRANCH_SEL_O            (dec_exe_uop_branch_sel         ),
    .DEC_EXE_UOP_DATA_O                  (dec_exe_uop_data               ),
    .DEC_EXE_UOP_DIRECT_EN_O             (dec_exe_uop_direct_en          ),
    .DEC_EXE_UOP_STACK_DONE_O            (dec_exe_uop_stack_done         ),

    // Fetch/Decode Interface
    .FET_DEC_PC_O                        (fet_dec_pc                     ),
    .FET_DEC_LOAD_PC_O                   (fet_dec_load_pc                ),
    .FET_DEC_INSTR_RD_EN_O               (fet_dec_instr_rd_en            ),
    .FET_DEC_INSTR_LEN_O                 (fet_dec_instr_len              ),
    //                                                                         
    .FET_DEC_NXT_PC_I                    (fet_dec_nxt_pc                 ),
    .FET_DEC_REG_QUEUE_LVL_I             (fet_dec_reg_queue_lvl          ),
    .FET_DEC_REG_QUEUE_D3_I              (fet_dec_reg_queue_d3           ),
    .FET_DEC_REG_QUEUE_D2_I              (fet_dec_reg_queue_d2           ),
    .FET_DEC_REG_QUEUE_D1_I              (fet_dec_reg_queue_d1           ),
    .FET_DEC_REG_QUEUE_D0_I              (fet_dec_reg_queue_d0           ),
    .FET_DEC_REG_PREBYTE_EN_I            (fet_dec_reg_prebyte_en         )
  );



  //////////////////////////////////////// Execute Stage
  turbo9_execute_stage I_turbo9_execute_stage
  (
    // Inputs: Clock & Reset
    .RST_I                               (RST_I                          ),
    .CLK_I                               (CLK_I                          ),

    // Decode Execute Control Interface
    .DEC_EXE_STALL_MICROCYCLE_I          (dec_exe_stall_microcycle       ),
    .DEC_EXE_DMEM_OP_READY_O             (dec_exe_dmem_op_ready          ),
    .DEC_EXE_REGISTER_ARRAY_READY_O      (dec_exe_register_array_ready   ),
    .DEC_EXE_MICRO_SEQ_COND_O            (dec_exe_micro_seq_cond         ),
    .DEC_EXE_NEXT_INSTR_ACK_I            (dec_exe_next_instr_ack         ),
    .DEC_EXE_NXT_PC_I                    (dec_exe_nxt_pc                 ),
    .DEC_EXE_NEW_PC_WR_EN_O              (dec_exe_new_pc_wr_en           ),
    .DEC_EXE_NEW_PC_O                    (dec_exe_new_pc                 ),

    // Micro-Op
    .DEC_EXE_UOP_DATA_ALU_A_SEL_I        (dec_exe_uop_data_alu_a_sel     ),
    .DEC_EXE_UOP_DATA_ALU_B_SEL_I        (dec_exe_uop_data_alu_b_sel     ),
    .DEC_EXE_UOP_DATA_ALU_WR_SEL_I       (dec_exe_uop_data_alu_wr_sel    ),
    .DEC_EXE_UOP_ADDR_ALU_REG_SEL_I      (dec_exe_uop_addr_alu_reg_sel   ),
    .DEC_EXE_UOP_ADDR_ALU_OFFSET_SEL_I   (dec_exe_uop_addr_alu_offset_sel),
    .DEC_EXE_UOP_ADDR_ALU_EA_WR_EN_I     (dec_exe_uop_addr_alu_ea_wr_en  ),
    .DEC_EXE_UOP_ADDR_ALU_Y_OP_I         (dec_exe_uop_addr_alu_y_op      ),
    .DEC_EXE_UOP_ADDR_ALU_EA_OP_I        (dec_exe_uop_addr_alu_ea_op     ),
    .DEC_EXE_UOP_DATA_ALU_OP_I           (dec_exe_uop_data_alu_op        ),
    .DEC_EXE_UOP_CCR_OP_I                (dec_exe_uop_ccr_op             ),
    .DEC_EXE_UOP_DATA_ALU_COND_SEL_I     (dec_exe_uop_data_alu_cond_sel  ),
    .DEC_EXE_UOP_MICRO_SEQ_COND_SEL_I    (dec_exe_uop_micro_seq_cond_sel ),
    .DEC_EXE_UOP_DMEM_OP_I               (dec_exe_uop_dmem_op            ),
    .DEC_EXE_UOP_DATA_I                  (dec_exe_uop_data               ),
    .DEC_EXE_UOP_DIRECT_EN_I             (dec_exe_uop_direct_en          ),
    .DEC_EXE_UOP_DATA_WIDTH_I            (dec_exe_uop_data_width         ),
    .DEC_EXE_UOP_DATA_ALU_SAU_EN_I       (dec_exe_uop_data_alu_sau_en    ),
    .DEC_EXE_UOP_DATA_ALU_SAU_OP_I       (dec_exe_uop_data_alu_sau_op    ),
    .DEC_EXE_UOP_IDX_INDIRECT_EN_I       (dec_exe_uop_idx_indirect_en    ),
    .DEC_EXE_UOP_BRANCH_SEL_I            (dec_exe_uop_branch_sel         ),
    .DEC_EXE_UOP_STACK_DONE_I            (dec_exe_uop_stack_done         ),
    //                                                                              
    // Data Memory Interface                                                        
    .DMEM_DAT_O                          (DMEM_DAT_O                     ),
    .DMEM_DAT_I                          (DMEM_DAT_I                     ),
    .DMEM_ADR_O                          (DMEM_ADR_O                     ),
    .DMEM_BUSY_I                         (DMEM_BUSY_I                    ),
    .DMEM_REQ_O                          (DMEM_REQ_O                     ),
    .DMEM_REQ_WIDTH_O                    (DMEM_REQ_WIDTH_O               ),
    .DMEM_WE_O                           (DMEM_WE_O                      ),
    .DMEM_RD_ACK_I                       (DMEM_RD_ACK_I                  ),
    .DMEM_WR_ACK_I                       (DMEM_WR_ACK_I                  ),
    .DMEM_ACK_WIDTH_I                    (DMEM_ACK_WIDTH_I               )
  );


/////////////////////////////////////////////////////////////////////////////

endmodule


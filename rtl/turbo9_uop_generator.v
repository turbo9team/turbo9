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
// Description: CISC to RISC Micro-Op generation block
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
module turbo9_uop_generator
(
  // Inputs: Clock & Reset
  input          RST_I,
  input          CLK_I,

  // Control Interface
  output         MICROCYCLE_START_O,
  output         NEXT_INSTR_REQ_O,
  input          STALL_MICROCYCLE_I,
  input          MICRO_SEQ_COND_I,
  input          NEXT_INSTR_ACK_I,

  // Instruction Queue
  //input    [7:0] QUEUE_D2_I,
  input    [7:0] QUEUE_D1_I,
  input    [7:0] QUEUE_D0_I,
  input    [1:0] PAGE_SEL_I,

  // Decoded Instruction                                        
  input  [15:0] INSTR_DATA_I,
  input         INSTR_DIRECT_EN_I,
  input         INSTR_INH_EN_I,
  input   [3:0] INSTR_R1_SEL_I,
  input   [3:0] INSTR_R2_SEL_I,
  input   [3:0] INSTR_AR_SEL_I,
  input   [7:0] INSTR_JUMP_TABLE_A_I,
  input   [7:0] INSTR_JUMP_TABLE_B_I,

  // Micro-Op
  output  [2:0] UOP_MICRO_SEQ_OP_O,
  output  [7:0] UOP_MICRO_SEQ_BRANCH_ADDR_O,
  output  [3:0] UOP_DATA_ALU_A_SEL_O,
  output  [3:0] UOP_DATA_ALU_B_SEL_O,
  output  [3:0] UOP_DATA_ALU_WR_SEL_O,
  output  [3:0] UOP_ADDR_ALU_REG_SEL_O,
  output  [3:0] UOP_ADDR_ALU_OFFSET_SEL_O,
  output        UOP_ADDR_ALU_EA_OP_O,
  output        UOP_ADDR_ALU_EA_WR_EN_O,
  output        UOP_ADDR_ALU_Y_OP_O,
  output  [2:0] UOP_DATA_ALU_OP_O,
  output  [3:0] UOP_CCR_OP_O,
  output  [1:0] UOP_DATA_ALU_COND_SEL_O,
  output  [3:0] UOP_MICRO_SEQ_COND_SEL_O,
  output  [1:0] UOP_DMEM_OP_O,
  output        UOP_DATA_WIDTH_O,
  output        UOP_DATA_ALU_SAU_EN_O,
  output  [3:0] UOP_DATA_ALU_SAU_OP_O,
  output        UOP_IDX_INDIRECT_EN_O,
  output  [3:0] UOP_BRANCH_SEL_O,
  output [15:0] UOP_DATA_O,
  output        UOP_DIRECT_EN_O,
  output  [7:0] UOP_JUMP_TABLE_B_O,
  output        UOP_STACK_DONE_O
);


/////////////////////////////////////////////////////////////////////////////
//                             INTERNAL SIGNALS
/////////////////////////////////////////////////////////////////////////////

wire   [7:0] microcode_adr;   

//////////////////////////////////////// Microcode Control Vector Micro-Op Fields
//
wire  [2:0] cv_micro_seq_op;
reg   [2:0] uop_micro_seq_op_reg;
localparam  uop_micro_seq_op_rst = 3'h1; // INFO: JUMP to initialize pipeline reg after reset

wire  [7:0] cv_micro_seq_branch_addr;
reg   [7:0] uop_micro_seq_branch_addr_reg;
localparam  uop_micro_seq_branch_addr_rst = 8'h0; // INFO: addr = 0 to initialize pipeline reg after reset

wire  [3:0] cv_data_alu_a_sel;
wire  [3:0] data_alu_a_sel;
reg   [3:0] uop_data_alu_a_sel_reg;
localparam  uop_data_alu_a_sel_rst = 4'h0;

wire  [2:0] cv_data_alu_b_sel;
wire  [3:0] data_alu_b_sel;
reg   [3:0] uop_data_alu_b_sel_reg;
localparam  uop_data_alu_b_sel_rst = 4'h0;

wire  [3:0] cv_data_alu_wr_sel;
wire  [3:0] data_alu_wr_sel;
reg   [3:0] uop_data_alu_wr_sel_reg;
localparam  uop_data_alu_wr_sel_rst = 4'h0;

wire  [3:0] cv_addr_alu_reg_sel;
wire  [3:0] addr_alu_reg_sel;
reg   [3:0] uop_addr_alu_reg_sel_reg;
localparam  uop_addr_alu_reg_sel_rst = 4'h0;

wire  [3:0] addr_alu_offset_sel;
reg   [3:0] uop_addr_alu_offset_sel_reg;
localparam  uop_addr_alu_offset_sel_rst = 4'h0;

wire        addr_alu_ea_op;
reg         uop_addr_alu_ea_op_reg;
localparam  uop_addr_alu_ea_op_rst = 1'b0;

wire        addr_alu_ea_wr_en;
reg         uop_addr_alu_ea_wr_en_reg;
localparam  uop_addr_alu_ea_wr_en_rst = 1'b0;

wire        addr_alu_y_op;
reg         uop_addr_alu_y_op_reg;
localparam  uop_addr_alu_y_op_rst = 1'b0;

wire  [2:0] cv_data_alu_op;
reg   [2:0] uop_data_alu_op_reg;
localparam  uop_data_alu_op_rst = 3'h0;

wire  [3:0] cv_ccr_op;
reg   [3:0] uop_ccr_op_reg;
localparam  uop_ccr_op_rst = 4'h0;

wire  [1:0] cv_data_alu_cond_sel;
reg   [1:0] uop_data_alu_cond_sel_reg;
localparam  uop_data_alu_cond_sel_rst = 2'h0;

wire  [3:0] cv_micro_seq_cond_sel;
reg   [3:0] uop_micro_seq_cond_sel_reg;
localparam  uop_micro_seq_cond_sel_rst = 4'h1;  // INFO: cond = true initialize pipeline reg after reset

wire  [1:0] cv_dmem_op;
wire  [1:0] dmem_op;
reg   [1:0] uop_dmem_op_reg;
localparam  uop_dmem_op_rst = 2'h0;

wire  [1:0] cv_stack_op;

wire  [1:0] cv_data_width_sel;
wire        data_width;
reg         uop_data_width_reg;
localparam  uop_data_width_rst = 1'b0;

wire        cv_data_alu_sau_en;
reg         uop_data_alu_sau_en_reg;
localparam  uop_data_alu_sau_en_rst = 1'b0;

wire  [3:0] data_alu_sau_op;
reg   [3:0] uop_data_alu_sau_op_reg;
localparam  uop_data_alu_sau_op_rst = 4'h0;

wire        idx_indirect_en;
reg         uop_idx_indirect_en_reg;
localparam  uop_idx_indirect_en_rst = 1'b0;

wire        stack_done;
reg         uop_stack_done_reg;
localparam  uop_stack_done_rst = 1'b0;

wire  [3:0] branch_sel;
reg   [3:0] uop_branch_sel_reg;
localparam  uop_branch_sel_rst = 1'b0;


//////////////////////////////////////// Instruction Decoded Fields
//
reg   [15:0] uop_data_reg;
localparam   uop_data_rst = 16'h0000;

reg          uop_direct_en_reg;
localparam   uop_direct_en_rst = 1'b0;

reg    [7:0] uop_jump_table_b_reg;
localparam   uop_jump_table_b_rst = 8'h00;

/////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////
//                                LOGIC
/////////////////////////////////////////////////////////////////////////////


  //////////////////////////////////////// Microsequencer
  turbo9_microsequencer I_turbo9_microsequencer
  (
    // Inputs: Clock & Reset
    .RST_I                    (RST_I                         ),
    .CLK_I                    (CLK_I                         ),
    // Inputs                                              
    .STALL_MICROCYCLE_I       (STALL_MICROCYCLE_I            ),
    .CONDITION_I              (MICRO_SEQ_COND_I              ),
    .MICRO_SEQ_OP_I           (uop_micro_seq_op_reg          ),
    .MICRO_SEQ_BRANCH_ADDR_I  (uop_micro_seq_branch_addr_reg ),
    .JUMP_TABLE_A_I           (INSTR_JUMP_TABLE_A_I          ),
    .JUMP_TABLE_B_I           (uop_jump_table_b_reg          ),
    // Outputs                                           
    .MICROCYCLE_START_O       (MICROCYCLE_START_O            ),
    .MICROCODE_ADR_O          (microcode_adr                 ),
    .EXECUTE_NEXT_INSTR_O     (NEXT_INSTR_REQ_O              )
  );

  //////////////////////////////////////// Microcode
  turbo9_urtl_microcode I_turbo9_urtl_microcode
  (
    // Inputs:
    .MICROCODE_ADR_I            ({1'b0,microcode_adr}     ),
                                                            
    // Control Vectors
    .CV_MICRO_SEQ_OP_O          (cv_micro_seq_op          ),
    .CV_MICRO_SEQ_BRANCH_ADDR_O (cv_micro_seq_branch_addr ),
    .CV_DATA_ALU_A_SEL_O        (cv_data_alu_a_sel        ),
    .CV_DATA_ALU_B_SEL_O        (cv_data_alu_b_sel        ),
    .CV_DATA_ALU_WR_SEL_O       (cv_data_alu_wr_sel       ),
    .CV_ADDR_ALU_REG_SEL_O      (cv_addr_alu_reg_sel      ),
    .CV_DATA_ALU_OP_O           (cv_data_alu_op           ),
    .CV_DATA_WIDTH_SEL_O        (cv_data_width_sel        ),
    .CV_DATA_ALU_SAU_EN_O       (cv_data_alu_sau_en       ),
    .CV_CCR_OP_O                (cv_ccr_op                ),
    .CV_DATA_ALU_COND_SEL_O     (cv_data_alu_cond_sel     ),
    .CV_MICRO_SEQ_COND_SEL_O    (cv_micro_seq_cond_sel    ),
    .CV_DMEM_OP_O               (cv_dmem_op               ),
    .CV_STACK_OP_O              (cv_stack_op              )
  );

  //////////////////////////////////////// Register Control
  turbo9_reg_addr_ctrl I_turbo9_reg_addr_ctrl
  (
    // Inputs: Clock & Reset
    .RST_I                    (RST_I                ),
    .CLK_I                    (CLK_I                ),
    //                                              
    // Stall & Next Instruction ACK
    .STALL_MICROCYCLE_I       (STALL_MICROCYCLE_I   ),
    .NEXT_INSTR_ACK_I         (NEXT_INSTR_ACK_I     ),
    //
    // Instruction Queue
    //.QUEUE_D2_I               (QUEUE_D2_I           ),
    .QUEUE_D1_I               (QUEUE_D1_I           ),
    .QUEUE_D0_I               (QUEUE_D0_I           ),
    .PAGE_SEL_I               (PAGE_SEL_I           ),
    //
    // Instrution Decoded Controls
    .INSTR_INH_EN_I           (INSTR_INH_EN_I       ),
    .INSTR_R1_SEL_I           (INSTR_R1_SEL_I       ),
    .INSTR_R2_SEL_I           (INSTR_R2_SEL_I       ),
    .INSTR_AR_SEL_I           (INSTR_AR_SEL_I       ),
    //
    // Control Vector Register Selects
    .CV_DATA_WIDTH_SEL_I      (cv_data_width_sel    ),
    .CV_DATA_ALU_A_SEL_I      (cv_data_alu_a_sel    ),
    .CV_DATA_ALU_B_SEL_I      (cv_data_alu_b_sel    ),
    .CV_DATA_ALU_WR_SEL_I     (cv_data_alu_wr_sel   ),
    .CV_ADDR_ALU_REG_SEL_I    (cv_addr_alu_reg_sel  ),
    .CV_DMEM_OP_I             (cv_dmem_op           ),
    .CV_STACK_OP_I            (cv_stack_op          ),
    //
    // Data ALU 
    .DATA_WIDTH_O             (data_width           ),
    .DATA_ALU_A_SEL_O         (data_alu_a_sel       ),
    .DATA_ALU_B_SEL_O         (data_alu_b_sel       ),
    .DATA_ALU_WR_SEL_O        (data_alu_wr_sel      ),
    .DATA_ALU_SAU_OP          (data_alu_sau_op      ),
    //
    // Address ALU 
    .ADDR_ALU_REG_SEL_O       (addr_alu_reg_sel     ),
    .ADDR_ALU_OFFSET_SEL_O    (addr_alu_offset_sel  ),
    .ADDR_ALU_EA_WR_EN_O      (addr_alu_ea_wr_en    ),
    .ADDR_ALU_EA_OP_O         (addr_alu_ea_op       ),
    .ADDR_ALU_Y_OP_O          (addr_alu_y_op        ),
    //
    // Other
    .DMEM_OP                  (dmem_op              ),
    .BRANCH_SEL_O             (branch_sel           ),
    .IDX_INDIRECT_EN_O        (idx_indirect_en      ),
    .STACK_DONE_O             (stack_done           )
  );
/////////////////////////////////////////////////////////////////////////////
//                          MICRO-OPERATION REGISTER
/////////////////////////////////////////////////////////////////////////////
//
always @(posedge CLK_I, posedge RST_I) begin
  if (RST_I) begin
    //
    uop_micro_seq_op_reg          <= uop_micro_seq_op_rst;
    uop_micro_seq_branch_addr_reg <= uop_micro_seq_branch_addr_rst;
    uop_data_alu_a_sel_reg        <= uop_data_alu_a_sel_rst;
    uop_data_alu_b_sel_reg        <= uop_data_alu_b_sel_rst;
    uop_data_alu_wr_sel_reg       <= uop_data_alu_wr_sel_rst;
    uop_addr_alu_reg_sel_reg      <= uop_addr_alu_reg_sel_rst;
    uop_addr_alu_offset_sel_reg   <= uop_addr_alu_offset_sel_rst;
    uop_addr_alu_ea_op_reg        <= uop_addr_alu_ea_op_rst;
    uop_addr_alu_ea_wr_en_reg     <= uop_addr_alu_ea_wr_en_rst;
    uop_addr_alu_y_op_reg         <= uop_addr_alu_y_op_rst;
    uop_data_alu_op_reg           <= uop_data_alu_op_rst;
    uop_ccr_op_reg                <= uop_ccr_op_rst;
    uop_data_alu_cond_sel_reg     <= uop_data_alu_cond_sel_rst;
    uop_micro_seq_cond_sel_reg    <= uop_micro_seq_cond_sel_rst;
    uop_dmem_op_reg               <= uop_dmem_op_rst;
    uop_data_width_reg            <= uop_data_width_rst;
    uop_data_alu_sau_en_reg       <= uop_data_alu_sau_en_rst;
    uop_data_alu_sau_op_reg       <= uop_data_alu_sau_op_rst;
    uop_idx_indirect_en_reg       <= uop_idx_indirect_en_rst;
    uop_stack_done_reg            <= uop_stack_done_rst;
    uop_branch_sel_reg            <= uop_branch_sel_rst;
    //                               //                           
    uop_data_reg                  <= uop_data_rst;
    uop_direct_en_reg             <= uop_direct_en_rst;
    uop_jump_table_b_reg          <= uop_jump_table_b_rst;
    //
  end else begin
    if (~STALL_MICROCYCLE_I) begin
      //
      uop_micro_seq_op_reg          <= cv_micro_seq_op;
      uop_micro_seq_branch_addr_reg <= cv_micro_seq_branch_addr;
      uop_data_alu_a_sel_reg        <= data_alu_a_sel;
      uop_data_alu_b_sel_reg        <= data_alu_b_sel;
      uop_data_alu_wr_sel_reg       <= data_alu_wr_sel;
      uop_addr_alu_reg_sel_reg      <= addr_alu_reg_sel;
      uop_addr_alu_offset_sel_reg   <= addr_alu_offset_sel;
      uop_addr_alu_ea_op_reg        <= addr_alu_ea_op;
      uop_addr_alu_ea_wr_en_reg     <= addr_alu_ea_wr_en;
      uop_addr_alu_y_op_reg         <= addr_alu_y_op;
      uop_data_alu_op_reg           <= cv_data_alu_op;
      uop_ccr_op_reg                <= cv_ccr_op;
      uop_data_alu_cond_sel_reg     <= cv_data_alu_cond_sel;
      uop_micro_seq_cond_sel_reg    <= cv_micro_seq_cond_sel;
      uop_dmem_op_reg               <= dmem_op;
      uop_data_width_reg            <= data_width;
      uop_data_alu_sau_en_reg       <= cv_data_alu_sau_en;
      uop_idx_indirect_en_reg       <= idx_indirect_en;
      uop_stack_done_reg            <= stack_done;
      uop_branch_sel_reg            <= branch_sel;
      //
      if (NEXT_INSTR_ACK_I) begin
        //
        uop_data_reg            <= INSTR_DATA_I;
        uop_direct_en_reg       <= INSTR_DIRECT_EN_I;
        uop_jump_table_b_reg    <= INSTR_JUMP_TABLE_B_I;
        uop_data_alu_sau_op_reg <= data_alu_sau_op;
        //
      end
    end
  end
end
//
/////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////
//                            ASSIGN OUPUTS
/////////////////////////////////////////////////////////////////////////////
//
//
assign  UOP_MICRO_SEQ_OP_O          = uop_micro_seq_op_reg;         
assign  UOP_MICRO_SEQ_BRANCH_ADDR_O = uop_micro_seq_branch_addr_reg;
assign  UOP_DATA_ALU_A_SEL_O        = uop_data_alu_a_sel_reg;       
assign  UOP_DATA_ALU_B_SEL_O        = uop_data_alu_b_sel_reg;       
assign  UOP_DATA_ALU_WR_SEL_O       = uop_data_alu_wr_sel_reg;      
assign  UOP_ADDR_ALU_REG_SEL_O      = uop_addr_alu_reg_sel_reg;     
assign  UOP_ADDR_ALU_OFFSET_SEL_O   = uop_addr_alu_offset_sel_reg;  
assign  UOP_ADDR_ALU_EA_OP_O        = uop_addr_alu_ea_op_reg;       
assign  UOP_ADDR_ALU_EA_WR_EN_O     = uop_addr_alu_ea_wr_en_reg;    
assign  UOP_ADDR_ALU_Y_OP_O         = uop_addr_alu_y_op_reg;        
assign  UOP_DATA_ALU_OP_O           = uop_data_alu_op_reg;          
assign  UOP_CCR_OP_O                = uop_ccr_op_reg;               
assign  UOP_DATA_ALU_COND_SEL_O     = uop_data_alu_cond_sel_reg;    
assign  UOP_MICRO_SEQ_COND_SEL_O    = uop_micro_seq_cond_sel_reg;   
assign  UOP_DMEM_OP_O               = uop_dmem_op_reg;              
assign  UOP_DATA_WIDTH_O            = uop_data_width_reg;
assign  UOP_DATA_ALU_SAU_EN_O       = uop_data_alu_sau_en_reg;
assign  UOP_DATA_ALU_SAU_OP_O       = uop_data_alu_sau_op_reg;
assign  UOP_IDX_INDIRECT_EN_O       = uop_idx_indirect_en_reg;      
assign  UOP_BRANCH_SEL_O            = uop_branch_sel_reg;           
assign  UOP_DATA_O                  = uop_data_reg;                 
assign  UOP_DIRECT_EN_O             = uop_direct_en_reg;            
assign  UOP_JUMP_TABLE_B_O          = uop_jump_table_b_reg;         
assign  UOP_STACK_DONE_O            = uop_stack_done_reg;
//
/////////////////////////////////////////////////////////////////////////////


endmodule


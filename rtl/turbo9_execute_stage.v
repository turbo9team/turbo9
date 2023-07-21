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
// Description: Turbo9 Execute Stage
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
module turbo9_execute_stage
(
  // Inputs: Clock & Reset
  input          RST_I,
  input          CLK_I,

  // Decode Execute Control Interface
  input          DEC_EXE_STALL_MICROCYCLE_I,
  output         DEC_EXE_DMEM_OP_READY_O,
  output         DEC_EXE_REGISTER_ARRAY_READY_O,
  output         DEC_EXE_MICRO_SEQ_COND_O,
  input          DEC_EXE_NEXT_INSTR_ACK_I,
  input   [15:0] DEC_EXE_NXT_PC_I,
  output         DEC_EXE_NEW_PC_WR_EN_O,
  output  [15:0] DEC_EXE_NEW_PC_O,

  // Micro-Op
  input    [3:0] DEC_EXE_UOP_DATA_ALU_A_SEL_I,
  input    [3:0] DEC_EXE_UOP_DATA_ALU_B_SEL_I,
  input    [3:0] DEC_EXE_UOP_DATA_ALU_WR_SEL_I,
  input    [3:0] DEC_EXE_UOP_ADDR_ALU_REG_SEL_I, 
  input    [3:0] DEC_EXE_UOP_ADDR_ALU_OFFSET_SEL_I,  
  input          DEC_EXE_UOP_ADDR_ALU_EA_WR_EN_I,
  input          DEC_EXE_UOP_ADDR_ALU_Y_OP_I,
  input          DEC_EXE_UOP_ADDR_ALU_EA_OP_I,
  input    [2:0] DEC_EXE_UOP_DATA_ALU_OP_I,
  input    [3:0] DEC_EXE_UOP_CCR_OP_I,
  input    [1:0] DEC_EXE_UOP_DATA_ALU_COND_SEL_I,
  input    [3:0] DEC_EXE_UOP_MICRO_SEQ_COND_SEL_I,
  input    [1:0] DEC_EXE_UOP_DMEM_OP_I,
  input   [15:0] DEC_EXE_UOP_DATA_I,
  input          DEC_EXE_UOP_DIRECT_EN_I,
  input          DEC_EXE_UOP_DATA_WIDTH_I,
  input          DEC_EXE_UOP_DATA_ALU_SAU_EN_I,
  input    [3:0] DEC_EXE_UOP_DATA_ALU_SAU_OP_I,
  input          DEC_EXE_UOP_IDX_INDIRECT_EN_I,
  input    [3:0] DEC_EXE_UOP_BRANCH_SEL_I,            
  input          DEC_EXE_UOP_STACK_DONE_I,

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

// Register Array Control Vectors
wire         ra_ccr_wr_en;
wire   [7:0] ra_ccr_wr_data;
wire   [7:0] ra_ccr_rd_data;

wire  [15:0] data_alu_a;
wire  [15:0] data_alu_b;
wire  [15:0] data_alu_y;
wire         data_alu_cond;
wire   [4:0] data_alu_flags;
wire         data_alu_sau_done;
wire  [47:0] data_alu_sau_abxy;
wire   [4:0] ccr_flags;

// Address ALU Data Inputs / Outputs
wire  [15:0] addr_alu_reg;
wire  [15:0] addr_alu_y;
wire  [15:0] addr_alu_ea;
wire  [15:0] addr_alu_offset;

wire         dmem_rd_data_ready;
wire  [15:0] dmem_rd_data_reg;



/////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////
//                                LOGIC
/////////////////////////////////////////////////////////////////////////////

  //////////////////////////////////////// Register Array
  turbo9_register_array I_turbo9_register_array
  (
    // Inputs: Clock & Reset
    .RST_I                     (RST_I                             ),
    .CLK_I                     (CLK_I                             ),
    .STALL_MICROCYCLE_I        (DEC_EXE_STALL_MICROCYCLE_I        ),
    .REGISTER_ARRAY_READY_O    (DEC_EXE_REGISTER_ARRAY_READY_O    ),
    //                                                               
    // PC Interface to Fetch & Decode                             
    .NXT_PC_WR_EN_I            (DEC_EXE_NEXT_INSTR_ACK_I          ),
    .NXT_PC_I                  (DEC_EXE_NXT_PC_I                  ),
    .NEW_PC_WR_EN_O            (DEC_EXE_NEW_PC_WR_EN_O            ),
    .NEW_PC_O                  (DEC_EXE_NEW_PC_O                  ),
    //                                                               
    // Data ALU                                                      
    .DATA_ALU_A_SEL_I          (DEC_EXE_UOP_DATA_ALU_A_SEL_I      ),
    .DATA_ALU_B_SEL_I          (DEC_EXE_UOP_DATA_ALU_B_SEL_I      ),
    .DATA_ALU_WR_SEL_I         (DEC_EXE_UOP_DATA_ALU_WR_SEL_I     ),
    .DATA_ALU_A_O              (data_alu_a                        ),
    .DATA_ALU_B_O              (data_alu_b                        ),
    .DATA_ALU_Y_I              (data_alu_y                        ),
    .DATA_ALU_SAU_ABXY_O       (data_alu_sau_abxy                 ),
    //                                                       
    // Register Array ALU Selects                            
    .ADDR_ALU_REG_SEL_I        (DEC_EXE_UOP_ADDR_ALU_REG_SEL_I    ),
    .ADDR_ALU_OFFSET_SEL_I     (DEC_EXE_UOP_ADDR_ALU_OFFSET_SEL_I ),
    .ADDR_ALU_EA_WR_EN_I       (DEC_EXE_UOP_ADDR_ALU_EA_WR_EN_I   ),
    //                                                       
    // Address ALU Data Inputs / Outputs                       
    .ADDR_ALU_REG_O            (addr_alu_reg                      ),
    .ADDR_ALU_OFFSET_O         (addr_alu_offset                   ),
    .ADDR_ALU_Y_I              (addr_alu_y                        ),
    .ADDR_ALU_EA_I             (addr_alu_ea                       ),
    //                                                            
    // Other Registers                                            
    .DMEM_RD_DATA_READY_I      (dmem_rd_data_ready                ),
    .DMEM_RD_DATA_REG_I        (dmem_rd_data_reg                  ),
    .INSTR_DATA_I              (DEC_EXE_UOP_DATA_I                ),
    .INSTR_DIRECT_EN_I         (DEC_EXE_UOP_DIRECT_EN_I           ),
    //                                                          
    // CCR to Register Array                                    
    .RA_CCR_WR_EN_O            (ra_ccr_wr_en                      ),
    .RA_CCR_WR_DATA_O          (ra_ccr_wr_data                    ),
    .RA_CCR_RD_DATA_I          (ra_ccr_rd_data                    )
  );

  //////////////////////////////////////// Address ALU
  turbo9_address_alu I_turbo9_address_alu
  (
    //
    // Address ALU Operation
    .ADDR_ALU_EA_OP_I         (DEC_EXE_UOP_ADDR_ALU_EA_OP_I     ),
    .ADDR_ALU_Y_OP_I          (DEC_EXE_UOP_ADDR_ALU_Y_OP_I      ),
    //
    // Address ALU Data Inputs / Outputs
    .ADDR_ALU_REG_I           (addr_alu_reg                     ),
    .ADDR_ALU_OFFSET_I        (addr_alu_offset                  ),
    .ADDR_ALU_Y_O             (addr_alu_y                       ),
    .ADDR_ALU_EA_O            (addr_alu_ea                      )
  );

  //////////////////////////////////////// Data ALU
  turbo9_data_alu I_turbo9_data_alu
  (
    // Inputs: Clock & Reset
    .RST_I                   (RST_I                             ),
    .CLK_I                   (CLK_I                             ),
    .STALL_MICROCYCLE_I      (DEC_EXE_STALL_MICROCYCLE_I        ),
    //                                                          
    // Inputs                                                  
    .DATA_ALU_OP_I           (DEC_EXE_UOP_DATA_ALU_OP_I         ),
    .DATA_ALU_COND_SEL_I     (DEC_EXE_UOP_DATA_ALU_COND_SEL_I   ),
    .DATA_ALU_A_I            (data_alu_a                        ),
    .DATA_ALU_B_I            (data_alu_b                        ),
    .DATA_ALU_WIDTH_I        (DEC_EXE_UOP_DATA_WIDTH_I          ),
    .DATA_ALU_SAU_EN_I       (DEC_EXE_UOP_DATA_ALU_SAU_EN_I     ),
    .DATA_ALU_SAU_OP_I       (DEC_EXE_UOP_DATA_ALU_SAU_OP_I     ),
    .DATA_ALU_SAU_ABXY_I     (data_alu_sau_abxy                 ),
    .CCR_FLAGS_I             (ccr_flags                         ),
    //                                                 
    // Outputs                                         
    .DATA_ALU_Y_O            (data_alu_y                        ),
    .DATA_ALU_FLAGS_O        (data_alu_flags                    ),
    .DATA_ALU_SAU_DONE_O     (data_alu_sau_done                 )
  );

  //////////////////////////////////////// Condition Code Register
  turbo9_ccr I_turbo9_ccr
  (
    // Inputs: Clock & Reset
    .RST_I                    (RST_I                            ),
    .CLK_I                    (CLK_I                            ),
    .STALL_MICROCYCLE_I       (DEC_EXE_STALL_MICROCYCLE_I       ),
    //                                                
    // Inputs                                         
    .CCR_OP_I                 (DEC_EXE_UOP_CCR_OP_I             ),
    .MICRO_SEQ_COND_SEL_I     (DEC_EXE_UOP_MICRO_SEQ_COND_SEL_I ),
    .BRANCH_SEL_I             (DEC_EXE_UOP_BRANCH_SEL_I         ),
    .STACK_DONE_I             (DEC_EXE_UOP_STACK_DONE_I         ),
    .IDX_INDIRECT_EN_I        (DEC_EXE_UOP_IDX_INDIRECT_EN_I    ),
    .DATA_WIDTH_I             (DEC_EXE_UOP_DATA_WIDTH_I         ),
    .DATA_ALU_FLAGS_I         (data_alu_flags                   ),
    .DATA_ALU_SAU_DONE_I      (data_alu_sau_done                ),
    //                       
    // Register Array        
    .RA_CCR_WR_EN_I           (ra_ccr_wr_en                     ),
    .RA_CCR_WR_DATA_I         (ra_ccr_wr_data                   ),
    .RA_CCR_RD_DATA_O         (ra_ccr_rd_data                   ),
    //                                                
    // Outputs                                        
    .CCR_FLAGS_O              (ccr_flags                        ),
    .MICRO_SEQ_COND_O         (DEC_EXE_MICRO_SEQ_COND_O         )
  );

  //////////////////////////////////////// Data Memory Controller
  turbo9_data_mem_ctrl I_turbo9_data_mem_ctrl 
  (
    // Inputs: Clock & Reset
    .RST_I                   (RST_I                          ),
    .CLK_I                   (CLK_I                          ),
    .STALL_MICROCYCLE_I      (DEC_EXE_STALL_MICROCYCLE_I     ), //FIXME Using this stall signal is safe but could be optimized
    //                                                       
    // Execution Stage Interface                             
    .DMEM_OP_I               (DEC_EXE_UOP_DMEM_OP_I          ),
    .DMEM_OP_READY_O         (DEC_EXE_DMEM_OP_READY_O        ),
    .DMEM_RD_DATA_REG_O      (dmem_rd_data_reg               ),
    .DMEM_RD_DATA_READY_O    (dmem_rd_data_ready             ),
    .DMEM_DATA_ALU_Y_I       (data_alu_y                     ),
    .DMEM_ADDR_ALU_EA_I      (addr_alu_ea                    ),
    // 
    // 8bit or 16bit Data Width
    .DATA_WIDTH_I            (DEC_EXE_UOP_DATA_WIDTH_I       ),
    //
    // Data Memory Interface                  
    .DMEM_DAT_O              (DMEM_DAT_O                     ),
    .DMEM_DAT_I              (DMEM_DAT_I                     ),
    .DMEM_ADR_O              (DMEM_ADR_O                     ),
    .DMEM_BUSY_I             (DMEM_BUSY_I                    ),
    .DMEM_REQ_O              (DMEM_REQ_O                     ),
    .DMEM_REQ_WIDTH_O        (DMEM_REQ_WIDTH_O               ),
    .DMEM_WE_O               (DMEM_WE_O                      ),
    .DMEM_RD_ACK_I           (DMEM_RD_ACK_I                  ),
    .DMEM_WR_ACK_I           (DMEM_WR_ACK_I                  ),
    .DMEM_ACK_WIDTH_I        (DMEM_ACK_WIDTH_I               )
  );

/////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////
//                            ASSIGN OUPUTS
/////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////
endmodule


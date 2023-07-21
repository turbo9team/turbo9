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
// Description: Turbo9 microsequencer
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
module turbo9_microsequencer
(
  // Inputs: Clock & Reset
  input          RST_I,
  input          CLK_I,
  // Inputs         
  input          STALL_MICROCYCLE_I,
  input          CONDITION_I,
  input    [2:0] MICRO_SEQ_OP_I,
  input    [7:0] MICRO_SEQ_BRANCH_ADDR_I,
  input    [7:0] JUMP_TABLE_A_I,
  input    [7:0] JUMP_TABLE_B_I,
  // Outputs
  output         MICROCYCLE_START_O,
  output   [7:0] MICROCODE_ADR_O,
  output         EXECUTE_NEXT_INSTR_O
);


/////////////////////////////////////////////////////////////////////////////
//                             INTERNAL SIGNALS
/////////////////////////////////////////////////////////////////////////////

reg    [7:0] micro_pc_reg;
reg    [7:0] micro_pc_nxt;
wire   [7:0] micro_pc_inc;
localparam   micro_pc_rst = 8'h00;

reg          return_load;
reg    [7:0] return_reg;
localparam   return_rst = 8'h00;

reg          microcycle_start_reg;
localparam   microcycle_start_rst = 1'b1;

// Note this encoding is critical.
// OP_JUMP_TABLE_A_NEXT_PC is partially decoded for speed
localparam  OP_CONTINUE             = 3'b000;
localparam  OP_JUMP                 = 3'b001;
localparam  OP_CALL                 = 3'b010;
localparam  OP_RETURN               = 3'b011;
localparam  OP_JUMP_TABLE_B         = 3'b100;
localparam  OP_JUMP_TABLE_A_NEXT_PC = 3'b1?1;

/////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////
//                            NEXT STATE LOGIC
/////////////////////////////////////////////////////////////////////////////

assign micro_pc_inc = micro_pc_reg + 8'h01;

always @* begin
  
  // Default State
  micro_pc_nxt = micro_pc_rst;
  return_load  = 1'b0;

  // Next State Logic
  //unique casez ({MICRO_SEQ_OP_I, CONDITION_I}) // FIXME optimize logic
  casez ({MICRO_SEQ_OP_I, CONDITION_I})
    ////////////////////////////////////////// Conditional Cases
    {OP_CONTINUE, 1'b1}: begin
      micro_pc_nxt = micro_pc_inc;
    end
    //
    {OP_JUMP, 1'b1}: begin
      micro_pc_nxt = MICRO_SEQ_BRANCH_ADDR_I;
    end
    //
    {OP_CALL, 1'b1}: begin
      return_load  = 1'b1;
      micro_pc_nxt = MICRO_SEQ_BRANCH_ADDR_I;
    end
    //
    {OP_RETURN, 1'b1}: begin
      micro_pc_nxt = return_reg;
    end
    //
    {OP_JUMP_TABLE_B, 1'b1}: begin
      micro_pc_nxt = JUMP_TABLE_B_I;
    end
    ////////////////////////////////////////// Unconditional Cases
    {OP_JUMP_TABLE_A_NEXT_PC, 1'b?}: begin
      micro_pc_nxt = JUMP_TABLE_A_I;
    end
    //
    default: begin // CONTINUE
      micro_pc_nxt = micro_pc_inc;
    end
  endcase

end
/////////////////////////////////////////////////////////////////////////////



/////////////////////////////////////////////////////////////////////////////
//                                REGISTERS
/////////////////////////////////////////////////////////////////////////////
always @(posedge CLK_I, posedge RST_I) begin
  if (RST_I) begin

    micro_pc_reg         <= micro_pc_rst;
    return_reg           <= return_rst;
    microcycle_start_reg <= microcycle_start_rst;

  end else begin

    if (~STALL_MICROCYCLE_I) begin
      micro_pc_reg  <= micro_pc_nxt;
      //    
      if (return_load)
        return_reg  <= micro_pc_inc;
      //
      microcycle_start_reg <= 1'b1;
    end else begin
      microcycle_start_reg <= 1'b0;
    end
  end
end
/////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////
//                             ASSIGN OUTPUTS
/////////////////////////////////////////////////////////////////////////////

assign MICROCYCLE_START_O   = microcycle_start_reg;
assign MICROCODE_ADR_O      = STALL_MICROCYCLE_I ? micro_pc_reg : micro_pc_nxt;
assign EXECUTE_NEXT_INSTR_O = MICRO_SEQ_OP_I[2] & MICRO_SEQ_OP_I[0]; // OP_JUMP_TABLE_A_NEXT_PC

/////////////////////////////////////////////////////////////////////////////

endmodule


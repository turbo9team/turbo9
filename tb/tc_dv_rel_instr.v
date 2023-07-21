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
// Description: Testcase: Relative 8-bit instructions
//
//////////////////////////////////////////////////////////////////////////////
// History:
// 07.14.2023 - Kevin Phillipson
//   File header added
//
//////////////////////////////////////////////////////////////////////////////
// [TURBO9_HEADER_END]

/////////////////////////////////////////////////////////////////////////////
//                  Relative (8-bit) Addressing Instruction Testcase
/////////////////////////////////////////////////////////////////////////////

  `define TEST_REL_TOTAL_INSTR    16
  `define TEST_REL_RESET_CYCLES   40  // (16  nominal)
  `define TEST_REL_START_CYCLES   200 // (100 nominal)
  `define TEST_REL_FINISH_CYCLES  500 // (240 nominal)

  ////////////////////////////////////////////////////////////////////////////
  // Test Direct Addressing Instructions
  ////////////////////////////////////////////////////////////////////////////
  task tc_dv_rel_instr;

    reg [15:0] addr_ptr;
    reg [15:0] rel_addr_ptr;
    reg [15:0] data_block_start;
    reg [15:0] effective_addr;
    reg [31:0] rand32;
    reg [ 7:0] rel_addr_offset;
    reg [15:0] temp16;

    integer rel_instr_list [0:`TEST_REL_TOTAL_INSTR-1];
    integer instr_idx;
    integer error_cnt;

    integer rand_itr_idx;

    reg        stack_ptr_sel;
    reg [ 1:0] operand_size;
    reg [ 7:0] prebyte;
    reg [ 7:0] opcode;


  begin
    // rel_instr_list define:
    // [23:20] : Stack ptr sel : 'h0 = S     / 'h1 = U      / 'h2 = random
    // [19:16] : Operand size  : 'h1 = 8bit  / 'h2 = 16bit
    // [15: 8] : Prebyte       : 'h00 = none / 'h10 = Page2 / 'h11 = Page3
    // [ 7: 0] : Opcode

    rel_instr_list[ 0] = 'h00_2_1_00_20;  // BRA
    rel_instr_list[ 1] = 'h00_2_1_00_21;  // BRN
    rel_instr_list[ 2] = 'h00_2_1_00_22;  // BHI
    rel_instr_list[ 3] = 'h00_2_1_00_23;  // BLS
    rel_instr_list[ 4] = 'h00_2_1_00_24;  // BHS,BCC
    rel_instr_list[ 5] = 'h00_2_1_00_25;  // BLO,BCS
    rel_instr_list[ 6] = 'h00_2_1_00_26;  // BNE
    rel_instr_list[ 7] = 'h00_2_1_00_27;  // BEQ
    rel_instr_list[ 8] = 'h00_2_1_00_28;  // BVC
    rel_instr_list[ 9] = 'h00_2_1_00_29;  // BVS
    rel_instr_list[10] = 'h00_2_1_00_2A;  // BPL
    rel_instr_list[11] = 'h00_2_1_00_2B;  // BMI
    rel_instr_list[12] = 'h00_2_1_00_2C;  // BGE
    rel_instr_list[13] = 'h00_2_1_00_2D;  // BLT
    rel_instr_list[14] = 'h00_2_1_00_2E;  // BGT
    rel_instr_list[15] = 'h00_2_1_00_2F;  // BLE
  //rel_instr_list[16] = 'h00_2_1_00_8D;  // BSR (different test needed)

    for (instr_idx = 0; instr_idx < `TEST_REL_TOTAL_INSTR; instr_idx++) begin

      ///////////////// Load the instruction setup
      //
      opcode        = rel_instr_list[instr_idx][ 7: 0];
      prebyte       = rel_instr_list[instr_idx][15: 8];
      operand_size  = rel_instr_list[instr_idx][17:16];
      $display("[TB: tc_dv_rel_instr]"); 
      $display("[TB: tc_dv_rel_instr]"); 
      $display("[TB: tc_dv_rel_instr] ////////////////////////////////////////////////////////////////////"); 
      $write("[TB; tc_dv_rel_instr] // Testcase ");
      print_opcode_info(prebyte, opcode, 1'b1);
      $display("[TB: tc_dv_rel_instr] ////////////////////////////////////////////////////////////////////"); 

      rand_itr_idx = 1;
      error_cnt = 0;
      while ((rand_itr_idx <= rand_itr_total) && (error_cnt == 0)) begin
      
        $display("[TB: tc_dv_rel_instr]"); 
        $write("[TB: tc_dv_rel_instr] Random Iteration %0d of %0d for ",rand_itr_idx,rand_itr_total);
        print_opcode_info(prebyte, opcode, 1'b1);

        ///////////////// Select or randomize the stack pointer
        //
        stack_ptr_sel = choose_stack_ptr(rel_instr_list[instr_idx][21:20]);
      
      
        ///////////////// Loading testbench template
        //
        if (rand_itr_idx == 1) begin
          $display("[TB: tc_dv_rel_instr] Loading testbench template: %0s", hex_file);
          $readmemh(hex_file,`tb_mem);
        end else begin
          $display("[TB: tc_dv_rel_instr] Skip loading testbench template for subsequent randomization iterations");
        end
      
      
        ///////////////// Randomizing data block
        //
        random_block_p(`asm_code_under_test,`asm_data_block_last_byte);
        $display("writing random data from `asm_code_under_test to `asm_data_block_last_byte");
   

        ///////////////// Write opcode under test
        //
        //           code_under_test:
        // 70 FF 42    neg   >data_addr
        // 7E F0 1F    jmp   save_state
        //
        addr_ptr = `asm_code_under_test_mid;
        write_opcode(prebyte, opcode, addr_ptr, 1'b0);
        $display(" *** OPCODE UNDER TEST *** ");
      
        // Save address pointer
        rel_addr_ptr = addr_ptr;
        addr_ptr++;
    
        ///////////////// Write JMP opcode & program done address
        //
        write_jump_done(stack_ptr_sel, addr_ptr);
    
        data_block_start = addr_ptr;
        rand32 = {$random(seed)};
        
        ///////////////// 50/50 choice to branch forwards or backwards
        // 
        if(rand32[31]) begin
          $write("[TB: tc_dv_rel_instr] Creating a random address for a forward branch... ");
          effective_addr = data_block_start + ((rand32[15:0])%(`asm_code_under_test_br_fwd - data_block_start));
          $display("effective address = 0x%4x", effective_addr);
        end else begin
          $write("[TB: tc_dv_rel_instr] Creating a random address for a backward branch... ");
          effective_addr = `asm_code_under_test_br_bwd + ((rand32[15:0])%(`asm_code_under_test_mid - `asm_code_under_test_br_bwd - 4)); // 4bytes of INCA, JMP
          $display("effective address = 0x%4x", effective_addr);
        end


        ///////////////// Create a random relative address offset for the data
        //
        $write("[TB: tc_dv_rel_instr] Calculate relative address offset... ");
        temp16 = effective_addr - (rel_addr_ptr + 1); // Offset = ea - pc
        rel_addr_offset = temp16[7:0];
        $display("relative offset = 0x%2x", rel_addr_offset);
      

        ///////////////// Write offset byte for relative address instructions
        //
        write_tb_mem8p(rel_addr_ptr, rel_addr_offset);
        $display("writing relative offset to the relative address field in instruction");


        ///////////////// Write INCA
        //
        addr_ptr = effective_addr;
        write_opcode('h0, 'h4C, addr_ptr, 1'b0);
        $display(" writing INCA canary instruction");


        ///////////////// Write JMP opcode & program done address
        //
        write_jump_done(stack_ptr_sel, addr_ptr);
    

        ///////////////// Write random data to stack & vector table
        //
        random_block_p(`asm_stack_end, 16'hFFFF);
        $display("writing random data to stack & vector table *** This includes processor initalization state! ***");
       
      
        ///////////////// Initialize the processor state on the stack
        //
        //write_tb_mem8p( `asm_init_cc,  ); // CC
        //write_tb_mem8p( `asm_init_a,   ); // A
        //write_tb_mem8p( `asm_init_b,   ); // B
        //write_tb_mem8p( `asm_init_dp,  ); // DP
        //write_tb_mem16p(`asm_init_x,   ); // X
        //write_tb_mem16p(`asm_init_y,   ); // Y
        //write_tb_mem16p(`asm_init_u_s, ); // U or S
        write_tb_mem16p(`asm_init_pc,`asm_code_under_test_mid); $display("setting PC stack intialization value to `asm_code_under_test_mid");
      
      
        ///////////////// Initialize Reset Vector
        //
        write_reset_vector(stack_ptr_sel);
      
      
        ///////////////// Copy testbench program into model and DUT memory
        //
        copy_tb_mem;
    
      
        ///////////////// Reset DUT and Model
        //
        $display("[TB: tc_dv_rel_instr] Resetting DUT and Model");
        reset = 1'b1;
        wait_clk_cycles(4);
     

        ///////////////// Ensure the output port are cleared
        //
        $display("[TB: tc_dv_rel_instr] Waiting for output ports of Model and DUT to clear...");
        wait_bits_clear(8'hFF, `TEST_REL_RESET_CYCLES, error_cnt);
      
      
        ///////////////// Release Reset and begin testcase
        //
        $display("[TB: tc_dv_rel_instr] Release reset and begin testcase!");
        reset = 1'b0;
        
      
        ///////////////// Waiting for indication of begining of code under test
        //
        $display("[TB: tc_dv_rel_instr] Waiting for Model and DUT to indicate begining of code under test...");
        wait_bits_set(8'h01, `TEST_REL_START_CYCLES, error_cnt);
      
        
        ///////////////// Waiting for indication of completed code under test
        //
        $display("[TB: tc_dv_rel_instr] Waiting for Model and DUT to indicate completion of code under test...");
        wait_bits_set(8'h80, `TEST_REL_FINISH_CYCLES, error_cnt);
      
        wait_clk_cycles(4); // wait a few cycles to capture the output port in waveform dump

    error_cnt += model_error; //add model error to error count




        $display("[TB: tb_dv_test_code] Resetting DUT and Model");
        reset = 1'b1;
        wait_clk_cycles(4);

        ///////////////// Running a diff on the memories
        //
        $display("[TB: tc_dv_rel_instr] Comparing DUT memory and Model memory...");
        error_cnt += mem_diff_cnt(1'b0);
      


        ///////////////// Test PASS / FAIL summary 
        //
        if (error_cnt == 0) begin
          $write("[TB: tc_dv_rel_instr] Test PASS for interation %0d of %0d for ", rand_itr_idx, rand_itr_total);
          print_opcode_info(prebyte, opcode, 1'b1);
          pass_test_cnt++;
        end else begin
          $display("[TB: tc_dv_rel_instr] ERROR count: %0d", error_cnt);
          $write("[TB; tc_dv_rel_instr] Test FAIL for interation %0d of %0d for ", rand_itr_idx, rand_itr_total);
          print_opcode_info(prebyte, opcode, 1'b1);
          save_tb_mem("tc_dv_rel_instr",prebyte,opcode,rand_itr_idx);
          $display("[TB: tc_dv_rel_instr] Exiting randomization iteration loop... ");
          fail_test_cnt++;
        end


        rand_itr_idx++;
      end
    end
  end
  endtask
  

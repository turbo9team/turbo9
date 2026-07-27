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
// Engineer: Kevin Phillipson & Michael Rywalt
// Description: Testcase: Exchange & Transfer instructions
//
//////////////////////////////////////////////////////////////////////////////
// History:
// 07.14.2023 - Kevin Phillipson
//   File header added
//
//////////////////////////////////////////////////////////////////////////////
// [TURBO9_HEADER_END]

/////////////////////////////////////////////////////////////////////////////
//                  Inherent Addressing Instruction Testcase
/////////////////////////////////////////////////////////////////////////////

  `define TEST_EXG_TFR_TOTAL_INSTR    2
  `define TEST_EXG_TFR_RESET_CYCLES   40  // (16  nominal)
  `define TEST_EXG_TFR_START_CYCLES   200 // (100 nominal)
  `define TEST_EXG_TFR_FINISH_CYCLES  500 // (240 nominal)

  `define TEST_EXG_TFR_SEL_D     'b0000
  `define TEST_EXG_TFR_SEL_X     'b0001
  `define TEST_EXG_TFR_SEL_Y     'b0010
  `define TEST_EXG_TFR_SEL_US    'b0011
  `define TEST_EXG_TFR_SEL_SP    'b0100
  `define TEST_EXG_TFR_SEL_PC    'b0101
  //                            
  `define TEST_EXG_TFR_SEL_0110  'b0110 
  `define TEST_EXG_TFR_SEL_0111  'b0111 
  //                            
  `define TEST_EXG_TFR_SEL_A     'b1000
  `define TEST_EXG_TFR_SEL_B     'b1001
  `define TEST_EXG_TFR_SEL_CCR   'b1010
  `define TEST_EXG_TFR_SEL_DPR   'b1011

  ////////////////////////////////////////////////////////////////////////////
  // Test Direct Addressing Instructions
  ////////////////////////////////////////////////////////////////////////////
  task tc_dv_exg_tfr_instr;

    reg [15:0] addr_ptr;
    reg [15:0] inh_addr_ptr;
    reg [15:0] data_block_start;
    reg [15:0] data_ea;
    reg [31:0] rand32;

    integer inh_instr_list [0:`TEST_EXG_TFR_TOTAL_INSTR-1];
    integer instr_idx;
    integer error_cnt;

    integer rand_itr_idx;

    reg        stack_ptr_sel;
    reg [ 1:0] operand_size;
    reg [ 7:0] prebyte;
    reg [ 7:0] opcode;

    reg [ 3:0] postbyte_src;
    reg [ 3:0] postbyte_dst;

  begin
    // inh_instr_list define:
    // [23:20] : Stack ptr sel : 'h0 = S     / 'h1 = U      / 'h2 = random
    // [19:16] : Operand size  : 'h1 = 8bit  / 'h2 = 16bit
    // [15: 8] : Prebyte       : 'h00 = none / 'h10 = Page2 / 'h11 = Page3
    // [ 7: 0] : Opcode

    // Page 1
    inh_instr_list[0] =  'h00_2_1_00_1E; // EXG
    inh_instr_list[1] =  'h00_2_1_00_1F; // TFR

    for (instr_idx = 0; instr_idx < `TEST_EXG_TFR_TOTAL_INSTR; instr_idx++) begin

      ///////////////// Load the instruction setup
      //
      opcode        = inh_instr_list[instr_idx][ 7: 0];
      prebyte       = inh_instr_list[instr_idx][15: 8];
      operand_size  = inh_instr_list[instr_idx][17:16];
      $display("[TB: tc_dv_exg_tfr_instr]"); 
      $display("[TB: tc_dv_exg_tfr_instr]"); 
      $display("[TB: tc_dv_exg_tfr_instr] ////////////////////////////////////////////////////////////////////"); 
      $write("[TB; tc_dv_exg_tfr_instr] // Testcase ");
      print_opcode_info(prebyte, opcode, 1'b1);
      $display("[TB: tc_dv_exg_tfr_instr] ////////////////////////////////////////////////////////////////////"); 

      rand_itr_idx = 1;
      error_cnt = 0;
      while ((rand_itr_idx <= rand_itr_total) && (error_cnt == 0)) begin
      
        $display("[TB: tc_dv_exg_tfr_instr]"); 
        $write("[TB: tc_dv_exg_tfr_instr] Random Iteration %0d of %0d for ",rand_itr_idx,rand_itr_total);
        print_opcode_info(prebyte, opcode, 1'b1);

        ///////////////// Select or randomize the stack pointer
        //
        stack_ptr_sel = choose_stack_ptr(inh_instr_list[instr_idx][21:20]);
      

        ///////////////// Loading testbench template
        //
        if (rand_itr_idx == 1) begin
          $display("[TB: tc_dv_exg_tfr_instr] Loading testbench template: %0s", hex_file);
          $readmemh(hex_file,`tb_mem);
        end else begin
          $display("[TB: tc_dv_exg_tfr_instr] Skip loading testbench template for subsequent randomization iterations");
        end
      
      
        ///////////////// Randomizing data block
        //
        random_block_p(`asm_code_under_test,`asm_data_block_last_byte);
        $display("writing random data from `asm_code_under_test to `asm_data_block_last_byte");
   

        ///////////////// Write opcode under test
        //
        //           code_under_test:
        // 1E 12       exg   x,y
        // 7E F0 1F    jmp   save_state
        //
        addr_ptr = `asm_code_under_test;
        write_opcode(prebyte, opcode, addr_ptr, 1'b0);
        $display(" *** OPCODE UNDER TEST *** ");
      
        ///////////////// Write the postbyte to the opcode
        //
        // Get a random number to use to select bits for most and least significant bits of exchange postbyte.
        rand32 = {$random(seed)};

        // Source Register
        postbyte_src = rand32[31:28] % 10; // values between 0 and 9, i.e. 10 valid registers
        if (postbyte_src > `TEST_EXG_TFR_SEL_PC) postbyte_src = postbyte_src + 'd2;

        // Destination Register
        postbyte_dst = rand32[27:24] % 10; // values between 0 and 9, i.e. 10 valid registers
        if (postbyte_dst > `TEST_EXG_TFR_SEL_PC) postbyte_dst = postbyte_dst + 'd2;

        // If the S stack pointer is selected, make sure the postbyte_dst doesn't select S.
        if (!stack_ptr_sel && postbyte_dst == `TEST_EXG_TFR_SEL_SP) postbyte_dst = `TEST_EXG_TFR_SEL_US;
        
        // If the U stack pointer is selected, make sure the postbyte_dst doesn't select U.
        if ( stack_ptr_sel && postbyte_dst == `TEST_EXG_TFR_SEL_US) postbyte_dst = `TEST_EXG_TFR_SEL_SP;
    
        // If postbyte_dst selects PC, select D 
        if (postbyte_dst == `TEST_EXG_TFR_SEL_PC) postbyte_dst = `TEST_EXG_TFR_SEL_D;

        // EXG writes back to both registers, so postbyte_src needs the same
        // SP/US/PC shielding as postbyte_dst. TFR only writes postbyte_dst;
        // its source is read-only, so no shielding is needed there.
        if (opcode == 'h1E) begin
          // If the S stack pointer is selected, make sure the postbyte_dst doesn't select S.
          if (!stack_ptr_sel && postbyte_src == `TEST_EXG_TFR_SEL_SP) postbyte_src = `TEST_EXG_TFR_SEL_US;
          
          // If the U stack pointer is selected, make sure the postbyte_dst doesn't select U.
          if ( stack_ptr_sel && postbyte_src == `TEST_EXG_TFR_SEL_US) postbyte_src = `TEST_EXG_TFR_SEL_SP;
         
          // If postbyte_dst selects PC, select D 
          if (postbyte_src == `TEST_EXG_TFR_SEL_PC) postbyte_src = `TEST_EXG_TFR_SEL_D;
        end

        write_tb_mem8p(addr_ptr, {postbyte_src,postbyte_dst});
        addr_ptr++;

        print_exg_tfr_register(postbyte_src);
        if (opcode == 'h1E) begin
          $write(" <- exchange -> ");
        end else begin
          $write(" -> transfer -> ");
        end
        print_exg_tfr_register(postbyte_dst);
        $display("");


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
        write_tb_mem16p(`asm_init_pc,`asm_code_under_test); $display("setting PC stack intialization value to `asm_code_under_test");
      
      
        ///////////////// Initialize Reset Vector
        //
        write_reset_vector(stack_ptr_sel);
      
      
        ///////////////// Copy testbench program into model and DUT memory
        //
        copy_tb_mem;
    
      
        ///////////////// Reset DUT and Model
        //
        $display("[TB: tc_dv_exg_tfr_instr] Resetting DUT and Model");
        reset = 1'b1;
        wait_clk_cycles(4);
     

        ///////////////// Ensure the output port are cleared
        //
        $display("[TB: tc_dv_exg_tfr_instr] Waiting for output ports of Model and DUT to clear...");
        wait_bits_clear(8'hFF, `TEST_EXG_TFR_RESET_CYCLES, error_cnt);
      
      
        ///////////////// Release Reset and begin testcase
        //
        $display("[TB: tc_dv_exg_tfr_instr] Release reset and begin testcase!");
        reset = 1'b0;
        
      
        ///////////////// Waiting for indication of begining of code under test
        //
        $display("[TB: tc_dv_exg_tfr_instr] Waiting for Model and DUT to indicate begining of code under test...");
        wait_bits_set(8'h01, `TEST_EXG_TFR_START_CYCLES, error_cnt);
      
        
        ///////////////// Waiting for indication of completed code under test
        //
        $display("[TB: tc_dv_exg_tfr_instr] Waiting for Model and DUT to indicate completion of code under test...");
        wait_bits_set(8'h02, `TEST_EXG_TFR_FINISH_CYCLES, error_cnt);
      
        wait_clk_cycles(4); // wait a few cycles to capture the output port in waveform dump

        error_cnt += `model_error; //add model error to error count

        $display("[TB: tb_dv_test_code] Resetting DUT and Model");
        reset = 1'b1;
        wait_clk_cycles(4);

        ///////////////// Running a diff on the memories
        //
        $display("[TB: tc_dv_exg_tfr_instr] Comparing DUT memory and Model memory...");
        error_cnt += mem_diff_cnt(1'b0);
      


        ///////////////// Test PASS / FAIL summary 
        //
        if (error_cnt == 0) begin
          $write("[TB: tc_dv_exg_tfr_instr] Test PASS for iteration %0d of %0d for ", rand_itr_idx, rand_itr_total);
          print_opcode_info(prebyte, opcode, 1'b1);
          pass_test_cnt++;
        end else begin
          $display("[TB: tc_dv_exg_tfr_instr] ERROR count: %0d", error_cnt);
          $write("[TB; tc_dv_exg_tfr_instr] Test FAIL for iteration %0d of %0d for ", rand_itr_idx, rand_itr_total);
          print_opcode_info(prebyte, opcode, 1'b1);
          save_tb_mem("tc_dv_exg_tfr_instr",prebyte,opcode,rand_itr_idx);
          $display("[TB: tc_dv_exg_tfr_instr] Exiting randomization iteration loop... ");
          fail_test_cnt++;
        end


        rand_itr_idx++;
      end
    end
  end
  endtask
  

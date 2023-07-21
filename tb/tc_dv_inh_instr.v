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
// Description: Testcase: Inherent instructions
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

  `define TEST_INH_TOTAL_INSTR    30
  `define TEST_INH_RESET_CYCLES   40  // (16  nominal)
  `define TEST_INH_START_CYCLES   200 // (100 nominal)
  `define TEST_INH_FINISH_CYCLES  500 // (240 nominal)

  ////////////////////////////////////////////////////////////////////////////
  // Test Direct Addressing Instructions
  ////////////////////////////////////////////////////////////////////////////
  task tc_dv_inh_instr;

    reg [15:0] addr_ptr;
    reg [15:0] inh_addr_ptr;
    reg [15:0] data_block_start;
    reg [15:0] data_ea;
    reg [31:0] rand32;

    integer inh_instr_list [0:`TEST_INH_TOTAL_INSTR-1];
    integer instr_idx;
    integer error_cnt;

    integer rand_itr_idx;

    reg        stack_ptr_sel;
    reg [ 1:0] operand_size;
    reg [ 7:0] prebyte;
    reg [ 7:0] opcode;


  begin
    // inh_instr_list define:
    // [23:20] : Stack ptr sel : 'h0 = S     / 'h1 = U      / 'h2 = random
    // [19:16] : Operand size  : 'h1 = 8bit  / 'h2 = 16bit
    // [15: 8] : Prebyte       : 'h00 = none / 'h10 = Page2 / 'h11 = Page3
    // [ 7: 0] : Opcode

    // Page 1
    //inh_instr_list[] =  'h00_2_1_00_10; // Page 1
    //inh_instr_list[] =  'h00_2_1_00_11; // Page 2
    inh_instr_list[ 0] =  'h00_2_1_00_12; // NOP
    //inh_instr_list[] =  'h00_2_1_00_13; // SYNC
    inh_instr_list[ 1] =  'h00_2_1_00_14; // EMUL
    //inh_instr_list[] =  'h00_2_1_00_15;
    //inh_instr_list[] =  'h00_2_1_00_16; // LBRA
    //inh_instr_list[] =  'h00_2_1_00_17; // LBSR
    inh_instr_list[ 2] =  'h00_2_1_00_18; // IDIV
    inh_instr_list[ 3] =  'h00_2_1_00_19; // DAA
    //inh_instr_list[] =  'h00_2_1_00_1A; // ORCC
    //inh_instr_list[] =  'h00_2_1_00_1B;
    //inh_instr_list[] =  'h00_2_1_00_1C; // ANDCC
    inh_instr_list[ 4] =  'h00_2_1_00_1D; // SEX
    //inh_instr_list[] =  'h00_2_1_00_1E; // EXG
    //inh_instr_list[] =  'h00_2_1_00_1F; // TRF

    inh_instr_list[ 5] =  'h00_2_1_00_3A; // ABX
    inh_instr_list[ 6] =  'h00_2_1_00_3D; // MUL
    //
    inh_instr_list[ 7] =  'h00_2_1_00_40; // NEGA
    //inh_instr_list[] =  'h00_2_1_00_41;
    //inh_instr_list[] =  'h00_2_1_00_42;
    inh_instr_list[ 8] =  'h00_2_1_00_43; // COMA
    inh_instr_list[ 9] =  'h00_2_1_00_44; // LSRA
    //inh_instr_list[] =  'h00_2_1_00_45;
    inh_instr_list[10] =  'h00_2_1_00_46; // RORA
    inh_instr_list[11] =  'h00_2_1_00_47; // ASRA
    inh_instr_list[12] =  'h00_2_1_00_48; // ASLA,LSLA
    inh_instr_list[13] =  'h00_2_1_00_49; // ROLA
    inh_instr_list[14] =  'h00_2_1_00_4A; // DECA
    //inh_instr_list[] =  'h00_2_1_00_4B;
    inh_instr_list[15] =  'h00_2_1_00_4C; // INCA
    inh_instr_list[16] =  'h00_2_1_00_4D; // TSTA
    //inh_instr_list[] =  'h00_2_1_00_4E;
    inh_instr_list[17] =  'h00_2_1_00_4F; // CLRA
    //
    inh_instr_list[18] =  'h00_2_1_00_50; // NEGB
    //inh_instr_list[] =  'h00_2_1_00_51;
    //inh_instr_list[] =  'h00_2_1_00_52;
    inh_instr_list[19] =  'h00_2_1_00_53; // COMB
    inh_instr_list[20] =  'h00_2_1_00_54; // LSRB
    //inh_instr_list[] =  'h00_2_1_00_55;
    inh_instr_list[21] =  'h00_2_1_00_56; // RORB
    inh_instr_list[22] =  'h00_2_1_00_57; // ASRB
    inh_instr_list[23] =  'h00_2_1_00_58; // ASLB,LSLB
    inh_instr_list[24] =  'h00_2_1_00_59; // ROLB
    inh_instr_list[25] =  'h00_2_1_00_5A; // DECB
    //inh_instr_list[] =  'h00_2_1_00_5B;
    inh_instr_list[26] =  'h00_2_1_00_5C; // INCB
    inh_instr_list[27] =  'h00_2_1_00_5D; // TSTB
    //inh_instr_list[] =  'h00_2_1_00_5E;
    inh_instr_list[28] =  'h00_2_1_00_5F; // CLRB
    inh_instr_list[29] =  'h00_2_1_10_18; // IDIVS


    for (instr_idx = 0; instr_idx < `TEST_INH_TOTAL_INSTR; instr_idx++) begin

      ///////////////// Load the instruction setup
      //
      opcode        = inh_instr_list[instr_idx][ 7: 0];
      prebyte       = inh_instr_list[instr_idx][15: 8];
      operand_size  = inh_instr_list[instr_idx][17:16];
      $display("[TB: tc_dv_inh_instr]"); 
      $display("[TB: tc_dv_inh_instr]"); 
      $display("[TB: tc_dv_inh_instr] ////////////////////////////////////////////////////////////////////"); 
      $write("[TB; tc_dv_inh_instr] // Testcase ");
      print_opcode_info(prebyte, opcode, 1'b1);
      $display("[TB: tc_dv_inh_instr] ////////////////////////////////////////////////////////////////////"); 

      rand_itr_idx = 1;
      error_cnt = 0;
      while ((rand_itr_idx <= rand_itr_total) && (error_cnt == 0)) begin
      
        $display("[TB: tc_dv_inh_instr]"); 
        $write("[TB: tc_dv_inh_instr] Random Iteration %0d of %0d for ",rand_itr_idx,rand_itr_total);
        print_opcode_info(prebyte, opcode, 1'b1);

        ///////////////// Select or randomize the stack pointer
        //
        stack_ptr_sel = choose_stack_ptr(inh_instr_list[instr_idx][21:20]);
      
      
        ///////////////// Loading testbench template
        //
        if (rand_itr_idx == 1) begin
          $display("[TB: tc_dv_inh_instr] Loading testbench template: %0s", hex_file);
          $readmemh(hex_file,`tb_mem);
        end else begin
          $display("[TB: tc_dv_inh_instr] Skip loading testbench template for subsequent randomization iterations");
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
        addr_ptr = `asm_code_under_test;
        write_opcode(prebyte, opcode, addr_ptr, 1'b0);
        $display(" *** OPCODE UNDER TEST *** ");
      
    
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
        $display("[TB: tc_dv_inh_instr] Resetting DUT and Model");
        reset = 1'b1;
        wait_clk_cycles(4);
     

        ///////////////// Ensure the output port are cleared
        //
        $display("[TB: tc_dv_inh_instr] Waiting for output ports of Model and DUT to clear...");
        wait_bits_clear(8'hFF, `TEST_INH_RESET_CYCLES, error_cnt);
      
      
        ///////////////// Release Reset and begin testcase
        //
        $display("[TB: tc_dv_inh_instr] Release reset and begin testcase!");
        reset = 1'b0;
        
      
        ///////////////// Waiting for indication of begining of code under test
        //
        $display("[TB: tc_dv_inh_instr] Waiting for Model and DUT to indicate begining of code under test...");
        wait_bits_set(8'h01, `TEST_INH_START_CYCLES, error_cnt);
      
        
        ///////////////// Waiting for indication of completed code under test
        //
        $display("[TB: tc_dv_inh_instr] Waiting for Model and DUT to indicate completion of code under test...");
        wait_bits_set(8'h80, `TEST_INH_FINISH_CYCLES, error_cnt);
      
        wait_clk_cycles(4); // wait a few cycles to capture the output port in waveform dump

    error_cnt += model_error; //add model error to error count




        $display("[TB: tb_dv_test_code] Resetting DUT and Model");
        reset = 1'b1;
        wait_clk_cycles(4);

        ///////////////// Running a diff on the memories
        //
        $display("[TB: tc_dv_inh_instr] Comparing DUT memory and Model memory...");
        error_cnt += mem_diff_cnt(1'b0);
      


        ///////////////// Test PASS / FAIL summary 
        //
        if (error_cnt == 0) begin
          $write("[TB: tc_dv_inh_instr] Test PASS for iteration %0d of %0d for ", rand_itr_idx, rand_itr_total);
          print_opcode_info(prebyte, opcode, 1'b1);
          pass_test_cnt++;
        end else begin
          $display("[TB: tc_dv_inh_instr] ERROR count: %0d", error_cnt);
          $write("[TB; tc_dv_inh_instr] Test FAIL for iteration %0d of %0d for ", rand_itr_idx, rand_itr_total);
          print_opcode_info(prebyte, opcode, 1'b1);
          save_tb_mem("tc_dv_inh_instr",prebyte,opcode,rand_itr_idx);
          $display("[TB: tc_dv_inh_instr] Exiting randomization iteration loop... ");
          fail_test_cnt++;
        end


        rand_itr_idx++;
      end
    end
  end
  endtask
  

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
// Description: Testcase: Direct instructions
//
//////////////////////////////////////////////////////////////////////////////
// History:
// 07.14.2023 - Kevin Phillipson
//   File header added
//
//////////////////////////////////////////////////////////////////////////////
// [TURBO9_HEADER_END]

/////////////////////////////////////////////////////////////////////////////
//                  Direct Addressing Instruction Testcase
/////////////////////////////////////////////////////////////////////////////

  `define TEST_DIR_TOTAL_INSTR    50
  `define TEST_DIR_RESET_CYCLES   40  // (16  nominal)
  `define TEST_DIR_START_CYCLES   200 // (100 nominal)
  `define TEST_DIR_FINISH_CYCLES  500 // (240 nominal)

  ////////////////////////////////////////////////////////////////////////////
  // Test Direct Addressing Instructions
  ////////////////////////////////////////////////////////////////////////////
  task tc_dv_dir_instr;

    reg [15:0] addr_ptr;
    reg [15:0] dir_addr_ptr;
    reg [15:0] data_block_start;
    reg [15:0] data_ea;
    reg [31:0] rand32;

    integer dir_instr_list [0:`TEST_DIR_TOTAL_INSTR-1];
    integer instr_idx;
    integer error_cnt;

    integer rand_itr_idx;

    reg        stack_ptr_sel;
    reg [ 1:0] operand_size;
    reg [ 7:0] prebyte;
    reg [ 7:0] opcode;


  begin
    // dir_instr_list define:
    // [23:20] : Stack ptr sel : 'h0 = S     / 'h1 = U      / 'h2 = random
    // [19:16] : Operand size  : 'h1 = 8bit  / 'h2 = 16bit
    // [15: 8] : Prebyte       : 'h00 = none / 'h10 = Page2 / 'h11 = Page3
    // [ 7: 0] : Opcode

    dir_instr_list[ 0] = 'h00_2_1_00_00; // NEG 
    //dir_instr_list[] = 'h00_2_1_00_01; // 
    //dir_instr_list[] = 'h00_2_1_00_02; // 
    dir_instr_list[ 1] = 'h00_2_1_00_03; // COM
    dir_instr_list[ 2] = 'h00_2_1_00_04; // LSR
    //dir_instr_list[] = 'h00_2_1_00_05; // 
    dir_instr_list[ 3] = 'h00_2_1_00_06; // ROR
    dir_instr_list[ 4] = 'h00_2_1_00_07; // ASR
    dir_instr_list[ 5] = 'h00_2_1_00_08; // ASL,LSL
    dir_instr_list[ 6] = 'h00_2_1_00_09; // ROL
    dir_instr_list[ 7] = 'h00_2_1_00_0A; // DEC
    //dir_instr_list[] = 'h00_2_1_00_0B; // 
    dir_instr_list[ 8] = 'h00_2_1_00_0C; // INC
    dir_instr_list[ 9] = 'h00_2_1_00_0D; // TST
    //dir_instr_list[] = 'h00_2_2_00_0E; // JMP (different test)
    dir_instr_list[10] = 'h00_2_1_00_0F; // CLR

    dir_instr_list[11] = 'h00_2_1_00_90; // SUBA
    dir_instr_list[12] = 'h00_2_1_00_91; // CMPA
    dir_instr_list[13] = 'h00_2_1_00_92; // SBCA
    dir_instr_list[14] = 'h00_2_2_00_93; // SUBD
    dir_instr_list[15] = 'h00_2_1_00_94; // ANDA
    dir_instr_list[16] = 'h00_2_1_00_95; // BITA
    dir_instr_list[17] = 'h00_2_1_00_96; // LDA
    dir_instr_list[18] = 'h00_2_1_00_97; // STA
    dir_instr_list[19] = 'h00_2_1_00_98; // EORA
    dir_instr_list[20] = 'h00_2_1_00_99; // ADCA
    dir_instr_list[21] = 'h00_2_1_00_9A; // ORA
    dir_instr_list[22] = 'h00_2_1_00_9B; // ADDA
    dir_instr_list[23] = 'h00_2_2_00_9C; // CMPX
    //dir_instr_list[] = 'h00_2_2_00_9D; // JSR (different test)
    dir_instr_list[24] = 'h00_2_2_00_9E; // LDX
    dir_instr_list[25] = 'h00_2_2_00_9F; // STX

    dir_instr_list[26] = 'h00_2_1_00_D0; // SUBB 
    dir_instr_list[27] = 'h00_2_1_00_D1; // CMPB 
    dir_instr_list[28] = 'h00_2_1_00_D2; // SBCB 
    dir_instr_list[29] = 'h00_2_2_00_D3; // ADDD 
    dir_instr_list[30] = 'h00_2_1_00_D4; // ANDB 
    dir_instr_list[31] = 'h00_2_1_00_D5; // BITB 
    dir_instr_list[32] = 'h00_2_1_00_D6; // LDB  
    dir_instr_list[33] = 'h00_2_1_00_D7; // STB  
    dir_instr_list[34] = 'h00_2_1_00_D8; // EORB 
    dir_instr_list[35] = 'h00_2_1_00_D9; // ADCB 
    dir_instr_list[36] = 'h00_2_1_00_DA; // ORB  
    dir_instr_list[37] = 'h00_2_1_00_DB; // ADDB 
    dir_instr_list[38] = 'h00_2_2_00_DC; // LDD 
    dir_instr_list[39] = 'h00_2_2_00_DD; // STD
    dir_instr_list[40] = 'h00_0_2_00_DE; // LDU  
    dir_instr_list[41] = 'h00_0_2_00_DF; // STU

    // Page 2                   
    dir_instr_list[42] = 'h00_2_2_10_93; // CMPD
    dir_instr_list[43] = 'h00_2_2_10_9C; // CMPY
    dir_instr_list[44] = 'h00_2_2_10_9E; // LDY
    dir_instr_list[45] = 'h00_2_2_10_9F; // STY
    dir_instr_list[46] = 'h00_1_2_10_DE; // LDS
    dir_instr_list[47] = 'h00_1_2_10_DF; // STS

    // Page 3                  
    dir_instr_list[48] = 'h00_0_2_11_93; // CMPU
    dir_instr_list[49] = 'h00_1_2_11_9C; // CMPS

    for (instr_idx = 0; instr_idx < `TEST_DIR_TOTAL_INSTR; instr_idx++) begin

      ///////////////// Load the instruction setup
      //
      opcode        = dir_instr_list[instr_idx][ 7: 0];
      prebyte       = dir_instr_list[instr_idx][15: 8];
      operand_size  = dir_instr_list[instr_idx][17:16];
      $display("[TB: tc_dv_dir_instr]"); 
      $display("[TB: tc_dv_dir_instr]"); 
      $display("[TB: tc_dv_dir_instr] ////////////////////////////////////////////////////////////////////"); 
      $write("[TB; tc_dv_dir_instr] // Testcase ");
      print_opcode_info(prebyte, opcode, 1'b1);
      $display("[TB: tc_dv_dir_instr] ////////////////////////////////////////////////////////////////////"); 

      rand_itr_idx = 1;
      error_cnt = 0;
      while ((rand_itr_idx <= rand_itr_total) && (error_cnt == 0)) begin
      
        $display("[TB: tc_dv_dir_instr]"); 
        $write("[TB: tc_dv_dir_instr] Random Iteration %0d of %0d for ",rand_itr_idx,rand_itr_total);
        print_opcode_info(prebyte, opcode, 1'b1);

        ///////////////// Select or randomize the stack pointer
        //
        stack_ptr_sel = choose_stack_ptr(dir_instr_list[instr_idx][21:20]);
      
      
        ///////////////// Loading testbench template
        //
        if (rand_itr_idx == 1) begin
          $display("[TB: tc_dv_dir_instr] Loading testbench template: %0s",hex_file);
          $readmemh(hex_file,`tb_mem);
        end else begin
          $display("[TB: tc_dv_dir_instr] Skip loading testbench template for subsequent randomization iterations");
        end
      
      
        ///////////////// Randomizing data block
        //
        random_block_p(`asm_code_under_test,`asm_data_block_last_byte);
        $display("writing random data from `asm_code_under_test to `asm_data_block_last_byte");
   

        ///////////////// Write opcode under test
        //
        //           code_under_test:
        // 00 42       neg   <data_addr
        // 7E F0 1F    jmp   save_state
        //
        addr_ptr = `asm_code_under_test;
        write_opcode(prebyte, opcode, addr_ptr, 1'b0);
        $display(" *** OPCODE UNDER TEST *** ");
      
    
        ///////////////// Save a pointer to the direct address
        //
        dir_addr_ptr = addr_ptr++;
        $display("[TB: tc_dv_dir_instr] @ 0x%4x : This is the direct address location, saving. Will be updated after calculating effective address", dir_addr_ptr);
      
    
        ///////////////// Write JMP opcode & program done address
        //
        write_jump_done(stack_ptr_sel, addr_ptr);
      
    
        ///////////////// Calculate the start and range of the data block
        //
        data_block_start = addr_ptr;
        $display("[TB: tc_dv_dir_instr] @ 0x%4x to 0x%4x : will be used as the data block (%0d bytes)",
          data_block_start,`asm_data_block_last_byte,(`asm_data_block_end-data_block_start));
      
      
        ///////////////// Create a random effective address for the data
        //
        $write("[TB: tc_dv_dir_instr] Creating a random address within the data block for data... ");
        rand32  = {$random(seed)}; //{} = unsigned
        data_ea = data_block_start + ((rand32[15:0])%(`asm_data_block_end - data_block_start - operand_size));
        $display("effective address = 0x%4x", data_ea);
      
    
        ///////////////// Write low byte of effective address to direct address
        //
        write_tb_mem8p(dir_addr_ptr, data_ea[7:0]);
        $display("writing low byte of effective address to the direct address field in instruction");
      
      
        ///////////////// Write random data to stack & vector table
        //
        random_block_p(`asm_stack_end, 16'hFFFF);
        $display("writing random data to stack & vector table *** This includes processor initalization state! ***");
       
      
        ///////////////// Initialize the processor state on the stack
        //
        //write_tb_mem8p( `asm_init_cc,  ); // CC
        //write_tb_mem8p( `asm_init_a,   ); // A
        //write_tb_mem8p( `asm_init_b,   ); // B
        write_tb_mem8p( `asm_init_dp,  data_ea[15:8]); $display("setting DP stack intialization value to high byte of effective address"); 
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
        $display("[TB: tc_dv_dir_instr] Resetting DUT and Model");
        reset = 1'b1;
        wait_clk_cycles(4);
     

        ///////////////// Ensure the output port are cleared
        //
        $display("[TB: tc_dv_dir_instr] Waiting for output ports of Model and DUT to clear...");
        wait_bits_clear(8'hFF, `TEST_DIR_RESET_CYCLES, error_cnt);
      
      
        ///////////////// Release Reset and begin testcase
        //
        $display("[TB: tc_dv_dir_instr] Release reset and begin testcase!");
        reset = 1'b0;
        
      
        ///////////////// Waiting for indication of begining of code under test
        //
        $display("[TB: tc_dv_dir_instr] Waiting for Model and DUT to indicate begining of code under test...");
        wait_bits_set(8'h01, `TEST_DIR_START_CYCLES, error_cnt);
      
        
        ///////////////// Waiting for indication of completed code under test
        //
        $display("[TB: tc_dv_dir_instr] Waiting for Model and DUT to indicate completion of code under test...");
        wait_bits_set(8'h80, `TEST_DIR_FINISH_CYCLES, error_cnt);
      
        wait_clk_cycles(4); // wait a few cycles to capture the output port in waveform dump

    error_cnt += model_error; //add model error to error count




        $display("[TB: tb_dv_test_code] Resetting DUT and Model");
        reset = 1'b1;
        wait_clk_cycles(4);

        ///////////////// Running a diff on the memories
        //
        $display("[TB: tc_dv_dir_instr] Comparing DUT memory and Model memory...");
        error_cnt += mem_diff_cnt(1'b0);
      


        ///////////////// Test PASS / FAIL summary 
        //
        if (error_cnt == 0) begin
          $write("[TB: tc_dv_dir_instr] Test PASS for interation %0d of %0d for ", rand_itr_idx, rand_itr_total);
          print_opcode_info(prebyte, opcode, 1'b1);
          pass_test_cnt++;
        end else begin
          $display("[TB: tc_dv_dir_instr] ERROR count: %0d", error_cnt);
          $write("[TB; tc_dv_dir_instr] Test FAIL for interation %0d of %0d for ", rand_itr_idx, rand_itr_total);
          print_opcode_info(prebyte, opcode, 1'b1);
          save_tb_mem("tc_dv_dir_instr",prebyte,opcode,rand_itr_idx);
          $display("[TB: tc_dv_dir_instr] Exiting randomization iteration loop... ");
          fail_test_cnt++;
        end


        rand_itr_idx++;
      end
    end
  end
  endtask
  

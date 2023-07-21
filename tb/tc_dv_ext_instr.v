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
// Description: Testcase: Extended instructions
//
//////////////////////////////////////////////////////////////////////////////
// History:
// 07.14.2023 - Kevin Phillipson
//   File header added
//
//////////////////////////////////////////////////////////////////////////////
// [TURBO9_HEADER_END]

/////////////////////////////////////////////////////////////////////////////
//                  Extended Addressing Instruction Testcase
/////////////////////////////////////////////////////////////////////////////

  `define TEST_EXT_TOTAL_INSTR    50
  `define TEST_EXT_RESET_CYCLES   40  // (16  nominal)
  `define TEST_EXT_START_CYCLES   200 // (100 nominal)
  `define TEST_EXT_FINISH_CYCLES  500 // (240 nominal)

  ////////////////////////////////////////////////////////////////////////////
  // Test Direct Addressing Instructions
  ////////////////////////////////////////////////////////////////////////////
  task tc_dv_ext_instr;

    reg [15:0] addr_ptr;
    reg [15:0] ext_addr_ptr;
    reg [15:0] data_block_start;
    reg [15:0] data_ea;
    reg [31:0] rand32;

    integer ext_instr_list [0:`TEST_EXT_TOTAL_INSTR-1];
    integer instr_idx;
    integer error_cnt;

    integer rand_itr_idx;

    reg        stack_ptr_sel;
    reg [ 1:0] operand_size;
    reg [ 7:0] prebyte;
    reg [ 7:0] opcode;


  begin
    // ext_instr_list define:
    // [23:20] : Stack ptr sel : 'h0 = S     / 'h1 = U      / 'h2 = random
    // [19:16] : Operand size  : 'h1 = 8bit  / 'h2 = 16bit
    // [15: 8] : Prebyte       : 'h00 = none / 'h10 = Page2 / 'h11 = Page3
    // [ 7: 0] : Opcode

    ext_instr_list[ 0] = 'h00_2_1_00_70; // NEG
                                 //  71
                                 //  72
    ext_instr_list[ 1] = 'h00_2_1_00_73; // COM
    ext_instr_list[ 2] = 'h00_2_1_00_74; // LSR
                                 //  75
    ext_instr_list[ 3] = 'h00_2_1_00_76; // ROR
    ext_instr_list[ 4] = 'h00_2_1_00_77; // ASR
    ext_instr_list[ 5] = 'h00_2_1_00_78; // ASL,LSL
    ext_instr_list[ 6] = 'h00_2_1_00_79; // ROL
    ext_instr_list[ 7] = 'h00_2_1_00_7A; // DEC
                                 //  7B
    ext_instr_list[ 8] = 'h00_2_1_00_7C; // INC
    ext_instr_list[ 9] = 'h00_2_1_00_7D; // TST
//  ext_instr_list[  ] = 'h00_2_1_00_7E; // JMP
    ext_instr_list[10] = 'h00_2_1_00_7F; // CLR
    ext_instr_list[11] = 'h00_2_1_00_B0; // SUBA
    ext_instr_list[12] = 'h00_2_1_00_B1; // CMPA
    ext_instr_list[13] = 'h00_2_1_00_B2; // SBCA
    ext_instr_list[14] = 'h00_2_2_00_B3; // SUBD
    ext_instr_list[15] = 'h00_2_1_00_B4; // ANDA
    ext_instr_list[16] = 'h00_2_1_00_B5; // BITA
    ext_instr_list[17] = 'h00_2_1_00_B6; // LDA
    ext_instr_list[18] = 'h00_2_1_00_B7; // STA
    ext_instr_list[19] = 'h00_2_1_00_B8; // EORA
    ext_instr_list[20] = 'h00_2_1_00_B9; // ADCA
    ext_instr_list[21] = 'h00_2_1_00_BA; // ORA
    ext_instr_list[22] = 'h00_2_1_00_BB; // ADDA
    ext_instr_list[23] = 'h00_2_2_00_BC; // CMPX
//  ext_instr_list[  ] = 'h00_2_1_00_BD; // JSR
    ext_instr_list[24] = 'h00_2_2_00_BE; // LDX
    ext_instr_list[25] = 'h00_2_2_00_BF; // STX
    ext_instr_list[26] = 'h00_2_1_00_F0; // SUBB
    ext_instr_list[27] = 'h00_2_1_00_F1; // CMPB
    ext_instr_list[28] = 'h00_2_1_00_F2; // SBCB
    ext_instr_list[29] = 'h00_2_2_00_F3; // ADDD
    ext_instr_list[30] = 'h00_2_1_00_F4; // ANDB
    ext_instr_list[31] = 'h00_2_1_00_F5; // BITB
    ext_instr_list[32] = 'h00_2_1_00_F6; // LDB
    ext_instr_list[33] = 'h00_2_1_00_F7; // STB
    ext_instr_list[34] = 'h00_2_1_00_F8; // EORB
    ext_instr_list[35] = 'h00_2_1_00_F9; // ADCB
    ext_instr_list[36] = 'h00_2_1_00_FA; // ORB
    ext_instr_list[37] = 'h00_2_1_00_FB; // ADDB
    ext_instr_list[38] = 'h00_2_2_00_FC; // LDD
    ext_instr_list[39] = 'h00_2_2_00_FD; // STD
    ext_instr_list[40] = 'h00_0_2_00_FE; // LDU
    ext_instr_list[41] = 'h00_0_2_00_FF; // STU
  
    // Page 2
    ext_instr_list[42] = 'h00_2_2_10_B3; // CMPD
    ext_instr_list[43] = 'h00_2_2_10_BC; // CMPY
    ext_instr_list[44] = 'h00_2_2_10_BE; // LDY
    ext_instr_list[45] = 'h00_2_2_10_BF; // STY
    ext_instr_list[46] = 'h00_1_2_10_FE; // LDS
    ext_instr_list[47] = 'h00_1_2_10_FF; // STS
 
    // Page 3
    ext_instr_list[48] = 'h00_0_2_11_B3; // CMPU
    ext_instr_list[49] = 'h00_1_2_11_BC; // CMPS

    for (instr_idx = 0; instr_idx < `TEST_EXT_TOTAL_INSTR; instr_idx++) begin

      ///////////////// Load the instruction setup
      //
      opcode        = ext_instr_list[instr_idx][ 7: 0];
      prebyte       = ext_instr_list[instr_idx][15: 8];
      operand_size  = ext_instr_list[instr_idx][17:16];
      $display("[TB: tc_dv_ext_instr]"); 
      $display("[TB: tc_dv_ext_instr]"); 
      $display("[TB: tc_dv_ext_instr] ////////////////////////////////////////////////////////////////////"); 
      $write("[TB; tc_dv_ext_instr] // Testcase ");
      print_opcode_info(prebyte, opcode, 1'b1);
      $display("[TB: tc_dv_ext_instr] ////////////////////////////////////////////////////////////////////"); 

      rand_itr_idx = 1;
      error_cnt = 0;
      while ((rand_itr_idx <= rand_itr_total) && (error_cnt == 0)) begin
      
        $display("[TB: tc_dv_ext_instr]"); 
        $write("[TB: tc_dv_ext_instr] Random Iteration %0d of %0d for ",rand_itr_idx,rand_itr_total);
        print_opcode_info(prebyte, opcode, 1'b1);

        ///////////////// Select or randomize the stack pointer
        //
        stack_ptr_sel = choose_stack_ptr(ext_instr_list[instr_idx][21:20]);
      
      
        ///////////////// Loading testbench template
        //
        if (rand_itr_idx == 1) begin
          $display("[TB: tc_dv_ext_instr] Loading testbench template: %0s", hex_file);
          $readmemh(hex_file,`tb_mem);
        end else begin
          $display("[TB: tc_dv_ext_instr] Skip loading testbench template for subsequent randomization iterations");
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
      
    
        ///////////////// Save a pointer to the extended address
        //
        ext_addr_ptr = addr_ptr;
				addr_ptr += 2;
        $display("[TB: tc_dv_ext_instr] @ 0x%4x : This is the extended address location, saving. Will be updated after calculating effective address", ext_addr_ptr);
      
    
        ///////////////// Write JMP opcode & program done address
        //
        write_jump_done(stack_ptr_sel, addr_ptr);
      
    
        ///////////////// Calculate the start and range of the data block
        //
        data_block_start = addr_ptr;
        $display("[TB: tc_dv_ext_instr] @ 0x%4x to 0x%4x : will be used as the data block (%0d bytes)",
          data_block_start,`asm_data_block_last_byte,(`asm_data_block_end-data_block_start));
      
      
        ///////////////// Create a random effective address for the data
        //
        $write("[TB: tc_dv_ext_instr] Creating a random address within the data block for data... ");
        rand32  = {$random(seed)}; //{} = unsigned
        data_ea = data_block_start + ((rand32[15:0])%(`asm_data_block_end - data_block_start - operand_size));
        $display("effective address = 0x%4x", data_ea);
      
    
        ///////////////// Write effective address to extended address
        //
        write_tb_mem16p(ext_addr_ptr, data_ea[15:0]);
        $display("writing effective address to the extended address field in instruction");
      
      
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
        $display("[TB: tc_dv_ext_instr] Resetting DUT and Model");
        reset = 1'b1;
        wait_clk_cycles(4);
     

        ///////////////// Ensure the output port are cleared
        //
        $display("[TB: tc_dv_ext_instr] Waiting for output ports of Model and DUT to clear...");
        wait_bits_clear(8'hFF, `TEST_EXT_RESET_CYCLES, error_cnt);
      
      
        ///////////////// Release Reset and begin testcase
        //
        $display("[TB: tc_dv_ext_instr] Release reset and begin testcase!");
        reset = 1'b0;
        
      
        ///////////////// Waiting for indication of begining of code under test
        //
        $display("[TB: tc_dv_ext_instr] Waiting for Model and DUT to indicate begining of code under test...");
        wait_bits_set(8'h01, `TEST_EXT_START_CYCLES, error_cnt);
      
        
        ///////////////// Waiting for indication of completed code under test
        //
        $display("[TB: tc_dv_ext_instr] Waiting for Model and DUT to indicate completion of code under test...");
        wait_bits_set(8'h80, `TEST_EXT_FINISH_CYCLES, error_cnt);
      
        wait_clk_cycles(4); // wait a few cycles to capture the output port in waveform dump

    error_cnt += model_error; //add model error to error count




        $display("[TB: tb_dv_test_code] Resetting DUT and Model");
        reset = 1'b1;
        wait_clk_cycles(4);

        ///////////////// Running a diff on the memories
        //
        $display("[TB: tc_dv_ext_instr] Comparing DUT memory and Model memory...");
        error_cnt += mem_diff_cnt(1'b0);
      


        ///////////////// Test PASS / FAIL summary 
        //
        if (error_cnt == 0) begin
          $write("[TB: tc_dv_ext_instr] Test PASS for interation %0d of %0d for ", rand_itr_idx, rand_itr_total);
          print_opcode_info(prebyte, opcode, 1'b1);
          pass_test_cnt++;
        end else begin
          $display("[TB: tc_dv_ext_instr] ERROR count: %0d", error_cnt);
          $write("[TB; tc_dv_ext_instr] Test FAIL for interation %0d of %0d for ", rand_itr_idx, rand_itr_total);
          print_opcode_info(prebyte, opcode, 1'b1);
          save_tb_mem("tc_dv_ext_instr",prebyte,opcode,rand_itr_idx);
          $display("[TB: tc_dv_ext_instr] Exiting randomization iteration loop... ");
          fail_test_cnt++;
        end


        rand_itr_idx++;
      end
    end
  end
  endtask
  

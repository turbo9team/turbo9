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
// Engineer: Michael Rywalt &  Kevin Phillipson
// Description: Testcase: Indirect 16-bit offset
//
//////////////////////////////////////////////////////////////////////////////
// History:
// 07.14.2023 - Kevin Phillipson
//   File header added
//
//////////////////////////////////////////////////////////////////////////////
// [TURBO9_HEADER_END]

/////////////////////////////////////////////////////////////////////////////
//                  Indexed Addressing Instruction Testcase
/////////////////////////////////////////////////////////////////////////////

  `define TEST_IND_16B_TOTAL_INSTR    54
  `define TEST_IND_16B_RESET_CYCLES   40  // (16  nominal)
  `define TEST_IND_16B_START_CYCLES   200 // (100 nominal)
  `define TEST_IND_16B_FINISH_CYCLES  500 // (240 nominal)

  ////////////////////////////////////////////////////////////////////////////
  // Test Indexed Addressing Instructions
  ////////////////////////////////////////////////////////////////////////////
  task tc_dv_ind_16b_instr;

    reg [15:0] addr_ptr;
    reg [15:0] offset_addr_ptr;
    reg [15:0] data_block_start;
    reg [15:0] indirect_addr;
    reg [15:0] data_ea;
    reg [31:0] rand32;

    integer ind_instr_list [0:`TEST_IND_16B_TOTAL_INSTR-1];
    integer instr_idx;
    integer idx_reg_sel;
    integer error_cnt;

    integer rand_itr_idx;

    reg        stack_ptr_sel;
    reg [ 1:0] operand_size;
    reg [ 7:0] prebyte;
    reg [ 7:0] post_byte;
    reg [ 7:0] opcode;
    reg [15:0] init_ptr;
    reg [15:0] index_reg;
    reg [15:0] offset16;

    localparam s_sel = 0;
    localparam u_sel = 1;
    localparam y_sel = 2;
    localparam x_sel = 3;

  begin
    // ind_instr_list define:
    // [23:20] : Stack ptr sel : 'h0 = S     / 'h1 = U      / 'h2 = random
    // [19:16] : Operand size  : 'h1 = 8bit  / 'h2 = 16bit
    // [15: 8] : Prebyte       : 'h00 = none / 'h10 = Page2 / 'h11 = Page3
    // [ 7: 0] : Opcode

    // Page 1
    ind_instr_list[ 0] = 'h00_2_2_00_30; // LEAX
    ind_instr_list[ 1] = 'h00_2_2_00_31; // LEAY
    ind_instr_list[ 2] = 'h00_1_2_00_32; // LEAS
    ind_instr_list[ 3] = 'h00_0_2_00_33; // LEAU
    ind_instr_list[ 4] = 'h00_2_1_00_60; // NEG
  //ind_instr_list[  ] = 'h00_2_1_00_61; // *
  //ind_instr_list[  ] = 'h00_2_1_00_62; // *
    ind_instr_list[ 5] = 'h00_2_1_00_63; // COM
    ind_instr_list[ 6] = 'h00_2_1_00_64; // LSR
  //ind_instr_list[  ] = 'h00_2_1_00_65; // *
    ind_instr_list[ 7] = 'h00_2_1_00_66; // ROR
    ind_instr_list[ 8] = 'h00_2_1_00_67; // ASR
    ind_instr_list[ 9] = 'h00_2_1_00_68; // ASL,LSL
    ind_instr_list[10] = 'h00_2_1_00_69; // ROL
    ind_instr_list[11] = 'h00_2_1_00_6A; // DEC
  //ind_instr_list[  ] = 'h00_2_1_00_6B; // *
    ind_instr_list[12] = 'h00_2_1_00_6C; // INC
    ind_instr_list[13] = 'h00_2_1_00_6D; // TST
  //ind_instr_list[  ] = 'h00_2_1_00_6E; // JMP
    ind_instr_list[14] = 'h00_2_1_00_6F; // CLR
    ind_instr_list[15] = 'h00_2_1_00_A0; // SUBA
    ind_instr_list[16] = 'h00_2_1_00_A1; // CMPA
    ind_instr_list[17] = 'h00_2_1_00_A2; // SBCA
    ind_instr_list[18] = 'h00_2_2_00_A3; // SUBD
    ind_instr_list[19] = 'h00_2_1_00_A4; // ANDA
    ind_instr_list[20] = 'h00_2_1_00_A5; // BITA
    ind_instr_list[21] = 'h00_2_1_00_A6; // LDA
    ind_instr_list[22] = 'h00_2_1_00_A7; // STA
    ind_instr_list[23] = 'h00_2_1_00_A8; // EORA
    ind_instr_list[24] = 'h00_2_1_00_A9; // ADCA
    ind_instr_list[25] = 'h00_2_1_00_AA; // ORA
    ind_instr_list[26] = 'h00_2_1_00_AB; // ADDA
    ind_instr_list[27] = 'h00_2_2_00_AC; // CMPX
  //ind_instr_list[  ] = 'h00_2_1_00_AD; // JSR
    ind_instr_list[28] = 'h00_2_2_00_AE; // LDX
    ind_instr_list[29] = 'h00_2_2_00_AF; // STX
    ind_instr_list[30] = 'h00_2_1_00_E0; // SUBB
    ind_instr_list[31] = 'h00_2_1_00_E1; // CMPB
    ind_instr_list[32] = 'h00_2_1_00_E2; // SBCB
    ind_instr_list[33] = 'h00_2_2_00_E3; // ADDD
    ind_instr_list[34] = 'h00_2_1_00_E4; // ANDB
    ind_instr_list[35] = 'h00_2_1_00_E5; // BITB
    ind_instr_list[36] = 'h00_2_1_00_E6; // LDB
    ind_instr_list[37] = 'h00_2_1_00_E7; // STB
    ind_instr_list[38] = 'h00_2_1_00_E8; // EORB
    ind_instr_list[39] = 'h00_2_1_00_E9; // ADCB
    ind_instr_list[40] = 'h00_2_1_00_EA; // ORB
    ind_instr_list[41] = 'h00_2_1_00_EB; // ADDB
    ind_instr_list[42] = 'h00_2_2_00_EC; // LDD
    ind_instr_list[43] = 'h00_2_2_00_ED; // STD
    ind_instr_list[44] = 'h00_0_2_00_EE; // LDU
    ind_instr_list[45] = 'h00_0_2_00_EF; // STU

    // Page 2
    ind_instr_list[46] = 'h00_2_2_10_A3; // CMPD
    ind_instr_list[47] = 'h00_2_2_10_AC; // CMPY
    ind_instr_list[48] = 'h00_2_2_10_AE; // LDY
    ind_instr_list[49] = 'h00_2_2_10_AF; // STY
    ind_instr_list[50] = 'h00_1_2_10_EE; // LDS
    ind_instr_list[51] = 'h00_1_2_10_EF; // STS

    // Page 3
    ind_instr_list[52] = 'h00_0_2_11_A3; // CMPU
    ind_instr_list[53] = 'h00_1_2_11_AC; // CMPS


    for (instr_idx = 0; instr_idx < `TEST_IND_16B_TOTAL_INSTR; instr_idx++) begin

      ///////////////// Load the instruction setup
      //
      opcode        = ind_instr_list[instr_idx][ 7: 0];
      prebyte       = ind_instr_list[instr_idx][15: 8];
      operand_size  = ind_instr_list[instr_idx][17:16];
      $display("[TB: tc_dv_ind_16b_instr]"); 
      $display("[TB: tc_dv_ind_16b_instr]"); 
      $display("[TB: tc_dv_ind_16b_instr] ////////////////////////////////////////////////////////////////////"); 
      $write("[TB; tc_dv_ind_16b_instr] // Testcase ");
      print_opcode_info(prebyte, opcode, 1'b1);
      $display("[TB: tc_dv_ind_16b_instr] ////////////////////////////////////////////////////////////////////"); 

      for (idx_reg_sel = 0; idx_reg_sel < 4; idx_reg_sel++) begin

        // Dont use stack pointer as index
        if (((idx_reg_sel == s_sel) || (idx_reg_sel == u_sel)) && (ind_instr_list[instr_idx][21:20] == idx_reg_sel))
          idx_reg_sel++;
        
        $display("[TB: tc_dv_ind_16b_instr]"); 
        $write("[TB: tc_dv_ind_16b_instr] //////////// Selecting ");
        case (idx_reg_sel) 
          s_sel: $write("S ");
          u_sel: $write("U ");
          y_sel: $write("Y ");
          x_sel: $write("X ");
        endcase
        $display("as index register ////////////"); 

        ///////////////// Set post-byte one of the index registers.
        //
        case (idx_reg_sel) 
        s_sel: post_byte = 'hF9;
        u_sel: post_byte = 'hD9;
        y_sel: post_byte = 'hB9;
        x_sel: post_byte = 'h99;
        endcase

        rand_itr_idx = 1;
        error_cnt = 0;
        while ((rand_itr_idx <= rand_itr_total) && (error_cnt == 0)) begin
        
          $display("[TB: tc_dv_ind_16b_instr]"); 
          $write("[TB: tc_dv_ind_16b_instr] Random Iteration %0d of %0d for ",rand_itr_idx,rand_itr_total);
          print_opcode_info(prebyte, opcode, 1'b1);
        
          ///////////////// Select or randomize the stack pointer
          //
          case (idx_reg_sel) 
          s_sel: stack_ptr_sel = choose_stack_ptr(u_sel);
          u_sel: stack_ptr_sel = choose_stack_ptr(s_sel);
          y_sel: stack_ptr_sel = choose_stack_ptr(ind_instr_list[instr_idx][21:20]);  // Y
          x_sel: stack_ptr_sel = choose_stack_ptr(ind_instr_list[instr_idx][21:20]);  // X
          endcase

          ///////////////// Loading testbench template
          //
          if (rand_itr_idx == 1) begin
            $display("[TB: tc_dv_ind_16b_instr] Loading testbench template: %0s", hex_file);
            $readmemh(hex_file,`tb_mem);
          end else begin
            $display("[TB: tc_dv_ind_16b_instr] Skip loading testbench template for subsequent randomization iterations");
          end
        
        
          ///////////////// Randomizing data block
          //
          random_block_p(`asm_code_under_test,`asm_data_block_last_byte);
          $display("writing random data from `asm_code_under_test to `asm_data_block_last_byte");
        
        
          ///////////////// Write opcode under test
          //
          //           code_under_test:
          // 60 99 FFFE  neg  [16bit, x]
          // 7E F0 1F    jmp   save_state
          //
          addr_ptr = `asm_code_under_test;
          write_opcode(prebyte, opcode, addr_ptr, 1'b0);
          $display(" *** OPCODE UNDER TEST *** ");
        
        
          ///////////////// Write post-byte
          write_tb_mem8p(addr_ptr, post_byte);
          addr_ptr++;
          $display("Writing post-byte for accu_16b_offset Indexed Addressing mode test.");

          // After the post-byte, save space for the 16 bit offset
          offset_addr_ptr = addr_ptr;
          addr_ptr+=2;
          $display("[TB: tc_dv_ind_16b_instr] Offset field in instruction at address: 0x%x", offset_addr_ptr);

          ///////////////// Write JMP opcode & program done address
          //
          write_jump_done(stack_ptr_sel, addr_ptr);
        
        
          ///////////////// Calculate the start and range of the data block
          //
          data_block_start = addr_ptr;
          $display("[TB: tc_dv_ind_16b_instr] @ 0x%4x to 0x%4x : will be used as the data block (%0d bytes)",
            data_block_start,`asm_data_block_last_byte,(`asm_data_block_end-data_block_start));
        
          ///////////////// Create a random indirect address for the data
          //
          $write("[TB: tc_dv_ind_16b_instr] Creating a random indirect address within the data block for data... ");
          rand32  = {$random(seed)}; //{} = unsigned
          indirect_addr = data_block_start + ((rand32[15:0])%(`asm_data_block_end - data_block_start - operand_size));
          $display("indirect address = 0x%4x", indirect_addr);

          ///////////////// Create a random effective address for the data
          //
          $write("[TB: tc_dv_ind_16b_instr] Creating a random address within the data block for data... ");
          rand32  = {$random(seed)}; //{} = unsigned
          data_ea = data_block_start + ((rand32[15:0])%(`asm_data_block_end - data_block_start - operand_size));
          $display("effective address = 0x%4x", data_ea);

          write_tb_mem16p(indirect_addr, data_ea);

          ///////////////// Calculate Offset and Index
          //
          // indirect_addr = index_reg + signed offset
          //   - randomize offset and solve for index_reg
          //
          // index_reg = indirect_addr - signed offset
          //
          offset16 = rand32[31:16];
          $display("[TB: tc_dv_ind_16b_instr] Random offset value: 0x%x", offset16);

          index_reg = indirect_addr - offset16;
          $display("[TB: tc_dv_ind_16b_instr] Index register value: 0x%x", index_reg);

          // After the post-byte, write the 16 bit offset
          write_tb_mem16p(offset_addr_ptr, offset16);
          $display("Writing 16-bit offset follwing post-byte.");

 
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

          case (idx_reg_sel) 
          s_sel:
            begin
              write_tb_mem16p(`asm_init_u_s, index_reg);
              $write("Setting S ");
            end
          u_sel:
            begin
              write_tb_mem16p(`asm_init_u_s, index_reg);
              $write("Setting U ");
            end
          y_sel:
            begin
              write_tb_mem16p(`asm_init_y, index_reg);
              $write("Setting Y ");
            end
          x_sel:
            begin
              write_tb_mem16p(`asm_init_x, index_reg);
              $write("Setting X ");
            end
          endcase
          $display("index register stack intialization value to 0x%x", index_reg); // X

          write_tb_mem16p(`asm_init_pc,`asm_code_under_test); $display("setting PC stack intialization value to `asm_code_under_test");
        
        
          ///////////////// Initialize Reset Vector
          //
          write_reset_vector(stack_ptr_sel);
        
        
          ///////////////// Copy testbench program into model and DUT memory
          //
          copy_tb_mem;
        
        
          ///////////////// Reset DUT and Model
          //
          $display("[TB: tc_dv_ind_16b_instr] Resetting DUT and Model");
          reset = 1'b1;
          wait_clk_cycles(4);
       
        
          ///////////////// Ensure the output port are cleared
          //
          $display("[TB: tc_dv_ind_16b_instr] Waiting for output ports of Model and DUT to clear...");
          wait_bits_clear(8'hFF, `TEST_IND_16B_RESET_CYCLES, error_cnt);
        
        
          ///////////////// Release Reset and begin testcase
          //
          $display("[TB: tc_dv_ind_16b_instr] Release reset and begin testcase!");
          reset = 1'b0;
          
        
          ///////////////// Waiting for indication of begining of code under test
          //
          $display("[TB: tc_dv_ind_16b_instr] Waiting for Model and DUT to indicate begining of code under test...");
          wait_bits_set(8'h01, `TEST_IND_16B_START_CYCLES, error_cnt);
        
          
          ///////////////// Waiting for indication of completed code under test
          //
          $display("[TB: tc_dv_ind_16b_instr] Waiting for Model and DUT to indicate completion of code under test...");
          wait_bits_set(8'h80, `TEST_IND_16B_FINISH_CYCLES, error_cnt);
        
          wait_clk_cycles(4); // wait a few cycles to capture the output port in waveform dump
          error_cnt += model_error; //add model error to error count

          $display("[TB: tb_dv_test_code] Resetting DUT and Model");
          reset = 1'b1;
          wait_clk_cycles(4);
        
          ///////////////// Running a diff on the memories
          //
          $display("[TB: tc_dv_ind_16b_instr] Comparing DUT memory and Model memory...");
          error_cnt += mem_diff_cnt(1'b0);
        

        
          ///////////////// Test PASS / FAIL summary 
          //
          if (error_cnt == 0) begin
            $write("[TB: tc_dv_ind_16b_instr] Test PASS for interation %0d of %0d for ", rand_itr_idx, rand_itr_total);
            print_opcode_info(prebyte, opcode, 1'b1);
            pass_test_cnt++;
          end else begin
            $display("[TB: tc_dv_ind_16b_instr] ERROR count: %0d", error_cnt);
            $write("[TB; tc_dv_ind_16b_instr] Test FAIL for interation %0d of %0d for ", rand_itr_idx, rand_itr_total);
            print_opcode_info(prebyte, opcode, 1'b1);
            save_tb_mem("tc_dv_ind_16b_instr",prebyte,opcode,rand_itr_idx);
            $display("[TB: tc_dv_ind_16b_instr] Exiting randomization iteration loop... ");
            fail_test_cnt++;
          end
        
        
          rand_itr_idx++;
        end
      end
    end
  end
  endtask
  

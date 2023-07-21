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
// Engineer: Michael Rywalt & Kevin Phillipson
// Description: Testcase: Indexed PC 16-bit offset instructions
// (reviewed 11/7/21) -KP
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

  `define TEST_IDX_PC16_TOTAL_INSTR    54
  `define TEST_IDX_PC16_RESET_CYCLES   40  // (16  nominal)
  `define TEST_IDX_PC16_START_CYCLES   200 // (100 nominal)
  `define TEST_IDX_PC16_FINISH_CYCLES  500 // (240 nominal)

  ////////////////////////////////////////////////////////////////////////////
  // Test Indexed Addressing Instructions
  ////////////////////////////////////////////////////////////////////////////
  task tc_dv_idx_pc16_instr;

    reg [15:0] addr_ptr;
    reg [15:0] offset_addr_ptr;
    reg [15:0] data_block_start;
    reg [15:0] data_ea;
    reg [31:0] rand32;

    integer idx_instr_list [0:`TEST_IDX_PC16_TOTAL_INSTR-1];
    integer instr_idx;
    integer postbyte_sel;
    integer error_cnt;

    integer rand_itr_idx;

    reg        stack_ptr_sel;
    reg [ 1:0] operand_size;
    reg [ 7:0] prebyte;
    reg [ 7:0] post_byte;
    reg [ 7:0] opcode;
    reg [15:0] temp16;
    reg [15:0] pc_index_reg;
    reg [15:0] offset16;

  begin
    // idx_instr_list define:
    // [23:20] : Stack ptr sel : 'h0 = S     / 'h1 = U      / 'h2 = random
    // [19:16] : Operand size  : 'h1 = 8bit  / 'h2 = 16bit
    // [15: 8] : Prebyte       : 'h00 = none / 'h10 = Page2 / 'h11 = Page3
    // [ 7: 0] : Opcode

    // Page 1
    idx_instr_list[ 0] = 'h00_2_2_00_30; // LEAX
    idx_instr_list[ 1] = 'h00_2_2_00_31; // LEAY
    idx_instr_list[ 2] = 'h00_1_2_00_32; // LEAS
    idx_instr_list[ 3] = 'h00_0_2_00_33; // LEAU
    idx_instr_list[ 4] = 'h00_2_1_00_60; // NEG
  //idx_instr_list[  ] = 'h00_2_1_00_61; // *
  //idx_instr_list[  ] = 'h00_2_1_00_62; // *
    idx_instr_list[ 5] = 'h00_2_1_00_63; // COM
    idx_instr_list[ 6] = 'h00_2_1_00_64; // LSR
  //idx_instr_list[  ] = 'h00_2_1_00_65; // *
    idx_instr_list[ 7] = 'h00_2_1_00_66; // ROR
    idx_instr_list[ 8] = 'h00_2_1_00_67; // ASR
    idx_instr_list[ 9] = 'h00_2_1_00_68; // ASL,LSL
    idx_instr_list[10] = 'h00_2_1_00_69; // ROL
    idx_instr_list[11] = 'h00_2_1_00_6A; // DEC
  //idx_instr_list[  ] = 'h00_2_1_00_6B; // *
    idx_instr_list[12] = 'h00_2_1_00_6C; // INC
    idx_instr_list[13] = 'h00_2_1_00_6D; // TST
  //idx_instr_list[  ] = 'h00_2_1_00_6E; // JMP
    idx_instr_list[14] = 'h00_2_1_00_6F; // CLR
    idx_instr_list[15] = 'h00_2_1_00_A0; // SUBA
    idx_instr_list[16] = 'h00_2_1_00_A1; // CMPA
    idx_instr_list[17] = 'h00_2_1_00_A2; // SBCA
    idx_instr_list[18] = 'h00_2_2_00_A3; // SUBD
    idx_instr_list[19] = 'h00_2_1_00_A4; // ANDA
    idx_instr_list[20] = 'h00_2_1_00_A5; // BITA
    idx_instr_list[21] = 'h00_2_1_00_A6; // LDA
    idx_instr_list[22] = 'h00_2_1_00_A7; // STA
    idx_instr_list[23] = 'h00_2_1_00_A8; // EORA
    idx_instr_list[24] = 'h00_2_1_00_A9; // ADCA
    idx_instr_list[25] = 'h00_2_1_00_AA; // ORA
    idx_instr_list[26] = 'h00_2_1_00_AB; // ADDA
    idx_instr_list[27] = 'h00_2_2_00_AC; // CMPX
  //idx_instr_list[  ] = 'h00_2_1_00_AD; // JSR
    idx_instr_list[28] = 'h00_2_2_00_AE; // LDX
    idx_instr_list[29] = 'h00_2_2_00_AF; // STX
    idx_instr_list[30] = 'h00_2_1_00_E0; // SUBB
    idx_instr_list[31] = 'h00_2_1_00_E1; // CMPB
    idx_instr_list[32] = 'h00_2_1_00_E2; // SBCB
    idx_instr_list[33] = 'h00_2_2_00_E3; // ADDD
    idx_instr_list[34] = 'h00_2_1_00_E4; // ANDB
    idx_instr_list[35] = 'h00_2_1_00_E5; // BITB
    idx_instr_list[36] = 'h00_2_1_00_E6; // LDB
    idx_instr_list[37] = 'h00_2_1_00_E7; // STB
    idx_instr_list[38] = 'h00_2_1_00_E8; // EORB
    idx_instr_list[39] = 'h00_2_1_00_E9; // ADCB
    idx_instr_list[40] = 'h00_2_1_00_EA; // ORB
    idx_instr_list[41] = 'h00_2_1_00_EB; // ADDB
    idx_instr_list[42] = 'h00_2_2_00_EC; // LDD
    idx_instr_list[43] = 'h00_2_2_00_ED; // STD
    idx_instr_list[44] = 'h00_0_2_00_EE; // LDU
    idx_instr_list[45] = 'h00_0_2_00_EF; // STU

    // Page 2
    idx_instr_list[46] = 'h00_2_2_10_A3; // CMPD
    idx_instr_list[47] = 'h00_2_2_10_AC; // CMPY
    idx_instr_list[48] = 'h00_2_2_10_AE; // LDY
    idx_instr_list[49] = 'h00_2_2_10_AF; // STY
    idx_instr_list[50] = 'h00_1_2_10_EE; // LDS
    idx_instr_list[51] = 'h00_1_2_10_EF; // STS

    // Page 3
    idx_instr_list[52] = 'h00_0_2_11_A3; // CMPU
    idx_instr_list[53] = 'h00_1_2_11_AC; // CMPS


    for (instr_idx = 0; instr_idx < `TEST_IDX_PC16_TOTAL_INSTR; instr_idx++) begin

      ///////////////// Load the instruction setup
      //
      opcode        = idx_instr_list[instr_idx][ 7: 0];
      prebyte       = idx_instr_list[instr_idx][15: 8];
      operand_size  = idx_instr_list[instr_idx][17:16];
      $display("[TB: tc_dv_idx_pc16_instr]"); 
      $display("[TB: tc_dv_idx_pc16_instr]"); 
      $display("[TB: tc_dv_idx_pc16_instr] ////////////////////////////////////////////////////////////////////"); 
      $write("[TB; tc_dv_idx_pc16_instr] // Testcase ");
      print_opcode_info(prebyte, opcode, 1'b1);
      $display("[TB: tc_dv_idx_pc16_instr] ////////////////////////////////////////////////////////////////////"); 

      for (postbyte_sel = 0; postbyte_sel < 4; postbyte_sel++) begin
        
        $display("[TB: tc_dv_idx_pc16_instr]"); 

        ///////////////// Set post-byte one of the index registers.
        //
        case (postbyte_sel) 
          0: post_byte = 'hED;
          1: post_byte = 'hCD;
          2: post_byte = 'hAD;
          3: post_byte = 'h8D;
        endcase
        $display("[TB: tc_dv_idx_pc16_instr] //////////// Selecting postbyte 0x%x for PC 8bit offset", post_byte);

        rand_itr_idx = 1;
        error_cnt = 0;
        while ((rand_itr_idx <= rand_itr_total) && (error_cnt == 0)) begin
        
          $display("[TB: tc_dv_idx_pc16_instr]"); 
          $write("[TB: tc_dv_idx_pc16_instr] Random Iteration %0d of %0d for ",rand_itr_idx,rand_itr_total);
          print_opcode_info(prebyte, opcode, 1'b1);
        
          ///////////////// Select or randomize the stack pointer
          //
          stack_ptr_sel = choose_stack_ptr(idx_instr_list[instr_idx][21:20]);

          ///////////////// Loading testbench template
          //
          if (rand_itr_idx == 1) begin
            $display("[TB: tc_dv_idx_pc16_instr] Loading testbench template: tb_dv_asm.hex");
            $readmemh("tb_dv_asm.hex",`tb_mem);
          end else begin
            $display("[TB: tc_dv_idx_pc16_instr] Skip loading testbench template for subsequent randomization iterations");
          end
        
        
          ///////////////// Randomizing data block
          //
          random_block_p(`asm_code_under_test,`asm_data_block_last_byte);
          $display("writing random data from `asm_code_under_test to `asm_data_block_last_byte");
        
        
          ///////////////// Write opcode under test
          //
          //               code_under_test:
          // 60 8D 80 00   neg   128, PC
          // 7E F0 1F      jmp   save_state
          //
          addr_ptr = `asm_code_under_test_mid;
          write_opcode(prebyte, opcode, addr_ptr, 1'b0);
          $display(" *** OPCODE UNDER TEST *** ");
        
        
          ///////////////// Write post-byte
          write_tb_mem8p(addr_ptr, post_byte);
          addr_ptr++;
          $display("Writing post-byte for 16-bit offset Indexed Addressing mode test.");

          // After the post-byte, save space for the 16 bit offset
          offset_addr_ptr = addr_ptr;
          addr_ptr+=2;
          $display("[TB: tc_dv_idx_pc16_instr] Offset field in instruction at address: 0x%x", offset_addr_ptr);

          // After the offset, save the PC value
          //
          pc_index_reg  = addr_ptr;
          $display("[TB: tc_dv_idx_pc16_instr] PC = 0x%x", pc_index_reg);

          ///////////////// Write JMP opcode & program done address
          //
          write_jump_done(stack_ptr_sel, addr_ptr);

      
          data_block_start = addr_ptr;
          rand32 = {$random(seed)};

          ///////////////// 50/50 choice to go forwards or backwards
          // 
          if(rand32[31]) begin
            $write("[TB: tc_dv_idx_pc16_instr] Creating a random address for a forward PC 16bit index... ");
            data_ea = data_block_start + ((rand32[15:0])%((`asm_data_block_end ) - data_block_start));
            $display("effective address = 0x%4x", data_ea);
          end else begin
            $write("[TB: tc_dv_idx_pc16_instr] Creating a random address for a backward PC 16bit index... ");
            data_ea = (`asm_code_under_test) + ((rand32[15:0])%(`asm_code_under_test_mid - (`asm_code_under_test ) - operand_size));
            $display("effective address = 0x%4x", data_ea);
          end
        
          ///////////////// Create a random relative address offset for the data
          //
          $write("[TB: tc_dv_idx_pc16_instr] Calculate offset... ");
          temp16 = data_ea - pc_index_reg; // Offset = ea - pc
          offset16 = temp16[15:0];
          $display("16bit offset = 0x%2x", offset16);
      
        
          ///////////////// Write offset byte for relative address instructions
          //
          write_tb_mem16p(offset_addr_ptr, offset16);
          $display("writing 16-bit offset to the offset field after postbyte");

 
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
          //write_tb_mem16p(`asm_init_u_s, ); // U or S
          //write_tb_mem16p(`asm_init_y,   ); // Y
          //write_tb_mem16p(`asm_init_x,   ); // X

          write_tb_mem16p(`asm_init_pc,`asm_code_under_test_mid); $display("setting PC stack intialization value to `asm_code_under_test");
        
        
          ///////////////// Initialize Reset Vector
          //
          write_reset_vector(stack_ptr_sel);
        
        
          ///////////////// Copy testbench program into model and DUT memory
          //
          copy_tb_mem;
        
        
          ///////////////// Reset DUT and Model
          //
          $display("[TB: tc_dv_idx_pc16_instr] Resetting DUT and Model");
          reset = 1'b1;
          wait_clk_cycles(4);
       
        
          ///////////////// Ensure the output port are cleared
          //
          $display("[TB: tc_dv_idx_pc16_instr] Waiting for output ports of Model and DUT to clear...");
          wait_bits_clear(8'hFF, `TEST_IDX_PC16_RESET_CYCLES, error_cnt);
        
        
          ///////////////// Release Reset and begin testcase
          //
          $display("[TB: tc_dv_idx_pc16_instr] Release reset and begin testcase!");
          reset = 1'b0;
          
        
          ///////////////// Waiting for indication of begining of code under test
          //
          $display("[TB: tc_dv_idx_pc16_instr] Waiting for Model and DUT to indicate begining of code under test...");
          wait_bits_set(8'h01, `TEST_IDX_PC16_START_CYCLES, error_cnt);
        
          
          ///////////////// Waiting for indication of completed code under test
          //
          $display("[TB: tc_dv_idx_pc16_instr] Waiting for Model and DUT to indicate completion of code under test...");
          wait_bits_set(8'h80, `TEST_IDX_PC16_FINISH_CYCLES, error_cnt);
        
          wait_clk_cycles(4); // wait a few cycles to capture the output port in waveform dump
          $display("[TB: tb_dv_test_code] Resetting DUT and Model");
          reset = 1'b1;
          wait_clk_cycles(4);
        
          ///////////////// Running a diff on the memories
          //
          $display("[TB: tc_dv_idx_pc16_instr] Comparing DUT memory and Model memory...");
          error_cnt += mem_diff_cnt(1'b0);
        
          error_cnt += model_error; //add model error to error count
        
          ///////////////// Test PASS / FAIL summary 
          //
          if (error_cnt == 0) begin
            $write("[TB: tc_dv_idx_pc16_instr] Test PASS for interation %0d of %0d for ", rand_itr_idx, rand_itr_total);
            print_opcode_info(prebyte, opcode, 1'b1);
            pass_test_cnt++;
          end else begin
            $display("[TB: tc_dv_idx_pc16_instr] ERROR count: %0d", error_cnt);
            $write("[TB; tc_dv_idx_pc16_instr] Test FAIL for interation %0d of %0d for ", rand_itr_idx, rand_itr_total);
            print_opcode_info(prebyte, opcode, 1'b1);
            save_tb_mem("tc_dv_idx_pc16_instr",prebyte,opcode,rand_itr_idx);
            $display("[TB: tc_dv_idx_pc16_instr] Exiting randomization iteration loop... ");
            fail_test_cnt++;
          end
        
        
          rand_itr_idx++;
        end
      end
    end
  end
  endtask
  

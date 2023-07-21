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
// Description: Testbench: Library of functions and tasks
//
//////////////////////////////////////////////////////////////////////////////
// History:
// 07.14.2023 - Kevin Phillipson
//   File header added
//
//////////////////////////////////////////////////////////////////////////////
// [TURBO9_HEADER_END]

/////////////////////////////////////////////////////////////////////////////
//                    Testbench Function and Task Library
/////////////////////////////////////////////////////////////////////////////


  ////////////////////////////////////////////////////////////////////////////
  // Write Testbench Memory (8-bit)
  ////////////////////////////////////////////////////////////////////////////
  task write_tb_mem8(input [15:0] addr, input [7:0] data);
  begin
    `tb_mem[addr[(`MEM_ADDR_WIDTH-1):0]] = data;
  end
  endtask

  ////////////////////////////////////////////////////////////////////////////
  // Write Testbench Memory (16-bit)
  ////////////////////////////////////////////////////////////////////////////
  task write_tb_mem16(input [15:0] addr, input [15:0] data);
    reg [15:0] addr_inc;
  begin
    addr_inc = addr + 'h1;
    `tb_mem[addr[(`MEM_ADDR_WIDTH-1):0]] = data[15:8];
    `tb_mem[addr_inc[(`MEM_ADDR_WIDTH-1):0]] = data[7:0];
  end
  endtask

  ////////////////////////////////////////////////////////////////////////////
  // Write Testbench Memory (8-bit) (Print output)
  ////////////////////////////////////////////////////////////////////////////
  task write_tb_mem8p(input [15:0] addr, input [7:0] data);
  begin
    $write("[TB: write_tb_mem8p ] @ 0x%4x <=   0x%2x : ", addr, data);
    `tb_mem[addr[(`MEM_ADDR_WIDTH-1):0]] = data;
  end
  endtask

  ////////////////////////////////////////////////////////////////////////////
  // Write Testbench Memory (16-bit) (Print output)
  ////////////////////////////////////////////////////////////////////////////
  task write_tb_mem16p(input [15:0] addr, input [15:0] data);
    reg [15:0] addr_inc;
  begin
    $write("[TB: write_tb_mem16p] @ 0x%4x <= 0x%4x : ", addr, data);
    addr_inc = addr + 'h1;
    `tb_mem[addr[(`MEM_ADDR_WIDTH-1):0]] = data[15:8];
    `tb_mem[addr_inc[(`MEM_ADDR_WIDTH-1):0]] = data[7:0];
  end
  endtask

  ////////////////////////////////////////////////////////////////////////////
  // Copy Testbench Memory to Model and DUT
  ////////////////////////////////////////////////////////////////////////////
  task copy_tb_mem;
    integer ptr;
  begin
    $display("[TB: copy_tb_mem    ] Copy testbench program into model and DUT memory");
    for (ptr = 0; ptr < (2**`MEM_ADDR_WIDTH); ptr++) begin
`ifdef TURBO9_R
      if (ptr[0] == 1'b0) begin
        `dut_mem_even[ptr[31:1]]   = `tb_mem[ptr];
      end else begin
        `dut_mem_odd[ptr[31:1]]   = `tb_mem[ptr];
      end
`else
      `dut_mem[ptr] = `tb_mem[ptr];
`endif
      `model_mem[ptr] = `tb_mem[ptr];
    end
  end
  endtask

  ////////////////////////////////////////////////////////////////////////////
  // Compare Model and DUT memories
  ////////////////////////////////////////////////////////////////////////////

  function integer mem_diff_cnt(input stop_on_err);
    integer ptr;
    integer diff_cnt;
  begin
    ptr = 0;
    diff_cnt = 0;
    while ((ptr < (2**`MEM_ADDR_WIDTH)) && ((diff_cnt == 0) || ~stop_on_err)) begin

`ifdef TURBO9_R
      if (ptr[0] == 1'b0) begin
        if (`dut_mem_even[ptr[31:1]] !== `model_mem[ptr]) begin
          $display("[TB: mem_diff_cnt   ] ERROR: Memory mismatch. DUT = 0x%2x / Model = 0x%2x @ Address: 0x%4x (Memory Index %0d)",
            `dut_mem_even[ptr[31:1]], `model_mem[ptr], {{(16-`MEM_ADDR_WIDTH){1'b1}},ptr[(`MEM_ADDR_WIDTH-1):0]}, ptr);
          diff_cnt++;
        end
      end else begin
        if (`dut_mem_odd[ptr[31:1]] !== `model_mem[ptr]) begin
          $display("[TB: mem_diff_cnt   ] ERROR: Memory mismatch. DUT = 0x%2x / Model = 0x%2x @ Address: 0x%4x (Memory Index %0d)",
            `dut_mem_odd[ptr[31:1]], `model_mem[ptr], {{(16-`MEM_ADDR_WIDTH){1'b1}},ptr[(`MEM_ADDR_WIDTH-1):0]}, ptr);
          diff_cnt++;
        end
      end
`else
      if (`dut_mem[ptr] != `model_mem[ptr]) begin
        $display("[TB: mem_diff_cnt   ] ERROR: Memory mismatch. DUT = 0x%2x / Model = 0x%2x @ Address: 0x%4x (Memory Index %0d)",
          `dut_mem[ptr], `model_mem[ptr], {{(16-`MEM_ADDR_WIDTH){1'b1}},ptr[(`MEM_ADDR_WIDTH-1):0]}, ptr);
        diff_cnt++;
      end
`endif
      ptr++;
    end
    if (diff_cnt == 0) begin
      $display("[TB: mem_diff_cnt   ] DUT memory matches Model memory!");
    end else begin
      $display("[TB: mem_diff_cnt   ] ERROR: Memory mismatch total: %0d",diff_cnt);
    end
    mem_diff_cnt = diff_cnt;
  end
  endfunction

  ////////////////////////////////////////////////////////////////////////////
  // Create a random block of data
  ////////////////////////////////////////////////////////////////////////////
  task random_block_p(input [15:0] block_start, input [15:0] block_last_byte);
    integer ptr;
    reg [31:0] rand32;
  begin
    // Initialize the data block with random data
    rand32  = {$random(seed)}; // {} = unsigned 
    for (ptr = block_start; ptr <= block_last_byte; ptr++) begin
      case (ptr[1:0])
        2'h0    : begin
          rand32  = {$random(seed)}; // {} = unsigned
          write_tb_mem8(ptr, rand32[31:24]);
        end
        2'h1    : write_tb_mem8(ptr, rand32[23:16]);
        2'h2    : write_tb_mem8(ptr, rand32[15: 8]);
        default : write_tb_mem8(ptr, rand32[ 7: 0]);
      endcase
    end
    $write("[TB: random_block_p ] @ 0x%4x to 0x%4x : ", block_start, block_last_byte);
  end
  endtask

  ////////////////////////////////////////////////////////////////////////////
  // Debug $random
  ////////////////////////////////////////////////////////////////////////////
  task debug_random;
    reg [31:0] rand32;
  begin
    // this is a scratchpad task for debugging $random
   $display("[TB: debug_random ]");
    rand32 = 0;
    while (rand32[31:30] != 2'h1) begin
      rand32 = {$random(seed)}; // {} = unsigned
      $display("[TB: debug_random ]rand32[31:0] = %8h",rand32[31:0]);
      $display("[TB: debug_random ]rand32[31:30] = %1h", rand32[31:30]);
    end
   $display("[TB: debug_random ]");
  end
  endtask


  ////////////////////////////////////////////////////////////////////////////
  // Wait Clock Cycles
  ////////////////////////////////////////////////////////////////////////////
  task wait_clk_cycles(input integer wait_cycle_total);
    integer wait_cycle_cnt;
  begin
    $display("[TB: wait_clk_cycles] Waiting %0d clock cycles ", wait_cycle_total);
    for (wait_cycle_cnt = 0; wait_cycle_cnt < wait_cycle_total; wait_cycle_cnt++) begin
      @(posedge sysclk);
    end
  end
  endtask


  ////////////////////////////////////////////////////////////////////////////
  // Choose Stack Pointer 
  ////////////////////////////////////////////////////////////////////////////
  function reg choose_stack_ptr(input [1:0] stack_ptr_field);
  begin
    $write("[TB: choose_stack_ptr] ");
    if (stack_ptr_field == 2'h2) begin
      $write("Selecting random stack pointer... ");
      choose_stack_ptr = {$random(seed)}; //{} = unsigned
    end else begin
      choose_stack_ptr = stack_ptr_field[0];
    end
    if (choose_stack_ptr == 1'b0) begin
      $display("S selected as stack pointer.");
    end else begin
      $display("U selected as stack pointer.");
    end
  end
  endfunction


  ////////////////////////////////////////////////////////////////////////////
  // Write Opcode
  ////////////////////////////////////////////////////////////////////////////
  task write_opcode(input [7:0] prebyte, input [7:0] opcode, inout reg [15:0] addr_ptr, input newline);
  begin
    $write("[TB: write_opcode   ] @ 0x%4x <= ",addr_ptr);
    if (prebyte != 8'h00) begin
      write_tb_mem16(addr_ptr, {prebyte, opcode});
      addr_ptr+=2;
    end else begin
      write_tb_mem8(addr_ptr++, opcode);
    end
    print_opcode_info(prebyte, opcode, newline);
  end
  endtask


  ////////////////////////////////////////////////////////////////////////////
  // Write Jump to Done
  ////////////////////////////////////////////////////////////////////////////
  task write_jump_done(input stack_ptr_sel, inout reg [15:0] addr_ptr);
  begin
    write_opcode(8'h00,8'h7E,addr_ptr,1'b1);
    if (stack_ptr_sel == 1'b0) begin
      write_tb_mem16p(addr_ptr,`asm_done_s_ptr);
      addr_ptr+=2;
      $display("writing address `asm_done_s_ptr for JMP");
    end else begin
      write_tb_mem16p(addr_ptr,`asm_done_u_ptr);
      addr_ptr+=2;
      $display("writing address `asm_done_u_ptr for JMP");
    end
  end
  endtask


  ////////////////////////////////////////////////////////////////////////////
  // Write Reset Vector
  ////////////////////////////////////////////////////////////////////////////
  task write_reset_vector(input stack_ptr_sel);
  begin
    if (stack_ptr_sel == 1'b0) begin
      write_tb_mem16p(`asm_reset_vector,`asm_start_s_ptr);
      $display("setting Reset Vector to `asm_start_s_ptr");
    end else begin
      write_tb_mem16p(`asm_reset_vector,`asm_start_u_ptr);
      $display("setting Reset Vector to `asm_start_u_ptr");
    end
  end
  endtask


  ////////////////////////////////////////////////////////////////////////////
  // Save Testbench Memory
  ////////////////////////////////////////////////////////////////////////////
  task save_tb_mem(input [(32*8)-1:0] test_name, input [7:0] prebyte, input [7:0] opcode, input integer itr_idx);
    integer hex_file_ptr;
    integer hex_file_idx;
    reg [(64*8)-1:0] hex_file_name;
  begin
    if (prebyte != 8'h00) begin
      $sformat(hex_file_name,"%0s.0x%4x.%0d.hex",test_name,{prebyte,opcode},itr_idx);
    end else begin
      $sformat(hex_file_name,"%0s.0x%2x.%0d.hex",test_name,opcode,itr_idx);
    end
    hex_file_ptr = $fopen(hex_file_name,"w");
    for (hex_file_idx = 0; hex_file_idx<(2**`MEM_ADDR_WIDTH); hex_file_idx++) begin
      $fwrite(hex_file_ptr,"%2x\n",`tb_mem[hex_file_idx]);
    end
    $fclose(hex_file_ptr);
    $display("[TB: save_tb_mem    ] Saving tb_mem as \"%0s\" for future debug", hex_file_name);
  end
  endtask

  ////////////////////////////////////////////////////////////////////////////
  // Load S19 into Testbench Memory
  ////////////////////////////////////////////////////////////////////////////
  task load_s19_tb_mem(input [(128*8)-1:0] s19_load_file);
    integer s19_file_ptr;
    integer read_byte;
    reg [ 7:0] s19_data;
    reg [ 7:0] s19_len;
    reg [15:0] s19_addr;
    integer    s19_idx;
  begin
    $display("[TB: load_s19_tb_mem  ] Loading S19 file into tb_mem: %0s", s19_load_file);
    s19_file_ptr = $fopen(s19_load_file,"r");
    read_byte = $fgetc(s19_file_ptr);
    while (read_byte > 0) // ~EOF
    begin
      if (read_byte[7:0] == "S") begin
        read_byte = $fgetc(s19_file_ptr);
        if (read_byte[7:0] == "1") begin
          s19_len [ 7: 4] = hex2bin($fgetc(s19_file_ptr));
          s19_len [ 3: 0] = hex2bin($fgetc(s19_file_ptr));
          //
          s19_addr[15:12] = hex2bin($fgetc(s19_file_ptr));
          s19_addr[11: 8] = hex2bin($fgetc(s19_file_ptr));
          s19_addr[ 7: 4] = hex2bin($fgetc(s19_file_ptr));
          s19_addr[ 3: 0] = hex2bin($fgetc(s19_file_ptr));
          //
          s19_len = s19_len - 8'd3; // subtract address & checksum
          //
          $display("[TB: load_s19_tb_mem ] s19_len = 0x%2x , s19_addr = 0x%4x ", s19_len, s19_addr);
          for (s19_idx = 0; s19_idx < s19_len; s19_idx++) begin
            s19_data[ 7: 4] = hex2bin($fgetc(s19_file_ptr));
            s19_data[ 3: 0] = hex2bin($fgetc(s19_file_ptr));
            write_tb_mem8(s19_addr, s19_data);
            s19_addr++;
          end
        end
      end
      read_byte = $fgetc(s19_file_ptr);
    end
  end
  endtask

  ////////////////////////////////////////////////////////////////////////////
  // HEX to bin
  ////////////////////////////////////////////////////////////////////////////
  function reg [3:0] hex2bin(input reg [7:0] hex_byte);
  begin
    if (hex_byte >= "a") begin
      hex_byte = hex_byte - 8'h20; //Adjust to ucase
    end
    //
    if (hex_byte >= "A") begin
      hex_byte = hex_byte - 8'h37;
    end else begin
      hex_byte = hex_byte - "0";
    end
    //
    hex2bin = hex_byte[3:0];
  end
  endfunction

  ////////////////////////////////////////////////////////////////////////////
  // Wait for bits to clear
  ////////////////////////////////////////////////////////////////////////////
  task wait_bits_clear(input [7:0] mask, input integer timeout, inout integer error_cnt);
    integer clk_cycles;
  begin
    $display("[TB: wait_bits_clear] Waiting for masked output_port bits of Model and DUT to clear. mask = 0x%2x", mask);
    clk_cycles = 0;
    while ((~model_error) && (clk_cycles < timeout) && (((model_output_port&mask) != 8'h00) || ((dut_output_port&mask) != 8'h00)))
    begin
      @(posedge sysclk) clk_cycles++;
    end
    //
    if (clk_cycles == timeout) begin
      $display("[TB: wait_bits_clear] Timeout! clk_cycles: %0d", clk_cycles);
      if ((model_output_port&mask) != 8'h00) begin
        $display("[TB: wait_bits_clear] ERROR Model masked output_port bits did not clear. model_output_port(0x%2x) & mask(0x%2x) = 0x%2x",
          model_output_port, mask, (model_output_port&mask));
        error_cnt++;
      end
      //
      if ((dut_output_port&mask) != 8'h00) begin
        $display("[TB: wait_bits_clear] ERROR DUT masked output_port bits did not clear. dut_output_port(0x%2x) & mask(0x%2x)  = 0x%2x", 
          dut_output_port, mask, (dut_output_port&mask));
        error_cnt++;
      end
    end if (model_error) begin
      $display("[TB: wait_bits_set  ] ERROR Model error detected");
    end else begin
      $display("[TB: wait_bits_clear] Masked output_port bits of Model and DUT clear! clk_cycles: %0d", clk_cycles);
    end
  end
  endtask


  ////////////////////////////////////////////////////////////////////////////
  // Wait for bits to set
  ////////////////////////////////////////////////////////////////////////////
  task wait_bits_set(input [7:0] mask, input integer timeout, inout integer error_cnt);
    integer clk_cycles;
  begin
    $display("[TB: wait_bits_set  ] Waiting for masked output_port bits of Model and DUT to set. mask = 0x%2x", mask);
    clk_cycles = 0;
    while ((~model_error) && (clk_cycles < timeout) && (((model_output_port|(~mask)) != 8'hFF) || ((dut_output_port|(~mask)) != 8'hFF)))
    begin
      @(posedge sysclk) clk_cycles++;
    end
    //
    if (clk_cycles == timeout) begin
      $display("[TB: wait_bits_set  ] Timeout! clk_cycles: %0d", clk_cycles);
      if ((model_output_port|(~mask)) != 8'hFF) begin
        $display("[TB: wait_bits_set  ] ERROR Model masked output_port bits did not set. model_output_port(0x%2x) & mask(0x%2x) = 0x%2x",
          model_output_port, mask, (model_output_port&mask));
        error_cnt++;
      end
      //
      if ((dut_output_port|(~mask)) != 8'hFF) begin
        $display("[TB: wait_bits_set  ] ERROR DUT masked output_port bits did not set. dut_output_port(0x%2x) & mask(0x%2x)  = 0x%2x", 
          dut_output_port, mask, (dut_output_port&mask));
        error_cnt++;
      end
    end if (model_error) begin
      $display("[TB: wait_bits_set  ] ERROR Model error detected");
    end else begin
      $display("[TB: wait_bits_set  ] Masked output_port bits of Model and DUT set! clk_cycles: %0d", clk_cycles);
    end
  end
  endtask


  ////////////////////////////////////////////////////////////////////////////
  // Print Opcode Infomation 
  ////////////////////////////////////////////////////////////////////////////
  task print_opcode_info(input [7:0] prebyte, input [7:0] opcode, input newline);
  begin
    if (prebyte == 8'h11) begin
      case (opcode)
        8'h3F   : $write("0x%2x%2x : SWI3      (stack_op)  (page3)", prebyte, opcode);
        8'h83   : $write("0x%2x%2x : CMPU      (immediate) (page3)", prebyte, opcode);
        8'h8C   : $write("0x%2x%2x : CMPS      (immediate) (page3)", prebyte, opcode);
        8'h93   : $write("0x%2x%2x : CMPU      (direct)    (page3)", prebyte, opcode);
        8'h9C   : $write("0x%2x%2x : CMPS      (direct)    (page3)", prebyte, opcode);
        8'hA3   : $write("0x%2x%2x : CMPU      (indexed)   (page3)", prebyte, opcode);
        8'hAC   : $write("0x%2x%2x : CMPS      (indexed)   (page3)", prebyte, opcode);
        8'hB3   : $write("0x%2x%2x : CMPU      (extended)  (page3)", prebyte, opcode);
        8'hBC   : $write("0x%2x%2x : CMPS      (extended)  (page3)", prebyte, opcode);
        default : $write("0x%2x%2x : Invalid Opcode        (page3)", prebyte, opcode);
      endcase
      if (newline) $display("");
    end else if (prebyte == 8'h10) begin
      case (opcode)
        8'h18   : $write("0x%2x%2x : IDIVS     (inherent)  (page2)", prebyte, opcode);
        8'h20   : $write("0x%2x%2x : LBRA      (relative)  (page2)", prebyte, opcode);
        8'h21   : $write("0x%2x%2x : LBRN      (relative)  (page2)", prebyte, opcode);
        8'h22   : $write("0x%2x%2x : LBHI      (relative)  (page2)", prebyte, opcode);
        8'h23   : $write("0x%2x%2x : LBLS      (relative)  (page2)", prebyte, opcode);
        8'h24   : $write("0x%2x%2x : LBHS,LBCC (relative)  (page2)", prebyte, opcode);
        8'h25   : $write("0x%2x%2x : LBLO,LBCS (relative)  (page2)", prebyte, opcode);
        8'h26   : $write("0x%2x%2x : LBNE      (relative)  (page2)", prebyte, opcode);
        8'h27   : $write("0x%2x%2x : LBEQ      (relative)  (page2)", prebyte, opcode);
        8'h28   : $write("0x%2x%2x : LBVC      (relative)  (page2)", prebyte, opcode);
        8'h29   : $write("0x%2x%2x : LBVS      (relative)  (page2)", prebyte, opcode);
        8'h2A   : $write("0x%2x%2x : LBPL      (relative)  (page2)", prebyte, opcode);
        8'h2B   : $write("0x%2x%2x : LBMI      (relative)  (page2)", prebyte, opcode);
        8'h2C   : $write("0x%2x%2x : LBGE      (relative)  (page2)", prebyte, opcode);
        8'h2D   : $write("0x%2x%2x : LBLT      (relative)  (page2)", prebyte, opcode);
        8'h2E   : $write("0x%2x%2x : LBGT      (relative)  (page2)", prebyte, opcode);
        8'h2F   : $write("0x%2x%2x : LBLE      (relative)  (page2)", prebyte, opcode);
        8'h3F   : $write("0x%2x%2x : SWI2      (stack_op)  (page2)", prebyte, opcode);
        8'h83   : $write("0x%2x%2x : CMPD      (immediate) (page2)", prebyte, opcode);
        8'h8C   : $write("0x%2x%2x : CMPY      (immediate) (page2)", prebyte, opcode);
        8'h8E   : $write("0x%2x%2x : LDY       (immediate) (page2)", prebyte, opcode);
        8'h93   : $write("0x%2x%2x : CMPD      (direct)    (page2)", prebyte, opcode);
        8'h9C   : $write("0x%2x%2x : CMPY      (direct)    (page2)", prebyte, opcode);
        8'h9E   : $write("0x%2x%2x : LDY       (direct)    (page2)", prebyte, opcode);
        8'h9F   : $write("0x%2x%2x : STY       (direct)    (page2)", prebyte, opcode);
        8'hA3   : $write("0x%2x%2x : CMPD      (indexed)   (page2)", prebyte, opcode);
        8'hAC   : $write("0x%2x%2x : CMPY      (indexed)   (page2)", prebyte, opcode);
        8'hAE   : $write("0x%2x%2x : LDY       (indexed)   (page2)", prebyte, opcode);
        8'hAF   : $write("0x%2x%2x : STY       (indexed)   (page2)", prebyte, opcode);
        8'hB3   : $write("0x%2x%2x : CMPD      (extended)  (page2)", prebyte, opcode);
        8'hBC   : $write("0x%2x%2x : CMPY      (extended)  (page2)", prebyte, opcode);
        8'hBE   : $write("0x%2x%2x : LDY       (extended)  (page2)", prebyte, opcode);
        8'hBF   : $write("0x%2x%2x : STY       (extended)  (page2)", prebyte, opcode);
        8'hCE   : $write("0x%2x%2x : LDS       (immediate) (page2)", prebyte, opcode);
        8'hDE   : $write("0x%2x%2x : LDS       (direct)    (page2)", prebyte, opcode);
        8'hDF   : $write("0x%2x%2x : STS       (direct)    (page2)", prebyte, opcode);
        8'hEE   : $write("0x%2x%2x : LDS       (indexed)   (page2)", prebyte, opcode);
        8'hEF   : $write("0x%2x%2x : STS       (indexed)   (page2)", prebyte, opcode);
        8'hFE   : $write("0x%2x%2x : LDS       (extended)  (page2)", prebyte, opcode);
        8'hFF   : $write("0x%2x%2x : STS       (extended)  (page2)", prebyte, opcode);
        default : $write("0x%2x%2x : Invalid Opcode        (page2)", prebyte, opcode);
      endcase
      if (newline) $display("");
    end else if (~((opcode == 8'h10) || (opcode == 8'h11))) begin
      case (opcode)
        8'h00   : $write("  0x%2x : NEG       (direct)    (page1)", opcode);
      //8'h01   : $write("  0x%2x : *         ()          (page1)", opcode);
      //8'h02   : $write("  0x%2x : *         ()          (page1)", opcode);
        8'h03   : $write("  0x%2x : COM       (direct)    (page1)", opcode);
        8'h04   : $write("  0x%2x : LSR       (direct)    (page1)", opcode);
      //8'h05   : $write("  0x%2x : *         ()          (page1)", opcode);
        8'h06   : $write("  0x%2x : ROR       (direct)    (page1)", opcode);
        8'h07   : $write("  0x%2x : ASR       (direct)    (page1)", opcode);
        8'h08   : $write("  0x%2x : ASL,LSL   (direct)    (page1)", opcode);
        8'h09   : $write("  0x%2x : ROL       (direct)    (page1)", opcode);
        8'h0A   : $write("  0x%2x : DEC       (direct)    (page1)", opcode);
      //8'h0B   : $write("  0x%2x : *         ()          (page1)", opcode);
        8'h0C   : $write("  0x%2x : INC       (direct)    (page1)", opcode);
        8'h0D   : $write("  0x%2x : TST       (direct)    (page1)", opcode);
        8'h0E   : $write("  0x%2x : JMP       (direct)    (page1)", opcode);
        8'h0F   : $write("  0x%2x : CLR       (direct)    (page1)", opcode);
      //8'h10   : $write("  0x%2x : Prebyte   ()          (page1)", opcode);
      //8'h11   : $write("  0x%2x : Prebyte   ()          (page1)", opcode);
        8'h12   : $write("  0x%2x : NOP       (inherent)  (page1)", opcode);
        8'h13   : $write("  0x%2x : SYNC      (inherent)  (page1)", opcode);
        8'h14   : $write("  0x%2x : EMUL      (inherent)  (page1)", opcode);
      //8'h15   : $write("  0x%2x : *         ()          (page1)", opcode);
        8'h16   : $write("  0x%2x : LBRA      (relative)  (page1)", opcode);
        8'h17   : $write("  0x%2x : LBSR      (relative)  (page1)", opcode);
        8'h18   : $write("  0x%2x : IDIV      (inherent)  (page1)", opcode);
        8'h19   : $write("  0x%2x : DAA       (inherent)  (page1)", opcode);
        8'h1A   : $write("  0x%2x : ORCC      (immediate) (page1)", opcode);
      //8'h1B   : $write("  0x%2x : *         ()          (page1)", opcode);
        8'h1C   : $write("  0x%2x : ANDCC     (immediate) (page1)", opcode);
        8'h1D   : $write("  0x%2x : SEX       (inherent)  (page1)", opcode);
        8'h1E   : $write("  0x%2x : EXG       (inherent)  (page1)", opcode);
        8'h1F   : $write("  0x%2x : TFR       (inherent)  (page1)", opcode);
        8'h20   : $write("  0x%2x : BRA       (relative)  (page1)", opcode);
        8'h21   : $write("  0x%2x : BRN       (relative)  (page1)", opcode);
        8'h22   : $write("  0x%2x : BHI       (relative)  (page1)", opcode);
        8'h23   : $write("  0x%2x : BLS       (relative)  (page1)", opcode);
        8'h24   : $write("  0x%2x : BHS,BCC   (relative)  (page1)", opcode);
        8'h25   : $write("  0x%2x : BLO,BCS   (relative)  (page1)", opcode);
        8'h26   : $write("  0x%2x : BNE       (relative)  (page1)", opcode);
        8'h27   : $write("  0x%2x : BEQ       (relative)  (page1)", opcode);
        8'h28   : $write("  0x%2x : BVC       (relative)  (page1)", opcode);
        8'h29   : $write("  0x%2x : BVS       (relative)  (page1)", opcode);
        8'h2A   : $write("  0x%2x : BPL       (relative)  (page1)", opcode);
        8'h2B   : $write("  0x%2x : BMI       (relative)  (page1)", opcode);
        8'h2C   : $write("  0x%2x : BGE       (relative)  (page1)", opcode);
        8'h2D   : $write("  0x%2x : BLT       (relative)  (page1)", opcode);
        8'h2E   : $write("  0x%2x : BGT       (relative)  (page1)", opcode);
        8'h2F   : $write("  0x%2x : BLE       (relative)  (page1)", opcode);
        8'h30   : $write("  0x%2x : LEAX      (indexed)   (page1)", opcode);
        8'h31   : $write("  0x%2x : LEAY      (indexed)   (page1)", opcode);
        8'h32   : $write("  0x%2x : LEAS      (indexed)   (page1)", opcode);
        8'h33   : $write("  0x%2x : LEAU      (indexed)   (page1)", opcode);
        8'h34   : $write("  0x%2x : PSHS      (stack_op)  (page1)", opcode);
        8'h35   : $write("  0x%2x : PULS      (stack_op)  (page1)", opcode);
        8'h36   : $write("  0x%2x : PSHU      (stack_op)  (page1)", opcode);
        8'h37   : $write("  0x%2x : PULU      (stack_op)  (page1)", opcode);
      //8'h38   : $write("  0x%2x : *         ()          (page1)", opcode);
        8'h39   : $write("  0x%2x : RTS       (stack_op)  (page1)", opcode);
        8'h3A   : $write("  0x%2x : ABX       (inherent)  (page1)", opcode);
        8'h3B   : $write("  0x%2x : RTI       (stack_op)  (page1)", opcode);
        8'h3C   : $write("  0x%2x : CWAI      (stack_op)  (page1)", opcode);
        8'h3D   : $write("  0x%2x : MUL       (inherent)  (page1)", opcode);
      //8'h3E   : $write("  0x%2x : *         ()          (page1)", opcode);
        8'h3F   : $write("  0x%2x : SWI       (stack_op)  (page1)", opcode);
        8'h40   : $write("  0x%2x : NEGA      (inherent)  (page1)", opcode);
      //8'h41   : $write("  0x%2x : *         ()          (page1)", opcode);
      //8'h42   : $write("  0x%2x : *         ()          (page1)", opcode);
        8'h43   : $write("  0x%2x : COMA      (inherent)  (page1)", opcode);
        8'h44   : $write("  0x%2x : LSRA      (inherent)  (page1)", opcode);
      //8'h45   : $write("  0x%2x : *         ()          (page1)", opcode);
        8'h46   : $write("  0x%2x : RORA      (inherent)  (page1)", opcode);
        8'h47   : $write("  0x%2x : ASRA      (inherent)  (page1)", opcode);
        8'h48   : $write("  0x%2x : ASLA,LSLA (inherent)  (page1)", opcode);
        8'h49   : $write("  0x%2x : ROLA      (inherent)  (page1)", opcode);
        8'h4A   : $write("  0x%2x : DECA      (inherent)  (page1)", opcode);
      //8'h4B   : $write("  0x%2x : *         ()          (page1)", opcode);
        8'h4C   : $write("  0x%2x : INCA      (inherent)  (page1)", opcode);
        8'h4D   : $write("  0x%2x : TSTA      (inherent)  (page1)", opcode);
      //8'h4E   : $write("  0x%2x : *         ()          (page1)", opcode);
        8'h4F   : $write("  0x%2x : CLRA      (inherent)  (page1)", opcode);
        8'h50   : $write("  0x%2x : NEGB      (inherent)  (page1)", opcode);
      //8'h51   : $write("  0x%2x : *         ()          (page1)", opcode);
      //8'h52   : $write("  0x%2x : *         ()          (page1)", opcode);
        8'h53   : $write("  0x%2x : COMB      (inherent)  (page1)", opcode);
        8'h54   : $write("  0x%2x : LSRB      (inherent)  (page1)", opcode);
      //8'h55   : $write("  0x%2x : *         ()          (page1)", opcode);
        8'h56   : $write("  0x%2x : RORB      (inherent)  (page1)", opcode);
        8'h57   : $write("  0x%2x : ASRB      (inherent)  (page1)", opcode);
        8'h58   : $write("  0x%2x : ASLB,LSLB (inherent)  (page1)", opcode);
        8'h59   : $write("  0x%2x : ROLB      (inherent)  (page1)", opcode);
        8'h5A   : $write("  0x%2x : DECB      (inherent)  (page1)", opcode);
      //8'h5B   : $write("  0x%2x : *         ()          (page1)", opcode);
        8'h5C   : $write("  0x%2x : INCB      (inherent)  (page1)", opcode);
        8'h5D   : $write("  0x%2x : TSTB      (inherent)  (page1)", opcode);
      //8'h5E   : $write("  0x%2x : *         ()          (page1)", opcode);
        8'h5F   : $write("  0x%2x : CLRB      (inherent)  (page1)", opcode);
        8'h60   : $write("  0x%2x : NEG       (indexed)   (page1)", opcode);
      //8'h61   : $write("  0x%2x : *         ()          (page1)", opcode);
      //8'h62   : $write("  0x%2x : *         ()          (page1)", opcode);
        8'h63   : $write("  0x%2x : COM       (indexed)   (page1)", opcode);
        8'h64   : $write("  0x%2x : LSR       (indexed)   (page1)", opcode);
      //8'h65   : $write("  0x%2x : *         ()          (page1)", opcode);
        8'h66   : $write("  0x%2x : ROR       (indexed)   (page1)", opcode);
        8'h67   : $write("  0x%2x : ASR       (indexed)   (page1)", opcode);
        8'h68   : $write("  0x%2x : ASL,LSL   (indexed)   (page1)", opcode);
        8'h69   : $write("  0x%2x : ROL       (indexed)   (page1)", opcode);
        8'h6A   : $write("  0x%2x : DEC       (indexed)   (page1)", opcode);
      //8'h6B   : $write("  0x%2x : *         ()          (page1)", opcode);
        8'h6C   : $write("  0x%2x : INC       (indexed)   (page1)", opcode);
        8'h6D   : $write("  0x%2x : TST       (indexed)   (page1)", opcode);
        8'h6E   : $write("  0x%2x : JMP       (indexed)   (page1)", opcode);
        8'h6F   : $write("  0x%2x : CLR       (indexed)   (page1)", opcode);
        8'h70   : $write("  0x%2x : NEG       (extended)  (page1)", opcode);
      //8'h71   : $write("  0x%2x : *         ()          (page1)", opcode);
      //8'h72   : $write("  0x%2x : *         ()          (page1)", opcode);
        8'h73   : $write("  0x%2x : COM       (extended)  (page1)", opcode);
        8'h74   : $write("  0x%2x : LSR       (extended)  (page1)", opcode);
      //8'h75   : $write("  0x%2x : *         ()          (page1)", opcode);
        8'h76   : $write("  0x%2x : ROR       (extended)  (page1)", opcode);
        8'h77   : $write("  0x%2x : ASR       (extended)  (page1)", opcode);
        8'h78   : $write("  0x%2x : ASL,LSL   (extended)  (page1)", opcode);
        8'h79   : $write("  0x%2x : ROL       (extended)  (page1)", opcode);
        8'h7A   : $write("  0x%2x : DEC       (extended)  (page1)", opcode);
      //8'h7B   : $write("  0x%2x : *         ()          (page1)", opcode);
        8'h7C   : $write("  0x%2x : INC       (extended)  (page1)", opcode);
        8'h7D   : $write("  0x%2x : TST       (extended)  (page1)", opcode);
        8'h7E   : $write("  0x%2x : JMP       (extended)  (page1)", opcode);
        8'h7F   : $write("  0x%2x : CLR       (extended)  (page1)", opcode);
        8'h80   : $write("  0x%2x : SUBA      (immediate) (page1)", opcode);
        8'h81   : $write("  0x%2x : CMPA      (immediate) (page1)", opcode);
        8'h82   : $write("  0x%2x : SBCA      (immediate) (page1)", opcode);
        8'h83   : $write("  0x%2x : SUBD      (immediate) (page1)", opcode);
        8'h84   : $write("  0x%2x : ANDA      (immediate) (page1)", opcode);
        8'h85   : $write("  0x%2x : BITA      (immediate) (page1)", opcode);
        8'h86   : $write("  0x%2x : LDA       (immediate) (page1)", opcode);
      //8'h87   : $write("  0x%2x : *         ()          (page1)", opcode);
        8'h88   : $write("  0x%2x : EORA      (immediate) (page1)", opcode);
        8'h89   : $write("  0x%2x : ADCA      (immediate) (page1)", opcode);
        8'h8A   : $write("  0x%2x : ORA       (immediate) (page1)", opcode);
        8'h8B   : $write("  0x%2x : ADDA      (immediate) (page1)", opcode);
        8'h8C   : $write("  0x%2x : CMPX      (immediate) (page1)", opcode);
        8'h8D   : $write("  0x%2x : BSR       (relative)  (page1)", opcode);
        8'h8E   : $write("  0x%2x : LDX       (immediate) (page1)", opcode);
      //8'h8F   : $write("  0x%2x : *         ()          (page1)", opcode);
        8'h90   : $write("  0x%2x : SUBA      (direct)    (page1)", opcode);
        8'h91   : $write("  0x%2x : CMPA      (direct)    (page1)", opcode);
        8'h92   : $write("  0x%2x : SBCA      (direct)    (page1)", opcode);
        8'h93   : $write("  0x%2x : SUBD      (direct)    (page1)", opcode);
        8'h94   : $write("  0x%2x : ANDA      (direct)    (page1)", opcode);
        8'h95   : $write("  0x%2x : BITA      (direct)    (page1)", opcode);
        8'h96   : $write("  0x%2x : LDA       (direct)    (page1)", opcode);
        8'h97   : $write("  0x%2x : STA       (direct)    (page1)", opcode);
        8'h98   : $write("  0x%2x : EORA      (direct)    (page1)", opcode);
        8'h99   : $write("  0x%2x : ADCA      (direct)    (page1)", opcode);
        8'h9A   : $write("  0x%2x : ORA       (direct)    (page1)", opcode);
        8'h9B   : $write("  0x%2x : ADDA      (direct)    (page1)", opcode);
        8'h9C   : $write("  0x%2x : CMPX      (direct)    (page1)", opcode);
        8'h9D   : $write("  0x%2x : JSR       (direct)    (page1)", opcode);
        8'h9E   : $write("  0x%2x : LDX       (direct)    (page1)", opcode);
        8'h9F   : $write("  0x%2x : STX       (direct)    (page1)", opcode);
        8'hA0   : $write("  0x%2x : SUBA      (indexed)   (page1)", opcode);
        8'hA1   : $write("  0x%2x : CMPA      (indexed)   (page1)", opcode);
        8'hA2   : $write("  0x%2x : SBCA      (indexed)   (page1)", opcode);
        8'hA3   : $write("  0x%2x : SUBD      (indexed)   (page1)", opcode);
        8'hA4   : $write("  0x%2x : ANDA      (indexed)   (page1)", opcode);
        8'hA5   : $write("  0x%2x : BITA      (indexed)   (page1)", opcode);
        8'hA6   : $write("  0x%2x : LDA       (indexed)   (page1)", opcode);
        8'hA7   : $write("  0x%2x : STA       (indexed)   (page1)", opcode);
        8'hA8   : $write("  0x%2x : EORA      (indexed)   (page1)", opcode);
        8'hA9   : $write("  0x%2x : ADCA      (indexed)   (page1)", opcode);
        8'hAA   : $write("  0x%2x : ORA       (indexed)   (page1)", opcode);
        8'hAB   : $write("  0x%2x : ADDA      (indexed)   (page1)", opcode);
        8'hAC   : $write("  0x%2x : CMPX      (indexed)   (page1)", opcode);
        8'hAD   : $write("  0x%2x : JSR       (indexed)   (page1)", opcode);
        8'hAE   : $write("  0x%2x : LDX       (indexed)   (page1)", opcode);
        8'hAF   : $write("  0x%2x : STX       (indexed)   (page1)", opcode);
        8'hB0   : $write("  0x%2x : SUBA      (extended)  (page1)", opcode);
        8'hB1   : $write("  0x%2x : CMPA      (extended)  (page1)", opcode);
        8'hB2   : $write("  0x%2x : SBCA      (extended)  (page1)", opcode);
        8'hB3   : $write("  0x%2x : SUBD      (extended)  (page1)", opcode);
        8'hB4   : $write("  0x%2x : ANDA      (extended)  (page1)", opcode);
        8'hB5   : $write("  0x%2x : BITA      (extended)  (page1)", opcode);
        8'hB6   : $write("  0x%2x : LDA       (extended)  (page1)", opcode);
        8'hB7   : $write("  0x%2x : STA       (extended)  (page1)", opcode);
        8'hB8   : $write("  0x%2x : EORA      (extended)  (page1)", opcode);
        8'hB9   : $write("  0x%2x : ADCA      (extended)  (page1)", opcode);
        8'hBA   : $write("  0x%2x : ORA       (extended)  (page1)", opcode);
        8'hBB   : $write("  0x%2x : ADDA      (extended)  (page1)", opcode);
        8'hBC   : $write("  0x%2x : CMPX      (extended)  (page1)", opcode);
        8'hBD   : $write("  0x%2x : JSR       (extended)  (page1)", opcode);
        8'hBE   : $write("  0x%2x : LDX       (extended)  (page1)", opcode);
        8'hBF   : $write("  0x%2x : STX       (extended)  (page1)", opcode);
        8'hC0   : $write("  0x%2x : SUBB      (immediate) (page1)", opcode);
        8'hC1   : $write("  0x%2x : CMPB      (immediate) (page1)", opcode);
        8'hC2   : $write("  0x%2x : SBCB      (immediate) (page1)", opcode);
        8'hC3   : $write("  0x%2x : ADDD      (immediate) (page1)", opcode);
        8'hC4   : $write("  0x%2x : ANDB      (immediate) (page1)", opcode);
        8'hC5   : $write("  0x%2x : BITB      (immediate) (page1)", opcode);
        8'hC6   : $write("  0x%2x : LDB       (immediate) (page1)", opcode);
      //8'hC7   : $write("  0x%2x : *         ()          (page1)", opcode);
        8'hC8   : $write("  0x%2x : EORB      (immediate) (page1)", opcode);
        8'hC9   : $write("  0x%2x : ADCB      (immediate) (page1)", opcode);
        8'hCA   : $write("  0x%2x : ORB       (immediate) (page1)", opcode);
        8'hCB   : $write("  0x%2x : ADDB      (immediate) (page1)", opcode);
        8'hCC   : $write("  0x%2x : LDD       (immediate) (page1)", opcode);
      //8'hCD   : $write("  0x%2x : *         ()          (page1)", opcode);
        8'hCE   : $write("  0x%2x : LDU       (immediate) (page1)", opcode);
      //8'hCF   : $write("  0x%2x : *         ()          (page1)", opcode);
        8'hD0   : $write("  0x%2x : SUBB      (direct)    (page1)", opcode);
        8'hD1   : $write("  0x%2x : CMPB      (direct)    (page1)", opcode);
        8'hD2   : $write("  0x%2x : SBCB      (direct)    (page1)", opcode);
        8'hD3   : $write("  0x%2x : ADDD      (direct)    (page1)", opcode);
        8'hD4   : $write("  0x%2x : ANDB      (direct)    (page1)", opcode);
        8'hD5   : $write("  0x%2x : BITB      (direct)    (page1)", opcode);
        8'hD6   : $write("  0x%2x : LDB       (direct)    (page1)", opcode);
        8'hD7   : $write("  0x%2x : STB       (direct)    (page1)", opcode);
        8'hD8   : $write("  0x%2x : EORB      (direct)    (page1)", opcode);
        8'hD9   : $write("  0x%2x : ADCB      (direct)    (page1)", opcode);
        8'hDA   : $write("  0x%2x : ORB       (direct)    (page1)", opcode);
        8'hDB   : $write("  0x%2x : ADDB      (direct)    (page1)", opcode);
        8'hDC   : $write("  0x%2x : LDD       (direct)    (page1)", opcode);
        8'hDD   : $write("  0x%2x : STD       (direct)    (page1)", opcode);
        8'hDE   : $write("  0x%2x : LDU       (direct)    (page1)", opcode);
        8'hDF   : $write("  0x%2x : STU       (direct)    (page1)", opcode);
        8'hE0   : $write("  0x%2x : SUBB      (indexed)   (page1)", opcode);
        8'hE1   : $write("  0x%2x : CMPB      (indexed)   (page1)", opcode);
        8'hE2   : $write("  0x%2x : SBCB      (indexed)   (page1)", opcode);
        8'hE3   : $write("  0x%2x : ADDD      (indexed)   (page1)", opcode);
        8'hE4   : $write("  0x%2x : ANDB      (indexed)   (page1)", opcode);
        8'hE5   : $write("  0x%2x : BITB      (indexed)   (page1)", opcode);
        8'hE6   : $write("  0x%2x : LDB       (indexed)   (page1)", opcode);
        8'hE7   : $write("  0x%2x : STB       (indexed)   (page1)", opcode);
        8'hE8   : $write("  0x%2x : EORB      (indexed)   (page1)", opcode);
        8'hE9   : $write("  0x%2x : ADCB      (indexed)   (page1)", opcode);
        8'hEA   : $write("  0x%2x : ORB       (indexed)   (page1)", opcode);
        8'hEB   : $write("  0x%2x : ADDB      (indexed)   (page1)", opcode);
        8'hEC   : $write("  0x%2x : LDD       (indexed)   (page1)", opcode);
        8'hED   : $write("  0x%2x : STD       (indexed)   (page1)", opcode);
        8'hEE   : $write("  0x%2x : LDU       (indexed)   (page1)", opcode);
        8'hEF   : $write("  0x%2x : STU       (indexed)   (page1)", opcode);
        8'hF0   : $write("  0x%2x : SUBB      (extended)  (page1)", opcode);
        8'hF1   : $write("  0x%2x : CMPB      (extended)  (page1)", opcode);
        8'hF2   : $write("  0x%2x : SBCB      (extended)  (page1)", opcode);
        8'hF3   : $write("  0x%2x : ADDD      (extended)  (page1)", opcode);
        8'hF4   : $write("  0x%2x : ANDB      (extended)  (page1)", opcode);
        8'hF5   : $write("  0x%2x : BITB      (extended)  (page1)", opcode);
        8'hF6   : $write("  0x%2x : LDB       (extended)  (page1)", opcode);
        8'hF7   : $write("  0x%2x : STB       (extended)  (page1)", opcode);
        8'hF8   : $write("  0x%2x : EORB      (extended)  (page1)", opcode);
        8'hF9   : $write("  0x%2x : ADCB      (extended)  (page1)", opcode);
        8'hFA   : $write("  0x%2x : ORB       (extended)  (page1)", opcode);
        8'hFB   : $write("  0x%2x : ADDB      (extended)  (page1)", opcode);
        8'hFC   : $write("  0x%2x : LDD       (extended)  (page1)", opcode);
        8'hFD   : $write("  0x%2x : STD       (extended)  (page1)", opcode);
        8'hFE   : $write("  0x%2x : LDU       (extended)  (page1)", opcode);
        8'hFF   : $write("  0x%2x : STU       (extended)  (page1)", opcode);
        default : $write("  0x%2x : Invalid Opcode        (page1)", opcode);
      endcase
      if (newline) $display("");
    end
  end
  endtask
  
  
  

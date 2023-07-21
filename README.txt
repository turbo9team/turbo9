
A basic technical description:
 - Executes Motorola 6809 8-bit instruction set (1978)

 - Pipelined micro-architecture
   * Instruction prefetch stage
   * Decode stage (CISC to RISC translation)
   * Single/Multi-cycle execute stage

 - Pipelined Wishbone bus
   * Public domain industry standard
   * Internal separate Program Bus & Data Bus
   * External shared Program/Data Bus

 - Custom uRTL microcode assembler
   * written in C
   * macro based assembler
   * Verilog output
   * Statistics output
   * Decode table output

Current status:
 - 99% of instructions work
 - Interrupts incomplete
 - 98% of testcases complete

Directory structure:
 - asm: 6809 assembly code for testing

 - c_code: vbcc & gcc C code

 - fpga: FPGA project directory

 - regress: nightly regression run directory

 - rtl: Verilog RTL for micro-architecture
   * urtl: Microcode for micro-architecture

 - sim: Simulation run directory
   * run_iv
     > for iverilog single run & regressions
     > Icarus Verilog is open source
     > Use GTKwave for viewing .vcd

 - tb: Testbench

 - urtl_asm_src: Microcode assembler source code

Authors:
 - Kevin Phillipson
 - Michael Rywalt


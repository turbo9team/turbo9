# Turbo9 - A Compact & Efficient Pipelined 6809 Microprocessor IP

![Turbo9 Logo](./docs/images/turbo9_logo_small.png)

### Soft release v0.9 - This repository is still under construction!

----------------------------------------

### Overview
* [What is the Turbo9?](#what-is-the-turbo9)   
* [What are the target applications?](#what-are-the-target-applications)
* [Why use the 6809 instruction set? Why not RISC?](#why-use-the-6809-instruction-set-why-not-risc)
* [But wait 6809 is CISC and CISC is bad!](#but-wait-6809-is-cisc-and-cisc-is-bad)

### The Basics
* [Key Features](#key-features) 
* [Directory Structure](#directory-structure)
* [Current Status](#current-status)
* [Team Members](#team-members)

----------------------------------------

### What is the Turbo9?
The Turbo9 is a pipelined microprocessor IP written in Verilog that executes a superset of the Motorola 6809 instruction set. It is a new modern microarchitecture with 16-bit internal datapaths that balances high performance vs small area / low power. The Turbo9R with a 16-bit memory interface achieves 0.69 DMIPS/MHz which is 3.8 times faster than Motorola's original 8-bit MC6809 implementation. It is an active graduate research project at the University of Florida.

![Turbo9 Microarchitecture](./docs/images/turbo9_microarchitecture_small.png)   

----------------------------------------

### What are the target applications?
The target applications are SoC sub-blocks or small mixed-signal ASICs that require a compact and efficient microprocessor for programmable high-level control. There are many 32 or 64-bit  RISC-V or ARM cores that try to fill this niche, but prove to be inefficient solutions given many of these applications only require 16-bit precision.

![Turbo9 Target Examples](./docs/images/turbo9_target_examples_small.png)

----------------------------------------

### Why use the 6809 instruction set? Why not RISC?
Current industry trends are to adapt 32-bit RISC IP for microcontroller use, however their large 32x32 register files and loosely encoded instructions limit their absolute minimum footprint. So with the goal of a creating a performance _and_ _compact_ microprocessor IP, we need an 16-bit instruction set architecture (ISA). Also, we want an architecture that is capable of running C code effectively. Given these requirements, the Motorola 6809 ISA stands out with its minimal number of registers (shown below), orthogonal instruction set, and powerful indexed and indirect addressing modes that map well to C concepts, such as arrays and pointers. 

![Turbo9 Programming Model](./docs/images/turbo9_programming_model_small.png)

----------------------------------------

### But wait 6809 is CISC and CISC is bad!
The 6809 was designed before the definition of RISC and therefore retroactively is classed as a CISC processor. However, the instruction set is actually simpler than many RISC ISAs. The main rule that 6809 instruction set breaks that it is not a "load-store" architecture. It is a simple accumulator architecture where one of its operands is memory. However, the instruction set is very elegant and well thought-through. This presents the challenge of pipelining a CISC processor while remaining as small as possible and attempting to rival performance levels of RISC implementations. To do this, the Turbo9 implements a novel CISC to RISC micro-op decode stage (shown below). 

![Turbo9 Decode Stage](./docs/images/turbo9_decode_stage_small.png)

----------------------------------------

### Key Features
* **Executes a Superset of the  Motorola 6809 Instruction Set**
  - Compatiable with existing Comp

* Pipelined micro-architecture
  - Instruction prefetch stage
  - Decode stage (CISC to RISC micro-op translation)
  - Single/Multi-cycle execute stage

* Pipelined Wishbone bus
  - Public domain industry standard
  - Internal separate Program Bus & Data Bus
  - External shared Program/Data Bus

* Custom uRTL microcode assembler
  - written in C
  - macro based assembler
  - Verilog output
  - Statistics output
  - Decode table output

----------------------------------------

### Directory structure
|                               |                      |                                                   |
|-------------------------------|----------------------|---------------------------------------------------|
| [asm/](asm/)                  |                      | 6809 assembly code for testing.                   |
| [c_code/](c_code/)            |                      | vbcc & gcc C code.                                |
|                               | **build/**           |                                                   |
|                               | **byte_sieve_src/**  |                                                   |
|                               | **dhrystone_src/**   |                                                   |
|                               | **hello_world_src/** |                                                   |
|                               | **lib_gcc/**         |                                                   |
|                               | **lib_vbcc/**        |                                                   |
| [fpga/](fpga/)                |                      | FPGA project directory                            |
| [regress/](regress/)          |                      | Nightly regression run directory                  |
| [rtl/](rtl/)                  |                      | Verilog RTL for micro-architecture                |
|                               | **urtl/**            | Microcode for micro-architecture                  |
| [sim/](sim/)                  |                      | Simulation run directory                          |
| [tb/](tb/)                    |                      | Testbench                                         |
| [urtl_asm_src/](urtl_asm_src) |                      | Microcode assembler source code                   |


----------------------------------------

### Current status
* 99% of instructions work
* Interrupts incomplete
* 98% of testcases complete

### TODO List

* Interrupts
* Implement Turbo9S
* SDIV / SMUL
* fix stim bench
* pipeline bubbles on reset are benign

----------------------------------------

### Team Members
#### Kevin Phillipson
![Kevin Phillipson](./docs/images/kevin.png)
#### Michael Rywalt
![Michael Rywalt](./docs/images/michael.png)

![asdf]:./scratch.md


# Turbo9 - A Compact & Efficient Pipelined 6809 Microprocessor IP

![Turbo9 Logo](./docs/images/turbo9_logo_small.png)

## Soft release v0.9 - This repository is still under construction!

----------------------------------------

## What is Turbo9?
The Turbo9 is a pipelined microprocessor IP that executes a superset of the Motorola 6809 instruction set. It is a new modern microarchitecture with 16-bit internal datapaths that balances high performance vs small area / low power. The Turbo9R with a 16-bit memory interface acheives 0.69 DMIPS/MHz which is 3.8 times faster than Motorola's orignal 8-bit MC6809 implementation. It is being developed under graduate research at the University of Florida.

![Turbo9 Microarchitecture](./docs/images/turbo9_microarchitecture_small.png)  

----------------------------------------

## What are the target applications?
The target applications are SoC sub-blocks or small mixed-signal ASICs that require a compact and efficient microprocessor for programmable high-level control. There are many 32 or 64-bit  RISC-V or ARM cores that try to fill this niche, but prove to be inefficent solutions given many of these applications only require 16-bit precision.

![Turbo9 Target Examples](./docs/images/turbo9_target_examples_small.png)

----------------------------------------

## Why use the 6809 instruction set? Why not RISC?
Current industry trends are to apdapt 32-bit RISC IP for microcontroller use, however their large 32x32 register files and loosely encoded instructions limit their absolute minimum footprint. So with the goal of a creating a performance _and_ _compact_ microprocessor IP, we need an 16-bit instruction set architecture (ISA). Also, we want an architecture that is capable of running C code effectively. Given these requirements, the Motorola 6809 ISA stands out with its minimal number of registers (shown below), orthogonal instruction set, and powerful indexed and indirect addressing modes that map well to C concepts, such as arrays and pointers. 

![Turbo9 Programming Model](./docs/images/turbo9_programming_model_small.png)

----------------------------------------

## But wait 6809 is CISC and CISC is bad!
The 6809 was designed before the definition of RISC and therefore retroactively is classed as a CISC processor. However, the instruction set is actually simpiler than many RISC ISAs. The main rule that 6809 instruction set breaks that it is not a "load-store" architecture. It is a simple accumaltor architecture where one of its operands is memory. However, the instruction set is very elegant and well thought-through. This presents the challenge of pipelining a CISC processor while remaining as small as possible and attempting to rival performance levels of RISC implementations. To do this, the Turbo9 implements a novel CISC to RISC micro-op decode stage (shown below). 

![Turbo9 Decode Stage](./docs/images/turbo9_decode_stage_small.png)


## TODO List

* Interrupts
* Implement TurboS
* SDIV / SMUL
* fix stim bench
* pipeline bubbles on reset are benign



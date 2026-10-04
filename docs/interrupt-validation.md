# Interrupt implementation validation

Validated on October 4, 2026 on an Apple Silicon Mac with Apio 1.6.0
(`pyinst-darwin-arm64-2026-09-15`) and its installed toolchain packages:

- Icarus Verilog 14.0 development build `s20251012-140-g5c6cdec6a`.
- Yosys `0.63+173`, revision `66306a8ca-dirty` (packaged build identifier).
- OSS CAD Suite package `2026.09.15`.

## Directed interrupt tests

```sh
apio raw -- bash sim/run_interrupts.sh
```

The matrix covers 144 configurations: six CPU types, queue sizes 4/6/7,
reset modes default/synchronous/minimal/X don't-care, and memory latencies
1/3 with stalls enabled. Checks include frame contents, RTI restoration,
masking, priority, NMI arming, held and nested interrupts, SYNC, CWAI, and
interrupted prebytes. Every configuration passed.

## TurbOS boot tests

Both smoke and development profiles passed on all six CPU types (12 boots).
The smoke profile printed `TurbOS OK` and serviced timer interrupts. The
development profile booted the shell, accepted `mfree` through terminal
receive interrupts, printed `Total pages free = 192`, returned to its prompt,
and continued servicing timer interrupts.

Images were built from the clean TurbOS checkout at
[`b5d22c00c283b03ca2cb539ed4eb3584bef613cc`](https://github.com/DrPitre/turbos/commit/b5d22c00c283b03ca2cb539ed4eb3584bef613cc).
Each image is 65,536 bytes. SHA-256 hashes:

```text
turbos_smoke.img  0a55868428d6a430fd79ab582e31822428cc0c5eb32c1c355a8877bbddc6123d
turbos_dev.img    5d5793e2c10e764c490170211595ac47e9cf7f7968c38dcc721cda55b27515da
```

Rebuild and run using the commands in the README's TurbOS section.
These external images are not bundled in this repository or built by its CI.

## Synthesis

```sh
apio raw -- bash sim/run_synthesis.sh
```

All six pipelines passed Xilinx 7-series synthesis and the structural netlist
check. The script uses queue size 6, default asynchronous reset, a flattened
CPU pipeline and no I/O pads. Counts exclude SoC memory, UART, board I/O, and
Wishbone wrappers. LUT counts are the sum of LUT1 through LUT6 cells;
flip-flop counts are FDCE plus FDPE cells.

| CPU type | LUT cells | Flip-flops | CARRY4 | MUXF7 | MUXF8 |
| --- | ---: | ---: | ---: | ---: | ---: |
| 0 | 1676 | 491 | 34 | 148 | 58 |
| 1 | 1663 | 491 | 34 | 190 | 69 |
| 2 | 1740 | 491 | 34 | 183 | 51 |
| 3 | 1676 | 491 | 34 | 148 | 58 |
| 4 | 1663 | 491 | 34 | 190 | 69 |
| 5 | 1740 | 491 | 34 | 183 | 51 |

These are mapped cell counts, not placed slice usage or a board fit estimate.
No placement, routing, timing closure, or physical FPGA test was performed.
The existing FPGA top still needs TurbOS memory, timer and UART integration.

## Generated microcode and CI

`bash sim/generate_microcode.sh --check` passed: generated microcode, opcode
decode tables, and statistics exactly match their checked-in files.
The check runs in a temporary directory and does not overwrite repository files.

The RTL validation workflow runs the interrupt matrix, all six synthesis
checks and microcode regeneration on Ubuntu 24.04 with distro Icarus Verilog
and Yosys. It records tool versions and uploads interrupt/synthesis logs.

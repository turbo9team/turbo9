#!/usr/bin/env bash
# Map all six CPU pipelines to Xilinx 7-series cells; no board timing claim.
set -euo pipefail
root=$(cd "$(dirname "$0")/.." && pwd)
build=$(mktemp -d "${TMPDIR:-/tmp}/turbo9-synthesis.XXXXXX")
trap 'rm -rf "$build"' EXIT
yosys=${YOSYS:-yosys}
cd "$root"
for cpu in 0 1 2 3 4 5; do
  echo "Synthesis CPU=$cpu queue=6 target=xc7"
  "$yosys" -Q -T -p "read_verilog -Irtl rtl/turbo9*.v;
    chparam -set TURBO9_CPU_TYPE $cpu turbo9_pipeline;
    hierarchy -check -top turbo9_pipeline;
    synth_xilinx -family xc7 -top turbo9_pipeline -flatten -noiopad;
    check -assert;
    stat" > "$build/cpu-$cpu.log" 2>&1 || {
      cat "$build/cpu-$cpu.log"; exit 1;
    }
  # Keep the final resource report, with the full log printed on failure.
  sed -n '/=== turbo9_pipeline ===/,$p' "$build/cpu-$cpu.log" | tail -60
  echo "PASS synthesis CPU=$cpu"
done

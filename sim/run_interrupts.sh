#!/usr/bin/env bash
set -euo pipefail
root=$(cd "$(dirname "$0")/.." && pwd)
build=$(mktemp -d "${TMPDIR:-/tmp}/turbo9-interrupts.XXXXXX")
trap 'rm -rf "$build"' EXIT
iverilog=${IVERILOG:-iverilog}
vvp=${VVP:-vvp}
cd "$root"
for cpu in 0 1 2 3 4 5; do
  for queue in 4 6 7; do
    for mode in default sync minimal x; do
      defines=(-DTURBO9_INTERRUPT_TEST)
      case "$mode" in
        sync) defines=(-DTURBO9_RTL_SYNC_RESET);;
        minimal) defines=(-DTURBO9_RTL_MIN_RESET);;
        x) defines=(-DTURBO9_RTL_USE_X);;
      esac
      for latency in 1 3; do
        "$iverilog" -g2012 -I rtl -s tb_interrupts "${defines[@]}" \
          -Ptb_interrupts.CPU_TYPE="$cpu" -Ptb_interrupts.QUEUE_SIZE="$queue" \
          -Ptb_interrupts.LATENCY="$latency" -Ptb_interrupts.STALLS=1 \
          -o "$build/test.vvp" tb/tb_interrupts.v rtl/turbo9*.v 2>"$build/compile.log" || \
          { cat "$build/compile.log"; exit 1; }
        echo "Interrupts CPU=$cpu queue=$queue reset=$mode latency=$latency stalls=1"
        "$vvp" "$build/test.vvp"
      done
    done
  done
done

#!/usr/bin/env bash
set -euo pipefail
check=0
case "${1:-}" in
  "") ;;
  --check) check=1;;
  *) echo "Usage: $0 [--check]" >&2; exit 2;;
esac
root=$(cd "$(dirname "$0")/.." && pwd)
build=$(mktemp -d "${TMPDIR:-/tmp}/turbo9-microcode.XXXXXX")
trap 'rm -rf "$build"' EXIT
sources=()
for name in urtl_asm log err mathlib strproc statistics ctrl_vec macro verilog assemble decode_table fileproc; do
  sources+=("$root/urtl_asm_src/$name.c")
done
"${CC:-cc}" -I "$root/urtl_asm_src" -o "$build/urtl_asm" "${sources[@]}"
cp "$root/rtl/urtl/turbo9_urtl.mac" "$root/rtl/urtl/turbo9_urtl.asm" "$build/"
cd "$build"
./urtl_asm -c turbo9_urtl.mac -a turbo9_urtl.asm > assembly.log
# Decode injects these reserved entry addresses; reject source changes that move them.
for entry in 'INTERRUPT_FULL (D0)' 'INTERRUPT_LOOP (D1)' 'INTERRUPT_VECTOR (D2)' 'INTERRUPT_FAST (E0)'; do
  grep -Fq "$entry" urtl_statistics.log || { echo "Moved interrupt microcode entry: $entry" >&2; exit 1; }
done
if (( check )); then
  for file in turbo9_urtl*.v; do
    cmp "$file" "$root/rtl/$file" || { echo "Stale generated file: rtl/$file" >&2; exit 1; }
  done
  cmp urtl_statistics.log "$root/rtl/urtl/urtl_statistics.log" || {
    echo "Stale generated statistics log" >&2; exit 1;
  }
  echo "Generated microcode, decode tables and statistics match their sources."
else
  cp turbo9_urtl*.v "$root/rtl/"
  cp urtl_statistics.log "$root/rtl/urtl/"
  echo "Regenerated microcode and opcode decode tables."
fi

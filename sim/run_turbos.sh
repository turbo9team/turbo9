#!/usr/bin/env bash
set -euo pipefail
root=$(cd "$(dirname "$0")/.." && pwd)
image=${1:?Usage: run_turbos.sh path/to/turbos_smoke.img [smoke|dev]}
profile=${2:-smoke}
case "$profile" in
  smoke) dev=0;;
  dev) dev=1;;
  *) echo "profile must be smoke or dev" >&2; exit 1;;
esac
build=$(mktemp -d "${TMPDIR:-/tmp}/turbo9-turbos.XXXXXX")
trap 'rm -rf "$build"' EXIT
python3 - "$image" "$build/image.hex" <<'PYTHON'
import sys
from pathlib import Path
data = Path(sys.argv[1]).read_bytes()
if len(data) != 65536:
    raise SystemExit("TurbOS image must be exactly 65536 bytes")
Path(sys.argv[2]).write_text("".join(f"{b:02x}\n" for b in data))
PYTHON
cd "$root"
for cpu in 0 1 2 3 4 5; do
  "${IVERILOG:-iverilog}" -g2012 -I rtl -s tb_turbos \
    -Ptb_turbos.CPU_TYPE="$cpu" -Ptb_turbos.DEV_IMAGE="$dev" -o "$build/boot.vvp" tb/tb_turbos.v rtl/turbo9*.v
  "${VVP:-vvp}" "$build/boot.vvp" +image="$build/image.hex"
done

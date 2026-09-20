
# Top Level Files

|               |                                       |
|---------------|---------------------------------------|
| fpga_top.v    |  FPGA top                             |
|               |                                       |
| soc_top.v     |  SoC top 8-bit memory bus             |
| soc_top_r.v   |  SoC top 16-bit memory bus            |
| soc_top_gtr.v |  SoC top 16-bit Harvard memory bus    |
|               |                                       |
| turbo9.v      |  Turbo9 top 8-bit memory bus          |
| turbo9_r.v    |  Turbo9 top 16-bit memory bus         |
| turbo9_gtr.v  |  Turbo9 top 16-bit Harvard memory bus |
|               |                                       |

## Build for the Arty A7-35T with Apio

Activate your Python environment containing Apio, then run from the repository root:

```sh
apio build -p rtl
```

The project is in `rtl/apio.ini`, so Apio finds the HDL and boot ROM files
without including the separate verification sources in `tb/`. The build produces
`rtl/_build/default/hardware.bit`. This configuration was checked with Apio 1.6.0
on macOS arm64, using its installed OSS CAD Suite and openXC7 packages.
See the [Apio project configuration documentation](https://fpgawars.github.io/apio/docs/project-file/).

`fpga_top` instantiates the Turbo9S SoC (`soc_top_s`) with 64 KiB RAM and the
checked-in 512-byte boot ROM. The board's 100 MHz oscillator is divided to 50 MHz.
The XDC constrains the input clock, and Apio's `--freq 50` nextpnr option constrains
the divided clock because nextpnr does not apply the Vivado generated-clock
constraint. The UART runs at approximately 115200 baud, 8 data bits, no parity,
and 1 stop bit.

To load the bitstream into a connected board when ready:

```sh
apio upload -p rtl
```

The current nextpnr tool reports combinational-loop warnings during timing
analysis. Independent Yosys SCC checks found no loops in the elaborated RTL or
the mapped combinational logic. The routed report meets the 50 MHz target, but
the bitstream still needs validation on physical hardware.

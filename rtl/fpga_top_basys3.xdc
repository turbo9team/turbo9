## Turbo9 fpga_top constraints for the Digilent Basys 3 rev B.
##
## The Basys 3 buttons are active-high, while ck_rst is active-low.  The
## unused SW15 switch therefore drives hard reset: SW15=0 holds reset and
## SW15=1 releases it.  btn[0:2] use the center, up, and left buttons;
## btn[3] uses the right button.
##
## Board FPGA: XC7A35T-1CPG236C

## 100 MHz oscillator
set_property -dict { PACKAGE_PIN W5 IOSTANDARD LVCMOS33 } [get_ports { CLK100MHZ }]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports { CLK100MHZ }]
create_generated_clock -name clkdiv2 -source [get_ports CLK100MHZ] -divide_by 2 [get_pins I_clk_div/CLK_DIV2]

## Four switches (SW0-SW3)
set_property -dict { PACKAGE_PIN V17 IOSTANDARD LVCMOS33 } [get_ports { sw[0] }]
set_property -dict { PACKAGE_PIN V16 IOSTANDARD LVCMOS33 } [get_ports { sw[1] }]
set_property -dict { PACKAGE_PIN W16 IOSTANDARD LVCMOS33 } [get_ports { sw[2] }]
set_property -dict { PACKAGE_PIN W17 IOSTANDARD LVCMOS33 } [get_ports { sw[3] }]

## Four discrete LEDs (LD0-LD3)
set_property -dict { PACKAGE_PIN U16 IOSTANDARD LVCMOS33 } [get_ports { led[0] }]
set_property -dict { PACKAGE_PIN E19 IOSTANDARD LVCMOS33 } [get_ports { led[1] }]
set_property -dict { PACKAGE_PIN U19 IOSTANDARD LVCMOS33 } [get_ports { led[2] }]
set_property -dict { PACKAGE_PIN V19 IOSTANDARD LVCMOS33 } [get_ports { led[3] }]

## The fpga_leds status outputs are mapped to the remaining Basys 3 LEDs.
set_property -dict { PACKAGE_PIN W18 IOSTANDARD LVCMOS33 } [get_ports { led0_b }]
set_property -dict { PACKAGE_PIN U15 IOSTANDARD LVCMOS33 } [get_ports { led0_g }]
set_property -dict { PACKAGE_PIN U14 IOSTANDARD LVCMOS33 } [get_ports { led0_r }]
set_property -dict { PACKAGE_PIN V14 IOSTANDARD LVCMOS33 } [get_ports { led1_b }]
set_property -dict { PACKAGE_PIN V13 IOSTANDARD LVCMOS33 } [get_ports { led1_g }]
set_property -dict { PACKAGE_PIN V3  IOSTANDARD LVCMOS33 } [get_ports { led1_r }]
set_property -dict { PACKAGE_PIN W3  IOSTANDARD LVCMOS33 } [get_ports { led2_b }]
set_property -dict { PACKAGE_PIN U3  IOSTANDARD LVCMOS33 } [get_ports { led2_g }]
set_property -dict { PACKAGE_PIN P3  IOSTANDARD LVCMOS33 } [get_ports { led2_r }]
set_property -dict { PACKAGE_PIN N3  IOSTANDARD LVCMOS33 } [get_ports { led3_b }]
set_property -dict { PACKAGE_PIN P1  IOSTANDARD LVCMOS33 } [get_ports { led3_g }]
set_property -dict { PACKAGE_PIN L1  IOSTANDARD LVCMOS33 } [get_ports { led3_r }]

## Buttons: center, up, left, right
set_property -dict { PACKAGE_PIN U18 IOSTANDARD LVCMOS33 } [get_ports { btn[0] }]
set_property -dict { PACKAGE_PIN T18 IOSTANDARD LVCMOS33 } [get_ports { btn[1] }]
set_property -dict { PACKAGE_PIN W19 IOSTANDARD LVCMOS33 } [get_ports { btn[2] }]
set_property -dict { PACKAGE_PIN T17 IOSTANDARD LVCMOS33 } [get_ports { btn[3] }]

## SW15 is the active-low reset input expected by fpga_top.
set_property -dict { PACKAGE_PIN R2 IOSTANDARD LVCMOS33 } [get_ports { ck_rst }]

## USB-UART bridge: Basys 3 RsRx/RsTx
set_property -dict { PACKAGE_PIN B18 IOSTANDARD LVCMOS33 } [get_ports { uart_txd_in }]
set_property -dict { PACKAGE_PIN A18 IOSTANDARD LVCMOS33 } [get_ports { uart_rxd_out }]

## Configuration defaults
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]

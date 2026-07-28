// [TURBO9_HEADER_START]
//////////////////////////////////////////////////////////////////////////////
//                          Turbo9 Microprocessor IP
//////////////////////////////////////////////////////////////////////////////
// Website: www.turbo9.org
// Contact: team[at]turbo9[dot]org
//////////////////////////////////////////////////////////////////////////////
// [TURBO9_LICENSE_START]
// BSD-1-Clause
//
// Copyright (c) 2020-2023
// Kevin Phillipson
// Michael Rywalt
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
// 1. Redistributions of source code must retain the above copyright notice,
//    this list of conditions and the following disclaimer.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS AND CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.
// [TURBO9_LICENSE_END]
//////////////////////////////////////////////////////////////////////////////
// Engineer: Kevin Phillipson
// Description: Turbo9 RTL configuration macros, shared by CPU-core and
// SoC/peripheral RTL alike.
//
//////////////////////////////////////////////////////////////////////////////
// History:
// 06.27.2026 - Kevin Phillipson
//   File header added
// 07.25.2026 - Kevin Phillipson
//   Renamed from turbo9_cpu_config.vh; merged in turbo9_soc_config.vh
//
//////////////////////////////////////////////////////////////////////////////
// [TURBO9_HEADER_END]

`ifndef TURBO9_RTL_CONFIG_VH
`define TURBO9_RTL_CONFIG_VH

///////////////////// Reset & Logic Defines
//
//`define TURBO9_RTL_SYNC_RESET // Use Synchronous Reset
//`define TURBO9_RTL_MIN_RESET  // Reset minimal registers
//`define TURBO9_RTL_USE_X      // Assign X in dont care logic for optimization

///////////////////// Simulator Defines
//
//`define TURBO9_RTL_SIM_DEBUG        // Turns on debug strings in decode table verilog files
//`define TURBO9_RTL_SIM_T6551_FAST   // Runs T6551 UART as fast as possible
//`define TURBO9_RTL_SIM_NO_MEM_INIT  // Do not use $readmemh to init memory

`endif

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
// Engineer: Michael Rywalt
// Description: Debug dump header file.
//
//////////////////////////////////////////////////////////////////////////////
// History:
// 07.14.2023 - Kevin Phillipson
//   File header added
//
//////////////////////////////////////////////////////////////////////////////
// [TURBO9_HEADER_END]
#ifndef _VERILOG_H_
#define _VERILOG_H_

#include "mytypedef.h"
#include "ctrl_vec.h"

// Called to initialize the verilog dumping. This also opens the
// output verilog file for writing. NOTE: This will overwrite any
// existing verilog file by the same name. Call  
s16 init_verilog_dump(macro_ctx_t *ctx, char *base_filename, char *asm_filename);

// Call this to print the header portion of the file up to, and
// including the start of the case statements. This will dump
// the control vector defaults just before the case switch.
s16 dump_verilog_header(ctrl_vec_ctx_t *ctx);

// This will dump a string as a comment into the file.
s16 dump_comment(u32 line_number, char *comment, ...);

// When building the case statements, call this with each new
// control vector that changes.
s16 dump_verilog_ctrl_vec(u32 address, ctrl_vec_t *ctrl_vec);
s16 dump_verilog_end_case();

// Once the control vectors have been added to the case switch,
// call this function. It will populate the default case and
// close out the dump.
s16 dump_verilog_footer(ctrl_vec_ctx_t *ctx);

// Close the file handle and cleanup.
s16 uninit_verilog_dump();

#endif

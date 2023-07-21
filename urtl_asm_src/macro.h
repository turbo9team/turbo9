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
// Description: Macro list generator header file.
//
//////////////////////////////////////////////////////////////////////////////
// History:
// 07.14.2023 - Kevin Phillipson
//   File header added
//
//////////////////////////////////////////////////////////////////////////////
// [TURBO9_HEADER_END]
#ifndef _MACRO_H
#define _MACRO_H

#include "ctrl_vec.h"
#include "mytypedef.h"

// ctrl_vec definition type
typedef struct _ctrl_vec_def_t
{
  ctrl_vec_t *ctrl_vec;

  union {
    equ_t *equ;
    s32    value;
  } data;

  s08         arg_num;
  
} ctrl_vec_def_t;

// macro type
typedef struct _macro_t
{
  char           *name;
  ctrl_vec_def_t  ctrl_vec_def[MAX_CTRL_VEC];
  u08             total_ctrl_vec;
  s08             total_args;

} macro_t;

typedef struct _macro_ctx_t
{
  macro_t        *list;
  u16             total_macros;

  // We keep this internal to the macro context so we only
  // pass around one list of control vectors that are 
  // directly associated with this macro list.
  ctrl_vec_ctx_t *ctrl_vec_ctx;

} macro_ctx_t;

//
// Macro API Follows:
//

// Initialize the list of macros in the given mandatory context.
// Must be called prior to using this library.
// Note that the ctrl_vec_ctx must have already been created, as it is
// an input to this function.
s16 init_macro_ctx(ctrl_vec_ctx_t *ctrl_vec_ctx, macro_ctx_t *macro_ctx);

// Free all control vector defs from the current macro.
void free_ctrl_vec_defs_from_macro(macro_t *macro);

// Free all memory allocated in the mandatory given context when using this library.
// Must be called when done using this library to avoid memory leak.
void free_macro_ctx(macro_ctx_t *ctx);

// Main state machine used to build the macro list.
s16 build_macro_list(macro_ctx_t *ctx, char *macro_file_name);

// Finds a macro by a string given by name parameter.
macro_t * find_macro_by_name(macro_ctx_t *ctx, char * name);

// This is a convenience function that should not normally need to be used, except for debug.
// Prints out all control vectors and EQUs in list of control vectors.
void print_macro_list(macro_ctx_t *ctx);

#endif

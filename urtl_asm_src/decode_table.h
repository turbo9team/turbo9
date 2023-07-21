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
// Description: Decode table library header file.
//
//////////////////////////////////////////////////////////////////////////////
// History:
// 07.14.2023 - Kevin Phillipson
//   File header added
//
//////////////////////////////////////////////////////////////////////////////
// [TURBO9_HEADER_END]
#ifndef _JUMP_TABLE_H
#define _JUMP_TABLE_H

#include "ctrl_vec.h"
#include "mytypedef.h"

// One per opcode. Several opcodes per table.
typedef struct _decode_t
{
  u08   opcode;
  u08   has_comment;
  char  *comment;
  equ_t *equ;

} decode_t;

// Tables contain a control vector, and for a list of opcodes,
// an equ.
typedef struct _decode_table_t
{
  ctrl_vec_t *ctrl_vec;
  char       *default_val;
  char       *name;
  decode_t   *list;
  u32        list_len;

} decode_table_t;

// Context carries around the tables list.
typedef struct _decode_table_ctx_t
{
  ctrl_vec_ctx_t *cv_ctx;
  decode_table_t *tables;
  u32            num_tables;

} decode_table_ctx_t;


//
// API Follows:
//

s16 init_decode_table_ctx(decode_table_ctx_t **ctx, ctrl_vec_ctx_t *cv_ctx);

decode_table_t * find_table_by_name(decode_table_ctx_t *ctx, char *table_name);

s16 add_table_to_ctx(decode_table_ctx_t *ctx, char *table_name, ctrl_vec_t *ctrl_vec, char *default_val);

s16 add_opcode_to_table(decode_table_ctx_t *ctx, decode_table_t *table, u08 opcode, equ_t *equ, u08 has_comment, char *comment);

s16 free_decode_list(decode_t *list);

s16 free_all_tables(decode_table_ctx_t *ctx);

s16 free_decode_table_ctx(decode_table_ctx_t *ctx);

s16 build_decode_table(decode_table_ctx_t *ctx, char *asm_file_name);

s16 output_decode_tables(decode_table_ctx_t *ctx, char *base_filename, char *asm_filename);

#endif

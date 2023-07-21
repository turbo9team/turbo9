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
// Description: Control vector generator header file.
//
//////////////////////////////////////////////////////////////////////////////
// History:
// 07.14.2023 - Kevin Phillipson
//   File header added
//
//////////////////////////////////////////////////////////////////////////////
// [TURBO9_HEADER_END]
#ifndef _CTRL_VEC_H
#define _CTRL_VEC_H

#include "mytypedef.h"

// EQU type
typedef struct _equ_t
{
  char *name;
  u16   index;
  u16   value; 

  // Statistical data, not used elsewhere.
  u16   use_cnt;
  u16   decode_use_cnt;
} equ_t;

// Control vector type
typedef struct _ctrl_vec_t
{
  char  *name;
  u16    index;
  u08    width;
  u16    lsb;
  u16    msb;
  u08    microcode_vector;

  equ_t  equ[MAX_EQU];
  u16    total_equ;

  equ_t *equ_sel;
  u08    equ_is_coded;
  u16    equ_microcode_cnt;

} ctrl_vec_t;

typedef struct _ctrl_vec_ctx_t
{
  ctrl_vec_t *list;
  u16         total_microcode_vec;
  u16         total_ctrl_vec;

  // Special type that is stored once, used many.
  equ_t       labels[MAX_EQU];
  u16         total_labels;
  u08         addr_width;

} ctrl_vec_ctx_t;

//
// Control Vector API Follows:
//

// Initialize the list of control vectors in the given mandatory context.
// Must be called prior to using this library.
s16 init_ctrl_vec_ctx(ctrl_vec_ctx_t *ctx);

// Free all memory allocated in the mandatory given context when using this library.
// Must be called when done using this library to avoid memory leak.
void free_ctrl_vec_ctx(ctrl_vec_ctx_t *ctx);

// Find an EQU by name from within a control vector.
equ_t * get_equ_by_name_from_ctrl_vec(ctrl_vec_t *ctrl_vec, char *name);

// Main state machine used to build the control vector list.
s16 build_ctrl_vec_list(ctrl_vec_ctx_t *ctx, char *macro_file_name);

// Add a control vector with required name, and optional width, msb, lsb arguments.
// The context argument is mandatory, and it is on this context that the function operates.
s16 add_ctrl_vec(ctrl_vec_ctx_t *ctx, char *name, u08 width, u16 msb, u16 lsb, u08 mcv);

// Set the width of a control vector, located by providing the mandatory name argument.
// The context argument is mandatory, and it is on this context that the function operates.
s16 set_ctrl_vec_width_by_name(ctrl_vec_ctx_t *ctx, char *name, u08 width);

// Set the msb of a control vector, located by providing the mandatory name argument.
// The context argument is mandatory, and it is on this context that the function operates.
s16 set_ctrl_vec_msb_by_name(ctrl_vec_ctx_t *ctx, char *name, u16 msb);

// Set the lsb of a control vector, located by providing the mandatory name argument.
// The context argument is mandatory, and it is on this context that the function operates.
s16 set_ctrl_vec_lsb_by_name(ctrl_vec_ctx_t *ctx, char *name, u16 lsb);

// Find a control vector in the given context by searching for the mandatory name arguemnt.
// The context argument is mandatory, and it is on this context that the function operates.
ctrl_vec_t * find_ctrl_vec_by_name(ctrl_vec_ctx_t *ctx, char *name);

// Return the count of all control vectors for the given mandatory context.
s32 get_total_ctrl_vec_count(ctrl_vec_ctx_t *ctx);

// Add an equ to the control vector given by the mandatory name argument. The equ_name
// argument is mandatory, and an optional value can be set as well at this time.
// The context argument is mandatory, and it is on this context that the function operates.
s16 add_equ_by_ctrl_vec_name(ctrl_vec_ctx_t *ctx, char *ctrl_vec_name, char *equ_name, u16 equ_val);

// Add a label to the context list that is reused for control vectors that have no EQUs.
s16 add_label_to_context(ctrl_vec_ctx_t *ctx, char *label_name, u16 value);

// Add an equ to the control vector given by the mandatory ctrl_vec argument. The equ_name
// argument is mandatory, and an optional value can be set as well at this time.
// The context argument is mandatory, and it is on this context that the function operates.
s16 add_equ_by_ctrl_vec(ctrl_vec_t *ctrl_vec, char *equ_name, u16 equ_val);

// Opens asm_filename file, and loads all labels as EQUs into given ctrl_vec_name found in the context ctx.
s16 load_labels_to_context_from_asm_file(ctrl_vec_ctx_t *ctx, char *asm_filename);

s16 set_ctrl_vec_equs_from_ctx_labels(ctrl_vec_ctx_t *ctx, char *dst_ctrl_vec_name);

// 
s16 copy_all_equs_between_ctrl_vecs(ctrl_vec_ctx_t *ctx, char *src_ctrl_vec_name, char *dst_ctrl_vec_name);

// Resets all ctrl_vec equ_sel pointers back to the 0th (default) EQU element.
s16 reset_all_ctrl_vec_equ_sel(ctrl_vec_ctx_t *ctx);

// Set a control vector's equ_sel to a given EQU.
s16 set_ctrl_vec_equ_sel(ctrl_vec_t *ctrl_vec, equ_t *equ);

// Find an equ by the mandatory given equ_name argument. 
// The context argument is mandatory, and it is on this context that the function operates.
equ_t * find_equ_by_name(ctrl_vec_t *ctrl_vec, char *equ_name);

// Find a label by the mandatory given label_name argument.
// The context argument is mandatory, and it is on this context that the function operates.
equ_t * find_label_by_name(ctrl_vec_ctx_t *ctx, char *label_name);

// Run through all control vectors and assign the actual lsb and msb offset based on its location in
// the microprogram word.
s16 slice_up_the_word(ctrl_vec_ctx_t *ctx);

// This is a convenience function that should not normally need to be used, except for debug.
// Prints out all control vectors and EQUs in list of control vectors.
void print_ctrl_vec_list(ctrl_vec_ctx_t *ctx);

// This is a convenience function that should not normally need to be used, except for debug.
// Prints out the ctrl_vec list's equ_sel value. Useful after setting equ_sel from
// assembly calls.
void print_ctrl_vec_list_equ_sel(ctrl_vec_ctx_t *ctx);

// This is a convenience function that should not normally need to be used, except for debug.
// Prints out all label names in the special list of names in the context.
void print_label_list(ctrl_vec_ctx_t *ctx);

s16 inc_decode_use_cnt(equ_t *equ);

// TODO: The following functions need to be updated to use the new context.

s16 get_equ_name_from_val(ctrl_vec_t *cv_list, u16 cv_idx, u32 value, char **name);

u16 get_ctrl_vec_value(ctrl_vec_t *cv_list, u16 cv_idx, u08 *mem, u16 addr);

#endif

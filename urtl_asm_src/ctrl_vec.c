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
// Description: Control vector generation library.
//
//////////////////////////////////////////////////////////////////////////////
// History:
// 07.14.2023 - Kevin Phillipson
//   File header added
//
//////////////////////////////////////////////////////////////////////////////
// [TURBO9_HEADER_END]
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "err.h"
#include "log.h"
#include "mathlib.h"
#include "mytypedef.h"
#include "ctrl_vec.h"
#include "statistics.h"
#include "strproc.h"

static char * null_string = "";
static ctrl_vec_t _ctrl_vec_list[MAX_CTRL_VEC]; // TODO: allocate to dynamic memory, use linked list, or other data structure.
extern u08 log_level;

// --==============================================--
// print_ctrl_vec_list_equ_sel
// 
// prints equ_sel values for all ctrl_vecs in the list from given context..
//
// this is a debug function that has no purpose elsewhere.
//
void print_ctrl_vec_list_equ_sel(ctrl_vec_ctx_t *ctx)
{
  u16 ctrl_vec_idx;
  u16 equ_idx;
  ctrl_vec_t *ctrl_vec;

  WRITE_LOG_NF(LOG_HIGH, "\n");
  WRITE_LOG(LOG_HIGH, "Control Vector equ_sel list dump follows:\n");
  WRITE_LOG(LOG_HIGH, "total ctrl_vec count: %d\n", ctx->total_ctrl_vec);

  for(ctrl_vec_idx = 0; ctrl_vec_idx < ctx->total_ctrl_vec; ctrl_vec_idx++)
  {
      WRITE_LOG_NF(LOG_HIGH, "=============================\n");
      WRITE_LOG_NF(LOG_HIGH, "list index: %d\nname: %s\nindex: %d\nwidth: %d\nmsb: %d\nlsb: %d\n",
              ctrl_vec_idx,
              ctx->list[ctrl_vec_idx].name,
              ctx->list[ctrl_vec_idx].index,
              ctx->list[ctrl_vec_idx].width,
              ctx->list[ctrl_vec_idx].msb,
              ctx->list[ctrl_vec_idx].lsb);
      ctrl_vec = &ctx->list[ctrl_vec_idx];
      WRITE_LOG_NF(LOG_HIGH, "total equs: %d\n", ctrl_vec->total_equ);
      WRITE_LOG_NF(LOG_HIGH, "macro equ sel = %s\n", ctrl_vec->equ_sel->name);
      WRITE_LOG_NF(LOG_HIGH, "macro equ is coded? %s\n", ctrl_vec->equ_is_coded ? "Yes": "No");
      WRITE_LOG_NF(LOG_HIGH, "EQU used %d times\n", ctrl_vec->equ_sel->use_cnt);
      WRITE_LOG_NF(LOG_HIGH, "EQU used %d times in decode\n", ctrl_vec->equ_sel->decode_use_cnt);
      WRITE_LOG_NF(LOG_HIGH, "=============================\n");
  }
}

// --==============================================--
// print_ctrl_vec_list
// 
// prints all names and associated values for all list elements.
//
// this is a debug function that has no purpose elsewhere.
//
void print_ctrl_vec_list(ctrl_vec_ctx_t *ctx)
{
  u16 ctrl_vec_idx;
  u16 equ_idx;
  ctrl_vec_t *ctrl_vec;

  WRITE_LOG_NF(LOG_HIGH, "\n");
  WRITE_LOG(LOG_HIGH, "control vector list dump follows:\n");
  WRITE_LOG(LOG_HIGH, "total ctrl_vec count: %d\n", ctx->total_ctrl_vec);

  for(ctrl_vec_idx = 0; ctrl_vec_idx < ctx->total_ctrl_vec; ctrl_vec_idx++)
  {
      WRITE_LOG_NF(LOG_HIGH, "=============================\n");
      WRITE_LOG_NF(LOG_HIGH, "list index: %d\nname: %s\n%sindex: %d\nwidth: %d\nmsb: %d\nlsb: %d\n",
              ctrl_vec_idx,
              ctx->list[ctrl_vec_idx].name,
              ctx->list[ctrl_vec_idx].microcode_vector ? "microcode vector\n": "\n",
              ctx->list[ctrl_vec_idx].index,
              ctx->list[ctrl_vec_idx].width,
              ctx->list[ctrl_vec_idx].msb,
              ctx->list[ctrl_vec_idx].lsb);
      ctrl_vec = &ctx->list[ctrl_vec_idx];
      WRITE_LOG_NF(LOG_HIGH, "macro equ sel = %s\n", ctrl_vec->equ_sel->name);
      WRITE_LOG_NF(LOG_HIGH, "macro equ is coded? %s\n", ctrl_vec->equ_is_coded ? "Yes": "No");
      WRITE_LOG_NF(LOG_HIGH, "total equs: %d\n", ctrl_vec->total_equ);
      for(equ_idx = 0; equ_idx < ctrl_vec->total_equ; equ_idx++)
      {
        WRITE_LOG_NF(LOG_HIGH, "\t%s equ $%x (equ index %d)\n", ctrl_vec->equ[equ_idx].name, ctrl_vec->equ[equ_idx].value, ctrl_vec->equ[equ_idx].index);
      }
      WRITE_LOG_NF(LOG_HIGH, "=============================\n");
  }
}

// --==============================================--
// print_label_list
// 
// Prints all names and associated values for all labels in the context.
//
// This is a debug function that has no purpose elsewhere.
//
void print_label_list(ctrl_vec_ctx_t *ctx)
{
  u16 label_idx;

  for(label_idx = 0; label_idx < ctx->total_labels; label_idx++)
  {
      printf("=============================\n");
      printf("%d\nName: %s\nValue: %d (label index %d)\n", label_idx, ctx->labels[label_idx].name, ctx->labels[label_idx].value, ctx->labels[label_idx].index);
      printf("=============================\n");
  }
}

// --==============================================--
// get_ctrl_vec_index_by_name
s16 get_ctrl_vec_index_by_name(ctrl_vec_ctx_t *ctx, char *ctrl_vec_name)
{
  s16 retval = ERR_NOT_FOUND;
  u16 idx;

  for(idx = 0; idx < MAX_CTRL_VEC; idx++)
  {
    if(ctx->list[idx].name)
      if(!strcmp(ctrl_vec_name, ctx->list[idx].name))
        retval = ctx->list[idx].index;
  }

  return retval;
}


// --==============================================--
// find_ctrl_vec_by_name
ctrl_vec_t * find_ctrl_vec_by_name(ctrl_vec_ctx_t *ctx, char *name)
{
  s32 idx;
  ctrl_vec_t *ctrl_vec = NULL;

  for(idx = 0; idx < MAX_CTRL_VEC; idx++)
  {
    if(ctx->list[idx].name)
      if(!strcmp(name, ctx->list[idx].name))
        ctrl_vec = &ctx->list[idx];
  }

  return ctrl_vec;
}

// --==============================================--
// find_equ_by_name
equ_t * find_equ_by_name(ctrl_vec_t *ctrl_vec, char *equ_name)
{
  s16 equ_idx;
  equ_t *equ = NULL;

  if(ctrl_vec != NULL)
  {
    for(equ_idx = 0; equ_idx < MAX_EQU; equ_idx++)
    {
      if(ctrl_vec->equ[equ_idx].name)
        if(!strcmp(equ_name, ctrl_vec->equ[equ_idx].name))
          equ = &ctrl_vec->equ[equ_idx];
    }
  }

  return equ;
}

// --==============================================--
// find_equ_by_value
equ_t * find_equ_by_value(ctrl_vec_t *ctrl_vec, u16 value)
{
  s16 equ_idx;
  equ_t *equ = NULL;

  if(ctrl_vec != NULL)
  {
    for(equ_idx = 0; equ_idx < MAX_EQU; equ_idx++)
    {
      if(ctrl_vec->equ[equ_idx].name)
        if(value == ctrl_vec->equ[equ_idx].value)
          equ = &ctrl_vec->equ[equ_idx];
    }
  }

  return equ;
}

// --==============================================--
// find_label_by_name
equ_t * find_label_by_name(ctrl_vec_ctx_t *ctx, char *label_name)
{
  s16 label_idx;
  equ_t *label = NULL;

  if(ctx != NULL)
  {
    for(label_idx = 0; label_idx < MAX_EQU; label_idx++)
    {
      if(ctx->labels[label_idx].name)
        if(!strcmp(label_name, ctx->labels[label_idx].name))
          label = &ctx->labels[label_idx];
    }
  }

  return label;
}

// --==============================================--
s16 init_ctrl_vec_ctx(ctrl_vec_ctx_t *ctx)
{
  s16 retval = ERR_OK;
  u16 idx;
  u16 equ_idx;

  if(!ctx)
  {
    retval = ERR_NULL_PTR;
    goto done;
  }

  ctx->list = _ctrl_vec_list;
  ctx->total_ctrl_vec = 0;
  ctx->total_microcode_vec = 0;
  ctx->total_labels = 0;

  // This is LABELS only.
  for(idx = 0; idx < MAX_EQU; idx++)
  {
    ctx->labels[idx].name = NULL;
    ctx->labels[idx].value = 0;
  }

  for(idx = 0; idx < MAX_CTRL_VEC; idx++)
  {
    ctx->list[idx].name      = NULL;
    ctx->list[idx].index     = 0;
    ctx->list[idx].width     = 0;
    ctx->list[idx].lsb       = 0;
    ctx->list[idx].msb       = 0;
    ctx->list[idx].total_equ = 0;

      for(equ_idx = 0; equ_idx < MAX_EQU; equ_idx++)
      {
        ctx->list[idx].equ[equ_idx].name    = NULL;
        ctx->list[idx].equ[equ_idx].index   = 0;
        ctx->list[idx].equ[equ_idx].value   = 0;
        ctx->list[idx].equ[equ_idx].use_cnt = 0;
        ctx->list[idx].equ[equ_idx].decode_use_cnt = 0;
      }

    // Upon init, always set the "equ_sel" to the default 0th EQU.
    // When assembling, this entry will change as arguments are read
    // and then it will be reset back to 0 after an end_state.
    ctx->list[idx].equ_sel = &ctx->list[idx].equ[0];
    ctx->list[idx].equ_is_coded = 0;
  }

done:
  return retval;
}
// --==============================================--


// --==============================================--
// free_equs_from_ctrl_vec
//
// This will clear out and free all EQUs from the
// given control vector. This will probably be
// rarely used on its own. It is used by the 
// free_ctrl_vec_ctx() function below.
//
void free_equs_from_ctrl_vec(ctrl_vec_t *ctrl_vec)
{
  u16 idx;

  ctrl_vec->total_equ = 0;

  for(idx = 0; idx < MAX_EQU; idx++)
  {
    if(ctrl_vec->equ[idx].name) free(ctrl_vec->equ[idx].name);
    ctrl_vec->equ[idx].index   = 0;
    ctrl_vec->equ[idx].value   = 0;
    ctrl_vec->equ[idx].use_cnt = 0;
    ctrl_vec->equ[idx].decode_use_cnt = 0;
  }
}

// --==============================================--
// free_ctrl_vec_ctx
//
// This clears out and frees up all members of the
// control vector context, including lists of all
// control vectors and their associated EQUs.
//
void free_ctrl_vec_ctx(ctrl_vec_ctx_t *ctx)
{
  u16 idx;
  u16 equ_idx;

  ctx->list = _ctrl_vec_list;
  ctx->total_ctrl_vec = 0;
  ctx->total_microcode_vec = 0;

  for(idx = 0; idx < MAX_CTRL_VEC; idx++)
  {
    if(ctx->list[idx].name) free(ctx->list[idx].name);
    ctx->list[idx].index     = 0;
    ctx->list[idx].width     = 0;
    ctx->list[idx].lsb       = 0;
    ctx->list[idx].msb       = 0;
    ctx->list[idx].total_equ = 0;

    free_equs_from_ctrl_vec(&ctx->list[idx]);
  }
}

// --==============================================--
// reset_all_ctrl_vec_equ_sel
//
// Resets all ctrl_vec equ_sel pointers back to the 0th (default) EQU element.
s16 reset_all_ctrl_vec_equ_sel(ctrl_vec_ctx_t *ctx)
{
  u16 idx;
  s16 retval = ERR_OK;

  if(ctx == NULL)
  {
    retval = ERR_NULL_PTR;
    goto done;
  }

  for(idx = 0; idx < ctx->total_ctrl_vec; idx++)
  {
    ctx->list[idx].equ_sel = &ctx->list[idx].equ[0];
    ctx->list[idx].equ_is_coded = 0;
    // Do NOT reset the use_cnt or decode_use_cnt here
    // as this will be called frequently, and the counts
    // are used to gather statistics over all runs.
  }

done:
  return retval;
}

// --==============================================--
// set_ctrl_vec_equ_sel
//
// Sets the given control vector's equ_sel to the given equ.
//
// NOTE: This also increments the use_cnt member of the equ,
//       for use in statistical information.
//
s16 set_ctrl_vec_equ_sel(ctrl_vec_t *ctrl_vec, equ_t *equ)
{
  s16 retval = ERR_OK;

  if(!ctrl_vec || !equ)
  {
    retval = ERR_NULL_PTR;
    goto done;
  }

  ctrl_vec->equ_sel = equ;
  ctrl_vec->equ_sel->use_cnt++;
  ctrl_vec->equ_is_coded = 1;

done:
  return retval;
}

// --==============================================--
// add_ctrl_vec
// Takes:
// name
// width (optional)
// msb (optional)
// lsb (optional)
// mcv - microcode vector = 1, other vector = 0
//
// returns error level, ERR_OK is success, ERR_DUPLICATE_ENTRY on failure.
//
s16 add_ctrl_vec(ctrl_vec_ctx_t *ctx, char *name, u08 width, u16 msb, u16 lsb, u08 mcv)
{
  s16 retval = ERR_DUPLICATE_ENTRY;
  ctrl_vec_t *ctrl_vec;

  if(ctx == NULL)
  {
    retval = ERR_NULL_PTR;
    goto done;
  }

  if(find_ctrl_vec_by_name(ctx, name) == NULL)
  {
    ctrl_vec = &ctx->list[ctx->total_ctrl_vec];
    ctrl_vec->name = malloc(strlen(name)+1);
    strcpy(ctrl_vec->name, name);
    ctrl_vec->index = ctx->total_ctrl_vec;
    ctrl_vec->width = width;
    ctrl_vec->msb = msb;
    ctrl_vec->lsb = lsb;
    ctrl_vec->microcode_vector = mcv;
    ctx->total_ctrl_vec++;
    if(mcv) ctx->total_microcode_vec++;
    retval = ERR_OK;
  }

done:
  return retval;
}

// --==============================================--
//
// get_total_ctrl_vec_count
//
// Returns the total number of control vectors in our list.
//
s32 get_total_ctrl_vec_count(ctrl_vec_ctx_t *ctx)
{
  s32 retval = ERR_NULL_PTR;
  if(ctx)
  {
    retval = ctx->total_ctrl_vec;
  }

  return retval;
}

// --==============================================--
//
// get_total_microcode_vec_count
//
// Returns the total number of control vectors in our list.
//
s32 get_total_microcode_vec_count(ctrl_vec_ctx_t *ctx)
{
  s32 retval = ERR_NULL_PTR;
  if(ctx)
  {
    retval = ctx->total_microcode_vec;
  }

  return retval;
}

// --==============================================--
// add_equ_by_ctrl_vec
//
s16 add_equ_by_ctrl_vec(ctrl_vec_t *ctrl_vec, char *equ_name, u16 equ_val)
{
  s16 retval = ERR_DUPLICATE_ENTRY;
  equ_t *equ;

  // If the EQU we're tryint to add is already not part of the list...
  if((equ = find_equ_by_name(ctrl_vec, equ_name)) == NULL)
  {
    equ = &ctrl_vec->equ[ctrl_vec->total_equ];
    equ->name = malloc(strlen(equ_name)+1);
    if(equ->name)
    {
      strcpy(equ->name, equ_name);
      equ->index = ctrl_vec->total_equ;
      equ->value = equ_val;
      ctrl_vec->total_equ++;
      retval = ERR_OK;
    }
    else
      retval = ERR_NULL_PTR;
  }

  return retval;
}

// --==============================================--
// add_equ_by_ctrl_vec_name
//
// Adds a new equ to an existing ctrl vector.
s16 add_equ_by_ctrl_vec_name(ctrl_vec_ctx_t *ctx, char *ctrl_vec_name, char *equ_name, u16 equ_val)
{
  u16 ctrl_vec_idx;
  s16 retval = ERR_DUPLICATE_ENTRY;
  ctrl_vec_t *ctrl_vec;
  equ_t *equ;

  if((ctrl_vec = find_ctrl_vec_by_name(ctx, ctrl_vec_name)) != NULL)
  {
    retval = add_equ_by_ctrl_vec(ctrl_vec, equ_name, equ_val);
  }

  return retval;
}

// --==============================================--
// add_label_to_context
//
// Adds a new label to the list of labels in the  context.
s16 add_label_to_context(ctrl_vec_ctx_t *ctx, char *label_name, u16 value)
{
  u16 ctrl_vec_idx;
  s16 retval = ERR_DUPLICATE_ENTRY;
  equ_t *equ;

  if(!ctx || !label_name)
  {
    retval = ERR_NULL_PTR;
    goto done;
  }

  WRITE_LOG(LOG_HIGH, "Searching for label: %s\n", label_name);
  if((equ = find_label_by_name(ctx, label_name)) == NULL)
  {
    equ = &ctx->labels[ctx->total_labels];
    equ->name = malloc(strlen(label_name)+1);
    if(equ->name)
    {
      strcpy(equ->name, label_name);
      equ->index = ctx->total_labels;
      equ->value = value;
      ctx->total_labels++;
      retval = ERR_OK;
      WRITE_LOG(LOG_HIGH, "Found label %s, adding with value %d\n", equ->name, equ->value);
    }
    else
      retval = ERR_NULL_PTR;
  }

done:
  return retval;
}

// --==============================================--
s16 set_ctrl_vec_width_by_name(ctrl_vec_ctx_t *ctx, char *name, u08 width)
{
  s16 retval = ERR_NOT_FOUND;
  ctrl_vec_t *ctrl_vec;

  if((ctrl_vec = find_ctrl_vec_by_name(ctx, name)) != NULL)
  {
    // TODO: find out if this is not an addr ctrl_vec, and if that is the case,
    // then check if the value is < 0. If it is less than 0, return an error.
    // Don't do this check if the ctrl_vec is an addr ctrl_vec!
    ctrl_vec->width = width;
    retval = ERR_OK;
  }

  return retval;
}

s16 set_ctrl_vec_msb_by_name(ctrl_vec_ctx_t *ctx, char *name, u16 msb)
{
  s16 retval = ERR_NOT_FOUND;
  ctrl_vec_t *ctrl_vec;

  if((ctrl_vec = find_ctrl_vec_by_name(ctx, name)) != NULL)
  {
    ctrl_vec->msb = msb;
    retval = ERR_OK;
  }

  return retval;
}

s16 set_ctrl_vec_lsb_by_name(ctrl_vec_ctx_t *ctx, char *name, u16 lsb)
{
  s16 retval = ERR_NOT_FOUND;
  ctrl_vec_t *ctrl_vec;

  if((ctrl_vec = find_ctrl_vec_by_name(ctx, name)) != NULL)
  {
    ctrl_vec->lsb = lsb;
    retval = ERR_OK;
  }

  return retval;
}

// --==============================================--
// slice_up_the_word()
// 
// set the LSB & MSB of each ctrl_vec
// return the overall bit width of 
//
//s16 slice_up_the_word(ctrl_vec_t *cv_list, u16 list_len)
s16 slice_up_the_word(ctrl_vec_ctx_t *ctx)
{   
  s16 i;
  s16 retval = ERR_OK;
  s16 overall_width = 0;
  
  if(ctx == NULL)
  {
    retval = ERR_NULL_PTR;
    goto done;
  } 
  
  for(i = ctx->total_ctrl_vec-1; i >= 0; i--)
  {
    if(!ctx->list[i].microcode_vector) continue;

    ctx->list[i].lsb  = overall_width;
    overall_width    += ctx->list[i].width;
    ctx->list[i].msb  = overall_width - 1;

    WRITE_LOG(LOG_LOW, "Ctrl Vec: %s, Width: %d, MSB: %d, LSB: %d Overall width of word: %d\n",
          ctx->list[i].name, ctx->list[i].width,
          ctx->list[i].msb,  ctx->list[i].lsb,
          overall_width);
  }

  retval = overall_width;

done:
  return retval;
}
// --==============================================--


// --==============================================--
// load_labels_to_context_from_asm_file
//
// Given a ctrl vector name that should exist in the context ctx,
// this function will open the asm_filename file, and start
// loading all of the labels encountered as EQU values into
// the given control vector.
s16 load_labels_to_context_from_asm_file(ctrl_vec_ctx_t *ctx, char *asm_filename)
{
  enum asm_states {
    ASM_FIND_FIRST_ORG  = 0,
    ASM_FIND_LABEL = 1,
    ASM_END_STATE = 2
  };

  FILE *fp;
  char line[256];
  char val[32];
  s16 retval = ERR_OK;
  s16 label_name_len;
  s32 value;

  if(!ctx)
  {
    retval = ERR_NULL_PTR;
    goto done;
  }

  fp = fopen(asm_filename, "r");
  if(fp == NULL)
  {
    puts(asm_filename); /* why didn't the file open? */
    retval = ERR_NULL_PTR;
    goto done;
  }

  // Read each line from the file, one by one...
  while(fgets(line, 256, fp) != NULL)
  {
    // Skip lines beginning with a semicolon, treat like comments.
    if(is_comment(line)) continue;

    strip_string(line, 0);
    if(get_org_val(line, &value) == ERR_OK)
    {
      WRITE_LOG(LOG_HIGH, "Found ORG, setting address to %x (%d)\n", value, value);
      //printf("Found ORG, setting address to %x (%d)\n", value, value);
    }
    else if(check_field(line, "end_state", 1, 0) == ERR_OK)
    {
      value++;
    }
    else if((label_name_len = get_label(line)) > 0)
    {
      line[label_name_len] = '\0';
      if(retval = add_label_to_context(ctx, line, value) != ERR_OK)
      {
        printf("ERROR: add_label_to_context(): Could not add equ to ctrl vector (%d).\n", retval);
        goto done;
      }
    }

  }

done:
  return retval;
}
// --==============================================--


// --==============================================--
// set_ctrl_vec_equs_from_ctx_labels
//
// As the name implies, this copies all of the EQUs
// from one control vector to another.
//
// NOTE: This will free up any previous name and value
// stored in the destination ctrl vector EQU names.
s16 set_ctrl_vec_equs_from_ctx_labels(ctrl_vec_ctx_t *ctx, char *dst_ctrl_vec_name)
{
  s16 retval = ERR_OK;
  ctrl_vec_t *ctrl_vec_dst;
  int i;

  if((ctrl_vec_dst = find_ctrl_vec_by_name(ctx, dst_ctrl_vec_name)) == NULL)
  {
    WRITE_LOG(LOG_HIGH, "Found ctrl_vec %s\n", dst_ctrl_vec_name);
    retval = ERR_NOT_FOUND;
    goto done;
  }

  ctrl_vec_dst->total_equ = ctx->total_labels;

  WRITE_LOG(LOG_HIGH, "Adding labels as equs to destination ctrl_vec %s\n", dst_ctrl_vec_name);
  for(i = 0; i < ctx->total_labels; i++)
  {
    ctrl_vec_dst->equ[i].name = ctx->labels[i].name;

    if(ctrl_vec_dst->equ[i].name && ctx->labels[i].name)
    {
      ctrl_vec_dst->equ[i].index = ctx->labels[i].index;
      ctrl_vec_dst->equ[i].value = ctx->labels[i].value;

      WRITE_LOG(LOG_HIGH, "Found %s, added label as equ %s with value %d\n",
                           dst_ctrl_vec_name, ctrl_vec_dst->equ[i].name, ctrl_vec_dst->equ[i].value);
    }
  }

done:
  return retval;
}
// --==============================================--


// --==============================================--
// copy_all_equs_between_ctrl_vecs
//
// As the name implies, this copies all of the EQUs
// from one control vector to another.
//
// NOTE: This will free up any previous name and value
// stored in the destination ctrl vector EQU names.
s16 copy_all_equs_between_ctrl_vecs(ctrl_vec_ctx_t *ctx, char *src_ctrl_vec_name, char *dst_ctrl_vec_name)
{
  s16 retval = ERR_OK;
  ctrl_vec_t *ctrl_vec_src;
  ctrl_vec_t *ctrl_vec_dst;
  int i;

  if((ctrl_vec_src = find_ctrl_vec_by_name(ctx, src_ctrl_vec_name)) == NULL)
  {
    retval = ERR_NOT_FOUND;
    goto done;
  }

  if((ctrl_vec_dst = find_ctrl_vec_by_name(ctx, dst_ctrl_vec_name)) == NULL)
  {
    retval = ERR_NOT_FOUND;
    goto done;
  }

  ctrl_vec_dst->total_equ = ctrl_vec_src->total_equ;

  for(i = 0; i < ctrl_vec_src->total_equ; i++)
  {
    if(ctrl_vec_dst->equ[i].name) free(ctrl_vec_dst->equ[i].name);
    ctrl_vec_dst->equ[i].name = malloc(strlen(ctrl_vec_src->equ[i].name)+1);

    if(ctrl_vec_dst->equ[i].name && ctrl_vec_src->equ[i].name)
    {
      strcpy(ctrl_vec_dst->equ[i].name, ctrl_vec_src->equ[i].name);
      ctrl_vec_dst->equ[i].index = ctrl_vec_src->equ[i].index;
      ctrl_vec_dst->equ[i].value = ctrl_vec_src->equ[i].value;
    }
  }

done:
  return retval;
}
// --==============================================--


// --==============================================--
// get_equ_name_from_val
//
// Given a ctrl vec cv_list and total entries count
// find the first equate name associated with the value.
// Function returns name through name parameter,
// Return value of 0 is pass, negative failure.
s16 get_equ_name_from_val(ctrl_vec_t *cv_list, u16 cv_idx, u32 value, char **name)
{
  s16 retval = ERR_NOT_FOUND; // Assume failure until pass.
  u16 j;

  static char * null_string = "";

  *name = null_string;

  if(!cv_list)
  {
    printf("get_equ_name_from_val: cv_list was null\n");
    goto end;
  }

    for(j = 0; j < cv_list[cv_idx].total_equ; j++)
    {
      if(cv_list[cv_idx].equ[j].value == value)
      {
        *name = cv_list[cv_idx].equ[j].name;
        retval = ERR_OK;
        break;
      }
    }

end:
  return retval;
}
// --==============================================--

// --==============================================--
s16 inc_decode_use_cnt(equ_t *equ)
{
  s16 retval = ERR_OK;

  if(!equ)
  {
    retval = ERR_NULL_PTR;
    goto done;
  }

  equ->decode_use_cnt++;

done:
  return retval;
}
// --==============================================--

// --==============================================--
equ_t * get_equ_by_name_from_ctrl_vec(ctrl_vec_t *ctrl_vec, char *name)
{
  equ_t *retval = NULL;
  u16 idx;

  if(!ctrl_vec || !name)
  {
    printf("get_equ_by_name_from_ctrl_vec: ctrl_vec or name is NULL!\n");
    goto done;
  }

  for(idx = 0; idx < ctrl_vec->total_equ; idx++)
  {
    if(!strcmp(name, ctrl_vec->equ[idx].name))
      retval = &ctrl_vec->equ[idx];
  }

done:
  return retval;
}

// --==============================================--
// get_ctrl_vec_value()
// Returns the control vector value given its index and the microprogram address
//
u16 get_ctrl_vec_value(ctrl_vec_t *cv_list, u16 cv_idx, u08 *mem, u16 addr)
{
  u16 mpw_len_in_bytes;
  u08 mpw_offset_in_bytes;
  u16 mem_pos;
  s08 i;
  u32 raw_data = 0;
  u16 retval = 0;
  u32 mask_data = 0xFFFFFFFF;

  if(mem == NULL)
  {
    printf("get_ctrl_vec_value: memory pointer is null.\n");
    goto end;
  }

  mpw_len_in_bytes = (rnd_up((cv_list[0].msb + 1), 8))/8; // Calculate the Microprogram Word length rounded up to the nearest byte
  mpw_offset_in_bytes = mpw_len_in_bytes - (cv_list[cv_idx].lsb / 8); // Calculate which byte of the mpw is the first to load.
  mem_pos = (mpw_len_in_bytes * addr) + mpw_offset_in_bytes - 1; // Calculate memory position of first byte


  // Read in 24bits
  for (i = 0; i < 3; i++)
  {
    if (((s32)mem_pos-i)>=0) // Ensure we are not out bounds
      raw_data += (u32)(mem[mem_pos-i]) <<(i*8);
  }

  //Shift & Mask Data
  raw_data = raw_data >>(cv_list[cv_idx].lsb % 8);
  mask_data = ~(mask_data <<cv_list[cv_idx].width);
  retval = raw_data & mask_data;

end:
  return retval;
}
// --==============================================--


// --==============================================--
// Main state machine used to build the control vector list.
//
// Give it a context pointer and a macro file name.
// Returns ERR_OK on pass, other error code on failure.
s16 build_ctrl_vec_list(ctrl_vec_ctx_t *ctx, char *macro_file_name)
{
  enum main_states
  {
    FIND_MICROPROGRAM_WORD      = 0,
    READ_MICROPROGRAM_WORD_INIT = 1,
    FIND_CTRL_VEC               = 2,
    SET_CTRL_VEC_ADDR_EQU       = 3,
    READ_CTRL_VEC_EQU           = 4
  }; 

  u08 state = FIND_MICROPROGRAM_WORD;
  char line[255]; // make this dynamic...(cannot use dynamic %m in fscanf)
  FILE *macro_file_ptr = NULL;
  u08 done = 0;
  char field[128];
  char curr_ctrl_vec_name[128];
  s16 retval = ERR_OK;
  u32 line_num = 0;

  macro_file_ptr = fopen(macro_file_name, "r");
  if(macro_file_ptr == NULL)
  {
    printf("%s - ", macro_file_name);
    puts(macro_file_name); /* why didn't the file open? */
    retval = ERR_FILE_IO;
    goto done;
  } 

  while((fgets(line, 254, macro_file_ptr)))
  {
    line_num++;
    if(is_comment(line)) continue;

    strip_string(line, 1);
    WRITE_LOG(LOG_HIGH, "state: %d  \tctrl_vec_total: %d  \t%s\n", state, ctx->total_ctrl_vec, line);

    switch (state)
    {
      case FIND_MICROPROGRAM_WORD:
        if(strstr(line, "microprogram_word_begin")) state = READ_MICROPROGRAM_WORD_INIT;
      break;

      case READ_MICROPROGRAM_WORD_INIT:
        if(strstr(line, "microprogram_word_end"))
        {
          state = FIND_CTRL_VEC;
          done = 1;
        }
        else
        {
          // This is where each entry is collected.
          if(strstr(line, "INIT"))
          {
            get_field(line, field, 1, 0);
            if((retval = add_ctrl_vec(ctx, field, 0, 0, 0, 1)) != ERR_OK)
            {
              printf("State READ_MICROPROGRAM_WORD_INIT: Could not add control vector.\n");
              goto done;
            }
          }
        }

        get_field(line, field, 0, 0);
      break;

      case FIND_CTRL_VEC:
        if(strstr(line, "microprogram_addr_width"))
        {
          get_field(line, field, 1, 0);
          ctx->addr_width = atoi(field);
        }

        if(strstr(line, "ctrl_vec_begin") || strstr(line, "ctrl_vec_addr_begin"))
        {
          get_field(line, curr_ctrl_vec_name, 1, 0);
          get_field(line, field, 2, 0);
          if((retval = set_ctrl_vec_width_by_name(ctx, curr_ctrl_vec_name, atoi(field))) != ERR_OK)
          {
            // This is not necessarily an error now. If we see control vectors that are not
            // already in the INIT list, then we are dealing with other control vectors that
            // are used to build additional LUTs that are not necessarily true control vecs.
            // Note the last 0 parameter sets the microcode_vector to 0 so we know not to
            // output these control vectors in microcode. This is part of the change to add
            // the global use of decode muxes, not just jump tables. Need to use the field to
            // set the width accordingly.
            if((retval = add_ctrl_vec(ctx, curr_ctrl_vec_name, atoi(field), 0, 0, 0)) != ERR_OK)
            {
              printf("State READ_MICROPROGRAM_WORD_INIT: Could not add control vector.\n");
              goto done;
            }
            //printf("State FIND_CTRL_VEC: Could not set ctrl_vec width by name.\n");
            //goto done;
          }

          if(strstr(line, "ctrl_vec_addr_begin"))
          {
            state = SET_CTRL_VEC_ADDR_EQU;
          }
          else
            state = READ_CTRL_VEC_EQU;

          if(strstr(line, "ctrl_vec_end") || strstr(line, "ctrl_vec_addr_end"))
          {
            printf("ERROR: Found ctrl_vec_end or ctrl_vec_addr_end before ctrl_vec_begin.\n");
            retval = ERR_INVALID_STATE;
            goto done;
          }
        }

      break;

      case SET_CTRL_VEC_ADDR_EQU:
        WRITE_LOG(LOG_HIGH, "In state SET_CTRL_VEC_ADDR_EQU, Calling set_ctrl_vec_equs_from_ctx_labels()\n");
        if((retval = set_ctrl_vec_equs_from_ctx_labels(ctx, curr_ctrl_vec_name)) != ERR_OK)
        {
          printf("State FIND_CTRL_VEC: Could not set label equs to control vector.\n");
          goto done;
        }

        if(strstr(line, "ctrl_vec_addr_end"))
        {
          WRITE_LOG(LOG_HIGH, "Found ctrl_vec_addr_end\n");
          state = FIND_CTRL_VEC;
        }
      break;

      case READ_CTRL_VEC_EQU:
        if(strstr(line, "ctrl_vec_end"))
        {
          state = FIND_CTRL_VEC;
        }
        else if(strstr(line, "ctrl_vec_begin"))
        {
          printf("Error: Found ctrl_vec_begin when expecting ctrl_vec_end.\n");
          retval = ERR_INVALID_STATE;
          goto done;
        }
        else
        {
          //get_field(line, field, 1, 0);
          //if(strncmp(field, "EQU", 3) == 0)
          if(strstr(line, "EQU"))
          {
            char name[128];
            get_field(line, name, 0, 0);
            get_field(line, field, 2, 0);
            if(field[0] == '$')
            {
              if(strlen(field) <= 1)
              {
                retval = ERR_INVALID_FIELD;
                goto done;
              }
            }
            if((retval = add_equ_by_ctrl_vec_name(ctx, curr_ctrl_vec_name, name, str2num(field))) != ERR_OK)
            {
              printf("State READ_CTRL_VEC_EQU: Could not add equ to ctrl vector\n");
              goto done;
            } // if(add_equ_by_ctrl_vec_name)
          } // if(strncmp)
        } // else
      break;

    } // switch(state)
  } // while(read lines)

done:
  if(retval != ERR_OK) printf("Error %s on line num %ld in file %s (state %d)\n", get_error_by_name(retval), line_num, macro_file_name, state);
  if(macro_file_ptr) fclose(macro_file_ptr);
  return retval;
}


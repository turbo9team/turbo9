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
// Description: Macro function library.
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
#include "macro.h"
#include "statistics.h"
#include "strproc.h"

static char * null_string = "";
static macro_t _macro_list[MAX_MACROS]; // TODO: allocate to dynamic memory, use linked list, or other data structure.

// --==============================================--
// print_macro_list
// 
// Prints all names and associated values for all list elements.
//
// This is a debug function that has no purpose elsewhere.
//
void print_macro_list(macro_ctx_t *ctx)
{
  u16 macro_idx;
  u16 ctrl_vec_idx;
  macro_t *macro;

  WRITE_LOG_NF(LOG_HIGH, "\n");
  WRITE_LOG(LOG_HIGH, "High Level Macros List Dump Follows:\n");
  WRITE_LOG(LOG_HIGH, "Total macro count: %d\n", ctx->total_macros);

  for(macro_idx = 0; macro_idx < ctx->total_macros; macro_idx++)
  {
      WRITE_LOG_NF(LOG_HIGH, "=============================\n");
      WRITE_LOG_NF(LOG_HIGH, "List index: %d\nName: %s\n",
              macro_idx,
              ctx->list[macro_idx].name);
      macro = &ctx->list[macro_idx];
      WRITE_LOG_NF(LOG_HIGH, "Total ctrl_vecs: %d\n", macro->total_ctrl_vec);
      for(ctrl_vec_idx = 0; ctrl_vec_idx < ctx->list[macro_idx].total_ctrl_vec; ctrl_vec_idx++)
      {
        if(macro->ctrl_vec_def[ctrl_vec_idx].arg_num == -1)
        {
          WRITE_LOG_NF(LOG_HIGH, "\t%s\t%s $%x (%d -> %d)\n", macro->ctrl_vec_def[ctrl_vec_idx].ctrl_vec->name, macro->ctrl_vec_def[ctrl_vec_idx].data.equ->name, macro->ctrl_vec_def[ctrl_vec_idx].data.equ->value, macro->ctrl_vec_def[ctrl_vec_idx].ctrl_vec->index, macro->ctrl_vec_def[ctrl_vec_idx].data.equ->index);
        }
        else
        {
          WRITE_LOG_NF(LOG_HIGH, "\t%s\t$%d\n", macro->ctrl_vec_def[ctrl_vec_idx].ctrl_vec->name, macro->ctrl_vec_def[ctrl_vec_idx].data.value);
        }
      }
      WRITE_LOG_NF(LOG_HIGH, "=============================\n");
  }

  return;
}


// --==============================================--
s16 init_macro_ctx(ctrl_vec_ctx_t IN *ctrl_vec_ctx, macro_ctx_t OUT *macro_ctx)
{
  s16 retval = ERR_OK;
  u16 idx, ctrl_vec_idx;

  if(!ctrl_vec_ctx || !macro_ctx)
  {
    retval = ERR_NULL_PTR;
    goto done;
  }

  macro_ctx->list = _macro_list;
  macro_ctx->total_macros = 0;
  macro_ctx->ctrl_vec_ctx = ctrl_vec_ctx;

  for(idx = 0; idx < MAX_MACROS; idx++)
  {
    if(macro_ctx->list[idx].name) free(macro_ctx->list[idx].name);
    macro_ctx->list[idx].name = NULL;
    macro_ctx->total_macros = 0;

    for(ctrl_vec_idx = 0; ctrl_vec_idx < MAX_CTRL_VEC; ctrl_vec_idx++)
    {
      macro_ctx->list[idx].ctrl_vec_def[ctrl_vec_idx].ctrl_vec = NULL;
      macro_ctx->list[idx].ctrl_vec_def[ctrl_vec_idx].data.equ = NULL;
      macro_ctx->list[idx].ctrl_vec_def[ctrl_vec_idx].arg_num  = -1;
    }
  }

done:
  return retval;
}
// --==============================================--


// --==============================================--
// free_ctrl_vec_defs_from_macro
//
// This will clear out and free all ctrl_vec_defs from the
// given macro.
void free_ctrl_vec_defs_from_macro(macro_t *macro)
{
  u16 idx;

  macro->total_ctrl_vec = 0;

  for(idx = 0; idx < MAX_CTRL_VEC; idx++)
  {
    macro->ctrl_vec_def[idx].ctrl_vec = NULL;
    macro->ctrl_vec_def[idx].data.equ = NULL;
    macro->ctrl_vec_def[idx].arg_num  = -1;
  }
}

// --==============================================--
void free_macro_ctx(macro_ctx_t *ctx)
{
  u16 idx;
  u16 ctrl_vec_idx;

  ctx->list = _macro_list;
  ctx->total_macros = 0;

  for(idx = 0; idx < MAX_MACROS; idx++)
  {
    if(ctx->list[idx].name) free(ctx->list[idx].name);
    ctx->total_macros = 0;
    ctx->ctrl_vec_ctx = NULL; // Do not free here, allow to be freed in ctrl_vec context.

    for(ctrl_vec_idx = 0; ctrl_vec_idx < MAX_CTRL_VEC; ctrl_vec_idx++)
    {
      ctx->list[idx].ctrl_vec_def[ctrl_vec_idx].ctrl_vec = NULL;
      ctx->list[idx].ctrl_vec_def[ctrl_vec_idx].data.equ = NULL;
      ctx->list[idx].ctrl_vec_def[ctrl_vec_idx].arg_num  = -1;
    }
  }
}

macro_t * find_macro_by_name(macro_ctx_t *ctx, char * name)
{
  s32 idx;
  macro_t *macro = NULL;
  
  if(ctx == NULL || name == NULL)
    goto done;

  for(idx = 0; idx < MAX_MACROS; idx++)
  {
    if(ctx->list[idx].name)
      if(!strcmp(name, ctx->list[idx].name))
        macro = &ctx->list[idx];
  }

done:
  return macro;
}

// --==============================================--
// add_macro
// Takes:
// name
//
// returns error level, ERR_OK is success, ERR_DUPLICATE_ENTRY on failure.
//
s16 add_macro(macro_ctx_t *ctx, char *name)
{
  s16 retval = ERR_DUPLICATE_ENTRY;
  macro_t *macro;

  if(ctx == NULL || name == NULL)
  {
    retval = ERR_NULL_PTR;
    goto done;
  }

  if(find_macro_by_name(ctx, name) == NULL)
  {
    macro = &ctx->list[ctx->total_macros];
    macro->name = malloc(strlen(name)+1);
    strcpy(macro->name, name);
    ctx->total_macros++;
    retval = ERR_OK;
  }

done:
  return retval;
}

// --==============================================--
// add_ctrl_vec_def_by_macro
//
// Given the macro context (needed for the associated ctrl_vec_ctx
// that is needed to find ctrl_vecs and their equs), and a
// control vector name and equ name, find the given control
// vector and then add it to the current macro given by the
// current_macro paramter.
//
s16 add_ctrl_vec_def_by_macro(macro_ctx_t *ctx, macro_t *current_macro, char *type, char *ctrl_vec_name, char *equ_name)
{
  s16 retval = ERR_NOT_FOUND;
  ctrl_vec_ctx_t *ctrl_vec_ctx;
  ctrl_vec_t *ctrl_vec;
  equ_t *equ;

  if(ctx == NULL || ctx->ctrl_vec_ctx == NULL)
  {
    retval = ERR_NULL_PTR;
    goto done;
  }

  // Get the ctrl_vec from the list of control vectors.
  if((ctrl_vec = find_ctrl_vec_by_name(ctx->ctrl_vec_ctx, ctrl_vec_name)) != NULL)
  {
    WRITE_LOG(LOG_HIGH, "Found control vector by name: %s, type: %s\n", ctrl_vec_name, type);

    current_macro->ctrl_vec_def[current_macro->total_ctrl_vec].ctrl_vec = ctrl_vec;

    if(!strcmp(type, "arg"))
    {
      current_macro->ctrl_vec_def[current_macro->total_ctrl_vec].data.value = atoi(equ_name);
      current_macro->ctrl_vec_def[current_macro->total_ctrl_vec].arg_num = current_macro->total_args++;

      WRITE_LOG(LOG_HIGH, "ARG add ctrl_vec_def_by_macro: data value: %d, arg_num = %d\n",
             current_macro->ctrl_vec_def[current_macro->total_ctrl_vec].data.value,
             current_macro->ctrl_vec_def[current_macro->total_ctrl_vec].arg_num);
      retval = ERR_OK;
    }
    else if((equ = find_equ_by_name(ctrl_vec, equ_name)) != NULL)
    {
      current_macro->ctrl_vec_def[current_macro->total_ctrl_vec].data.equ = equ;
      WRITE_LOG(LOG_HIGH, "VAL add_ctrl_vec_def_by_macro: equ.name = %s, its value = %d\n",
             current_macro->ctrl_vec_def[current_macro->total_ctrl_vec].data.equ->name,
             current_macro->ctrl_vec_def[current_macro->total_ctrl_vec].data.equ->value);
      retval = ERR_OK;
    }

    current_macro->total_ctrl_vec++;
  }

done:
  return retval;
}

// --==============================================--
// add_ctrl_vec_def_by_macro_name
//
// Given the macro context (needed for the associated ctrl_vec_ctx
// that is needed to find ctrl_vecs and their equs), and a
// control vector name and equ name, find the given control
// vector and then add it to the current macro given by the
// curr_macro string. This function will find the current macro.
//
s16 add_ctrl_vec_def_by_macro_name(macro_ctx_t *ctx, char *curr_macro, char *type, char *ctrl_vec_name, char *equ_name)
{
  s16 retval = ERR_NOT_FOUND;
  ctrl_vec_ctx_t *ctrl_vec_ctx;
  ctrl_vec_t *ctrl_vec;
  macro_t *macro;
  equ_t *equ;

  if(ctx == NULL || ctx->ctrl_vec_ctx == NULL)
  {
    retval = ERR_NULL_PTR;
    goto done;
  }

  if((macro = find_macro_by_name(ctx, curr_macro)) != NULL)
  {
    retval = add_ctrl_vec_def_by_macro(ctx, macro, type, ctrl_vec_name, equ_name);
  }

done:
  return retval;
}


// --==============================================--
//
// get_total macro count_
//
// Returns the total number of macros in our list.
//
s32 get_total_macro_count(macro_ctx_t *ctx)
{
  s32 retval = ERR_NULL_PTR;
  if(ctx)
  {
    retval = ctx->total_macros;
  }

  return retval;
}

// --==============================================--
// Main state machine used to build the macro list.
//
// Give it a context pointer and a macro file name.
// Returns ERR_OK on pass, other error code on failure.
s16 build_macro_list(macro_ctx_t *ctx, char *macro_file_name)
{
  enum main_states
  {
    FIND_MACRO_BEGIN            = 0,
    READ_CTRL_VECS              = 1
  }; 

  char  line[255]; // TODO: Prefer this to be dynamic
  char *stripped_line = NULL;
  char  field[128];
  char  curr_macro_name[128];
  FILE *macro_file_ptr = NULL;
  s16   retval = ERR_OK;
  u08   state = FIND_MACRO_BEGIN;
  u08   done = 0;
  u32   line_num = 0;

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

    WRITE_LOG(LOG_HIGH, "state: %d  \tmacro_total: %d  \t%s\n", state, ctx->total_macros, line);

    switch (state)
    {
      case FIND_MACRO_BEGIN:
        if(strstr(line, "macro_begin"))
        {
          get_field(line, curr_macro_name, 1, 0);
          if((retval = add_macro(ctx, curr_macro_name)) != ERR_OK)
          {
            goto done;
          }
          state = READ_CTRL_VECS;
          WRITE_LOG(LOG_HIGH, "Found macro_begin name %s\n", field);
        }
        else if(strstr(line, "macro_end"))
        {
          printf("\n\n########## ERROR: Found macro_end before macro_begin. ##########\n");
          retval = ERR_INVALID_STATE;
          goto done;
        }
        else if(strstr(line, "decode_init"))
        {
          printf("Found a decode_init, ignoring\n");
        }
        else if(strstr(line, "decode"))
        {
          printf("Found a decode, ignoring\n");
        }
      break;

      case READ_CTRL_VECS:
        if(strstr(line, "macro_end"))
        {
          state = FIND_MACRO_BEGIN;
          WRITE_LOG(LOG_HIGH, "Found macro_end, going back to find macro_begin...\n");
        }
        else if(strstr(line, "macro_begin"))
        {
          printf("\n\n########## ERROR: Found macro_begin when expecting macro_end or a macro. ##########\n");
          retval = ERR_INVALID_STATE;
          goto done;
        }
        else if(strstr(line, "set_table"))
        {
          printf("Found a set_table, ignoring\n");
        }
        else
        {
          char ctrl_vec_name[64];
          char equ_name[64];
          char type[64];
          get_field(line, ctrl_vec_name, 0, 0);
          get_field(line, type, 1, 0);
          get_field(line, equ_name, 2, 0);
          // Add control vectors and their default value.
          if((retval = add_ctrl_vec_def_by_macro_name(ctx, curr_macro_name, type, ctrl_vec_name, equ_name)) != ERR_OK)
          {
            printf("\n\n########## ERROR: Could not add ctrl_vec_def by macro name. ##########\n");
            goto done;
          }
        }
      break;

    } // switch(state)

    //if(stripped_line) free(stripped_line);
  } // while(read lines)

done:
  if(retval != ERR_OK) printf("Error %s on line num %ld in file %s (state %d)\n", get_error_by_name(retval), line_num, macro_file_name, state);
  if(macro_file_ptr) fclose(macro_file_ptr);
  return retval;
}



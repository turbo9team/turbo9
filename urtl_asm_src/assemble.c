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
// Description: Assembler function library.
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
#include "strproc.h"
#include "verilog.h"

static char *null_string = "";
static macro_ctx_t *_macro_ctx;

// --==============================================--
s16 init_assembler(macro_ctx_t *macro_ctx)
{
  s16 retval = ERR_OK;

  if(!macro_ctx)
  {
    retval = ERR_NULL_PTR;
    goto done;
  }

  _macro_ctx = macro_ctx;

done:
  return retval;
}
// --==============================================--


// --==============================================--
s16 assemble(macro_ctx_t *macro_ctx, char *asm_file_name, s16 (*f)(u32, ctrl_vec_t *))
{
  FILE *asm_file_ptr = NULL;
  s16 retval = ERR_OK;
  char line[255] = {0};
  char name[255] = {0};
  char macro_name[255] = {0};
  u32 address = 0;
  macro_t *macro;
  ctrl_vec_ctx_t *cv_ctx;
  u08 begin = 0;
  u32 line_num = 0;

  asm_file_ptr = fopen(asm_file_name, "r");
  if(asm_file_ptr == NULL)
  {
    printf("%s - ", asm_file_name);
    puts(asm_file_name);
    retval = ERR_FILE_IO;
    goto done;
  }

  if(!macro_ctx)
  {
    retval = ERR_NULL_PTR;
    goto done;
  }

  cv_ctx = macro_ctx->ctrl_vec_ctx;

  while((fgets(line, 254, asm_file_ptr)) != NULL)
  {
    line_num++;

    if((retval = dump_comment(line_num, line)) != ERR_OK)
    {
      printf("dump_comment failed.\n");
      goto done;
    }

    if(is_comment(line) || is_empty_line(line)) continue;

    if(strstr(line, "ORG"))
    {
      //strmspc(line);
      if(!sscanf(line, " %*4c %*1c%3lx", &address))
      {
        retval = ERR_NOT_FOUND;
        goto done;
      }
    }
    else if(strstr(line, "end_state"))
    {
      u08 idx;
      // TODO: Here is where you want to call whatever function to 
      // convert the current set of control vectors into verilog or
      // some other data output. Do this before the call to reset
      // below...

      // Here is where the new control vector/EQU can be sent to a verilog
      // or other handler, and subsequently dumped.
      for(idx = 0; idx < cv_ctx->total_ctrl_vec; idx++)
      {
        if(cv_ctx->list[idx].equ_is_coded)
        {
          if((retval = ((*f)(address, &cv_ctx->list[idx]))) != ERR_OK)
            goto done;
        }
      }

      WRITE_LOG_NF(LOG_HIGH, "###############################################################\n");
      WRITE_LOG_NF(LOG_HIGH, "STATE OF CONTROL VECTORS AT end_state\n");
      print_ctrl_vec_list_equ_sel(cv_ctx);
      printf("------------------------------------------------------------------\n");

      if(begin)
      {
        if((retval = dump_verilog_end_case()) != ERR_OK)
          goto done;

        begin = 0;
      }

      if((retval = reset_all_ctrl_vec_equ_sel(cv_ctx)) != ERR_OK)
        goto done;

      address++;
    }
    else if(!get_label(line))
    {
      strip_string(line, 1);
      get_field(line, macro_name, 0, 0);

      if(strstr(line, "decode") || strstr(line, "decode_init"))
      {
        printf("Found a decode/decode_init, ignoring\n");
        continue;
      }

      // Get a pointer to the current macro.
      if((macro = find_macro_by_name(macro_ctx, macro_name)) != NULL)
      {
        u08 cv_idx;
        ctrl_vec_t *ctrl_vec;
        equ_t *equ;
        begin = 1;

        // Only if the macro has control vector defs...

        if(macro->total_ctrl_vec > 0)
        {
          printf("Address: %05lx: Macro Name: %s, Num Ctrl Vecs: %d, Num Args: %d\n", address, macro_name, macro->total_ctrl_vec, macro->total_args);

          // Iterate over each of the control vector defs in the macro.
          for(cv_idx = 0; cv_idx < macro->total_ctrl_vec; cv_idx++)
          {
            // Now get a pointer to the actual control vector from the original ctrl_vec list.
            ctrl_vec = macro->ctrl_vec_def[cv_idx].ctrl_vec;
          
            // If this is an EQU (not a parameterized value)...
            if(macro->ctrl_vec_def[cv_idx].arg_num < 0)
            {
              printf("\tVAL: ");
              equ = macro->ctrl_vec_def[cv_idx].data.equ;
            }
            // Otherwise, this is a parameterized value (arg)...
            else
            {
              // Parse the current line, get the name of the EQU name from the line.
              if((retval = get_field(line, name, macro->ctrl_vec_def[cv_idx].data.value + 1, 0)) < ERR_OK)
                goto done;
          
              printf("\tARG: ");
          
              // Using the EQU as parameter, now find it in the given control vector.
              if((equ = find_equ_by_name(ctrl_vec, name)) == NULL)
              {
                retval = ERR_NULL_PTR;
                goto done;
              }
            }
          
            printf("\tctrl_vec: %s \tequ: %d (%s)\n", macro->ctrl_vec_def[cv_idx].ctrl_vec->name, equ->value, equ->name);
            //
            // In any case, now that we have an equ, either by value or arg,
            // assign it to the current control vector.
            if((retval = set_ctrl_vec_equ_sel(macro->ctrl_vec_def[cv_idx].ctrl_vec, equ)) != ERR_OK)
              goto done;

          }

        }
      }
      else
      {
        printf("Macro %s not found!\n", macro_name);
        retval = ERR_NOT_FOUND;
        goto done;
      }
    }
  }

done:
  if(retval != ERR_OK) printf("Error %s on line num %ld in file %s\n", get_error_by_name(retval), line_num, asm_file_name);
  if(asm_file_ptr) fclose(asm_file_ptr);
  return retval;
}

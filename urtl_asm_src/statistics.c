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
// Description: Statistics library source.
//
//////////////////////////////////////////////////////////////////////////////
// History:
// 07.14.2023 - Kevin Phillipson
//   File header added
//
//////////////////////////////////////////////////////////////////////////////
// [TURBO9_HEADER_END]
#include <stdio.h>
#include <string.h>
#include "ctrl_vec.h"
#include "err.h"
#include "mathlib.h"
#include "mytypedef.h"
#include "strproc.h"

// --==============================================--
// run_statistics()
//
//
//s32 run_statistics(char *file_name, ctrl_vec_t *cv_list, u16 cv_total, u08 *mem)
s32 run_statistics(char *file_name, ctrl_vec_ctx_t *ctx, u08 *mem)
{
  FILE *fp;
  s32 ret_val = 0;
  u16 cv_idx = 0;
  u16 equ_idx = 0;
  u16 value_idx = 0;
  u32 value_total = 0;
  u32 value_cnt = 0;
  u16 i = 0;
  u16 bar_graph;
  u16 addr_idx = 0;
  s32 tmp;
  char field[128];
  char * equ_name;
  ctrl_vec_t *cv_list;
  u16 cv_total;

  if(!file_name)
  {
    printf("run_statistics(): filename parameter is null\n");
    ret_val = -1;
    goto end;
  }

  if(!ctx)
  {
    printf("run_statistics(): ctx pointer is null\n");
    ret_val = ERR_NULL_PTR;
    goto end;
  }

  if(!ctx->list)
  {
    printf("run_statistics(): list is null\n");
    ret_val = ERR_NULL_PTR;
    goto end;
  }

  cv_list = ctx->list;
  cv_total = ctx->total_ctrl_vec;

  fp = fopen(file_name, "w");
  if(fp)
  {
    for (cv_idx = 0; cv_idx < cv_total; cv_idx++)
    {
      fprintf(fp, "+==========================================================================================================+\n");
      make_str_pad(rnd_up(strlen(cv_list[cv_idx].name),2)/2, 46, ' ', field);
      fprintf(fp, "| %s %s (%2d bits)", field, cv_list[cv_idx].name, cv_list[cv_idx].width);
      make_str_pad(strlen(cv_list[cv_idx].name)/2, 46, ' ', field);
      fprintf(fp, " %s |\n", field);
      fprintf(fp, "|                                         microprogram_word[%2d:%2d]                                         |\n", cv_list[cv_idx].msb, cv_list[cv_idx].lsb);
      fprintf(fp, "+==========================================================================================================+\n");
  

      fprintf(fp, "Use Count:\n");
      for(equ_idx = 0; equ_idx < cv_list[cv_idx].total_equ; equ_idx++)
      {
        equ_name = cv_list[cv_idx].equ[equ_idx].name;

        make_str_pad((strlen(equ_name)+4+(rnd_up(cv_list[cv_idx].width,4)/4)), 20, ' ', field);
        fprintf(fp, "%s", field);

        fprintf(fp, " %s",equ_name);
      
        num2hex_str(cv_list[cv_idx].equ[equ_idx].value, cv_list[cv_idx].width, field);
        fprintf(fp, " (%s) ",field);
        
        bar_graph = cv_list[cv_idx].equ[equ_idx].use_cnt;
        if (value_cnt > 30)
          bar_graph = 60;
        fprintf(fp, "|");
        for (i = 0; i < bar_graph; i++)
          fprintf(fp, "#");

        fprintf(fp, " %d", cv_list[cv_idx].equ[equ_idx].use_cnt);

        if (cv_list[cv_idx].equ_sel == &cv_list[cv_idx].equ[equ_idx])
          fprintf(fp, " (default)");

        if (cv_list[cv_idx].equ[equ_idx].use_cnt > 30)
          fprintf(fp, " (clipped)");

        if (cv_list[cv_idx].equ[equ_idx].use_cnt)
          fprintf(fp, "\n");
        else
          fprintf(fp, " (equate not used!) \n");
      }

      fprintf(fp, "\nDecode Use Count:\n");
      for(equ_idx = 0; equ_idx < cv_list[cv_idx].total_equ; equ_idx++)
      {
        equ_name = cv_list[cv_idx].equ[equ_idx].name;

        make_str_pad((strlen(equ_name)+4+(rnd_up(cv_list[cv_idx].width,4)/4)), 20, ' ', field);
        fprintf(fp, "%s", field);

        fprintf(fp, " %s",equ_name);
      
        num2hex_str(cv_list[cv_idx].equ[equ_idx].value, cv_list[cv_idx].width, field);
        fprintf(fp, " (%s) ",field);
        
        bar_graph = cv_list[cv_idx].equ[equ_idx].decode_use_cnt;
        if (value_cnt > 30)
          bar_graph = 60;
        fprintf(fp, "|");
        for (i = 0; i < bar_graph; i++)
          fprintf(fp, "#");

        fprintf(fp, " %d", cv_list[cv_idx].equ[equ_idx].decode_use_cnt);

        if (cv_list[cv_idx].equ_sel == &cv_list[cv_idx].equ[equ_idx])
          fprintf(fp, " (default)");

        if (cv_list[cv_idx].equ[equ_idx].decode_use_cnt > 30)
          fprintf(fp, " (clipped)");

        if (cv_list[cv_idx].equ[equ_idx].decode_use_cnt)
          fprintf(fp, "\n");
        else
          fprintf(fp, " (equate not used!) \n");
      }



      fprintf(fp, "\n\n");
    }
    fclose(fp);
  }

end:
  return ret_val;
}
// --==============================================--


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
// Description: Debug tools library.
//
//////////////////////////////////////////////////////////////////////////////
// History:
// 07.14.2023 - Kevin Phillipson
//   File header added
//
//////////////////////////////////////////////////////////////////////////////
// [TURBO9_HEADER_END]
#include <stdio.h>
#include "ctrl_vec.h"
#include "err.h"

s16 debug_print(ctrl_vec_ctx_t *ctx)
{
  s16 retval = ERR_MISC;

  if(debug_file_ptr)
  {
    // Write data to to debug file
    fprintf(debug_file_ptr, "\n =====================================================> Control Vectors\n");
    for (ctrl_vec_idx = 0; ctrl_vec_idx < ctrl_vec_total; ctrl_vec_idx++)
    {
      fprintf(debug_file_ptr, "Control Vector Index = %d\n",ctrl_vec_idx);
      fprintf(debug_file_ptr, ctrl_vec_list[ctrl_vec_idx].name);
      fprintf(debug_file_ptr, "(%d bits)\n", ctrl_vec_list[ctrl_vec_idx].width);
      fprintf(debug_file_ptr, "microprogram_word[%d:%d]\n", ctrl_vec_list[ctrl_vec_idx].msb, ctrl_vec_list[ctrl_vec_idx].lsb);
  
        for (equ_idx = 0; equ_idx < ctrl_vec_list[ctrl_vec_idx].total_equ; equ_idx++)
        {

          fprintf(debug_file_ptr, "  %s ", ctrl_vec_list[ctrl_vec_idx].equ[equ_idx].name);
          make_str_pad(strlen(ctrl_vec_list[ctrl_vec_idx].equ[equ_idx].name), 32, '.', field);
          fprintf(debug_file_ptr, "%s", field);
          num2hex_str(ctrl_vec_list[ctrl_vec_idx].equ[equ_idx].value, ctrl_vec_list[ctrl_vec_idx].width, field);
          fprintf(debug_file_ptr, " 0x%s\n", field);
        }
      fprintf(debug_file_ptr, "\n");
    }

    // Write out the loaded microprogram memory and decode it
    fprintf(debug_file_ptr, "\n =====================================================> uProgram Memory\n");
    for(i = 0x43; i < 0x48; i++)
    {
    
      fprintf(debug_file_ptr, "----> Address = %03x\n", i);
      fprintf(debug_file_ptr, "  ", i);
    
      for(j = 0; j < 7; j++)
      {
        fputc(num2hex(s_rec_mem[(i*7)+j] >> 4), debug_file_ptr);
        fputc(num2hex(s_rec_mem[(i*7)+j] & 0x0F), debug_file_ptr);
      }
      fputc('\n', debug_file_ptr);

      for(j = 0; j < ctrl_vec_total; j++)
      {
        fprintf(debug_file_ptr, "  %s ",ctrl_vec_list[j].name);
        make_str_pad(strlen(ctrl_vec_list[j].name), 25, '.', field);
        fprintf(debug_file_ptr, "%s ", field);

        k = get_ctrl_vec_value(ctrl_vec_list, j, s_rec_mem, i);

        get_equ_name_from_val(ctrl_vec_list, j, k, &equ_name);
        fprintf(debug_file_ptr, "%s ",equ_name);

        make_str_pad(strlen(equ_name), 20, '.', field);
        fprintf(debug_file_ptr, "%s ", field);

        num2hex_str(k, ctrl_vec_list[j].width, field);
        fprintf(debug_file_ptr, "0x%s\n",field);
      }
      fprintf(debug_file_ptr, "\n");

    }
 
    fclose (debug_file_ptr);
  }


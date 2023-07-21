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
// Description: Verilog generator library.
//
//////////////////////////////////////////////////////////////////////////////
// History:
// 07.14.2023 - Kevin Phillipson
//   File header added
//
//////////////////////////////////////////////////////////////////////////////
// [TURBO9_HEADER_END]

#include <ctype.h>
#include <stdarg.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "err.h"
#include "libgen.h"
#include "log.h"
#include "mytypedef.h"
#include "ctrl_vec.h"
#include "macro.h"
#include "strproc.h"

static macro_ctx_t *_macro_ctx;
static FILE *_verilog_fp;
static char _vlog_file_name[256];
static char _asm_file_name[256];

s16 init_verilog_dump(macro_ctx_t *ctx, char *base_filename, char *asm_filename)
{
  s16 retval = ERR_OK;
  
  if(!ctx || !base_filename)
  {
    retval = ERR_NULL_PTR;
    goto done;
  }

  strcpy(_vlog_file_name, base_filename);

  strcat(_vlog_file_name, "_microcode.v");

  strcpy(_asm_file_name, asm_filename);

  _macro_ctx = ctx;

  _verilog_fp = fopen(_vlog_file_name, "w");
  if(_verilog_fp == NULL)
  {
    printf("%s - ", _vlog_file_name);
    perror(_vlog_file_name);
    retval = ERR_FILE_IO;
    goto done;
  }

done:
  return retval;
}


s16 dump_verilog_header()
{
  u16 idx;
  s16 retval = ERR_OK;
  ctrl_vec_t *ctrl_vec;
  char *ctrl_vec_name;
  char *equ_name;
  char *module_name;

  if(! _verilog_fp || !_macro_ctx)
  {
    retval = ERR_NULL_PTR;
    goto done;
  }



  fprintf(_verilog_fp, "// [TURBO9_MICROCODE_HEADER_START]\n");
  fprintf(_verilog_fp, "//////////////////////////////////////////////////////////////////////////////\n");
  fprintf(_verilog_fp, "//                          Turbo9 Microprocessor IP\n");
  fprintf(_verilog_fp, "//////////////////////////////////////////////////////////////////////////////\n");
  fprintf(_verilog_fp, "// Website: www.turbo9.org\n");
  fprintf(_verilog_fp, "// Contact: team[at]turbo9[dot]org\n");
  fprintf(_verilog_fp, "//////////////////////////////////////////////////////////////////////////////\n");
  fprintf(_verilog_fp, "// [TURBO9_MICROCODE_LICENSE_START]\n");
  fprintf(_verilog_fp, "// BSD-1-Clause\n");
  fprintf(_verilog_fp, "//\n");
  fprintf(_verilog_fp, "// Copyright (c) 2020-2023\n");
  fprintf(_verilog_fp, "// Kevin Phillipson\n");
  fprintf(_verilog_fp, "// Michael Rywalt\n");
  fprintf(_verilog_fp, "// All rights reserved.\n");
  fprintf(_verilog_fp, "//\n");
  fprintf(_verilog_fp, "// Redistribution and use in source and binary forms, with or without\n");
  fprintf(_verilog_fp, "// modification, are permitted provided that the following conditions are met:\n");
  fprintf(_verilog_fp, "//\n");
  fprintf(_verilog_fp, "// 1. Redistributions of source code must retain the above copyright notice,\n");
  fprintf(_verilog_fp, "//    this list of conditions and the following disclaimer.\n");
  fprintf(_verilog_fp, "//\n");
  fprintf(_verilog_fp, "// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS \"AS IS\"\n");
  fprintf(_verilog_fp, "// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE\n");
  fprintf(_verilog_fp, "// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE\n");
  fprintf(_verilog_fp, "// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS AND CONTRIBUTORS BE\n");
  fprintf(_verilog_fp, "// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR\n");
  fprintf(_verilog_fp, "// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF\n");
  fprintf(_verilog_fp, "// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS\n");
  fprintf(_verilog_fp, "// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN\n");
  fprintf(_verilog_fp, "// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)\n");
  fprintf(_verilog_fp, "// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE\n");
  fprintf(_verilog_fp, "// POSSIBILITY OF SUCH DAMAGE.\n");
  fprintf(_verilog_fp, "// [TURBO9_MICROCODE_LICENSE_END]\n");
  fprintf(_verilog_fp, "//////////////////////////////////////////////////////////////////////////////\n");
  fprintf(_verilog_fp, "// Engineer: Kevin Phillipson & Michael Rywalt\n");
  fprintf(_verilog_fp, "// Description:\n");
  fprintf(_verilog_fp, "// Assembled from %s file\n\n", _asm_file_name);
  fprintf(_verilog_fp, "//\n");
  fprintf(_verilog_fp, "//////////////////////////////////////////////////////////////////////////////\n");
  fprintf(_verilog_fp, "// History:\n");
  fprintf(_verilog_fp, "// 07.14.2023 - Kevin Phillipson\n");
  fprintf(_verilog_fp, "//   File header added\n");
  fprintf(_verilog_fp, "//\n");
  fprintf(_verilog_fp, "//////////////////////////////////////////////////////////////////////////////\n");
  fprintf(_verilog_fp, "// [TURBO9_MICROCODE_HEADER_END]\n");
  fprintf(_verilog_fp, "\n");
  fprintf(_verilog_fp, "/////////////////////////////////////////////////////////////////////////////\n");
  fprintf(_verilog_fp, "//                                MODULE\n");
  fprintf(_verilog_fp, "/////////////////////////////////////////////////////////////////////////////\n");
  module_name = basename(_vlog_file_name);
  module_name = strtok(module_name,".");
  fprintf(_verilog_fp, "module %s\n", module_name);
  fprintf(_verilog_fp, "(\n");
  fprintf(_verilog_fp, "  // Inputs:\n");
  fprintf(_verilog_fp, "  input     [%d:0] MICROCODE_ADR_I,\n\n", _macro_ctx->ctrl_vec_ctx->addr_width);
  fprintf(_verilog_fp, "  // Control Vectors\n");

  for(idx = 0; idx < _macro_ctx->ctrl_vec_ctx->total_ctrl_vec; idx++)
  {
    ctrl_vec = &_macro_ctx->ctrl_vec_ctx->list[idx];
    if(!ctrl_vec->microcode_vector) continue;
    ctrl_vec_name = convert_to_upper_case(ctrl_vec->name);
    if(ctrl_vec_name)
    {
      fprintf(_verilog_fp, "  output reg [%d:0] %s_O%c\n", ctrl_vec->msb - ctrl_vec->lsb, ctrl_vec_name, idx < _macro_ctx->ctrl_vec_ctx->total_microcode_vec-1? ',': ' ');
      memset(ctrl_vec_name, '\0', strlen(ctrl_vec_name));
      free(ctrl_vec_name);
      ctrl_vec_name = NULL;
    }
    
  }

  fprintf(_verilog_fp, ");\n\n\n");
  fprintf(_verilog_fp, "/////////////////////////////////////////////////////////////////////////////\n");
  fprintf(_verilog_fp, "//                                  MICROCODE\n");
  fprintf(_verilog_fp, "/////////////////////////////////////////////////////////////////////////////\n\n");
  fprintf(_verilog_fp, "always @* begin\n");
  fprintf(_verilog_fp, "  //\n");
  fprintf(_verilog_fp, "  // Control Logic Defaults\n");

  for(idx = 0; idx < _macro_ctx->ctrl_vec_ctx->total_ctrl_vec; idx++)
  {
    ctrl_vec = &_macro_ctx->ctrl_vec_ctx->list[idx];
    if(!ctrl_vec->microcode_vector) continue;
    equ_name = convert_to_upper_case(ctrl_vec->equ[0].name);
    ctrl_vec_name = convert_to_upper_case(ctrl_vec->name);
    if(equ_name && ctrl_vec_name)
    {
      fprintf(_verilog_fp, "  %s_O = %d'h%x;  // %s\n", ctrl_vec_name, ctrl_vec->width, ctrl_vec->equ[0].value, equ_name);
      memset(equ_name, '\0', strlen(equ_name));
      memset(ctrl_vec_name, '\0', strlen(ctrl_vec_name));
      free(equ_name);
      free(ctrl_vec_name);
      equ_name = NULL;
      ctrl_vec_name = NULL;
    }
  }

  fprintf(_verilog_fp, "  //\n");
  fprintf(_verilog_fp, "  // Decode Microcode Address\n");
  fprintf(_verilog_fp, "  case (MICROCODE_ADR_I)\n");
  fprintf(_verilog_fp, "\n");

done:
  return retval;
}

s16 dump_comment(u32 line_number, char *comment, ...)
{
  va_list args;
  char str[256] = {0};
  s16 retval = ERR_OK;

  va_start(args, comment);
  vsprintf(str, comment, args);
  va_end(args);

  if(!_verilog_fp)
  {
    retval = ERR_NULL_PTR;
    goto done;
  }

  fprintf(_verilog_fp, "    // %04ld: %s", line_number, str);

done:
  return retval;
}

s16 dump_verilog_ctrl_vec(u32 address, ctrl_vec_t *ctrl_vec)
{
  char * ctrl_vec_name;
  char * equ_name;
  s16 retval = ERR_OK;
  static u32 addr = 0xFFFFFFFF;

  if(!ctrl_vec || !_verilog_fp)
  {
    retval = ERR_NULL_PTR;
    goto done;
  }

  equ_name = convert_to_upper_case(ctrl_vec->equ_sel->name);
  ctrl_vec_name = convert_to_upper_case(ctrl_vec->name);
  
  if(addr != address)
  {
    fprintf(_verilog_fp, "    9'h%03lx: begin\n", address);
    addr = address;
  }

  fprintf(_verilog_fp, "      %s_O = %d'h%x;  // %s\n", ctrl_vec_name, ctrl_vec->width, ctrl_vec->equ_sel->value, equ_name);
  memset(equ_name, '\0', strlen(equ_name));
  memset(ctrl_vec_name, '\0', strlen(ctrl_vec_name));
  free(equ_name);
  free(ctrl_vec_name);
  equ_name = NULL;
  ctrl_vec_name = NULL;

done:
  return retval;
}

s16 dump_verilog_end_case()
{
  s16 retval = ERR_OK;

  if(!_verilog_fp)
  {
    retval = ERR_NULL_PTR;
    goto done;
  }

  fprintf(_verilog_fp, "    end\n\n\n");

done:
  return retval;
}

s16 dump_verilog_footer()
{
  u16 idx;
  ctrl_vec_t *ctrl_vec;
  char * ctrl_vec_name;
  char * equ_name;
  s16 retval = ERR_OK;

  if(!_verilog_fp)
  {
    retval = ERR_NULL_PTR;
    goto done;
  }

  fprintf(_verilog_fp, "    default: begin\n");
  fprintf(_verilog_fp, "      //\n");
  fprintf(_verilog_fp, "      // Control Logic Defaults\n");

  for(idx = 0; idx < _macro_ctx->ctrl_vec_ctx->total_ctrl_vec; idx++)
  {
    ctrl_vec = &_macro_ctx->ctrl_vec_ctx->list[idx];
    if(!ctrl_vec->microcode_vector) continue;
    equ_name = convert_to_upper_case(ctrl_vec->equ[0].name);
    ctrl_vec_name = convert_to_upper_case(ctrl_vec->name);
    if(equ_name && ctrl_vec_name)
    {
      fprintf(_verilog_fp, "      %s_O = %d'h%x;  // %s\n", ctrl_vec_name, ctrl_vec->width, ctrl_vec->equ[0].value, equ_name);
      memset(equ_name, '\0', strlen(equ_name));
      memset(ctrl_vec_name, '\0', strlen(ctrl_vec_name));
      free(equ_name);
      free(ctrl_vec_name);
      equ_name = NULL;
      ctrl_vec_name = NULL;
    }
  }

  fprintf(_verilog_fp, "    end\n");
  fprintf(_verilog_fp, "  endcase\n");
  fprintf(_verilog_fp, "end\n\n");
  fprintf(_verilog_fp, "/////////////////////////////////////////////////////////////////////////////\n\n");
  fprintf(_verilog_fp, "endmodule\n");


done:
  return retval;
}


s16 uninit_verilog_dump()
{
  if(_verilog_fp)
  {
    fclose(_verilog_fp);
  }
}

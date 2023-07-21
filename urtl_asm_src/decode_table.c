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
// Description: Decode table generator library.
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
#include "ctrl_vec.h"
#include "err.h"
#include "decode_table.h"
#include "log.h"
#include "mathlib.h"
#include "mytypedef.h"
#include "strproc.h"

#define MAX_JM_LIST 32
#define EQU_PADDING 12

// This type is used by the function that prints the tables.
// Three types exist:
//    reg - the register type that takes a value.
//     op - a string type to represent the operation description.
//     eq - a string type to represent the equ.
enum table {reg, op, eq};

// --==============================================--
s16 init_decode_table_ctx(decode_table_ctx_t **ctx, ctrl_vec_ctx_t *cv_ctx)
{
  s16 retval = ERR_OK;

  if(*ctx == NULL)
  {
    *ctx = malloc(sizeof(decode_table_ctx_t));
    if(!ctx)
    {
      retval = ERR_NULL_PTR;
      goto done;      
    }

    // Newly allocated context has no prebyte list.
    (*ctx)->tables     = NULL;
    (*ctx)->num_tables = 0;
    (*ctx)->cv_ctx     = cv_ctx;
  }
  else
    retval = ERR_ALREADY_ALLOCATED;

done:
  return retval;
}

// --==============================================--
decode_table_t * find_table_by_name(decode_table_ctx_t *ctx, char *table_name)
{
  decode_table_t *table = NULL;
  u16 idx;

  if(!ctx)
  {
    WRITE_LOG(LOG_HIGH, "Context null!\n");
    goto done;
  }

  if(!table_name)
  {
    WRITE_LOG(LOG_HIGH, "Table name null!\n");
    goto done;
  }

  for(idx = 0; idx < ctx->num_tables; idx++)
  {
    if(!ctx->tables[idx].name)
    {
      WRITE_LOG(LOG_HIGH, "Table index %d, name null!\n", idx);
      goto done;
    }

    if(!strcmp(ctx->tables[idx].name, table_name))
    {
      table = &ctx->tables[idx];
      WRITE_LOG(LOG_HIGH, "Table index %d, found table %s!\n", idx, table_name);
      goto done;
    }
  }

done:
  return table;
}

// --==============================================--
s16 find_opcode_in_decode_table(decode_table_t *table, u08 opcode)
{
  s16 retval = ERR_NOT_FOUND;
  u16 idx;

  if(!table)
  {
    retval = ERR_NULL_PTR;
    goto done;
  }

  for(idx = 0; idx < table->list_len; idx++)
  {
    if(table->list[idx].opcode == opcode)
    {
      retval = idx;
    }
  }

done:
  return retval;
}

// --==============================================--
s16 swap_list_elements(decode_t *a, decode_t *b)
{
  s16 retval = ERR_OK;
  decode_t c;

  if(!a || !b)
  {
    retval = ERR_NULL_PTR;
    goto done;
  }

  c.opcode      = a->opcode;
  c.has_comment = a->has_comment;
  c.comment     = a->comment;
  c.equ         = a->equ;

  a->opcode      = b->opcode;
  a->has_comment = b->has_comment;
  a->comment     = b->comment;
  a->equ         = b->equ;

  b->opcode      = c.opcode;
  b->has_comment = c.has_comment;
  b->comment     = c.comment;
  b->equ         = c.equ;

done:
  return retval;
}
// --==============================================--
s16 add_opcode_to_table(decode_table_ctx_t *ctx, decode_table_t *table, u08 opcode, equ_t *equ, u08 has_comment, char *comment)
{
  s16 retval = ERR_OK;
  s16 index;
  s16 traversal;

  if(!ctx)
  {
    retval = ERR_NULL_PTR;
    goto done;
  }

  if(index = find_opcode_in_decode_table(table, opcode) == ERR_NOT_FOUND)
  {
    WRITE_LOG(LOG_HIGH, "table %s len: %d, alloc size: %d\n", table->name, table->list_len, (table->list_len+1)*sizeof(decode_t));
    table->list = realloc(table->list, (table->list_len+1)*sizeof(decode_t));
    if(table->list)
    {
      // Add the new element to the end of the list.
      table->list[table->list_len].opcode = opcode;
      table->list[table->list_len].equ    = equ;

      if((retval = inc_decode_use_cnt(equ)) != ERR_OK)
      {
        printf("add_opcode_to_table: Error: (%d) EQU pointer is NULL!\n", retval);
        goto done;
      }

      if(has_comment)
      {
        char padding[32] = {0};
        s16 str_len;
        s16 equ_name_len;
        str_len = strlen(comment);
        equ_name_len = strlen(equ->name);
        
        make_str_pad(strlen(equ->name), EQU_PADDING, ' ', padding);

        table->list[table->list_len].comment = malloc(equ_name_len*sizeof(char)+str_len*sizeof(char)+6+20);
        sprintf(table->list[table->list_len].comment, "// %s%s%s", equ->name, padding, comment);
        table->list[table->list_len].has_comment = has_comment;
      }
      else
        table->list[table->list_len].has_comment = 0;

      table->list_len++;

      // Cheap sort... This can be optimized...
      if(table->list_len > 1)
      {
        // Move the element into place.
        for(traversal = table->list_len-1; traversal >= 1; traversal--)
        {
          // Sort by opcode.
          if(table->list[traversal-1].opcode > table->list[traversal].opcode)
          {
            // TODO: maybe change this to swap list element instead of list element contents...?
            retval = swap_list_elements(&table->list[traversal-1], &table->list[traversal]);
          }
        }
      }
    }
    else
      retval = ERR_NULL_PTR;
  }
  else
  {
    WRITE_LOG(LOG_HIGH, "Duplicate opcode found at table %s, list element %d.\n", table->name, index);
    retval = index; 
  }

done:
  return retval;
}

// --==============================================--
s16 add_table_to_ctx(decode_table_ctx_t *ctx, char *table_name, ctrl_vec_t *ctrl_vec, char *default_val)
{
  u32 idx;
  s16 retval = ERR_OK;

  if(!ctx)
  {
    retval = ERR_NULL_PTR;
    goto done;
  }

  if(!ctx->cv_ctx)
  {
    retval = ERR_NULL_PTR;
    goto done;
  }

  for(idx = 0; idx < ctx->num_tables; idx++)
  {
    if(strcmp(table_name, ctx->tables[idx].name) == 0)
    {
      WRITE_LOG(LOG_HIGH, "Found duplicate table at index %d with name %s\n", idx, table_name);
      goto done;
    }
  }

  ctx->tables = realloc(ctx->tables, (ctx->num_tables+1)*sizeof(decode_table_t));
  if(ctx->tables)
  {
    // Newly allocated table has no mappings yet...
    ctx->tables[ctx->num_tables].name = malloc(strlen(table_name)*sizeof(char)+1);
    if(ctx->tables[ctx->num_tables].name)
    {
      memset(ctx->tables[ctx->num_tables].name, 0, strlen(table_name)*sizeof(char)+1);
      memcpy(ctx->tables[ctx->num_tables].name, table_name, strlen(table_name)*sizeof(char));
      //strcpy(ctx->tables[ctx->num_tables].name, table_name);
      ctx->tables[ctx->num_tables].list_len = 0;
      ctx->tables[ctx->num_tables].list = NULL;
      ctx->tables[ctx->num_tables].ctrl_vec = ctrl_vec;
      ctx->tables[ctx->num_tables].default_val = malloc(strlen(default_val)*sizeof(char)+1);
      strcpy(ctx->tables[ctx->num_tables].default_val, default_val);
      ctx->num_tables++;
    }
    else
    {
      retval = ERR_NULL_PTR;
      goto done;
    }
  }
  else
    retval = ERR_NULL_PTR;

done:
  return retval;
}

// --==============================================--
s16 free_decode_list(decode_t *list)
{
  s16 retval = ERR_OK;

  if(list)
  {
    if(list->comment) free(list->comment);
    free(list);
  }

done:
  return retval;
}

// --==============================================--
s16 free_all_tables(decode_table_ctx_t *ctx)
{
  u16 idx;
  s16 retval = ERR_OK;

  if(ctx->tables)
  {
    for(idx = 0; idx < ctx->num_tables; idx++)
    {
      if(ctx->tables[idx].default_val) free(ctx->tables[idx].default_val);
      if(ctx->tables[idx].name) free(ctx->tables[idx].name);
    }

    if((retval = free_decode_list(ctx->tables->list)) != ERR_OK)
    {
      goto done;
    }
    free(ctx->tables);
  }

done:
  return retval;
}

// --==============================================--
s16 free_decode_table_ctx(decode_table_ctx_t *ctx)
{
  s16 retval = ERR_OK;

  if(ctx)
  {
    if((retval = free_all_tables(ctx)) != ERR_OK)
    {
      goto done;
    }
    free(ctx);
    ctx = NULL;
  }
  else
    retval = ERR_NULL_PTR;

done:
  return retval;
}


// --==============================================--
// Main state machine used to build the control vector list.
//
// Give it a context pointer and a macro file name.
// Returns ERR_OK on pass, other error code on failure.
s16 build_decode_table(decode_table_ctx_t *ctx, char *asm_file_name)
{
  s16 retval = ERR_OK;
  FILE *decode_table_fp;
  char  line[255]; // TODO: Prefer this to be dynamic
  char  field[64];
  u32   value = 0;
  u32   line_num = 0;
  s16   comment_pos;
  u32   count = 0;
  ctrl_vec_t *ctrl_vec;
  decode_table_t *table;

  if(!ctx || !asm_file_name)
  {
    printf("build_decode_table(ctx = %p, file name = %s)\n", ctx, asm_file_name);
    retval = ERR_NULL_PTR;
    goto done;
  }

  decode_table_fp = fopen(asm_file_name, "r");
  if(decode_table_fp == NULL)
  {
    retval = ERR_FILE_IO;
    goto done;
  } 

  while((fgets(line, 254, decode_table_fp)))
  {
    line_num++;

    comment_pos = strip_string(line, 0);

    printf("line %ld: %s\n", count++, line);

    if(check_field(line, "decode_init", 1, 0) == ERR_OK)
    {
      char *table_name;
      char *ctrl_vec_name;
      char *default_val;

      if((retval = get_field_ex(line, &table_name, 2, 0)) <= ERR_OK)
      {
        printf("get_field_ex failed.\n");
        goto done;
      }
      else
        retval = ERR_OK;
        
      if((retval = get_field_ex(line, &ctrl_vec_name, 3, 0)) <= ERR_OK)
      {
        printf("get_field_ex failed.\n");
        goto done;
      }
      else
      {
        retval = ERR_OK;
        // The name of the control vector used to be passed into add_table_to_ctx, but
        // the EQU is needed, and it is more appropriate to pull it from the ctrl_vec list.
        if((ctrl_vec = find_ctrl_vec_by_name(ctx->cv_ctx, ctrl_vec_name)) == NULL)
        {
          retval = ERR_NOT_FOUND;
          goto done;
        }
      }
      
      if((retval = get_field_ex(line, &default_val, 4, 0)) <= ERR_OK)
      {
        printf("get_field_ex failed.\n");
        goto done;
      }
      else
        retval = ERR_OK;

      WRITE_LOG(LOG_HIGH, "Found decode_init, table: %s ctrl_vec_name: %s default_val: %s\n", table_name, ctrl_vec_name, default_val);

      if((retval = add_table_to_ctx(ctx, table_name, ctrl_vec, default_val)) != ERR_OK)
      {
        printf("ERROR: add_table_to_ctx returned %d\n", retval);
        goto done;
      }
      
      if(table_name) free(table_name);
      if(ctrl_vec_name) free(ctrl_vec_name);
      if(default_val) free(default_val);

    }
    else if(check_field(line, "decode", 1, 0) == ERR_OK)
    {
      char *table_name = NULL;
      char *equ_name = NULL;
      char *val = NULL;
      s08 idx = 0;
      u16 opcode = 0;
      s16 temp;
      equ_t *equ = NULL;

      if((retval = get_field_ex(line, &table_name, 2, 0)) <= ERR_OK)
      {
        printf("get_field_ex failed.\n");
        goto done;
      }
      else
      {
        table = find_table_by_name(ctx, table_name);
        if(!table)
        {
          retval = ERR_NOT_FOUND;
          WRITE_LOG(LOG_HIGH, "Table %s not found.\n", table_name);
          goto done;
        }
      }

      if((retval = get_field_ex(line, &equ_name, 3, 0)) <= ERR_OK)
      {
        printf("get_field_ex failed.\n");
        goto done;
      }
      else
      {
        equ = get_equ_by_name_from_ctrl_vec(table->ctrl_vec, equ_name);
        if(!equ)
        {
          retval = ERR_NOT_FOUND;
          WRITE_LOG(LOG_HIGH, "EQU %s could not be found in ctrl vec %s\n", equ_name, ctrl_vec->name);
          goto done;
        }
      }

      // TODO: 64 seems arbitrary, although probably excessive...
      for(idx = 4; idx < 64; idx++)
      {
        val = NULL;
        temp = get_field_ex(line, &val, idx, 0);
        if(temp >= ERR_OK)
        {
          opcode = (str2num(val) & 0xFF);

          // The comment position is greater than 0. ERR_OK is 0. Real errors are less than 0.
          if((temp = add_opcode_to_table(ctx, table, (u08)opcode, equ, comment_pos > ERR_OK, line+comment_pos)) == ERR_OK)
            WRITE_LOG(LOG_HIGH, "idx = %d, opcode %x for table: %s, EQU: %s\n", idx, opcode, table_name, equ_name);

          if(val) free(val);
        }
      }

      // The get_field_ex calls will return a position or a failure, so clear the position.
      if(retval >= ERR_OK) retval = ERR_OK;

      if(table_name) free(table_name);
      if(equ_name) free(equ_name);
    }
  } // while(read lines)

done:
  if(retval != ERR_OK) printf("Error %s on line num %ld in file %s\n", get_error_by_name(retval), line_num, asm_file_name);
  if(decode_table_fp) fclose(decode_table_fp);
  return retval;
}

void fprint_decode_logic(FILE *fp, decode_table_ctx_t *ctx, char *reg_name, u32 table_num, u16 addr_width, enum table type)
{
  u32 idx;
  char sub_str[64] = {0};

  if(ctx->tables[table_num].list_len)
  {
    for(idx = 0; idx < ctx->tables[table_num].list_len; idx++)
    {
      printf("opcode %x\n", (u08)ctx->tables[table_num].list[idx].opcode);
      {
        // First, print out the verilog case along with the reg name.
        fprintf(fp, "    8'h%02X : %s_", ctx->tables[table_num].list[idx].opcode, reg_name);

        // Now use a C case statement to fill out the rest of the verilog case statements.
        switch(type)
        {
        case reg:
        fprintf(fp, "O = %d'h%x; %s%s",
                        addr_width,
                        ctx->tables[table_num].list[idx].equ->value,
                        ctx->tables[table_num].list[idx].comment,
                        ctx->tables[table_num].list[idx].has_comment ? "" : "\n"); // comments have \n already.
        break;

        case op:
        sub_str_by_field(ctx->tables[table_num].list[idx].comment, ' ', sub_str, 3, 99);
        fprintf(fp, "op = \"%s\";\n", sub_str);
        break;

        case eq:
        //sub_str_by_field(ctx->tables[table_num].list[idx].comment, ' ', sub_str, 2, 2);
        fprintf(fp, "eq = \"%s\";\n", ctx->tables[table_num].list[idx].equ->name);
        break;
        }
      }
    }
  }
  switch(type) {
    case reg: fprintf(fp, "    default : %s_O = %d'h%s; // from decode_init\n", reg_name, addr_width, ctx->tables[table_num].default_val); break;
    case  op: fprintf(fp, "    default : %s_op = \"invalid\";\n", reg_name); break;
    case  eq: fprintf(fp, "    default : %s_eq = \"invalid\";\n", reg_name); break;
  }
}

s16 build_decode_table_file(decode_table_ctx_t *ctx, u32 table_num, char *filename, char *asm_filename)
{
  s16 retval = ERR_OK;
  char table_filename[78] = {0};
  char full_table_filename[80] = {0};
  u32 idx;
  u16 addr_width;
  char pb[16] = {0};
  char *uppercase_str;
  FILE *fp;

  if(!ctx || !filename)
  {
    retval = ERR_NULL_PTR;
    goto done;
  }

  strcpy(table_filename, filename);
  sprintf(table_filename, "%s_%s", filename, ctx->tables[table_num].name);
  sprintf(full_table_filename, "%s.v", table_filename);

  printf("built name: %s\n", full_table_filename);

  fp = fopen(full_table_filename, "w");
  if(!fp)
  {
    retval = ERR_FILE_IO;
    goto done;
  }

  uppercase_str = convert_to_upper_case(ctx->tables[table_num].name);
  addr_width = ctx->tables[table_num].ctrl_vec->width;


  fprintf(fp, "// [TURBO9_DECODE_HEADER_START]\n");
  fprintf(fp, "//////////////////////////////////////////////////////////////////////////////\n");
  fprintf(fp, "//                          Turbo9 Microprocessor IP\n");
  fprintf(fp, "//////////////////////////////////////////////////////////////////////////////\n");
  fprintf(fp, "// Website: www.turbo9.org\n");
  fprintf(fp, "// Contact: team[at]turbo9[dot]org\n");
  fprintf(fp, "//////////////////////////////////////////////////////////////////////////////\n");
  fprintf(fp, "// [TURBO9_DECODE_LICENSE_START]\n");
  fprintf(fp, "// BSD-1-Clause\n");
  fprintf(fp, "//\n");
  fprintf(fp, "// Copyright (c) 2020-2023\n");
  fprintf(fp, "// Kevin Phillipson\n");
  fprintf(fp, "// Michael Rywalt\n");
  fprintf(fp, "// All rights reserved.\n");
  fprintf(fp, "//\n");
  fprintf(fp, "// Redistribution and use in source and binary forms, with or without\n");
  fprintf(fp, "// modification, are permitted provided that the following conditions are met:\n");
  fprintf(fp, "//\n");
  fprintf(fp, "// 1. Redistributions of source code must retain the above copyright notice,\n");
  fprintf(fp, "//    this list of conditions and the following disclaimer.\n");
  fprintf(fp, "//\n");
  fprintf(fp, "// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS \"AS IS\"\n");
  fprintf(fp, "// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE\n");
  fprintf(fp, "// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE\n");
  fprintf(fp, "// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS AND CONTRIBUTORS BE\n");
  fprintf(fp, "// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR\n");
  fprintf(fp, "// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF\n");
  fprintf(fp, "// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS\n");
  fprintf(fp, "// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN\n");
  fprintf(fp, "// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)\n");
  fprintf(fp, "// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE\n");
  fprintf(fp, "// POSSIBILITY OF SUCH DAMAGE.\n");
  fprintf(fp, "// [TURBO9_DECODE_LICENSE_END]\n");
  fprintf(fp, "//////////////////////////////////////////////////////////////////////////////\n");
  fprintf(fp, "// Engineer: Kevin Phillipson & Michael Rywalt\n");
  fprintf(fp, "// Description:\n");
  fprintf(fp, "// Assembled from %s file\n", asm_filename);
  fprintf(fp, "// built using %s ctrl_vec\n", ctx->tables[table_num].ctrl_vec->name);
  fprintf(fp, "//\n");
  fprintf(fp, "//////////////////////////////////////////////////////////////////////////////\n");
  fprintf(fp, "// History:\n");
  fprintf(fp, "// 07.14.2023 - Kevin Phillipson\n");
  fprintf(fp, "//   File header added\n");
  fprintf(fp, "//\n");
  fprintf(fp, "//////////////////////////////////////////////////////////////////////////////\n");
  fprintf(fp, "// [TURBO9_DECODE_HEADER_END]\n");
  fprintf(fp, "\n");
  fprintf(fp, "/////////////////////////////////////////////////////////////////////////////\n");
  fprintf(fp, "//                                MODULE\n");
  fprintf(fp, "/////////////////////////////////////////////////////////////////////////////\n");
  fprintf(fp, "module %s", table_filename);
  fprintf(fp, "(\n");
  fprintf(fp, "  input      [7:0] OPCODE_I,\n"); // TODO: dynamic width
  fprintf(fp, "  output reg [%d:0] %s_O\n", addr_width-1, uppercase_str);
  fprintf(fp, ");\n");
  fprintf(fp, "\n");
  fprintf(fp, "/////////////////////////////////////////////////////////////////////////////\n");
  fprintf(fp, "//                                LOGIC\n");
  fprintf(fp, "/////////////////////////////////////////////////////////////////////////////\n");
  fprintf(fp, "\n");
  //////////////////////////////////////
  fprintf(fp, "always @* begin\n");
  fprintf(fp, "  case (OPCODE_I)\n");

  fprint_decode_logic(fp, ctx, uppercase_str, table_num, addr_width, reg);

//  fprintf(fp, "    default : %s_O = %d'h%s; // from decode_init\n", uppercase_str, addr_width, ctx->tables[table_num].default_val);

  fprintf(fp, "  endcase\n");
  fprintf(fp, "end\n\n");
  //////////////////////////////////////
  
  fprintf(fp, "`ifdef SIM_TURBO9\n\n");
  fprintf(fp, "reg [(8*64):0] %s_op;\n\n", uppercase_str);
  fprintf(fp, "always @* begin\n");
  fprintf(fp, "  case (OPCODE_I)\n");
  fprint_decode_logic(fp, ctx, uppercase_str, table_num, addr_width, op);
//  fprintf(fp, "    default : %s_op = \"invalid\";\n", uppercase_str);
  fprintf(fp, "  endcase\n");
  fprintf(fp, "end\n\n");

  fprintf(fp, "reg [(8*64):0] %s_eq;\n\n", uppercase_str);
  fprintf(fp, "always @* begin\n");
  fprintf(fp, "  case (OPCODE_I)\n");
  fprint_decode_logic(fp, ctx, uppercase_str, table_num, addr_width, eq);
//  fprintf(fp, "    default : %s_op = \"invalid\";\n", uppercase_str);
  fprintf(fp, "  endcase\n");
  fprintf(fp, "end\n\n");
  fprintf(fp, "`endif\n");

  fprintf(fp, "\n");
  fprintf(fp, "/////////////////////////////////////////////////////////////////////////////\n");
  fprintf(fp, "\n");
  fprintf(fp, "endmodule\n");


done:
  if(fp) fclose(fp);
  if(uppercase_str) free(uppercase_str);

  return retval;
}

// --==============================================--
// output_decode_tables
//
s16 output_decode_tables(decode_table_ctx_t *ctx, char *base_filename, char *asm_filename)
{
  u32 idx, idx_tables, idx_list;
  s16 retval = ERR_OK;
  char decode_filename[256] = {0};

  if(!ctx || !base_filename)
  {
    retval = ERR_NULL_PTR;
    goto done;
  }
  
  strcpy(decode_filename, base_filename);
  
  strcat(decode_filename, "_decode");

  // Build a separate file for each of the prebytes.
  for(idx_tables = 0; idx_tables < ctx->num_tables; idx_tables++)
  {
    if((retval = build_decode_table_file(ctx, idx_tables, decode_filename, asm_filename)) != ERR_OK)
      goto done;
  }

done:
  return retval;
}

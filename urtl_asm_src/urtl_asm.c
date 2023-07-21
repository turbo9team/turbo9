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
// Engineer: Kevin Phillipson and Michael Rywalt
// Description: Microcode Assembler main entry point.
//
//////////////////////////////////////////////////////////////////////////////
// History:
// 07.14.2023 - Kevin Phillipson
//   File header added
//
//////////////////////////////////////////////////////////////////////////////
// [TURBO9_HEADER_END]

#include <ctype.h>
#include <dirent.h>
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <regex.h>
#include <unistd.h>
#include "assemble.h"
#include "ctrl_vec.h"
#include "err.h"
#include "decode_table.h"
#include "log.h"
#include "macro.h"
#include "mytypedef.h"
#include "statistics.h"
#include "strproc.h"
#include "urtl_asm.h"
#include "verilog.h"

#define MAX_ERROR_MSG 0x1000


// --==============================================-- Main
s08 main(int argc, char *argv[])
{
  s08 retval = 0;
  char * macro_file_name;
  char * asm_file_name;
  char base_filename[256] = {0};
  u08 *s_rec_mem = NULL;
  u08 append_log = 0;
  ctrl_vec_ctx_t ctrl_vec_ctx;
  macro_ctx_t macro_ctx;
  decode_table_ctx_t *jt_ctx = NULL;
  int c;

  if ( argc != 2 ) /* argc should be 2 for correct execution */
  while ((c = getopt(argc, argv, "hld:c:a:")) != -1)
  {
    switch (c)
    {
    case 'h':
      printf("usage: %s -c <macro file name> -a <assembly file name> -d <log level>\n", argv[0]);
      break;
    case 'a':
      asm_file_name = optarg;
      break;
    case 'c':
      macro_file_name = optarg;
      break;
    case 'd':
      log_level = (u08)atoi(optarg);
      if(log_level > 2) log_level = 2;
      break;
    case 'l':
      append_log = 1;
      break;
    case '?':
      if(optopt == 'c')
      {
        fprintf(stderr, "Required file name missing (%s -c <input file name>).\n", argv[0]);
      }
      else if(optopt == 'd')
      {
        fprintf(stderr, "Required debug log level missing (%s -d <log level>).\n", argv[0]);
      }
      else if(isprint (optopt))
      {
        fprintf(stderr, "Unknown option `-%c'.\n", optopt);
      }
      else
      {
        fprintf(stderr,
                 "Unknown option character `\\x%x'.\n",
                 optopt);
      }
      errno = -1;
      goto done;
    default:
      abort();
    }
  }

  // If no options were given, exit.
  if((optind == 1 && argc >= 1 ))
  {
    printf("usage: %s -c <macro file name> -a <assembly file name> -o <output verilog file name> [-d <log level>] (to append log, use -l)\n", argv[0]);
    exit(1);
  }


  // TODO: Needs more checking.
  strcpy(base_filename, asm_file_name);

  if((retval = chop_string(base_filename, '.')) != ERR_OK)
  {
    printf("main.c: Could not chop string at .\n");
    goto done;
  }



  if(!append_log) clear_log(log_level);

  // Initalize data structure
  init_ctrl_vec_ctx(&ctrl_vec_ctx);
  init_macro_ctx(&ctrl_vec_ctx, &macro_ctx);
  init_assembler(&macro_ctx);

  // This is first-pass. Load the EQUs from labels in the asm file.
  // These will be used later whenever we see a branch addr control
  // vector.
  if((errno = load_labels_to_context_from_asm_file(&ctrl_vec_ctx, asm_file_name)) != ERR_OK)
  {
    printf("Could not load or add label equs.\n");
    goto done;
  }

  if((errno = build_ctrl_vec_list(&ctrl_vec_ctx, macro_file_name)) != ERR_OK)
  {
    printf("Could not build control vector list.\n");
    goto done;
  }

  slice_up_the_word(&ctrl_vec_ctx);

  // This inits the context on the heap.
  if((retval = init_decode_table_ctx(&jt_ctx, &ctrl_vec_ctx)) != ERR_OK)
  {
    printf("Could not initialize decode table context.\n");
    goto done;
  }

  // Build the decode tables first.
  if((retval = build_decode_table(jt_ctx, asm_file_name)) != ERR_OK)
  {
    printf("Could not build decode table. (errno=%d)\n", retval);
    goto done;
  }

  if((retval = output_decode_tables(jt_ctx, base_filename, asm_file_name)) != ERR_OK)
  {
    printf("Could not output decode tables.\n");
    goto done;
  }

  // No more need for decode table context, free it all up.
  // This frees everything within the top level struct too.
  if((retval = free_decode_table_ctx(jt_ctx)) != ERR_OK)
  {
    printf("Could not free decode table context.\n");
    goto done;
  }

  if((errno = build_macro_list(&macro_ctx, macro_file_name)) != ERR_OK)
  {
    printf("Could not build macro list.\n");
    goto done;
  }

//  print_ctrl_vec_list(&ctrl_vec_ctx);
//  print_macro_list(&macro_ctx);

  // Initialize dumper
  if((errno = init_verilog_dump(&macro_ctx, base_filename, asm_file_name)) != ERR_OK)
  {
    printf("Could not initialize dumper.\n");
    goto done;
  }

  if((errno = dump_verilog_header(&ctrl_vec_ctx)) != ERR_OK)
  {
    printf("Could not dump verilog header.\n");
    goto done;
  }

  // Assemble. Pass in verilog dump function for individual ctrl_vec and EQUs.
  if((errno = assemble(&macro_ctx, asm_file_name, dump_verilog_ctrl_vec)) != ERR_OK)
  {
    printf("Could not assemble!\n");
    goto done;
  }

  if((errno = dump_verilog_footer(&ctrl_vec_ctx)) != ERR_OK)
  {
    printf("Could not dump verilog footer.\n");
    goto done;
  }

  run_statistics("urtl_statistics.log", &ctrl_vec_ctx, s_rec_mem);

  //print_ctrl_vec_list(&ctrl_vec_ctx);
  print_ctrl_vec_list_equ_sel(&ctrl_vec_ctx);

done:

  if(s_rec_mem) free(s_rec_mem);
  free_ctrl_vec_ctx(&ctrl_vec_ctx);
  free_macro_ctx(&macro_ctx);
  uninit_verilog_dump();

  return errno;
}
// --==============================================--



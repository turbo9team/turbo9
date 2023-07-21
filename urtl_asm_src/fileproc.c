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
// Description: File processing library.
//
//////////////////////////////////////////////////////////////////////////////
// History:
// 07.14.2023 - Kevin Phillipson
//   File header added
//
//////////////////////////////////////////////////////////////////////////////
// [TURBO9_HEADER_END]
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "ctrl_vec.h"
#include "err.h"
#include "mathlib.h"
#include "mytypedef.h"
#include "strproc.h"

// --==============================================--
// load_s_records()
//
// Loads contents of file_name into newly allocated
// memory. This function allocates memory on heap,
// so it is up to the caller to free this block of
// memory.
//
// Function will return the memory bit-width.
// Negative value indicates error condition.
//
s32 load_s_records(char *file_name, ctrl_vec_ctx_t *ctx, u08 **memory)
{
  FILE *fp;
  u08 s_rec[MAX_SREC_LEN];
  s32 ret_val = 0;
  s32 bit_width;
  int i = 0;
  int s_rec_offset;
  long file_size;
  u08 *mem;
  ctrl_vec_t *cv_list;
  u16 list_len;

  if(!ctx)
  {
    printf("load_s_records: context pointer is null\n");
    ret_val = ERR_NULL_PTR;
    goto end;
  }

  if(!ctx->list)
  {
    printf("load_s_records: list pointer inside context is null\n");
    ret_val = ERR_NULL_PTR;
    goto end;
  }

  cv_list = ctx->list;
  list_len = ctx->total_ctrl_vec;

  if(!file_name)
  {
    printf("load_s_records: filename parameter is null\n");
    ret_val = -1;
    goto end;
  }

  // Calculate the bit width here.
  bit_width = rnd_up(cv_list[0].msb + 1, 8);
  if(!bit_width)
  {
    printf("load_s_records: bit width cannot be 0.\n");
    ret_val = -1;
    goto end;
  }
  printf("load_s_records: got a bit width of %ld\n", bit_width);

  // Function returns bit width.
  ret_val = bit_width;

  fp = fopen(file_name, "r");
  if(fp)
  {
    if(fseek(fp, 0, SEEK_END) != 0)
    {
      printf("load_s_records: Cannot seek end of file.\n");
      ret_val = -1;
      goto end;
    }

    file_size = ftell(fp);
    rewind(fp);
    if(file_size > MAX_SREC_DEPTH * MAX_SREC_LEN)
    {
      printf("load_s_records: File contains more records than MAX_SREC_LEN.\n");
      ret_val = -1;
      goto end;
    }

    *memory = (u08*) malloc(MAX_SREC_DEPTH * bit_width/8);
    mem = *memory;
    if(!mem)
    {
      printf("Memory allocation failed.");
      ret_val = -1;
      goto end;
    }

    memset(mem, 0, MAX_SREC_DEPTH * bit_width/8);

    // Read lines in until EOF   
    while(fscanf(fp, "%s", s_rec) != EOF)
    {
      // If the current line matches the S-record signature...
      if(strncmp(s_rec, "S2140", 5) == 0)
      {
        u32 address; // address from string.
        size_t s_rec_len;
        u16 mpw_len_in_bytes;
        u16 mpw_len_in_nibbles;
        u16 mpw_srec_offset;
        u16 mem_pos;
        u16 srec_pos;

        // Get the address to know where in the memory block to lay out
        // each row of data into the memory block.
        address = ((hex2num(s_rec[4+0]) << 16) |
                   (hex2num(s_rec[4+1]) << 12) |
                   (hex2num(s_rec[4+2]) <<  8) |
                   (hex2num(s_rec[4+3]) <<  4) |
                    hex2num(s_rec[4+4]));

        // Find the number of string nibbles to convert to binary memory.
        s_rec_len          = strlen(s_rec); // total length of current s-record.
        mpw_len_in_bytes   = bit_width/8;   // microprogram word length as byte count.
        mpw_len_in_nibbles = bit_width/4;   // microprogram word length as nibble count.
        mpw_srec_offset    = s_rec_len - mpw_len_in_nibbles - 2; // points to beginning of microprogrammed word in str, minus checksum.

        // Reading s-record string left to right, but
        // storing the data big endian into memory.
        for(i = 0; i < mpw_len_in_bytes; i++)
        {
          mem_pos  = (address * mpw_len_in_bytes) + i; // Destination pointer in binary memory expressed in bytes.
          srec_pos = mpw_srec_offset + (i*2);
          mem[mem_pos] = (hex2num(s_rec[srec_pos]) << 4) | (hex2num(s_rec[srec_pos+1]));
        }
      }
    }
    fclose(fp);
  }

end:
  return ret_val;
}



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
// Description: Inputs a sym file containing EQUs and outputs a verilog
// header file.
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
#include <stdlib.h>
#include <unistd.h>

typedef unsigned char u08;
typedef signed char s08;
typedef unsigned short u16;
typedef signed short s16;
typedef unsigned long u32;
typedef signed long s32;

union LONG
{
  s32 sl;
  u32 ul;
  s16 si[2];
  u16 ui[2];
  s08 sb[4];
  u08 ub[4];
};

union WORD
{
  s16 si;
  u16 ui;
  s08 sb[2];
  u08 ub[2];
};

#define MAX_CTRL_VEC   256
#define MAX_PTR_VEC    256
#define MAX_EQU        256
#define MAX_MACROS     256
#define MAX_SREC_LEN   64
#define MAX_SREC_DEPTH 512
#define MAXLINE        256

#define IN
#define OUT

#define LF  0x0A

enum error_codes {
  ERR_ALREADY_ALLOCATED = -8,
  ERR_INVALID_STATE = -7,
  ERR_INVALID_FIELD = -6,
  ERR_FILE_IO = -5,
  ERR_DUPLICATE_ENTRY = -4,
  ERR_NOT_FOUND = -3,
  ERR_MISC = -2,
  ERR_NULL_PTR = -1,
  ERR_OK = 0
};

// --==============================================--
// strip_string
//
// This function will take a string and strip out all characters that are
// not in the large if statement condition below. Repeated invalid
// characters will be consolidated into a single space character.
//
// line - the string to be operated ron.
// clip_leading_whitespace - remove leading whitespace
// retval - returns 0 if successful. Negative value is return if error
//
s16 strip_string(char *line, u08 clip_leading_whitespace)
{
  s16 retval = ERR_OK;

  u16 i = 0;
  u16 j = 0;
  u08 flag = clip_leading_whitespace;

  if (!line)
  {
    retval = ERR_NULL_PTR;
    printf( "Error: null pointer passed to strip_string function\n");
    goto done;
  }

  while ((line[j] != '\0') && (line[j] != LF)) // While not end of string
  {
    if
    (
      ((line[j] >= 'A') && (line[j] <= 'Z')) ||
      ((line[j] >= 'a') && (line[j] <= 'z')) ||
      ((line[j] >= '0') && (line[j] <= '9')) ||
      (line[j] == '.') ||
      (line[j] == ']') ||
      (line[j] == '[') ||
      (line[j] == '/') ||
      (line[j] == '_')
    )
    {
      line[i] = line[j]; // Valid character. Copy back into string
      i++;
      flag = 0;
    }
    else if(line[j] == ';')
    {
      line[i] = '\0';
      retval = j+2; // Point to beginning of comment as return val.
      goto done;
    }
    else
    {
      if (flag == 0)
      {
        line[i] = ' '; // First invalid character. Insert a space
        i++;
        flag = 1;
      }
    }
    j++;
  }

  line[i] = '\0';

done:
  return retval;
}

// --==============================================--
// Get Field Function
//
// This function will take a string that is made up of fields seperated
// by space characters and return the desired field.
//
// line - input string with space delimiters
// field - output string
// field_num - specifies field number to return
// field_spaces - specifies how many spaces to include in field
// ret_val - the starting position of the desired field. 
//           returns an ERR_* type if error
//
//  TODO: Needs reevaluation to use strtok() and not take in a stack variable to store fields.
//        *field output should not be a char array, but just point to the tokenized field from
//        strtok().
s16 get_field(char *line, char *field, u08 field_num, u08 field_spaces)
{
  s16 ret_val = ERR_NOT_FOUND;
  u16 i = 0;
  u16 j = 0;

  if (!line)
  {
    ret_val = ERR_NULL_PTR;
    printf( "Error: null pointer passed to get_field function\n");
    goto done;
  }

  while ((line[i] != '\0') && (j != field_num)) // While not end of string
  {
    if (line[i] == ' ') j++;
    i++;
  }
  if (j != field_num) // Field not found
  {
    ret_val = ERR_NOT_FOUND;
    field[0] = '\0';
    goto done;
  }
  else
  {
    ret_val = i; // return position
  }

  j = 0;
  while ((line[i] != '\0') && !((line[i] == ' ') && (field_spaces == 0))) // While not end of string
  {
    field[j] = line[i];
    if (line[i] == ' ')
      field_spaces--;
    j++;
    i++;
  }
  field[j] = '\0';

  if (j == 0) // Field has zero length
  {
    ret_val = ERR_NOT_FOUND;
    goto done;
  }

done:
  return ret_val;
}

void make_str_pad(u08 str_len, u08 width, char pad_char, char * pad)
{
  u08 i;

  if ( width <= str_len )
  {
    pad[0] = pad_char;
    pad[1] = '\0';
  }
  else
  {
    for (i=0; i<(width-str_len); i++)
    {
      pad[i] = pad_char;
    }
    pad[(width-str_len)] = '\0';
  }
}

int main(int argc, char ** argv)
{
  int retval = 0;
  FILE *f_in, *f_out;
  char *in_name;
  char *out_name;
  char str[MAXLINE] = {0};
  char field0[MAXLINE] = {0};
  char field1[MAXLINE] = {0};
  char pad[32] = {0};
  int index = 0;
  int opt;
      
  // put ':' in the starting of the
  // string so that program can 
  //distinguish between '?' and ':' 
  while((opt = getopt(argc, argv, "io?")) != -1) 
  { 
    switch(opt) 
    { 
      case 'i': 
        in_name = argv[optind];
        printf("input filename %s\n", in_name); 
        break; 
      case 'o': 
        out_name = argv[optind];
        printf("output filename %s\n", out_name); 
        break; 
      case '?': 
      default:
        printf("%s -i <input filename> -o <output filename>\n", argv[0]);
        break; 
    } 
    optind++;
  } 
    
  if((f_in = fopen(in_name, "r")) == NULL)
  {
    perror("Input filename failed\n");
    goto done;
  }

  if((f_out = fopen(out_name, "w")) == NULL)
  {
    perror("Output filename failed\n");
    goto done;
  }

  // Write header data
  fprintf(f_out, "////////////////////////////////////////////////////////////////////////////////\n");
  fprintf(f_out, "//                                                                            //\n");
  fprintf(f_out, "//      Definition file                                                       //\n");
  fprintf(f_out, "//                                                                            //\n");
  fprintf(f_out, "////////////////////////////////////////////////////////////////////////////////\n\n");

  while(fgets(str, MAXLINE, f_in) != NULL)
  {
    //printf("Processing string: %s", str);
    if(strip_string(str, 0))
    {
      fprintf(stderr, "Could not properly reformat line %d\n", index);
      goto done;
    }
    if(get_field(str, field1, 2, 0) < 0)
    {
      fprintf(stderr, "Failed getting field 2\n");
      goto done;
    }
    if(get_field(str, field0, 0, 0) < 0)
    {
      fprintf(stderr, "Failed getting field 0\n");
      goto done;
    }

    make_str_pad(strlen(field0), 32, ' ', pad);
    fprintf(f_out, "`define asm_%s%s16'h%s\n", field0, pad, field1);
    index++;
  }

done:
  if(f_in) fclose(f_in);
  if(f_out) fclose(f_out);
  return retval;
}

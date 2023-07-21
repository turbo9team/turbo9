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
// Description: String processing library.
//
//////////////////////////////////////////////////////////////////////////////
// History:
// 07.14.2023 - Kevin Phillipson
//   File header added
//
//////////////////////////////////////////////////////////////////////////////
// [TURBO9_HEADER_END]
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "err.h"
#include "log.h"
#include "mytypedef.h"
#include "statistics.h"

#define LF  0x0A


char * convert_to_upper_case(char *str)
{
  char *retval = NULL;
  char *p = NULL;
  u16 len = 0;

  if(!str)
  {
    goto done;
  }

  len = strlen(str);

  if(len)
  {
    retval = malloc(len * sizeof(char)+1);
    if(retval)
    {
      memset(retval, '\0', len * sizeof(char)+1);
      p = retval;

      while(*str != '\0')
        *p++ = toupper((unsigned char)*str++);
    }
  }

done:
  return retval;
}

// --==============================================--
// is_comment
//
// If the string passed in has a ; at the beginning of
// the line, return 1 (it is a comment). If it doesn't
// and no longer meets the qualifications as a full line
// comment, returns 0;
s16 is_comment(char *line)
{
  char *a;
  s16 retval = 0;

  if(!line)
  {
    goto done;
  }

  a = line;
  while(*a != '\0' && *a != '\n')
  {
    if(*a == ' ' || *a == '\t')
    {
      a++;
      continue;
    }
    else if(*a == ';')
    {
      retval = 1;
      goto done;
    }
    else
    {
      goto done;
    }
  }

done:
  return retval;
}

// --==============================================--
// is_empty_line
//
// If the string passed in has no characters in it other than
// spaces, tabs, or just a single newline, it is empty.
//
s16 is_empty_line(char *line)
{
  char *a;
  s16 retval = 1; // Assume empty

  if(!line)
  {
    goto done;
  }

  a = line;
  while(*a != '\0' && *a != '\n')
  {
    if(*a != ' ' && *a != '\t')
    {
      retval = 0; // It's not empty
      goto done;
    }
    else
    {
      a++;
      continue;
    }
  }

done:
  return retval;
}

// --==============================================--
// strspc
//
// Strip the leading spaces out of a string.
// This function is destructive and will modify the
// string passed into the function.
//
s16 strmspc(char *line)
{
  char *a, *b;
  u08 find_spaces = 1;
  s16 retval = ERR_OK;

  if(!line)
  {
    retval = ERR_NULL_PTR;
    goto done;
  }

  a = line;
  b = line;

  while(*a != '\0' && *a != '\n')
  {
    if(find_spaces && (*a == ' ' || *a == '\t'))
    {
      a++;
    }
    else
    {
      find_spaces = 0;
      *b++ = *a++;
    }
  }

done:
  return retval;
}

char * find_next_nonblank_char(char *str)
{
  char *retval = NULL;
  char *a;

  if(!str)
  {
    retval = NULL;
    goto done;
  }

  a = str;
  while(*a != '\0' && *a != '\n' && *a != ';')
  {
    if(*a == '\t' || *a == ' ')
    {
      a++;
    }
    else
    {
      retval = a;
      goto done;
    }
  }

done:
  return retval;
}

// --==============================================--
// chop the string at a given character
s16 chop_string(char *line, char chop)
{
  s16 retval = ERR_OK;

  u16 i = 0;
  u16 j = 0;
  
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
      (line[j] == ']') ||
      (line[j] == '[') ||
      (line[j] == '/') ||
      (line[j] == '$') ||
      (line[j] == '_') 
    )
    {
      line[i] = line[j]; // Valid character. Copy back into string
      i++;
    } 
    else if(line[j] == chop)
    {
      line[i] = '\0';
      goto done;
    }
    j++;
  }

  line[i] = '\0';

done:
  return retval;
}


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
      (line[j] == '$') ||
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
// strip_string_s
// Performs the same operation as strip_string, but
// is not destructive to the input string.
//
// The out_str must be freed when not needed any 
// longer.
s16 strip_string_s(char *in_str, char **out_str, u08 clip_leading_whitespace)
{
  s16 retval = ERR_OK;
  size_t str_len;
  char *new_str;

  // Get the size of the original string.
  str_len = strlen(in_str);
  if(str_len > 1)
  {
    // Allocate at least as much memory. We will be
    // stripping the string, so the result will be smaller.
    new_str = malloc(str_len * sizeof(char));
    if(new_str)
    {
      strcpy(new_str, in_str);
      retval = strip_string(new_str, clip_leading_whitespace);
      if(retval)
      {
        goto done;
      }
      *out_str = new_str;
    }
    else
    {
      retval = ERR_NULL_PTR;
      goto done;
    }
  }

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

// --==============================================--
s16 sub_str_by_field(char *in_str, char sep_ch, char *out_str, u08 start_field, u08 end_field)
{
  s16 ret_val = ERR_NOT_FOUND;
  u08 field = 0;
  u16 i = 0, j = 0, spc_cnt = 0;
  u08 state = 0;
  u08 copy = 0;

  if(in_str == NULL)
  {
    ret_val = ERR_NULL_PTR;
    printf("Error: null pointer passed to sub_str_by_field function.\n");
    goto done;
  }

  while(in_str[i] != '\0' && field < end_field+1)
  {
    switch(state)
    {
      case 0: // look for text
      {
        if(in_str[i] == ' ') // Any further spaces,
          copy = 0;          // don't copy if we see spaces in this state.
        else if(in_str[i] != ' ')
        {
          field++;
          if(field == start_field)
            copy = 1;
          else if(field == end_field+1)
            copy = 0;
          state = 1; // state to find spaces.
        }
      }
      break;
      case 1: // look for spaces
      {
        if(in_str[i] == ' ')
          state = 0; // If we see a space, eat it and go back to look for characters.
      }
      break;
    }

    if(copy == 1 && in_str[i] != '\n')
      out_str[j++] = in_str[i];

    i++;
  }

  out_str[j] = '\0';

done:
  return ret_val;
}

// --==============================================--
u08 hex2num(char hex_digit)
{   
  u08 num;

  if ((hex_digit >= 0x30) && (hex_digit <= 0x39)) // 0 to 9
    num = hex_digit - 0x30;
  else if ((hex_digit >= 0x41) && (hex_digit <= 0x46)) // A to F
    num = hex_digit - 0x37;
  else if ((hex_digit >= 0x61) && (hex_digit <= 0x66)) // a to f
    num = hex_digit - 0x57;
  else
    num = 0xff;
    
  return num;
}
// --==============================================--
//
// --==============================================--
u32 hex_str2num(char * hex_str)
{
  u08 i = 0;
  u08 len = strlen(hex_str);
  u32 num = 0;

  for (i=0; i<len; i++)
  {
    num += hex2num(hex_str[i])<<(4*(len-i-1));
  }

  return num;
}
// --==============================================--

u32 str2num(char * str)
{
  if(str)
  { 
    if(strlen(str) > 1)
    {
      if(*str == '$')
        return hex_str2num(&str[1]);
      else
        return atoi(str);
    }
  }
}

// --==============================================--
char num2hex(u08 num)
{
  char hex_digit;

  if (num < 0x0A)
    hex_digit = num + 0x30;
  else
    hex_digit = num + 0x37;

  return hex_digit;
}
// --==============================================--


// --==============================================--
void num2bin_str(u16 num, u08 width, char * bin_str)
{
  u08 i;

  for (i=0; i<width; i++)
  {
    bin_str[i] = num2hex((num >>(width-1-i)) & 0x01);
  }
  bin_str[width] = '\0';
}
// --==============================================--


// --==============================================--
void num2hex_str(u16 num, u08 width, char * hex_str)
{
  u08 hex_str_len;
  u08 i;

  hex_str_len = rnd_up(width, 4)/4;

  for (i=0; i<hex_str_len; i++)
  {
    hex_str[i] = num2hex((num >>((hex_str_len-1-i)*4)) & 0x0F);
  }
  hex_str[hex_str_len] = '\0';
}
// --==============================================--


// --==============================================--
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
// --==============================================--


// --==============================================--
// is_valid
//
// returns TRUE if a valid character is input, FALSE
// if not.
u08 is_valid(char c)
{
  return (c >= 0x61 && c <= 0x7A) || (c >= 0x41 && c <= 0x5A) || (c >= 0x30 && c <= 0x39) || c == 0x5F;
}
// --==============================================--


// --==============================================--
// is_number
//
// returns TRUE if a valid character is input, FALSE
// if not.
u08 is_number(char c)
{
  return (c >= 0x30 && c <= 0x39);
}

// --==============================================--
// --==============================================--
// get_label
//
// Returns a length of the label name if present,
// or if no label is present, 0 is returned.
//
s16 get_label(char *line)
{
  size_t str_len;
  s16 label_len = 0;

  if(!line)
    goto done;

  str_len = strlen(line);
  if(str_len)
  {
    while(is_valid(line[label_len++]));
  }

done:
  return label_len-1;
}
// --==============================================--

// --==============================================--
// check_field
//
// Returns ERR_OK if the token given by tok is found on the given line
// in the given field number. If the string token is not found, then
// this function will return ERR_NOT_FOUND.
s16 check_field(char IN *line, char IN *tok, u08 field_num, u08 field_spaces)
{
  size_t line_len, tok_len;
  s16 retval = ERR_NOT_FOUND;
  char * field;

  if(!line || !tok)
  {
    retval = ERR_NULL_PTR;
    goto done;
  }

  line_len = strlen(line);
  tok_len  = strlen(tok);

  // See that the token length is less than the length of the 
  // whole line, and that the token is larger than 0.
  if((tok_len <= line_len) && (tok_len > 0))
  {
    field = malloc(line_len * sizeof(char));
    if(field)
    {
      get_field(line, field, field_num, field_spaces);
      if(strcmp(field, tok) == 0)
      {
        retval = ERR_OK;
      }
      free(field);
    }
  }
  else
    retval = ERR_MISC;

done:
  return retval;
}


// --==============================================--
// get_org
//
// Get the ORG value if ORG is found.
s16 get_org_val(char IN *line, u32 *val)
{
  size_t len;
  s16 retval = ERR_NOT_FOUND;
  char * field;

  if(!line || !val)
  {
    retval = ERR_NULL_PTR;
    goto done;
  }

  if(check_field(line, "ORG", 1, 0) == ERR_OK)
  {
    WRITE_LOG(LOG_HIGH, "Found ORG\n");
    len = strlen(line);
    field = malloc(len * sizeof(char));
    if(field)
    {
      get_field(line, field, 2, 0);
      *val = str2num(field);
      retval = ERR_OK;
      free(field);
    }
  }

done:
  return retval;
}


// --==============================================--
// get_field_ex
//
// Returns ERR_OK if the token given by tok is found on the given line
// in the given field number. If the string token is not found, then
// this function will return ERR_NOT_FOUND.
s16 get_field_ex(char IN *line, char OUT **field, u08 field_num, u08 field_spaces)
{
  size_t line_len;
  s16 retval = ERR_NOT_FOUND;
  char * tmp;

  if(!line || !field)
  {
    retval = ERR_NULL_PTR;
    goto done;
  }

  line_len = strlen(line);

  // See that the token length is less than the length of the 
  // whole line, and that the token is larger than 0.
  if(line_len > 0)
  {
    tmp = malloc(line_len * sizeof(char));
    if(tmp)
    {
      memset(tmp, 0, line_len * sizeof(char));
      retval = get_field(line, tmp, field_num, field_spaces);
      *field = tmp;
    }
  }
  else
    retval = ERR_MISC;

done:
  return retval;
}



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
// Engineer: Kevin Phillipson
// Description: Library for vbcc compiler
//
//////////////////////////////////////////////////////////////////////////////
// History:
// 07.14.2023 - Kevin Phillipson
//   File header added
//
//////////////////////////////////////////////////////////////////////////////
// [TURBO9_HEADER_END]

#include "lib.h"

//////////////////////////////////////// Print String
//
void acia_print_str(char *string_ptr)
{

  while (*string_ptr != NULL)
  {
    acia_put_char(*string_ptr);
    string_ptr++;
  }

}


//////////////////////////////////////// Put 16-bit Hex 
//
void acia_print_hex_16bit(u16 data)
{
  union WORD tmp;
  tmp.ui = data; 

  acia_print_hex_byte(tmp.ub[0]); // big endian
  acia_print_hex_byte(tmp.ub[1]);
}


//////////////////////////////////////// Put 8-bit Hex 
//
void acia_print_hex_byte(u08 data)
{
  acia_put_hex_nibble((data>>4)&0x0F);
  acia_put_hex_nibble((data)&0x0F);
}


//////////////////////////////////////// Put 4-bit Hex 
//
void acia_put_hex_nibble(u08 data)
{
  if (data > 9)
    data += 0x07;

  data += 0x30;

  acia_put_char(data);
}


//////////////////////////////////////// Print signed decimal 
//
void acia_print_signed_long(s32 snum)
{

  union LONG tmp;

  tmp.sl = snum;

  if (tmp.ub[0] & 0x80) // Negative? (big endian)
  {
    // This method accounts for -2147483648 case.
    // casting can cause issues depending on compiler
    acia_put_char('-');
    tmp.ul = ~tmp.ul;
    tmp.ul++;
  }

  acia_print_unsigned_long(tmp.ul);
}



////////////////////////////////////////  Print unsigned decimal
//
void acia_print_unsigned_long(u32 unum)
{

  u32 divisor = 1000000000;
  u08 digit;
  u08 flag;

  flag = 0;
  for (divisor = 1000000000; divisor != 0; divisor=divisor/10)
  {
    digit = (u08)(unum / divisor);
    unum = unum % divisor;
    if ((digit != 0) || (divisor == 1))
    {
      flag = 1;
    }
    if (flag)
    {
      digit += 0x30;
      acia_put_char(digit);
    }
  }

}


/*
////////////////////////////////////////  Print unsigned decimal
//
void acia_print_unsigned_long(u32 unum)
{

  static u32 div_array[10] = {1, 10, 100, 1000, 10000, 100000, 1000000, 10000000, 100000000, 1000000000};
  u32 div;
  u08 digit;
  u08 flag;
  u08 idx;

  flag = 0;
  for (idx = 10; idx !=0; idx--)
  {
    digit = 0;
    div = 0;
    while ((unum > div) && ~((idx == 10) && (digit == 4)))
    {
      div = div + div_array[idx-1];
      digit++;
    }
    if ((unum < div)
    {
      div = div - div_array[idx-1];
      digit--;
    }
    unum = unum - div;
    if ((idx == 1) || (digit != 0))
    {
      flag = 1;
    }
    if (flag)
    {
      digit += 0x30;
      acia_put_char(digit);
    }
  }

}
*/

void setup(void)
{
}

void teardown(void)
{
}



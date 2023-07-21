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
// Description: This program calculates the size of an Intel Hex file
//
//////////////////////////////////////////////////////////////////////////////
// History:
// 07.14.2023 - Kevin Phillipson
//   File header added
//
//////////////////////////////////////////////////////////////////////////////
// [TURBO9_HEADER_END]


#include <stdio.h>


////////////////////////////////////// Type Defs
//
typedef unsigned char u08;
typedef signed char s08;
typedef unsigned short u16;
typedef signed short s16;
typedef unsigned long u32;
typedef signed long s32;

u08 hex2bin(u08 hex_digit);
u08 gethex_byte(void);

int main(void)
{

  s16 read_buf;
  u08 byte;
  u32 byte_count = 0;
  u32 tmp_count;

  read_buf = getchar();
  while (read_buf != EOF)
  {
    byte = (u08)read_buf;

    if (byte == ':')
    {
      tmp_count = gethex_byte();  // Byte count
      gethex_byte();              // Address
      gethex_byte();              // Address
      if (gethex_byte() == 0x00)  // Data Record
      {
        byte_count += tmp_count;
      }
    }
    read_buf = getchar();
  }


  printf("\nIntel HEX file contains %lu bytes.\n\n", byte_count);

  return(0);

}

u08 gethex_byte(void)
{
  u08 nibble_hi;
  u08 nibble_lo;

  nibble_hi = hex2bin(getchar());
  nibble_lo = hex2bin(getchar());

  return (((nibble_hi<<4)&0xF0)|(nibble_lo));
}

u08 hex2bin(u08 hex_digit)
{
  u08 nibble;

  if ((hex_digit >= 0x30) && (hex_digit <= 0x39)) // 0 to 9
  {
    nibble = hex_digit - 0x30;
  }
  else if ((hex_digit >= 0x41) && (hex_digit <= 0x46)) // A to F
  {
    nibble = hex_digit - 0x37;
  }
  else if ((hex_digit >= 0x61) && (hex_digit <= 0x66)) // a to f
  {
    nibble = hex_digit - 0x57;
  }
  else
  {
    nibble = 0xFF;
  }
    
  return nibble;
}


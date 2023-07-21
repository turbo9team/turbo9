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
// Description: Library for GCC6809
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


//////////////////////////////////////// Put Char 
//
/*
void acia_put_char(char data)
{

  if (SIM_BOOT_DETECT == 0)
  {
    while (!(ACIA_STATUS & (char)0x10)); // wait for TX buffer empty
    ACIA_DATA = data;
  }
  else
  {
    SIM_BOOT_ACIA_OUT = data;
  }
}
*/

__asm__
(
  "   .area .text                 \n"
  "   .globl  _acia_put_char      \n"
  "_acia_put_char                 \n"
  "   lda   #3                    \n"
  "   swi                         \n"
  "   rts                         \n"
);



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
  {
    data += 0x07;
  }

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


//////////////////////////////////////// 
//
void setup(void)
{
}

//////////////////////////////////////// 
//
void teardown(void)
{
}


//////////////////////////////////////// 
//
void abort(void)
{
  acia_print_str("\nNaN\n");
}



/*
int strcmp(const char *s1, const char *s2)
{
    // check if s1 and s2 vectors are equal
    while(*s1 != '\0' && *s1 == *s2)
    {
        s1++;
        s2++;
    }

    // return the difference of the last char on the string
    return (*(unsigned char *) s1) - (*(unsigned char *) s2);
}
*/


__asm__
(
  " .area .text               \n"
  " .globl  _strcmp           \n"
  "_strcmp:                   \n"
  "  pshs  u                  \n"
  "  ldu   4,s                \n"
  "strcmp_loop:               \n"
  "  ldb   ,x+                \n"
  "  beq   strcmp_done_cond1  \n"
  "  subb  ,u+                \n"
  "  bne   strcmp_done        \n"
  "  ;                        \n"
  "  ldb   ,x+                \n"
  "  beq   strcmp_done_cond1  \n"
  "  subb  ,u+                \n"
  "  bne   strcmp_done        \n"
  "  ;                        \n"
  "  ldb   ,x+                \n"
  "  beq   strcmp_done_cond1  \n"
  "  subb  ,u+                \n"
  "  bne   strcmp_done        \n"
  "  ;                        \n"
  "  ldb   ,x+                \n"
  "  beq   strcmp_done_cond1  \n"
  "  subb  ,u+                \n"
  "  bne   strcmp_done        \n"
  "  ;                        \n"
  "  ldb   ,x+                \n"
  "  beq   strcmp_done_cond1  \n"
  "  subb  ,u+                \n"
  "  bne   strcmp_done        \n"
  "  ;                        \n"
  "  ldb   ,x+                \n"
  "  beq   strcmp_done_cond1  \n"
  "  subb  ,u+                \n"
  "  bne   strcmp_done        \n"
  "  ;                        \n"
  "  ldb   ,x+                \n"
  "  beq   strcmp_done_cond1  \n"
  "  subb  ,u+                \n"
  "  bne   strcmp_done        \n"
  "  ;                        \n"
  "  ldb   ,x+                \n"
  "  beq   strcmp_done_cond1  \n"
  "  subb  ,u+                \n"
  "  beq   strcmp_loop        \n"
  "strcmp_done:               \n"
  "  sex                      \n"
  "  tfr   d,x                \n"
  "  puls  u,pc               \n"
  "strcmp_done_cond1:         \n"
  "  subb  ,u                 \n"
  "  sex                      \n"
  "  tfr   d,x                \n"
  "  puls  u,pc               \n"
);   

/* GCC version:
  .globl  _strcmp
_strcmp:
  pshs  y,u
  leas  -3,s
  leau  ,s
  ldy  9,u
  ldb  ,x
  stb  ,u
  beq  L81
  ldb  ,y
  stb  2,u
  ldb  ,u
  cmpb  2,u  ;cmpqi:
  bne  L80
  leax  1,x
  bra  L78
L77:
  leay  1,y
  ldb  ,y
  stb  2,u
  ldb  ,u
  cmpb  2,u  ;cmpqi:
  bne  L80
L78:
  ldb  ,x+
  stb  ,u
  bne  L77
  ldb  1,y
  stb  2,u
  ldd  #0
  std  ,u
L75:
  ldb  2,u
  clra    ;zero_extendqihi: R:b -> R:d
  tfr  d,x
  ldd  ,u
  pshs  x  ;subhi: R:d -= R:x
  subd  ,s++
  tfr  d,x
  leas  3,s
  puls  y,u,pc
L80:
  clra    ;zero_extendqihi: R:b -> R:d
  std  ,u
  bra  L75
L81:
  ldb  ,y
  stb  2,u
  ldd  #0
  std  ,u
  bra  L75
*/






/*
void *memcpy(char *d, const char *s, unsigned l)
{
    while (l--) *d++ = *s++;
}
*/

  // x   = *d
  // 6,s = *s
  // 8,s = l (9,s = l[7:0])

__asm__
(
  " .area .text                       \n"
  " .globl  _memcpy                   \n"
  "_memcpy:                           \n"
  "  pshs   y,u                       \n"
  "  ldu    6,s ; *s (source)         \n"
  "  ldd    8,s ; l  (num of bytes)   \n"
  "  tfr    d,y                       \n" 
  "  lsrb       ; odd num of bytes?   \n"
  "  bcc    memcopy_16bit             \n"
  "memcopy_8bit                       \n"
  "  lda    ,u+                       \n"
  "  sta    ,x+                       \n"
  "  leay   -1,y                      \n"
  "  beq    memcopy_done              \n"
  "memcopy_16bit                      \n"
  "  ldd    ,u++                      \n"
  "  std    ,x++                      \n"
  "  leay   -2,y                      \n"
  "  beq    memcopy_done              \n"
  "  ;                                \n"
  "  ldd    ,u++                      \n"
  "  std    ,x++                      \n"
  "  leay   -2,y                      \n"
  "  beq    memcopy_done              \n"
  "  ;                                \n"
  "  ldd    ,u++                      \n"
  "  std    ,x++                      \n"
  "  leay   -2,y                      \n"
  "  beq    memcopy_done              \n"
  "  ;                                \n"
  "  ldd    ,u++                      \n"
  "  std    ,x++                      \n"
  "  leay   -2,y                      \n"
  "  beq    memcopy_done              \n"
  "  ;                                \n"
  "  ldd    ,u++                      \n"
  "  std    ,x++                      \n"
  "  leay   -2,y                      \n"
  "  beq    memcopy_done              \n"
  "  ;                                \n"
  "  ldd    ,u++                      \n"
  "  std    ,x++                      \n"
  "  leay   -2,y                      \n"
  "  beq    memcopy_done              \n"
  "  ;                                \n"
  "  ldd    ,u++                      \n"
  "  std    ,x++                      \n"
  "  leay   -2,y                      \n"
  "  beq    memcopy_done              \n"
  "  ;                                \n"
  "  ldd    ,u++                      \n"
  "  std    ,x++                      \n"
  "  leay   -2,y                      \n"
  "  bne    memcopy_16bit             \n"
  "memcopy_done                       \n"
  "  puls   y,u,pc                    \n"
);


/* GCC version:
  .globl  _memcpy
_memcpy:
  pshs  y,u
  leau  ,s
  ldy  8,u
  beq  L71
  ldy  6,u
L70:
  ldb  ,y+
  stb  ,x+
  ldd  8,u
  addd  #-1
  std  8,u
  bne  L70
L71:
  puls  y,u,pc
*/


/*
// Avoid libc at all costs!
char* strcpy(char *dst0, const char * src0)
{
    char *s = dst0;

    // copy the source to the destination
    while(*dst0++ = *src0++);

    return s;
}
*/

/* GCC version:
  .globl  _strcpy
_strcpy:
  pshs  y,u
  leas  -2,s
  leau  ,s
  stx  ,u
  ldx  8,u
  ldy  ,u
L83:
  ldb  ,x+
  stb  ,y+
  bne  L83
  ldx  ,u
  leas  2,s
  puls  y,u,pc
*/


__asm__
(
  "   .area .text                 \n"
  "   .globl  _strcpy             \n"
  "_strcpy:                       \n"
  "   pshs  y,u                   \n"
  "   tfr   x,y                   \n"
  "   ldu  6,s                    \n"
  "strcpy_loop:                   \n"
  "   lda   ,u+                   \n"
  "   beq   strcpy_done_wr_8bit   \n"
  "   ldb   ,u+                   \n"
  "   beq   strcpy_done_wr_16bit  \n"
  "   std   ,y++                  \n"
  "   ;                           \n"
  "   lda   ,u+                   \n"
  "   beq   strcpy_done_wr_8bit   \n"
  "   ldb   ,u+                   \n"
  "   beq   strcpy_done_wr_16bit  \n"
  "   std   ,y++                  \n"
  "   ;                           \n"
  "   lda   ,u+                   \n"
  "   beq   strcpy_done_wr_8bit   \n"
  "   ldb   ,u+                   \n"
  "   beq   strcpy_done_wr_16bit  \n"
  "   std   ,y++                  \n"
  "   ;                           \n"
  "   lda   ,u+                   \n"
  "   beq   strcpy_done_wr_8bit   \n"
  "   ldb   ,u+                   \n"
  "   beq   strcpy_done_wr_16bit  \n"
  "   std   ,y++                  \n"
  "   ;                           \n"
  "   lda   ,u+                   \n"
  "   beq   strcpy_done_wr_8bit   \n"
  "   ldb   ,u+                   \n"
  "   beq   strcpy_done_wr_16bit  \n"
  "   std   ,y++                  \n"
  "   ;                           \n"
  "   lda   ,u+                   \n"
  "   beq   strcpy_done_wr_8bit   \n"
  "   ldb   ,u+                   \n"
  "   beq   strcpy_done_wr_16bit  \n"
  "   std   ,y++                  \n"
  "   ;                           \n"
  "   lda   ,u+                   \n"
  "   beq   strcpy_done_wr_8bit   \n"
  "   ldb   ,u+                   \n"
  "   beq   strcpy_done_wr_16bit  \n"
  "   std   ,y++                  \n"
  "   ;                           \n"
  "   lda   ,u+                   \n"
  "   beq   strcpy_done_wr_8bit   \n"
  "   ldb   ,u+                   \n"
  "   beq   strcpy_done_wr_16bit  \n"
  "   std   ,y++                  \n"
  "   bra   strcpy_loop           \n"
  "strcpy_done_wr_16bit:          \n"
  "   std   ,y                    \n"
  "   puls  y,u,pc                \n"
  "strcpy_done_wr_8bit:           \n"
  "   sta   ,y                    \n"
  "   puls  y,u,pc                \n"
);




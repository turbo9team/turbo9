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

#ifndef _TURBO9_LIB_
#define _TURBO9_LIB_


////////////////////////////////////// Type Defs
//
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


////////////////////////////////////// Defines & Macros
//

// I/O Space: FFEF - FF00
//
// FF08          CLK_CNT_CTRL[1:0] (read)  /  CLK_CNT_CTRL (write)
// FF04 : FF07   CLK_CNT[31:0]     (read)
// FF03          ACIA_STATUS       (read)
// FF02          ACIA_RX_DATA      (read)  /  ACIA_TX_DATA (write)
// FF01          GPI PORT          (read)
// FF00          GPO PORT          (read)  /  GPO_PORT    (write)
//
// Initialized RAM: FEFF - 0000


#define  CLK_CNT_CTRL   (*(volatile u08 *)0xFF08)
#define  CLK_CNT_L      (*(volatile u16 *)0xFF06)
#define  CLK_CNT_H      (*(volatile u16 *)0xFF04)
#define  CLK_CNT        (*(volatile u32 *)0xFF04)
#define  ACIA_STATUS    (*(volatile u08 *)0xFF03)
#define  ACIA_DATA      (*(volatile u08 *)0xFF02)
#define  GPI_PORT       (*(volatile u08 *)0xFF01)
#define  GPO_PORT       (*(volatile u08 *)0xFF00) 

#define  NULL         0x00

#define SECTION_START
//#define SECTION_START __section(.prog_start,"prog_start")
//__attribute__((section (".prog_start")))

#define COUNTER_VAR   \
  union LONG clk_cnt;

#define COUNTER_START   \
  CLK_CNT_CTRL = 0x00;  \
  CLK_CNT_CTRL = 0x01;

#define COUNTER_STOP      \
  CLK_CNT_CTRL = 0x02;    \
  clk_cnt.ui[0] = CLK_CNT_H; \
  clk_cnt.ui[1] = CLK_CNT_L; \

#define COUNTER_PRINT               \
  acia_print_str("Clock Count: ");  \
  acia_print_unsigned_long(clk_cnt.ul);     \
  acia_print_str(" (CPU clocks)\n");

#define SYSTEM_RESET        \
  __asm("  jmp [0xfffe]");



////////////////////////////////////// Function Declaration
//
extern void acia_print_str(char *string_ptr);
extern void acia_put_char(char data);
extern void acia_print_hex_16bit(u16 data);
extern void acia_print_hex_byte(u08 data);
extern void acia_put_hex_nibble(u08 data);
extern void acia_print_unsigned_long(u32 unum);
extern void acia_print_signed_long(s32 snum);
//extern void abort(void);
extern void setup(void);
extern void teardown(void);
//extern char * strcpy(char *dst0, const char * src0);
//extern int  strcmp(const char *s1, const char *s2);
//extern void * memcpy(char *d, const char *s, unsigned l);
//extern void acia_put_char(__reg("d") char);
//extern int emul(int dy, int dd);
//extern int idiv(int dd, int dx);

//void acia_put_char(__reg("d") char)="\tjsr\tasm_putchar_b";


//void acia_put_char(__reg("d") char) =
//  "   lda   0xff03      \n"
//  "   bita  #0x10       \n"
//  "   .byte 0x27        \n"
//  "   .byte 0xf9        \n"
//  "   stb   0xff02      \n";        



int strcmp(__reg("y") const char *, __reg("x")const char *) =
  ".1:                \n"
  "  ldd   ,y++       \n"
  "  tsta             \n"
  "  beq   .3         \n"
  "  tstb             \n"
  "  beq   .5         \n"
  "  subd  ,x++       \n"
  "  bne   .2         \n"
  "  ;                \n"
  "  ldd   ,y++       \n"
  "  tsta             \n"
  "  beq   .3         \n"
  "  tstb             \n"
  "  beq   .5         \n"
  "  subd  ,x++       \n"
  "  beq    .1        \n"
  "  ;                \n"
  ".2:                \n"
  "  ldd   -2,y       \n"
  "  suba  -2,x       \n"
  "  bne   .4         \n"
  "  subb  -1,x       \n"
  "  bra   .6         \n"
  ".3:                \n"
  "  suba  ,x         \n"
  ".4:                \n"
  "  tfr  a,b         \n"
  "  bra  .6          \n"
  ".5:                \n"
  "  subb  1,x        \n"
  ".6:                \n"
  "  sex              \n";


#endif

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
// Description:
// BYTE Sieve Benchmark (Language: C)
// Originally published in BYTE magazine September 1981
//
//////////////////////////////////////////////////////////////////////////////
// History:
// 07.14.2023 - Kevin Phillipson
//   File header added
//
//////////////////////////////////////////////////////////////////////////////
// [TURBO9_HEADER_END]

#include "lib.h"
#define ITER_TOTAL  10


#define true 1
#define false 0
#define size 8190
#define sizepl 8191
unsigned char flags[sizepl];

SECTION_START
int main( void ) {

  COUNTER_VAR
  unsigned int i, prime, k, count, iter; 

  setup();

  acia_print_str      ("\n");
  acia_print_str      ("BYTE Sieve Benchmark (Language: C, ");
  acia_print_str      ("Compiler: ");
#ifdef _VBCC
  acia_print_str      ("vbcc");
#else
  acia_print_str      (COMPILER);
#endif
  acia_print_str      (")\n");
  acia_print_str      ("Originally published in BYTE magazine September 1981\n");
  acia_print_str      ("\n");
  acia_print_unsigned_long (ITER_TOTAL);
  acia_print_str      (" iterations\n");

  COUNTER_START

  for (iter = 1; iter <= ITER_TOTAL; iter ++) {
    count=0 ; 
    for (i = 0; i <= size; i++)
      flags[i] = true; 
    for (i = 0; i <= size; i++) { 
      if (flags[i]) {
        prime = i + i + 3; 
        k = i + prime; 
        while (k <= size) { 
          flags[k] = false; 
          k += prime; 
        }
        count = count + 1;
      }
    }
  }

  COUNTER_STOP

  acia_print_str      ("\n");
  acia_print_unsigned_long (count);
  acia_print_str      (" primes\n\n");
  
  acia_print_str      ("Number of iterations: ");
  acia_print_unsigned_long (ITER_TOTAL);
  acia_print_str      ("\n\n");
   
  COUNTER_PRINT

  acia_print_str     ("\n");

  teardown();

  return ( 0 );

}




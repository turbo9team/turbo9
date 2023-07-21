; [TURBO9_HEADER_START]
; ////////////////////////////////////////////////////////////////////////////
;                          Turbo9 Microprocessor IP
; ////////////////////////////////////////////////////////////////////////////
; Website: www.turbo9.org
; Contact: team[at]turbo9[dot]org
; ////////////////////////////////////////////////////////////////////////////
; [TURBO9_LICENSE_START]
; BSD-1-Clause
;
; Copyright (c) 2020-2023
; Kevin Phillipson
; Michael Rywalt
; All rights reserved.
;
; Redistribution and use in source and binary forms, with or without
; modification, are permitted provided that the following conditions are met:
;
; 1. Redistributions of source code must retain the above copyright notice,
;    this list of conditions and the following disclaimer.
;
; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
; AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
; IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
; ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS AND CONTRIBUTORS BE
; LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
; CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
; SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
; INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
; CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
; ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
; POSSIBILITY OF SUCH DAMAGE.
; [TURBO9_LICENSE_END]
; ////////////////////////////////////////////////////////////////////////////
; Engineer: Kevin Phillipson
; Description:
; BYTE Sieve Benchmark (Language: 6809 ASM)
; Originally published in BYTE magazine September 1981
; 6809 Assembly port by Kevin Phillipson
;
; ////////////////////////////////////////////////////////////////////////////
; History:
; 07.14.2023 - Kevin Phillipson
;   File header added
;
; ////////////////////////////////////////////////////////////////////////////
; [TURBO9_HEADER_END]

; ////////////////////////////////////////////////////////////////////////////
;                  Turbo9 / 6809 BYTE sieve benchmark program
; ////////////////////////////////////////////////////////////////////////////

  IFDEF _COCO
prog_start  equ $4000
clk_cnt     equ $0112
  ELSE
prog_start  equ $8000
clk_cnt     equ $0004
output_port equ $0000
  ENDC


data_size   equ 8190
iter        equ 10
LF          equ $0a


  org  prog_start  ; 32k of memory at the top

  IFDEF _COCO
 section code
  ENDC
; ////////////////////////////////////////////////////////////////////////////
;                             Code Under Test
; ////////////////////////////////////////////////////////////////////////////
code_under_test:
  leas  -1,s

  ldx   #prog_title
  jsr   print_x

  IFDEF _COCO
  ldd   #0
  std   clk_cnt
  ELSE
  lda   >output_port
  ora   #$02
  sta   >output_port    ; Set output_port[1] = 1, starting clk_counter
  ENDC


; ////////////////////////////////////////////////////////////////////////////
;                               BYTE sieve function
; ////////////////////////////////////////////////////////////////////////////
; #define true 1
; #define false 0
; #define size 8190
; #define sizepl 8191
; char flags[sizepl];
; main() {
;     int i, prime, k, count, iter; 
;     printf("10 iterations\n");
;     for (iter = 1; iter <= 10; iter ++) {     // interation_loop
;         count=0 ; 
;         for (i = 0; i <= size; i++)           // set_flags_loop
;             flags[i] = true;                  // set_flags_loop_done
;         for (i = 0; i <= size; i++) {         // find_primes_loop 
;             if (flags[i]) {
;                 prime = i + i + 3; 
;                 k = i + prime; 
;                 while (k <= size) {           // clr_flags_loop
;                     flags[k] = false; 
;                     k += prime; 
;                 }                             // clr_flags_loop_done
;                 count = count + 1;
;             }
;         }                                     // find_primes_loop_done 
;     }                                         // interation_loop_done
;    printf("\n%d primes", count);
; }
; Variables:
;
; i: generic loop counter (16bit) (X used) 
; prime:  16bit                   (D used)
; k:      16bit                   (Y used)
; count:  16bit                   (U used)
; iter:   8bit                    (0,s)

  lda   #iter
  sta   ,s

interation_loop
  
  ldx   #((data_size+1)&$0007)
  ldu   #flags
  ldd   #$0101
  ;  
set_flags_loop_1
  sta   ,u+
  leax  -1,x
  bne   set_flags_loop_1
  ;
  ldx   #((data_size+1)&$FFF8)
  beq   set_flags_done

  tfr   d,y   ; y   = $0101
  tfr   d,x   ; x   = $0101
  tfr   a,dp  ; dp  = $01
  ldu   #(flags+data_size+1)

  pshs  cc
set_flags_loop_8
  tfr   a,cc  ; cc  = $01
  pshu  y,x,dp,b,a,cc
  cmpu  #(flags+((data_size+1)&$0007))
  bne   set_flags_loop_8  ; Could unroll this loop...
  puls  cc
set_flags_done

  ldu   #0                ; U = count = 0
  ldd   #3                ; D = i + i + 3 (prime)
  ldx   #flags            ; X = i + flags
find_primes_loop
  tst   ,x+               ; need to account for this +1
  bne   if_flag_set       ; flag[i] = 1?
  addd  #2
  cmpx  #(flags+data_size)
  bls   find_primes_loop  ; Could unroll this loop...
find_primes_loop_done_0
  
  dec   ,s
  bne   interation_loop
interation_loop_done_0

  bra   main_done

if_flag_set
  leay  d,x                   ; Y = k = i + prime + flags +1
  cmpy  #(data_size+flags+1)  ; while (k <= size) (+1 correction for tst ,x+)
  bhi   clr_flags_loop_done
clr_flags_loop
  clr   -1,y                  ; flags[k] = false; (-1 correction for tst ,x+)
  leay  d,y                   ; X = k += prime
  cmpy  #(data_size+flags+1)  ; while (k <= size) (+1 correction for tst ,x+)
  bls   clr_flags_loop        ; Could unroll this loop...
clr_flags_loop_done

  leau  1,u

  addd  #2
  cmpx  #(flags+data_size)
  bls   find_primes_loop
find_primes_loop_done_1
  
  dec   ,s
  bne   interation_loop
interation_loop_done_1

; ////////////////////////////////////////////////////////////////////////////


main_done:

  IFDEF _COCO
  ELSE
; //////////////////////// Stop Clock Counter / Test Bench
  lda   >output_port
  ora   #$40
  sta   >output_port
  ENDC

; //////////////////////// Print Primes Found
  ldx   #primes_found
  jsr   print_x
  tfr   u,d
  jsr   puthex_16bit
  lda   #LF
  jsr   putchar_a

; ////////; //////////////////////// Number of Iterations
  ldx   #num_iter
  jsr   print_x
  lda   #iter
  jsr   puthex_byte
  lda   #LF
  jsr   putchar_a
 
  
; //////////////// Print Clock Count
  ldx   #clk_cnt_output
  jsr   print_x
  ldd   >clk_cnt
  jsr   puthex_16bit

  IFDEF _COCO
  ldx   #clk_cnt_unit
  jsr   print_x
  ELSE
  ldd   >(clk_cnt+2)
  jsr   puthex_16bit
  ENDC
  
  lda   #LF
  jsr   putchar_a
  
  leas  1,s
  jmp   terminate_prog


; ////////////////////////////////////////////////////////////////////////////
;                               Data Block
; ////////////////////////////////////////////////////////////////////////////

data_addr:

flags:  .blkb  (data_size+1)


data_end:

clk_cnt_output
  fcc  "Clock count: $"
  fcb  $00

  IFDEF _COCO
clk_cnt_unit
  fcc  " 16.67ms cycles"
  fcb $00
  ENDC

primes_found
  fcc  "Primes found: $"
  fcb  $00

prog_title:
  fcb   $0a
  fcc   "BYTE Sieve Benchmark (Language: 6809 ASM)"
  fcb   $0a
  fcc   "Originally published in BYTE magazine September 1981"
  fcb   $0a
  fcc   "6809 Assembly port by Kevin Phillipson"
  fcb   $0a
  fcb   $0a
  fcb   $00

num_iter:
  fcc   "Number of iterations: $"
  fcb   $00


  IFDEF _COCO
  include coco_sys_io.asm
  ELSE
  include turbo9_sys_io.asm
  ENDC

  include common_io.asm

  IFDEF _COCO
  endsect
  ENDC


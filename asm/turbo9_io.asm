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
; Description: Input / Output Library
;
; ////////////////////////////////////////////////////////////////////////////
; History:
; 07.14.2023 - Kevin Phillipson
;   File header added
;
; ////////////////////////////////////////////////////////////////////////////
; [TURBO9_HEADER_END]

; ////////////////////////////////////////////////////////////////////////////
;                             Turbo9 I/O Functions
; ////////////////////////////////////////////////////////////////////////////



; ////////////////////// Recieve byte and return in B
;
getchar_b
getchar_b_io_lib
  ldb   >acia_status
  bitb  #$08
  beq   getchar_b
  ldb   >acia_data
  rts


; ////////////////////// Get Hex 16bit
; 
; Get 4 hex digit and convert
; to binary word. Return in D
;
gethex_16bit
gethex_16bit_io_lib
  bsr   gethex_byte
  tfr   b,a
  bsr   gethex_byte
  rts

; ////////////////////// Get Hex Byte
; 
; Get 2 hex digit and convert
; to binary byte. Return in B
;
gethex_byte
gethex_byte_io_lib
  bsr   gethex_digit
  lslb
  lslb
  lslb
  lslb
  pshs  b
  bsr   gethex_digit
  orb   ,s+
  rts

; ////////////////////// Get Hex Digit
;
; Get hex digit and convert
; to binary nibble. Return in B
;
gethex_digit
gethex_digit_io_lib
  bsr   getchar_b
  cmpb  #'9'        ; 0 to 9?
  bls   ghd_0to9
  cmpb  #'F'        ; A to F?
  bls   ghd_AtoF
ghd_atof            ; else a to f
  subb  #32         ; ascii a: 97 - 32  - 7 - 48 = 10
ghd_AtoF
  subb  #7          ; ascii A: 65 - 7 - 48 = 10
ghd_0to9
  subb  #48         ; ascii 0: 48 - 48 = 0
  rts




; ////////////////////// Send byte contained in B
;
putchar_b
putchar_b_io_lib
  pshs  a
pcb_wait
  lda   >acia_status
  bita  #$10
  beq   pcb_wait
  stb   >acia_data
  puls  a,pc

; ////////////////////// Print null terminated string pointed to by D
;
; Adds CR to LF to support standard VT-100
;
print_string
print_string_io_lib
  pshs  b,x
  tfr   d,x
ps_loop
  ldb   ,x+
  beq   ps_end
  cmpb  #$0a
  bne   ps_not_lf
  ldb   #$0d
  bsr   putchar_b
  ldb   #$0a
ps_not_lf
  bsr   putchar_b
  bra   ps_loop
ps_end
  puls  b,x,pc

; ////////////////////// Put Hex 16bit
;
; Print hex value in D
;
puthex_16bit
puthex_16bit_io_lib
  exg   a,b
  bsr   puthex_byte
  exg   a,b
  bsr   puthex_byte
  rts


; ////////////////////// Put Hex Byte
;
; Print hex value in B
;
puthex_byte
puthex_byte_io_lib
  pshs  b
  lsrb
  lsrb
  lsrb
  lsrb
  bsr   puthex_digit
  puls  b
  bsr   puthex_digit
  rts


; ////////////////////// Put Hex Digit
;
puthex_digit
puthex_digit_io_lib
  pshs  b
  andb  #$0f
  cmpb  #$0a
  blo   phd_0to9
phd_AtoF
  addb  #7
phd_0to9
  addb  #48
  bsr   putchar_b
  puls  b,pc


; ////////////////////////////////////////////////////////////////////////////



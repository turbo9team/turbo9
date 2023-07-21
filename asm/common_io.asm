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
;                             Common I/O Functions
; ////////////////////////////////////////////////////////////////////////////

; You must provide a putchar_a & getchar_a function for this library.
; Requirement for putchar_a & getchar_a
;  - byte in A to be recieved / sent
;  - all other registers need to be maintained through function call
;



; ////////////////////// Print null terminated string pointed to by X
;
print_x
  pshs  a,x
apx_loop
  lda   ,x+
  beq   apx_end
  jsr   putchar_a
  bra   apx_loop
apx_end
  puls  a,x,pc

; ////////////////////// Put Hex Digit
;
puthex_digit
  pshs  a
  anda  #$0f
  cmpa  #$0a
  blo   puthex_digit1
  adda  #$37
  bra   puthex_digit2
puthex_digit1
  adda  #$30
puthex_digit2
  jsr   putchar_a
  puls  a,pc

; ////////////////////// Get Hex Digit
;
; Get hex digit and convert
; to binary nibble. Return in A
;
gethex_digit
  jsr   getchar_a
  bsr   ucase_a
  cmpa  #'A'         ; uppercase A to F?
  bhs   ghd_AtoF
ghd_0to9
  suba  #'0'         ; else 0 to 9
  bra   ghd_done
ghd_AtoF
  suba  #$37
ghd_done
  rts


; ////////////////////// Get Hex Byte
; 
; Get 2 hex digit and convert
; to binary byte. Return in A
;
gethex_byte
  bsr   gethex_digit
  lsla
  lsla
  lsla
  lsla
  pshs  a
  bsr   gethex_digit
  ora   ,s+
  rts

; ////////////////////// Put Hex Byte
;
; Print hex value in A
;
puthex_byte
  pshs  a
  lsra
  lsra
  lsra
  lsra
  bsr   puthex_digit
  puls  a
  bsr   puthex_digit
  rts

; ////////////////////// Put Hex 16bit
;
; Print hex value in D
;
puthex_16bit
  bsr   puthex_byte
  exg   a,b
  bsr   puthex_byte
  exg   a,b
  rts

; ////////////////////// Ucase A
;
ucase_a
  cmpa  #'a'
  blo   uca_done
  cmpa  #'z'
  bhi   uca_done
  suba  #$20
uca_done
  rts

; ////////////////////////////////////////////////////////////////////////////



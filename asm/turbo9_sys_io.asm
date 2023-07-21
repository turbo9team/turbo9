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
; Description: Basic putchar and getchar system I/O using the bootloader SWI
; functions
;
; ////////////////////////////////////////////////////////////////////////////
; History:
; 07.14.2023 - Kevin Phillipson
;   File header added
;
; ////////////////////////////////////////////////////////////////////////////
; [TURBO9_HEADER_END]

; ////////////////////////////////////////////////////////////////////////////
;                          System I/O Functions
; ////////////////////////////////////////////////////////////////////////////

putchar_a
  pshs  a,b
  tfr   a,b
  lda   #3
  swi
  puls  a,b,pc

getchar_a
  pshs  x
  lda   #4
  ldx   #getchar_byte_buf
  swi
  lda   >getchar_byte_buf
  puls  x,pc
getchar_byte_buf
  fcb   $00

terminate_prog
  lda   #0
  swi

; ////////////////////////////////////////////////////////////////////////////



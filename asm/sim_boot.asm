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
; Engineer:
; Description:
;
; ////////////////////////////////////////////////////////////////////////////
; History:
; 07.14.2023 - Kevin Phillipson
;   File header added
;
; ////////////////////////////////////////////////////////////////////////////
; [TURBO9_HEADER_END]
;
; Turbo9 S19 Bootloader
;
; Kevin Phillipson
;

output_port equ   $0000
acia_data   equ   $0002
acia_status equ   $0003
boot_start  equ   $fe00  ; bootloader location
boot_stack  equ   $fe00  ; stack location
prog_start  equ   $8000  ; loaded program should start here
LF          equ   $0a


; ////////////////////////////////////////////////////////////////////////////
;                            Main Program
; ////////////////////////////////////////////////////////////////////////////

  org   boot_start

  clr   >output_port  ; clear outport to communicate with TB

  lds   #boot_stack 

  ldx   #prompt
  jsr   print_x

  lbra   call_prog_start  ; sed in asm32k will change this to bra for sim_boot.asm

  ; A = general purpose
  ; S = stack pointer

  ; B = byte_cnt,     S1 record byte count
  ; X = checksum,
  ; Y = write_addr,   Write address
  ; U = total_bytes,  Total bytes written
  
  ldu   #$0000        ; clear total_bytes
  ldx   #$0000        ; clear checksum

main_loop
  jsr   getchar_a

  cmpa  #'S'
  bne   main_loop

  jsr   getchar_a

  cmpa  #'1'
  beq   s1_record

  cmpa  #'9'
  beq   s9_record

  bra   main_loop

s1_record
  leax  ,x            ; checksum still ok?
  bne   main_loop
  lda   #'.'
  jsr   putchar_a     ; Print progress bar
  jsr   gethex_byte   ; Read length
  leax  a,x           ; add_checksum
  suba  #3            ; minus 16bit address & checksum equals number of data bytes
  sta   ,-s           ; push A (byte_cnt)
  jsr   gethex_byte
  leax  a,x           ; add_checksum
  tfr   a,b           ; put write_addr[15:8] in B
  jsr   gethex_byte
  leax  a,x           ; add_checksum
  exg   a,b           ; D = write_addr
  tfr   d,y           ; Y = write_addr
  ldb   ,s+           ; pull B (byte_cnt)
  ;
s1r_loop
  decb                ; dec byte_cnt
  bmi   s1r_checkit
  jsr   gethex_byte
  leax  a,x           ; add_checksum
  sta   ,y+           ; write byte to write_addr; write_addr + 1
  leau  1,u           ; U = total_bytes + 1
  bra   s1r_loop
  ;
s1r_checkit
  ; the S1 checksum should equal the one's complement of our running checksum in x[7:0]
  jsr   gethex_byte   ; read S1 checksum
  sta   ,-s           ; push S1 checksum onto stack
  tfr   x,d
  eorb  ,s            ; B = $FF if correct
  incb                ; B = $00 if correct
  clra
  tfr   d,x           ; X = $0000 if correct
  leas  1,s           ; clean up stack
  bra   main_loop


s9_record
  leax  ,x            ; checksum ok?
  beq   s9r_good_load
  ldx   #load_bad
  jsr   print_x
  jmp   boot_start
s9r_good_load
  ldx   #load_good0
  jsr   print_x
  tfr   u,d           ; A:B = total_bytes
  jsr   puthex_16bit
  ldx   #load_good1
  jsr   print_x
  ldd   #prog_start
  jsr   puthex_16bit
  lda   #LF
  jsr   putchar_a

call_prog_start
  inc   >output_port  ; set outport[0] = 1 to tell TB test has begun 
  jsr  prog_start  

boot_return
  ldx   #return_msg
  jsr   print_x
  lda   >output_port
  ora   #$80
  sta   >output_port  ;  set outport[7] = 1 to tell TB test has finished
boot_sim_stop
  bra   boot_sim_stop ; sed in asm32k will change this to bra for sim_boot.asm
  jmp   boot_start

; ////////////////////////////////////////////////////////////////////////////


; ////////////////////////////////////////////////////////////////////////////
;                              Utility Functions
; ////////////////////////////////////////////////////////////////////////////


; ////////////////////// Send byte contained in A
;
putchar_a
  tst   >sim_detect
  bne   pca_sim_out
  cmpa  #$0a  ; LF
  bne   pca_not_lf
  lda   #$0d  ; CR
  bsr   acia_putchar_a
  lda   #$0a  ; LF
pca_not_lf
; fall through
acia_putchar_a
  pshs  a
apa_wait
  lda   >acia_status
  bita  #$10
  beq   apa_wait
  puls  a
  sta   >acia_data
  rts

pca_sim_out
  sta   >sim_putchar_buf
  clr   >sim_putchar_en
  com   >sim_putchar_en ; on bit0 posedge simulator writes to console.txt
  rts


; ////////////////////// Recieve byte and return in A
;
getchar_a
  lda   >acia_status
  bita  #$08
  beq   getchar_a
  lda   >acia_data
  rts

; ////////////////////////////////////////////////////////////////////////////


; ////////////////////////////////////////////////////////////////////////////
;                              SWI Handler
; ////////////////////////////////////////////////////////////////////////////

swi_handler
  cmpa  #$04
  bne   swi_handler_3
  bsr   getchar_a
  sta   ,x
  puls  pc,u,y,x,dp,b,a,cc

swi_handler_3
  cmpa  #$03
  bne   swi_handler_2
  tfr   b,a
  bsr   putchar_a
  puls  pc,u,y,x,dp,b,a,cc

swi_handler_2
  cmpa  #$02
  bne   swi_handler_1
  ldx   #input_prompt
  jsr   print_x
  puls  pc,u,y,x,dp,b,a,cc

swi_handler_1
  cmpa  #$01
  bne   swi_handler_exit
  jsr   print_x
  puls  pc,u,y,x,dp,b,a,cc

swi_handler_exit
  jmp   boot_return

; ////////////////////////////////////////////////////////////////////////////


; ////////////////////////////////////////////////////////////////////////////
;                              Data Block
; ////////////////////////////////////////////////////////////////////////////

prompt
  fcb  $0a
  fcc  "/// Turbo9 S19 Bootloader ///"
  fcb  $0a
  fcb  $00

load_bad
  fcb  $0a
  fcc  "Checksum FAIL"
  fcb  $0a
  fcb  $00

load_good0
  fcb  $0a
  fcc  "Bytes received $"
  fcb  $00

load_good1
  fcb  $0a
  fcc  "Checksum PASS"
  fcb  $0a
  fcc  "JSR to $"
  fcb  $00

input_prompt
  fcc  "BAD"
  fcb  $00

return_msg
  fcb  $0a
  fcc  "Returned to bootloader..."
  fcb  $0a
  fcb  $00

; ////////////////////////////////////////////////////////////////////////////


; ////////////////////////////////////////////////////////////////////////////
;                       Common I/O Function Library
; ////////////////////////////////////////////////////////////////////////////
  
  include   common_io.asm

; ////////////////////////////////////////////////////////////////////////////


; ////////////////////////////////////////////////////////////////////////////
;                     Simulation Output Interface
; ////////////////////////////////////////////////////////////////////////////

  org   boot_vector_table-3
sim_detect
  fcb   $01   ;sed replace tag_sim_detect
sim_putchar_en
  fcb   $00 
sim_putchar_buf
  fcb   $00

; ////////////////////////////////////////////////////////////////////////////


; ////////////////////////////////////////////////////////////////////////////
;                      Reset / Interrupt Vector Table
; ////////////////////////////////////////////////////////////////////////////

  org  $fff0
boot_vector_table:

boot_reserved_vector:
  fdb boot_start
boot_swi3_vector:
  fdb boot_start
boot_swi2_vector:
  fdb boot_start
boot_firq_vector:
  fdb boot_start
boot_irq_vector:
  fdb boot_start
boot_swi_vector:
  fdb swi_handler
boot_nmi_vector:
  fdb boot_start
boot_reset_vector:
  fdb boot_start

; ////////////////////////////////////////////////////////////////////////////

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

; //////////// Memory Map
;
; Initialized RAM (Vector Table): FFFF - FFF0
;
; FFFE : FFFF   RESET_VECTOR
; FFFC : FFFD   NMI_VECTOR
; FFFA : FFFB   SWI_VECTOR
; FFF8 : FFF9   IRQ_VECTOR
; FFF6 : FFF7   FIRQ_VECTOR
; FFF4 : FFF5   SWI2_VECTOR
; FFF2 : FFF3   SWI3_VECTOR
; FFF0 : FFF1   RESERVED_VECTOR
;
;
; I/O Space: FFEF - FF00
;
; FF08          CLK_CNT_CTRL[1:0] (read)  /  CLK_CNT_CTRL (write)
; FF04 : FF07   CLK_CNT[31:0]     (read)
; FF03          ACIA_STATUS       (read)
; FF02          ACIA_RX_DATA      (read)  /  ACIA_TX_DATA (write)
; FF01          GPI PORT          (read)
; FF00          GPO PORT          (read)  /  GPO_PORT    (write)
;
; Initialized RAM: FEFF - 0000
;

acia_status equ   $ff03
acia_data   equ   $ff02
gpi_port    equ   $ff01
gpo_port    equ   $ff00


boot_start  equ   $fd00       ; bootloader location
boot_stack  equ   boot_start  ; stack location


; ////////////////////////////////////////////////////////////////////////////
;                            Main Program
; ////////////////////////////////////////////////////////////////////////////


; //////////////////// Start of bootloader
; //
  org   boot_start

  lds   #boot_stack   ; set stack point

  clr   gpo_port  ; clear outport to communicate with TB

  ; B = general purpose
  ; S = stack pointer

  ; A = byte_cnt,     S1 record byte count
  ; X = checksum,
  ; Y = write_addr,   Write address
  ; U = total_bytes,  Total bytes written
  
  ldx   #$0000        ; clear checksum
  tfr   x,u           ; clear total_bytes

  ldd   #string_prompt
  jsr   print_string
 
; //////////////////// Top of main Loop
; //
main_loop
  jsr   getchar_b

  cmpb  #'S'
  bne   main_loop

  jsr   getchar_b

  cmpb  #'0'
  beq   s0_record

  cmpb  #'1'
  beq   s1_record

  cmpb  #'9'
  beq   s9_record

  bra   main_loop


; //////////////////// S0 record
; //
s0_record
  leax  ,x            ; checksum still ok?
  bne   main_loop
  jsr   put_len_in_a
  jsr   put_addr_in_y
s0r_loop
  jsr   gethex_byte
  leax  b,x           ; add_checksum
  jsr   putchar_b
  deca                ; dec byte_cnt
  bne   s0r_loop
  jsr   calc_checksum_x
  ldb   #' '
  jsr   putchar_b     ; Print a space
  bra   main_loop
 

; //////////////////// S1 record
; //
s1_record
  leax  ,x            ; checksum still ok?
  bne   main_loop
  jsr   put_len_in_a
  jsr   put_addr_in_y
s1r_loop
  jsr   gethex_byte
  leax  b,x           ; add_checksum
  stb   ,y+           ; write byte to write_addr; write_addr + 1
  leau  1,u           ; U = total_bytes + 1
  deca                ; dec byte_cnt
  bne   s1r_loop
  jsr   calc_checksum_x
  ldb   #'.'
  jsr   putchar_b     ; Print progress bar
  bra   main_loop


; //////////////////// S9 record
; //
s9_record
  leax  ,x            ; checksum still ok?
  bne   bootload_done
  jsr   put_len_in_a
  jsr   put_addr_in_y
  jsr   calc_checksum_x
s9r_lf
  jsr   getchar_b
  cmpb  #$0a
  bne   s9r_lf        ; strip the last LF from the data stream
  bra   bootload_done
  

; //////////////////// Bootloader done
; //
bootload_done
  ldd   #string_checksum
  jsr   print_string
  leax  ,x            ; checksum ok?
  beq   bootload_good
  ldd   #string_fail
  jsr   print_string
  jmp   boot_start
bootload_good
  ldd   #string_pass_total_bytes
  jsr   print_string
  tfr   u,d           ; U = total_bytes
  jsr   puthex_16bit
  ldd   #string_jsr
  jsr   print_string
  tfr   y,d           ; Y = loaded program start address
  jsr   puthex_16bit
  ldd   #string_line_feed
  jsr   print_string
  jsr   print_string
call_prog_start
  ldb   #$01
  stb   gpo_port    ; set outport[0] = 1 to tell TB test has begun 
  jsr   ,y          ; jump/call to loaded program at address Y 
  ;
  ; Run the loaded program!
  ;
boot_return
boot_return_io_lib
  ldb   #$02
  stb   gpo_port    ;  set outport[1] = 1 to tell TB test has finished
  jmp   boot_start

; ////////////////////////////////////////////////////////////////////////////


; ////////////////////////////////////////////////////////////////////////////
;                            Helper Functions
; ////////////////////////////////////////////////////////////////////////////


; //////////////////// Get length, put in A
; //
put_len_in_a
  ; put length in A, update checksum in X.
  pshs  b
  jsr   gethex_byte   ; Read length
  leax  b,x           ; add_checksum
  subb  #3            ; minus 16bit address & checksum equals number of data bytes
  tfr   b,a           ; put byte_cnt in A
  puls  b,pc


; //////////////////// Get address, put in Y
; //
put_addr_in_y
  ; put address in Y, update checksum in X.
  pshs  a,b
  jsr   gethex_byte
  leax  b,x           ; add_checksum
  tfr   b,a           ; put write_addr[15:8] in A
  jsr   gethex_byte
  leax  b,x           ; add_checksum
  tfr   d,y           ; Y = write_addr
  puls  a,b,pc


; //////////////////// Get checksum, compare to X
; //
calc_checksum_x
  ; the S1 checksum should equal the one's complement of our running checksum in x[7:0]
  pshs  a,b
  jsr   gethex_byte   ; read S1 checksum
  stb   ,-s           ; push S1 checksum onto stack
  tfr   x,d
  eorb  ,s            ; B = $FF if correct
  incb                ; B = $00 if correct
  clra
  tfr   d,x           ; X = $0000 if correct
  leas  1,s           ; clean up stack
  puls  a,b,pc

; ////////////////////////////////////////////////////////////////////////////


; ////////////////////////////////////////////////////////////////////////////
;                              Data Block
; ////////////////////////////////////////////////////////////////////////////

string_prompt
  fcb  $0a
  fcb  $0a
  fcc  "> Turbo9 S19 Bootloader"
  fcb  $0a
  fcc  "> "
  fcb  $00

string_checksum
  fcc  " done!"
  fcb  $0a
  fcc  "> Checksum "
  fcb  $00

string_fail
  fcc  "FAIL"
  fcb  $00

string_pass_total_bytes
  fcc  "PASS"
  fcb  $0a
  fcc  "> Total bytes $"
  fcb  $00

string_jsr
  fcb  $0a
  fcc  "> JSR to $"
  fcb  $00

string_line_feed
  fcb  $0a
  fcb  $00

; ////////////////////////////////////////////////////////////////////////////


; ////////////////////////////////////////////////////////////////////////////
;                       Common I/O Function Library
; ////////////////////////////////////////////////////////////////////////////

turbo9_io_addr:
 
  include   turbo9_io.asm

; ////////////////////////////////////////////////////////////////////////////



; ////////////////////////////////////////////////////////////////////////////
;                           I/O Block  (240 bytes)
; ////////////////////////////////////////////////////////////////////////////
  org $ff00
io_block:

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
  fdb boot_start
boot_nmi_vector:
  fdb boot_start
boot_reset_vector:
  fdb boot_start

; ////////////////////////////////////////////////////////////////////////////

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
; Description: Template assemply program used by the DV testbench
;
; ////////////////////////////////////////////////////////////////////////////
; History:
; 07.14.2023 - Kevin Phillipson
;   File header added
;
; ////////////////////////////////////////////////////////////////////////////
; [TURBO9_HEADER_END]

; ////////////////////////////////////////////////////////////////////////////
;                       Turbo9 / 6809 testbench program
; ////////////////////////////////////////////////////////////////////////////

output_port equ $0000

  org  $fc00

; ////////////////////////////////////////////////////////////////////////////
;                    Testbench Program Start (S Stack Pointer)
; ////////////////////////////////////////////////////////////////////////////
start_s_ptr:

  ; initalize output_port[7:0] = 8'h00
  lda   #$00
  sta   >output_port

  ; Delay a few cycles
  nop
  nop
  nop
  nop

  ; set start flag (output_port[0] = 1'b1)
  lda   #$01
  sta   >output_port

  ; Use S as stack pointer
  lds   #init_stack_data
  puls  pc,u,y,x,dp,b,a,cc ; pulling PC will jump to code_under_test


; ////////////////////////////////////////////////////////////////////////////
;                    Testbench Program Start (U Stack Pointer)
; ////////////////////////////////////////////////////////////////////////////
start_u_ptr:

  ; initalize output_port[7:0] = 8'h00
  lda   #$00
  sta   >output_port

  ; Delay a few cycles
  nop
  nop
  nop
  nop

  ; set start flag (output_port[0] = 1'b1)
  lda   #$01
  sta   >output_port

  ; Use U as stack pointer
  ldu   #init_stack_data
  pulu  pc,s,y,x,dp,b,a,cc ; pulling PC will jump to code_under_test


; ////////////////////////////////////////////////////////////////////////////
;                     Testbench Program Done (S Stack Pointer)
; ////////////////////////////////////////////////////////////////////////////
done_s_ptr
  pshs  pc,u,y,x,dp,b,a,cc

  ; set done flag (output_port[7] = 1'b1)
  lda   >output_port
  ora   #$80
  sta   >output_port

done_s_ptr_loop:
  nop   ; make the PC change in sim model
  bra   done_s_ptr_loop


; ////////////////////////////////////////////////////////////////////////////
;                     Testbench Program Done (U Stack Pointer)
; ////////////////////////////////////////////////////////////////////////////
done_u_ptr
  pshu  pc,s,y,x,dp,b,a,cc

  ; set done flag (output_port[7] = 1'b1)
  lda   >output_port
  ora   #$80
  sta   >output_port

done_u_ptr_loop:
  nop   ; make the PC change in sim model
  bra   done_u_ptr_loop


; ////////////////////////////////////////////////////////////////////////////
;                             Code Under Test
; ////////////////////////////////////////////////////////////////////////////
code_under_test:

; replace the following with code to test
  jmp   done_s_ptr

  org code_under_test_mid-128+2
code_under_test_br_bwd
; the maximum range for branching backward
  inca
  jmp   done_s_ptr

  org code_under_test_mid-128+3
code_under_test_idx_pc8_bwd
; the maximum range for pc8 index backward

  org   (code_under_test+data_block_end)/2
code_under_test_mid
; a midpoint in the code/data block
  beq   code_under_test_br_bwd
  jmp   done_s_ptr

  org code_under_test_mid+127+2
code_under_test_br_fwd
; the maximum range for branching forward
  incb
  jmp   done_s_ptr

  org code_under_test_mid+127+3
code_under_test_idx_pc8_fwd
; the maximum range for pc8 index forward



; ////////////////////////////////////////////////////////////////////////////
;                               Data Block
; ////////////////////////////////////////////////////////////////////////////

data_addr:
  fcb $7f


  org  stack_end-1
data_block_last_byte:
  org  stack_end
data_block_end:

; ////////////////////////////////////////////////////////////////////////////
;                            Stack (32 bytes)
; ////////////////////////////////////////////////////////////////////////////
; Used to load initial state and save run-time data for code under test
; and save the processor state after code under test complete

  org  vector_table-32
stack_end:

  org  vector_table-12
init_stack_data:
init_cc:
  fcb   $78   ;cc
init_a:
  fcb   $67   ;a
init_b:
  fcb   $56   ;b
init_dp:
  fcb   data_addr/$100  ;dp
init_x:
  fdb   $3443 ;x
init_y:
  fdb   $2332 ;y
init_u_s:
  fdb   $1221 ;u or s
init_pc:
  fdb   code_under_test ;pc

stack_start:

; ////////////////////////////////////////////////////////////////////////////
;                         reset / interrupt vector 
; ////////////////////////////////////////////////////////////////////////////
  org  $fff0
vector_table:

reserved_vector:
  fdb start_s_ptr
swi3_vector:
  fdb start_s_ptr
swi2_vector:
  fdb start_s_ptr
firq_vector:
  fdb start_s_ptr
irq_vector:
  fdb start_s_ptr
swi_vector:
  fdb start_s_ptr
nmi_vector:
  fdb start_s_ptr
reset_vector:
  fdb start_s_ptr


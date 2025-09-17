////////////////////////////////////////////////////////////////////////////////
//                                                                            //
//      Definition file                                                       //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////

`define asm_code_under_test                 16'hFA2B
`define asm_code_under_test_br_bwd          16'hFC07
`define asm_code_under_test_br_fwd          16'hFD06
`define asm_code_under_test_idx_pc8_bwd     16'hFC08
`define asm_code_under_test_idx_pc8_fwd     16'hFD07
`define asm_code_under_test_mid             16'hFC85
`define asm_data_addr                       16'hFD07
`define asm_data_block_end                  16'hFEE0
`define asm_data_block_last_byte            16'hFEDF
`define asm_done_s_ptr                      16'hFA1B
`define asm_done_s_ptr_loop                 16'hFA20
`define asm_done_u_ptr                      16'hFA23
`define asm_done_u_ptr_loop                 16'hFA28
`define asm_firq_vector                     16'hFFF6
`define asm_gpo_port                        16'hFF00
`define asm_init_a                          16'hFEF5
`define asm_init_b                          16'hFEF6
`define asm_init_cc                         16'hFEF4
`define asm_init_dp                         16'hFEF7
`define asm_init_pc                         16'hFEFE
`define asm_init_stack_data                 16'hFEF4
`define asm_init_u_s                        16'hFEFC
`define asm_init_x                          16'hFEF8
`define asm_init_y                          16'hFEFA
`define asm_io_block                        16'hFF00
`define asm_irq_vector                      16'hFFF8
`define asm_nmi_vector                      16'hFFFC
`define asm_reserved_vector                 16'hFFF0
`define asm_reset_vector                    16'hFFFE
`define asm_stack_end                       16'hFEE0
`define asm_start_s_ptr                     16'hFA00
`define asm_start_u_ptr                     16'hFA0E
`define asm_swi2_vector                     16'hFFF4
`define asm_swi3_vector                     16'hFFF2
`define asm_swi_vector                      16'hFFFA
`define asm_vector_table                    16'hFFF0

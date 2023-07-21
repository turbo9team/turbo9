////////////////////////////////////////////////////////////////////////////////
//                                                                            //
//      Definition file                                                       //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////

`define asm_code_under_test                 16'hFC41
`define asm_code_under_test_br_bwd          16'hFD8A
`define asm_code_under_test_br_fwd          16'hFE89
`define asm_code_under_test_idx_pc8_bwd     16'hFD8B
`define asm_code_under_test_idx_pc8_fwd     16'hFE8A
`define asm_code_under_test_mid             16'hFE08
`define asm_data_addr                       16'hFE8A
`define asm_data_block_end                  16'hFFD0
`define asm_data_block_last_byte            16'hFFCF
`define asm_done_s_ptr                      16'hFC27
`define asm_done_s_ptr_loop                 16'hFC31
`define asm_done_u_ptr                      16'hFC34
`define asm_done_u_ptr_loop                 16'hFC3E
`define asm_firq_vector                     16'hFFF6
`define asm_init_a                          16'hFFE5
`define asm_init_b                          16'hFFE6
`define asm_init_cc                         16'hFFE4
`define asm_init_dp                         16'hFFE7
`define asm_init_pc                         16'hFFEE
`define asm_init_stack_data                 16'hFFE4
`define asm_init_u_s                        16'hFFEC
`define asm_init_x                          16'hFFE8
`define asm_init_y                          16'hFFEA
`define asm_irq_vector                      16'hFFF8
`define asm_nmi_vector                      16'hFFFC
`define asm_output_port                     16'h0000
`define asm_reserved_vector                 16'hFFF0
`define asm_reset_vector                    16'hFFFE
`define asm_stack_end                       16'hFFD0
`define asm_stack_start                     16'hFFF0
`define asm_start_s_ptr                     16'hFC00
`define asm_start_u_ptr                     16'hFC14
`define asm_swi2_vector                     16'hFFF4
`define asm_swi3_vector                     16'hFFF2
`define asm_swi_vector                      16'hFFFA
`define asm_vector_table                    16'hFFF0

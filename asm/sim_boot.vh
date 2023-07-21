////////////////////////////////////////////////////////////////////////////////
//                                                                            //
//      Definition file                                                       //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////

`define asm_acia_data                       16'h0002
`define asm_acia_putchar_a                  16'hFEBE
`define asm_acia_status                     16'h0003
`define asm_apa_wait                        16'hFEC0
`define asm_apx_end                         16'hFF93
`define asm_apx_loop                        16'hFF8A
`define asm_boot_firq_vector                16'hFFF6
`define asm_boot_irq_vector                 16'hFFF8
`define asm_boot_nmi_vector                 16'hFFFC
`define asm_boot_reserved_vector            16'hFFF0
`define asm_boot_reset_vector               16'hFFFE
`define asm_boot_return                     16'hFE9C
`define asm_boot_sim_stop                   16'hFEAA
`define asm_boot_stack                      16'hFE00
`define asm_boot_start                      16'hFE00
`define asm_boot_swi2_vector                16'hFFF4
`define asm_boot_swi3_vector                16'hFFF2
`define asm_boot_swi_vector                 16'hFFFA
`define asm_boot_vector_table               16'hFFF0
`define asm_call_prog_start                 16'hFE96
`define asm_getchar_a                       16'hFED7
`define asm_gethex_byte                     16'hFFB8
`define asm_gethex_digit                    16'hFFA8
`define asm_ghd_0to9                        16'hFFB1
`define asm_ghd_AtoF                        16'hFFB5
`define asm_ghd_done                        16'hFFB7
`define asm_input_prompt                    16'hFF68
`define asm_LF                              16'h000A
`define asm_load_bad                        16'hFF2E
`define asm_load_good0                      16'hFF3E
`define asm_load_good1                      16'hFF50
`define asm_main_loop                       16'hFE16
`define asm_output_port                     16'h0000
`define asm_pca_not_lf                      16'hFEBE
`define asm_pca_sim_out                     16'hFECD
`define asm_print_x                         16'hFF88
`define asm_prog_start                      16'h8000
`define asm_prompt                          16'hFF0E
`define asm_putchar_a                       16'hFEAF
`define asm_puthex_16bit                    16'hFFD2
`define asm_puthex_byte                     16'hFFC5
`define asm_puthex_digit                    16'hFF95
`define asm_puthex_digit1                   16'hFFA1
`define asm_puthex_digit2                   16'hFFA3
`define asm_return_msg                      16'hFF6C
`define asm_s1_record                       16'hFE2A
`define asm_s1r_checkit                     16'hFE5C
`define asm_s1r_loop                        16'hFE4E
`define asm_s9_record                       16'hFE6D
`define asm_s9r_good_load                   16'hFE7A
`define asm_sim_detect                      16'hFFED
`define asm_sim_putchar_buf                 16'hFFEF
`define asm_sim_putchar_en                  16'hFFEE
`define asm_swi_handler                     16'hFEE2
`define asm_swi_handler_1                   16'hFF02
`define asm_swi_handler_2                   16'hFEF6
`define asm_swi_handler_3                   16'hFEEC
`define asm_swi_handler_exit                16'hFF0B
`define asm_uca_done                        16'hFFE5
`define asm_ucase_a                         16'hFFDB

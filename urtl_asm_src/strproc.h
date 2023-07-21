// [TURBO9_HEADER_START]
//////////////////////////////////////////////////////////////////////////////
//                          Turbo9 Microprocessor IP
//////////////////////////////////////////////////////////////////////////////
// Website: www.turbo9.org
// Contact: team[at]turbo9[dot]org
//////////////////////////////////////////////////////////////////////////////
// [TURBO9_LICENSE_START]
// BSD-1-Clause
//
// Copyright (c) 2020-2023
// Kevin Phillipson
// Michael Rywalt
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
// 1. Redistributions of source code must retain the above copyright notice,
//    this list of conditions and the following disclaimer.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS AND CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.
// [TURBO9_LICENSE_END]
//////////////////////////////////////////////////////////////////////////////
// Engineer: Michael Rywalt
// Description: String processing header file.
//
//////////////////////////////////////////////////////////////////////////////
// History:
// 07.14.2023 - Kevin Phillipson
//   File header added
//
//////////////////////////////////////////////////////////////////////////////
// [TURBO9_HEADER_END]

#ifndef _STRPROC_H_
#define _STRPROC_H_

#include "mytypedef.h"

char * convert_to_upper_case(char *str);
s16 strmspc(char *line);
s16 chop_string(char *line, char chop);
s16 strip_string(char *line, u08 clip_leading_whitespace);
s16 sub_str_by_field(char *in_str, char sep_ch, char *out_str, u08 start_field, u08 end_field);
s16 get_field(char *line, char *field, u08 field_num, u08 field_spaces);
s16 get_field_ex(char IN *line, char OUT **field, u08 field_num, u08 field_spaces);
s16 check_field(char IN *line, char IN *tok, u08 field_num, u08 field_spaces);
u32 hex_str2num(char * hex_str);
u32 str2num(char * str);
u08 hex2num(char hex_digit);
u08 is_valid(char c);
u08 is_number(char c);
s16 is_comment(char *line);
s16 is_empty_line(char *line);
void num2bin_str(u16 num, u08 width, char * bin_str);
void num2hex_str(u16 num, u08 width, char * hex_str);
char num2hex(u08 num);
void make_str_pad(u08 str_len, u08 width, char pad_char, char * pad);
s16 get_label(char *line);
s16 get_org_val(char IN *line, u32 *val);

#endif

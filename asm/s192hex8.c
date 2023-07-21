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
// Engineer: Kevin Phillipson
// Description: s19 to hex file converter
//
//////////////////////////////////////////////////////////////////////////////
// History:
// 07.14.2023 - Kevin Phillipson
//   File header added
//
//////////////////////////////////////////////////////////////////////////////
// [TURBO9_HEADER_END]
/*

; --==========================> Gator uProccessor <===========================--
; -- File:		s192hex8.c	
; -- Engineer:		Kevin Phillipson
; -- Date:		03.28.07
; -- Revision:		10.03.20
; -- Description:
;
;    THIS IS OLD CODE AND SHOULD PROBABLY BE REWRITTEN, BUT IT WORKS.
;
; --==========================================================================--

*/

#include <stdio.h>
#include <string.h>

#define WIDTH 8

#define BUF_SIZE 16

typedef	unsigned char	u08;
typedef	signed char	s08;
typedef	unsigned short	u16;
typedef	signed short	s16;
typedef	unsigned long	u32;
typedef	signed long	s32;

u08	hex2bin(u08 hex_digit);
u08	bin2hex(u08 nibble);
s16	load_buffer(void);
void	crlf(void);


u08	buffer[BUF_SIZE];
s16	eof_buf[BUF_SIZE];


main(void)
{


	u32	idx = 0;

	u08	num_bytes;
	
	u16	hex_file_addr;
	u32	hex_file_depth = 0;
	
	u32	raw_idx = 0;
	u16	raw_addr[0x10000];
	u08	raw_data[0x10000];

	s08	flush;
	u08	state = 0;

	for (idx = 0; idx < BUF_SIZE; idx++)
		buffer[idx] = 0x00;

	for (idx = 0; idx < BUF_SIZE; idx++)
		eof_buf[idx] = 0x00;

	while (load_buffer() != EOF)
	{
		flush = 0;
		
		switch(state)
		{
			case 0:
				if (strncmp(buffer,"S1",2) == 0)
				{
					num_bytes = 	(hex2bin(buffer[2]) << 4) +
							(hex2bin(buffer[3])) - 3;
						
					hex_file_addr =	(hex2bin(buffer[4]) << 12) +
							(hex2bin(buffer[5]) << 8) +
							(hex2bin(buffer[6]) << 4) + 
							(hex2bin(buffer[7]));
					
					flush = 8;
					state = 1;
				}
				break;

			case 1:
				if (num_bytes != 0)
				{
					if (hex_file_addr > hex_file_depth)
					{
						hex_file_depth = hex_file_addr;
					}
					
					raw_addr[raw_idx] =	hex_file_addr;
					raw_data[raw_idx] = 	(hex2bin(buffer[0]) << 4) +
								(hex2bin(buffer[1]));
								
					raw_idx++;
					hex_file_addr++;
					num_bytes--;
					flush = 2;
					
					if (num_bytes == 0)
					{
						state = 0;
					}
				}
				else
				{
					state = 0;
				}

				break;
				
			default:
				state = 0;
				break;
		}
		
		for (idx = 1; idx < flush; idx++)
			load_buffer();
	}

	for (idx = 0; idx < raw_idx; idx++)
	{
		putchar(bin2hex((raw_data[idx] >> 4) & 0x0F));
		putchar(bin2hex((raw_data[idx] >> 0) & 0x0F));

		crlf();
	}

	//return(0);

}


s16 load_buffer(void)
{
	s16 tmp;
	
	for (tmp = 0; tmp < BUF_SIZE-1; tmp++)
		buffer[tmp] = buffer[tmp+1];

	for (tmp = 0; tmp < BUF_SIZE-1; tmp++)
		eof_buf[tmp] = eof_buf[tmp+1];

	if (eof_buf[BUF_SIZE-1] != EOF)	//
	{
		tmp = getchar();

		//make ucase
		if((tmp >= 0x61) && (tmp <= 0x7A))
			tmp = tmp - 0x20;

	}
	else
	{
		tmp = EOF;
	}
		
	buffer[BUF_SIZE-1] = tmp;
	eof_buf[BUF_SIZE-1] = tmp;

	return eof_buf[0];
}

void crlf(void)
{
	putchar(0x0D);
	putchar(0x0A);
}

u08 hex2bin(u08 hex_digit)
{
	u08 nibble;

	if ((hex_digit >= 0x30) && (hex_digit <= 0x39))
		nibble = hex_digit - 0x30;
	else
		if ((hex_digit >= 0x41) && (hex_digit <= 0x46))
			nibble = hex_digit - 0x37;
		else
			nibble = 0xFF;
		
	return nibble;
}

u08 bin2hex(u08 nibble)
{
	u08 hex_digit;

	if (nibble < 0x0A)
		hex_digit = nibble + 0x30;
	else
		hex_digit = nibble + 0x37;

	return hex_digit;
}

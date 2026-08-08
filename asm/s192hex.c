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
// Description: Converts a Motorola S1-record (S19) file into a readmemh-
// style hex file. Address range, byte-lane (all/even/odd), output width
// (8/16-bit), and the unused-address fill pattern are all runtime flags.
//
// This supersedes the old s192hex8_offset0x0000/0x8000 [_even|_odd] family
// of hardcoded single-purpose programs. Written against plain ISO C89
// library calls only (stdio/stdlib/string/ctype) -- no getopt, no POSIX
// headers -- so it builds with any standard-conforming C compiler.
//
//////////////////////////////////////////////////////////////////////////////
// History:
// 07.28.2026 - Kevin Phillipson
//   Initial version. Consolidates the s192hex8_offset* family into one
//   flag-driven tool (-s/-e/-l/-w) and adds 16-bit output width.
//   Reworked again same day: dropped stdin/stdout in favor of required
//   -i/-o file arguments, added selectable fill pattern (-f deadbeef|ff|00),
//   replaced the original's byte-count-only S1 parsing with full checksum
//   and hex-digit validation, and replaced the old parallel-array-plus-
//   linear-scan memory model (which had no bound on the number of S1 data
//   bytes it could accept) with a direct-mapped 64KB image that can't
//   overflow regardless of input.
//
//////////////////////////////////////////////////////////////////////////////
// [TURBO9_HEADER_END]

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>


////////////////////////////////////// Type Defs
//
typedef unsigned char  u08;
typedef signed char    s08;
typedef unsigned short u16;
typedef signed short   s16;
typedef unsigned long  u32;
typedef signed long    s32;

enum lane_e { LANE_ALL, LANE_EVEN, LANE_ODD };
enum fill_e { FILL_DEADBEEF, FILL_FF, FILL_00 };


////////////////////////////////////// Constants
//
#define MEM_SIZE      0x10000  // full 16-bit address space
#define LINE_MAX_LEN  1024     // generous headroom over the largest legal
                                // S1 line (2 + 2 + 4 + 252*2 + 2 = 514 chars)


////////////////////////////////////// Function Prototypes
//
static int  hex2bin(char c);
static int  hex_byte(const char *s, u08 *out);
static int  parse_s1_line(const char *line, long line_no);
static u08  fill_byte(u32 addr, enum fill_e fill);
static u08  get_byte(u32 addr, enum fill_e fill);
static void emit_hex8(FILE *f_out, u08 byte);
static void emit_hex16(FILE *f_out, u16 word);
static const char *get_value(int argc, char **argv, int *idx, const char *flag);
static void usage(const char *prog_name);


////////////////////////////////////// Global Storage
//
// Direct-mapped image of the full 16-bit address space plus a parallel
// "was this address actually written by the S19 file" flag. Indexing by
// address instead of appending to a parallel (addr,data) list -- as the
// original tool did -- means storage is fixed at 128KB regardless of input
// and can never overflow, and duplicate/overlapping S1 records naturally
// resolve to "last write wins" with no extra bookkeeping.
//
static u08 mem[MEM_SIZE];
static u08 mem_used[MEM_SIZE];


int main(int argc, char **argv)
{
  const char *in_name  = NULL;
  const char *out_name = NULL;
  FILE *f_in;
  FILE *f_out;

  u32 start_addr   = 0x0000;
  u32 end_addr     = 0xFFFF;
  int width        = 8;
  enum lane_e lane = LANE_ALL;
  enum fill_e fill = FILL_DEADBEEF;
  int lane_given   = 0;

  char line[LINE_MAX_LEN];
  long line_no = 0;
  u32 addr_idx;
  int i;

  //////////////////////////////////////// Parse arguments
  //
  for (i = 1; i < argc; i++)
  {
    const char *arg = argv[i];
    const char *val;

    if (strcmp(arg, "-h") == 0)
    {
      usage(argv[0]);
      return 0;
    }
    else if (strcmp(arg, "-i") == 0)
    {
      if ((val = get_value(argc, argv, &i, "-i")) == NULL) { usage(argv[0]); return 1; }
      in_name = val;
    }
    else if (strcmp(arg, "-o") == 0)
    {
      if ((val = get_value(argc, argv, &i, "-o")) == NULL) { usage(argv[0]); return 1; }
      out_name = val;
    }
    else if (strcmp(arg, "-s") == 0)
    {
      if ((val = get_value(argc, argv, &i, "-s")) == NULL) { usage(argv[0]); return 1; }
      start_addr = strtoul(val, NULL, 16);
    }
    else if (strcmp(arg, "-e") == 0)
    {
      if ((val = get_value(argc, argv, &i, "-e")) == NULL) { usage(argv[0]); return 1; }
      end_addr = strtoul(val, NULL, 16);
    }
    else if (strcmp(arg, "-w") == 0)
    {
      if ((val = get_value(argc, argv, &i, "-w")) == NULL) { usage(argv[0]); return 1; }
      width = (int)strtol(val, NULL, 10);
    }
    else if (strcmp(arg, "-l") == 0)
    {
      if ((val = get_value(argc, argv, &i, "-l")) == NULL) { usage(argv[0]); return 1; }
      lane_given = 1;
      if      (strcmp(val, "all")  == 0) lane = LANE_ALL;
      else if (strcmp(val, "even") == 0) lane = LANE_EVEN;
      else if (strcmp(val, "odd")  == 0) lane = LANE_ODD;
      else
      {
        fprintf(stderr, "Error: -l must be all, even, or odd\n");
        usage(argv[0]);
        return 1;
      }
    }
    else if (strcmp(arg, "-f") == 0)
    {
      if ((val = get_value(argc, argv, &i, "-f")) == NULL) { usage(argv[0]); return 1; }
      if      (strcmp(val, "deadbeef") == 0) fill = FILL_DEADBEEF;
      else if (strcmp(val, "ff")       == 0) fill = FILL_FF;
      else if (strcmp(val, "00")       == 0) fill = FILL_00;
      else
      {
        fprintf(stderr, "Error: -f must be deadbeef, ff, or 00\n");
        usage(argv[0]);
        return 1;
      }
    }
    else
    {
      fprintf(stderr, "Error: unknown argument '%s'\n", arg);
      usage(argv[0]);
      return 1;
    }
  }

  //////////////////////////////////////// Validate arguments
  //
  if (!in_name || !out_name)
  {
    fprintf(stderr, "Error: -i and -o are both required\n");
    usage(argv[0]);
    return 1;
  }

  if ((width != 8) && (width != 16))
  {
    fprintf(stderr, "Error: -w must be 8 or 16\n");
    usage(argv[0]);
    return 1;
  }

  if ((width == 16) && lane_given)
  {
    fprintf(stderr, "Error: -l is only valid with -w 8\n");
    usage(argv[0]);
    return 1;
  }

  if ((start_addr > 0xFFFF) || (end_addr > 0xFFFF))
  {
    fprintf(stderr, "Error: -s/-e must be within 0000-FFFF\n");
    usage(argv[0]);
    return 1;
  }

  if (start_addr > end_addr)
  {
    fprintf(stderr, "Error: start address must be <= end address\n");
    usage(argv[0]);
    return 1;
  }

  //////////////////////////////////////// Open files
  //
  if ((f_in = fopen(in_name, "r")) == NULL)
  {
    fprintf(stderr, "Error: could not open input file '%s': %s\n", in_name, strerror(errno));
    return 1;
  }

  if ((f_out = fopen(out_name, "w")) == NULL)
  {
    fprintf(stderr, "Error: could not open output file '%s': %s\n", out_name, strerror(errno));
    fclose(f_in);
    return 1;
  }

  //////////////////////////////////////// Parse S19 input
  //
  // Read line by line rather than as a raw byte stream: S-records are
  // inherently line-oriented, and this lets each record be validated
  // (hex digits, checksum) as a complete unit instead of trusting bytes
  // as they arrive. Lines that don't start with "S1" -- S0 headers, S9
  // termination records, blank lines -- are silently skipped, since only
  // S1 (16-bit address data) records carry load data this tool cares
  // about.
  //
  memset(mem_used, 0, sizeof(mem_used));

  while (fgets(line, sizeof(line), f_in) != NULL)
  {
    size_t cut;

    line_no++;

    cut = strcspn(line, "\r\n");
    if ((line[cut] == '\0') && (cut == sizeof(line) - 1) && !feof(f_in))
    {
      fprintf(stderr, "Error: line %ld exceeds max supported length (%d)\n",
              line_no, LINE_MAX_LEN - 1);
      fclose(f_in);
      fclose(f_out);
      return 1;
    }
    line[cut] = '\0';

    if ((line[0] != 'S') || (line[1] != '1'))
      continue;

    if (parse_s1_line(line, line_no) != 0)
    {
      fclose(f_in);
      fclose(f_out);
      return 1;
    }
  }

  fclose(f_in);

  //////////////////////////////////////// Emit hex output
  //
  if (width == 8)
  {
    for (addr_idx = start_addr; addr_idx <= end_addr; addr_idx++)
    {
      if ((lane == LANE_ALL) ||
          ((lane == LANE_EVEN) && ((addr_idx & 1) == 0)) ||
          ((lane == LANE_ODD)  && ((addr_idx & 1) == 1)))
      {
        emit_hex8(f_out, get_byte(addr_idx, fill));
      }
    }
  }
  else // width == 16
  {
    // Pairs are big-endian (even address = high byte, odd = low byte),
    // matching Turbo9/6809 byte order and the -l even/-l odd split. If the
    // 16-bit address space wraps past 0xFFFF mid-pair, the low byte comes
    // from address 0x0000 -- consistent with treating memory as a 64KB ring
    // rather than special-casing the boundary.
    for (addr_idx = start_addr; addr_idx <= end_addr; addr_idx += 2)
    {
      u08 hi = get_byte(addr_idx,     fill);
      u08 lo = get_byte(addr_idx + 1, fill);
      emit_hex16(f_out, (u16)(((u16)hi << 8) | lo));
    }
  }

  fclose(f_out);

  return 0;
}


////////////////////////////////////// hex2bin
//
// Converts one ASCII hex digit to its 0-15 value. Returns -1 for anything
// else so callers can distinguish "invalid input" from a legal nibble
// value, instead of the original tool's 0xFF sentinel that nobody checked.
//
static int hex2bin(char c)
{
  if ((c >= '0') && (c <= '9')) return c - '0';
  if ((c >= 'A') && (c <= 'F')) return c - 'A' + 10;
  if ((c >= 'a') && (c <= 'f')) return c - 'a' + 10;
  return -1;
}

////////////////////////////////////// hex_byte
//
// Converts the two hex digits at s[0],s[1] into *out. Returns 0 on
// success, -1 if either digit is not valid hex.
//
static int hex_byte(const char *s, u08 *out)
{
  int hi = hex2bin(s[0]);
  int lo = hex2bin(s[1]);

  if ((hi < 0) || (lo < 0))
    return -1;

  *out = (u08)((hi << 4) | lo);
  return 0;
}

////////////////////////////////////// parse_s1_line
//
// Parses one "S1cciaaaa[dd...]ss" record: byte count, 16-bit address, data
// bytes, and checksum. Validates hex digits, minimum/actual record length,
// and the checksum (one's complement of the low byte of count+addr+data),
// so a corrupted or hand-edited S19 file is rejected with a line number
// instead of silently producing wrong memory contents. On success, the
// data bytes are written into mem[]/mem_used[]. Returns 0 on success, -1
// on a fatal parse error (message already printed to stderr).
//
static int parse_s1_line(const char *line, long line_no)
{
  size_t len = strlen(line);
  u08 byte_count;
  u08 data_len;
  u08 addr_hi, addr_lo;
  u16 addr;
  u08 sum;
  size_t i;

  if (len < 8) // "S1" + count(2) + addr(4), minimum before any data/checksum
  {
    fprintf(stderr, "Error: line %ld: S1 record too short\n", line_no);
    return -1;
  }

  if (hex_byte(line + 2, &byte_count) != 0)
  {
    fprintf(stderr, "Error: line %ld: invalid hex in byte count field\n", line_no);
    return -1;
  }

  if (byte_count < 3) // count includes 2 address bytes + 1 checksum byte
  {
    fprintf(stderr, "Error: line %ld: byte count %u too small (must be >= 3)\n",
            line_no, (unsigned)byte_count);
    return -1;
  }
  data_len = byte_count - 3;

  if (len < (size_t)(8 + (size_t)data_len * 2 + 2))
  {
    fprintf(stderr, "Error: line %ld: record truncated (expected %u data bytes)\n",
            line_no, (unsigned)data_len);
    return -1;
  }

  if ((hex_byte(line + 4, &addr_hi) != 0) || (hex_byte(line + 6, &addr_lo) != 0))
  {
    fprintf(stderr, "Error: line %ld: invalid hex in address field\n", line_no);
    return -1;
  }
  addr = (u16)(((u16)addr_hi << 8) | addr_lo);

  sum = byte_count;
  sum = (u08)(sum + addr_hi);
  sum = (u08)(sum + addr_lo);

  for (i = 0; i < data_len; i++)
  {
    u08 data_byte;

    if (hex_byte(line + 8 + i * 2, &data_byte) != 0)
    {
      fprintf(stderr, "Error: line %ld: invalid hex in data field\n", line_no);
      return -1;
    }

    mem[(u16)(addr + i)]      = data_byte;
    mem_used[(u16)(addr + i)] = 1;
    sum = (u08)(sum + data_byte);
  }

  {
    u08 checksum_field;
    u08 checksum_calc = (u08)(~sum);

    if (hex_byte(line + 8 + (size_t)data_len * 2, &checksum_field) != 0)
    {
      fprintf(stderr, "Error: line %ld: invalid hex in checksum field\n", line_no);
      return -1;
    }

    if (checksum_field != checksum_calc)
    {
      fprintf(stderr, "Error: line %ld: checksum mismatch (expected %02X, got %02X)\n",
              line_no, checksum_calc, checksum_field);
      return -1;
    }
  }

  return 0;
}

////////////////////////////////////// fill_byte
//
// Value used for addresses the S19 file never wrote. DEADBEEF cycles by
// address so gaps are visually obvious in a hex dump/waveform; ff/00 are
// flat fills for tools or memory models that expect a specific erased-
// state value.
//
static u08 fill_byte(u32 addr, enum fill_e fill)
{
  static const u08 deadbeef[4] = { 0xDE, 0xAD, 0xBE, 0xEF };

  switch (fill)
  {
    case FILL_FF:       return 0xFF;
    case FILL_00:       return 0x00;
    case FILL_DEADBEEF:
    default:            return deadbeef[addr % 4];
  }
}

////////////////////////////////////// get_byte
//
static u08 get_byte(u32 addr, enum fill_e fill)
{
  if (mem_used[(u16)addr])
    return mem[(u16)addr];

  return fill_byte(addr, fill);
}

////////////////////////////////////// emit_hex8 / emit_hex16
//
static void emit_hex8(FILE *f_out, u08 byte)
{
  fprintf(f_out, "%02X\n", byte);
}

static void emit_hex16(FILE *f_out, u16 word)
{
  fprintf(f_out, "%04X\n", word);
}

////////////////////////////////////// get_value
//
// Returns argv[*idx + 1] and advances *idx past it, or prints an error and
// returns NULL if flag was the last argument.
//
static const char *get_value(int argc, char **argv, int *idx, const char *flag)
{
  if (*idx + 1 >= argc)
  {
    fprintf(stderr, "Error: %s requires a value\n", flag);
    return NULL;
  }
  *idx += 1;
  return argv[*idx];
}

////////////////////////////////////// usage
//
static void usage(const char *prog_name)
{
  fprintf(stderr,
    "Usage: %s -i infile -o outfile [-s start] [-e end] [-w 8|16] [-l all|even|odd] [-f deadbeef|ff|00]\n"
    "\n"
    "  -i FILE   input S19 file                              (required)\n"
    "  -o FILE   output hex file                              (required)\n"
    "  -s ADDR   start address, hex                    (default: 0000)\n"
    "  -e ADDR   end address, hex                       (default: FFFF)\n"
    "  -w WIDTH  output width: 8 or 16                  (default: 8)\n"
    "  -l LANE   byte lane: all/even/odd, only valid with -w 8 (default: all)\n"
    "  -f FILL   unused-address fill: deadbeef/ff/00    (default: deadbeef)\n"
    "  -h        show this help\n"
    "\n"
    "Examples:\n"
    "  %s -i prog.s19 -o prog.hex                       8-bit, full 64KB range\n"
    "  %s -i prog.s19 -o prog_even.hex -l even          8-bit, even bytes only\n"
    "  %s -i prog.s19 -o prog.hex -s 8000 -e FFFF       8-bit, upper half only\n"
    "  %s -i prog.s19 -o prog16.hex -w 16               16-bit words, big-endian\n"
    "  %s -i prog.s19 -o prog.hex -f ff                 fill unused bytes with FF\n",
    prog_name, prog_name, prog_name, prog_name, prog_name, prog_name);
}

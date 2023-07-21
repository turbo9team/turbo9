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
// Description: Logging function library.
//
//////////////////////////////////////////////////////////////////////////////
// History:
// 07.14.2023 - Kevin Phillipson
//   File header added
//
//////////////////////////////////////////////////////////////////////////////
// [TURBO9_HEADER_END]

#include <stdio.h>
#include <stdarg.h>
#include <time.h>
#include "log.h"

#define LOG_PATH "./urtl_debug.log"
extern int log_level;

void clear_log(int level)
{
  FILE *fp;

  if(level > LOG_OFF && level <= LOG_DEBUG_LEVEL)
  {
    fp = fopen(LOG_PATH, "w");
    fclose(fp);
  }
}

void write_log(const char * caller_name, int level, int timestamp, int show_caller, char * log_entry, ...)
{
  FILE *fp;
  time_t rawtime;
  char log_str[256] = {0};
  va_list args;
  char timestr[80];
  char marker[256];
  struct tm *tmp;

  va_start(args, log_entry);
  vsprintf(log_str, log_entry, args);
  va_end(args);

  if(log_level >= level)
  {
    fp = fopen(LOG_PATH, "a");
    if(fp)
    {
      rawtime = time(NULL);
      tmp = localtime(&rawtime);
      if(strftime(timestr, sizeof(timestr), "%a, %d %b %Y %T %z", tmp) == 0)
      {
        fprintf(fp, "strftime returned 0");
      }

      if(timestamp)
        sprintf(marker, "[%s : %s]: ", timestr, caller_name);
      else
        sprintf(marker, "[%s]: ", caller_name);

        fprintf(fp, "%s%s", show_caller? marker: "", log_str);

      fclose(fp);
    }
  }
}


/*
 ****************************************************************************
 *
 *                   "DHRYSTONE" Benchmark Program
 *                   -----------------------------
 *                                                                            
 *  Version:    C, Version 2.1
 *                                                                            
 *  File:       dhry_1.c (part 2 of 3)
 *
 *  Date:       May 25, 1988
 *
 *  Author:     Reinhold P. Weicker
 *
 ****************************************************************************
 */

/***************************************************************************
 * Adapted for embedded microcontrollers by Graham Davies, ECROS Technology.
 *
 * Further adapted for Turbo9 (pipelined 6809 microprocessor)
 * Reverted as much as possible back to original dhrystone 2.1 (diff to review)
 * All timing related code and replaced with simple clock counter HW
 * turbo9_lib.* contains necessary std_lib functions
 * By Kevin Phillipson & Michael Rywalt
 *
 **************************************************************************/

#include "dhry.h"
/*#include <stdlib.h> */  /* Turbo9: remove */
/*#include <stdio.h>  */  /* Turbo9: remove */
/*#include <string.h> */  /* Turbo9: remove */
#include "lib.h"

/* Global Variables: */

static char space1[50];
static char space2[50];

Rec_Pointer     Ptr_Glob,
                Next_Ptr_Glob;
int             Int_Glob;
Boolean         Bool_Glob;
char            Ch_1_Glob,
                Ch_2_Glob;
int             Arr_1_Glob [50];
int             Arr_2_Glob [50] [50];

#ifndef REG
        Boolean Reg = false;
#define REG
        /* REG becomes defined as empty */
        /* i.e. no register variables   */
#else
        Boolean Reg = true;
#endif


/* variables for time measurement: */

/* Turbo9: removed all timing variables */

/* end of variables for time measurement */

void Proc_1( REG Rec_Pointer Ptr_Val_Par );
void Proc_2( One_Fifty * Int_Par_Ref );
void Proc_3( Rec_Pointer * Ptr_Ref_Par );
void Proc_4( void );
void Proc_5( void );

SECTION_START
 int main( void ) /* Turbo9: added "prog_start */
/*****/

  /* main program, corresponds to procedures        */
  /* Main and Proc_0 in the Ada version             */
{

  COUNTER_VAR

        One_Fifty       Int_1_Loc;
  REG   One_Fifty       Int_2_Loc;
        One_Fifty       Int_3_Loc;
  REG   char            Ch_Index;
        Enumeration     Enum_Loc;
        Str_30          Str_1_Loc;
        Str_30          Str_2_Loc;
  REG   int             Run_Index;
  REG   int             Number_Of_Runs;

  /* Initializations */

  Next_Ptr_Glob = (Rec_Pointer) space1;
  Ptr_Glob = (Rec_Pointer) space2;

  //Next_Ptr_Glob = (Rec_Pointer) emalloc (sizeof (Rec_Type));
  //Ptr_Glob = (Rec_Pointer) emalloc (sizeof (Rec_Type));

  setup();
   

  Ptr_Glob->Ptr_Comp                    = Next_Ptr_Glob;
  Ptr_Glob->Discr                       = Ident_1;
  Ptr_Glob->variant.var_1.Enum_Comp     = Ident_3;
  Ptr_Glob->variant.var_1.Int_Comp      = 40;
  strcpy (Ptr_Glob->variant.var_1.Str_Comp, 
          "DHRYSTONE PROGRAM, SOME STRING");
  strcpy (Str_1_Loc, "DHRYSTONE PROGRAM, 1'ST STRING");

  Arr_2_Glob [8][7] = 10;
        /* Was missing in published program. Without this statement,    */
        /* Arr_2_Glob [8][7] would have an undefined value.             */
        /* Warning: With 16-Bit processors and Number_Of_Runs > 32000,  */
        /* overflow may occur for this array element.                   */

  acia_print_str ("\n");
  acia_print_str ("Dhrystone Benchmark, Version 2.1 (Language: C, ");
  acia_print_str ("Compiler: ");
#ifdef _VBCC
  acia_print_str ("vbcc");
#else
  acia_print_str (COMPILER);
#endif
  acia_print_str (")\n");

  if (Reg)
  {
    acia_print_str ("Program compiled with 'register' attribute\n");
    acia_print_str ("\n");
  }
  else
  {
    acia_print_str ("Program compiled without 'register' attribute\n");
    acia_print_str ("\n");
  }

  Number_Of_Runs = 200; /* Turbo9: hardcode the number of runs */
  acia_print_str ("Execution starts, ");
  acia_print_signed_long (Number_Of_Runs);
  acia_print_str (" runs through Dhrystone\n");

  /***************/
  /* Start timer */
  /***************/
 
  COUNTER_START

  for (Run_Index = 1; Run_Index <= Number_Of_Runs; ++Run_Index)
  {
    Proc_5();
    Proc_4();
      /* Ch_1_Glob == 'A', Ch_2_Glob == 'B', Bool_Glob == true */
    Int_1_Loc = 2;
    Int_2_Loc = 3;
    strcpy (Str_2_Loc, "DHRYSTONE PROGRAM, 2'ND STRING");
    Enum_Loc = Ident_2;
    Bool_Glob = ! Func_2 (Str_1_Loc, Str_2_Loc);
      /* Bool_Glob == 1 */
    while (Int_1_Loc < Int_2_Loc)  /* loop body executed once */
    {
      Int_3_Loc = 5 * Int_1_Loc - Int_2_Loc;
      //Int_3_Loc = emul(5, Int_1_Loc) - Int_2_Loc;

        /* Int_3_Loc == 7 */
      Proc_7 (Int_1_Loc, Int_2_Loc, &Int_3_Loc);
        /* Int_3_Loc == 7 */
      Int_1_Loc += 1;
    } /* while */
      /* Int_1_Loc == 3, Int_2_Loc == 3, Int_3_Loc == 7 */
    Proc_8 (Arr_1_Glob, Arr_2_Glob, Int_1_Loc, Int_3_Loc);
      /* Int_Glob == 5 */
    Proc_1 (Ptr_Glob);
    for (Ch_Index = 'A'; Ch_Index <= Ch_2_Glob; ++Ch_Index)
                             /* loop body executed twice */
    {
      if (Enum_Loc == Func_1 (Ch_Index, 'C'))
          /* then, not executed */
        {
        Proc_6 (Ident_1, &Enum_Loc);
        strcpy (Str_2_Loc, "DHRYSTONE PROGRAM, 3'RD STRING");
        Int_2_Loc = Run_Index;
        Int_Glob = Run_Index;
        }
    }
      /* Int_1_Loc == 3, Int_2_Loc == 3, Int_3_Loc == 7 */
    Int_2_Loc = Int_2_Loc * Int_1_Loc;
    //Int_2_Loc = emul(Int_2_Loc, Int_1_Loc);
    Int_1_Loc = Int_2_Loc / Int_3_Loc;
    //Int_1_Loc = idiv(Int_2_Loc, Int_3_Loc);
    Int_2_Loc = 7 * (Int_2_Loc - Int_3_Loc) - Int_1_Loc;
    //Int_2_Loc = emul(7, (Int_2_Loc - Int_3_Loc)) - Int_1_Loc;
      /* Int_1_Loc == 1, Int_2_Loc == 13, Int_3_Loc == 7 */
    Proc_2 (&Int_1_Loc);
      /* Int_1_Loc == 5 */

  } /* loop "for Run_Index" */

  /**************/
  /* Stop timer */
  /**************/
   
  COUNTER_STOP



  acia_print_str ("Execution ends\n");
  acia_print_str ("\n");
  acia_print_str ("Final values of the variables used in the benchmark:\n");
  acia_print_str ("\n");

  acia_print_str    ("Int_Glob:            ");
  acia_print_signed_long (Int_Glob);
  acia_print_str    ("\n        should be:   5\n");

  acia_print_str    ("Bool_Glob:           ");
  acia_print_signed_long (Bool_Glob);
  acia_print_str    ("\n        should be:   1\n");

  acia_print_str    ("Ch_1_Glob:           ");
  acia_put_char     (Ch_1_Glob);
  acia_print_str    ("\n        should be:   'A'\n");

  acia_print_str    ("Ch_2_Glob:           ");
  acia_put_char     (Ch_2_Glob);
  acia_print_str    ("\n        should be:   'B'\n");

  acia_print_str    ("Arr_1_Glob[8]:       ");
  acia_print_signed_long (Arr_1_Glob[8]);
  acia_print_str    ("\n        should be:   7\n");

  acia_print_str    ("Arr_2_Glob[8][7]:    ");
  acia_print_signed_long (Arr_2_Glob[8][7]);
  acia_print_str    ("\n        should be:   Number_Of_Runs + 10\n");

  acia_print_str    ("Ptr_Glob->\n");
  acia_print_str    ("  Ptr_Comp:          0x");
  acia_print_hex_16bit ((unsigned int)Ptr_Glob->Ptr_Comp);
  acia_print_str    ("\n        should be:   (implementation-dependent)\n");

  acia_print_str    ("  Discr:             ");
  acia_print_signed_long (Ptr_Glob->Discr);
  acia_print_str    ("\n        should be:   0\n");

  acia_print_str    ("  Enum_Comp:         ");
  acia_print_signed_long (Ptr_Glob->variant.var_1.Enum_Comp);
  acia_print_str    ("\n        should be:   2\n");

  acia_print_str    ("  Int_Comp:          ");
  acia_print_signed_long (Ptr_Glob->variant.var_1.Int_Comp);
  acia_print_str    ("\n        should be:   17\n");

  acia_print_str    ("  Str_Comp:          ");
  acia_print_str    (Ptr_Glob->variant.var_1.Str_Comp);
  acia_print_str    ("\n        should be:   DHRYSTONE PROGRAM, SOME STRING\n");

  acia_print_str    ("Next_Ptr_Glob->\n");
  acia_print_str    ("  Ptr_Comp:          0x");
  acia_print_hex_16bit ((unsigned int) Next_Ptr_Glob->Ptr_Comp);
  acia_print_str    ("\n        should be:   (implementation-dependent), same as above\n");

  acia_print_str    ("  Discr:             ");
  acia_print_signed_long (Next_Ptr_Glob->Discr);
  acia_print_str    ("\n        should be:   0\n");

  acia_print_str    ("  Enum_Comp:         ");
  acia_print_signed_long (Next_Ptr_Glob->variant.var_1.Enum_Comp);
  acia_print_str    ("\n        should be:   1\n");

  acia_print_str    ("  Int_Comp:          ");
  acia_print_signed_long (Next_Ptr_Glob->variant.var_1.Int_Comp);
  acia_print_str    ("\n        should be:   18\n");

  acia_print_str    ("  Str_Comp:          ");
  acia_print_str    (Next_Ptr_Glob->variant.var_1.Str_Comp);
  acia_print_str    ("\n        should be:   DHRYSTONE PROGRAM, SOME STRING\n");

  acia_print_str    ("Int_1_Loc:           ");
  acia_print_signed_long (Int_1_Loc);
  acia_print_str    ("\n        should be:   5\n");

  acia_print_str    ("Int_2_Loc:           ");
  acia_print_signed_long (Int_2_Loc);
  acia_print_str    ("\n        should be:   13\n");

  acia_print_str    ("Int_3_Loc:           ");
  acia_print_signed_long (Int_3_Loc);
  acia_print_str    ("\n        should be:   7\n");

  acia_print_str    ("Enum_Loc:            ");
  acia_print_signed_long (Enum_Loc);
  acia_print_str    ("\n        should be:   1\n");

  acia_print_str    ("Str_1_Loc:           ");
  acia_print_str    (Str_1_Loc);
  acia_print_str    ("\n        should be:   DHRYSTONE PROGRAM, 1'ST STRING\n");

  acia_print_str    ("Str_2_Loc:           ");
  acia_print_str    (Str_2_Loc);
  acia_print_str    ("\n        should be:   DHRYSTONE PROGRAM, 2'ND STRING\n");
  acia_print_str    ("\n");

  acia_print_str ("Number of runs through Dhrystone: ");
  acia_print_signed_long (Number_Of_Runs);
  acia_print_str ("\n\n");
  
  COUNTER_PRINT

  acia_print_str      ("\n");

  teardown();

  return ( 0 );
}


void Proc_1( REG Rec_Pointer Ptr_Val_Par )
/******************/
    /* executed once */
{
  REG Rec_Pointer Next_Record = Ptr_Val_Par->Ptr_Comp;  
                                        /* == Ptr_Glob_Next */
  /* Local variable, initialized with Ptr_Val_Par->Ptr_Comp,    */
  /* corresponds to "rename" in Ada, "with" in Pascal           */
  
  structassign (*Ptr_Val_Par->Ptr_Comp, *Ptr_Glob); 
  Ptr_Val_Par->variant.var_1.Int_Comp = 5;
  Next_Record->variant.var_1.Int_Comp 
        = Ptr_Val_Par->variant.var_1.Int_Comp;
  Next_Record->Ptr_Comp = Ptr_Val_Par->Ptr_Comp;
  Proc_3 (&Next_Record->Ptr_Comp);
    /* Ptr_Val_Par->Ptr_Comp->Ptr_Comp 
                        == Ptr_Glob->Ptr_Comp */
  if (Next_Record->Discr == Ident_1)
    /* then, executed */
  {
    Next_Record->variant.var_1.Int_Comp = 6;
    Proc_6 (Ptr_Val_Par->variant.var_1.Enum_Comp, 
           &Next_Record->variant.var_1.Enum_Comp);
    Next_Record->Ptr_Comp = Ptr_Glob->Ptr_Comp;
    Proc_7 (Next_Record->variant.var_1.Int_Comp, 10, 
           &Next_Record->variant.var_1.Int_Comp);
  }
  else /* not executed */
    structassign (*Ptr_Val_Par, *Ptr_Val_Par->Ptr_Comp);
} /* Proc_1 */


void Proc_2( One_Fifty * Int_Par_Ref )
/******************/
    /* executed once */
    /* *Int_Par_Ref == 1, becomes 4 */
{
  One_Fifty  Int_Loc;  
  Enumeration   Enum_Loc;

  Int_Loc = *Int_Par_Ref + 10;
  do /* executed once */
    if (Ch_1_Glob == 'A')
      /* then, executed */
    {
      Int_Loc -= 1;
      *Int_Par_Ref = Int_Loc - Int_Glob;
      Enum_Loc = Ident_1;
    } /* if */
  while (Enum_Loc != Ident_1); /* true */
} /* Proc_2 */


void Proc_3( Rec_Pointer * Ptr_Ref_Par )
/******************/
    /* executed once */
    /* Ptr_Ref_Par becomes Ptr_Glob */
{
  if (Ptr_Glob != Null)
    /* then, executed */
    *Ptr_Ref_Par = Ptr_Glob->Ptr_Comp;
  Proc_7 (10, Int_Glob, &Ptr_Glob->variant.var_1.Int_Comp);
} /* Proc_3 */


void Proc_4( void ) /* without parameters */
/*******/
    /* executed once */
{
  Boolean Bool_Loc;

  Bool_Loc = Ch_1_Glob == 'A';
  Bool_Glob = Bool_Loc | Bool_Glob;
  Ch_2_Glob = 'B';
} /* Proc_4 */


void Proc_5( void ) /* without parameters */
/*******/
    /* executed once */
{
  Ch_1_Glob = 'A';
  Bool_Glob = false;
} /* Proc_5 */


        /* Procedure for the assignment of structures,          */
        /* if the C compiler doesn't support this feature       */
#ifdef  NOSTRUCTASSIGN
memcpy (d, s, l)
register char   *d;
register char   *s;
register int    l;
{
        while (l--) *d++ = *s++;
}
#endif



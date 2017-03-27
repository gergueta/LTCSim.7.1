/* padsbackf.c - File Reader for PADS Schematic Back Annotation */

/*  Copyright 1993 Xilinx Coporation, 2000 Cohesion Systems, inc. All Rights Reserved.
 *
 * This program is protected under the copyright laws as a published work.
 * It may not be copied, reproduced, further distributed, adaptations
 * made from the same, or used to prepare derivative works, without the
 * prior written consent of Cohesion Systems, inc
 *
 * History:
 *    5/05/93 - Included in Version 2.5
 */

#include "stdafx.h"
#include <string.h>
#include "spikproc.h"
#include "scback.h"


/**************************** Do Changes **********************/

static char *strip( char* string )
{ char *cp;

     /* Strip leading white space
      */
   cp = string;
   while ( ( *cp == ' ' ) || ( *cp == '\t' ) )
      ++cp;

   return cp;
 }

static int getPADSLine( char* buff, FILE* file, char* command, int* lineno )
 { char word[64];

   while ( TRUE )
    {
      if ( fgets( buff, 256, file ) == NULL )
       { *buff = '\0';
          return FALSE;
       }

      ++(*lineno);
      if ( sscanf( buff, "%s", word ) != 1 ) /* blank line */
         continue;
      if ( *word == '*' )    /* beginning of command line */
       { if ( !strnicmp( word, "*REM", 4 ) ) /* remark line */
            continue;
         if ( !strnicmp( word, command, 5 ) ) /* same command */
            continue;
         else                                 /* new command */
            return FALSE;
       }
      return TRUE;
    }
 }

int DoPADSChanges( FILE* backfile )
 { char buff[256], type[64];
   char name[64], value[256], value2[256];
   char *bptr, *split;
   int count, ok, done, status;

   ok = TRUE;
   count = 0;
   done = ( fgets( buff, 256, backfile ) == NULL );
   while ( !done )
    {
      if ( sscanf( buff, "%s", type ) != 1 )           /* blank line */
       { ++count;
         done = ( fgets( buff, 256, backfile ) == NULL );
       }
      else if ( !strnicmp( type, "*REM", 4 ) )         /* REMARK == NO-OP */
       { ++count;
         done = ( fgets( buff, 256, backfile ) == NULL );
       }
      else if ( !strnicmp( type, "*END", 4 ) )    /* END, Ignore */
       { ++count;
         done = ( fgets( buff, 256, backfile ) == NULL );
       }
      else if ( !strnicmp( type, "*PADS", 5 ) )   /* Header, Ignore */
       { ++count;
         done = ( fgets( buff, 256, backfile ) == NULL );
       }
      else if ( !strnicmp( type, "*REN", 4 ) )     /* Rename Component */
       { while ( getPADSLine( buff, backfile, type, &count ) )
          { if ( sscanf( buff, "%s%s", value, value2 ) != 2 )
             { sprintf( buff, "Rename Error at line %d", count );
               ErrorMsg ( buff );
               return FALSE;
             }
            ok = Rename( value, value2, count );
          }
       }
      else if ( !strnicmp( type, "*SWPP", 5 ) )     /* Swap Pins */
       { while ( getPADSLine( buff, backfile, type, &count ) )
          { bptr = buff;
            status = GetWord( &bptr, name );
            if ( !status )
             { sprintf( buff, "Swap Pins Error at line %d", count );
               ErrorMsg ( buff );
               return FALSE;
             }

               /* The line contains a series of pin pairs.  The pins in
                * each pair are separated by a '.'.
                */
            while ( GetWord ( &bptr, value ) )
             {
               split = strchr( value, '.' );
               *split++ = '\0';
               ok = SwapPins( name, value, split, count );
             }
          }
       }
      else if ( !strnicmp( type, "*SWPG", 5 ) )     /* Swap Gates */
       { while ( getPADSLine( buff, backfile, type, &count ) )
          { if ( sscanf( buff, "%s%s", value, value2 ) != 2 )
             { sprintf( buff, "Swap Gates Error at line %d", count );
               ErrorMsg ( buff );
               return FALSE;
             }

            ok = SwapSection( value, value2, '.', count );
          }
       }
      else
       { sprintf( buff, "Unrecognized header '%s' at line %d", type, count );
         ErrorMsg ( buff );
         return FALSE;
       } /* End else */

      if ( !ok )
         break;
    } /* End while */

   return ok;
 } /* End DoChanges */

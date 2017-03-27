/* ring.c - File Reader for RINF (Racal) Schematic Back Annotation */

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

int DoRINFChanges( FILE* backfile )
 { char buff[256], type[64], *cptr;
   char name[64], value[256], value2[256];
   int count, ok, done;

   ok = TRUE;
   count = 1;
   done = ( fgets( buff, 256, backfile ) == NULL );
   while ( !done )
    {
      if ( sscanf( buff, "%s", type ) != 1 )           /* blank line */
       { ++count;
         done = ( fgets( buff, 256, backfile ) == NULL );
         continue;
       }
      else if ( !strnicmp( type, ".REM", 4 ) )         /* REMARK == NO-OP */
       { ++count;
         done = ( fgets( buff, 256, backfile ) == NULL );
         continue;
       }
      else if ( !strnicmp( type, ".HEA", 4 ) )    /* Header, Ignore */
       { ++count;
         done = ( fgets( buff, 256, backfile ) == NULL );
         continue;
       }
      else if ( !strnicmp( type, ".TIM", 4 ) )    /* Header info , Ignore */
       { ++count;
         done = ( fgets( buff, 256, backfile ) == NULL );
         continue;
       }
      else if ( !strnicmp( type, ".END", 4 ) )    /* END, Ignore */
       { ++count;
         done = ( fgets( buff, 256, backfile ) == NULL );
         continue;
       }
      else if ( !strnicmp( type, ".REN", 4 ) )     /* Rename Component */
       { if ( sscanf( buff, "%*s%s%s", value, value2 ) != 2 )
          { sprintf( buff, "Rename Error at line %d", count );
            ErrorMsg ( buff );
            return FALSE;
          }
         ok = Rename( value, value2, count );
       }
      else if ( !strnicmp( type, ".SWA_P", 6 ) )     /* Swap Pins */
       { if ( sscanf( buff, "%*s%s%s%s", name, value, value2 ) != 3 )
          { sprintf( buff, "Swap Pins Error at line %d", count );
            ErrorMsg ( buff );
            return FALSE;
          }
         ok = SwapPins( name, value, value2, count );
       }
      else if ( !strnicmp( type, ".SWA_G", 6 ) )     /* Swap Gates */
       { cptr = buff + strlen( type );
         if ( !GetWord( &cptr, value ) || !GetWord( &cptr, value2 ) )
          { sprintf( buff, "Swap Gates Error at line %d", count );
            ErrorMsg ( buff );
            return FALSE;
          }

         ok = SwapGates( value, value2, cptr, count );
       }
      else
       { sprintf( buff, "Unrecognized header '%s' at line %d", type, count );
         ErrorMsg ( buff );
         return FALSE;
       } /* End else */

      if ( !ok )
         break;

      ++count;
      done = ( fgets( buff, 256, backfile ) == NULL );
    } /* End while */

   return ok;
 } /* End DoChanges */

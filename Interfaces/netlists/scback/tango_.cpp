/* tango.c - File Reader for Tango Schematic Back Annotation */

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

static void unquote( char* string )
 { char *from, *to;

   from = to = string;
   while ( *from != '"' )   /* search to leading quote */
    { if ( *from == '\0' )
         return;
      ++from;
    }
    ++from;

   while ( *from != '"' )   /* search to trailing quote */
    { *to++ = *from++;
      if ( *from == '\0' )
         return;
    }
    *to = '\0';
 }

int DoTangoChanges( FILE* backfile )
 { char type[64], *buff = 0, *pin1, *pin2;
   char value[256], value2[256];
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
      else if ( *type  == ';' )          /* REMARK == NO-OP */
       { ++count;
         done = ( fgets( buff, 256, backfile ) == NULL );
         continue;
       }
      else if ( !strnicmp( type, "RefDesChange", 6 ) )   /* Rename Component */
       { if ( sscanf( buff, "%*s%s%s", value, value2 ) != 2 )
          { sprintf( value, "RefDesChange Error at line %d", count );
            ErrorMsg ( value );
            return FALSE;
          }
         unquote( value );
         unquote( value2);
         ok = Rename( value, value2, count );
         if ( !ok )
          { sprintf( value, "RefDesChange Error at line %d", count );
            ErrorMsg ( value );
          }
       }
      else if ( !strnicmp( type, "PinSwap", 7 ) )     /* Swap Pins */
       { if ( sscanf( buff, "%*s%s%s", value, value2 ) != 2 )
          { sprintf( value, "PinSwap Error at line %d", count );
            ErrorMsg ( value );
            return FALSE;
          }
            /* The Pin values are in the form <refdes>-<pinnum>.
             * Strip off the pin numbers, leaving the refdes in "value"
             */
         unquote( value );
         unquote( value2 );
         pin1 = strchr( value, '-' );
         *pin1++ = '\0';
         pin2 = strchr( value2, '-' );
         ++pin2;
         ok = SwapPins( value, pin1, pin2, count );
         if ( !ok )
          { sprintf( value, "PinSwap Error at line %d", count );
            ErrorMsg ( value );
          }
       }
      else if ( !strnicmp( type, "GateSwap", 8 ) )     /* Swap Gates */
       { if ( sscanf( buff, "%*s%s%s", value, value2 ) != 2 )
          { sprintf( value, "GateSwap Error at line %d", count );
            ErrorMsg ( value );
            return FALSE;
          }

            /* The Gate values are in the form <refdes>:<section>.
             * Strip off the section letters, leaving the refdes in "value"
             */
         unquote( value );
         unquote( value2 );
         ok = SwapSection( value, value2, ':', count );
         if ( !ok )
          { sprintf( value, "GateSwap Error at line %d", count );
            ErrorMsg ( value );
          }
       }
      else
       { sprintf( value, "Unrecognized ECO Command '%s' at line %d", 
                          type, count );
         ErrorMsg ( value );
       } /* End else */

      if ( !ok )
         break;

      ++count;
      done = ( fgets( buff, 256, backfile ) == NULL );
    } /* End while */

   return TRUE;
 } /* End DoTangoChanges */

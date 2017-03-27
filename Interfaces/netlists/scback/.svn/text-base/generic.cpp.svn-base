/* pcbbackf.c - File Reader for Generic Schematic Back Annotation */

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

int DoChanges( FILE* backfile )
 { char buff[256], type[64];
   char attribute[64], name[64], value[256], value2[256];
   int count, ok;

   ok = TRUE;
   count = 0;
   while ( fgets( buff, 256, backfile ) != NULL )
    { ++count;
      if ( sscanf( buff, "%s", type ) != 1 ) /* blank line */
         continue; 

      switch ( *type )
       {
        case '#': continue;  /* Comment line */
                  break;
 
        case 'I': if ( sscanf( buff, "%*s%s%s%[^\n\r]", 
                                      attribute, name, value) != 3 )
                   { sprintf( buff, "Error in Back Annotation File at line %d",
                                     count );
                     ErrorMsg ( buff );
                     return FALSE;
                   }

                  ok = ChangeInst( attribute, name, strip( value ), count );
                  break;
 
        case 'N': if ( sscanf( buff, "%*s%s%s%[^\n\r]", 
                                      attribute, name, value) != 3 )
                   { sprintf( buff, 
                         "Error in Back Annotation File at line %d", count );
                     ErrorMsg ( buff );
                     return FALSE;
                   }

                  ok = ChangeNet( attribute, name, strip( value ), count );
                  break;

        case 'P': if ( sscanf( buff, "%*s%s%s%[^\n\r]", 
                                      attribute, name, value) != 3 )
                   { sprintf( buff, 
                         "Error in Back Annotation File at line %d", count );
                     ErrorMsg ( buff );
                     return FALSE;
                   }

                  ok = ChangePin( attribute, name, strip( value ), count );
                  break;
 
        case 'R': if ( sscanf( buff, "%*s%s%s", value, value2 ) != 2 )
                   { sprintf( buff, 
                         "Error in Back Annotation File at line %d", count );
                     ErrorMsg ( buff );
                     return FALSE;
                   }

                  ok = Rename( value, value2, count );
                  break;
 
        case 'S': if ( sscanf( buff, "%*s%s%s%s", name, value, value2 ) != 3 )
                   { sprintf( buff, 
                         "Error in Back Annotation File at line %d", count );
                     ErrorMsg ( buff );
                     return FALSE;
                   }

                  ok = SwapPins( name, value, value2, count );
                  break;
 
        case 'G': if ( sscanf( buff, "%*s%s%s", value, value2 ) != 2 )
                   { sprintf( buff, 
                         "Error in Back Annotation File at line %d", count );
                     ErrorMsg ( buff );
                     return FALSE;
                   }

                  ok = SwapSection( value, value2, '.', count );
                  break;
 
         default: sprintf( buff, 
                         "Error in Back Annotation File at line %d", count );
                  ErrorMsg ( buff );
                  return FALSE;
       } /* End switch */

      if ( !ok )
         break;
    } /* End while */

   return ok;
 } /* End DoChanges */

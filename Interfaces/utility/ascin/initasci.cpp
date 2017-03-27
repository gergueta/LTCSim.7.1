/* initasci.c -- Compiler from ASCII to schematic */

/* Copyright (C) 1993 -- Data I/O Corporation -- All Rights Reserved.
 *
 * This program is protected under the copyright laws as a published work.
 * It may not be copied, reproduced, further distributed, adaptations
 * made from the same, or used to prepare derivative works, without the
 * prior written consent of the Data I/O Corporation
 *
 * History:
 *    5/05/93 - Included in Version 2.5
 */

#include "stdafx.h"
#include "funcs.h"

extern char FullFileName[];
int MajorError( const char* string );

char SourceFileExt[] = ".asc";                  /* used by main to find files */
char ProgramName[] = "ASCII to Schematic";

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

int Interface()
 { int file, error = TRUE;
#ifdef _WIN32
   file = _sopen( FullFileName, O_RDONLY | O_TEXT, _SH_DENYWR );
#else
   file = open( FullFileName, O_RDONLY | O_TEXT );
#endif
   if ( file >= 0 )
    { error = Parse( file, FullFileName );
      close( file );
    }
   else
    { char str[300];
      sprintf( str, "No file named <%s> available", FullFileName );
      MajorError( str );
    }
   return( error );
 }

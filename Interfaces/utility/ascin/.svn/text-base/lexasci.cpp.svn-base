/* lexasci.c -- Lexical Scanner for ASCII IN */

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

extern char *keyword[], *constant[];

#define B_SIZE 256
#define NEXT_CC inc_cc()

int lineno;

char filebuf[B_SIZE+1], linebuf[B_SIZE];       /* pointers into ascii file */

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

static char *cc, *end;
static int ascfile;
static int done = 0;

static char *inc_cc()
 { cc++;
   if ( cc == end )
    { cc = filebuf;
      end = cc + read( ascfile, cc, B_SIZE );
      *end = '\0';
    }
   return( cc );
 }

void InitLex( int file )
 { ascfile = file;
   done = 0;
   lineno = 0;
   cc = filebuf;
   end = filebuf+1;
   NEXT_CC;
 }

int GetConstant( const char* str )
 { int key = -1, ii;
   for ( ii = 0; key < 0 && *constant[ii]; ii++ )
    { if ( stricmp( str, constant[ii] ) == 0 ) key = ii;
    }
   if ( key < 0 ) Warning( "Unknown constant" );
   return( key );
 }

static int GetKey()
 { int key = -1, ii;
   char keybuf[B_SIZE];

   if ( sscanf( linebuf, "%s", keybuf ) > 0 )
    {
      for ( ii = 0; key < 0 && *keyword[ii]; ii++ )
       { if ( stricmp( keybuf, keyword[ii] ) == 0 ) key = ii;
       }
      if ( key < 0 ) Warning( "Unknown keyword" );
    }
   return( key );
 }

int GetLine()
 { int key = -1, ii, eol;
   while ( !done && key < 0 )
    { for ( ii = 0, eol = 0; *cc && ii < B_SIZE && !eol; NEXT_CC, ii++ )
       { if ( ii < B_SIZE )
          { if ( *cc == '\n' )
             { eol = 1;
               ii--;
             }
            else if ( *cc == '\r' ) ii--;
            else linebuf[ii] = *cc;
          }
       }
      lineno++;
      if ( ii < B_SIZE ) linebuf[ii] = '\0';
      else Warning( "Line too long" );
      if ( *cc == 0 ) done = 1;
      key = GetKey();
    }
   return( key );
 }

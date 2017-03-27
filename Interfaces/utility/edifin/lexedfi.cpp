/* lexedfi.c -- Lexical Scanner for EDIF */

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
#include "token.h"
#include "funcs.h"


#define WHITESPACE( c ) ( c == ' ' || c == '\t' || c == '\n' || c == '\r' )
#define DELIMITER( c ) ( WHITESPACE( c ) || \
                         c == '(' || c == ')' || c == '%' || c == '"' )

/* edif file buffer is read one character at a time. any BACKUP is immediately
   followed by a NEXT. */
#define B_SIZE 256
#define NEXT_CC inc_cc()
#define BACKUP_CC cc--

long tokenval;
char tokenbuf[B_SIZE];
int lineno;

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

static char filebuf[B_SIZE+1], *cc, *end;           /* pointers into edif file */
static int ediffile;

static char *inc_cc()
 { cc++;
   if ( cc == end )
    { cc = filebuf;
      end = cc + read( ediffile, cc, B_SIZE );
      *end = '\0';
    }
   return( cc );
 }

void Init( int file )
 { ediffile = file;
   lineno = 1;
   cc = filebuf;
   end = filebuf+1;
   NEXT_CC;
 }

/* Lexan is the lexical analyzer for EDIF.  It searches for the basic
   terminals, integerToken, identifier, stringToken, '(', ')' and TOK_DONE.  It
   ignores whiteSpace and case except in strings.  It calls itself to handle
   integers which may be encountered as asciiCharacter escape sequences in
   strings.  The return value is the token type and the token data is in
   tokenval or tokenbuf.
*/
int Lexan()
 { int tok = 0;
   int ii;
   char buf[B_SIZE];
   tokenval = TOK_NONE;
   while( !tok )
    { if ( *cc == ' ' || *cc == '\t' || *cc == '\r' ) NEXT_CC;  /* whiteSpace */
      else if ( *cc == '\n' )                                     /* new line */
       { lineno++;
         NEXT_CC;
       }
      else if ( *cc == '-' || *cc == '+' || isdigit( *cc ) )  /* integerToken */
       { for( ii = 0; *cc && !DELIMITER( *cc ); NEXT_CC, ii++ )
          { if ( ii < B_SIZE ) buf[ii] = *cc;
          }
         if ( ii < B_SIZE ) buf[ii] = '\0';
         else Warning( "Integer string too long" );
         if ( !sscanf( buf, "%ld", &tokenval ) ) Warning( "Integer error" );
         tok = TOK_NUM;
       }
      else if ( *cc == '&' || isalpha( *cc ) )                  /* identifier */
       { if ( *cc == '&' ) NEXT_CC;       /* skip & */
         for( ii = 0; *cc && !DELIMITER( *cc ); NEXT_CC, ii++ )
          { if ( ii < B_SIZE ) tokenbuf[ii] = *cc;
            if ( isalnum( *cc ) || *cc == '_' );
            else Warning( "Identifier error" );
          }
         if ( ii < B_SIZE ) tokenbuf[ii] = '\0';
         else Warning( "Identifier string too long" );
         /* identifiers are case insensitive */
         strupr( tokenbuf );
         tok = TOK_ID;
       }
      else if ( *cc == '"' )                                   /* stringToken */
       { NEXT_CC;
         for( ii = 0; *cc && *cc != '"'; NEXT_CC, ii++ )
          { if ( *cc == '%' )                               /* asciiCharacter */
             { int temp;
               NEXT_CC;
               while( ( temp = GetNextToken() ) == TOK_NUM )
                { if ( tokenval < 0 || tokenval > 127 )
                     Warning( "Ascii character too large" );
                  if ( ii < B_SIZE ) tokenbuf[ii++] = (char)tokenval;
                }
               if ( temp != '%' ) Warning( "Ascii character - expected %%" );
               /* watch this carefully:
                  ii and cc got incremented one extra time in number loop */
               ii--;
               BACKUP_CC;
             }
            else
             { if ( *cc == '\n' ) lineno++;
               else if ( *cc == '\r' );
               else if ( ii < B_SIZE ) tokenbuf[ii] = *cc;
             }
          }
         if ( ii < B_SIZE ) tokenbuf[ii] = '\0';
         else Warning( "String too long" );   /* EDIF has no limit on strings */
         tok = TOK_STRING;
         if ( *cc == '\0' ) Warning( "End of file, expecting \"" );
         else NEXT_CC;
       }
      else if ( *cc == '\0' ) tok = TOK_DONE;                          /* EOF */
      else                                                 /* all other types */
       { tok = *cc;
         NEXT_CC;
       }
    }

   return( tok );
 }

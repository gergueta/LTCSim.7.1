/* parsedfi.c -- Parser for EDIF */

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
#include "edifin.h"
#include "token.h"

extern char *keyword[], *constant[];
extern int lineno, notepad;
extern long tokenval;
extern char tokenbuf[];

int lookahead;

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

static int peekahead = 0;
static int synerrcnt = 0, warncnt = 0;
static int errorfile, ediffile;
static char errorname[_MAX_PATH];

void Quit()
{
	close( ediffile );
	close( errorfile );
	if ( synerrcnt || warncnt )
	{
		LaunchViewer( errorname );
	}
	exit( 1 );
}

static void SynError( const char* m )
 { char str[400];
   sprintf( str, "Syntax error line %d: %.300s\n", lineno, m );
   write( errorfile, str, strlen( str ) );
   if ( ++synerrcnt >= 10 ) Quit();
 }

void Warning( const char* m )
 { char str[400];
   sprintf( str, "Warning line %d: %.300s\n", lineno, m );
   write( errorfile, str, strlen( str ) );
   warncnt++;
 }

int ErrorMsg( const char* m )
 { char str[400];
   sprintf( str, "Symbol error line %d: %.300s\n", lineno, m );
   write( errorfile, str, strlen( str ) );
   ++warncnt;
   return( 100 );
 }

void Parse( int file, const char* filename )
{
	char str[300];

	sprintf( str, "Errors or warnings compiling %s.\n\n", filename );
	ediffile = file;
	strcpy( errorname, FileInPath( filename ) );
	AddExt( errorname, ".err" );
	strlwr ( errorname );
#ifdef _WIN32
	errorfile = _sopen( errorname, O_RDWR | O_CREAT | O_TRUNC | O_TEXT, _SH_DENYNO, 0600 );
#else
	errorfile = open( errorname, O_RDWR | O_CREAT | O_TRUNC | O_TEXT, 0600 );
#endif
	if ( errorfile >= 0 )
	{
		write( errorfile, str, strlen( str ) );
		Init( file );
		lookahead = GetNextToken();
		Start();
		if ( lookahead != TOK_DONE ) Warning( "End of file expected" );
		close( errorfile );
		if ( synerrcnt || warncnt )
		{
			LaunchViewer( errorname );
		}
		else unlink( errorname );
	}
	else
	{
		sprintf( str, "Unable to create %s", errorname );
		MajorError( str );
	}
}

int GetNextToken()
 { int retn;
   if ( peekahead ) retn = peekahead;
   else retn = Lexan();
   peekahead = 0;
   return( retn );
 }

/* TokenStr produces a string suitable for output which has the token type
   and optionally the actual token.  Max length < 64. */
void TokenStr( int tok, char* str, int actual )
 { switch( tok )
    { case TOK_NUM:
         if ( actual ) sprintf( str, "Integer %ld", tokenval );
         else strcpy( str, "Integer" );
         break;
      case TOK_ID:
         if ( actual ) sprintf( str, "Identifier %.50s", tokenbuf );
         else strcpy( str, "Identifier" );
         break;
      case TOK_STRING:
         if ( actual ) sprintf( str, "String %.50s", tokenbuf );
         else strcpy( str, "String" );
         break;
      case TOK_DONE:
         strcpy( str, "EOF" );
         break;
      default:
         *str     = (char)tok;
         *(str+1) = '\0';
         break;
    }
 }

int Match( int cc )
 { int retn = 1;
   char str1[64], str2[64], str[160];
   if ( lookahead == cc ) lookahead = GetNextToken();
   else
    { TokenStr( cc, str1, 0 );
      TokenStr( lookahead, str2, 1 );
      sprintf( str, "%s expecting %s", str2, str1 );
      SynError( str );
      lookahead = GetNextToken();
      retn = 0;
    }
   return( retn );
 }

int MatchKeyword( int key )
 { int retn = 1;
   char str[128], str1[64];
   if ( lookahead == TOK_ID )
    { if ( key < 0 ) lookahead = GetNextToken();
      else if ( !strcmp( tokenbuf, keyword[key] ) ) lookahead = GetNextToken();
      else
       { sprintf( str, "%.64s Expecting %s",
                                      tokenbuf, keyword[key] );
         retn = 0;
       }
    }
   else
    { TokenStr( lookahead, str1, 1 );
      sprintf( str, "%s expecting %s",
             str1, ( key >= 0 ? keyword[key] : "valid keyword" ) );
    }
   if ( !retn ) SynError( str );
   return( retn );
 }

/* SkipRestOfForm will never be called immediately after PeekAtKeyword so
   it does not need to worry about counting an extra (. */
void SkipRestOfForm()
 { int count = 1;
   while ( lookahead != TOK_DONE )
    { if ( lookahead == ')' ) count--;
      else if ( lookahead == '(' ) count++;
      if ( count <= 0 ) break;
      lookahead = GetNextToken();
    }
 }

/* IgnoreForm is usually called after PeekAtKeyword */
void IgnoreForm()
 {
   Match( '(' );
   SkipRestOfForm();
   Match( ')' );
 }

/*  PeekAtKeyword looks up an id in the keyword table.  It does not advance
    the lookahead token but it will peek ahead if current lookahead is '('.  */
int PeekAtKeyword()
 { int ii, retn = -1;
   if ( lookahead == TOK_ID ||
           ( lookahead == '(' && ( peekahead = GetNextToken() ) == TOK_ID ) )
    { for( ii = 0; retn < 0 && *keyword[ii]; ii++ )
       { if ( strcmp( tokenbuf, keyword[ii] ) == 0 ) retn = ii;
       }
      if ( retn < 0 ) Warning( "Unknown keyword" );
    }
   else SynError( "Keyword expected" );
   return( retn );
 }

/*  MatchConstant looks up a constant in the constant table.  */
int MatchConstant()
 { int ii, retn = -1;
   if ( lookahead == TOK_ID )
    { for( ii = 0; retn < 0 && *constant[ii]; ii++ )
       { if ( strcmp( tokenbuf, constant[ii] ) == 0 ) retn = ii;
       }
      if ( retn < 0 ) Warning( "Unknown constant" );
    }
   Match( TOK_ID );
   return( retn );
 }

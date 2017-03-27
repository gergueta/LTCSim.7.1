/* parsasci.c -- Parse utilities for ASCII IN */

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
#include "ascin.h"

extern int lineno;
extern char FullFileName[];

int abort_flag;

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

static int synerrcnt, warncnt;
static int errorfile;

void SynError( const char* m )
 { char str[400];
   sprintf( str, "Syntax error line %d: %.300s\n", lineno, m );
   write( errorfile, str, strlen( str ) );
   if ( ++synerrcnt >= 30 ) abort_flag = TRUE;
 }

void Warning( const char* m )
 { char str[400];
   sprintf( str, "Warning line %d: %.300s\n", lineno, m );
   write( errorfile, str, strlen( str ) );
   warncnt++;
 }

int ErrorMsg( const char* m )
 { char str[400];
   sprintf( str, "Error line %d: %.300s\n", lineno, m );
   write( errorfile, str, strlen( str ) );
   ++warncnt;
   return( 100 );
 }

int Parse( int file, const char* filename )
{
	char str[300];
	char errorname[_MAX_PATH];

	abort_flag = FALSE;
	synerrcnt = warncnt = 0;
	strcpy( errorname, FileInPath( filename ) );
	AddExt( errorname, ".err" );
	strlwr ( errorname );
#ifdef _WIN32
	errorfile = _sopen( errorname, O_RDWR | O_CREAT | O_TRUNC | O_TEXT, _SH_DENYWR, 0600 );
#else
	errorfile = open( errorname, O_RDWR | O_CREAT | O_TRUNC | O_TEXT, 0600 );
#endif

	sprintf( str, "Errors or Warnings compiling %s.\n\n", filename );
	write( errorfile, str, strlen( str ) );

	InitLex( file );
	if ( Asc_In() )
	{
		SchematicSave( FullFileName );
		FreeSchematic();
	}

	close( errorfile );
	if ( synerrcnt || warncnt )
	{
		LaunchViewer( errorname );
	}
	else unlink( errorname );
	return( synerrcnt + warncnt );
}

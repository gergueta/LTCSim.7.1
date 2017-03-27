/* $HDR$*/
/************************************************************************/
/* File archived using GP-Version                                       */
/* GP-Version is Copyright 1999 by Quality Software Components Ltd      */
/*                                                                      */
/* For further information / comments, visit our WEB site at            */
/* http://www.qsc.co.uk                                                 */
/************************************************************************/
/**/
/* $Log:  11247: Pspcsub.cpp 
/*
/*   Rev 1.0    5/4/2001 4:51:04 AM      Version: 5.0.0.4
*/
/*
/*   Rev 1.0    8/2/2000 10:56:51 PM  supervisor
/* Initial Revision
*/
/*
/*   Rev 1.0    7/31/2000 9:50:21 PM  german_e
/* Initial Revision
*/
/**/
/* pspcsub.c -- Hierarchical Spice - Merges subckt files into the .SPI file */

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

#include <stdafx.h>
#include "pikproc.h"
#include "dataout.h"

static char list[16000] = "";
static int err = 0;

                      /*---------- Open_File ----------*/

static FILE* Open_File( const char* pszName, const char* pszExt )
{
	char pathname[_MAX_PATH];
	FILE *file = NULL;

	if ( FindECSFile( pszName, pszExt, CURRENT_DIRECTORY | SCHEMATIC_PATHS, pathname ) == 0 )
		file = fopen( pathname, "r" );
	return( file );
}

                  /*---------- Merge_Macro_Files ----------*/

int Merge_Macro_File( char* def_name )
{
  char name[_MAX_PATH], buff[_MAX_PATH];
  char *bb;
  char *lst, *nn;
  TD_PTR td;
  int macro;
  int abort = FALSE;
  FILE * macrofile;
  
  if ( macrofile = Open_File( def_name, ".p" ) )    {
    macro = FALSE;                          /* have not started a macro yet */
    while ( !abort && fgets( buff, sizeof(buff), macrofile ))  {
      bb = strchr( buff, '.' );
      if ( bb )	{
	if ( macro && strnicmp( bb, ".ENDS", 5 ) == 0 ) {
	  /* End of Macro */ 
	  fwrite( buff, 1, strlen( buff ), file );/* write the last line */
	  macro = FALSE;
	}
	if ( strnicmp( bb, ".SUBCKT ", 8 ) == 0 ) {
	  /* starting a new one */
	  sscanf( bb, "%*s %s", name );                  /* get the name */
	  for( lst = list; *lst; ) {
	    /* check list for name */
	    if ( strcmp( lst, name ) ) while( *lst++ );
	    else break;
	  }
	  if ( *lst == '\0' ) {
	    /* not in the list yet */
	    if ( lst + strlen( name ) + 2 - list > sizeof( list ) ) {
	      if ( !err )
		err = MajorError( "Too many subckts to expand" );
	    }
	    else {
	      nn = name;
	      while( *lst++ = *nn++ );              /* add to the list */
	      *lst++ = '\0';                            /* double NULL */
	    }
	    if ( td = FindDescriptorNamed( name ) ) MarkBlockDone( td );
	    macro = TRUE;
	  }
	}
      }
      if ( macro )               /* if we are currently processing a macro */
	fwrite( buff, 1, strlen( buff ), file );    /* write current line */
    }
    fclose( macrofile );
  }
  return( macrofile != (FILE *)NULL );
}
int Merge_Digital_Macro_File( char* def_name )
{
  char name[_MAX_PATH], buff[_MAX_PATH];
  char *bb;
  char *lst, *nn;
  TD_PTR td;
  int macro;
  int abort = FALSE;
  FILE * macrofile;
  
  if ( macrofile = Open_File( def_name, ".pd" ) )  {
    macro = FALSE;                          /* have not started a macro yet */
    while ( !abort && fgets( buff, sizeof(buff), macrofile ) ) {
      bb = strchr( buff, '.' );
      if ( bb )	{
	if ( macro && strnicmp( bb, ".ENDS", 5 ) == 0 ) {
	  /* End of Macro */
	  fwrite( buff, 1, strlen( buff ), file );/* write the last line */
	  macro = FALSE;
	}
	if ( strnicmp( bb, ".SUBCKT ", 8 ) == 0 ) {
	  /* starting a new one */
	  sscanf( bb, "%*s %s", name );                  /* get the name */
	  for( lst = list; *lst; ) {
	    /* check list for name */
	    if ( strcmp( lst, name ) ) while( *lst++ );
	    else break;
	  }
	  if ( *lst == '\0' ) {
	    /* not in the list yet */
	    if ( lst + strlen( name ) + 2 - list > sizeof( list ) ) {
	      if ( !err )
		err = MajorError( "Too many subckts to expand" );
	    }
	    else {
	      nn = name;
	      while( *lst++ = *nn++ );              /* add to the list */
	      *lst++ = '\0';                            /* double NULL */
	    }
	    if ( td = FindDescriptorNamed( name ) ) MarkBlockDone( td );
	    macro = TRUE;
	  }
	}
      }
      if ( macro )               /* if we are currently processing a macro */
	fwrite( buff, 1, strlen( buff ), file );    /* write current line */
    }
    fclose( macrofile );
  }
  return( macrofile != (FILE *)NULL );
}

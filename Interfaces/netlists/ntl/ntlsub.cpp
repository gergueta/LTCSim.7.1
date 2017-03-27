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
  
  if ( macrofile = Open_File( def_name, ".l" ) ) {
    macro = FALSE;                          /* have not started a macro yet */
    while ( !abort && fgets( buff, sizeof(buff), macrofile ) ) {
      bb = strchr( buff, '.' );
      if ( bb ) {
	if ( macro && strnicmp( bb, ".ENDS", 5 ) == 0 ) {  /* End of Macro */
	  fwrite( buff, 1, strlen( buff ), file );/* write the last line */
	  macro = FALSE;
	}
	if ( strnicmp( bb, ".SUBCKT ", 8 ) == 0 ) {   /* starting a new one */
	  sscanf( bb, "%*s %s", name );                  /* get the name */
	  for( lst = list; *lst; ) {                /* check list for name */
	    if ( strcmp( lst, name ) ) while( *lst++ );
	    else break;
	  }
	  if ( *lst == '\0' ) {                     /* not in the list yet */
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

                  /*---------- Merge_Header_File ----------*/

int Merge_Header_File( char* def_name )
{
  char buff[_MAX_PATH];
  int abort = FALSE;
  FILE * headerfile;

  if ( headerfile = Open_File( def_name, ".lvh" ) ) {
    while ( !abort && fgets( buff, sizeof(buff), headerfile ) ) {
      fwrite( buff, 1, strlen( buff ), file );
    }
    fclose( headerfile );
  }
  else if (headerfile = Open_File( "lvs", ".equ" )) {
    while ( !abort && fgets( buff, sizeof(buff), headerfile ) ) {
      fwrite( buff, 1, strlen( buff ), file );
    }
    fclose( headerfile );
  }
  return( headerfile != (FILE *)NULL );
}










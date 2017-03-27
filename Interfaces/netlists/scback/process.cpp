/* scback.c - Generic Schematic Back Annotation */

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
#include "spikproc.h"
#include "scback.h"
#include "version.h"
//#include "utilmsgs.h"
//#include "featcode.h"

extern char BaseFileName[], SymFileName[], SchmFileName[];

extern int DoChanges( FILE* backfile );
extern int DoPADSChanges( FILE* backfile );
extern int DoRINFChanges( FILE* backfile );
extern int DoTangoChanges( FILE* backfile );
extern int DoOrcadChanges( FILE* backfile );
extern int BeginRename();
extern int EndRename();

#define GENERIC 0
#define PADS    1
#define RINF    2
#define TANGO   3
#define ORCAD  4

static char *theBanFileExt;
static int theFormat;

char ProgramName[] = "scback";

unsigned long ProcRequiredLicBit  = 0;
unsigned long ProcRequiredVersion = 0;

char DeviceName[256];

static int Process_File( char *name );

                         /*---------- Process_File ----------*/

static int Process_File( char* name )
 { int retn, error = FALSE;
   char buff[300];
   FILE *backfile = 0;

   AddExt( name, "" );
   strlwr( FileInPath( name ) );
   strcpy( SchmFileName, name );
   strcpy( SymFileName, name );
   strcpy( BaseFileName, FileInPath( SymFileName ) );
   AddExt( BaseFileName, "" );

   Free_Memory();                 /* frees memory leftover from previous file */

   if ( !LoadSchematic( SchmFileName ) )
    { sprintf( buff, "Can not read schematic file %s.sch", name );
      error = MajorError( buff );
    }
   else if ( ( retn = LoadSymbolsUsed() ) != 1 )
    { if ( retn == 0 )
         sprintf( buff, "Unable to load symbols for %s.sch", name );
      else
         sprintf( buff, "Some symbols for %s.sch are out of date", name );
      error = MajorError( buff );
    }

   if ( !error )
    { AddExt( name, theBanFileExt );

      if ( ( backfile = fopen( name, "r" ) ) == NULL )
       { sprintf( buff, "Can not read back annotation file %s", name );
         error = MajorError( buff );
       }
    }

     /* Gate and pin swaps happen immediately.  Component renames are
      * accumulated and processed at the end for the entire file to avoid
      * multiple renames in the case where a new refdes is the same as an
      * old one that is being changed.  The SWAP structure stores the list
      * of components to be renamed.
      */

   if ( !error )
   {
   	if( theFormat != ORCAD )
   	{
			error = !BeginRename();
		}
	}

   if ( !error )
    { int ok = FALSE;
      //if      ( theFormat == GENERIC ) 
   ok = DoChanges( backfile );
      //else if ( theFormat == PADS )    ok = DoPADSChanges( backfile );
      //else if ( theFormat == RINF )    ok = DoRINFChanges( backfile );
      //else if ( theFormat == TANGO )   ok = DoTangoChanges( backfile );
      //else if ( theFormat == ORCAD )   ok = DoOrcadChanges( backfile );

        /* Now process the SWAP list to rename the components */
		if( theFormat != ORCAD )
		{
			EndRename();
      }

      if ( ok && !SaveSchematic( name ) ) error = TRUE;
      else if ( !ok ) error = TRUE;
    }

   return( error );
 }

               /*---------- Process_Command_Line ----------*/

int Process_Command_Line( int argc, char* argv[] )
 { int ii, success = 0;

   theFormat = GENERIC;
   theBanFileExt = ".ban";
   for ( ii = 1; ii < argc; ii++ )
    { if ( *argv[ii] == '-' )
       { if      ( !strnicmp( argv[ii], "-pads", 5 ) )
          {
            theFormat = PADS;
            theBanFileExt = ".eco";
          }
         else if ( !strnicmp( argv[ii], "-rinf", 5 ) )
          {
            theFormat = RINF;
            theBanFileExt = ".irp";
          }
         else if ( !strnicmp( argv[ii], "-tango", 5 ) )
          {
            theFormat = TANGO;
            theBanFileExt = ".eco";
          }
         else if ( !strnicmp( argv[ii], "-orcad+", 5 ) )
          {
            theFormat = ORCAD;
            theBanFileExt = ".swp";
          }
       }
	  else if ( *argv[ii] == '@' )
	   {
		   int count;
		   char *arglist[MAXNARGS];

		   count = Parse_Command_File( argv[ii]+1, arglist );
		   if ( count > 0 )
		   {
			   success = Process_Command_Line( count, arglist );
			   Free_Arg_List( count, arglist );
		   }
		   else
		   {
			   char message[100];
			   sprintf( message, "Error Reading Response File: %s", argv[ii]+1 );
			   MajorError( message );
		   }
	   }
      else
       { 
		  //OpenErrorFile( argv[ii] );
         success = Process_File( argv[ii] );
         argc = 0;
       }
    }
//   CloseErrorFile();
//   ShowOrDeleteErrorFile();

   return( success );
 }

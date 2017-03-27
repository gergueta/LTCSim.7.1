/* mainasci.c -- Main Program for All Interfaces */

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
#ifdef _WIN32
#include <windows.h>
#include <direct.h>
#endif
#include "sympi.h"
#include "version.h"

#define NETLIST_VER "7.0"
unsigned int feature_code = 0;
unsigned int feature_version = 0;
unsigned long ProcRequiredLicBit = 0xFFFFFFFF;
unsigned long ProcRequiredVersion = 0;

int Interface();

extern char SourceFileExt[];
extern char ProgramName[];
extern char FullFileName[];

// unsigned long ProcRequiredLicBit  = 0xffFFffFF;
// unsigned long ProcRequiredVersion = VERSION_I;

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

#ifdef _WIN32
                      /*----------  WinMain  -----------*/

HWND hBackWnd = 0;
HMETAFILE hDragMF = 0;
HDC hDragDC = 0;
HINSTANCE _hInstance;

int PASCAL WinMain( HINSTANCE hInstance, HINSTANCE hPrevInst, LPSTR lpszCmdLine, int nCmdShow )
 { char cmdline[_MAX_PATH], file_template[_MAX_PATH];
   HWND hListBox;
   char cPath[_MAX_PATH];
   int ii, count, error = TRUE;
   int delete_after_use = FALSE;

   _hInstance = hInstance;
   /* Synario requires a Yield before the program returns in order to be
      able to check the return code.  The -yield command line argument
      will force a Yield.  If Initialize fails we won't read the command
      line arguments but Initialize will have Posted a MajorError so the
      Yield will not be necessary. */
   if ( Initialize() )
    { error = FALSE;
      /* Parse the command line.  Look for flags preceded by '/' or '-'
         Allow file names to contain wild card specifications. */

      lstrcpy( cmdline, lpszCmdLine );

      while ( *cmdline )
       { file_template[0] = '\0';
         if ( sscanf( cmdline, "%s %[^\n]", file_template, cmdline ) < 2 )
            *cmdline = '\0';
         if ( *file_template == '-' || *file_template == '/' )
          { if ( !stricmp( file_template + 1, "yield" ) )
               Yield();
            else if ( !stricmp( file_template + 1, "d" ) ) delete_after_use = TRUE;
          }
         else if ( !*file_template );
         else if ( strpbrk( file_template, "?*" ) )
          {
            AddExt( file_template, SourceFileExt );              /* dont allow *.* */
            hListBox = CreateWindow( (LPSTR)"listbox", (LPSTR)"", WS_TILED,
                                     0, 0, 20, 20, (HWND)NULL,
                                     NULL, _hInstance, 0L );
            if ( hListBox )
             { count = (int)SendMessage( hListBox, LB_DIR, 0,
                                         (long)((LPSTR)file_template) );
               for ( ii = 0; ii <= count; ii++ )
                { if ( SendMessage( hListBox, LB_GETTEXT, ii,
                                    (long)((LPSTR)FullFileName) ) != LB_ERR )
                   {
						_getcwd(cPath, sizeof(cPath));
						error = Interface();
						if ( !error && delete_after_use )
						{ 
							AddExt( FullFileName, SourceFileExt );
							unlink( FullFileName );
						}
                   }
                }
               DestroyWindow( hListBox );
             }
            else
               SysError( "Failed to create list box" );
          }
         else
          { strcpy( FullFileName, file_template );
            AddExt( FullFileName, SourceFileExt );
            error = Interface();
            if ( !error && delete_after_use )
             { AddExt( FullFileName, SourceFileExt );
               unlink( FullFileName );
             }
          }
       }
      if ( *FullFileName == '\0' )
         MajorError( "No files to process" );
    }
   // NOTE: error is set in while loop so return code could be wrong
   return( error );
 }

#endif

#if defined(UNIX)

int main( int argc, char* argv[] )
 { int ii, error = FALSE;
   int delete_after_use = FALSE;

   if ( Initialize() )
    { for ( ii = 1; ii < argc; ii++ )
       { if ( *argv[ii] == '-' )
          { if ( !strnicmp( argv[ii], "-d", 2 ) ) delete_after_use = TRUE;
          }
         else
          { strcpy( FullFileName, argv[ii] );
            AddExt( FullFileName, SourceFileExt );
            strlwr( FileInPath( FullFileName ) );
            fprintf( stderr, "Running %s on file %s\n",
                     argv[0], FullFileName );
            Interface();
            /* KLUGE, should check return code for failure */
            if ( delete_after_use )
             { AddExt( FullFileName, SourceFileExt );
               unlink( FullFileName );
             }
          }
       }
      if ( argc <= 1 )
         MajorError( "No Files To Process" );
    }
   return( error );
 }

#endif

                      /*---------- MajorError ----------*/

int MajorError( const char* string )
 { char errstr[128];
   sprintf( errstr, "%.100s Error", ProgramName );
#if defined(_WIN32)
   MessageBox( NULL, string, errstr, MB_ICONEXCLAMATION | MB_OK );
#endif
#if defined(UNIX)
   fprintf( stderr, "**** %s - %s ****\n", errstr, string );
#endif
   return( TRUE );
 }

                      /*----------  SysError  ----------*/

int SysError( const char* string )
 { char errstr[128];
   sprintf( errstr, "%.100s Program Error", ProgramName );
#if defined(_WIN32)
   MessageBox( NULL, string, errstr, MB_ICONSTOP | MB_OK );
#endif
#if defined(UNIX)
   fprintf( stderr, "**** %s - %s ****\n", errstr, string );
#endif
   return( TRUE );
 }

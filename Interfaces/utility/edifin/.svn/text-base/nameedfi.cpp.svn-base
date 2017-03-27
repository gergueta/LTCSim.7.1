/* nameedfi.c -- Low level parse for EDIF names and identifiers */

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

extern char tokenbuf[];
extern int ignore_display;

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

               /* memory allocation for identifiers and strings */
static unsigned long allocated = 0;
static char* alloc( unsigned int len )
 { char* retn;
   retn = (char*)malloc( len );
   allocated += len;
   if ( !retn )
    { MajorError( "Insufficient memory" );
      Quit();
    }
   return( retn );
 }

/* The symbol table doesn't care what type of identifier it is looking at.
   if the first indentifier is named AND it will be id 0.  later an instance
   or pin or cell or anything named AND will be id 0.  This is not a problem
   since the Defs and Refs keep track of the name Class. */
#define NENT 1024
static char *symtab[NENT];
static int nextentry = 0;
static int identifier()
 { int index = -1;
   if ( lookahead == TOK_ID )
    { for ( index = 0; index < nextentry; index++ )
       { if ( strcmp( tokenbuf, symtab[index] ) == 0 ) break;
       }
      if ( index == nextentry )
       { if ( index >= NENT )
          { MajorError( "Symbol table overflow" );
            Quit();
          }
         else
          { symtab[index] = alloc( strlen( tokenbuf ) + 1 );
            strcpy( symtab[index], tokenbuf );
            nextentry++;
          }
       }
    }
   Match( TOK_ID );
   return( index );
 }

static char string_token[256];   /* temporary holding */
static char *stringToken()
 {
   string_token[0] = '\0';
   if ( lookahead == TOK_STRING )
    { strncpy( string_token, tokenbuf, 256 );
      string_token[255] = '\0';
    }
   Match( TOK_STRING );
   return( string_token );
 }

static int name()
 { int retn;
   Match( '(' );
   MatchKeyword( K_NAME );
   retn = identifier();
   while ( lookahead != ')' ) display();
   Match( ')' );
   return( retn );
 }

static int rename_()
 { int id;
   Match( '(' );
   MatchKeyword( K_RENAME );
   if ( lookahead == '(' ) id = name();                   /* dont do displays */
   else id = identifier();
   if ( lookahead == '(' ) stringDisplay();
   else stringToken();
   Match( ')' );
   return( id );           /* actual string is in static string_token */
 }

/* -------------------------------------------------------------------------- */

char *stringValue()
 {
   return( stringToken() );
 }

#define NUM_CLASSES 7

static DEF *first_def[ 1 + NUM_CLASSES ] =
 { NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL };
static unsigned int sizeof_def[ 1 + NUM_CLASSES ] =
 { 0, sizeof( FIGUREDEF ), sizeof( PORTDEF ), sizeof( DEF ),
      sizeof( PROPERTYDEF ), sizeof( PROPERTYDEF ),
      sizeof( PROPERTYDEF ), sizeof( PROPERTYDEF ) };

DEF* nameDef( int Class )
/* displays in the Def portion should be ignored */
 { int key = -1;
   int id;
   DEF *def = (DEF *)NULL;
   int save_ignore;

   save_ignore = ignore_display;
   ignore_display = 1;

   if ( lookahead == '(' )
    { key = PeekAtKeyword();
      if ( key == K_NAME ) id = name();
      else id = rename_();
    }
   else id = identifier();

   if ( Class )         /* better be < sizeof( first_def ) / sizeof( char * ) */
    { /* should check to make sure its not already defined */
      def = (DEF *)alloc( sizeof_def[ Class ] );
      def->next = first_def[ Class ];
      def->id = id;
      if ( key == K_RENAME )
       { if ( Class == PORTCLASS && Filter_Net_Name( string_token ) )
          { def->name = symtab[id];
            Warning( "Can't use original name, using identifier instead" );
          }
         else
          { def->name = alloc( strlen( string_token ) + 1 );
            strcpy( def->name, string_token );
          }
       }
      else def->name = symtab[id];
      first_def[ Class ] = def;
    }

   ignore_display = save_ignore;
   return( def );
 }

DEF* array( int Class )
/* displays in the Def portion should be ignored */
 { long size;
   DEF *def = (DEF *)NULL;
   int save_ignore;

   save_ignore = ignore_display;
   ignore_display = 1;

   Match( '(' );
   MatchKeyword( K_ARRAY );
   def = nameDef( Class );
   size = integerValue();                    /* always one dimension required */
   while ( lookahead != ')' ) size = integerValue();
   Match( ')' );

   ignore_display = save_ignore;
   return( def );
 }

DEF* nameRef( int Class )
 { int id;
   DEF *def = (DEF *)NULL;
   if ( lookahead == '(' ) id = name();
   else id = identifier();
   if ( Class )
    { for ( def = first_def[ Class ]; def && def->id != id; def = def->next )
      if ( !def ) Warning( "Names must be defined before being referenced" );
    }
   return( def );
 }

/* This function allows memory to be freed so that the program can run multiple
   times.  Careful about this.. */
void Free_Names()
 { int ii, Class;
   DEF *def;
   char *cc;

   for ( Class = 1; Class <= NUM_CLASSES ; Class++ )
    { for ( def = first_def[ Class ]; def; )
       { /* first see if any memory got allocated by rename */
         cc = def->name;
         for ( ii = 0; ii < nextentry && symtab[ii] != cc; ii++ );
         if ( ii == nextentry ) free( cc );                  /* not in symtab */
         cc = (char *)def;
         def = def->next;
         free( cc );                                    /* was memory for def */
       }
      first_def[ Class ] = NULL;
    }
   /* free symtab */
   for ( ii = 0; ii < nextentry; ii++ ) free( symtab[ii] );
   nextentry = 0;
 }

/* utiledfo.c -- Utility functions */

/* Copyright (C) 1993 -- Data I/O Corporation -- All Rights Reserved.
 *
 * This program is protected under the copyright laws as a published work.
 * It may not be copied, reproduced, further distributed, adaptations
 * made from the same, or used to prepare derivative works, without the
 * prior written consent of the Data I/O Corporation
 *
 * History:
 *    5/05/93 - Included in Version 2.5
 *    5/11/93 - Changed Valid Identifier coding - PCN
 */

#include "stdafx.h"
#include "spikproc.h"
#include "funcs.h"

extern FILE *ascfile;
extern int skip_white_space;
extern int convert_brackets;

#define MAXNEST sizeof( blanks ) -1
#define INDENT 2
#define LEFT( c )   ( c == '[' || c == '(' || c == '<' || c == '{' )
#define RIGHT( c )  ( c == ']' || c == ')' || c == '>' || c == '}' )

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

static char blanks[] = "                    ";
static int nest, first;

static void indent()
 { int len;
   len = min( nest, MAXNEST );
   if ( len < 0 ) MajorError( "EDIF program error, indent < 0" );
   else if ( !skip_white_space )
      fwrite( blanks, 1, (unsigned int)len, ascfile );
 }

void Out( const char* ss, int flag )
 {
   if ( flag >= 0 )
    { if ( !first ) fprintf( ascfile, "\n" );            /* end previous line */
      indent();
    }
   /* the call to write ss must not be fprintf since ss may contain %s ... */
   fwrite( ss, 1, strlen( ss ), ascfile );
   nest = nest + flag * INDENT;
   first = 0;
 }

void Init_Out()
 {
   first = 1;
   nest = 0;
 }

/* IsValidIdentifier checks returns TRUE if the entire string is alphanumeric
   or underscore.  EDIF requires strings which begin with either a digit or
   an underscore to be preceded with an ampersand. */
static int IsValidIdentifier( const char* str )
 {
   while ( *str && ( *str == '_' || isalnum( *str ) ) ) str++;
   return( *str == '\0' );
 }

/* MakeValidIdentifier takes a string as input and creates a valid EDIF
   identifier.  The result identifier will start with an ampersand if the
   first character is not alpha.  Characters which are not alphanumeric or
   underscores will be converted to an octal escape sequences preceded by
   underscore.  As long as the user does not use octal escape sequences
   preceded by underscores there will not be any conflicts.  */
static char *MakeValidIdentifier( const char* str, char* result )
 { /* if first character is not alpha, add an ampersand */
   char* dd = result;
   if ( !isalpha( *str ) ) *dd++ = '&';
   for ( const char* cc = str; *cc; cc++, dd++ )
    { if ( isalnum( *cc ) || *cc == '_' ) *dd = *cc;
      else if ( convert_brackets && ( LEFT( *cc ) || RIGHT( *cc ) ) )
         *dd = '_';
      else
       { sprintf( dd, "_%03o", (int)*cc );               /* convert to number */
         dd += strlen( dd ) - 1;
       }
    }
   *dd = '\0';
   return( result );
 }

/* MakeValidString takes a string as input and creates a valid EDIF
   string.  The result string may be just the input string or it may have
   some %num% escape sequences in it. */
char *MakeValidString( const char* str, char* result )
 {
   char* dd = result;
   *dd++ = '"';
   for ( const char* cc = str; *cc; cc++, dd++ )
    { if ( *cc != '"' && *cc != '%' ) *dd = *cc;
      else
       { sprintf( dd, "%%%u%%", (int)*cc );              /* convert to number */
         dd += strlen( dd ) - 1;
       }
    }
   *dd++ = '"';
   *dd = '\0';
   return( result );
 }

/* MakeValidName takes a string as input and creates a valid EDIF
   nameDef.  The result name may be just the input string or it may have
   a rename construct. */
char *MakeValidName( const char* str, char* result )
 { char str1[256], str2[256];
   if ( IsValidIdentifier( str ) )
    { if ( isalpha( *str ) ) strcpy( result, str );
      else
       { *result = '&';
         strcpy( result+1, str );
       }
    }
   else
    { MakeValidIdentifier( str, str1 );
      MakeValidString( str, str2 );
      sprintf( result, "(rename %s %s)", str1, str2 );
    }
   return( result );
 }

/* MakeValidRef takes a string as input and creates a valid EDIF
   nameRef.  The result name may be either the input string or a
   valid identifier. */
char *MakeValidRef( const char* str, char* result )
 {
   if ( IsValidIdentifier( str ) )
    { if ( isalpha( *str ) ) strcpy( result, str );
      else
       { *result = '&';
         strcpy( result+1, str );
       }
    }
   else MakeValidIdentifier( str, result );
   return( result );
 }

/* MakeValidNumberValue takes a string as input and creates a valid EDIF
   numberValue.  The result string may be just the input string or it may have
   an expression e(nn -4). */
char *MakeValidNumberValue( const char* str, char* result )
 { /* we should use the function ScaledNumber in pik */
   int exp, neg;
   exp = neg = 0;
   long mantissa = 0L;
   const char* cc = str;
   while ( *cc == ' ' ) cc++;                          /* skip leading spaces */
   if ( *cc == '-' )
    { cc++;
      neg = 1;
    }
   for ( mantissa = 0L; *cc && isdigit( *cc ); cc++ )
    { mantissa = 10 * mantissa + *cc - '0';
    }
   if ( *cc == '.' )
    { cc++;
      for ( ; *cc && isdigit( *cc ); cc++, exp-- )
       { mantissa = 10 * mantissa + *cc - '0';
       }
    }
   if ( neg ) mantissa = -mantissa;
   if ( exp == 0 )
      sprintf( result, "%ld", mantissa );
   else
      sprintf( result, "(e %ld %d)", mantissa, exp );
   return( result );
 }

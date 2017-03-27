/* low.c -- Low level parse for EDIF */

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

extern long tokenval;
extern long scale_num, scale_denom;

long integer_value;              /* generated by typedValue */
char *string_value;

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

static void e( long* mant, long* exp )
 {
   Match( '(' );
   MatchKeyword( K_E );
   if ( mant ) *mant = integerToken();
   if ( exp ) *exp = integerToken();
   Match( ')' );
 }

static void scaledInteger( long* mant, long* exp )
 {
   if ( lookahead == '(' ) e( mant, exp );
   else
    { if ( mant ) *mant = integerToken();
      if ( exp ) *exp = 0;
    }
 }

static void pt( POINT* xy )
/* perform coordinate mapping  */
 { long xx, yy;
   Match( '(' );
   MatchKeyword( K_PT );
   xx = integerValue();
   yy = -integerValue();      /* inverted for windows */
   /* scale the points here */
   SCALE_IT( xx );
   SCALE_IT( yy );
   /* KLUDGE, insert real range test here */
   if ( abs( xx ) >= 16384 || abs( yy ) >= 16384 )
      Warning( "Point outside world range" );
   xy->x = (int)xx;
   xy->y = (int)yy;
   Match( ')' );
 }

static long integer()
 { long retn = 0L;
   int key;
   Match( '(' );
   MatchKeyword( K_INTEGER );
   while ( lookahead != ')' )
    { if ( lookahead == '(' )
       { key = PeekAtKeyword();
         if ( key == K_INTEGERDISPLAY ) retn = integerDisplay();
         else IgnoreForm();                     /* dont allow nested integers */
       }
      else retn = integerValue();
      SkipRestOfForm();                             /* only allow one integer */
    }
   Match( ')' );
   return( retn );
 }

static char* string()
 { char *str = (char *)NULL;
   int key;
   Match( '(' );
   MatchKeyword( K_STRING );
   while ( lookahead != ')' )
    { if ( lookahead == '(' )
       { key = PeekAtKeyword();
         if ( key == K_STRINGDISPLAY ) str = stringDisplay();
         else IgnoreForm();                      /* dont allow nested strings */
       }
      else str = stringValue();
      SkipRestOfForm();                              /* only allow one string */
    }
   Match( ')' );
   return( str );
 }

/* -------------------------------------------------------------------------- */

static int false_()
 {
   Match( '(' );
   MatchKeyword( K_FALSE );
   Match( ')' );
   return( 0 );
 }

static int true_()
 {
   Match( '(' );
   MatchKeyword( K_TRUE );
   Match( ')' );
   return( 1 );
 }

int booleanValue()
 { int val = 0, key;
   if ( lookahead == '(' )
    { key = PeekAtKeyword();
      if ( key == K_FALSE ) val = false_();
      else val = true_();
    }
   return( val );
 }

long integerToken()
 { long ii = 0L;
   if ( lookahead == TOK_NUM ) ii = tokenval;
   Match( TOK_NUM );
   return( ii );
 }

long integerValue()
 {
   return( integerToken() );
 }

void numberValue( long* mant, long* exp )
 {
   scaledInteger( mant, exp );
 }

void pointValue( POINT* xy )
 {
   pt( xy );
 }

int typedValue()
 { int key = -1;
   if ( lookahead == '(' )
    { key = PeekAtKeyword();
      switch( key )
       { case K_STRING:
            string_value = string();
            break;
         case K_INTEGER:
            integer_value = integer();
            break;
         default:
            IgnoreForm();                 /* ignore other forms in typedValue */
       }
    }
   return( key );
 }

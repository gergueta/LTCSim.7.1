/* display.c -- Mid level parse for EDIF */

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

extern int font_height[];
extern int text_height, is_visible;
extern int path_width, border_width;

BYTE font_jus_rot;
int ignore_display = 0;
POINT TXxy;                   /* generated by display processing */

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

static int justify()
 { int just;
   Match( '(' );
   MatchKeyword( K_JUSTIFY );
   just = MatchConstant();
   Match( ')' );
   return( just );
 }

static int orientation()
 { int ori;
   Match( '(' );
   MatchKeyword( K_ORIENTATION );
   ori = MatchConstant();
   Match( ')' );
   return( ori );
 }

static void origin()
 {
   Match( '(' );
   MatchKeyword( K_ORIGIN );
   pointValue( &TXxy );
   Match( ')' );
 }

int display()
 { FIGUREDEF *def;
   int key;
   int font, just = C_LOWERLEFT, ori = C_R0;
   BYTE h_jus, v_jus;
   int save_ignore;

   if ( !ignore_display )
    { save_ignore = ignore_display;       /* dont bother with nested displays */
      ignore_display = 1;               /* so ignore all displays inside here */
      TXxy.x = TXxy.y = 0;                        /* default is origin at 0 0 */
      Match( '(' );
      MatchKeyword( K_DISPLAY );
      /* tricky since both figureGroupOverride and nameRef can have '(' */
      key = -1;
      if ( lookahead == '(' )
       { key = PeekAtKeyword();
         if ( key == K_FIGUREGROUPOVERRIDE ) figureGroupOverride();
       }
      if ( key != K_FIGUREGROUPOVERRIDE )
       {
         def = (FIGUREDEF *)nameRef( FIGURECLASS );     /* figureGroupNameRef */
         if ( def )
          { border_width = def->borderWidth;
            path_width = def->pathWidth;
            text_height = def->textHeight;
            is_visible = def->visible;
          }
       }
      while ( lookahead == '(' )
       { key = PeekAtKeyword();
         if ( key == K_JUSTIFY ) just = justify();
         else if ( key == K_ORIENTATION ) ori = orientation();
         else origin();
       }

      switch ( just )
       { case C_LOWERLEFT:
            h_jus = 0;
            v_jus = 0;
            break;
         case C_LOWERCENTER:
            h_jus = 1;
            v_jus = 0;
            break;
         case C_LOWERRIGHT:
            h_jus = 2;
            v_jus = 0;
            break;
         case C_CENTERLEFT:
            h_jus = 0;
            v_jus = 1;
            break;
         case C_CENTERCENTER:
            h_jus = 1;
            v_jus = 1;
            break;
         case C_CENTERRIGHT:
            h_jus = 2;
            v_jus = 1;
            break;
         case C_UPPERLEFT:
            h_jus = 0;
            v_jus = 2;
            break;
         case C_UPPERCENTER:
            h_jus = 1;
            v_jus = 2;
            break;
         case C_UPPERRIGHT:
            h_jus = 2;
            v_jus = 2;
            break;
         default:
            h_jus = 0;
            v_jus = 0;
            break;
       }
      /* only C_R0 and C_R90 are allowed so correct the others */
      switch ( ori )
       { case C_R0:
            font_jus_rot = (BYTE)( 1 + h_jus + 3 * v_jus );
            break;
         case C_R90:
            font_jus_rot = (BYTE)( 1 + h_jus + 3 * v_jus );
            font_jus_rot |= 0x10;
            break;
         case C_R180:
            font_jus_rot = (BYTE)( 1 + ( 2 - h_jus ) + 3 * ( 2 - v_jus ) );
            break;
         case C_R270:
            font_jus_rot = (BYTE)( 1 + ( 2 - h_jus ) + 3 * ( 2 - v_jus ) );
            font_jus_rot |= 0x10;
            break;
         case C_MX:
            font_jus_rot = (BYTE)( 1 + h_jus + 3 * ( 2 - v_jus ) );
            break;
         case C_MXR90:
            font_jus_rot = (BYTE)( 1 + h_jus + 3 * ( 2 - v_jus ) );
            font_jus_rot |= 0x10;
            break;
         case C_MY:
            font_jus_rot = (BYTE)( 1 + ( 2 - h_jus ) + 3 * v_jus );
            break;
         case C_MYR90:
            font_jus_rot = (BYTE)( 1 + ( 2 - h_jus ) + 3 * v_jus );
            font_jus_rot |= 0x10;
            break;
         default:
            font_jus_rot = (BYTE)( 1 + h_jus + 3 * v_jus );
            break;
       }
      /* find the font that is closest to the desired text_height */
      for ( font = 0; font < 7 && font_height[font] < text_height; font++ );
      if ( font > 0 && font_height[font] > text_height )
       { /* font is > text_height, see if smaller font is closer. */
         if ( text_height - font_height[font-1] <
              font_height[font] - text_height )
            font--;
       }
      font_jus_rot |= (BYTE)( font << 5 );

      Match( ')' );
      ignore_display = save_ignore;
    }
   else IgnoreForm();                               /* ignore_display is TRUE */
   return( !ignore_display );
 }

PROPERTYDEF* propertyDisplay( int Class )
 { PROPERTYDEF *def;
   int has_display = 0;
   Match( '(' );
   MatchKeyword( K_PROPERTYDISPLAY );
   def = (PROPERTYDEF *)nameRef( Class );
   while ( lookahead == '(' ) has_display = display();
   Match( ')' );
   if ( !has_display ) def = NULL;
   return( def );
 }

int keywordDisplay()
 { int key;
   int has_display = 0;
   Match( '(' );
   MatchKeyword( K_KEYWORDDISPLAY );
   key = PeekAtKeyword();
   MatchKeyword( key );
   while ( lookahead == '(' ) has_display = display();
   Match( ')' );
   if ( !has_display ) key = -1;
   return( key );
 }

char *stringDisplay()
 { char *buff;
   Match( '(' );
   MatchKeyword( K_STRINGDISPLAY );
   buff = stringValue();
   while ( lookahead != ')' ) display();
   Match( ')' );
   return( buff );
 }

long integerDisplay()
 { long retn;
   Match( '(' );
   MatchKeyword( K_INTEGERDISPLAY );
   retn = integerValue();
   while ( lookahead != ')' ) display();
   Match( ')' );
   return( retn );
 }

void numberDisplay( long* mant, long* exp )
 {
   Match( '(' );
   MatchKeyword( K_NUMBERDISPLAY );
   numberValue( mant, exp );
   while ( lookahead != ')' ) display();
   Match( ')' );
 }

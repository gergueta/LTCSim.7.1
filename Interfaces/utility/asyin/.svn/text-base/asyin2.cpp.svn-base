/* asyin2.c -- Low level parse for ASCII IN */

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
#include "attr.h"

extern char linebuf[];

extern PN_PTR current_pn;            /* remembers which pin gets the PinAttrs */
extern int ver24;

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

#define SCALE GRIDEXP - 2           /* number of bits to shift from 4 to GRID */

void Parse_Version()
 { int ver;
   sscanf( linebuf, "%*s %d", &ver );
   if ( ver < 4 ) ver24 = TRUE;                /* old version, convert to new */
 }

void Parse_SymbolType()
 { char buff[256];
   int type;

   buff[0] = '\0';
   sscanf( linebuf, "%*s %s", buff );
   type = SY_BLOCK;
   switch( GetConstant( buff ) )
    { case C_COMPONENT:
         type = SY_COMP;
         break;
      case C_GATE:
         type = SY_GATE;
         break;
      case C_CELL:
         type = SY_CELL;
         break;
      case C_BLOCK:
         type = SY_BLOCK;
         break;
      case C_GRAPHIC:
         type = SY_GRAPHIC;
         break;
      case C_PIN_SYMBOL:
         type = SY_PIN;
         break;
      case C_MASTER:
         type = SY_MASTER;
         break;
      case C_RIPPER:
         type = SY_RIPPER;
         break;
      default:
         SynError( "Invalid SymbolType" );
         break;
    }
   Set_Symbol_Type( type );
 }

void Parse_SymAttr()
 { char name[256], str[256], *enddigit;
   long num;
   if ( sscanf( linebuf, "%*s %s %[^\n]", name, str ) < 2 )
    { SynError( "Invalid SymAttr format" );
    }
   else
    { /* if the name is entirely a number, treat it as the attribute number */
      num = strtol( name, &enddigit, 10 );
      if ( *enddigit )                             /* name was not all digits */
       { num = GetSymAttrNumber( name );
         if ( num < 0 ) Warning( "Attribute not defined" );
       }
      else if ( num < 0 || num >= 255 )
         Warning( "Attribute number out of range" );
      if ( num < 0 || num >= 255 );
      else if ( num < 2 ) 
       { Warning( "Name or type attribute ignored" );
       }
      else Add_Attrib( (BYTE)num, str );
    }
 }

void Parse_Window()
 { int index, font;
   POINT xy;
   int x, y, ii;
   BYTE fjr;
   char just[256];
   if ( sscanf( linebuf, "%*s %d %d %d %s %d",
                         &index, &x, &y, just, &font ) < 5 )
    { SynError( "Invalid Window format" );
    }
   else
    { if ( ver24 )
       { x <<= SCALE;
         y <<= SCALE;
       }
      if ( index >= 255 )     /* should check GRAPHICWIN_File + NUMGRAPHICWINDOWS */
       { Warning( "Window index too large" );
       }
      font = Check_Font( font, "Window" );
      fjr = (BYTE)( font << 5 );
      ii = 0;
      if ( just[0] == 'V' )
       { ii = 1;
         fjr |= 0x10;
       }
      switch( just[ii] )
       { case 'l':
         case 'L':
            fjr |= 4;
            break;
         case 'c':
         case 'C':
            fjr |= 5;
            break;
         case 'r':
         case 'R':
            fjr |= 6;
            break;
         default:
            fjr |= 4;
            Warning(
               "Window Justify: left, center, right, vleft, vcenter, vright" );
            break;
       }
      xy.x = x; xy.y = y;
      Add_Twin( xy, fjr, (BYTE)index );
    }
 }

void Parse_Pin()
 { int nameloc, x, y, ii;
   POINT xy;
   BYTE fjr;
   char just[256];
   current_pn = 0;
   if ( sscanf( linebuf, "%*s %d %d %s %d", &x, &y, just, &nameloc ) < 4 )
    { SynError( "Invalid Pin format" );
    }
   else
    { if ( ver24 )
       { x <<= SCALE;
         y <<= SCALE;
         nameloc <<= SCALE;
       }
      fjr = 0;
      ii = 0;
      if ( just[0] == 'V' )
       { ii = 1;
         fjr |= 0x10;
       }
      switch( just[ii] )
       { case 'b':
         case 'B':
            fjr |= 2;
            break;
         case 'l':
         case 'L':
            fjr |= 4;
            break;
         case 'r':
         case 'R':
            fjr |= 6;
            break;
         case 't':
         case 'T':
            fjr |= 8;
            break;
         case 'n':
         case 'N':
            nameloc = 0;
            break;
         default:
            nameloc = 0;
            Warning(
               "Pin Justify: (v)bottom, (v)left, (v)top, (v)right or none" );
            break;
       }
      xy.x = x; xy.y = y;
      current_pn = Add_Pin( xy, (BYTE)nameloc, (BYTE)fjr, -1 );
    }
 }

void Parse_PinAttr()
 { char name[256], str[256], *enddigit;
   long num;
   if ( current_pn == 0 ) SynError( "PinAttr Without Pin" );
   else if ( sscanf( linebuf, "%*s %s %[^\n]", name, str ) < 2 )
    { SynError( "Invalid PinAttr format" );
    }
   else
    { /* if the name is entirely a number, treat it as the attribute number */
      num = strtol( name, &enddigit, 10 );
      if ( *enddigit )                             /* name was not all digits */
       { num = GetPinAttrNumber( name );
         if ( num < 0 ) Warning( "Pin attribute not defined" );
       }
      else if ( num < 0 || num >= 255 )
         Warning( "Pin attribute number out of range" );
      if ( num < 0 || num >= 255 );
      else
       { Add_Pin_Attrib( current_pn, (BYTE)num, str );
       }
    }
 }

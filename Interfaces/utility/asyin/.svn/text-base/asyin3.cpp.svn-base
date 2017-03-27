/* asyin3.c -- Parse for Graphics in Symbol and Schematic ASCII In */

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

extern char linebuf[];
extern int ver24;

#define FONT_OFFSET 2
#define SCALE GRIDEXP - 2           /* number of bits to shift from 4 to GRID */

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

#define swap( a, b )   { a^=(b^=(a^=b)); }

static int Parse_Width_Style( const char* width, const char* style )
 { int code = 0;

   if ( *width == 'w' || *width == 'W' ) code = GR_WIDE;
   if ( *style == 'd' || *style == 'D' )
    { if      ( !stricmp( style, "dash" ) )       code |= 0x10;
      else if ( !stricmp( style, "dot"  ) )       code |= 0x20;
      else if ( !stricmp( style, "dashdot" ) )    code |= 0x30;
      else if ( !stricmp( style, "dashdotdot" ) ) code |= 0x40;
    }
   return( code );
 }

int Check_Font( int font, const char* msg )
 { char string[120];
   if ( font < 0 || ( ver24 && font > 2 ) || font > 7 )
    { sprintf( string, "%s Font: Must be Between 0 and %d",
               msg, ver24 ? 2 : 7 );
      Warning( string );
      font = 2;
    }
   else if ( ver24 ) font += FONT_OFFSET;
   return( font );
 }

void Parse_Line()
 { POINT xy1, xy2;
   char buff[256], style[20];
   int x1, x2, y1, y2;
   *style = '\0';
   if ( sscanf( linebuf, "%*s %s %d %d %d %d %s",
                   buff, &x1, &y1, &x2, &y2, style ) < 5 )
    { SynError( "Invalid Line format" );
    }
   else
    { if ( ver24 )
       { x1 <<= SCALE;
         y1 <<= SCALE;
         x2 <<= SCALE;
         y2 <<= SCALE;
       }
      xy1.x = x1; xy1.y = y1; xy2.x = x2; xy2.y = y2;
      Add_Symbol_Grf( GR_LINE | Parse_Width_Style( buff, style ),
                      xy1, xy2, xy1, xy1 );
    }
 }

void Parse_Rectangle()
 { POINT xy1, xy2;
   char buff[256], style[20];
   int x1, x2, y1, y2;
   *style = '\0';
   if ( sscanf( linebuf, "%*s %s %d %d %d %d %s",
                    buff, &x1, &y1, &x2, &y2, style ) < 5 )
    { SynError( "Invalid Rectangle format" );
    }
   else
    { if ( ver24 )
       { x1 <<= SCALE;
         y1 <<= SCALE;
         x2 <<= SCALE;
         y2 <<= SCALE;
       }
      xy1.x = x1; xy1.y = y1; xy2.x = x2; xy2.y = y2;
      Add_Symbol_Grf( GR_RECT | Parse_Width_Style( buff, style ),
                      xy1, xy2, xy1, xy1 );
    }
 }

void Parse_Circle()
 { POINT xy1, xy2;
   char buff[256], style[20];
   int wid, hgt;
   int x1, x2, y1, y2;
   *style = '\0';
   if ( sscanf( linebuf, "%*s %s %d %d %d %d %s",
                    buff, &x1, &y1, &x2, &y2, style ) < 5 )
    { SynError( "Invalid Circle format" );
    }
   else
    { if ( ver24 )
       { x1 <<= SCALE;
         y1 <<= SCALE;
         x2 <<= SCALE;
         y2 <<= SCALE;
       }
      if ( x2 < x1 ) swap( x1, x2 ); /* keep rect sorted */
      if ( y2 < y1 ) swap( y1, y2 );
      wid = x2 - x1;
      hgt = y2 - y1;
      if ( wid != hgt )
       { Warning( "Circle must be circular" );
         wid = min( wid, hgt );
         x2 = x1 + wid;
         y2 = y1 + wid;
       }
      xy1.x = x1; xy1.y = y1; xy2.x = x2; xy2.y = y2;
      Add_Symbol_Grf( GR_CIRC | Parse_Width_Style( buff, style ),
                      xy1, xy2, xy1, xy1 );
    }
 }

void Parse_Arc()
 { POINT xy1, xy2, xy3, xy4;
   char buff[256], style[20];
   int wid, hgt;
   int x1, y1, x2, y2, x3, y3, x4, y4;
   *style = '\0';
   if ( sscanf( linebuf, "%*s %s %d %d %d %d %d %d %d %d %s", buff,
                      &x1, &y1, &x2, &y2, &x3, &y3, &x4, &y4, style ) < 9 )
    { SynError( "Invalid Arc format" );
    }
   else
    { if ( ver24 )
       { x1 <<= SCALE;
         y1 <<= SCALE;
         x2 <<= SCALE;
         y2 <<= SCALE;
         x3 <<= SCALE;
         y3 <<= SCALE;
         x4 <<= SCALE;
         y4 <<= SCALE;
       }
      if ( x2 < x1 ) swap( x1, x2 ); /* keep rect sorted */
      if ( y2 < y1 ) swap( y1, y2 );
      wid = x2 - x1;
      hgt = y2 - y1;
      if ( wid != hgt )
       { Warning( "Arc must be circular" );
         wid = min( wid, hgt );
         x2 = x1 + wid;
         y2 = y1 + wid;
       }
      xy1.x = x1; xy1.y = y1; xy2.x = x2; xy2.y = y2;
      xy3.x = x3; xy3.y = y3; xy4.x = x4; xy4.y = y4;
      Add_Symbol_Grf( GR_ARC | Parse_Width_Style( buff, style ),
                      xy1, xy2, xy3, xy4 );
    }
 }

void Parse_Text()
 { POINT xy;
   BYTE fjr;
   int font, x, y, ii;
   char just[256], str[256];
   if ( sscanf( linebuf, "%*s %d %d %s %d %[^\n]",
                         &x, &y, just, &font, str ) < 5 )
    { SynError( "Invalid Text format" );
    }
   else
    { if ( ver24 )
       { x <<= SCALE;
         y <<= SCALE;
       }
      font = Check_Font( font, "Text" );
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
               "Text Justify: left, center, right, vleft, vcenter, vright" );
            break;
       }
      xy.x = x; xy.y = y;
      Add_Symbol_Text( xy, fjr, str );
    }
 }

/* ascin2.c -- Low level parse for ASCII IN */

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

extern SI_PTR current_si;       /* remembers which instance gets the SymAttrs */
extern TB_PTR current_tb;     /* remembers which table gets the table entries */
extern int first_sheet;      /* remembers whether or not we have seen a sheet */
extern int ver24;

#define SCALE ( GRIDEXP - 2 )       /* number of bits to shift from 4 to GRID */

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

static int table_rows, table_cols;
static int sheet_number;

static int Check_Point( POINT xy )
 { int ok = 1;
   if ( xy.x & (GRID-1) || xy.y & (GRID-1) )
    { ok = 0;
      Warning( "Points must be on grid" );
    }
   return( ok );
 }

static int Check_45( int x1, int y1, int x2, int y2 )
 { int ok = 1;
   if ( x1 & (GRID-1) || y1 & (GRID-1) || x2 & (GRID-1) || y2 & (GRID-1) )
    { ok = 0;
      Warning( "Points must be on grid" );
    }
   else if ( x1 == x2 || y1 == y2 );
   else if ( x1 - x2 == y1 - y2 );
   else if ( x2 - x1 == y1 - y2 );
   else
    { ok = 0;
      Warning( "Points must be at 45 or 90 degree angles" );
    }
   return( ok );
 }

static int Check_90( int x1, int y1, int x2, int y2 )
 { int ok = 1;
   if ( x1 & (GRID-1) || y1 & (GRID-1) || x2 & (GRID-1) || y2 & (GRID-1) )
    { ok = 0;
      Warning( "Points must be on grid" );
    }
   else if ( x1 != x2 && y1 != y2 )
    { ok = 0;
      Warning( "Points must be at 90 degree angles" );
    }
   return( ok );
 }

void Parse_Version()
 { int ver = 0;
   sscanf( linebuf, "%*s %d", &ver );
   if ( ver < 4 ) ver24 = TRUE;                /* old version, convert to new */
 }

void Parse_Sheet()
 { int num, wide, high;
   if ( sscanf( linebuf, "%*s %d %d %d", &num, &wide, &high ) < 3 )
    { SynError( "Invalid sheet format" );
    }
   else
    { if ( ver24 )
       { wide <<= SCALE;
         high <<= SCALE;
       }
      if ( wide > 1000*GRID || high > 1000*GRID )
       { Warning( "Sheet width or height too large" );
         if ( wide > 1000*GRID )
            wide = 1000*GRID;
         if ( high > 1000*GRID )
            high = 1000*GRID;
       }
      if ( wide & (GRID-1) || high & (GRID-1) )
       { Warning( "Rounding up sheet width and height" );
         wide = ( wide + GRID ) & ~GRID;
         high = ( high + GRID ) & ~GRID;
       }
      if ( num < 1 || num > MAX_SHEETS )
       { Warning( "Invalid sheet number.. Using sheet 1" );
         num = 1;
       }
      if ( first_sheet )
       { SchematicInit( num, wide, high );
         first_sheet = 0;
       }
      else
       { CreateSchematicSheet( num, wide, high );
       }
      sheet_number = num;                               /* save for later use */
    }
 }

void Parse_BusTap()
 { POINT xy1, xy2;
   int x1, x2, y1, y2;
   if ( sscanf( linebuf, "%*s %d %d %d %d", &x1, &y1, &x2, &y2 ) < 4 )
    { SynError( "Invalid BusTap format" );
    }
   else
    { if ( ver24 )
       { x1 <<= SCALE;
         y1 <<= SCALE;
         x2 <<= SCALE;
         y2 <<= SCALE;
       }
      if ( !Check_90( x1, y1, x2, y2 ) );
      else
       { xy1.x = x1; xy1.y = y1; xy2.x = x2; xy2.y = y2;
         Add_Bus_Tap( xy1, xy2 );
       }
    }
 }

void Parse_Wire()
 { POINT xy1, xy2;
   int x1, x2, y1, y2;
   if ( sscanf( linebuf, "%*s %d %d %d %d", &x1, &y1, &x2, &y2 ) < 4 )
    { SynError( "Invalid Wire format" );
    }
   else
    { if ( ver24 )
       { x1 <<= SCALE;
         y1 <<= SCALE;
         x2 <<= SCALE;
         y2 <<= SCALE;
       }
      if ( !Check_45( x1, y1, x2, y2 ) );
      else
       { xy1.x = x1; xy1.y = y1; xy2.x = x2; xy2.y = y2;
         Add_Wire_Segment( xy1, xy2 );
       }
    }
 }

void Parse_Attr_Flag()
 { POINT xy;
   int x, y;
   if ( sscanf( linebuf, "%*s %d %d", &x, &y ) < 2 )
    { SynError( "Invalid AttrFlag format" );
    }
   else
    { if ( ver24 )
       { x <<= SCALE;
         y <<= SCALE;
       }
      xy.x = x; xy.y = y;
      if ( Check_Point( xy ) )
       { Add_Attr_Flag( xy );
       }
    }
 }

void Parse_Flag()
 { POINT xy;
   char str[256];
   int x, y;
   if ( sscanf( linebuf, "%*s %d %d %[^\n]", &x, &y, str ) < 3 )
    { SynError( "Invalid Flag format" );
    }
   else
    { if ( ver24 )
       { x <<= SCALE;
         y <<= SCALE;
       }
      xy.x = x; xy.y = y;
      if ( Check_Point( xy ) )
       { Filter_Net_Name( str );
         Add_Name_Flag( xy, str );
       }
    }
 }

void Parse_IOPin()
 { POINT xy;
   char dir[256];
   int x, y;
   BYTE io_flag;
   /* allow only x and y since we added the direction later */
   dir[0] = 'I';
   if ( sscanf( linebuf, "%*s %d %d %s", &x, &y, dir ) < 2 )
    { SynError( "Invalid IOPin format" );
    }
   else
    { if ( ver24 )
       { x <<= SCALE;
         y <<= SCALE;
       }
      xy.x = x; xy.y = y;
      if      ( dir[0] == 'I' ) io_flag = 1;
      else if ( dir[0] == 'O' ) io_flag = 2;
      else if ( dir[0] == 'B' ) io_flag = 3;
      else                      io_flag = 1;          /* to correct 1.2 files */
      if ( Check_Point( xy ) ) Set_IO_Flag( xy, io_flag );
    }
 }

void Parse_Symbol()
 { POINT xy;
   char name[256], rot[256];
   int x, y;
   BYTE r_m;
   current_si = 0;
   if ( sscanf( linebuf, "%*s %s %d %d %s", name, &x, &y, rot ) < 4 )
    { SynError( "Invalid Symbol format" );
    }
   else
    { if ( ver24 )
       { x <<= SCALE;
         y <<= SCALE;
       }
      xy.x = x; xy.y = y;
      if ( Check_Point( xy ) )
       { if ( rot[0] == 'M' || rot[0] == 'm' ) r_m = 4;
         else                                  r_m = 0;
         if ( rot[1] == '9' )      r_m |= 1;
         else if ( rot[1] == '1' ) r_m |= 2;
         else if ( rot[1] == '2' ) r_m |= 3;
         current_si = Place_Symbol( name, xy, r_m, FALSE, FALSE );
       }
    }
 }

void Parse_SymAttr()
 { char name[256], str[256];
   if ( sscanf( linebuf, "%*s %s %[^\n]", name, str ) < 2 )
    { SynError( "Invalid SymAttr format" );
    }
   else if ( current_si )
    {
      int nAttr = GetSymAttrNumber( name );
      if ( nAttr < 0 )
       {
         if ( ( nAttr = atoi( name ) ) && nAttr <= 255 )
          {
            Add_IA( current_si, nAttr, str );
          }
         else Warning( "Attribute not defined" );
       }
      else if ( nAttr == NAME &&
                !Validate_Instance_Name( str ) );
      else if ( SymAttrEditCode( nAttr ) & 0x12 )    /* special or overrideable */
       {
         Add_IA( current_si, nAttr, str );
       }
      else
       { Warning( "Attribute may not be overridden" );
       }
    }
   else SynError( "SymAttr without symbol instance" );
 }

void Parse_NetAttr()
 { char name[256], str[256];
   POINT xy;
   int x, y;
   NT_PTR nt;

   if ( sscanf( linebuf, "%*s %d %d %s %[^\n]", &x, &y, name, str ) < 4 )
    { SynError( "Invalid NetAttr format" );
    }
   else
    { if ( ver24 )
       { x <<= SCALE;
         y <<= SCALE;
       }
      xy.x = x; xy.y = y;
      if ( !Check_Point( xy ) );
      else if ( nt = Find_Net_At( xy ) )
       {
         int nAttr = GetNetAttrNumber( name );
         if ( nAttr < 0 )
          {
            if ( ( nAttr = atoi( name ) ) && nAttr <= 255 )
             { Add_NA( nt, nAttr, str );
             }
            else Warning( "Attribute not defined" );
          }
         else if ( nAttr )               /* anything but NAME */
          { Add_NA( nt, nAttr, str );
          }
         else
          { Warning( "Attribute may not be overridden" );
          }
       }
      else SynError( "No net for this NetAttr" );
    }
 }

void Parse_PinAttr()
 { char name[256], str[256];
   POINT xy;
   int x, y;
   SP_PTR sp;

   if ( sscanf( linebuf, "%*s %d %d %s %[^\n]", &x, &y, name, str ) < 4 )
    { SynError( "Invalid PinAttr format" );
    }
   else
    { if ( ver24 )
       { x <<= SCALE;
         y <<= SCALE;
       }
      xy.x = x; xy.y = y;
      if ( !Check_Point( xy ) );
      else if ( sp = Find_Pin_At( xy ) )
       {
         int nAttr = GetPinAttrNumber( name );
         if ( nAttr < 0 )
          {
            if ( ( nAttr = atoi( name ) ) && nAttr <= 255 )
             { Add_PA( sp, nAttr, str );
             }
            else Warning( "Attribute not defined" );
          }
         else if ( PinAttrEditCode( nAttr ) & 0x12 ) /* special or overrideable */
          {
            Add_PA( sp, nAttr, str );
          }
         else
          { Warning( "Attribute may not be overridden" );
          }
       }
      else SynError( "No pin for this PinAttr" );
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
    { SynError( "Invalid window format" );
    }
   else if ( current_si )
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
            Warning( "Window Justify: (v)left, (v)center, (v)right" );
            break;
       }
      xy.x = x; xy.y = y;
      Add_Twin_Override( current_si, xy, fjr, (BYTE)index );
    }
   else SynError( "Window without symbol instance" );
 }

void Parse_Table()
 { POINT xy;
   int x1, y1, nrows, ncols;
   int rowhgt, colwid, collabhgt, rowlabwid;
   BYTE fjr[6];
   int font[6];
   char just[6][32];
   int ii, jj;
   if ( sscanf( linebuf,
           "%*s %d %d %d %d %d %d %d %d %s %d %s %d %s %d %s %d %s %d %s %d",
                &x1, &y1, &nrows, &ncols, &rowhgt, &colwid,
                &collabhgt, &rowlabwid, just[0], &font[0], just[1], &font[1],
                just[2], &font[2], just[3], &font[3], just[4], &font[4],
                just[5], &font[5] ) < 20 )
    { SynError( "Invalid Table format" );
    }
   else
    { if ( ver24 )
       { x1 <<= SCALE;
         y1 <<= SCALE;
         rowhgt <<= SCALE;
         colwid <<= SCALE;
         collabhgt <<= SCALE;
         rowlabwid <<= SCALE;
       }
      for ( ii = 0; ii < 6; ii++ )
       { font[ii] = Check_Font( font[ii], "Table" );
         fjr[ii] = (BYTE)( font[ii] << 5 );
         jj = 0;
         if ( just[ii][0] == 'V' )
          { jj = 1;
            fjr[ii] |= 0x10;
          }
         switch( GetConstant( just[ii]+jj ) )
          { case C_NONE:
               break;
            case C_TOPLEFT:
               fjr[ii] |= 7;
               break;
            case C_TOPCENTER:
               fjr[ii] |= 8;
               break;
            case C_TOPRIGHT:
               fjr[ii] |= 9;
               break;
            case C_CENTERLEFT:
               fjr[ii] |= 4;
               break;
            case C_CENTERCENTER:
               fjr[ii] |= 5;
               break;
            case C_CENTERRIGHT:
               fjr[ii] |= 6;
               break;
            case C_BOTTOMLEFT:
               fjr[ii] |= 1;
               break;
            case C_BOTTOMCENTER:
               fjr[ii] |= 2;
               break;
            case C_BOTTOMRIGHT:
               fjr[ii] |= 3;
               break;
            default:
               Warning(
      "Table Justify: (v)topleft, (v)topcenter.. (v)bottomcenter .. none" );
               break;
          }
       }
      xy.x = x1; xy.y = y1;
      current_tb = Add_Table( xy, (BYTE)sheet_number, nrows, ncols,
                              rowhgt, colwid, collabhgt, rowlabwid, fjr );
      table_rows = nrows;     /* remember the # of rows and cols for the data */
      table_cols = ncols;
    }
 }

void Parse_TableAttr()
 { char str[256];
   int num;
   if ( sscanf( linebuf, "%*s %d %[^\n]", &num, str ) < 2 )
    { SynError( "Invalid TableData format" );
    }
   else if ( current_tb )
    { Add_Table_Attr( current_tb, (BYTE)num, str );
    }
   else SynError( "TableAttr without table" );
 }

void Parse_TableData()
 { char str[256];
   int row, col;
   if ( sscanf( linebuf, "%*s %d %d %[^\n]", &row, &col, str ) < 3 )
    { SynError( "Invalid TableData format" );
    }
   else if ( current_tb )
    {
      if ( row < table_rows && col < table_cols )
         Add_Table_Data( current_tb, row, (BYTE)col, str );
      else
         Warning( "TableData out of range" );
    }
   else SynError( "TableData without table" );
 }

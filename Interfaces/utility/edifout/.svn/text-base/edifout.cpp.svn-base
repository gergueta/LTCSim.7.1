/* edifout.c -- Output for Translator from symbol to EDIF */

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
#include "spikproc.h"
#include "mathmac.h"
#include "funcs.h"
#include <time.h>
#include "dwgctrl.h"

extern char FullFileName[];
extern int font_height[];

char SourceFileExt[] = ".sym";                  /* used by main to find files */
char ProgramName[] = "Symbol to EDIF";

int skip_white_space = FALSE;
int convert_brackets = FALSE;
FILE *ascfile;

char *just[] =
 { "", "LOWERLEFT",  "LOWERCENTER",  "LOWERRIGHT",
       "CENTERLEFT", "CENTERCENTER", "CENTERRIGHT",
       "UPPERLEFT",  "UPPERCENTER",  "UPPERRIGHT"
 };
int pin_count;

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

static char *symbol_type[] =
 { "", "COMPONENT", "GATE", "CELL", "BLOCK", "GRAPHIC",
   "PIN", "MASTER", "RIPPER"
 };

		/*---------- Do_Graphic ----------*/

static int first_grf = 1;

static int Do_Graphic( struct _gr_item* gr_item )
 {
   POINT xy[4];
/* POINT xyt; */
   int rad, angle, angle1, angle2;
   char str[256];
   static int gr_width;
   /* need to add support for styled lines here */
   if ( first_grf || gr_item->width != gr_width )
    { if ( !first_grf ) Out( ")", -1 ); /* figure */
      if ( !gr_item->width ) Out( "(figure NORMAL", 1 );
      else Out( "(figure WIDE", 1 );
      gr_width = gr_item->width;
      first_grf = 0;
    }

   switch ( gr_item->type )
    { case GR_LINE:
	 sprintf( str, "(path (pointList (pt %d %d) (pt %d %d)))",
		  gr_item->x[0], -gr_item->y[0],
		  gr_item->x[1], -gr_item->y[1] );
	 Out( str, 0 );
	 break;
      case GR_RECT:
	 sprintf( str, "(rectangle (pt %d %d) (pt %d %d))",
		  gr_item->x[0], -gr_item->y[0],
		  gr_item->x[1], -gr_item->y[1] );
	 Out( str, 0 );
	 break;
      case GR_CIRC:
	 xy[0].x = gr_item->x[0];
	 xy[1].x = gr_item->x[1];
	 xy[0].y = gr_item->y[0];
	 xy[1].y = gr_item->y[1];
	 rad = ( xy[1].x - xy[0].x + 1 ) / 2;
	 xy[0].y = xy[1].y = xy[0].y + rad;
	 sprintf( str, "(circle (pt %d %d) (pt %d %d))",
		       xy[0].x, -xy[0].y, xy[1].x, -xy[1].y );
	 Out( str, 0 );
	 break;
      case GR_ARC:
	 Out( "(openShape", 1 );
	 Out( "(curve", 1 );
	 xy[0].x = gr_item->x[0];
	 xy[1].x = gr_item->x[1];
	 xy[2].x = gr_item->x[2];
	 xy[3].x = gr_item->x[3];
	 xy[0].y = gr_item->y[0];
	 xy[1].y = gr_item->y[1];
	 xy[2].y = gr_item->y[2];
	 xy[3].y = gr_item->y[3];
	 rad = ( xy[1].x - xy[0].x + 1 ) / 2;
	 xy[0].x += rad;
	 xy[0].y += rad;   /* center point */
	 angle1 = ANGLE_AT( xy[2], xy[0] );
	 angle2 = ANGLE_AT( xy[3], xy[0] );
	 if ( angle2 <= angle1 ) angle2 += 360;
	 angle = ( angle1 + angle2 +1 ) /2;
	 POLAR_TO_RECT( rad, angle, &xy[1].x, &xy[1].y );
/*       xyt.x = Rsin( xy[2].x - xy[0].x, 90 - ( angle - angle1 ) )
	       + Rsin( xy[2].y - xy[0].y, angle - angle1 );
	 xyt.y = -Rsin( xy[2].x - xy[0].x, angle - angle1 )
	       + Rsin( xy[2].y - xy[0].y, 90 - ( angle - angle1 ) );
	 xyt.x += xy[0].x;
	 xyt.y += xy[0].y;    */
	 xy[0].x += xy[1].x;
	 xy[0].y += xy[1].y;
	 sprintf( str, "(arc (pt %d %d) (pt %d %d) (pt %d %d))",
		  xy[2].x, -xy[2].y, xy[0].x, -xy[0].y, xy[3].x, -xy[3].y );
	 Out( str, 0 );
	 Out( ")", -1 ); /* curve */
	 Out( ")", -1 ); /* openShape */
	 break;
    }
   return( FALSE );
 }

		/*---------- Do_Graphic_Text ----------*/

static int Do_Graphic_Text( struct _gr_text* gr_text )
 { char str[256];
   char str1[256];
   Out( "(annotate", 1 );
   MakeValidString( gr_text->string, str1 );
   sprintf( str, "(stringDisplay %s", str1 );
   Out( str, 1 );
   if ( gr_text->font != 2 )
    { sprintf( str, "(display (figureGroupOverride NORMAL (textHeight %d))",
			 font_height[ gr_text->font ] );
    }
   else
    { sprintf( str, "(display NORMAL" );
    }
   Out( str, 1 );
   sprintf( str, "(justify %s)", just[ gr_text->just ] );
   Out( str, 0 );
   if ( gr_text->rot )
      Out( "(orientation R90)", 0 );
   sprintf( str, "(origin (pt %d %d))", gr_text->x, -gr_text->y );
   Out( str, 0 );
   Out( ")", -1 ); /* display */
   Out( ")", -1 ); /* stringDisplay */
   Out( ")", -1 ); /* annotate */
   return( FALSE );
 }

static void Do_Symbol()
 { char str[256];
   struct _bounding_box* box;

   Out( "(interface", 1 );
   pin_count = 0;
   ForEachSymbolPin( Do_Pins );
   ForEachSymbolAttribute( 0, 255, Do_Symbol_Attributes );
   ForEachSymbolTextWindow( Define_Window_Attrs );

   Out( "(symbol", 1 );
   box = GetSymbolBoundingBox();
   sprintf( str, "(boundingBox (rectangle (pt %d %d) (pt %d %d)))",
	    box->l, -box->t, box->r, -box->b );
   Out( str, 0 );

   pin_count = 0;
   ForEachSymbolPin( Do_Pin_Locations );
   ForEachSymbolTextWindow( Do_Window );
   first_grf = 1;
   ForEachSymbolGraphicItem( Do_Graphic );
   if ( first_grf == 0 )
      Out( ")", -1 ); /* figure */
   ForEachSymbolGraphicText( Do_Graphic_Text );
   Out( ")", -1 ); /* symbol */
   Out( ")", -1 ); /* interface */
 }

static void Edif_Out( const char* filename )
 { char str[_MAX_PATH], str1[_MAX_PATH], *str2;
   struct _date_time *date;
   long ScaleMantissa;
   int ScaleExponent;
   int type;
   char name[_MAX_PATH];

   strcpy( name, filename );                          /* filename is file.edf */
   AddExt( name, "" );
   strupr( name );

   MakeValidName( name, str1 );
   sprintf( str, "(edif %sSym", str1 );
   Out( str, 1 );
   Out( "(edifVersion 2 0 0)", 0 );
   Out( "(edifLevel 0)", 0 );
   Out( "(keywordMap (keywordLevel 0))", 0 );
   Out( "(status", 1 );
   Out( "(written", 1 );
   /* time is supposed to be Greenwich Mean Time */
   date = GetSymbolDateTime();
   sprintf( str, "(timeStamp %d %d %d %d %d %d)", date->year, date->mon,
	    date->day, date->hour, date->minute, date->sec );
   Out( str, 0 );

   GetProductName( str, sizeof(str) );
   /* In case the Product has funny chars, convert it */
   MakeValidString( str, str1 );
   sprintf( str, "(program %s", str1 );
   Out( str, 1 );
   GetProductVersion( str, sizeof(str) );
   MakeValidString( str, str1 );
   sprintf( str, "(Version %s)", str1 );
   Out( str, 0 );
   Out( ")", -1 ); /* program */
   Out( ")", -1 ); /* written */
   Out( ")", -1 ); /* status */

   Out( "(library USER (edifLevel 0)", 1 );
   Out( "(technology", 1 );
   Out( "(numberDefinition", 1 );
   /* BASIC_GRID := ScaleMantissa * 10 exp( ScaleExponent ) Meters */
   ScaleMantissa = CTL_Grid;
   if ( CTL_Metric == 1 ) ScaleExponent = -4;                  /* centimeters */
   else if ( CTL_Metric == 2 ) ScaleExponent = -5;             /* millimeters */
   else                                                             /* inches */
    { ScaleExponent = -6;
      ScaleMantissa *= 254;
    }
   sprintf( str, "(scale %d (e %ld %d) (unit distance))",
	    GRID, ScaleMantissa, ScaleExponent );
   Out( str, 0 );
   Out( ")", -1 ); /* numberDefinition */
   Out( "(figureGroup NORMAL", 1 );
   Out( "(pathWidth 0) (borderWidth 0)", 0 );
   sprintf( str, "(textHeight %d)", font_height[2] );
   Out( str, 0 );
   Out( ")", -1 ); /* figureGroup */
   Out( "(figureGroup WIDE", 1 );
   Out( "(pathWidth 1) (borderWidth 1)", 0 );
   sprintf( str, "(textHeight %d)", font_height[2] );
   Out( str, 0 );
   Out( ")", -1 ); /* figureGroup */
   Out( ")", -1 ); /* technology */

   MakeValidName( name, str1 );
   sprintf( str, "(cell %s (cellType GENERIC)", str1 );
   Out( str, 1 );
   type = SymbolType();
   sprintf( str, "(property SymbolType (string \"%s\"))", symbol_type[type] );
   Out( str, 0 );
   switch( type )
    { case SY_COMP:
      case SY_GATE:
	 str2 = "PCB_Symbol";
	 break;
      case SY_CELL:
      case SY_BLOCK:
	 str2 = "VLSI_Symbol";
	 break;
      case SY_GRAPHIC:
      case SY_MASTER:
      case SY_RIPPER:
      default:
	 str2 = "Graphic_Symbol";
	 break;
    }
   sprintf( str, "(view %s (viewType SCHEMATIC)", str2 );
   Out( str, 1 );

   Do_Symbol();

   Out( ")", -1 ); /* view */
   Out( ")", -1 ); /* cell */

   Out( ")", -1 ); /* library */

   Out( ")", -1 ); /* edif */
   Out( "", 0 );                   /* KLUDGE, final carriage return line feed */
 }

		      /*---------- Interface -----------*/

int Interface()
 { char filename[_MAX_PATH];
   strcpy( filename, FileInPath( FullFileName ) );
   if ( LoadSymbol( filename ) )
    { AddExt( filename, ".edf" );
      if ( ( ascfile = fopen( filename, "w" ) ) != NULL )
       { Init_Out();
         Edif_Out( filename );

         fclose( ascfile );
       }
      else
         MajorError( "Unable to open output file - Check permissions" );
     Free_Memory();              // release memory
    }
   else
    { char msg[300];
      sprintf( msg, "Unable to process symbol %s", filename );
      MajorError( msg );
    }
   return( 1 );
 }

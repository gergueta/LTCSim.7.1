/* asyout.c -- symbol to ascii using schematic PIK routines */

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

extern char FullFileName[];

extern int factor;          /* normally 1 but may be a power of 2 if dividing */
extern int grid;                           /* normally GRID but == 4 if ver24 */
extern int ver24;
extern int all_attributes;

char SourceFileExt[] = ".sym";                  /* used by main to find files */
char ProgramName[] = "Symbol to ASCII";

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

static FILE *ascfile;

static char *styles[] = { "", "DASH", "DOT", "DASHDOT", "DASHDOTDOT" };
static char *Just[] =
 { "Left", "Center", "Right", "VLeft", "VCenter", "VRight" };

char *PinJust[] =
 { "NONE", "BOTTOM", "LEFT", "RIGHT", "TOP", "", "", "",
   "", "VBOTTOM", "VLEFT", "VRIGHT", "VTOP", "", "", ""
 };

static char *type[] =
 { "", "COMPONENT", "GATE", "CELL", "BLOCK", "GRAPHIC",
       "PIN", "MASTER", "RIPPER"
 };

#define MAJOR( xx )    ( ( xx / grid / factor ) * grid )
#define MINOR( xx )    ( xx / factor ) 

		/*---------- Do_Symbol_Attributes ----------*/

static int Do_Symbol_Attributes( int num, const char* value )
{
	const char* lpszAttrName = GetSymAttrName( num );
	if ( *lpszAttrName )
		fprintf( ascfile, "SYMATTR %s %s\n", lpszAttrName, value );
	else if ( all_attributes )
		fprintf( ascfile, "SYMATTR %d %s\n", num, value );
	return( FALSE );
}

		/*---------- Do_Symbol_Pin_Attributes ----------*/

static int Do_Symbol_Pin_Attributes( int num, const char* value )
{
	const char* lpszAttrName = GetPinAttrName( num );
	if ( *lpszAttrName && *value )
		fprintf( ascfile, "PINATTR %s %s\n", lpszAttrName, value );
	else if ( all_attributes && *value )
		fprintf( ascfile, "PINATTR %d %s\n", num, value );
	return( FALSE );
}

		/*---------- Do_Pins ----------*/


static int Do_Pins( PN_PTR pn, struct _pin* pin )
 {
   fprintf( ascfile, "PIN %d %d  %s %d\n", MAJOR( pin->xo ), MAJOR( pin->yo ),
	    PinJust[ pin->name_dir / 2 ], MINOR( pin->name_offset ) );
   ForEachSymbolPinAttribute( pn, 0, 255, Do_Symbol_Pin_Attributes );
   return( FALSE );
 }

		/*---------- Do_Window ----------*/

static int Do_Window( struct _twin* twin )
 { int font;
   font = twin->font;
   if ( ver24 )
    { font -= 2;
      if ( font < 0 ) font = 0;
      if ( font > 2 ) font = 2;
    }
   fprintf( ascfile, "WINDOW %d %d %d %s %d\n",
	    twin->number, MINOR( twin->xo ), MINOR( twin->yo ),
	    Just[ (twin->just-1) % 3 + 3 * twin->rot ], font );
   return( FALSE );
 }

		/*---------- Do_Graphic ----------*/

static int Do_Graphic( struct _gr_item* gr_item )
 {
   if ( gr_item->type == GR_ARC )
      fprintf( ascfile, "ARC %s %d %d %d %d %d %d %d %d %s\n",
	 gr_item->width ? "Wide" : "Normal",
	 MINOR( gr_item->x[0] ), MINOR( gr_item->y[0] ),
	 MINOR( gr_item->x[1] ), MINOR( gr_item->y[1] ),
	 MINOR( gr_item->x[2] ), MINOR( gr_item->y[2] ),
	 MINOR( gr_item->x[3] ), MINOR( gr_item->y[3] ),
	 styles[ gr_item->style ] );
   else if ( gr_item->type == GR_CIRC )
      fprintf( ascfile, "CIRCLE %s %d %d %d %d %s\n",
	 gr_item->width ? "Wide" : "Normal",
	 MINOR( gr_item->x[0] ), MINOR( gr_item->y[0] ),
	 MINOR( gr_item->x[1] ), MINOR( gr_item->y[1] ),
	 styles[ gr_item->style ] );
   else if ( gr_item->type == GR_RECT )
      fprintf( ascfile, "RECTANGLE %s %d %d %d %d %s\n",
	 gr_item->width ? "Wide" : "Normal",
	 MINOR( gr_item->x[0] ), MINOR( gr_item->y[0] ),
	 MINOR( gr_item->x[1] ), MINOR( gr_item->y[1] ),
	 styles[ gr_item->style ] );
   else if ( gr_item->type == GR_LINE )
      fprintf( ascfile, "LINE %s %d %d %d %d %s\n",
	 gr_item->width ? "Wide" : "Normal",
	 MINOR( gr_item->x[0] ), MINOR( gr_item->y[0] ),
	 MINOR( gr_item->x[1] ), MINOR( gr_item->y[1] ),
	 styles[ gr_item->style ] );
   return( FALSE );
 }

		/*---------- Do_Graphic_Text ----------*/

static int Do_Graphic_Text( struct _gr_text* gr_text )
 { int font;
   font = gr_text->font;
   if ( ver24 )
    { font -= 2;
      if ( font < 0 ) font = 0;
      if ( font > 2 ) font = 2;
    }
   fprintf( ascfile, "TEXT %d %d %s %d %s\n",
	    MINOR( gr_text->x ), MINOR( gr_text->y ),
	    Just[ (gr_text->just-1) % 3 + 3 * gr_text->rot ],
	    font, gr_text->string );
   return( FALSE );
 }

		      /*---------- Interface -----------*/

int Interface()
 { char filename[_MAX_PATH];
   strcpy( filename, FileInPath( FullFileName ) );
   if ( LoadSymbol( filename ) )
    { AddExt( filename, ".asy" );
		strlwr ( filename );
      if ( ( ascfile = fopen( filename, "w" ) ) != NULL )
       { fprintf( ascfile, "Version %d\n", ver24 ? 3 : 4 );
         fprintf( ascfile, "SymbolType %s\n", type[ SymbolType() ] );

         ForEachSymbolGraphicItem( Do_Graphic );
         ForEachSymbolGraphicText( Do_Graphic_Text );
         ForEachSymbolTextWindow( Do_Window );
         ForEachSymbolAttribute( 0, 255, Do_Symbol_Attributes );
         ForEachSymbolPin( Do_Pins );

         fclose( ascfile );
       }
      else
         MajorError( "Unable to open output file - Check permissions" );
      Free_Memory();     // release memory
    }
   else
    { char msg[300];
      sprintf( msg, "Unable to process symbol %s", filename );
      MajorError( msg );
    }
   return( 1 );
 }

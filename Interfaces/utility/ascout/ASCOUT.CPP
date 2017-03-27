/* ascout.c - ascout program using the schematic PIK routines */

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
#include <atlstr.h> 


extern char FullFileName[];

extern int factor;          /* normally 1 but may be a power of 2 if dividing */
extern int grid;                           /* normally GRID but == 4 if ver24 */
extern int ver24;
extern int all_attributes;

char SourceFileExt[] = ".sch";
char ProgramName[] = "Schematic to ASCII";

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

static FILE *ascfile;
static int xo, yo;
static int sheet_number;
static int found_branch;
static char name[_MAX_PATH], symbol_type[_MAX_PATH];

static char *io[] = { "", "In", "Out", "BiDir" };
static char *styles[] = { "", "Dash", "Dot", "DashDot", "DashDotDot" };
static char *Just[] =
 { "Left", "Center", "Right", "VLeft", "VCenter", "VRight" };
static char *Fulljust[] =
 { "None", "BottomLeft", "BottomCenter", "BottomRight", "CenterLeft",
   "CenterCenter", "CenterRight", "TopLeft", "TopCenter", "TopRight" };
static char *rm[] =
 { "R0", "R90", "R180", "R270", "M0", "M90", "M180", "M270" };

#define MAJOR( xx )    ( ( xx / grid / factor ) * grid )
#define MINOR( xx )    ( xx / factor )

/* Determine full path to instance.
	 * This is done when InstanceName() won't work
	 * because we're in a block scan
	 */
char *determineFullInstPath( SI_PTR si )
{
	static char instPath[256];
	
	strcpy( instPath, Get_IA( si, NAME ));
	return( instPath );
}

void errorWithInstance( char *string, SI_PTR si )
{
	static char line[256];
	sprintf( line, "%s Inst = %s",
				string, determineFullInstPath( si ));
//	Error_Out( line );
}


                /*---------- Do_Wires ----------*/

static int Do_Wires( struct _wire* wire )
 {
   switch( wire->type )
    { case WT_WIRE:
      fprintf( ascfile, "WIRE %d %d %d %d\n", 
               MAJOR( wire->xo ), MAJOR( wire->yo ), 
               MAJOR( wire->x1 ), MAJOR( wire->y1 ) );
         break;
      case WT_NAME_FLAG:
         fprintf( ascfile, "FLAG %d %d %s\n", 
                  MAJOR( wire->xo ), MAJOR( wire->yo ), name );
         if ( wire->io_pin )
            fprintf( ascfile, "IOPIN %d %d %s\n", 
                     MAJOR( wire->xo ), MAJOR( wire->yo ), io[wire->io_pin] );
         break;
      case WT_BUS_TAP:
         fprintf( ascfile, "BUSTAP %d %d %d %d\n",
                  MAJOR( wire->x1 ), MAJOR( wire->y1 ), 
                  MAJOR( wire->xo ), MAJOR( wire->yo ) );
         break;
      case WT_ATTR_FLAG:
         if ( !found_branch )
          { found_branch = TRUE;
            xo = MAJOR( wire->x1 );
            yo = MAJOR( wire->y1 );
          }
         fprintf( ascfile, "ATTRFLAG %d %d\n", 
                  MAJOR( wire->xo ), MAJOR( wire->yo ) );
         break;
      case WT_SYMB_PIN:
      default:
         break;
    }
   return( FALSE );
 }

                /*---------- Do_Branch ----------*/

static int Do_Branch( BR_PTR br, int page )
 {
   ForEachWire( br, Do_Wires );
   return( FALSE );
 }

            /*---------- Find_Point_On_First_Branch ----------*/

static int Find_Point_On_First_Branch( struct _wire* wire )
 {
   found_branch = TRUE;
   xo = MAJOR( wire->xo );
   yo = MAJOR( wire->yo );
   return( TRUE );                                       /* abort immediately */
 }

                /*---------- Find_First_Branch ----------*/

static int Find_First_Branch( BR_PTR br, int page )
 {
   if ( page == sheet_number )      /* do the first branch on the first sheet */
      ForEachWire( br, Find_Point_On_First_Branch );
   return( TRUE );                                       /* abort immediately */
 }

                /*---------- Do_Net_Attributes ----------*/

static int Do_Net_Attributes( int num, const char* value )
{
	const char* lpszAttrName = GetNetAttrName( num );
	if ( *lpszAttrName )
		fprintf( ascfile, "NETATTR %d %d %s %s\n",
			xo, yo, lpszAttrName, value );
	else if ( all_attributes )
		fprintf( ascfile, "NETATTR %d %d %d %s\n", xo, yo, num, value );
	return( FALSE );
}

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
	if ( *lpszAttrName )
		fprintf( ascfile, "PINATTR %d %d %s %s\n",
			xo, yo, lpszAttrName, value );
	else if ( all_attributes )
		fprintf( ascfile, "PINATTR %d %d %d %s\n", xo, yo, num, value );
	return( FALSE );
}

                /*---------- Do_Net ----------*/

static int Do_Net( NT_PTR nt )
 {
   found_branch = FALSE;

   strcpy( name, Get_NA( nt, NAME ) );
   ForEachBranch( nt, sheet_number, Do_Branch );

   /* now see if there are any attributes */
   if ( !found_branch ) ForEachBranch( nt, 0, Find_First_Branch );
   if ( found_branch )    /* means we found a point on a branch on this sheet */
    { ForEachNetAttrib( nt, 1, 255, Do_Net_Attributes );         /* skip name */
    }
   return( FALSE );
 }

                /*---------- Do_Pins ----------*/

static int Do_Pins( SP_PTR sp, PN_PTR pn, struct _pin* pin )
 {
   xo = MAJOR( pin->xo );
   yo = MAJOR( pin->yo );
   ForEachInstancePinAttrib( sp, 0, 255, Do_Symbol_Pin_Attributes );
   return( FALSE );
 }

                /*---------- Do_Window_Overrides ----------*/

static int Do_Window_Overrides( struct _twin* twin )
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

                /*---------- Do_Symbol_Instance ----------*/

static int Do_Symbol_Instance( SI_PTR si, struct _inst* inst )
 {
	CString OldAttValue, NewAttValue;
	CString AttrPrefix, AttrShrink, AttrResize, AttrName;
	CString ErrorMessage;
	bool bTitle = false;
	bool bCMOS = false;
	int iTemp;
	char *sTemp;

	sTemp = Get_SIA( si, PREFIX );
	if ( *sTemp )
	{
		fprintf( ascfile, "SYMBOL HAS PREFIX\n" );
	}
	else
	{
		fprintf( ascfile, "SYMBOL DOES NOT HAVE PREFIX\n" );
	}
		

	AttrPrefix = Get_SIA( si, PREFIX );
	AttrName = Get_IA( si, NAME );
	bTitle = ( AttrName.CompareNoCase( "Title" ) == 0 );
	if ( bTitle )
	{
		fprintf( ascfile, "SYMBOL is TITLE\n" );
	}
	else
	{
		fprintf( ascfile, "SYMBOL is not TITLE\n" );
	}

	if ( AttrPrefix.CompareNoCase( "M" ) == 0 )
	{
		bCMOS = true;
	}
	if ( bCMOS )
	{
		ErrorMessage.AppendFormat( "%s is a MOS device",AttrName );
		MajorError( ErrorMessage );
		AttrShrink = Get_IA( si, SHRINK );
		AttrResize = Get_IA( si, GATE_RESIZE );

		OldAttValue = Get_IA( si, WIDTH );
		if (!( OldAttValue.Find( '{' ) == 0 ))
		{
			NewAttValue.Format("(%s*%s)",OldAttValue,AttrShrink);
			Add_IA( si, WIDTH, NewAttValue );
		}
		OldAttValue = Get_IA( si, LENGTH ); 
		if (!( OldAttValue.Find( '{' ) == 0 ))
		{
			NewAttValue.Format("((%s*%s)-%s)",OldAttValue,AttrShrink,AttrResize);
			Add_IA( si, LENGTH, NewAttValue );
		}
	}
	else if ( !bTitle )
	{
		SysError("It is not  MOS device");
		Add_IA( si, SHRINK, "$[SHRINK]");
		Add_IA( si, GATE_RESIZE, "$[RESIZE]");
		AttrShrink = Get_IA( si, SHRINK );
		AttrResize = Get_IA( si, GATE_RESIZE );

		OldAttValue = Get_IA( si, WN );
		if (!( OldAttValue.Find( '{' ) == 0 ))
		{
			NewAttValue.Format("(%s*%s)",OldAttValue,AttrShrink);
			Add_IA( si, WN, NewAttValue );
		}
		OldAttValue = Get_IA( si, LN ); 
		if (!( OldAttValue.Find( '{' ) == 0 ))
		{
			NewAttValue.Format("((%s*%s)-%s)",OldAttValue,AttrShrink,AttrResize);
			Add_IA( si, LN, NewAttValue );
		}
		OldAttValue = Get_IA( si, WP );
		if (!( OldAttValue.Find( '{' ) == 0 ))
		{
			NewAttValue.Format("(%s*%s)",OldAttValue,AttrShrink);
			Add_IA( si, WP, NewAttValue );
		}
		OldAttValue = Get_IA( si, LP ); 
		if (!( OldAttValue.Find( '{' ) == 0 ))
		{
			NewAttValue.Format("((%s*%s)-%s)",OldAttValue,AttrShrink,AttrResize);
			Add_IA( si, LP, NewAttValue );
		}
	}
   fprintf( ascfile, "SYMBOL %s %d %d %s\n",
          name, MAJOR( inst->xo ), MAJOR( inst->yo ), rm[inst->rot_mir] );
   //ForEachInstanceTextWindow( si, Do_Window_Overrides );
   ForEachInstanceAttrib( si, 0, 255, Do_Symbol_Attributes );
   //ForEachInstancePin( si, Do_Pins );
   return( FALSE );
 }

                /*---------- Do_Symbols ----------*/

static int Do_Symbols( ST_PTR st )
{
   strcpy( name, Get_DA( st, NAME ) );
   ForEachSymbolInstance( sheet_number, st, Do_Symbol_Instance );
   return( FALSE );
}

                /*---------- Do_Tables ----------*/

static int Do_Tables( TB_PTR tb, struct _table* table )
 { const char* val = "";
   int row, col, num, ii, font;
   fprintf( ascfile, "TABLE %d %d %d %d %d %d %d %d",
            MINOR( table->xo ), MINOR( table->yo ), table->rows, table->cols,
            MINOR( table->row_height ), MINOR( table->col_width ),
            MINOR( table->row_0_height ), MINOR( table->col_0_width ) );
   for ( ii = 0; ii < 6; ii++ )
    { font = table->font[ii];
      if ( ver24 )
       { font -= 2;
         if ( font < 0 ) font = 0;
         if ( font > 2 ) font = 2;
       }
      fprintf( ascfile, " %s%s %d", table->rot[ii] ? "V" : "",
               Fulljust[ table->just[ii] ], font );
    }
   fprintf( ascfile, "\n" );
   for ( num = 0; num < 2; num++ )                          /* name and title */
    { val = Get_Table_Attr( tb, num );
      if ( *val )
         fprintf( ascfile, "TABLEATTR %d %s\n", num, val );
    }
   for ( row = 0; row < table->rows; row++ )
    { for ( col = 0; col < table->cols; col++ )
       { val = Get_Table_Data( tb, row, col );
         if ( *val )
            fprintf( ascfile, "TABLEDATA %d %d %s\n", row, col, val );
       }
    }
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

                /*---------- Do_Sheet ----------*/

static int Do_Sheet( int number )
 {
   sheet_number = number;
   //fprintf( ascfile, "SHEET %d %d %d\n", number,
   //     MAJOR( GetSheetWidth( number ) ), MAJOR( GetSheetHeight( number ) ) );
   ForEachSymbolType( Do_Symbols );
	/* Do the busses first so the taps have a place to attach */
   //ForEachNonScalar( Do_Net );
   //ForEachScalar( Do_Net );
   //ForEachGraphicItem( sheet_number, Do_Graphic );
   //ForEachGraphicText( sheet_number, Do_Graphic_Text );
   //ForEachTable( sheet_number, Do_Tables );
   return( FALSE );
 }

                      /*---------- Interface -----------*/

int Interface()
 { char filename[_MAX_PATH];
   strcpy( filename, FileInPath( FullFileName ) );
   if ( LoadSchematic( filename ) )
    { AddExt( filename, ".asc" );
		strlwr ( filename );
      if ( ( ascfile = fopen( filename, "w" ) ) != NULL )
       { fprintf( ascfile, "Version %d\n", ver24 ? 3 : 4 );
         ForEachSheet( Do_Sheet );
				 SaveSchematic( FullFileName );
         fclose( ascfile );
       }
      else
         MajorError( "Unable to open output file - Check permissions" );
      Free_Memory();	// release memory
    }
   else
    { char msg[300];
      sprintf( msg, "Unable to process schematic %s", filename );
      MajorError( msg );
    }
   return( 1 );
 }

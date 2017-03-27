/* spikproc.h - Header file for schematic built applications */

/* Copyright (C) 1993 -- Data I/O Corporation -- All Rights Reserved.
 *
 * This program is protected under the copyright laws as a published work.
 * It may not be copied, reproduced, further distributed, adaptations
 * made from the same, or used to prepare derivative works, without the
 * prior written consent of the Data I/O Corporation
 *
 * History:
 *    5/05/93 - Included in Version 2.5
 *    4/18/94 - Added Prototypes for SortPinsByOrder - MJM
 *    4/25/94 - Added Prototypes for xsort - PCN
 */

#ifndef SPIKPROC_H_INVOKED
#define SPIKPROC_H_INVOKED


#include "scsdef.h"
#include "attr.h"
#include "platform.h"

#if !defined __TYPEDEF_H__
// Forward declarations
typedef unsigned short PTR;
typedef PTR GR_PTR;     // Graphics
typedef PTR TX_PTR;     // Text
typedef PTR PN_PTR;     // Pin Definition from Symbol
typedef PTR NT_PTR;     // Nets
typedef PTR BR_PTR;     // Branches
typedef PTR ST_PTR;     // Symbol Type Definition
typedef PTR SI_PTR;     // Symbol Instance
typedef PTR SP_PTR;     // Instance Pin
typedef PTR TB_PTR;     // Table Description
#endif  // ! TYPEDEF_H

struct _date_time { int year, mon, day, hour, minute, sec; };

struct _bounding_box { int l, t, r, b; };

struct _gr_item {
   short type;
   short width;
   short style;
   int x[4], y[4]; };

struct _gr_text {
   int x, y;
   short font;
   short rot;
   short just;
   const char* string; };

struct _pin {
   int xo, yo;
   short name_offset;
   short name_dir;
   short name_font; };

struct _twin {
   short number;
   int xo, yo;
   short font;
   short just;
   short rot; };

struct _inst {
   short page;
   int xo, yo;
   short rot_mir;
   int l, t, r, b; };

struct _wire {
   short type;
   int xo, yo, x1, y1;
   short name_flag;
   short io_pin;
   SP_PTR sp; };

#define WT_WIRE       0
#define WT_NAME_FLAG  1
#define WT_BUS_TAP    2
#define WT_SYMB_PIN   3
#define WT_ATTR_FLAG  4

struct _table {
   int xo, yo;
   short rows, cols;
   short row_0_height;
   short col_0_width;
   short row_height;
   short col_width;
   short font[6];               // for name, title, row0-col0, row0, col0, tableentry
   short just[6];
   short rot[6]; };

#if !defined(GRID)
#define GRID 16
#endif

// Symbol Type Definitions

#ifndef SY_COMP

#define SY_COMP      1          // Symbol Types
#define SY_GATE      2
#define SY_CELL      3
#define SY_BLOCK     4
#define SY_GRAPHIC   5
#define SY_PIN       6
#define SY_MASTER    7
#define SY_RIPPER    8

#define GR_LINE      1          // types for graphic lines
#define GR_RECT      2
#define GR_CIRC      3
#define GR_ARC       4

#endif

// Net Type Definitions - returned by NetLocExtGbl

#define LOCAL_NET    0
#define EXTERNAL_NET 1
#define GLOBAL_NET   2

// Loading and Saving Data
int         BuildTopSymbol();
int         CheckTopSymbol( char* );
void        Free_Memory();
char*       GetSchematicPath( const char* name );
char*       GetSymbolPath( const char* name );
int         Initialize();
int         LoadSchematic( const char* );
int         LoadSymbol( const char* );
int         LoadSymbolsUsed();
int         SaveSchematic( const char* );

// Active Symbol
int         Activate_Symbol_Type( ST_PTR );
ST_PTR      Active_Symbol_Type();
struct _bounding_box* GetSymbolBoundingBox();
struct _date_time* GetSymbolDateTime();
int         GetTypeOfSymbol();
int         MainSymbol();
int         SymbolType();

// Traversing the Symbol Data Structures
int         ForEachSymbolPin( int(*)( PN_PTR, struct _pin* ) );
int         ForEachSymbolPort( int(*)( PN_PTR, char*, char* ) );
int         ForEachSymbolTextWindow( int(*)( struct _twin* ) );
int         ForEachSymbolGraphicItem( int(*)( struct _gr_item* ) );
int         ForEachSymbolGraphicText( int(*)( struct _gr_text* ) );
int         SortPinsByOrder( int );

// Accessing the Symbol Data - Attributes
char*       Get_PNA( PN_PTR, int );
char*       Get_SYA( int );
int         ForEachSymbolAttribute( int, int, int(*)( int, const char* ) );
int         ForEachSymbolPinAttribute( PN_PTR, int, int, int(*)( int, const char* ) );

// Traversing the Schematic Data - Sheets
int         ForEachSheet( int(*)( int ) );
int         GetSheetHeight( int );
int         GetSheetWidth( int );

// Traversing the Schematic Data - Symbol Data
int         ForEachInstancePin( SI_PTR,
			int(*)( SP_PTR, PN_PTR, struct _pin* ) );
int         ForEachPortConnection( SI_PTR, int, int,
			   int(*)( const char*, const char*, const char* ) );
int         ForEachInstanceTextWindow( SI_PTR, int(*)( struct _twin* ) );
int         ForEachSymbolInstance( int, ST_PTR,
			   int(*)( SI_PTR, struct _inst* ) );
int         ForEachSymbolType( int(*)( ST_PTR ) );
NT_PTR      GetNetOnPin( SP_PTR );
int         ForEachInstPin( SI_PTR, int, int(*)( SP_PTR, PN_PTR ) );
int         ForEachInstance( ST_PTR, int, int(*)( SI_PTR ) );

// Traversing the Schematic Data - Net Data
int         ForEachBranch( NT_PTR, int, int(*)( BR_PTR, int ) );
int         ForEachBus( int(*)( NT_PTR ) );
int         ForEachBusContainingNet( NT_PTR, int(*)( NT_PTR ) );
int         ForEachNetFlattened( int(*)( NT_PTR ) );
int         ForEachNet( int(*)( NT_PTR ) );
int         ForEachNetPin( NT_PTR, int(*)( SP_PTR, PN_PTR ) );
int         ForEachNetInBus( NT_PTR, int(*)( NT_PTR ) );
int         ForEachNetNotBus( int(*)( NT_PTR ) );
int         ForEachScalar( int(*)( NT_PTR ) );
int         ForEachNonScalar( int(*)( NT_PTR ) );
int         ForEachWire( BR_PTR, int(*)( struct _wire* ) );

// Traversing the Schematic Data - Graphic Data
int         ForEachGraphicItem( int, int(*)( struct _gr_item* ) );
int         ForEachGraphicText( int, int(*)( struct _gr_text* ) );

// Traversing the Schematic Data - Miscellaneous Data
int         ForEachGlobalNetName( int(*)( const char* ) );
int         ForEachTable( int, int(*)( TB_PTR, struct _table* ) );
char*       GetPinCoordinates( SP_PTR sp );
char*       GetInstanceCoordinates( SI_PTR si );
int         IsGlobalNetName( const char* );

// Accessing the Schematic Data - Attributes
int         ForEachInstanceAttrib( SI_PTR, int, int, int(*)( int, const char* ) );
int         ForEachInstancePinAttrib( SP_PTR, int, int, int(*)( int, const char* ) );
int         ForEachNetAttrib( NT_PTR, int, int, int(*)( int, const char* ) );
int         ForEachTypeAttrib( ST_PTR, int, int, int(*)( int, const char* ) );
char*       GetRefDesignator( SI_PTR si );
char*       GetPinName( PN_PTR pn );
char*       GetPinNumber( SP_PTR sp, PN_PTR pn );
char*       GetInstanceName( SI_PTR si );
char*       Get_DA( ST_PTR, int );
char*       Get_IA( SI_PTR, int );
char*       Get_NA( NT_PTR, int );
char*       Get_PA( SP_PTR, int );
char*       Get_SIA( SI_PTR, int );
char*       Get_SPA( SP_PTR, PN_PTR, int );
char*       Get_Table_Attr( TB_PTR, int );
char*       Get_Table_Data( TB_PTR, int, int );

// Adding Schematic Data - Attribute Overrides
int         Add_DA( ST_PTR, int, const char* );
int         Add_IA( SI_PTR, int, const char* );
int         Add_NA( NT_PTR, int, const char* );
int         Add_PA( SP_PTR, int, const char* );
int         Add_Table_Attr( TB_PTR, int, const char* );
int         Add_Table_Data( TB_PTR, int, int, const char* );

// Schematic Data - Miscellaneous
int         ClearGlobalFlag( NT_PTR nt );
SP_PTR      FindPinWithAttribute( SI_PTR, int, const char* );
NT_PTR      FindNetNamed( const char* );
char*       GetCoordinateUnits();
int         GetGridSize();
SI_PTR      InstanceContainingPin( SP_PTR );
int         IsBusName( const char* );
int         IsFeedbackNet( NT_PTR );
int         InOutBidir( NT_PTR );
int         LocExtGbl( NT_PTR );
PN_PTR      MatchingSymbolPin( SP_PTR );
int         MarkFeedbackNets();
NT_PTR      NetContainingPin( SP_PTR );
NT_PTR      NetContainingPoint( int, int );
int         ParseInstanceName( SI_PTR, const char*, int(*)( SI_PTR, char* ) );
int         ParseList( const char*, int(*)( char* ) );
int         ParseNetName( const char*, int(*)( char* ) );
int         ParseNthNetName( int, char*, int (*)( char* ) );
int         PropagateBusIO();
ST_PTR      TypeOfInstance( SI_PTR );
int         TypeOfType( ST_PTR );

// Miscellaneous
void        CloseErrorFile();
int         ErrorMsg( const char* );
FILE*       OpenErrorFile( char* name );
int         ScaledNumber( const char*, int, int, long* );

// Utility functions
void        AddExt( char*, const char* );
int         ChangeToFilePath( const char* filename );
int         _CopyFile( const char* filename, const char* destpath );
char*       FileInPath( const char* );
char*       GetFilePath( const char* filename, char* path );
char*       GetFullFileName( const char* filename, char* full_name );
char*       GetIntlDateTimeString( char* );
int         GetProductName( char* buff, int buflen );
int         GetProductVersion( char* buff, int buflen );
int         LaunchEditor( const char* lpszFileName );
int         LaunchViewer( const char* lpszFileName );
int         MajorError( const char* );
int         SameFile( const char* filename1, const char* filename2 );
int         SpawnTask( const char*, const char*, int );
int         SpawnTaskEx( const char*, const char*, const char*, int nCmdShow );
int         SysError( const char* );
int         alphanumcmp( const char* str1, const char* str2 );
int         alphanumicmp( const char* str1, const char* str2 );
void        bsort( void* data, long count, size_t size,
				  int (*compare)( const void*, const void* ) );
void        xsort( void* data, long count, size_t size,
				  int (*compare)( const void*, const void* ) );

// Recursive processing functions
int         hierSetRootBlock( char *name, int data_len );
char*       hierGetNextBlock();
int         hierAddSubBlocks();
int         hierSetData( char* list );
int         hierGetData( char* list );
int         hierForEachBlock( int (*callback)( const char* name ) );
int         hierForEachInstance( int (*callback)( char* path ) );

// Library Paths
#define CURRENT_DIRECTORY 1
#define SYMBOL_PATHS      2
#define SCHEMATIC_PATHS   4

int         FindECSFile( const char* pszName, const char* pszExt, int nPathMode, char* pszResult );
HANDLE      OpenECSFile( const char* pszName, const char* pszExt, int nPathMode,
						char* pszResult, long* plLength );
// Definitions for/from utilmain

#define MAXNARGS  32
#define MAXARGLEN 256
int Parse_Command_File( char* name, char* argv[] );
void Free_Arg_List( int argc, char* argv[] );


#endif // invoked
/* sympi.h -- Symbol Database Procedural Interface */

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

#ifndef __SYMPI_H__
#define __SYMPI_H__

#include "scsdef.h"
#include "platform.h"

#if !defined(MAX_WIDTH)

#define MAX_WIDTH  GRID*400
#define MAX_HEIGHT GRID*400

#endif

#if !defined(GR_LINE)

#define GR_LINE      1
#define GR_RECT      2
#define GR_CIRC      3
#define GR_ARC       4
#define GR_TYPE      7
#define GR_WIDE      8

#endif	// !GR_LINE

#define GR_SOLID        0x0
#define GR_DASH         0x1
#define GR_DOT          0x2
#define GR_DASHDOT      0x3
#define GR_DASHDOTDOT   0x4

#if !defined(SY_COMP)

#define SY_COMP      1
#define SY_GATE      2
#define SY_CELL      3
#define SY_BLOCK     4
#define SY_GRAPHIC   5
#define SY_PIN       6
#define SY_MASTER    7
#define SY_RIPPER    8

#endif	// !SY_COMP

#if !defined __TYPEDEF_H__

typedef unsigned short PTR;
typedef PTR NT_PTR;  /* Nets */
typedef PTR BR_PTR;  /* Branches */
typedef PTR LK_PTR;  /* Bus Links */
typedef PTR ST_PTR;  /* Symbol Type Definition */
typedef PTR SI_PTR;  /* Symbol Instance */
typedef PTR SP_PTR;  /* Symbol Pin */
typedef PTR WO_PTR;  /* Attribute Window Overrides */
typedef PTR TB_PTR;  /* Table Description */
typedef PTR RW_PTR;  /* Table Row Header */
typedef PTR GR_PTR;  /* Graphics */
typedef PTR TX_PTR;  /* Text */
typedef PTR GP_PTR;  /* Points */
typedef PTR AT_PTR;  /* Generic Attributes */
typedef PTR PN_PTR;  /* Pin Definition from Symbol */
typedef PTR WN_PTR;  /* Symbol: Attribute Window Overrides */

#endif	// !__TYPEDEF_H__

// Generic Functions for all applications
void        AddExt( char*, const char* );
int         ChangeToFilePath( const char* filename );
int         _CopyFile( const char* filename, const char* destpath );
int         ErrorMsg( const char* );
char*       FileInPath( const char* );
char*       GetFilePath( const char* filename, char* path );
char*       GetFullFileName( const char* filename, char* full_name );
int         GetProductName( char* buff, int buflen );
int         GetProductVersion( char* buff, int buflen );
int         LaunchEditor( const char* lpszFileName );
int         LaunchViewer( const char* lpszFileName );
int         MajorError( const char* );
int         SameFile( const char* filename1, const char* filename2 );
int         SpawnTask( const char*, const char*, int );
int         SpawnTaskEx( const char*, const char*, const char*, int nCmdShow );
int         SysError( const char* );

// functions for both symbol and schematic
int         Filter_Net_Name( char* );
int         Initialize();

// functions for creating symbols
void        FreeSymbol();
void        Set_Origin( POINT xy );
int         Set_Symbol_Type( int type );
int         SymbolInit( int type );
int         SymbolSave( const char* );

// functions for adding data to symbol
int         Add_Attrib( BYTE, const char* );
PN_PTR      Add_Pin( POINT, BYTE, BYTE, int );
int         Add_Pin_Attrib( PN_PTR, BYTE, const char* );
GR_PTR      Add_Symbol_Grf( int type, POINT xy1, POINT xy2, POINT xy3, POINT xy4 );
TX_PTR      Add_Symbol_Text( POINT xy, BYTE font_jus_rot, const char* str );
WN_PTR      Add_Twin( POINT, BYTE, BYTE );
int         Set_Pin_Location( PN_PTR pn, POINT xy );
int         Set_Pin_Offset( PN_PTR, BYTE, BYTE );

// functions for creating schematics
int         Activate_Sheet( int );
int         CreateSchematicSheet( int num, int wide, int high );
void        FreeSchematic();
int         SchematicInit( int num, int wide, int high );
int         SchematicSave( const char* name );

// functions for adding data to schematic
int         Add_Attr_Flag( POINT xy );
int         Add_Bus_Tap( POINT xy1, POINT xy2 );
int         Add_IA( SI_PTR si, int num, const char* value );
int         Add_NA( NT_PTR nt, int num, const char* value );
int         Add_Name_Flag( POINT xy, const char* net_name );
int         Add_PA( SP_PTR sp, int num, const char* value );
int         Add_Wire_Segment( POINT xy1, POINT xy2 );
GR_PTR      Add_Schematic_Grf( int type, POINT xy1, POINT xy2, POINT xy3, POINT xy4 );
TX_PTR      Add_Schematic_Text( POINT xy, BYTE font_jus_rot, const char* str );
TB_PTR      Add_Table( POINT xy, BYTE page, int rows, int cols, int height, int width,
					  int labelhgt, int labelwid, const BYTE fjr[6] );
int         Add_Table_Attr( TB_PTR table, int num, const char* val );
int         Add_Table_Data( TB_PTR table, int row, int col, const char* val );
WO_PTR      Add_Twin_Override( SI_PTR si, POINT xy, BYTE font_jus_rot, BYTE index );
SI_PTR      Place_Symbol( const char* name, POINT xy, BYTE rm, int replace, int autoreplace );
GP_PTR      Set_IO_Flag( POINT xy, BYTE inout );

// functions for getting schematic data
SP_PTR      Find_Instance_Pin( SI_PTR si, const char* name );
NT_PTR      Find_Net( const char* name );
NT_PTR      Find_Net_At( POINT xy );
SP_PTR      Find_Pin_At( POINT xy );
SI_PTR      Find_Symbol_Instance( const char* name );
POINT*      Get_Instance_Loc( SI_PTR si );
POINT*      Get_Instance_Pin_Loc( SP_PTR sp );
int         Validate_Instance_Name( char* string );

// Library Paths
#define CURRENT_DIRECTORY 1
#define SYMBOL_PATHS      2
#define SCHEMATIC_PATHS   4

int         FindECSFile( const char* pszName, const char* pszExt, int nPathMode, char* pszResult );
HANDLE      OpenECSFile( const char* pszName, const char* pszExt, int nPathMode,
						char* pszResult, long* plLength );

#endif  // __SYMPI_H__

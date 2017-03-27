/* funcs.h -- function definitions */

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

void        Parse_Arc();
void        Parse_Circle();
void        Parse_Line();
void        Parse_Pin();
void        Parse_PinAttr();
void        Parse_Rectangle();
void        Parse_SymAttr();
void        Parse_SymbolType();
void        Parse_Text();
void        Parse_Version();
void        Parse_Window();
int         Check_Font( int font, const char* msg );

int         Asc_In();
int         GetConstant( const char* );
int         GetLine();
void        InitLex( int );
int         Interface();
int         Parse( int, const char* );
void        SynError( const char* );
void        Warning( const char* );

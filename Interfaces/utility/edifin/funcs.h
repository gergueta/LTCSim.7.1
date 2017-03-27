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

/* functions from symbol */
void        Arc_Extents( POINT, POINT, POINT, POINT, RECT* );
int         Arc_Three( POINT, POINT, POINT, POINT* );
int         Circle_Two( POINT, POINT, POINT* );

/* miscellaneous functions */
void        Free_Names();
int         GetNextToken();
void        IgnoreForm();
void        Init( int );
int         Interface();
int         Lexan();
int         Match( int );
int         MatchConstant();
int         MatchKeyword( int );
void        Parse( int, const char* );
int         PeekAtKeyword();
void        Quit();
void        SkipRestOfForm();
void        Start();
void        TokenStr( int, char*, int );
void        Warning( const char* );

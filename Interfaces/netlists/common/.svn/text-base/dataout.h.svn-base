/* $HDR$*/
/************************************************************************/
/* File archived using GP-Version                                       */
/* GP-Version is Copyright 1999 by Quality Software Components Ltd      */
/*                                                                      */
/* For further information / comments, visit our WEB site at            */
/* http://www.qsc.co.uk                                                 */
/************************************************************************/
/**/
/* $Log:  11170: Dataout.h 
/*
/*   Rev 1.0    5/4/2001 4:06:26 AM      Version: 5.0.0.4
*/
/*
/*   Rev 1.2    4/7/2001 2:36:36 AM  german_e    Version: 4.2.0.1
/* Added display of errors to navigator.
*/
/*
/*   Rev 1.1    9/13/2000 6:44:35 PM  german_e    Version: 4.0.0.9
/* Verify correctly if header is available in subdirectories before 
/* it copies the default header.
*/
/*
/*   Rev 1.0    8/2/2000 10:56:14 PM  supervisor
/* Initial Revision
*/
/**/
/* dataout.h -- Include for Output Functions */

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

#if defined(MAIN_FILE)
FILE *file;
char line[1024];
int error_count = 0;

/* max_line_len should be the absolute maximum length minus the number of
   characters before the newline in continue_str and comment_continue_str.
   line_len should be the desired line length minus the number of
   characters before the newline in continue_str and comment_continue_str. */

int max_line_len = 250, line_len = 79;
char *continue_str = "\n";
char *comment_continue_str = "\n";
char *begin_error_str = "";
char *end_error_str = "";
#else
extern FILE *file;
extern char line[];
extern int error_count;
extern int max_line_len, line_len;
extern char *continue_str, *comment_continue_str;
extern char *begin_error_str, *end_error_str;
#endif

void Data_Out( char * string , bool brackets );
void Error_Out( char * string );
void In_Comment( int mode );
static void Out_XDef_Net();
static void Out_Def_Net();

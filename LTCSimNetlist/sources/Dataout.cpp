#include "stdafx.h"
#define MAIN_FILE
#include "dataout.h"
#include "LTCUtils.h"
/*
#include <atlstr.h>
*/

#include <string.h>

using namespace std;
using namespace System;
using namespace LTCSimNetlist;

static int nLineLength = 0;
static int nInComment = 0;
extern char cCmd_Tool;
extern int bCmd_IgnoreCase;

FILE *errorFile;


void Data_Out(char* stringIn, bool brackets)
{
	int nLen, nTmp;
	/*
CString sBefore, sAfter;
*/
	String^ sBefore;

	LTCUtils ltcUtils;

	char *cc, *dd, *ee;
	/* filter the string to make sure that no line gets written greater than
the max_line_len.  If possible no lines will be longer than line_len */
	/*
strcpy( szTemp, stringIn );
sBefore  = CString( szTemp );
*/
	sBefore = ltcUtils.LtcCharsToString(stringIn);

	switch (cCmd_Tool)
	{
		case 'h':
			/*
		sBefore.Replace('{', '\'');
		sBefore.Replace('}', '\'');
		*/
			sBefore = sBefore->Replace('{', '\'');
			sBefore = sBefore->Replace('}', '\'');
			break;
		case 'a':
		case 'd':
		case 't':
			/*
		sBefore.Remove('{');
		sBefore.Remove('}');
		String^ MyString = "Hello World!";
		array<Char>^ MyChar = {'r','o','W','l','d','!',' '};
		String^ NewString = MyString->TrimEnd(MyChar);
		*/
			sBefore = sBefore->Replace("{", "");
			sBefore = sBefore->Replace("}", "");
			break;
	}

	/*
		if ( !bCmd_IgnoreCase )
		sBefore.MakeLower();
		*/
	if (!bCmd_IgnoreCase)
		sBefore = sBefore->ToLower();
	/*
		cc = sBefore.GetBuffer();
		*/
	cc = ltcUtils.LtcStringToChars(sBefore);

	if (!brackets) {
		/*
		sBefore.Replace("[", "(");
		sBefore.Replace("]", ")");
		*/
		sBefore = sBefore->Replace('[', '(');
		sBefore = sBefore->Replace(']', ')');
	}
	while (cc && *cc)
	{
		dd = strchr(cc, '\n');
		if (dd == NULL) /* no more carriage returns to worry about */
			nLen = strlen(cc);
		else
			nLen = dd - cc; /* number of characters to write before the new_line */
		/* see if this string will overflow the desired line_len */
		if (nLen + nLineLength > line_len) /* wrap onto the next line */
		{ /* always try to avoid breaking the string */
			if (nLineLength) /* finish writing the preceding line */
			{
				if (nInComment)
				{
					fprintf(file, comment_continue_str);
					/* comment_continue_str always contains a newline */
					nLineLength = strlen(comment_continue_str) - 1;
				}
				else
				{
					fprintf(file, continue_str);
					/* continue_str always contains a newline */
					nLineLength = strlen(continue_str) - 1;
				}
			}
			/* see if this string will overflow the desired max_line_len */
			if (nLen + nLineLength > max_line_len) /* line is too long */
			{ /* break the line as many times as necessary */
				while (nLen > 0)
				{ /* see if it is still necessary to break the string */
					if (nLen + nLineLength > line_len) /* break the string */
					{
						/* guess at a point to break the string, then find a space */
						nTmp = line_len - nLineLength - 1; /* start at desired end */
						ee = cc + nTmp;
						while (ee > cc && *ee != ' ') ee--; /* back up to a space */
						/* if no a space before desired line end, search forward */
						if (*ee != ' ') /* we didn't find space */
						{
							ee = cc + nTmp; /* return to previous guess point */
							/* look for a space or a newline to break the string */
							while (*ee && *ee != ' ' && *ee != '\n' &&
								ee < cc + max_line_len - nLineLength - 1) ee++;
							/* if we never found a space, it breaks at max_line_len */
						}
					}
					else ee = cc + nLen;
					fwrite(cc, 1, ee - cc, file);
					nLen -= ee - cc;
					nLineLength += ee - cc;
					cc = ee;
					if (nLen > 0)
					{
						if (nInComment)
						{
							fprintf(file, comment_continue_str);
							/* comment_continue_str always contains a newline */
							nLineLength = strlen(comment_continue_str) - 1;
						}
						else
						{
							fprintf(file, continue_str);
							/* continue_str always contains a newline */
							nLineLength = strlen(continue_str) - 1;
						}
					}
				}
			}
			else /* write cc - dd as a single line */
			{
				fwrite(cc, 1, nLen, file);
				nLineLength += nLen;
			}
		}
		else if (nLen)
		{
			fwrite(cc, 1, nLen, file);
			nLineLength += nLen;
		}
		if (dd && *dd == '\n') /* write out a new_line */
		{
			fprintf(file, "\n");
			nLineLength = 0;
			dd++; /* skip past the new_line character */
		}
		cc = dd;
	}
}


void Error_Data_Out(char* string)
{
	int nLen, nTmp;
	char *szIllegalChar;

	char *cc, *dd, *ee;
	/* filter the string to make sure that no line gets written greater than
the max_line_len.  If possible no lines will be longer than line_len */
	cc = string;

	switch (cCmd_Tool)
	{
		case 'l':
		case 'p':
		case 'a':
		case 'd':
		case 't':
			while (szIllegalChar = strpbrk(cc, "{}"))
			{
				*szIllegalChar = ' ';
			}
			break;
		case 'h':
			while (szIllegalChar = strpbrk(cc, "{}"))
			{
				*szIllegalChar = '\'';
			}
			break;
	}
	while (szIllegalChar = strpbrk(cc, "["))
	{
		*szIllegalChar = '(';
	}
	while (szIllegalChar = strpbrk(cc, "]"))
	{
		*szIllegalChar = ')';
	}
	while (cc && *cc)
	{
		dd = strchr(cc, '\n');
		if (dd == NULL) /* no more carriage returns to worry about */
			nLen = strlen(cc);
		else
			nLen = dd - cc; /* number of characters to write before the new_line */
		/* see if this string will overflow the desired line_len */
		if (nLen + nLineLength > line_len) /* wrap onto the next line */
		{ /* always try to avoid breaking the string */
			if (nLineLength) /* finish writing the preceding line */
			{
				if (nInComment)
				{
					fprintf(errorFile, comment_continue_str);
					/* comment_continue_str always contains a newline */
					nLineLength = strlen(comment_continue_str) - 1;
				}
				else
				{
					fprintf(errorFile, continue_str);
					/* continue_str always contains a newline */
					nLineLength = strlen(continue_str) - 1;
				}
			}
			/* see if this string will overflow the desired max_line_len */
			if (nLen + nLineLength > max_line_len) /* line is too long */
			{ /* break the line as many times as necessary */
				while (nLen > 0)
				{ /* see if it is still necessary to break the string */
					if (nLen + nLineLength > line_len) /* break the string */
					{
						/* guess at a point to break the string, then find a space */
						nTmp = line_len - nLineLength - 1; /* start at desired end */
						ee = cc + nTmp;
						while (ee > cc && *ee != ' ') ee--; /* back up to a space */
						/* if no a space before desired line end, search forward */
						if (*ee != ' ') /* we didn't find space */
						{
							ee = cc + nTmp; /* return to previous guess point */
							/* look for a space or a newline to break the string */
							while (*ee && *ee != ' ' && *ee != '\n' &&
								ee < cc + max_line_len - nLineLength - 1) ee++;
							/* if we never found a space, it breaks at max_line_len */
						}
					}
					else ee = cc + nLen;
					fwrite(cc, 1, ee - cc, errorFile);
					nLen -= ee - cc;
					nLineLength += ee - cc;
					cc = ee;
					if (nLen > 0)
					{
						if (nInComment)
						{
							fprintf(errorFile, comment_continue_str);
							/* comment_continue_str always contains a newline */
							nLineLength = strlen(comment_continue_str) - 1;
						}
						else
						{
							fprintf(errorFile, continue_str);
							/* continue_str always contains a newline */
							nLineLength = strlen(continue_str) - 1;
						}
					}
				}
			}
			else /* write cc - dd as a single line */
			{
				fwrite(cc, 1, nLen, errorFile);
				nLineLength += nLen;
			}
		}
		else if (nLen)
		{
			fwrite(cc, 1, nLen, errorFile);
			nLineLength += nLen;
		}
		if (dd && *dd == '\n') /* write out a new_line */
		{
			fprintf(errorFile, "\n");
			nLineLength = 0;
			dd++; /* skip past the new_line character */
		}
		cc = dd;
	}
}


void Error_Out(char* string)
{
	int nSaveCommentMode;

	error_count++;
	nSaveCommentMode = nInComment;
	nInComment = TRUE;
	if (nLineLength) {
		Error_Data_Out("\n");
		Error_Data_Out(begin_error_str);
		Error_Data_Out(string);
		Error_Data_Out(end_error_str);
		Data_Out("\n", false);
		Data_Out(begin_error_str, false);
		Data_Out(string, false);
		Data_Out(end_error_str, false);
		nLineLength = max_line_len; /* force a new_line if more stuff is added */
	}
	else {
		Error_Data_Out(begin_error_str);
		Error_Data_Out(string);
		Error_Data_Out(end_error_str);
		Error_Data_Out("\n");
		Data_Out(begin_error_str, false);
		Data_Out(string, false);
		Data_Out(end_error_str, false);
		Data_Out("\n", false);
	}
	nInComment = nSaveCommentMode;
}

void In_Comment(int mode)
{
	nInComment = mode;
}





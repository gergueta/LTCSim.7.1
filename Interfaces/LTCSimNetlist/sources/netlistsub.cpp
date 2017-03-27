#include "netlistsub.h"

/*---------- Open_File ----------*/

static FILE* Open_File(const char* pszName, const char* pszExt)
{
	char pathname[_MAX_PATH];
	FILE *file = NULL;

	if (FindECSFile(pszName, pszExt, CURRENT_DIRECTORY | SCHEMATIC_PATHS, pathname) == 0){
		file = fopen(pathname, "r");
	}
	return(file);
}

/*---------- Merge_Macro_Files ----------*/

int Merge_Macro_File(char* def_name)
{
	char name[_MAX_PATH], buff[_MAX_PATH];
	char *bb;
	char *lst, *nn;
	TD_PTR td;
	int macro;
	int abort = FALSE;
	FILE * macrofile;
	char mExt[3];
	char mExtOpt[3];
	CString sTemp;

	switch (cCmd_Tool)
	{
	case 'l':
	case 'p':
		strcpy(mExt, ".p");
		break;
	case 'h':
		strcpy(mExt, ".h");
		break;
	case 'a':
		strcpy(mExt, ".a");
		strcpy(mExtOpt, ".l");
		break;
	case 'd':
	case 't':
		strcpy(mExt, ".l");
		break;
	}

	if (macrofile = Open_File(def_name, mExt)){
		macro = FALSE; /* have not started a macro yet */
		while (!abort && fgets(buff, sizeof(buff), macrofile)) {
			bb = strchr(buff, '.');
			if (bb) {
				if (macro && _strnicmp(bb, ".ends", 5) == 0) {
					/* End of Macro */
					sTemp = CString(buff);
					if (!bCmd_IgnoreCase) sTemp.MakeLower();
					fwrite(sTemp, 1, sTemp.GetLength(), file);/* write the last line */
					macro = FALSE;
				}
				if (strnicmp(bb, ".subckt ", 8) == 0) {
					/* starting a new one */
					sscanf(bb, "%*s %s", name); /* get the name */
					for (lst = list; *lst;) {
						/* check list for name */
						if (strcmp(lst, name)) while (*lst++);
						else break;
					}
					if (*lst == '\0') {
						/* not in the list yet */
						if (lst + strlen(name) + 2 - list > sizeof(list)) {
							if (!err)
								err = MajorError("Too many subckts to expand");
						}
						else {
							nn = name;
							while (*lst++ = *nn++); /* add to the list */
							*lst++ = '\0'; /* double NULL */
						}
						if (td = FindDescriptorNamed(name)) MarkBlockDone(td);
						macro = TRUE;
					}
				}
			}
			if (macro) /* if we are currently processing a macro */
			{
				sTemp = CString(buff);
				if (!bCmd_IgnoreCase) sTemp.MakeLower();
				fwrite(sTemp, 1, sTemp.GetLength(), file); /* write current line */
			}
		}
		fclose(macrofile);
	}
	else {
		if (macrofile = Open_File(def_name, mExtOpt)){
			macro = FALSE; /* have not started a macro yet */
			while (!abort && fgets(buff, sizeof(buff), macrofile)) {
				bb = strchr(buff, '.');
				if (bb) {
					if (macro && strnicmp(bb, ".ends", 5) == 0) {
						/* End of Macro */
						sTemp = CString(buff);
						if (!bCmd_IgnoreCase) sTemp.MakeLower();
						fwrite(sTemp, 1, sTemp.GetLength(), file); /* write current line */
						macro = FALSE;
					}
					if (strnicmp(bb, ".subckt ", 8) == 0) {
						/* starting a new one */
						sscanf(bb, "%*s %s", name); /* get the name */
						for (lst = list; *lst;) {
							/* check list for name */
							if (strcmp(lst, name)) while (*lst++);
							else break;
						}
						if (*lst == '\0') {
							/* not in the list yet */
							if (lst + strlen(name) + 2 - list > sizeof(list)) {
								if (!err)
									err = MajorError("Too many subckts to expand");
							}
							else {
								nn = name;
								while (*lst++ = *nn++); /* add to the list */
								*lst++ = '\0'; /* double NULL */
							}
							if (td = FindDescriptorNamed(name)) MarkBlockDone(td);
							macro = TRUE;
						}
					}
				}
				if (macro) /* if we are currently processing a macro */
				{
					sTemp = CString(buff);
					if (!bCmd_IgnoreCase) sTemp.MakeLower();
					fwrite(sTemp, 1, sTemp.GetLength(), file); /* write current line */
				}
			}
			fclose(macrofile);
		}
	}
	return(macrofile != (FILE *)NULL);
}
int Merge_Dracula_Header_File(char* def_name)
{
	char buff[_MAX_PATH];
	int abort = FALSE;
	FILE * headerfile;
	CString sTemp;

	if (headerfile = Open_File(def_name, ".lvh"))
	{
		while (!abort && fgets(buff, sizeof(buff), headerfile))
		{
			sTemp = CString(buff);
			if (!bCmd_IgnoreCase) sTemp.MakeLower();
			fwrite(sTemp, 1, sTemp.GetLength(), file);
		}
		fclose(headerfile);
	}
	return(headerfile != (FILE *)NULL);
}
int Merge_Assura_Header_File(char* def_name)
{
	char buff[_MAX_PATH];
	int abort = FALSE;
	FILE * headerfile;
	CString sTemp;

	if (headerfile = Open_File(def_name, ".alvh"))
	{
		while (!abort && fgets(buff, sizeof(buff), headerfile))
		{
			sTemp = CString(buff);
			if (!bCmd_IgnoreCase) sTemp.MakeLower();
			fwrite(sTemp, 1, strlen(sTemp), file);
		}
		fclose(headerfile);
	}
	return(headerfile != (FILE *)NULL);
}

int Merge_Digital_Macro_File(char* def_name)
{
	char name[_MAX_PATH], buff[_MAX_PATH];
	char *bb;
	char *lst, *nn;
	TD_PTR td;
	int macro;
	int abort = FALSE;
	FILE * macrofile;

	if (macrofile = Open_File(def_name, ".pd")) {
		macro = FALSE; /* have not started a macro yet */
		while (!abort && fgets(buff, sizeof(buff), macrofile)) {
			bb = strchr(buff, '.');
			if (bb) {
				if (macro && strnicmp(bb, ".ends", 5) == 0) {
					/* End of Macro */
					fwrite(buff, 1, strlen(buff), file);/* write the last line */
					macro = FALSE;
				}
				if (strnicmp(bb, ".subckt ", 8) == 0) {
					/* starting a new one */
					sscanf(bb, "%*s %s", name); /* get the name */
					for (lst = list; *lst;) {
						/* check list for name */
						if (strcmp(lst, name)) while (*lst++);
						else break;
					}
					if (*lst == '\0') {
						/* not in the list yet */
						if (lst + strlen(name) + 2 - list > sizeof(list)) {
							if (!err)
								err = MajorError("Too many subckts to expand");
						}
						else {
							nn = name;
							while (*lst++ = *nn++); /* add to the list */
							*lst++ = '\0'; /* double NULL */
						}
						if (td = FindDescriptorNamed(name)) MarkBlockDone(td);
						macro = TRUE;
					}
				}
			}
			if (macro) /* if we are currently processing a macro */
				fwrite(buff, 1, strlen(buff), file); /* write current line */
		}
		fclose(macrofile);
	}
	return(macrofile != (FILE *)NULL);
}





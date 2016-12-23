#include <stdafx.h>
#include "pikproc.h"
#include "dataout.h"
#include "spicprim.h"

#using <System.dll>

using namespace System;
using namespace System::Text::RegularExpressions;
using namespace System::Runtime::InteropServices;

#include <stdafx.h>

#define MAX_NETS 4
static char *inst, *element, elembuf[20];
static TI_PTR ti;
static TN_PTR nets[MAX_NETS];

long Get_Net_Number(TN_PTR);
void Add_Names_To_Flat_Cache(int);

static char net_name[256];

extern Tcl_Interp *interp;


/* Determine full path to instance.
 * This is done when InstanceName() won't work
 * because we're in a block scan
 */
char *determineFullInstPath(TI_PTR ti)
{
	static char instPath[256];
	char buf[256];
	buf[0] = '\0';
	TI_PTR myTi;
	TD_PTR myTd;
	int makingPath = TRUE;
	if (!bCmd_Flat){
		// Back-trace the instance path manually.
		// We'll make a path for example instance.
		myTi = ti;
		char *temp;

		temp = Get_TIA(ti, NAME);
		strcpy(instPath, Get_TIA(myTi, NAME));
		while (makingPath){
			if (myTd = OwnerOfInstance(myTi)){
				if (myTi = FirstInstanceOf(myTd)){
					sprintf(buf, "%s.%s", Get_TIA(myTi, NAME), instPath);
					strcpy(instPath, buf);
				}
			}
			else
				makingPath = FALSE;
		}
	}
	else // flat netlist
		strcpy(instPath, InstanceName(ti));
	return(instPath);
}

void errorWithInstance(char *string, TI_PTR ti)
{
	sprintf(line, "%s Inst = %s",
		string, determineFullInstPath(ti));
	Error_Out(line);
}

/* --------- LTC clean blanks ----------*/

char* No_Blanks(char* string)
{
	char szNewString[256];
	char szTempString[256];
	int iLength, i, j;

	strcpy(szTempString, string);
	iLength = strlen(szTempString);
	j = 0;
	for (i = 0; i < iLength; i++){
		if (szTempString[i] != ' '){
			szNewString[j] = szTempString[i];
			j++;
		}
	}
	szNewString[j] = '\0';
	strcpy(string, szNewString);
	return string;
}

bool LTCSimPassParamVal(char *value)
{
	sprintf(pattern, "{([^}]*)}");
	strcpy(sTclTxt, value);
	int idx = Tcl_RegExpMatch(interp, sTclTxt, pattern);
	if (idx > 0)
		return(true);
	else
		return(false);
}

char *LTCSimExtParam(char *value)
{
	char *sReturn;
	char command[256];

	sReturn = new char[strlen(value) + 10];
	// Trim spaces
	Tcl_SetVar(interp, "var", value, 0);
	sprintf(command, "string trim $var");
	Tcl_Eval(interp, command);
	strcpy(sTclTxt, Tcl_GetVar(interp, "var", 0));
	// Remove {} if found
	sprintf(pattern, "{([^}]*)}");
	Tcl_SetVar(interp, "pattern", pattern, 0);
	sprintf(command, "regexp  $pattern $var match value");
	Tcl_Eval(interp, command);
	strcpy(sTclTxt, Tcl_GetVar(interp, "value", 0));
	strcpy(sReturn, sTclTxt);
	return(sReturn);
}

char *LTCSimReplacePFByP(char *value)
{
	char *sReturn;
	char command[256];

	sReturn = new char[strlen(value) + 10];
	// Trim spaces
	Tcl_SetVar(interp, "var", value, 0);
	sprintf(command, "string trim $var");
	Tcl_Eval(interp, command);
	strcpy(sTclTxt, Tcl_GetVar(interp, "var", 0));
	// Find if ends in pf
	sprintf(pattern, "(P|p)(f|F)$");
	Tcl_SetVar(interp, "pattern", pattern, 0);
	sprintf(command, "regsub  (p|P)(f|F)$ $var p value");
	Tcl_Eval(interp, command);
	strcpy(sTclTxt, Tcl_GetVar(interp, "value", 0));
	strcpy(sReturn, sTclTxt);
	return(sReturn);
}

char *LTCSimSplitXLoc(char *value)
{
	char *sReturn;
	char command[256];

	sReturn = new char[strlen(value)];
	// Trim spaces
	Tcl_SetVar(interp, "var", value, 0);
	sprintf(command, "string trim $var");
	Tcl_Eval(interp, command);
	sprintf(pattern, "(.*),(.*)");
	Tcl_SetVar(interp, "pattern", pattern, 0);
	sprintf(command, "regexp {(.*),(.*)} $var match value1 value2");
	Tcl_Eval(interp, command);
	strcpy(sTclTxt, Tcl_GetVar(interp, "value1", 0));
	strcpy(sReturn, sTclTxt);
	return(sReturn);
}

char *LTCSimSplitYLoc(char *value)
{
	char *sReturn;
	char command[256];

	sReturn = new char[strlen(value)];
	// Trim spaces
	Tcl_SetVar(interp, "var", value, 0);
	sprintf(command, "string trim $var");
	Tcl_Eval(interp, command);
	sprintf(pattern, "(.*),(.*)");
	Tcl_SetVar(interp, "pattern", pattern, 0);
	sprintf(command, "regexp {(.*),(.*)} $var match value1 value2");
	Tcl_Eval(interp, command);
	strcpy(sTclTxt, Tcl_GetVar(interp, "value2", 0));
	strcpy(sReturn, sTclTxt);
	return(sReturn);
}

/* --------- LTC PSpice process net name ----------*/

char* LTC_PSpice_Process_Net_Name(char* name)
{
	char *pdest = new char[256];
	char *tempName = new char[256];
	char *newName = new char[256];
	char *szTemp = new char[256];
	//CString sTemp;
	String^ sName;
	LTCUtils ltcUtility;

	//strcpy( szTemp, name );
	//sTemp = CString( szTemp );
	sName = ltcUtility.LtcCharsToString(name);
	//sTemp.Replace( '[', *sBracketSubstitutionLeft ); 
	sName = sName->Replace("[", ltcUtility.LtcCharsToString(sBracketSubstitutionLeft));
	//sTemp.Replace( ']', *sBracketSubstitutionRight );
	sName = sName->Replace("]", ltcUtility.LtcCharsToString(sBracketSubstitutionRight));
	if (bCmd_XGNDXto0 && (sName->Contains("GND")))
		sName = "0";
	else if (bCmd_GNDto0 && (sName->Equals("GND")))
		sName = "0";
	else if (IsGlobalNetName(ltcUtility.LtcStringToChars(sName)))
		sName = "$G_" + sName;
	ltcUtility.~LTCUtils();
	return ltcUtility.LtcStringToChars(sName);

	/*
	strcpy(tempName, ltcUtility.LtcStringToChars(sName));

	pdest = strstr(tempName, "GND");
	if (bCmd_XGNDXto0 && (pdest != NULL))
		strcpy(newName, "0");
	else if (bCmd_GNDto0 && (_stricmp(name, "GND") == 0))
		strcpy(newName, "0");
	else if (IsGlobalNetName(name) > 0)
		sprintf(newName, "$G_%s", tempName);
	else
		sprintf(newName, "%s", tempName);
	ltcUtility.~LTCUtils();
	return newName;
	*/
}


/* --------- LTC HSpice process net name ----------*/
char* LTC_HSpice_Process_Net_Name(char* name)
{
	char *pdest = new char[256];
	char *tempName = new char[256];
	char* newName = new char[256];
	char* szTemp = new char[256];
	//CString sTemp;
	String^ sTemp;
	LTCUtils ltcUtility;

	//strcpy( szTemp, name );
	//sTemp = CString( szTemp );
	sTemp = ltcUtility.LtcCharsToString(name);
	//sTemp.Replace( '[', *sBracketSubstitutionLeft );
	sTemp = sTemp->Replace("[", ltcUtility.LtcCharsToString(sBracketSubstitutionLeft));
	//sTemp.Replace( ']', *sBracketSubstitutionRight );
	sTemp = sTemp->Replace("]", ltcUtility.LtcCharsToString(sBracketSubstitutionRight));
	strcpy(tempName, ltcUtility.LtcStringToChars(sTemp));

	int iComp = sTemp->CompareTo("GND");
	if (bCmd_XGNDXto0 && sTemp->Contains("GND"))
		strcpy(newName, "0");
	else if (bCmd_GNDto0 && (iComp == 0))
		strcpy(newName, "0");
	else
		sprintf(newName, "%s", tempName);
	/*
	pdest = strstr(tempName, "GND");
	if ( bCmd_XGNDXto0 && ( pdest != NULL ))
	strcpy( newName, "0");
	else if ( bCmd_GNDto0 && ( _stricmp( name, "GND" ) == 0) )
	strcpy( newName, "0" );
	else
	sprintf( newName, "%s", tempName );
	*/
	ltcUtility.~LTCUtils();
	return newName;
}

/*---------- Get_Spice_Net_Name ----------*/

char* Get_Spice_Net_Name(TN_PTR tn)
{
	int i, j;

	char *netname = _strdup(NetName(tn));
	char *szIllegalChar;
	char *szTempNetName;
	bool bOkToMatch = false;

	switch (cCmd_Tool)
	{
	case 'l':
	case 'p':
	default:
		szTempNetName = new char[strlen(netname) + 3];
		break;
	case 'h':
	case 'a':
	case 'd':
	case 't':
		szTempNetName = new char[strlen(netname) + 2];
		break;
	}
	strcpy(szTempNetName, netname);
	if (szIllegalChar = strpbrk(netname, ".-()<>{}"))
	{
		if (bCmd_Flat)
		{
			char *szResult;
			if (*szTempNetName == '.'){
				if (szResult = strpbrk(szTempNetName, "-")){
					if (!(szResult = strpbrk(szResult + 1, ".-()<>{}"))) {
						bOkToMatch = true;
					}
				}
			}
		}

		while (szIllegalChar = strpbrk(szTempNetName, ".-()<>{}")){
			*szIllegalChar = '_';
		}

		int nLocalMaxIndexCount;
		char **LocalUnderscoreNameCache;

		if (!bCmd_Flat) {
			for (i = 0; i < nMaxSubCircuitIndexCount; i++) {
				if (!_stricmp(szCurrentSubCircuitName, SubCircuitNames[i])) {
					break;
				}
			}
			LocalUnderscoreNameCache = SubCircuits[i];
			nLocalMaxIndexCount = *(SubCircuitMaxIndexCount[i]);
		}
		else {
			LocalUnderscoreNameCache = UnderscoreNameCache;
			nLocalMaxIndexCount = nMaxIndexCount;
		}

		bool bNameAlreadyInCache = true;

		while (bNameAlreadyInCache) {
			bNameAlreadyInCache = false;
			for (j = 0; j < nLocalMaxIndexCount; j++) {
				if (!_stricmp(szTempNetName, LocalUnderscoreNameCache[j])) {
					bNameAlreadyInCache = true;
					break;
				}
			}

			if (bNameAlreadyInCache && !bOkToMatch) {
				if (szNewName != NULL)
					delete szNewName;
				szNewName = new char[strlen(szTempNetName) + 2];
				strcpy(szNewName, szTempNetName);
				strcat(szNewName, "_");
				szTempNetName = szNewName;
			}
			else if (bNameAlreadyInCache && bOkToMatch) {
				//name is original, but the '.'s and '-'s in the flat
				//name cause some problems. Basically, we want to make
				//them all underscores and with the name already in the
				//cache, we don't really want to rename it.
				bNameAlreadyInCache = false;
			}
		}
	}
	// NOTE:  We need to find out what other characters are not legal
	switch (cCmd_Tool)
	{
	case 'l':
	case 'p':
	default:
		szTempNetName = LTC_PSpice_Process_Net_Name(szTempNetName);
		break;
	case 'h':
	case 'a':
	case 'd':
	case 't':
		szTempNetName = LTC_HSpice_Process_Net_Name(szTempNetName);
		break;
	}

	return szTempNetName;
}

/*---------- Out_Nets ----------*/

/* Out_Nets is used to list the element name and the various nets which are
   connected to it.  This portion is the same for all primitives.  For flat
   net lists, list nets by the NetNumber.  For hierarchical net lists, list
   nets either by name or by the number assigned previously for the current
   block ( Get_Net_Number() ). */

static void Out_Nets(int count)
{
	char *val;
	char *instname;
	char *netName;
	char *temp;
	bool bSimPrimitive = true;
	char szTemp[256];
	//CString sInstName;
	String^ sInstName;
	//CString sElement;
	String^ sElement;
	String^ sTemp;
	LTCUtils ltcUtility;

	instname = LocalInstanceName(ti);

	char *szIllegalChar;

	while (szIllegalChar = strpbrk(instname, ".-[]()<>{}")) {
		*szIllegalChar = '_';
	}
	temp = _strdup(instname);

	//strcpy( szTemp, instname );
	//sInstName = CString( instname );
	sInstName = ltcUtility.LtcCharsToString(instname);
	//if( !bCmd_IgnoreCase ) sInstName.MakeLower();
	if (!bCmd_IgnoreCase) sInstName->ToLower();
	//strcpy( szTemp, element );
	//sElement = CString( szTemp );
	sElement = ltcUtility.LtcCharsToString(element);
	//if( !bCmd_IgnoreCase ) sElement.MakeLower();
	if (!bCmd_IgnoreCase) sElement->ToLower();

	switch (cCmd_Tool)
	{
	case 'l':
	case 'p':
	case 'h':
		if (*(val = Get_TIA(ti, SIM_LEVEL))) {
			if ((*val == 'N') || (*val == 'n') || (*val == '0'))
				bSimPrimitive = true;
			else
				bSimPrimitive = false;
		}
		else
			bSimPrimitive = true;
		break;
	}

	if (bCmd_FilterPrefix && (*element == *temp)) {
		switch (cCmd_Tool)
		{
		case 'l':
		case 'p':
		default:
			if (!bCmd_MixedSignal || !bDigitalMode) {
				if (bSimPrimitive)
					//sprintf( line, "%s", sInstName.GetBuffer() );
					sprintf(line, "%s", ltcUtility.LtcStringToChars(sInstName));
				//sprintf( line, "%s", instname );
				else
					if (bCmd_IgnoreCase)
						//sprintf( line, "X%s", sInstName.GetBuffer() );
						sprintf(line, "X%s", ltcUtility.LtcStringToChars(sInstName));
					else
						sprintf(line, "x%s", ltcUtility.LtcStringToChars(sInstName));
			}
			else {
				if (bDigitalMode && (*element == 'M'))
					//sprintf( line, "U%s", sInstName.GetBuffer() );
					sprintf(line, "U%s", ltcUtility.LtcStringToChars(sInstName));
				//sprintf( line, "U%s", instname );
				else {
					if (bSimPrimitive)
						//sprintf( line, "%s", sInstName.GetBuffer() );
						sprintf(line, "%s", ltcUtility.LtcStringToChars(sInstName));
					else
						if (bCmd_IgnoreCase)
							//sprintf( line, "X%s", sInstName.GetBuffer() );
							sprintf(line, "X%s", ltcUtility.LtcStringToChars(sInstName));
						else
							//sprintf( line, "x%s", sInstName.GetBuffer() );
							sprintf(line, "x%s", ltcUtility.LtcStringToChars(sInstName));
				}
			}
			break;
		case 'h':
			if (bSimPrimitive)
				//sprintf( line, "%s", sInstName.GetBuffer() );
				sprintf(line, "%s", ltcUtility.LtcStringToChars(sInstName));
			else
				if (bCmd_IgnoreCase)
					//sprintf( line, "X%s", sInstName.GetBuffer() );
					sprintf(line, "X%s", ltcUtility.LtcStringToChars(sInstName));
				else
					//sprintf( line, "x%s", sInstName.GetBuffer() );
					sprintf(line, "x%s", ltcUtility.LtcStringToChars(sInstName));

			break;
		case 'a':
		case 'd':
		case 't':
			if (*(val = Get_TIA(ti, LVS_REMOVE)) && (*val == 'y' || *val == 'Y'))
				//sprintf( line, "*%s", sInstName.GetBuffer() );
				sprintf(line, "*%s", ltcUtility.LtcStringToChars(sInstName));
			else
				//sprintf( line, "%s", sInstName.GetBuffer() );
				sprintf(line, "%s", ltcUtility.LtcStringToChars(sInstName));
			break;
		}
	}
	else {
		switch (cCmd_Tool)
		{
		case 'l':
		case 'p':
		default:
			if (!bCmd_MixedSignal || !bDigitalMode) {
				if (bSimPrimitive)
					//sprintf( line, "%s%s", sElement.GetBuffer(), sInstName.GetBuffer() );
					sprintf(line, "%s%s", ltcUtility.LtcStringToChars(sElement), ltcUtility.LtcStringToChars(sInstName));
				else
					if (bCmd_IgnoreCase)
						//sprintf( line, "X%s%s", sElement.GetBuffer(), sInstName.GetBuffer() );
						sprintf(line, "X%s%s", ltcUtility.LtcStringToChars(sElement), ltcUtility.LtcStringToChars(sInstName));
					else
						//sprintf( line, "x%s%s", sElement.GetBuffer(), sInstName.GetBuffer() );
						sprintf(line, "x%s%s", ltcUtility.LtcStringToChars(sElement), ltcUtility.LtcStringToChars(sInstName));
			}
			else {
				if (bDigitalMode && (*element == 'M'))
					//sprintf( line, "U%s%s", sElement.GetBuffer() , sInstName.GetBuffer() );
					sprintf(line, "U%s%s", ltcUtility.LtcStringToChars(sElement), ltcUtility.LtcStringToChars(sInstName));
				else {
					if (bSimPrimitive)
						//sprintf( line, "%s%s", sElement.GetBuffer(), sInstName.GetBuffer() );
						sprintf(line, "%s%s", ltcUtility.LtcStringToChars(sElement), ltcUtility.LtcStringToChars(sInstName));
					else
						if (bCmd_IgnoreCase)
							//sprintf( line, "X%s%s", sElement.GetBuffer(), sInstName.GetBuffer() );
							sprintf(line, "X%s%s", ltcUtility.LtcStringToChars(sElement), ltcUtility.LtcStringToChars(sInstName));
						else
							//sprintf( line, "x%s%s", sElement.GetBuffer(), sInstName.GetBuffer() );
							sprintf(line, "x%s%s", ltcUtility.LtcStringToChars(sElement), ltcUtility.LtcStringToChars(sInstName));
				}
			}
			break;
		case 'h':
			if (bSimPrimitive)
				//sprintf( line, "%s%s", sElement.GetBuffer(), sInstName.GetBuffer() );
				sprintf(line, "%s%s", ltcUtility.LtcStringToChars(sElement), ltcUtility.LtcStringToChars(sInstName));
			else
				//sprintf( line, "%s%s", sElement.GetBuffer(), sInstName.GetBuffer() );
				sprintf(line, "%s%s", ltcUtility.LtcStringToChars(sElement), ltcUtility.LtcStringToChars(sInstName));
			break;
		case 'a':
		case 'd':
		case 't':
			if (*(val = Get_TIA(ti, LVS_REMOVE)) && (*val == 'y' || *val == 'Y'))
				//sprintf( line, "*%s%s", sElement.GetBuffer(), sInstName.GetBuffer() );
				sprintf(line, "*%s%s", ltcUtility.LtcStringToChars(sElement), ltcUtility.LtcStringToChars(sInstName));
			else
				//sprintf( line, "%s%s", sElement.GetBuffer(), sInstName.GetBuffer() );
				sprintf(line, "%s%s", ltcUtility.LtcStringToChars(sElement), ltcUtility.LtcStringToChars(sInstName));
			break;
		}
	}
	Data_Out(line, false);
	switch (cCmd_Tool)
	{
	case 'l':
	case 'p':
		if (bDigitalMode && *element == 'M') {
			if (*(val = Get_TIA(ti, DIGITAL_PRIMITIVE))) {
				sprintf(line, " %s %s %s", val, "$G_Dpwr", "$G_Dgnd");
				Data_Out(line, false);
			}
			else
				errorWithInstance("Missing DIGITAL_PRIMITIVE attribute", ti);
		}
		break;
	}

	for (int ii = 0; ii < count; ii++) {
		if (nets[ii])
		{
			if (bCmd_Node_Names && (netName = Get_Spice_Net_Name(nets[ii]))) {
				//strcpy( szTemp, netName );
				//sTemp = CString( szTemp );
				sTemp = ltcUtility.LtcCharsToString(netName);
				//if( !bCmd_IgnoreCase ) sTemp.MakeLower();
				if (!bCmd_IgnoreCase) sTemp->ToLower();
				switch (cCmd_Tool)
				{
				case 'l':
				case 'p':
					if ((*element == 'Q') && (ii == 3))
						//sprintf( line, " [%s]", sTemp.GetBuffer() );
						sprintf(line, " [%s]", ltcUtility.LtcStringToChars(sTemp));
					else
						if (bDigitalMode && (*element == 'M') && ii == 3)
							strcpy(line, "");
						else
							//sprintf( line, " %s", sTemp.GetBuffer() );
							sprintf(line, " %s", ltcUtility.LtcStringToChars(sTemp));
					break;
				case 'h':
				case 'a':
				case 'd':
				case 't':
					//sprintf( line, " %s", sTemp.GetBuffer() );
					sprintf(line, " %s", ltcUtility.LtcStringToChars(sTemp));
					break;
				}
			}
			else
				sprintf(line, " %ld", Get_Net_Number(nets[ii]));
			Data_Out(line, true);
		}
	}
	switch (cCmd_Tool)
	{
	case 'l':
	case 'p':
	case 'h':
		if (!bSimPrimitive)
			Out_XDef_Net();
		break;
	}
	ltcUtility.~LTCUtils();
}

/*---------- Out_XDef_Tub_Net ----------*/

static void Out_XDef_Tub_Net()
{
	char *netName;
	char szTemp[256];
	TN_PTR tn = 0;
	//CString sTemp;
	String^ sTemp;
	LTCUtils ltcUtility;

	SavePath();
	/* FindNetNamed() changes the path */
	/* Use the Default name for the subcircuit substrate terminal if it exists */

	netName = Get_TIA(ti, XDEF_TUB);

	if (bCmd_Node_Names) {
		switch (cCmd_Tool)
		{
		case 'l':
		case 'p':
			//strcpy( szTemp, LTC_PSpice_Process_Net_Name( netName ));
			//sTemp = CString(szTemp);
			sTemp = ltcUtility.LtcCharsToString(LTC_PSpice_Process_Net_Name(netName));
			//sTemp.MakeLower();
			if (!bCmd_IgnoreCase) sTemp->ToLower();
			//sprintf( line, " %s", sTemp.GetBuffer() );
			sprintf(line, " %s", ltcUtility.LtcStringToChars(sTemp));
			// sprintf( line, " %s", sTemp );
			break;
		case 'h':
		case 'a':
		case 'd':
		case 't':
			//strcpy( szTemp, LTC_HSpice_Process_Net_Name( netName ));
			//sTemp = CString(szTemp);
			sTemp = ltcUtility.LtcCharsToString(LTC_HSpice_Process_Net_Name(netName));
			//if (!bCmd_IgnoreCase) sTemp.MakeLower();
			if (!bCmd_IgnoreCase) sTemp->ToLower();
			//sprintf(line, " %s", sTemp.GetBuffer());
			sprintf(line, " %s", ltcUtility.LtcStringToChars(sTemp));
			// sprintf( line, " %s", sTemp );
			break;
		}
	}
	else
		sprintf(line, " %ld", Get_Net_Number(tn));
	Data_Out(line, true);
	ltcUtility.~LTCUtils();
	RestorePath();
}

/*---------- Out_XDef_Net ----------*/

static void Out_XDef_Net()
{
	char *netName;
	char szTemp[256];
	TN_PTR tn = 0;
	//CString sTemp;
	String^ sTemp;
	LTCUtils ltcUtility;


	SavePath();
	/* FindNetNamed() changes the path */
	/* Use the Default name for the subcircuit substrate terminal if it exists */

	netName = Get_TIA(ti, XDEF_SUB);

	if (bCmd_Node_Names) {
		switch (cCmd_Tool)
		{
		case 'l':
		case 'p':
			//strcpy( szTemp, LTC_PSpice_Process_Net_Name( netName ));
			//sTemp = CString(szTemp);
			sTemp = ltcUtility.LtcCharsToString(LTC_PSpice_Process_Net_Name(netName));
			//if( !bCmd_IgnoreCase ) sTemp.MakeLower();
			if (!bCmd_IgnoreCase) sTemp->ToLower();
			//sprintf( line, " %s", sTemp );
			sprintf(line, " %s", ltcUtility.LtcStringToChars(sTemp));
			break;
		case 'h':
		case 'a':
		case 'd':
		case 't':
			//strcpy( szTemp, LTC_HSpice_Process_Net_Name( netName ));
			// sTemp = CString(szTemp);
			sTemp = ltcUtility.LtcCharsToString(LTC_HSpice_Process_Net_Name(netName));
			//if( !bCmd_IgnoreCase ) sTemp.MakeLower();
			if (!bCmd_IgnoreCase) sTemp->ToLower();
			// sprintf( line, " %s", sTemp );
			sprintf(line, " %s", ltcUtility.LtcStringToChars(sTemp));
			break;
		}
	}
	else
		sprintf(line, " %ld", Get_Net_Number(tn));
	ltcUtility.~LTCUtils();
	Data_Out(line, true);
	RestorePath();
}

/*---------- Out_Def_Net ----------*/

static void Out_Def_Net()
{
	char *netName;
	TN_PTR tn = 0;
	char szTemp[256];
	//CString sTemp;
	String^ sTemp;
	LTCUtils ltcUtility;

	SavePath(); /* FindNetNamed() changes the path */
	/* Use the Default name for the fourth terminal if it exists */
	netName = Get_TIA(ti, DEFSUBSTRATE);

	/* add section to attach default substrate with syntax "=pin_name" */

	if (*element == 'M' && netName[0] == '=') {
		if (netName[1] == 'D') tn = nets[0];
		if (netName[1] == 'G') tn = nets[1];
		if (netName[1] == 'S') tn = nets[2];
	}
	else {
		if (*netName)
			tn = FindNetNamed(netName);
	}
	if (tn) {
		if (bCmd_Node_Names && (netName = Get_Spice_Net_Name(tn)))
		{
			//strcpy( szTemp, netName );
			//sTemp = CString( szTemp );
			sTemp = ltcUtility.LtcCharsToString(netName);
			//if( !bCmd_IgnoreCase ) sTemp.MakeLower();
			if (!bCmd_IgnoreCase) sTemp->ToLower();
			switch (cCmd_Tool)
			{
			case 'l':
			case 'p':
				if (*element == 'Q') //sprintf( line, " [%s]", sTemp.GetBuffer() );
					sprintf(line, " [%s]", ltcUtility.LtcStringToChars(sTemp));
				else //sprintf( line, " %s", sTemp.GetBuffer() );
					sprintf(line, " %s", ltcUtility.LtcStringToChars(sTemp));

				break;
			case 'h':
			case 'a':
			case 'd':
			case 't':
				//sprintf( line, " %s", sTemp.GetBuffer() );
				sprintf(line, " %s", ltcUtility.LtcStringToChars(sTemp));
				break;
			}
		}
		else
			sprintf(line, " %ld", Get_Net_Number(tn));
		Data_Out(line, true);
	}
	else {
		if (*netName) {
			char msg[128];
			sprintf(msg, "Unrecognized default substrate %s", netName);
			errorWithInstance(msg, ti);
		}
	}
	RestorePath();
}

/*---------- Out_Nets_Only ----------*/

/* Out_Nets_Only is used to list the various nets which are
   connected to it.  This portion is the same for all primitives.  For flat
   net lists, list nets by the NetNumber.  For hierarchical net lists, list
   nets either by name or by the number assigned previously for the current
   block ( Get_Net_Number() ). */

static void Out_Nets_Only(int count)
{
	for (int ii = 0; ii < count; ii++) {
		if (nets[ii]) {
			char* name;
			if (bCmd_Node_Names && (name = Get_Spice_Net_Name(nets[ii]))) {
				switch (cCmd_Tool)
				{
				case 'l':
				case 'p':
					name = LTC_PSpice_Process_Net_Name(name);
					break;
				}
				sprintf(line, " %s", name);
			}
			else
				sprintf(line, " %ld", Get_Net_Number(nets[ii]));
			Data_Out(line, false);
		}
	}
}

/*---------- Bipolar Transistor Models ----------*/

static int Bipolar_Pins(TP_PTR tp)
{
	char* name;
	TN_PTR net;

	net = NetContainingPin(tp);
	if (bCmd_Flat && net)
		net = FindNetRoot(net);
	name = Get_TPA(tp, NAME);
	if (*name == 'C')
		nets[0] = net;
	else if (*name == 'B')
		nets[1] = net;
	else if (*name == 'E')
		nets[2] = net;
	else if (*name == 'S') {
		nets[3] = net;
		if (!net) {
			char msg[128];
			sprintf(msg, " Unconnected pin on bipolar transistor %s", name);
			errorWithInstance(msg, ti);
		}
		else {
			char msg[128];
			sprintf(msg, " Unconnected pin on bipolar transistor %s", name);
			errorWithInstance(msg, ti);
		}
	}
	return(0);
}

/* Prefix = Q */
static void Bipolar_Transistor() {
	char* val;
	bool bSimPrimitive = true;
	char szSpiceModel[256];
	char szShrink[256];
	char szVal[256];
	char szResize[256];
	char *tVal;
	char szTemp[256];
	//CString sTemp;
	String^ sTemp;
	LTCUtils ltcUtility;

	ForEachInstancePin(ti, Bipolar_Pins);

	switch (cCmd_Tool)
	{
	case 'l':
	case 'p':
	case 'h':
		if (*(val = Get_TIA(ti, SIM_LEVEL)))
		{
			if ((*val == 'N') || (*val == 'n') || (*val == '0'))
				bSimPrimitive = true;
			else
				bSimPrimitive = false;
		}
		else
			bSimPrimitive = true;
		break;
	}

	if (nets[0] && nets[1] && nets[2]) {
		Out_Nets(4);
		if (!nets[3]) Out_Def_Net();

		/* SPICEMODEL */
		switch (cCmd_Tool)
		{
		case 'l':
		case 'p':
		case 'h':
			if (*(val = Get_TIA(ti, SPICEMODEL)) && *val != '*')
			{
				//strcpy( szTemp, val );
				//sTemp = CString( szTemp );
				sTemp = ltcUtility.LtcCharsToString(val);
				//if (!bCmd_IgnoreCase) sTemp.MakeLower();
				if (!bCmd_IgnoreCase) sTemp->ToLower();
				if (bSimPrimitive) //sprintf( line, " %s", sTemp.GetBuffer() );
					sprintf(line, " %s", ltcUtility.LtcStringToChars(sTemp));
				else {
					//strcpy(szSpiceModel, sTemp.GetBuffer());
					strcpy(szSpiceModel, ltcUtility.LtcStringToChars(sTemp));
					if (*(val = Get_TIA(ti, SIM_LEVEL)))
					{
						//strcpy( szTemp, val );
						//sTemp = CString( szTemp );
						sTemp = ltcUtility.LtcCharsToString(val);
						//if( !bCmd_IgnoreCase ) sTemp.MakeLower();
						if (!bCmd_IgnoreCase) sTemp->ToLower();
						//sprintf( line, " %s%s", szSpiceModel, sTemp.GetBuffer() );
						sprintf(line, " %s%s", szSpiceModel, ltcUtility.LtcStringToChars(sTemp));
					}
					else
						sprintf(line, " %s", szSpiceModel);
				}
				Data_Out(line, false);
			}
			else
				errorWithInstance("Device model needs to be checked", ti);
			break;
		}

		/* LVS_TYPE */
		switch (cCmd_Tool)
		{
		case 'a':
		case 'd':
			if (*(val = Get_TIA(ti, LVS_TYPE)) && *val != '*')
			{
				//strcpy( szTemp, val );
				//sTemp = CString( szTemp );
				sTemp = ltcUtility.LtcCharsToString(val);
				//if( !bCmd_IgnoreCase ) sTemp.MakeLower();
				if (!bCmd_IgnoreCase) sTemp->ToLower();
				//sprintf( line, " %s", sTemp.GetBuffer() );
				sprintf(line, " %s", ltcUtility.LtcStringToChars(sTemp));
				Data_Out(line, false);
			}
			else if (*(tVal = Get_TIA(ti, LVS_REMOVE)) == NULL)
				errorWithInstance("Missing LVS type attribute", ti);
			break;
		}

		/* CELL */
		switch (cCmd_Tool)
		{
		case 't':
			if (*(val = Get_TIA(ti, CELL)) && *val != '*')
			{
				//strcpy( szTemp, val );
				//sTemp = CString( szTemp );
				sTemp = ltcUtility.LtcCharsToString(val);
				//if( !bCmd_IgnoreCase ) sTemp.MakeLower();
				if (!bCmd_IgnoreCase) sTemp->ToLower();
				//sprintf( line, " %s", sTemp.GetBuffer() );
				sprintf(line, " %s", ltcUtility.LtcStringToChars(sTemp));
				Data_Out(line, false);
			}
			else if (*(tVal = Get_TIA(ti, LVS_REMOVE)) == NULL){
				sprintf(line, " dummy");
				Data_Out(line, false);
			}
			break;
		}

		/* MULTI */
		if ((*(val = Get_TIA(ti, MULTI)) && *val != '*') && bSimPrimitive) {
			if (!LTCSimPassParamVal(val))
			{
				//strcpy( szTemp, val );
				//sTemp = CString( szTemp );
				sTemp = ltcUtility.LtcCharsToString(val);
				//if( !bCmd_IgnoreCase ) sTemp.MakeLower();
				if (!bCmd_IgnoreCase) sTemp->ToLower();
				switch (cCmd_Tool)
				{
				case 'l':
				case 'p':
				case 'h':
					//sprintf( line, " %s", sTemp.GetBuffer() );
					sprintf(line, " %s", ltcUtility.LtcStringToChars(sTemp));
					break;
				case 'a':
				case 'd':
				case 't':
					if (bCmd_IgnoreCase)
						//sprintf( line, " M=%s", sTemp.GetBuffer());
						sprintf(line, " M=%s", ltcUtility.LtcStringToChars(sTemp));
					else
						//sprintf( line, " m=%s", sTemp.GetBuffer());
						sprintf(line, " m=%s", ltcUtility.LtcStringToChars(sTemp));
					break;
				}
			}
			else {
				switch (cCmd_Tool)
				{
				case 'l':
				case 'p':
				case 'h':
					//sprintf( line, " %s", sTemp.GetBuffer());
					sprintf(line, " %s", ltcUtility.LtcStringToChars(sTemp));
					break;
				case 'a':
				case 'd':
				case 't':
					if (bCmd_IgnoreCase)
						//sprintf( line, " M=%s", sTemp.GetBuffer());
						sprintf(line, " M=%s", ltcUtility.LtcStringToChars(sTemp));
					else
						//sprintf( line, " m=%s", sTemp.GetBuffer());
						sprintf(line, " m=%s", ltcUtility.LtcStringToChars(sTemp));
					break;
					break;
				}
			}
			Data_Out(line, false);
		}

		switch (cCmd_Tool)
		{
		case 'a':
		case 'd':
		case 't':
			if (bCmd_WLBip) {
				/* LENGTH */
				if (*(val = Get_TIA(ti, LENGTH)) && *val != '*') {
					if (!LTCSimPassParamVal(val)) {
						if (bCmd_Shrink) {
							strcpy(szVal, val);
							val = Get_TIA(ti, SHRINK);
							strcpy(szShrink, val);
							val = Get_TIA(ti, GATE_RESIZE);
							strcpy(szResize, val);
							if (bCmd_IgnoreCase)
								sprintf(line, " L=(%s*%s)", szVal, szShrink);
							else
								sprintf(line, " l=(%s*%s)", szVal, szShrink);
						}
						else
							if (bCmd_IgnoreCase)
								sprintf(line, " L=%s", val);
							else
								sprintf(line, " l=%s", val);
					}
					else if (bCmd_Shrink) {
						strcpy(szVal, LTCSimExtParam(val));
						val = Get_TIA(ti, SHRINK);
						strcpy(szShrink, val);
						val = Get_TIA(ti, GATE_RESIZE);
						strcpy(szResize, val);
						if (bCmd_IgnoreCase)
							sprintf(line, " L=%s*%s", szVal, szShrink);
						else
							sprintf(line, " l=%s*%s", szVal, szShrink);
					}
					else {
						strcpy(szVal, LTCSimExtParam(val));
						if (bCmd_IgnoreCase)
							sprintf(line, " L=%s", szVal);
						else
							sprintf(line, " l=%s", szVal);
					}
					Data_Out(line, false);
				}
				else
					errorWithInstance("Missing length value attribute", ti);

				/* WIDTH */
				if (*(val = Get_TIA(ti, WIDTH)) && *val != '*') {
					if (!LTCSimPassParamVal(val)) {
						if (bCmd_Shrink) {
							strcpy(szVal, val);
							val = Get_TIA(ti, SHRINK);
							strcpy(szShrink, val);
							if (bCmd_IgnoreCase)
								sprintf(line, " W=%s*%s", szVal, szShrink);
							else
								sprintf(line, " w=%s*%s", szVal, szShrink);
						}
						else
							if (bCmd_IgnoreCase)
								sprintf(line, " W=%s", val);
							else
								sprintf(line, " w=%s", val);
					}
					else {
						if (bCmd_Shrink) {
							strcpy(szVal, LTCSimExtParam(val));
							val = Get_TIA(ti, SHRINK);
							strcpy(szShrink, val);
							val = Get_TIA(ti, GATE_RESIZE);
							strcpy(szResize, val);
							if (bCmd_IgnoreCase)
								sprintf(line, " W=%s*%s", szVal, szShrink);
							else
								sprintf(line, " w=%s*%s", szVal, szShrink);
						}
						else {
							strcpy(szVal, LTCSimExtParam(val));
							if (bCmd_IgnoreCase)
								sprintf(line, " W=%s", szVal);
							else
								sprintf(line, " w=%s", szVal);
						}
					}
					Data_Out(line, false);
				}
				else
					errorWithInstance("Missing width value attribute", ti);
			}
			/* AREA */
			if (bCmd_AreaBip) {
				if ((*(val = Get_TIA(ti, AREA)) && *val != '*')) {
					if (!LTCSimPassParamVal(val)) {
						if (bCmd_Shrink) {
							strcpy(szVal, val);
							val = Get_TIA(ti, SHRINK);
							strcpy(szShrink, val);
							if (bCmd_IgnoreCase)
								sprintf(line, " $EA=%s*(%s*%s)", szVal, szShrink, szShrink);
							else
								sprintf(line, " $ea=%s*(%s*%s)", szVal, szShrink, szShrink);
						}
						else
							if (bCmd_IgnoreCase)
								sprintf(line, " $EA=%s", val);
							else
								sprintf(line, " $ea=%s", val);

					}
					else {
						if (bCmd_Shrink) {
							strcpy(szVal, LTCSimExtParam(val));
							val = Get_TIA(ti, SHRINK);
							strcpy(szShrink, val);
							if (bCmd_IgnoreCase)
								sprintf(line, " $EA=(%s*%s*%s)", szVal, szShrink, szShrink);
							else
								sprintf(line, " $ea=(%s*%s*%s)", szVal, szShrink, szShrink);
						}
						else {
							strcpy(szVal, LTCSimExtParam(val));
							if (bCmd_IgnoreCase)
								sprintf(line, " $EA=%s", szVal);
							else
								sprintf(line, " $ea=%s", szVal);
						}
					}
					Data_Out(line, false);
				}
				else
					errorWithInstance("Area not specified on bipolar transistor ", ti);
			}
			break;
		}

		/* SPICELINE */
		switch (cCmd_Tool)
		{
		case 'l':
		case 'p':
		case 'h':
			if ((*(val = Get_TIA(ti, SPICELINE)) && *val != '*') && bSimPrimitive)
			{
				//strcpy( szTemp, val );
				//sTemp = CString( szTemp );
				sTemp = ltcUtility.LtcCharsToString(val);
				//if (!bCmd_IgnoreCase) sTemp.MakeLower();
				if (!bCmd_IgnoreCase) sTemp->ToLower();
				//sprintf( line, " %s", sTemp.GetBuffer() );
				sprintf(line, " %s", ltcUtility.LtcStringToChars(sTemp));
				Data_Out(line, false);
			}
			break;
		}

		/* SPICELINE3 */
		if ((*(val = Get_TIA(ti, SPICELINE3))) && !bSimPrimitive)
		{
			//strcpy( szTemp, val );
			//sTemp = CString( szTemp );
			sTemp = ltcUtility.LtcCharsToString(val);
			//if (!bCmd_IgnoreCase) sTemp.MakeLower();
			if (!bCmd_IgnoreCase) sTemp->ToLower();
			switch (cCmd_Tool)
			{
			case 'l':
			case 'p':
				//sprintf( line, " params: %s", sTemp.GetBuffer() );
				sprintf(line, " params: %s", ltcUtility.LtcStringToChars(sTemp));
				break;
			case 'h':
			case 'a':
			case 'd':
			case 't':
				//sprintf( line, " %s", sTemp.GetBuffer() );
				sprintf(line, " %s", ltcUtility.LtcStringToChars(sTemp));
				break;
			}
			Data_Out(line, false);
		}
		/* APT LOCATION */
		switch (cCmd_Tool)
		{
		case 't':
			if (*(val = Get_TIA(ti, 254))){
				sprintf(line, " x_loc=%s y_loc=%s", LTCSimSplitXLoc(val), LTCSimSplitYLoc(val));
				Data_Out(line, true);
			}
			break;
		}
		Data_Out("\n", false);
	}
	else
		errorWithInstance("Unconnected pin on bipolar transisto", ti);
	ltcUtility.~LTCUtils();
}


/*---------- FET Transistor Models ----------*/

static int FET_Pins(TP_PTR tp)
{
	char* name;
	TN_PTR net;

	net = NetContainingPin(tp);
	if (bCmd_Flat && net) net = FindNetRoot(net);
	name = Get_TPA(tp, NAME);
	if (*name == 'D') nets[0] = net;
	else if (*name == 'G') nets[1] = net;
	else if (*name == 'S') nets[2] = net;
	else if (*name == 'B') {
		nets[3] = net;
		if (!net) {
			char msg[128];
			sprintf(msg, "Unconnected pin on transistor %s", name);
			errorWithInstance(msg, ti);
		}
	}
	else {
		char msg[128];
		sprintf(msg, "Unrecognized pin on transistor %s", name);
		errorWithInstance(msg, ti);
	}
	return(0);
}


/*---------- FET Transistor Models ----------*/

static int JFET_Pins(TP_PTR tp)
{
	char* name;
	TN_PTR net;

	net = NetContainingPin(tp);
	if (bCmd_Flat && net) net = FindNetRoot(net);
	name = Get_TPA(tp, NAME);

	switch (cCmd_Tool)
	{
	case 'l':
	case 'p':
	case 'a':
	case 'd':
	case 't':
		if (*name == 'D') nets[0] = net;
		else if (*name == 'G') nets[1] = net;
		else if (*name == 'S') nets[2] = net;
		else {
			char msg[128];
			sprintf(msg, "Unrecognized pin on transistor %s", name);
			errorWithInstance(msg, ti);
		}
		break;
	case 'h':
		if (*name == 'D') nets[0] = net;
		else if (*name == 'G') nets[1] = net;
		else if (*name == 'S') nets[2] = net;
		else if (*name == 'B') {
			nets[3] = net;
			if (!net) {
				char msg[128];
				sprintf(msg, "Unconnected pin on transistor %s", name);
				errorWithInstance(msg, ti);
			}
		}
		else {
			char msg[128];
			sprintf(msg, "Unrecognized pin on transistor %s", name);
			errorWithInstance(msg, ti);
		}
		break;
	}

	return(0);
}

char *LTCReplacePWLScale(char *value)
{
	char *sReturn;
	char *test;

	String^ sValue = System::Convert::ToString(value);
	if (sValue->Contains("1E-6") | sValue->Contains("1E-12")) {
		// TBD
	}
	IntPtr ptrToNativeString = Marshal::StringToHGlobalAnsi(sValue);
	test = static_cast<char*>(ptrToNativeString.ToPointer());

	sReturn = new char[strlen(value) + 10];
	strcpy(sTclTxt, LTCSimExtParam(value));
	sprintf(pattern, ".*1E-(6|12)]?");
	int idx = Tcl_RegExpMatch(interp, sTclTxt, pattern);

	if (idx > 0) {
		strcpy(sReturn, sTclTxt);
		return(sReturn);
	}
	else {
		switch (cCmd_Tool)
		{
		case 'l':
		case 'p':
		case 'h':
			sprintf(sReturn, "%s*1e-6", sTclTxt);
			return (sReturn);
			break;
		case 'a':
		case 'd':
		case 't':
			strcpy(sReturn, sTclTxt);
			return(sReturn);
			break;
		default:
			return(sReturn);
		}
	}
}


char *LTCReplaceAScale(char *value)
{
	char *sReturn;

	sReturn = new char[strlen(value) + 10];
	strcpy(sTclTxt, LTCSimExtParam(value));
	sprintf(pattern, ".*1E-(6|12)]?");
	int idx = Tcl_RegExpMatch(interp, sTclTxt, pattern);

	if (idx > 0) {
		strcpy(sReturn, sTclTxt);
		return(sReturn);
	}
	else {
		switch (cCmd_Tool)
		{
		case 'l':
		case 'p':
		case 'h':
			sprintf(sReturn, "%s*1e-12", sTclTxt);
			return (sReturn);
			break;
		case 'a':
		case 'd':
		case 't':
			strcpy(sReturn, sTclTxt);
			return(sReturn);
			break;
		default:
			return(sReturn);
		}
	}
}


/* Prefix = B - MESFET, M - MOSFET */

static void FET_Transistor()
{
	char *val;
	char ch = '\0';

	char szVal[256];
	char szShrink[256];
	char szResize[256];
	bool bSimPrimitive = true;
	char szSpiceModel[256];
	char *tVal;
	char szTemp[256];
	//CString sTemp;
	String^ sTemp;
	LTCUtils ltcUtility;

	switch (cCmd_Tool)
	{
	case 'l':
	case 'p':
	case 'h':
		if (*(val = Get_TIA(ti, SIM_LEVEL))) {
			if ((*val == 'N') || (*val == 'n') || (*val == '0'))
				bSimPrimitive = true;
			else
				bSimPrimitive = false;
		}
		else
			bSimPrimitive = true;
		break;
	}


	ForEachInstancePin(ti, FET_Pins);
	if (nets[0] && nets[1] && nets[2]) {
		Out_Nets(4);
		switch (cCmd_Tool)
		{
		case 'l':
		case 'p':
			if (!nets[3] && !bDigitalMode)
				Out_Def_Net();
			break;
		case 'h':
		case 'a':
		case 'd':
		case 't':
			Out_Def_Net();
			break;
		}

		/* LVS_TYPE */
		switch (cCmd_Tool)
		{
		case 'a':
		case 'd':
			if (*(val = Get_TIA(ti, LVS_TYPE)) && *val != '*')
			{
				//strcpy( szTemp, val );
				//sTemp = CString( szTemp );
				sTemp = ltcUtility.LtcCharsToString(val);
				//if( !bCmd_IgnoreCase ) sTemp.MakeLower();
				if (!bCmd_IgnoreCase) sTemp->ToLower();
				//sprintf( line, " %s", sTemp.GetBuffer() );
				sprintf(line, " %s", ltcUtility.LtcStringToChars(sTemp));
				Data_Out(line, false);
			}
			else
				if (*(tVal = Get_TIA(ti, LVS_REMOVE)) == NULL)
					errorWithInstance("Missing LVS type attribute", ti);
			break;
		}

		/* CELL */
		switch (cCmd_Tool)
		{
		case 't':
			if (*(val = Get_TIA(ti, CELL)) && *val != '*')
			{
				//strcpy( szTemp, val );
				//sTemp = CString( szTemp );
				sTemp = ltcUtility.LtcCharsToString(val);
				//if( !bCmd_IgnoreCase ) sTemp.MakeLower();
				if (!bCmd_IgnoreCase) sTemp->ToLower();
				//sprintf(line, " %s", sTemp.GetBuffer());
				sprintf(line, " %s", ltcUtility.LtcStringToChars(sTemp));
				Data_Out(line, false);
			}
			else if (*(tVal = Get_TIA(ti, LVS_REMOVE)) == NULL)
			{
				sprintf(line, " dummy");
				Data_Out(line, false);
			}
			break;
		}

		/* SPICEMODEL */
		switch (cCmd_Tool)
		{
		case 'l':
		case 'p':
			if (!bDigitalMode) {
				if (*(val = Get_TIA(ti, SPICEMODEL)) && *val != '*')
				{
					//strcpy( szTemp, val );
					//sTemp = CString( szTemp );
					sTemp = ltcUtility.LtcCharsToString(val);
					//if( !bCmd_IgnoreCase ) sTemp.MakeLower();
					if (!bCmd_IgnoreCase) sTemp->ToLower();
					if (bSimPrimitive)
						//sprintf( line, " %s", sTemp.GetBuffer() );
						sprintf(line, " %s", ltcUtility.LtcStringToChars(sTemp));
					else {
						//strcpy_s(szSpiceModel, sTemp.GetLength() + 1, sTemp );
						strcpy_s(szSpiceModel, sTemp->Length + 1, ltcUtility.LtcStringToChars(sTemp));
						if (*(val = Get_TIA(ti, SIM_LEVEL)))
						{
							//strcpy( szTemp, val );
							//sTemp = CString( szTemp );
							sTemp = ltcUtility.LtcCharsToString(val);
							//if( !bCmd_IgnoreCase ) sTemp.MakeLower();
							if (!bCmd_IgnoreCase) sTemp->ToLower();
							//
							sprintf(line, " %s%s", szSpiceModel, ltcUtility.LtcStringToChars(sTemp));
						}
						else
							sprintf(line, " %s", szSpiceModel);
					}
					Data_Out(line, false);
				}
				else
					errorWithInstance("Device model needs to be checked", ti);
			}
			break;
		case 'h':
			if (*(val = Get_TIA(ti, SPICEMODEL)) && *val != '*')
			{
				//strcpy( szTemp, val );
				//sTemp = CString( szTemp );
				sTemp = ltcUtility.LtcCharsToString(val);
				//if( !bCmd_IgnoreCase ) sTemp.MakeLower();
				if (!bCmd_IgnoreCase) sTemp->ToLower();
				if (bSimPrimitive)
					//sprintf( line, " %s", sTemp.GetBuffer() );
					sprintf(line, " %s", ltcUtility.LtcStringToChars(sTemp));
				else {
					//strcpy_s(szSpiceModel, sTemp.GetLength() + 1,  sTemp );
					strcpy_s(szSpiceModel, sTemp->Length + 1, ltcUtility.LtcStringToChars(sTemp));
					if (*(val = Get_TIA(ti, SIM_LEVEL)))
					{
						//strcpy( szTemp, val );
						//sTemp = CString( szTemp );
						sTemp = ltcUtility.LtcCharsToString(val);
						//if( !bCmd_IgnoreCase ) sTemp.MakeLower();
						if (!bCmd_IgnoreCase) sTemp->ToLower();
						//sprintf( line, " %s%s", szSpiceModel, sTemp.GetBuffer() );
						sprintf(line, " %s%s", szSpiceModel, ltcUtility.LtcStringToChars(sTemp));
					}
					else
						sprintf(line, " %s", szSpiceModel);
				}
				Data_Out(line, false);
			}
			else
				errorWithInstance("Device model needs to be checked", ti);
			break;
		}


		if (bSimPrimitive) {
			/* LENGTH */
			if (*(val = Get_TIA(ti, LENGTH)) && *val != '*') {
				if (!LTCSimPassParamVal(val)) {
					if (bCmd_Shrink) {
						strcpy(szVal, val);
						val = Get_TIA(ti, SHRINK);
						strcpy(szShrink, val);
						val = Get_TIA(ti, GATE_RESIZE);
						strcpy(szResize, val);
						switch (cCmd_Tool)
						{
						case 'l':
						case 'p':
							if (!bDigitalMode)
								if (bCmd_IgnoreCase)
									sprintf(line, " L={((%s*%s)-%s)*1e-6}", szVal, szShrink, szResize);
								else
									sprintf(line, " l={((%s*%s)-%s)*1e-6}", szVal, szShrink, szResize);
							break;
						case 'h':
							if (bCmd_IgnoreCase)
								sprintf(line, " L='((%s*%s)-%s)*1e-6'", szVal, szShrink, szResize);
							else
								sprintf(line, " l='((%s*%s)-%s)*1e-6'", szVal, szShrink, szResize);
							break;
						case 'a':
						case 'd':
						case 't':
							if (bCmd_IgnoreCase)
								sprintf(line, " L=(%s*%s)-%s", szVal, szShrink, szResize);
							else
								sprintf(line, " l=(%s*%s)-%s", szVal, szShrink, szResize);
							break;
						}
					}
					else {
						switch (cCmd_Tool)
						{
						case 'l':
						case 'p':
							if (!bDigitalMode)
								if (bCmd_IgnoreCase)
									sprintf(line, " L=%su", val);
								else
									sprintf(line, " l=%su", val);
							break;
						case 'h':
							if (bCmd_IgnoreCase)
								sprintf(line, " L=%su", val);
							else
								sprintf(line, " l=%su", val);
							break;
						case 'a':
						case 'd':
						case 't':
							if (bCmd_IgnoreCase)
								sprintf(line, " L=%s", val);
							else
								sprintf(line, " l=%s", val);
							break;
						}
					}
				}
				else {
					if (bCmd_Shrink) {
						strcpy(szVal, LTCSimExtParam(val));
						val = Get_TIA(ti, SHRINK);
						strcpy(szShrink, val);
						val = Get_TIA(ti, GATE_RESIZE);
						strcpy(szResize, val);
						switch (cCmd_Tool)
						{
						case 'l':
						case 'p':
							if (!bDigitalMode)
								if (bCmd_IgnoreCase)
									sprintf(line, " L={((%s*%s)-%s)*1e-6}", szVal, szShrink, szResize);
								else
									sprintf(line, " l={((%s*%s)-%s)*1e-6}", szVal, szShrink, szResize);
							break;
						case 'h':
							if (bCmd_IgnoreCase)
								sprintf(line, " L='((%s*%s)-%s)*1e-6'", szVal, szShrink, szResize);
							else
								sprintf(line, " l='((%s*%s)-%s)*1e-6'", szVal, szShrink, szResize);
							break;
						case 'a':
						case 'd':
						case 't':
							if (bCmd_IgnoreCase)
								sprintf(line, " L=(%s*%s)-%s", szVal, szShrink, szResize);
							else
								sprintf(line, " l=(%s*%s)-%s", szVal, szShrink, szResize);
							break;
						}
					}
					else {
						switch (cCmd_Tool)
						{
						case 'l':
						case 'p':
							if (!bDigitalMode)
								if (bCmd_IgnoreCase)
									sprintf(line, " L={%s}", LTCReplacePWLScale(val));
								else
									sprintf(line, " l={%s}", LTCReplacePWLScale(val));
							break;
						case 'h':
							if (bCmd_IgnoreCase)
								sprintf(line, " L='%s'", LTCReplacePWLScale(val));
							else
								sprintf(line, " l='%s'", LTCReplacePWLScale(val));
							break;
						case 'a':
						case 'd':
						case 't':
							if (bCmd_IgnoreCase)
								sprintf(line, " L=%s", LTCReplacePWLScale(val));
							else
								sprintf(line, " l=%s", LTCReplacePWLScale(val));
							break;
						}
					}
				}
				switch (cCmd_Tool)
				{
				case 'l':
				case 'p':
					if (!bDigitalMode)
						Data_Out(line, false);
					break;
				case 'h':
				case 'a':
				case 'd':
				case 't':
					Data_Out(line, false);
					break;
				}
			}
			else if (*val == '*')
				errorWithInstance("Missing length value attribute", ti);

			/* WIDTH */
			if (*(val = Get_TIA(ti, WIDTH)) && *val != '*') {
				if (!LTCSimPassParamVal(val)) {
					if (bCmd_Shrink) {
						strcpy(szVal, val);
						val = Get_TIA(ti, SHRINK);
						strcpy(szShrink, val);
						switch (cCmd_Tool)
						{
						case 'l':
						case 'p':
							if (!bDigitalMode)
								if (bCmd_IgnoreCase)
									sprintf(line, " W={(%s*%s)*1e-6}", szVal, szShrink);
								else
									sprintf(line, " w={(%s*%s)*1e-6}", szVal, szShrink);
							break;
						case 'h':
							if (bCmd_IgnoreCase)
								sprintf(line, " W='(%s*%s)*1e-6'", szVal, szShrink);
							else
								sprintf(line, " w='(%s*%s)*1e-6'", szVal, szShrink);
							break;
						case 'a':
						case 'd':
						case 't':
							if (bCmd_IgnoreCase)
								sprintf(line, " W=%s*%s", szVal, szShrink);
							else
								sprintf(line, " w=%s*%s", szVal, szShrink);
							break;
						}
					}
					else {
						switch (cCmd_Tool)
						{
						case 'l':
						case 'p':
							if (!bDigitalMode)
								if (bCmd_IgnoreCase)
									sprintf(line, " W=%su", val);
								else
									sprintf(line, " w=%su", val);
							break;
						case 'h':
							if (bCmd_IgnoreCase)
								sprintf(line, " W=%su", val);
							else
								sprintf(line, " w=%su", val);
							break;
						case 'a':
						case 'd':
						case 't':
							if (bCmd_IgnoreCase)
								sprintf(line, " W=%s", val);
							else
								sprintf(line, " w=%s", val);
							break;
						}
					}
				}
				else {
					if (bCmd_Shrink) {
						strcpy(szVal, LTCSimExtParam(val));
						val = Get_TIA(ti, SHRINK);
						strcpy(szShrink, val);
						val = Get_TIA(ti, GATE_RESIZE);
						strcpy(szResize, val);
						switch (cCmd_Tool)
						{
						case 'l':
						case 'p':
							if (!bDigitalMode)
								if (bCmd_IgnoreCase)
									sprintf(line, " W={(%s*%s)*1e-6}", szVal, szShrink);
								else
									sprintf(line, " w={(%s*%s)*1e-6}", szVal, szShrink);
							break;
						case 'h':
							if (bCmd_IgnoreCase)
								sprintf(line, " W='(%s*%s)*1e-6'", szVal, szShrink);
							else
								sprintf(line, " w='(%s*%s)*1e-6'", szVal, szShrink);
							break;
						case 'a':
						case 'd':
						case 't':
							if (bCmd_IgnoreCase)
								sprintf(line, " W=%s*%s", szVal, szShrink);
							else
								sprintf(line, " w=%s*%s", szVal, szShrink);
							break;
						}
					}
					else {
						switch (cCmd_Tool)
						{
						case 'l':
						case 'p':
							if (!bDigitalMode)
								if (bCmd_IgnoreCase)
									sprintf(line, " W={%s}", LTCReplacePWLScale(val));
								else
									sprintf(line, " w={%s}", LTCReplacePWLScale(val));
							break;
						case 'h':
							if (bCmd_IgnoreCase)
								sprintf(line, " W='%s'", LTCReplacePWLScale(val));
							else
								sprintf(line, " w='%s'", LTCReplacePWLScale(val));
							break;
						case 'a':
						case 'd':
						case 't':
							if (bCmd_IgnoreCase)
								sprintf(line, " W=%s", LTCReplacePWLScale(val));
							else
								sprintf(line, " w=%s", LTCReplacePWLScale(val));
							break;
						}
					}
				}
				switch (cCmd_Tool)
				{
				case 'l':
				case 'p':
					if (!bDigitalMode)
						Data_Out(line, false);
					break;
				case 'h':
				case 'a':
				case 'd':
				case 't':
					Data_Out(line, false);
					break;
				}
			}
			else if (*val == '*')
				errorWithInstance("Missing width value attribute", ti);

			/* AREA_S */
			switch (cCmd_Tool)
			{
			case 'l':
			case 'p':
				if (*(val = Get_TIA(ti, AREA_S)) && *val != '*') {
					if (!LTCSimPassParamVal(val)) {
						if (bCmd_Shrink) {
							strcpy(szVal, val);
							val = Get_TIA(ti, SHRINK);
							strcpy(szShrink, val);
							if (!bDigitalMode)
								sprintf(line, " as={(%s*%s*%s)*1e-12}", szVal, szShrink, szShrink);
						}
						else
							if (!bDigitalMode)
								sprintf(line, " as=%sp", val);
					}
					else {
						if (bCmd_Shrink) {
							strcpy(szVal, LTCSimExtParam(val));
							val = Get_TIA(ti, SHRINK);
							strcpy(szShrink, val);
							if (!bDigitalMode)
								sprintf(line, " as={%s*%s*%s}", szVal, szShrink, szShrink);
						}
						else {
							if (!bDigitalMode)
								sprintf(line, " as={%s}", LTCReplaceAScale(val));
						}
					}
					if (!bDigitalMode)
						Data_Out(line, false);
				}
				break;
			case 'h':
				if (*(val = Get_TIA(ti, AREA_S)) && *val != '*') {
					if (!LTCSimPassParamVal(val)) {
						if (bCmd_Shrink) {
							strcpy(szVal, val);
							val = Get_TIA(ti, SHRINK);
							strcpy(szShrink, val);
							sprintf(line, " as='(%s*%s*%s)*1e-12'", szVal, szShrink, szShrink);
						}
						else
							sprintf(line, " as=%sp", val);
					}
					else {
						if (bCmd_Shrink) {
							strcpy(szVal, LTCSimExtParam(val));
							val = Get_TIA(ti, SHRINK);
							strcpy(szShrink, val);
							sprintf(line, " as='%s*%s*%s'", szVal, szShrink, szShrink);
						}
						else {
							sprintf(line, " as='%s'", LTCReplaceAScale(val));
						}
					}
					Data_Out(line, false);
				}
				break;
			}

			/* AREA_D */
			switch (cCmd_Tool)
			{
			case 'l':
			case 'p':
				if (*(val = Get_TIA(ti, AREA_D)) && *val != '*') {
					if (!LTCSimPassParamVal(val)) {
						if (bCmd_Shrink) {
							strcpy(szVal, val);
							val = Get_TIA(ti, SHRINK);
							strcpy(szShrink, val);
							if (!bDigitalMode)
								sprintf(line, " ad={(%s*%s*%s)*1e-12}", szVal, szShrink, szShrink);
						}
						else
							if (!bDigitalMode)
								sprintf(line, " ad=%sp", val);
					}
					else {
						if (bCmd_Shrink) {
							strcpy(szVal, LTCSimExtParam(val));
							val = Get_TIA(ti, SHRINK);
							strcpy(szShrink, val);
							if (!bDigitalMode)
								sprintf(line, " ad={%s*%s*%s}", szVal, szShrink, szShrink);
						}
						else {
							if (!bDigitalMode)
								sprintf(line, " ad={%s}", LTCReplaceAScale(val));
						}
					}
					if (!bDigitalMode)
						Data_Out(line, false);
				}
				break;
			case 'h':
				if (*(val = Get_TIA(ti, AREA_D)) && *val != '*') {
					if (!LTCSimPassParamVal(val)) {
						if (bCmd_Shrink) {
							strcpy(szVal, val);
							val = Get_TIA(ti, SHRINK);
							strcpy(szShrink, val);
							sprintf(line, " ad='(%s*%s*%s)*1e-12'", szVal, szShrink, szShrink);
						}
						else
							sprintf(line, " ad=%sp", val);
					}
					else {
						if (bCmd_Shrink) {
							strcpy(szVal, LTCSimExtParam(val));
							val = Get_TIA(ti, SHRINK);
							strcpy(szShrink, val);
							sprintf(line, " ad='%s*%s*%s'", szVal, szShrink, szShrink);
						}
						else {
							sprintf(line, " ad='%s'", LTCReplaceAScale(val));
						}
					}
					Data_Out(line, false);
				}
				break;
			}

			/* PERI_S */
			switch (cCmd_Tool)
			{
			case 'l':
			case 'p':
				if (*(val = Get_TIA(ti, PERI_S)) && *val != '*') {
					if (!LTCSimPassParamVal(val)) {
						if (bCmd_Shrink) {
							strcpy(szVal, val);
							val = Get_TIA(ti, SHRINK);
							strcpy(szShrink, val);
							val = Get_TIA(ti, GATE_RESIZE);
							strcpy(szResize, val);
							if (!bDigitalMode)
								sprintf(line, " ps={((%s*%s)+%s)*1e-6}", szVal, szShrink, szResize);
						}
						else
							if (!bDigitalMode)
								sprintf(line, " ps=%su", val);
					}
					else {
						if (bCmd_Shrink) {
							strcpy(szVal, LTCSimExtParam(val));
							val = Get_TIA(ti, SHRINK);
							strcpy(szShrink, val);
							val = Get_TIA(ti, GATE_RESIZE);
							strcpy(szResize, val);
							if (!bDigitalMode)
								sprintf(line, " ps={(%s*%s)+(%s*1e-6)}", szVal, szShrink, szResize);
						}
						else {
							if (!bDigitalMode)
								sprintf(line, " ps={%s}", LTCReplacePWLScale(val));
						}
					}
					if (!bDigitalMode)
						Data_Out(line, false);
				}
				break;
			case 'h':
				if (*(val = Get_TIA(ti, PERI_S)) && *val != '*') {
					if (!LTCSimPassParamVal(val)) {
						if (bCmd_Shrink) {
							strcpy(szVal, val);
							val = Get_TIA(ti, SHRINK);
							strcpy(szShrink, val);
							val = Get_TIA(ti, GATE_RESIZE);
							strcpy(szResize, val);
							sprintf(line, " ps='((%s*%s)+%s)*1e-6'", szVal, szShrink, szResize);
						}
						else
							sprintf(line, " ps=%su", val);
					}
					else {
						if (bCmd_Shrink) {
							strcpy(szVal, LTCSimExtParam(val));
							val = Get_TIA(ti, SHRINK);
							strcpy(szShrink, val);
							val = Get_TIA(ti, GATE_RESIZE);
							strcpy(szResize, val);
							sprintf(line, " ps='(%s*%s)+(%s*1e-6)'", szVal, szShrink, szResize);
						}
						else {
							sprintf(line, " ps='%s'", LTCReplacePWLScale(val));
						}
					}
					Data_Out(line, false);
				}
				break;
			}

			/* PERI_D */
			switch (cCmd_Tool)
			{
			case 'l':
			case 'p':
				if (*(val = Get_TIA(ti, PERI_D)) && *val != '*') {
					if (!LTCSimPassParamVal(val)) {
						if (bCmd_Shrink) {
							strcpy(szVal, val);
							val = Get_TIA(ti, SHRINK);
							strcpy(szShrink, val);
							val = Get_TIA(ti, GATE_RESIZE);
							strcpy(szResize, val);
							if (!bDigitalMode)
								sprintf(line, " pd={((%s*%s)+%s)*1e-6}", szVal, szShrink, szResize);
						}
						else {
							if (!bDigitalMode)
								sprintf(line, " pd=%su", val);
						}
					}
					else {
						if (bCmd_Shrink) {
							strcpy(szVal, LTCSimExtParam(val));
							val = Get_TIA(ti, SHRINK);
							strcpy(szShrink, val);
							val = Get_TIA(ti, GATE_RESIZE);
							strcpy(szResize, val);
							if (!bDigitalMode)
								sprintf(line, " pd={(%s*%s)+(%s*1e-6)}", szVal, szShrink, szResize);
						}
						else {
							if (!bDigitalMode)
								sprintf(line, " pd={%s}", LTCReplacePWLScale(val));
						}
					}
					if (!bDigitalMode)
						Data_Out(line, false);
				}
				break;
			case 'h':
				if (*(val = Get_TIA(ti, PERI_D)) && *val != '*') {
					if (!LTCSimPassParamVal(val)) {
						if (bCmd_Shrink) {
							strcpy(szVal, val);
							val = Get_TIA(ti, SHRINK);
							strcpy(szShrink, val);
							val = Get_TIA(ti, GATE_RESIZE);
							strcpy(szResize, val);
							sprintf(line, " pd='((%s*%s)+%s)*1e-6'", szVal, szShrink, szResize);
						}
						else {
							sprintf(line, " pd=%su", val);
						}
					}
					else {
						if (bCmd_Shrink) {
							strcpy(szVal, LTCSimExtParam(val));
							val = Get_TIA(ti, SHRINK);
							strcpy(szShrink, val);
							val = Get_TIA(ti, GATE_RESIZE);
							strcpy(szResize, val);
							sprintf(line, " pd='(%s*%s)+(%s*1e-6)'", szVal, szShrink, szResize);
						}
						else {
							sprintf(line, " pd='%s'", LTCReplacePWLScale(val));
						}
					}
					Data_Out(line, false);
				}
				break;
			}

			/* NRS */
			switch (cCmd_Tool)
			{
			case 'l':
			case 'p':
			case 'h':
				if (*(val = Get_TIA(ti, NRS)) && *val != '*') {
					sprintf(line, " nrs=%s", val);
					Data_Out(line, false);
				}
				break;
			}
			/* NRD */
			switch (cCmd_Tool)
			{
			case 'l':
			case 'p':
			case 'h':
				if (*(val = Get_TIA(ti, NRD)) && *val != '*') {
					sprintf(line, " nrd=%s", val);
					Data_Out(line, false);
				}
				break;
			}
		}
		/* MULTI */
		if (*(val = Get_TIA(ti, MULTI)) && *val != '*') {
			sprintf(line, " %s%s", szCmd_MultiCode, val);
			Data_Out(line, false);
		}
		if (bSimPrimitive) {

			/* LVS_LDD */
			switch (cCmd_Tool)
			{
			case 'a':
			case 'd':
				if (*(val = Get_TIA(ti, LVS_LDD))) {
					tVal = Get_TIA(ti, LVS_TYPE);
					if (toupper(*val) == 'Y') {
						sprintf(line, " $ldd[%s]", tVal);
					}
					else {
						sprintf(line, " $ldd[%s]", val);
					}
					Data_Out(line, true);
				}
				break;
			}
			/* SPICELINE */
			if (*(val = Get_TIA(ti, SPICELINE)) && *val != '*') {
				switch (cCmd_Tool)
				{
				case 'l':
				case 'p':
					if (!bDigitalMode)
						sprintf(line, " params: %s", val);
					if (!bDigitalMode)
						Data_Out(line, false);
					break;
				case 'h':
				case 'a':
				case 'd':
				case 't':
					sprintf(line, " %s", val);
					Data_Out(line, false);
					break;
				}
			}
		}

		/* SPICELINE3 */
		if ((*(val = Get_TIA(ti, SPICELINE3))) && !bSimPrimitive) {
			switch (cCmd_Tool)
			{
			case 'l':
			case 'p':
				if (!bDigitalMode)
					sprintf(line, " params: %s", val);
				if (!bDigitalMode)
					Data_Out(line, false);
				break;
			case 'h':
			case 'a':
			case 'd':
			case 't':
				sprintf(line, " %s", val);
				Data_Out(line, false);
				break;
			}
		}
		switch (cCmd_Tool)
		{
		case 'l':
		case 'p':
			if (bDigitalMode) {
				if (*(val = Get_TIA(ti, DIGITAL_TIMING))) {
					sprintf(line, " %s", val);
					Data_Out(line, false);
				}
				else {
					char msg[128];
					sprintf(msg, "Error:Timing information not available on instance");
					errorWithInstance(msg, ti);
				}
				if (*(val = Get_TIA(ti, DIGITAL_IO))) {
					sprintf(line, " %s", val);
					Data_Out(line, false);
				}
				else {
					char msg[128];
					sprintf(msg, "Error:I/O information not available on instance");
					errorWithInstance(msg, ti);
				}
				if (*(val = Get_TIA(ti, DIGITAL_MNTYMXDLY))) {
					sprintf(line, " mntymxdly=%s", val);
					Data_Out(line, false);
				}
				if (*(val = Get_TIA(ti, DIGITAL_IO_LEVEL))) {
					sprintf(line, " io_level=%s", val);
					Data_Out(line, false);
				}
			}
			break;
		}

		/* APT LOCATION */
		switch (cCmd_Tool)
		{
		case 't':
			if (*(val = Get_TIA(ti, 254))){
				sprintf(line, " x_loc=%s y_loc=%s", LTCSimSplitXLoc(val), LTCSimSplitYLoc(val));
				Data_Out(line, true);
			}
			break;
		}
		Data_Out("\n", false);
	}
	else {
		errorWithInstance("Unconnected pin on transistor", ti);
	}
	ltcUtility.~LTCUtils();
}


/* Prefix = J - JFET */

static void JFET_Transistor()
{
	char *val;
	char ch = '\0';

	char szVal[256];
	char szShrink[256];
	char szResize[256];
	bool bSimPrimitive = true;
	char szSpiceModel[256];
	char *tVal;

	switch (cCmd_Tool)
	{
	case 'l':
	case 'p':
	case 'h':
		if (*(val = Get_TIA(ti, SIM_LEVEL))) {
			if ((*val == 'N') || (*val == 'n') || (*val == '0'))
				bSimPrimitive = true;
			else
				bSimPrimitive = false;
		}
		else
			bSimPrimitive = true;
		break;
	}

	ForEachInstancePin(ti, JFET_Pins);
	if (nets[0] && nets[1] && nets[2]) {
		switch (cCmd_Tool)
		{
		case 'h':
			Out_Nets(4);
			Out_Def_Net();
			break;
		case 'l':
		case 'p':
		case 'a':
		case 'd':
		case 't':
			Out_Nets(3);
			break;
		}

		/* LVS_TYPE */
		switch (cCmd_Tool)
		{
		case 'a':
		case 'd':
			if (*(val = Get_TIA(ti, LVS_TYPE)) && *val != '*') {
				sprintf(line, " %s", val);
				Data_Out(line, false);
			}
			else
				if (*(tVal = Get_TIA(ti, LVS_REMOVE)) == NULL)
					errorWithInstance("Missing LVS type attribute", ti);
			break;
		}

		/* CELL */
		switch (cCmd_Tool)
		{
		case 't':
			if (*(val = Get_TIA(ti, CELL)) && *val != '*') {
				sprintf(line, " %s", val);
				Data_Out(line, false);
			}
			else if (*(tVal = Get_TIA(ti, LVS_REMOVE)) == NULL){
				sprintf(line, " dummy");
				Data_Out(line, false);
			}
			break;
		}

		/* SPICEMODEL */
		switch (cCmd_Tool)
		{
		case 'l':
		case 'p':
			if (!bDigitalMode) {
				if (*(val = Get_TIA(ti, SPICEMODEL)) && *val != '*') {
					if (bSimPrimitive)
						sprintf(line, " %s", val);
					else {
						strcpy(szSpiceModel, val);
						if (*(val = Get_TIA(ti, SIM_LEVEL)))
							sprintf(line, " %s%s", szSpiceModel, val);
						else
							sprintf(line, " %s", szSpiceModel);
					}
					Data_Out(line, false);
				}
				else
					errorWithInstance("Device model needs to be checked", ti);
			}
			break;
		case 'h':
			if (*(val = Get_TIA(ti, SPICEMODEL)) && *val != '*') {
				if (bSimPrimitive)
					sprintf(line, " %s", val);
				else {
					strcpy(szSpiceModel, val);
					if (*(val = Get_TIA(ti, SIM_LEVEL)))
						sprintf(line, " %s%s", szSpiceModel, val);
					else
						sprintf(line, " %s", szSpiceModel);
				}
				Data_Out(line, false);
			}
			else
				errorWithInstance("Device model needs to be checked", ti);
			break;
		}

		/* LENGTH */
		if (*(val = Get_TIA(ti, LENGTH)) && *val != '*') {
			if (!LTCSimPassParamVal(val)) {
				if (bCmd_Shrink) {
					strcpy(szVal, val);
					val = Get_TIA(ti, SHRINK);
					strcpy(szShrink, val);
					val = Get_TIA(ti, GATE_RESIZE);
					strcpy(szResize, val);
					switch (cCmd_Tool)
					{
					case 'h':
						if (bCmd_IgnoreCase)
							sprintf(line, " L='((%s*%s)-%s)*1e-6'", szVal, szShrink, szResize);
						else
							sprintf(line, " l='((%s*%s)-%s)*1e-6'", szVal, szShrink, szResize);
						break;
					case 'a':
					case 'd':
					case 't':
						if (bCmd_IgnoreCase)
							sprintf(line, " L=(%s*%s)-%s", szVal, szShrink, szResize);
						else
							sprintf(line, " l=(%s*%s)-%s", szVal, szShrink, szResize);
						break;
					}
				}
				else {
					switch (cCmd_Tool)
					{
					case 'h':
						if (bCmd_IgnoreCase)
							sprintf(line, " L=%su", val);
						else
							sprintf(line, " l=%su", val);
						break;
					case 'a':
					case 'd':
					case 't':
						if (bCmd_IgnoreCase)
							sprintf(line, " L=%s", val);
						else
							sprintf(line, " l=%s", val);
						break;
					}
				}
			}
			else {
				if (bCmd_Shrink) {
					strcpy(szVal, LTCSimExtParam(val));
					val = Get_TIA(ti, SHRINK);
					strcpy(szShrink, val);
					val = Get_TIA(ti, GATE_RESIZE);
					strcpy(szResize, val);
					switch (cCmd_Tool)
					{
					case 'h':
						if (bCmd_IgnoreCase)
							sprintf(line, " L='((%s*%s)-%s)*1e-6'", szVal, szShrink, szResize);
						else
							sprintf(line, " l='((%s*%s)-%s)*1e-6'", szVal, szShrink, szResize);
						break;
					case 'a':
					case 'd':
					case 't':
						if (bCmd_IgnoreCase)
							sprintf(line, " L=(%s*%s)-%s", szVal, szShrink, szResize);
						else
							sprintf(line, " l=(%s*%s)-%s", szVal, szShrink, szResize);
						break;
					}
				}
				else {
					switch (cCmd_Tool)
					{
					case 'h':
						if (bCmd_IgnoreCase)
							sprintf(line, " L='%s'", LTCReplacePWLScale(val));
						else
							sprintf(line, " l='%s'", LTCReplacePWLScale(val));
						break;
					case 'a':
					case 'd':
					case 't':
						if (bCmd_IgnoreCase)
							sprintf(line, " L=%s", LTCReplacePWLScale(val));
						else
							sprintf(line, " l=%s", LTCReplacePWLScale(val));
						break;
					}
				}
			}
			switch (cCmd_Tool)
			{
			case 'h':
			case 'a':
			case 'd':
			case 't':
				Data_Out(line, false);
				break;
			}
		}
		else if (*val == '*')
			errorWithInstance("Missing length value attribute", ti);

		/* WIDTH */
		if (*(val = Get_TIA(ti, WIDTH)) && *val != '*') {
			if (!LTCSimPassParamVal(val)) {
				if (bCmd_Shrink) {
					strcpy(szVal, val);
					val = Get_TIA(ti, SHRINK);
					strcpy(szShrink, val);
					switch (cCmd_Tool)
					{
					case 'h':
						if (bCmd_IgnoreCase)
							sprintf(line, " W='(%s*%s)*1e-6'", szVal, szShrink);
						else
							sprintf(line, " w='(%s*%s)*1e-6'", szVal, szShrink);
						break;
					case 'a':
					case 'd':
					case 't':
						if (bCmd_IgnoreCase)
							sprintf(line, " W=%s*%s", szVal, szShrink);
						else
							sprintf(line, " w=%s*%s", szVal, szShrink);

						break;
					}
				}
				else {
					switch (cCmd_Tool)
					{
					case 'h':
						if (bCmd_IgnoreCase)
							sprintf(line, " W=%su", val);
						else
							sprintf(line, " w=%su", val);
						break;
					case 'a':
					case 'd':
					case 't':
						if (bCmd_IgnoreCase)
							sprintf(line, " W=%s", val);
						else
							sprintf(line, " w=%s", val);
						break;
					}
				}
			}
			else {
				if (bCmd_Shrink) {
					strcpy(szVal, LTCSimExtParam(val));
					val = Get_TIA(ti, SHRINK);
					strcpy(szShrink, val);
					val = Get_TIA(ti, GATE_RESIZE);
					strcpy(szResize, val);
					switch (cCmd_Tool)
					{
					case 'h':
						if (bCmd_IgnoreCase)
							sprintf(line, " W='(%s*%s)*1e-6'", szVal, szShrink);
						else
							sprintf(line, " w='(%s*%s)*1e-6'", szVal, szShrink);
						break;
					case 'a':
					case 'd':
					case 't':
						if (bCmd_IgnoreCase)
							sprintf(line, " W=%s*%s", szVal, szShrink);
						else
							sprintf(line, " w=%s*%s", szVal, szShrink);
						break;
					}
				}
				else {
					switch (cCmd_Tool)
					{
					case 'h':
						if (bCmd_IgnoreCase)
							sprintf(line, " W='%s'", LTCReplacePWLScale(val));
						else
							sprintf(line, " w='%s'", LTCReplacePWLScale(val));
						Data_Out(line, false);
						break;
					case 'a':
					case 'd':
					case 't':
						if (bCmd_IgnoreCase)
							sprintf(line, " w=%s", LTCReplacePWLScale(val));
						else
							sprintf(line, " W=%s", LTCReplacePWLScale(val));
						Data_Out(line, false);
						break;
					}
				}
			}
		}
		else if (*val == '*')
			errorWithInstance("Missing width value attribute", ti);

		/* MULTI */
		if (*(val = Get_TIA(ti, MULTI)) && *val != '*') {
			switch (cCmd_Tool)
			{
			case 'l':
			case 'p':
				sprintf(line, " %s", val);
				break;
			case 'h':
			case 'a':
			case 'd':
			case 't':
				if (bCmd_IgnoreCase)
					sprintf(line, " M=%s", val);
				else
					sprintf(line, " m=%s", val);
				break;
			}
			Data_Out(line, false);
		}

		/* LVS_LDD */
		switch (cCmd_Tool)
		{
		case 'a':
		case 'd':
		case 't':
			if (bSimPrimitive) {
				if (*(val = Get_TIA(ti, LVS_LDD))) {
					tVal = Get_TIA(ti, LVS_TYPE);
					if (toupper(*val) == 'Y') {
						sprintf(line, " $ldd[%s]", tVal);
					}
					else {
						sprintf(line, " $ldd[%s]", val);
					}
					Data_Out(line, true);
				}
			}
			break;
		}

		/* APT LOCATION */
		switch (cCmd_Tool)
		{
		case 't':
			if (*(val = Get_TIA(ti, 254))){
				sprintf(line, " x_loc=%s y_loc=%s", LTCSimSplitXLoc(val), LTCSimSplitYLoc(val));
				Data_Out(line, true);
			}
			break;
		}
		Data_Out("\n", false);
	}
	else {
		errorWithInstance("Unconnected pin on transistor", ti);
	}
}

/*---------- Transmission Lines ----------*/

static int XLine_Pins(TP_PTR tp)
{
	char* name;
	TN_PTR net;
	int err = 0;

	net = NetContainingPin(tp);
	if (bCmd_Flat && net) net = FindNetRoot(net);
	name = Get_TPA(tp, NAME);
	if (*name == 'I')
	{
		if (*(name + 1) == '1') nets[0] = net;
		else if (*(name + 1) == '2') nets[2] = net;
		else err = 1;
	}
	else if (*name == 'R')
	{
		if (*(name + 1) == '1') nets[1] = net;
		else if (*(name + 1) == '2') nets[3] = net;
		else err = 1;
	}
	else err = 1;
	if (err)
	{
		char msg[128];
		sprintf(msg, "Unrecognized pin on transmission lin %s", name);
		errorWithInstance(msg, ti);
	}
	return(0);
}

/* Prefix = T */
static void Transmission_Line()
{
	char* val;

	ForEachInstancePin(ti, XLine_Pins);

	if (nets[0] && nets[1] && nets[2] && nets[3])
	{
		Out_Nets(4);
		if (*(val = Get_TIA(ti, IMPEDANCE)) && *val != '*')
		{
			sprintf(line, " zo=%s", val);
			Data_Out(line, false);
		}
		if (*(val = Get_TIA(ti, VALUE)) && *val != '*')
		{
			sprintf(line, " td=%s", val);
			Data_Out(line, false);
		}
		if (*(val = Get_TIA(ti, SPICELINE)) && *val != '*')
		{
			sprintf(line, " %s", val);
			Data_Out(line, false);
		}
		if (*(val = Get_TIA(ti, SPICELINE2)) && *val != '*')
		{
			sprintf(line, " %s", val);
			Data_Out(line, false);
		}
		Data_Out("\n", false);
	}
	else
	{
		errorWithInstance("Unconnected pin", ti);
	}
}

/*---------- Diode Model ----------*/

static int Diode_Pins(TP_PTR tp)
{
	char* name;
	TN_PTR net;
	char str1[] = "T1";
	char str1_old[] = "+";
	char str1_old2[] = "A";
	char str2[] = "T2";
	char str2_old[] = "-";
	char str2_old2[] = "B";
	int index;
	char* spiceorder;

	spiceorder = Get_TPA(tp, SPICEORDER);
	net = NetContainingPin(tp);
	if (bCmd_Flat && net) net = FindNetRoot(net);
	name = Get_TPA(tp, NAME);
	if ((strcmp(name, str1) == 0) || (strcmp(name, str2) == 0))
	{
		if ((strcmp(name, str1) == 0))
		{
			nets[0] = net;
		}
		if ((strcmp(name, str2) == 0))
		{
			nets[1] = net;
		}
	}
	else
	{
		if ((strcmp(name, str1_old) == 0) || (strcmp(name, str2_old) == 0))
		{
			if ((strcmp(name, str1_old) == 0))
			{
				nets[0] = net;
			}
			if ((strcmp(name, str2_old) == 0))
			{
				nets[1] = net;
			}
		}
		else
		{
			if ((strcmp(name, str1_old2) == 0) || (strcmp(name, str2_old2) == 0))
			{
				if ((strcmp(name, str1_old2) == 0))
				{
					nets[0] = net;
				}
				if ((strcmp(name, str2_old2) == 0))
				{
					nets[1] = net;
				}
			}
			else
			{
				if (*spiceorder != '\0')
				{
					index = atoi(spiceorder);
					nets[index - 1] = net;
				}
			}
		}
	}
	/* Legacy
		if      ( *name == '+' ) nets[0] = net;
		else                     nets[1] = net;
		*/
	return(0);

}

/* Prefix = D */
static void Diode()
{
	char* val;
	char *tVal;

	char szVal[256];
	char szShrink[256];
	bool bSimPrimitive = true;
	char szSpiceModel[64];
	char szTemp[256];
	//CString sTemp; 
	String^ sTemp;
	LTCUtils ltcUtility;

	switch (cCmd_Tool)
	{
	case 'l':
	case 'p':
	case 'h':
		if (*(val = Get_TIA(ti, SIM_LEVEL)))
		{
			if ((*val == 'N') || (*val == 'n') || (*val == '0'))
			{
				bSimPrimitive = true;
			}
			else
			{
				bSimPrimitive = false;
			}
		}
		else
		{
			bSimPrimitive = true;
		}
		break;
	}

	ForEachInstancePin(ti, Diode_Pins);
	if (nets[0] && nets[1]) {
		Out_Nets(2);

		/* SPICEMODEL */
		switch (cCmd_Tool)
		{
		case 'l':
		case 'p':
		case 'h':
			if (*(val = Get_TIA(ti, SPICEMODEL)) && *val != '*')
			{
				//strcpy( szTemp, val);
				//sTemp = CString( szTemp );
				sTemp = ltcUtility.LtcCharsToString(val);
				//if( !bCmd_IgnoreCase ) sTemp.MakeLower();
				if (!bCmd_IgnoreCase) sTemp->ToLower();
				if (bSimPrimitive)
				{
					//sprintf( line, " %s", sTemp.GetBuffer() );
					sprintf(line, " %s", ltcUtility.LtcStringToChars(sTemp));
				}
				else
				{
					//strcpy(szSpiceModel, sTemp.GetBuffer());
					strcpy(szSpiceModel, ltcUtility.LtcStringToChars(sTemp));
					if (*(val = Get_TIA(ti, SIM_LEVEL)))
					{
						//strcpy( szTemp, val);
						//sTemp = CString( szTemp );
						sTemp = ltcUtility.LtcCharsToString(val);
						//if( !bCmd_IgnoreCase ) sTemp.MakeLower();
						if (!bCmd_IgnoreCase) sTemp->ToLower();
						//sprintf(line, " %s%s", szSpiceModel, sTemp.GetBuffer());
						sprintf(line, " %s%s", szSpiceModel, ltcUtility.LtcStringToChars(sTemp));
					}
					else
					{
						sprintf(line, " %s", szSpiceModel);
					}
				}
				Data_Out(line, false);
			}
			break;
		}

		/* LVS_TYPE */
		switch (cCmd_Tool)
		{
		case 'a':
		case 'd':
			if (*(val = Get_TIA(ti, LVS_TYPE)) && *val != '*')
			{
				//strcpy( szTemp, val);
				//sTemp = CString( szTemp );
				sTemp = ltcUtility.LtcCharsToString(val);
				//if( !bCmd_IgnoreCase ) sTemp.MakeLower();
				if (!bCmd_IgnoreCase) sTemp->ToLower();
				//sprintf(line, " %s", sTemp.GetBuffer());
				sprintf(line, " %s", ltcUtility.LtcStringToChars(sTemp));
				Data_Out(line, false);
			}
			else
			{
				if (*(tVal = Get_TIA(ti, LVS_REMOVE)) == NULL)
				{
					errorWithInstance("Missing LVS type attribute", ti);
				}
			}
			break;
		}

		/* CELL */
		switch (cCmd_Tool)
		{
		case 't':
			if (*(val = Get_TIA(ti, CELL)) && *val != '*')
			{
				//strcpy( szTemp, val);
				//sTemp = CString( szTemp );
				sTemp = ltcUtility.LtcCharsToString(val);
				//if( !bCmd_IgnoreCase ) sTemp.MakeLower();
				if (!bCmd_IgnoreCase) sTemp->ToLower();
				//sprintf(line, " %s", sTemp.GetBuffer());
				sprintf(line, " %s", ltcUtility.LtcStringToChars(sTemp));
				Data_Out(line, false);
			}
			else {
				if (*(tVal = Get_TIA(ti, LVS_REMOVE)) == NULL){
					sprintf(line, " dummy");
					Data_Out(line, false);
				}
			}
			break;
		}


		/* MULTI */
		if (*(val = Get_TIA(ti, MULTI))) {
			if (bCmd_Shrink) {
				strcpy(szVal, val);
				val = Get_TIA(ti, SHRINK);
				strcpy(szShrink, val);
				switch (cCmd_Tool)
				{
				case 'l':
				case 'p':
					sprintf(line, " {%s*%s*%s}", szVal, szShrink, szShrink);
					break;
				case 'h':
					sprintf(line, " '%s*%s*%s'", szVal, szShrink, szShrink);
					break;
				case 'a':
				case 'd':
				case 't':
					if (bCmd_IgnoreCase)
						sprintf(line, " M='%s*%s*%s'", szVal, szShrink, szShrink);
					else
						sprintf(line, " m='%s*%s*%s'", szVal, szShrink, szShrink);
					break;
				}
			}
			else {
				switch (cCmd_Tool)
				{
				case 'l':
				case 'p':
				case 'h':
					sprintf(line, " %s", val);
					break;
				case 'a':
				case 'd':
				case 't':
					if (bCmd_IgnoreCase)
						sprintf(line, " M=%s", val);
					else
						sprintf(line, " m=%s", val);
					break;
				}
			}
			Data_Out(line, false);
		}

		/* DAREA */
		switch (cCmd_Tool)
		{
		case 'a':
		case 'd':
		case 't':
			if ((*(val = Get_TIA(ti, DAREA)) && *val != '*') && bSimPrimitive)
			{
				if (bCmd_Shrink)
				{
					strcpy(szVal, val);
					val = Get_TIA(ti, SHRINK);
					strcpy(szShrink, val);
					sprintf(line, " %s*%s*%s", szVal, szShrink, szShrink);
				}
				else
					sprintf(line, " %s", val);
				Data_Out(line, false);
			}
			/* DPERIM */
			if ((*(val = Get_TIA(ti, DPERIM)) && *val != '*') && bSimPrimitive)
			{
				if (bCmd_Shrink)
				{
					strcpy(szVal, val);
					val = Get_TIA(ti, SHRINK);
					strcpy(szShrink, val);
					sprintf(line, " %s*%s", szVal, szShrink);
				}
				else
					sprintf(line, " %s", val);
				Data_Out(line, false);
			}
			/* DEFSUBSTRATE */
			if ((*(val = Get_TIA(ti, DEFSUBSTRATE)) && *val != '*') && bSimPrimitive)
			{
				sprintf(line, " $sub=%s", val);
				Data_Out(line, false);
			}
			break;
		}

		/* SPICELINE */
		switch (cCmd_Tool)
		{
		case 'l':
		case 'p':
		case 'h':
			if ((*(val = Get_TIA(ti, SPICELINE)) && *val != '*') && bSimPrimitive)
			{
				//strcpy( szTemp, val);
				//sTemp = CString( szTemp );
				sTemp = ltcUtility.LtcCharsToString(val);
				//if( !bCmd_IgnoreCase ) sTemp.MakeLower();
				if (!bCmd_IgnoreCase) sTemp->ToLower();
				//sprintf(line, " %s", sTemp.GetBuffer());
				sprintf(line, " %s", ltcUtility.LtcStringToChars(sTemp));
				Data_Out(line, false);
			}
			break;
		}


		/* SPICELINE3 */
		if ((*(val = Get_TIA(ti, SPICELINE3))) && !bSimPrimitive)
		{
			//strcpy( szTemp, val);
			//sTemp = CString( szTemp );
			sTemp = ltcUtility.LtcCharsToString(val);
			//if( !bCmd_IgnoreCase ) sTemp.MakeLower();
			if (!bCmd_IgnoreCase) sTemp->ToLower();
			switch (cCmd_Tool)
			{
			case 'l':
			case 'p':
				//sprintf( line, " params: %s", sTemp.GetBuffer() );
				sprintf(line, " params: %s", ltcUtility.LtcStringToChars(sTemp));
				break;
			case 'h':
			case 'a':
			case 'd':
			case 't':
				//sprintf( line, " %s", sTemp.GetBuffer() );
				sprintf(line, " %s", ltcUtility.LtcStringToChars(sTemp));
				break;
			}
		}

		/* APT LOCATION */
		switch (cCmd_Tool)
		{
		case 't':
			if (*(val = Get_TIA(ti, 254))){
				sprintf(line, " x_loc=%s y_loc=%s", LTCSimSplitXLoc(val), LTCSimSplitYLoc(val));
				Data_Out(line, true);
			}
			break;
		}
		Data_Out("\n", false);
	}
	else
	{
		errorWithInstance("Unconnected pin", ti);
	}
	ltcUtility.~LTCUtils();
}

/*---------- Independent Source ----------*/

static int Ind_Source_Pins(TP_PTR tp)
{
	char* name;
	TN_PTR net;

	net = NetContainingPin(tp);
	if (bCmd_Flat && net) net = FindNetRoot(net);
	name = Get_TPA(tp, NAME);
	if (*name == '+') nets[0] = net;
	else nets[1] = net;
	return(0);
}

/* Prefix = I - Independent Current Source, V - Independent Voltage Source */
static void Independent_Source()
{
	char* val;

	ForEachInstancePin(ti, Ind_Source_Pins);

	if (nets[0] && nets[1])
	{
		Out_Nets(2);
		if (*(val = Get_TIA(ti, VALUE)) && *val != '*')
		{
			sprintf(line, " %s", val);
			Data_Out(line, false);
		}
		else if (*val == '*')
		{
			errorWithInstance("Missing value attribute", ti);
		}


		if (*(val = Get_TIA(ti, SPICELINE)) && *val != '*')
		{
			sprintf(line, " %s", val);
			Data_Out(line, false);
		}
		if (*(val = Get_TIA(ti, SPICELINE2)) && *val != '*')
		{
			sprintf(line, " %s", val);
			Data_Out(line, false);
		}
		Data_Out("\n", false);
	}
	else
	{
		errorWithInstance("Unconnected pin", ti);
	}
}

/*---------- V_Control_Source ----------*/

static int V_Control_Source_Pins(TP_PTR tp)
{
	char* name;
	TN_PTR net;

	net = NetContainingPin(tp);
	if (bCmd_Flat && net) net = FindNetRoot(net);
	name = Get_TPA(tp, NAME);
	if (*name == '+') nets[0] = net;
	else if (*name == 'P') nets[2] = net;
	else if (*name == 'N') nets[3] = net;
	else nets[1] = net;
	return(0);
}

/* Prefix = E - Voltage Controlled Voltage, G - Voltage Controlled Current */
static void V_Control_Source()
{
	char* val;

	ForEachInstancePin(ti, V_Control_Source_Pins);

	if (nets[0] && nets[1] && nets[2] && nets[3])
	{
		Out_Nets(4);
		if (*(val = Get_TIA(ti, VALUE)) && *val != '*')
		{
			sprintf(line, " %s", val);
			Data_Out(line, false);
		}
		if (*(val = Get_TIA(ti, SPICELINE)) && *val != '*')
		{
			sprintf(line, " %s", val);
			Data_Out(line, false);
		}
		if (*(val = Get_TIA(ti, SPICELINE2)) && *val != '*')
		{
			sprintf(line, " %s", val);
			Data_Out(line, false);
		}
		Data_Out("\n", false);
	}
	else
	{
		errorWithInstance("Unconnected pin", ti);
	}
}

/*---------- TwoPort Model ----------*/

static int TwoPort_Pins(TP_PTR tp)
{
	TN_PTR net;

	net = NetContainingPin(tp);
	if (bCmd_Flat && net) net = FindNetRoot(net);
	if (nets[0]) nets[1] = net;
	else nets[0] = net;
	return(0);
}

/* Prefix = L - Inductor, R - Resistor */
static void TwoPort()
{
	char* val;
	char *tVal, *tVal1;
	char *szTempValName;

	ForEachInstancePin(ti, TwoPort_Pins);

	if (nets[0] && nets[1]) {
		Out_Nets(2);

		switch (cCmd_Tool)
		{
		case 'l':
		case 'p':
		case 'h':
			/* SPICEMODEL */
			if (*(val = Get_TIA(ti, SPICEMODEL)) && *val != '*') {
				sprintf(line, " %s", val);
				Data_Out(line, false);
			}
			/* VALUE */
			if (*(val = Get_TIA(ti, VALUE)) && *val != '*') {
				sprintf(line, " %s", val);
				Data_Out(line, false);
			}
			else if (*val == '*')
				errorWithInstance("Missing value attribute", ti);
			break;
		case 'a':
		case 'd':
		case 't':
			/* VALUE */
			if (*(val = Get_TIA(ti, VALUE)) && *val != '*') {
				if (!LTCSimPassParamVal(val)) {
					szTempValName = new char[strlen(val) + 2];
					strcpy(szTempValName, val);
					if (*(tVal1 = Get_TIA(ti, LVS_VALUE_DELTA)))
						sprintf(line, " %s*(1+(%s)/100)", szTempValName, tVal1);
					else
						sprintf(line, " %s", szTempValName);
					if (*(tVal = Get_TIA(ti, LVS_SHORT)) && *element == 'R' && (*tVal == 'y' || *tVal == 'Y'))
						sprintf(line, " %s", sLVSShort);
				}
				else {
					szTempValName = new char[strlen(val) + 2];
					strcpy(szTempValName, LTCSimExtParam(val));
					if (*(tVal1 = Get_TIA(ti, LVS_VALUE_DELTA)))
						sprintf(line, " %s*(1+(%s)/100)", No_Blanks(szTempValName), tVal1);
					else
						sprintf(line, " %s", No_Blanks(szTempValName));
					if (*(tVal = Get_TIA(ti, LVS_SHORT)) && *element == 'R' && (*tVal == 'y' || *tVal == 'Y'))
						sprintf(line, " %s", sLVSShort);
				}
				Data_Out(line, false);
			}
			else if (*val == '*')
				errorWithInstance("Missing value attribute", ti);
			break;
		}

		/* LVS_TYPE */
		switch (cCmd_Tool)
		{
		case 'a':
		case 'd':
			if (*(val = Get_TIA(ti, LVS_TYPE))) {
				sprintf(line, " $[%s]", val);
				Data_Out(line, true);
			}
			else {
				if (((*(tVal = Get_TIA(ti, LVS_REMOVE)) == NULL) &&
					(*(tVal1 = Get_TIA(ti, LVS_SHORT)) == NULL))) {
					errorWithInstance("Missing LVS type", ti);
				}
			}
			break;
		}

		/* CELL */
		switch (cCmd_Tool)
		{
		case 't':
			if (*(val = Get_TIA(ti, CELL))) {
				sprintf(line, " %s", val);
				Data_Out(line, true);
			}
			else {
				if (*(tVal = Get_TIA(ti, LVS_REMOVE)) == NULL){
					sprintf(line, " dummy");
					Data_Out(line, false);
				}
			}
			break;
		}

		/* DEFSUBSTRATE */
		switch (cCmd_Tool)
		{
		case 'a':
		case 'd':
		case 't':
			if (*(val = Get_TIA(ti, DEFSUBSTRATE)) && *val != '*') {
				sprintf(line, " $SUB=%s", val);
				Data_Out(line, false);
			}
			else if (*val == '?')
				errorWithInstance("Missing value", ti);
			break;
		}

		switch (cCmd_Tool)
		{
		case 'a':
		case 'd':
		case 't':
			if (!(*(val = Get_TIA(ti, LVS_REMOVE)) && (*val == 'y' || *val == 'Y'))) {
				/* WIDTH */
				if (*(val = Get_TIA(ti, WIDTH)) && *val != '*') {
					if (!LTCSimPassParamVal(val)) {
						if (bCmd_Shrink) {
							szTempValName = new char[strlen(val) + 2];
							strcpy(szTempValName, val);
							val = Get_TIA(ti, SHRINK);
							if (bCmd_IgnoreCase)
								sprintf(line, " $W=%s*%s", szTempValName, val);
							else
								sprintf(line, " $w=%s*%s", szTempValName, val);
						}
						else
							if (bCmd_IgnoreCase)
								sprintf(line, " $W=%s", val);
							else
								sprintf(line, " $w=%s", val);
					}
					else {
						szTempValName = new char[strlen(val) + 2];
						strcpy(szTempValName, LTCSimExtParam(val));
						if (bCmd_Shrink) {
							tVal = Get_TIA(ti, SHRINK);
							if (bCmd_IgnoreCase)
								sprintf(line, " $W=%s*%s", No_Blanks(szTempValName), tVal);
							else
								sprintf(line, " $w=%s*%s", No_Blanks(szTempValName), tVal);
						}
						else
							if (bCmd_IgnoreCase)
								sprintf(line, " $W=%s", No_Blanks(szTempValName));
							else
								sprintf(line, " $w=%s", No_Blanks(szTempValName));
					}
					Data_Out(line, false);
				}
				/* LENGTH */
				if (*(val = Get_TIA(ti, LENGTH)) && *val != '*') {
					if (!LTCSimPassParamVal(val)) {
						if (bCmd_Shrink) {
							szTempValName = new char[strlen(val) + 2];
							strcpy(szTempValName, val);
							val = Get_TIA(ti, SHRINK);
							if (bCmd_IgnoreCase)
								sprintf(line, " $L=%s*%s", szTempValName, val);
							else
								sprintf(line, " $l=%s*%s", szTempValName, val);
						}
						else
							if (bCmd_IgnoreCase)
								sprintf(line, " $L=%s", val);
							else
								sprintf(line, " $l=%s", val);
					}
					else {
						szTempValName = new char[strlen(val) + 2];
						strcpy(szTempValName, LTCSimExtParam(val));
						if (bCmd_Shrink) {
							tVal = Get_TIA(ti, SHRINK);
							if (bCmd_IgnoreCase)
								sprintf(line, " $L=%s*%s", No_Blanks(szTempValName), tVal);
							else
								sprintf(line, " $l=%s*%s", No_Blanks(szTempValName), tVal);
						}
						else
							if (bCmd_IgnoreCase)
								sprintf(line, " $L=%s", No_Blanks(szTempValName));
							else
								sprintf(line, " $l=%s", No_Blanks(szTempValName));
					}
					Data_Out(line, false);
				}
			}
			break;
		}
		/* MULTI */
		if (*(val = Get_TIA(ti, MULTI)) && *val != '*') {
			switch (cCmd_Tool)
			{
			case 'l':
			case 'p':
			case 'a':
			case 'd':
			case 't':
				errorWithInstance("M not supported in PSpice or Dracula", ti);
				break;
			case 'h':
				sprintf(line, " %s%s", szCmd_MultiCode, val);
				Data_Out(line, false);
				break;
			}
		}

		/* SPICELINE */
		switch (cCmd_Tool)
		{
		case 'l':
		case 'p':
		case 'h':
			if (*(val = Get_TIA(ti, SPICELINE)) && *val != '*') {
				sprintf(line, " %s", val);
				Data_Out(line, false);
			}
			if (*(val = Get_TIA(ti, SPICELINE2)) && *val != '*') {
				sprintf(line, " %s", val);
				Data_Out(line, false);
			}
			break;
		}
		/* APT LOCATION */
		switch (cCmd_Tool)
		{
		case 't':
			if (*(val = Get_TIA(ti, 254))){
				sprintf(line, " x_loc=%s y_loc=%s", LTCSimSplitXLoc(val), LTCSimSplitYLoc(val));
				Data_Out(line, true);
			}
			break;
		}
		Data_Out("\n", false);
	}
	else
		errorWithInstance("Unconnected pin", ti);
}
/*---------- Capacitor Model ----------*/

static int Capacitor_Pins(TP_PTR tp)
{
	char* name;
	TN_PTR net;
	char str1[] = "T1";
	char str1_old[] = "+";
	char str1_old2[] = "A";
	char str1_old3[] = "TP";
	char str2[] = "T2";
	char str2_old[] = "-";
	char str2_old2[] = "B";
	char str2_old3[] = "BP";
	int index;
	char* spiceorder;

	spiceorder = Get_TPA(tp, SPICEORDER);
	net = NetContainingPin(tp);
	if (bCmd_Flat && net) net = FindNetRoot(net);
	name = Get_TPA(tp, NAME);

	if ((strcmp(name, str1) == 0) || (strcmp(name, str2) == 0)) {
		if ((strcmp(name, str1) == 0))
			nets[0] = net;
		if ((strcmp(name, str2) == 0))
			nets[1] = net;
	}
	else {
		if ((strcmp(name, str1_old) == 0) || (strcmp(name, str2_old) == 0)) {
			if ((strcmp(name, str1_old) == 0))
				nets[0] = net;
			if ((strcmp(name, str2_old) == 0))
				nets[1] = net;
		}
		else {
			if ((strcmp(name, str1_old2) == 0) || (strcmp(name, str2_old2) == 0)) {
				if ((strcmp(name, str1_old2) == 0))
					nets[0] = net;
				if ((strcmp(name, str2_old2) == 0))
					nets[1] = net;
			}
			else {
				if ((strcmp(name, str1_old3) == 0) || (strcmp(name, str2_old3) == 0)) {
					if ((strcmp(name, str1_old3) == 0))
						nets[0] = net;
					if ((strcmp(name, str2_old3) == 0))
						nets[1] = net;
				}
				else {
					if (*spiceorder != '\0') {
						index = atoi(spiceorder);
						nets[index - 1] = net;
					}
				}
			}
		}
	}
	return(0);
}

/* Prefix = C - Capacitor */
static void Capacitor()
{
	char *val;
	char *szTempValName;
	bool bSimPrimitive = true;
	char szSpiceModel[256];
	char *tVal;
	char *tVal1;
	char szTemp[256];
	//CString sTemp;
	String^ sTemp;
	LTCUtils ltcUtility;

	char szVal[256];
	char szShrink[256];

	ForEachInstancePin(ti, Capacitor_Pins);

	if (nets[0] && nets[1]) {
		Out_Nets(2);

		switch (cCmd_Tool)
		{
		case 'l':
		case 'p':
		case 'h':
			if (*(val = Get_TIA(ti, SIM_LEVEL))) {
				if ((*val == 'N') || (*val == 'n') || (*val == '0'))
					bSimPrimitive = true;
				else
					bSimPrimitive = false;
			}
			else
				bSimPrimitive = true;
			/* SPICEMODEL */
			if (*(val = Get_TIA(ti, SPICEMODEL)) && *val != '*')
			{
				//strcpy( szTemp, val );
				//sTemp = CString( szTemp );
				sTemp = ltcUtility.LtcCharsToString(val);
				//if( !bCmd_IgnoreCase ) sTemp.MakeLower();
				if (!bCmd_IgnoreCase) sTemp->ToLower();
				if (bSimPrimitive)
					//sprintf( line, " %s", sTemp.GetBuffer() );
					sprintf(line, " %s", ltcUtility.LtcStringToChars(sTemp));
				else {
					//strcpy(szSpiceModel, sTemp.GetBuffer());
					strcpy(szSpiceModel, ltcUtility.LtcStringToChars(sTemp));
					if (*(val = Get_TIA(ti, SIM_LEVEL)))
					{
						//strcpy( szTemp, val );
						//sTemp = CString( szTemp );
						sTemp = ltcUtility.LtcCharsToString(val);
						//if( !bCmd_IgnoreCase ) sTemp.MakeLower();
						if (!bCmd_IgnoreCase) sTemp->ToLower();
						//sprintf(line, " %s%s", szSpiceModel, sTemp.GetBuffer());
						sprintf(line, " %s%s", szSpiceModel, ltcUtility.LtcStringToChars(sTemp));
					}
					else
						sprintf(line, " %s", szSpiceModel);
				}
				Data_Out(line, false);
			}
			break;
		}

		/* VALUE */
		if ((*(val = Get_TIA(ti, VALUE)) && *val != '*') && bSimPrimitive) {
			if (!LTCSimPassParamVal(val)) {
				if (bCmd_Shrink) {
					strcpy(szVal, val);
					val = Get_TIA(ti, SHRINK);
					strcpy(szShrink, val);
					switch (cCmd_Tool)
					{
					case 'l':
					case 'p':
						sprintf(line, " {%s*(%s*%s)}", szVal, szShrink, szShrink);
						break;
					case 'h':
						sprintf(line, " '%s*(%s*%s)'", szVal, szShrink, szShrink);
						break;
					case 'a':
					case 'd':
					case 't':
						if (*(tVal1 = Get_TIA(ti, LVS_VALUE_DELTA)))
							sprintf(line, " %s*%s*%s*(1+(%s)/100)", szVal, szShrink, szShrink, tVal1);
						else
							sprintf(line, " %s*%s*%s", szVal, szShrink, szShrink);
						break;
					}
				}
				else {
					strcpy(szVal, val);
					switch (cCmd_Tool)
					{
					case 'l':
					case 'p':
					case 'h':
						sprintf(line, " %s", szVal);
						break;
					case 'a':
					case 'd':
					case 't':
						if (*(tVal1 = Get_TIA(ti, LVS_VALUE_DELTA)))
							sprintf(line, " %s*(1+(%s)/100)", LTCSimReplacePFByP(szVal), tVal1);
						else
							sprintf(line, " %s", LTCSimReplacePFByP(szVal));
						break;
					}
				}
			}
			else {
				szTempValName = new char[strlen(val) + 2];
				strcpy(szTempValName, LTCSimExtParam(val));
				if (bCmd_Shrink) {
					val = Get_TIA(ti, SHRINK);
					switch (cCmd_Tool)
					{
					case 'l':
					case 'p':
						sprintf(line, " {%s*(%s*%s)}", No_Blanks(szTempValName), val, val);
						break;
					case 'h':
						sprintf(line, " '%s*(%s*%s)'", No_Blanks(szTempValName), val, val);
						break;
					case 'a':
					case 'd':
					case 't':
						if (*(tVal1 = Get_TIA(ti, LVS_VALUE_DELTA)))
							sprintf(line, " %s*%s*%s*(1+(%s)/100)", No_Blanks(szTempValName), val, val, tVal1);
						else
							sprintf(line, " %s*%s*%s", No_Blanks(szTempValName), val, val);
						break;
					}
				}
				else {
					switch (cCmd_Tool)
					{
					case 'l':
					case 'p':
						sprintf(line, " {%s}", No_Blanks(szTempValName));
						break;
					case 'h':
						sprintf(line, " '%s'", No_Blanks(szTempValName));
						break;
					case 'a':
					case 'd':
					case 't':
						sprintf(line, " %s", No_Blanks(szTempValName));
						break;
					}
				}
			}
			Data_Out(line, false);
		}
		else if (*val == '*')
			errorWithInstance("Missing value", ti);

		/* LVS_TYPE */
		switch (cCmd_Tool)
		{
		case 'a':
		case 'd':
			if ((*(val = Get_TIA(ti, LVS_TYPE))) && bSimPrimitive)
			{
				//strcpy( szTemp, val );
				//sTemp = CString( szTemp );
				sTemp = ltcUtility.LtcCharsToString(val);
				//if( !bCmd_IgnoreCase ) sTemp.MakeLower();
				if (!bCmd_IgnoreCase) sTemp->ToLower();
				//sprintf( line, " $[%s]", sTemp.GetBuffer());
				sprintf(line, " $[%s]", ltcUtility.LtcStringToChars(sTemp));
				Data_Out(line, true);
			}
			else {
				if (*(tVal = Get_TIA(ti, LVS_REMOVE)) == NULL)
					errorWithInstance("Missing LVS type", ti);
			}
			break;
		}

		/* CELL */
		switch (cCmd_Tool)
		{
		case 't':
			if ((*(val = Get_TIA(ti, CELL))) && bSimPrimitive)
			{
				//strcpy( szTemp, val );
				//sTemp = CString( szTemp );
				sTemp = ltcUtility.LtcCharsToString(val);
				//if( !bCmd_IgnoreCase ) sTemp.MakeLower();
				if (!bCmd_IgnoreCase) sTemp->ToLower();
				//sprintf(line, " %s", sTemp.GetBuffer());
				sprintf(line, " %s", ltcUtility.LtcStringToChars(sTemp));
				Data_Out(line, true);
			}
			else {
				if (*(tVal = Get_TIA(ti, LVS_REMOVE)) == NULL){
					/*      errorWithInstance("Missing CELL attribute" , ti ); */
					sprintf(line, " dummy");
					Data_Out(line, false);
				}
			}
			break;
		}

		/* SPICELINE */
		switch (cCmd_Tool)
		{
		case 'l':
		case 'p':
		case 'h':
			if ((*(val = Get_TIA(ti, SPICELINE)) && *val != '*') && bSimPrimitive)
			{
				//strcpy( szTemp, val );
				//sTemp = CString( szTemp );
				sTemp = ltcUtility.LtcCharsToString(val);
				//if( !bCmd_IgnoreCase ) sTemp.MakeLower();
				if (!bCmd_IgnoreCase) sTemp->ToLower();
				//sprintf( line, " %s", sTemp.GetBuffer() );
				sprintf(line, " %s", ltcUtility.LtcStringToChars(sTemp));
				Data_Out(line, false);
			}
			break;
		}

		/* DEFSUBSTRATE */
		switch (cCmd_Tool)
		{
		case 'a':
		case 'd':
			if ((*(val = Get_TIA(ti, DEFSUBSTRATE))) && bSimPrimitive)
			{
				//strcpy( szTemp, val );
				//sTemp = CString( szTemp );
				sTemp = ltcUtility.LtcCharsToString(val);
				//if( !bCmd_IgnoreCase ) sTemp.MakeLower();
				if (!bCmd_IgnoreCase) sTemp->ToLower();
				//sprintf(line, " $sub=%s", sTemp.GetBuffer());
				sprintf(line, " $sub=%s", ltcUtility.LtcStringToChars(sTemp));
				Data_Out(line, false);
			}
			break;
		}

		/* SPICELINE3 */
		if ((*(val = Get_TIA(ti, SPICELINE3))) && !(bSimPrimitive))
		{
			//strcpy( szTemp, val );
			//sTemp = CString( szTemp );
			sTemp = ltcUtility.LtcCharsToString(val);
			//if( !bCmd_IgnoreCase ) sTemp.MakeLower();
			if (!bCmd_IgnoreCase) sTemp->ToLower();
			switch (cCmd_Tool)
			{
			case 'l':
			case 'p':
				//sprintf( line, " params: %s", sTemp.GetBuffer() );
				sprintf(line, " params: %s", ltcUtility.LtcStringToChars(sTemp));
				break;
			case 'h':
			case 'a':
			case 'd':
			case 't':
				//sprintf( line, " %s", sTemp.GetBuffer() );
				sprintf(line, " %s", ltcUtility.LtcStringToChars(sTemp));
				break;
			}
		}
		/* APT LOCATION */
		switch (cCmd_Tool)
		{
		case 't':
			if (*(val = Get_TIA(ti, 254)))
			{
				sprintf(line, " x_loc=%s y_loc=%s", LTCSimSplitXLoc(val), LTCSimSplitYLoc(val));
				Data_Out(line, true);
			}
			break;
		}
		Data_Out("\n", false);
	}
	else
		errorWithInstance("Unconnected pin", ti);
	ltcUtility.~LTCUtils();
}


/*---------- SubCiruit ----------*/

#define MAX_PINS 512
static TP_PTR pins[MAX_PINS];
static int order_pins, pin_count;

static int SubCircuit_Pins(TP_PTR tp)
{
	int index;
	char* spiceorder;

	spiceorder = Get_TPA(tp, SPICEORDER);
	if (!pin_count) /* first pin determines whether order is required */
		order_pins = *spiceorder != '\0';
	else if (order_pins != (*spiceorder != '\0'))
		order_pins = -1; /* some pins have order, some don't */
	if (order_pins == 0)
		pins[pin_count++] = tp;
	else if (order_pins == 1) {
		index = atoi(spiceorder);
		if (index < 0 || index >= MAX_PINS)
			order_pins = -2;
		else {
			/* bus pins will all have the same number so look for the next slot */
			while (pins[index] && index < MAX_PINS - 1) index++; /* bus pin? */
			pins[index] = tp;
			pin_count++;
		}
	}
	return(order_pins < 0);
}

/* Prefix = X */
static void SubCircuit()
{
	TD_PTR td;
	TN_PTR net;
	int ii;
	long templ;
	char *name, *val;
	char *sim_level;
	char szSpiceModel[256];

	char instname[256];
	char *szIllegalChar;
	String ^sTemp;
	LTCUtils ltcUtility;

	strcpy(instname, inst);
	while (szIllegalChar = strpbrk(instname, ".-[]()<>{}")) {
		*szIllegalChar = '_';
	}

	/* either all or none of the pins must have SPICEORDER specified */
	for (ii = 0; ii < MAX_PINS; ii++) pins[ii] = 0;
	pin_count = 0;
	order_pins = 0;
	ForEachInstancePin(ti, SubCircuit_Pins);
	td = DescriptorOfInstance(ti);
	if (order_pins == -1) {
		sprintf(line, "Some pins on type = %s do not have spice order specified", Get_TDA(td, NAME));
		Error_Out(line);
	}
	else if (order_pins == -2) {
		sprintf(line, "Incorrect pin ordering on type = %s", Get_TDA(td, NAME));
		Error_Out(line);
	}
	else {
		//CString sInstName, sElement;
		String^ sInstName;
		String^ sElement;
		char szTemp[256];

		//strcpy( szTemp, instname );
		//sInstName = CString( szTemp );
		sInstName = ltcUtility.LtcCharsToString(instname);
		//if( !bCmd_IgnoreCase ) sInstName.MakeLower();
		if (!bCmd_IgnoreCase) sInstName->ToLower();
		//strcpy( szTemp, element );
		//sElement = CString( szTemp );
		sElement = ltcUtility.LtcCharsToString(element);
		//if( !bCmd_IgnoreCase ) sElement.MakeLower();
		if (!bCmd_IgnoreCase) sElement->ToLower();

		if (bCmd_FilterPrefix && *element == *inst)
		{
			switch (cCmd_Tool)
			{
			case 'l':
			case 'p':
			case 'h':
				//sprintf( line, "%s", sInstName.GetBuffer() );
				sprintf(line, "%s", ltcUtility.LtcStringToChars(sInstName));
				// sprintf( line, "%s", instname );
				break;
			case 'a':
			case 'd':
			case 't':
				if (*(val = Get_TIA(ti, LVS_REMOVE)) && *val == 'y' || *val == 'Y')
					//sprintf(line, "*%s", sInstName.GetBuffer() );
					sprintf(line, "*%s", ltcUtility.LtcStringToChars(sInstName));
				else
					//sprintf(line, "%s", sInstName.GetBuffer() );
					sprintf(line, "%s", ltcUtility.LtcStringToChars(sInstName));
				break;
			}
		}
		else {
			switch (cCmd_Tool)
			{
			case 'l':
			case 'p':
			case 'h':
				//sprintf(line, "%s%s", sElement.GetBuffer(), sInstName.GetBuffer() );
				sprintf(line, "%s%s", ltcUtility.LtcStringToChars(sElement), ltcUtility.LtcStringToChars(sInstName));
				break;
			case 'a':
			case 'd':
			case 't':
				if (*(val = Get_TIA(ti, LVS_REMOVE)) && *val == 'y' || *val == 'Y')
					//sprintf( line, "*%s%s", sElement.GetBuffer(), sInstName.GetBuffer() );
					sprintf(line, "*%s%s", ltcUtility.LtcStringToChars(sElement), ltcUtility.LtcStringToChars(sInstName));
				else
					//sprintf(line, "%s%s", sElement.GetBuffer(), sInstName.GetBuffer() );
					sprintf(line, "%s%s", ltcUtility.LtcStringToChars(sElement), ltcUtility.LtcStringToChars(sInstName));
				break;
			}
		}
		Data_Out(line, false);
		if (*element == 'U') {
			if (!*(name = Get_TIA(ti, SPICEMODEL)))
				name = Get_TDA(td, NAME);
			//strcpy( szTemp, name );
			//CString sTemp = CString( szTemp );
			sTemp = ltcUtility.LtcCharsToString(name);
			//if( !bCmd_IgnoreCase ) sTemp.MakeLower();
			if (!bCmd_IgnoreCase) sTemp->ToLower();
			//sprintf( line, " %s", sTemp.GetBuffer() );
			sprintf(line, " %s", ltcUtility.LtcStringToChars(sTemp));
			// sprintf( line, " %s", name );
			if (*(sim_level = Get_TIA(ti, SIM_LEVEL)))
			{
				//strcpy( szTemp, sim_level );
				//sTemp = CString( szTemp );
				sTemp = ltcUtility.LtcCharsToString(sim_level);
				//if( !bCmd_IgnoreCase ) sTemp.MakeLower();
				if (!bCmd_IgnoreCase) sTemp->ToLower();
				//sprintf( line, "%s%s", line, sTemp.GetBuffer());
				sprintf(line, "%s%s", line, ltcUtility.LtcStringToChars(sTemp));
				// sprintf( line, "%s%s", line, sim_level);
			}
			Data_Out(line, false);
		}
		for (ii = 0; pin_count > 0; ii++) {
			if (pins[ii]) {
				pin_count--;
				net = NetContainingPin(pins[ii]);
				if (bCmd_Flat && net) net = FindNetRoot(net);
				if (net) templ = Get_Net_Number(net);
				else templ = num_unconn++;
				if (bCmd_Node_Names && !net)
					sprintf(line, " unc%ld", templ);
				else if (bCmd_Node_Names && (name = Get_Spice_Net_Name(net)))
				{
					//CString sTemp;
					//char *szTemp = new char[256];
					//strcpy( szTemp, name );
					///sTemp = CString(szTemp);
					sTemp = ltcUtility.LtcCharsToString(name);
					//if( !bCmd_IgnoreCase ) sTemp.MakeLower();
					//if (!bCmd_IgnoreCase) sTemp->ToLower();
					//sprintf( line, " %s", sTemp.GetBuffer() );
					sprintf(line, " %s", ltcUtility.LtcStringToChars(sTemp));
					// sprintf( line, " %s", name );
				}
				else
					sprintf(line, " %ld", templ);
				Data_Out(line, false);
			}
		}
		/* XDef_Tub */
		if (*(val = Get_TIA(ti, XDEF_TUB)))
			Out_XDef_Tub_Net();


		/* XDef_Sub */
		if (*(val = Get_TIA(ti, XDEF_SUB)))
			Out_XDef_Net();

		if (*element == 'X') {
			/* SPICEMODEL */
			if (!*(name = Get_TIA(ti, SPICEMODEL)))
				name = Get_TDA(td, NAME);
			//CString sTemp;
			// char szTemp[256];
			//strcpy( szTemp, name );
			//sTemp = CString( szTemp );
			sTemp = ltcUtility.LtcCharsToString(name);
			//if( !bCmd_IgnoreCase ) sTemp.MakeLower();
			if (!bCmd_IgnoreCase) sTemp->ToLower();
			//sprintf( szSpiceModel, "%s", sTemp.GetBuffer() );
			sprintf(szSpiceModel, "%s", ltcUtility.LtcStringToChars(sTemp));
			// sprintf( szSpiceModel, "%s", name );
			switch (cCmd_Tool)
			{
			case 'l':
			case 'p':
			case 'h':
				if (*(val = Get_TIA(ti, SIM_LEVEL))) {
					if ((*val == 'N') || (*val == 'n') || (*val == '0'))
						sprintf(line, " %s", szSpiceModel);
					else
						sprintf(line, " %s%s", szSpiceModel, val);
				}
				else
					sprintf(line, " %s", szSpiceModel);
				break;
			case 'a':
			case 'd':
			case 't':
				if (*(val = Get_TIA(ti, LVS_LEVEL))) {
					if ((*val == 'N') || (*val == 'n') || (*val == '0'))
						sprintf(line, " %s", szSpiceModel);
					else
						sprintf(line, " %s%s", szSpiceModel, val);
				}
				else
					sprintf(line, " %s", szSpiceModel);
				break;
			}
			Data_Out(line, false);
			/* SPICELINE */
			if (*(val = Get_TIA(ti, SPICELINE)) && *val != '*') {
				//strcpy( szTemp, val );
				//sTemp = CString( szTemp );
				sTemp = ltcUtility.LtcCharsToString(val);
				//if( !bCmd_IgnoreCase ) sTemp.MakeLower();
				if (!bCmd_IgnoreCase) sTemp->ToLower();
				switch (cCmd_Tool)
				{
				case 'l':
				case 'p':
					//sprintf( line, " params: %s", sTemp.GetBuffer() );
					sprintf(line, " params: %s", ltcUtility.LtcStringToChars(sTemp));
					// sprintf( line, " params: %s", val );
					break;
				case 'h':
				case 'a':
				case 'd':
				case 't':
					//sprintf( line, " %s", sTemp.GetBuffer() );
					sprintf(line, " %s", ltcUtility.LtcStringToChars(sTemp));
					// sprintf( line, " %s", val );
					break;
				}
				Data_Out(line, false);
			}
			/* APT LOCATION */
			switch (cCmd_Tool)
			{
			case 't':
				if (*(val = Get_TIA(ti, 254))){
					sprintf(line, " x_loc=%s y_loc=%s", LTCSimSplitXLoc(val), LTCSimSplitYLoc(val));
					Data_Out(line, true);
				}
				break;
			}
		}
		Data_Out("\n", false);
	}
	ltcUtility.~LTCUtils();
}
/*---------- Dummy Routine for unspecified prefix's ----------*/

static void Dummy()
{
	TD_PTR td;
	char* prefix;
	td = DescriptorOfInstance(ti);
	prefix = Get_TDA(td, PREFIX);

	/* Don't put this message out any more than necessary, keep the file small */
	if (*prefix != *element) { /* instance override..Why did user do this?? */
		sprintf(line, "Invalid prefix on element %s%s",
			bCmd_Flat ? "I = ." : "",
			bCmd_Flat ? InstanceName(ti) :
			LocalInstanceName(ti));
		Error_Out(line);
	}
	else if (ti == FirstInstanceOf(td)) { /* only one error per type */
		sprintf(line, "Invalid prefix on symbol type = %s",
			Get_TDA(td, NAME));
		Error_Out(line);
	}
}

/* Prefix = B - MESFET, M - MOSFET */
static void CacheFETTransNames()
{
	ForEachInstancePin(ti, FET_Pins);

	if (nets[0] && nets[1] && nets[2]) {
		//Out_Nets( 4 );
		//if ( !nets[3] ) Out_Def_Net();
		Add_Names_To_Flat_Cache(4);
	}
}

/* Prefix = J - JFET */
static void CacheJFETTransNames()
{
	ForEachInstancePin(ti, JFET_Pins);

	if (nets[0] && nets[1] && nets[2]) {
		//Out_Nets( 4 );
		//if ( !nets[3] ) Out_Def_Net();
		Add_Names_To_Flat_Cache(4);
	}
}

static void CacheDummyNames()
{
	; //No-op
}

/* Prefix = L - Inductor, R - Resistor */
static void CacheTwoPortNames()
{
	ForEachInstancePin(ti, TwoPort_Pins);

	if (nets[0] && nets[1]) {
		//Out_Nets( 2 );
		Add_Names_To_Flat_Cache(2);
	}
}

/* Prefix = C - Capacitor */
static void CacheCapacitorNames()
{
	ForEachInstancePin(ti, Capacitor_Pins);

	if (nets[0] && nets[1]) {
		//Out_Nets( 2 );
		Add_Names_To_Flat_Cache(2);
	}
}

/* Prefix = D */
static void CacheDiodeNames()
{
	ForEachInstancePin(ti, Diode_Pins);

	if (nets[0] && nets[1]) {
		//Out_Nets( 2 );
		Add_Names_To_Flat_Cache(2);
	}
}

/* Prefix = E - Voltage Controlled Voltage, G - Voltage Controlled Current */
static void CacheVControlSrcNames()
{
	ForEachInstancePin(ti, V_Control_Source_Pins);

	if (nets[0] && nets[1] && nets[2] && nets[3]) {
		//Out_Nets( 4 );
		Add_Names_To_Flat_Cache(4);
	}
}

/* Prefix = I - Independent Current Source, V - Independent Voltage Source */
static void CacheIndSourceNames()
{
	ForEachInstancePin(ti, Ind_Source_Pins);

	if (nets[0] && nets[1]) {
		//Out_Nets( 2 );
		Add_Names_To_Flat_Cache(2);
	}
}

/* Prefix = Q */
static void CacheBipolarTransNames()
{
	ForEachInstancePin(ti, Bipolar_Pins);

	if (nets[0] && nets[1] && nets[2]) {
		//Out_Nets( 4 );
		//if ( !nets[3] ) Out_Def_Net();
		Add_Names_To_Flat_Cache(4);
	}
}

/* Prefix = T */
static void CacheTransLineNames()
{
	ForEachInstancePin(ti, XLine_Pins);

	if (nets[0] && nets[1] && nets[2] && nets[3]) {
		//Out_Nets( 4 );
		Add_Names_To_Flat_Cache(4);
	}
}

/* Prefix = X */
static void CacheSubCircuitNames()
{
	; //No-op - this shouldn't be called because only flat spice netlists
	//would cache names and flat netlists, by definition, won't have subcircuits
}

static void(*Primitive[])() =
{
	Dummy, /* A -                                     */
	FET_Transistor, /* B - MESFET Device                       */
	Capacitor, /* C - Capacitor                           */
	Diode, /* D - Diode Device                        */
	V_Control_Source, /* E - Voltage Controlled - Voltage Source */
	Dummy, /* F - Current Controlled - Current Source */
	V_Control_Source, /* G - Voltage Controlled - Current Source */
	Dummy, /* H - Current Controlled - Voltage Source */
	Independent_Source, /* I - Independent Current Source          */
	JFET_Transistor, /* J - JFET Device                         */
	Dummy, /* K - Mutual Inductor                     */
	TwoPort, /* L - Inductor                            */
	FET_Transistor, /* M - MOSFET Device                       */
	Dummy, /* N -                                     */
	Dummy, /* O -                                     */
	Dummy, /* P -                                     */
	Bipolar_Transistor, /* Q - BJT - Bipolar Junction Device       */
	TwoPort, /* R - Resistor                            */
	Dummy, /* S - Switch Device                       */
	Transmission_Line, /* T - Transmission Line                   */
	Dummy, /* U - Uniform Distributed RC Line         */
	Independent_Source, /* V - Independent Voltage Source          */
	Dummy, /* W -                                     */
	SubCircuit, /* X - Sub Circuit Call                    */
	Dummy, /* Y -                                     */
	Dummy /* Z -                                     */
};

static void(*FlatNameCache[])() =
{
	CacheDummyNames, /* A -                                     */
	CacheFETTransNames, /* B - MESFET Device                       */
	CacheCapacitorNames, /* C - Capacitor                           */
	CacheDiodeNames, /* D - Diode Device                        */
	CacheVControlSrcNames, /* E - Voltage Controlled - Voltage Source */
	CacheDummyNames, /* F - Current Controlled - Current Source */
	CacheVControlSrcNames, /* G - Voltage Controlled - Current Source */
	CacheDummyNames, /* H - Current Controlled - Voltage Source */
	CacheIndSourceNames, /* I - Independent Current Source          */
	CacheJFETTransNames, /* J - JFET Device                         */
	CacheDummyNames, /* K - Mutual Inductor                     */
	CacheTwoPortNames, /* L - Inductor                            */
	CacheFETTransNames, /* M - MOSFET Device                       */
	CacheDummyNames, /* N -                                     */
	CacheDummyNames, /* O -                                     */
	CacheDummyNames, /* P -                                     */
	CacheBipolarTransNames, /* Q - BJT - Bipolar Junction Device       */
	CacheTwoPortNames, /* R - Resistor                            */
	CacheDummyNames, /* S - Switch Device                       */
	CacheTransLineNames, /* T - Transmission Line                   */
	CacheDummyNames, /* U - Uniform Distributed RC Line         */
	CacheIndSourceNames, /* V - Independent Voltage Source          */
	CacheDummyNames, /* W -                                     */
	CacheSubCircuitNames, /* X - Sub Circuit Call                    */
	CacheDummyNames, /* Y -                                     */
	CacheDummyNames /* Z -                                     */
};

int Do_Primitive(TI_PTR tii, char *prefix)
{
	int index, ii;

	/* Do_Primitive is for the Hierarchical Format ( bCmd_Flat == FALSE ) */
	for (ii = 0; ii < MAX_NETS; ii++) nets[ii] = 0;
	ti = tii; /* ti pointer and element placed in statics for all to use */
	//strcpy_s(element, sizeof(element), prefix);
	element = prefix;
	inst = LocalInstanceName(ti);
	index = *element - 'A';
	if (index >= 0 && index <= 25) {
		switch (cCmd_Tool)
		{
		case 'l':
		case 'p':
			char ch = '\0';
			char *val;
			if (bCmd_MixedSignal) {
				if (*(val = Get_TIA(ti, DIGITAL_EXTRACT))) {
					ch = toupper(*val);
					if (ch == 'Y')
						bDigitalMode = true;
					else
						bDigitalMode = false;
				}
			}
			break;
		}
		Primitive[index]();
	}
	else
		Dummy();
	return(0);
}

static int Is_Valid_Prefix(char prefix)
{
	int index, retn = FALSE;
	index = prefix - 'A';
	if (index >= 0 && index <= 25 && Primitive[index] != Dummy) retn = TRUE;
	return(retn);
}

int Code_Primitives(TI_PTR ti_prim)
{
	int index, ii;
	char* prefix;
	TD_PTR td;

	/* Code_Primitives is for the Flattened Format ( bCmd_Flat == TRUE ) */
	for (ii = 0; ii < MAX_NETS; ii++) nets[ii] = 0;
	ti = ti_prim; /* ti pointer and element placed in statics for all to use */
	if (*(prefix = Get_TIA(ti, PREFIX)) && Is_Valid_Prefix(*prefix)) {
		index = toupper(*prefix) - 'A';
		sprintf(elembuf, "%c%ld", *prefix, InstanceNumber(ti_prim));
		element = elembuf;
		Primitive[index]();
	}
	else { /* Only print errors once for each type of symbol */
		td = DescriptorOfInstance(ti_prim);
		if (ti == FirstInstanceOf(td)) {
			sprintf(line, "Error: Missing or invalid prefix code on symbol type = %s",
				Get_TDA(td, NAME));
			Error_Out(line);
		}
	}
	return(0);
}

int Cache_Flat_Underscored_Names(TI_PTR ti_prim)
{
	int index, ii;
	char* prefix;

	/* Code_Primitives is for the Flattened Format ( bCmd_Flat == TRUE ) */
	for (ii = 0; ii < MAX_NETS; ii++) nets[ii] = 0;
	ti = ti_prim; /* ti pointer and element placed in statics for all to use */
	if (*(prefix = Get_TIA(ti, PREFIX)) && Is_Valid_Prefix(*prefix)) {
		index = toupper(*prefix) - 'A';
		sprintf(elembuf, "%c%ld", *prefix, InstanceNumber(ti_prim));
		element = elembuf;
		FlatNameCache[index]();
	}
	return(0);
}

void Add_Names_To_Flat_Cache(int nCount)
{
	for (int ii = 0; ii < nCount; ii++) {
		if (nets[ii]) {
			char* name;
			if (bCmd_Node_Names && (name = NetName(nets[ii]))) {
				sprintf(line, " %s", name);

				char *szResult;
				if (*name == '.')
					szResult = strpbrk(name, "-");

				if ((*name != '.' && strpbrk(name, "_")) ||
					(*name == '.' && strpbrk(szResult, "_"))) {
					bool bNameAlreadyInCache = false;
					char *szIllegalChar;
					while (szIllegalChar = strpbrk(name, ".-"))
						*szIllegalChar = '_';

					for (int i = 0; i < nMaxIndexCount; i++) {
						if (!_stricmp(name, UnderscoreNameCache[i])) {
							bNameAlreadyInCache = true;
							break;
						}
					}

					if (!bNameAlreadyInCache) {
						if (UnderscoreNameCache == NULL)
							UnderscoreNameCache = new char*[nMaxCachedItems];
						else if (nMaxIndexCount == nMaxCachedItems) {
							char **y = new char*[nMaxCachedItems * 2];
							for (int i = 0; i < nMaxCachedItems; i++) {
								*(y + i) = *(UnderscoreNameCache + i);
							}
							delete UnderscoreNameCache;
							UnderscoreNameCache = y;
							nMaxCachedItems *= 2;
						}

						char *pszTemp = new char[strlen(name) + 1];
						strcpy(pszTemp, name);
						*(UnderscoreNameCache + nMaxIndexCount) = pszTemp;
						nMaxIndexCount++;
					}
				}
			}
		}
	}
}





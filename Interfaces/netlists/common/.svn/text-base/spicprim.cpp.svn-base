#include <stdafx.h>
#include "pikproc.h"
#include "dataout.h"


extern int bCmd_Node_Names, bCmd_Flat, bCmd_Units, bCmd_Use_Globals;
extern int bCmd_XGNDXto0;
extern int bCmd_GNDto0;
extern int bCmd_FilterPrefix;
extern int bCmd_LVS;
extern int bCmd_Shrink;
extern int bCmd_WLBip;
extern int bCmd_AreaBip;
extern int bCmd_MixedSignal;
extern char szCmd_MultiCode[];
extern long num_unconn;
char **SubCircuitNames = NULL;
char ***SubCircuits = NULL;
int **SubCircuitMaxIndexCount;
char *szCurrentSubCircuitName = NULL;
int nMaxSubCircuitIndexCount = 0;

char **UnderscoreNameCache = NULL;
extern int nMaxCachedItems;
int nMaxIndexCount = 0;

char *szNewName = NULL;

char pattern[256];
bool bParamPass = false;
char sTclTxt[256];

#define MAX_NETS 4
static char *inst, *element, elembuf[20];
static TI_PTR ti;
static TN_PTR nets[MAX_NETS];

long Get_Net_Number( TN_PTR );
void Add_Names_To_Flat_Cache(int);

static char net_name[256];

#if defined(PSPICE)
extern long num_globals;
bool bDigitalMode = false;
#endif // PSPICE

extern FILE *errorFile;

extern Tcl_Interp *interp;

/* Determine full path to instance.
 * This is done when InstanceName() won't work
 * because we're in a block scan
 */
char *determineFullInstPath( TI_PTR ti )
{
	static char instPath[256];
	char buf[256];
	buf[0] = '\0';
	TI_PTR myTi;
	TD_PTR myTd;
	int makingPath = TRUE;
	if( !bCmd_Flat ){		
		// Back-trace the instance path manually.
		// We'll make a path for example instance.
		myTi = ti;
		strcpy( instPath, Get_TIA( myTi, NAME ));
		while( makingPath ){	
			if( myTd = OwnerOfInstance( myTi )){
				if( myTi = FirstInstanceOf( myTd )){
					sprintf( buf, "%s.%s", Get_TIA( myTi, NAME ), instPath );
					strcpy( instPath, buf );
				}
			}
			else
				makingPath = FALSE;
		}
	}
	else // flat netlist
		strcpy( instPath, InstanceName( ti ));
	return( instPath );
}

void errorWithInstance( char *string, TI_PTR ti )
{
  sprintf( line, "%s Inst = %s",
	   string, determineFullInstPath( ti ));
  Error_Out( line );
}

/* --------- LTC clean blanks ----------*/

char* No_Blanks( char* string )
{
	char szNewString[256];
	char szTempString[256];
	int iLength,i,j;

	strcpy(szTempString,string);
	iLength = strlen(szTempString);
	j = 0;
	for (i = 0; i < iLength; i++){
		if ( szTempString[i] != ' ' ){
			szNewString[j] = szTempString[i];
			j++;
		}
	}
	szNewString[j] = '\0';
	strcpy( string , szNewString );
	return string;
}

bool LTCSimPassParamVal( char *value )
{
	sprintf( pattern, "{([^}]*)}" );
	strcpy( sTclTxt, value  );
	int idx = Tcl_RegExpMatch( interp, sTclTxt, pattern );
	if ( idx > 0 )
		return( true );
	else
		return( false );
}

char *LTCSimExtParam( char *value )
{
	char *sReturn;
	char command[256];

	sReturn = new char[strlen(value) + 10];
	// Trim spaces
	Tcl_SetVar( interp, "var", value, 0 );
	sprintf( command, "string trim $var" );
	Tcl_Eval( interp, command );
	strcpy( sTclTxt, Tcl_GetVar( interp, "var", 0 ));
	// Remove {} if found
	sprintf( pattern, "{([^}]*)}" );
	Tcl_SetVar( interp, "pattern", pattern, 0 );
	sprintf( command, "regexp  $pattern $var match value" );
	Tcl_Eval( interp, command );
	strcpy( sTclTxt, Tcl_GetVar( interp, "value", 0 ));
	strcpy( sReturn, sTclTxt );
	return( sReturn );
}

char *LTCSimReplacePFByP( char *value )
{
	char *sReturn;
	char command[256];

	sReturn = new char[strlen(value) + 10];
	// Trim spaces
	Tcl_SetVar( interp, "var", value, 0 );
	sprintf( command, "string trim $var" );
	Tcl_Eval( interp, command );
	strcpy( sTclTxt, Tcl_GetVar( interp, "var", 0 ));
	// Find if ends in pf
	sprintf( pattern, "(P|p)(f|F)$" );
	Tcl_SetVar( interp, "pattern", pattern, 0 );
	sprintf( command, "regsub  (p|P)(f|F)$ $var p value" );
	Tcl_Eval( interp, command );
	strcpy( sTclTxt, Tcl_GetVar( interp, "value", 0 ));
	strcpy( sReturn, sTclTxt );
	return( sReturn );
}

char *LTCSimSplitXLoc( char *value )
{
	char *sReturn;
	char command[256];

	sReturn = new char[strlen( value )];
	// Trim spaces
	Tcl_SetVar( interp, "var", value, 0 );
	sprintf( command, "string trim $var" );
	Tcl_Eval( interp, command );
	sprintf( pattern, "(.*),(.*)" );
	Tcl_SetVar( interp, "pattern", pattern, 0 );
	sprintf( command, "regexp {(.*),(.*)} $var match value1 value2" );
	Tcl_Eval( interp, command );
	strcpy( sTclTxt, Tcl_GetVar( interp, "value1", 0 ));
	strcpy( sReturn, sTclTxt );
	return( sReturn );
}

char *LTCSimSplitYLoc( char *value )
{
	char *sReturn;
	char command[256];

	sReturn = new char[strlen( value )];
	// Trim spaces
	Tcl_SetVar( interp, "var", value, 0 );
	sprintf( command, "string trim $var" );
	Tcl_Eval( interp, command );
	sprintf( pattern, "(.*),(.*)" );
	Tcl_SetVar( interp, "pattern", pattern, 0 );
	sprintf( command, "regexp {(.*),(.*)} $var match value1 value2" );
	Tcl_Eval( interp, command );
	strcpy( sTclTxt, Tcl_GetVar( interp, "value2", 0 ));
	strcpy( sReturn, sTclTxt );
	return( sReturn );
}

#if defined(PSPICE)

/* --------- LTC PSpice process net name ----------*/

char* LTC_PSpice_Process_Net_Name( char* name )
{
	char *pdest;
	char newName[512];

	strcpy( newName, name );
	_strupr( newName );                  
	pdest = strstr( newName, "GND" );

	if (bCmd_XGNDXto0 && ( pdest != NULL ))
		strcpy( name, "0");
	else if ( bCmd_GNDto0 && ( _stricmp( name, "GND" ) == 0 ))
		strcpy( name, "0");
	else if (IsGlobalNetName( name ) > 0 )
		sprintf( name, "$G_%s", newName );
	else
		sprintf( name, "%s", newName );
	return name;
}

#endif // PSPICE

#if (defined(HSPICE) || defined(LVS) || defined(PR) || defined(NTL) )

/* --------- LTC HSpice process net name ----------*/
char* LTC_HSpice_Process_Net_Name( char* name )
{
	char *pdest;
	char newName[512];

	strcpy( newName, name );
	_strupr( newName );                  
	pdest = strstr( newName, "GND" );
	if ( bCmd_XGNDXto0 && ( pdest != NULL ))
		strcpy( name, "0");
	else if ( bCmd_GNDto0 && ( _stricmp( name, "GND" ) == 0) )
		strcpy( name, "0" );
	return name;
}
#endif // HSPICE  LVS PR NTL

/*---------- Get_Spice_Net_Name ----------*/

char* Get_Spice_Net_Name( TN_PTR tn )
{
	int i, j;

	char *netname = _strupr( _strdup(NetName( tn )));
	char *szIllegalChar;
	char *szTempNetName;
	bool bOkToMatch = false;
#if defined(PSPICE)
	szTempNetName = new char[strlen(netname) + 3];
#endif // PSPICE
#if ( defined(HSPICE) || defined(LVS) || defined(PR) || defined(NTL) )
	szTempNetName = new char[strlen(netname) + 2];
#endif // HSPICE
	strcpy(szTempNetName, netname);
	if ( szIllegalChar = strpbrk( netname, ".-[]()<>{}" ) ) {
		if (bCmd_Flat){
			char *szResult;
			if (*szTempNetName == '.'){
				if (szResult = strpbrk(szTempNetName, "-") ){
					if (!(szResult = strpbrk( szResult + 1, ".-[]()<>{}" ) ) ) {
						bOkToMatch = true;
					}
				}
			}
		}

		while ( szIllegalChar = strpbrk( szTempNetName, ".-[]()<>{}" ) ){
			*szIllegalChar = '$';
		}

		int nLocalMaxIndexCount;
		char **LocalUnderscoreNameCache;

		if (!bCmd_Flat) {
			for (i = 0; i < nMaxSubCircuitIndexCount; i++) {
				if (!stricmp(szCurrentSubCircuitName, SubCircuitNames[i]))  {
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
				if (!stricmp(szTempNetName, LocalUnderscoreNameCache[j]))  {
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
#if defined(PSPICE)
	szTempNetName  = LTC_PSpice_Process_Net_Name ( szTempNetName );
#endif // PSPICE

#if ( defined(HSPICE) || defined(LVS) || defined(PR) || defined(NTL) )
	szTempNetName  = LTC_HSpice_Process_Net_Name ( szTempNetName );
#endif // HSPICE or LVS

	return szTempNetName;
}

                       /*---------- Out_Nets ----------*/

/* Out_Nets is used to list the element name and the various nets which are
   connected to it.  This portion is the same for all primitives.  For flat
   net lists, list nets by the NetNumber.  For hierarchical net lists, list
   nets either by name or by the number assigned previously for the current
   block ( Get_Net_Number() ). */

static void Out_Nets( int count )
{
	char *val;
	char *instname;
	char sTemp[256];
	char *netName;
	char *temp;
	bool bSimPrimitive = true;

	instname = LocalInstanceName( ti );

	char *szIllegalChar;

	while ( szIllegalChar = strpbrk( instname, ".-[]()<>{}" )) {
		*szIllegalChar = '_';
	}
	temp = _strupr( _strdup( instname ));

#if ( defined( PSPICE ) || defined( HSPICE ))
	if ( *(val = Get_TIA( ti, SIM_LEVEL ))) {
		if ((*val == 'N') || (*val == 'n') || (*val == '0'))
			bSimPrimitive = true;
		else
			bSimPrimitive = false;
	}
	else
		bSimPrimitive = true;
#endif // PSPICE or HSPICE

	if ( bCmd_FilterPrefix && ( *element == *temp )) {
#if defined(PSPICE)
		if (!bCmd_MixedSignal || !bDigitalMode ) {
			if ( bSimPrimitive )
				sprintf( line, "%s", instname );
			else
				sprintf( line, "X%s", instname );
		}
		else {
			if ( bDigitalMode && ( *element == 'M' )) 
				sprintf( line, "U%s", instname );
			else {
				if ( bSimPrimitive )
					sprintf( line, "%s", instname );
				else
					sprintf( line, "X%s", instname );
			}
		}
#endif // PSPICE

#if defined(HSPICE)
		if ( bSimPrimitive )
			sprintf( line, "%s", instname );
		else
			sprintf( line, "X%s", instname );
#endif // HSPICE

#if( defined(LVS) || defined(PR) || defined(NTL) )
		if ( *(val = Get_TIA( ti, LVS_REMOVE ) ) && (*val == 'y' || *val =='Y') )
			sprintf( line, "*%s", instname );
		else
			sprintf( line, "%s", instname );
#endif // LVS
	}
	else {
#if defined(PSPICE)
		if (!bCmd_MixedSignal || !bDigitalMode ) {
			if ( bSimPrimitive )
				sprintf( line, "%s%s", element, instname );
			else
				sprintf( line, "X%s%s", element, instname );
		}
		else {
			if ( bDigitalMode && ( *element == 'M' )) 
				sprintf( line, "U%s%s", element, instname );
			else {
				if ( bSimPrimitive )
					sprintf( line, "%s%s", element, instname );
				else
					sprintf( line, "X%s%s", element, instname );
			}
		}
#endif // PSPICE 

#if defined(HSPICE)
		if ( bSimPrimitive )
			sprintf( line, "%s%s", element, instname );
		else
			sprintf( line, "X%s%s", element, instname );
#endif // HSPICE

#if ( defined(LVS) || defined(PR)  || defined(NTL))
		if ( *(val = Get_TIA( ti, LVS_REMOVE ) ) && ( *val == 'y' || *val =='Y' ))
			sprintf( line, "*%s%s", element, instname );
		else
			sprintf( line, "%s%s", element, instname );
#endif // LVS
	}
	Data_Out( line , false);

#if defined(PSPICE)
	if ( bDigitalMode && *element == 'M') {
		if ( *(val = Get_TIA( ti, DIGITAL_PRIMITIVE ))) {
			sprintf( line, " %s %s %s", val, "$G_Dpwr", "$G_Dgnd" );
			Data_Out( line , false); 
		}
		else
			errorWithInstance("Missing DIGITAL_PRIMITIVE attribute" , ti );
	}
#endif // PSPICE
	for ( int ii = 0; ii < count; ii++ ) {
		if ( nets[ii] ) {
			if ( bCmd_Node_Names && ( netName = Get_Spice_Net_Name( nets[ii] ))) {
#if defined( PSPICE )
				strcpy( sTemp, LTC_PSpice_Process_Net_Name( netName ));
				if (( *element == 'Q' ) && ( ii == 3 ))
					sprintf( line, " [%s]", sTemp );
				else
					if ( bDigitalMode && ( *element == 'M' ) && ii == 3 )
						strcpy( line, "" );
					else
						sprintf( line, " %s", sTemp );
#endif // PSPICE
#if ( defined(HSPICE)|| defined(LVS) || defined(PR) || defined(NTL))
				strcpy( sTemp,netName );
				sprintf( line, " %s", sTemp );
#endif // HSPICE
			}
			else
				sprintf( line, " %ld", Get_Net_Number( nets[ii] ) );
			Data_Out( line , true);
		}
	}
#if ( defined( PSPICE ) | defined( HSPICE ))
	if ( !bSimPrimitive )
		Out_XDef_Net();
#endif
}

/*---------- Out_XDef_Tub_Net ----------*/

static void Out_XDef_Tub_Net()
{
	char *netName;
	char sTemp[256];
	TN_PTR tn = 0;

	SavePath();
	/* FindNetNamed() changes the path */
	/* Use the Default name for the subcircuit substrate terminal if it exists */

	netName = Get_TIA( ti, XDEF_TUB );

	if ( bCmd_Node_Names ) {
#if defined(PSPICE)
		strcpy( sTemp, LTC_PSpice_Process_Net_Name( netName ));
		sprintf( line, " %s", sTemp );
#endif // PSPICE
#if ( defined(HSPICE) || defined(LVS) || defined(PR) || defined(NTL) )
		strcpy( sTemp, LTC_HSpice_Process_Net_Name( netName ));
		sprintf( line, " %s", sTemp );
#endif// HSPICE, LVS or PR
	}
	else
		sprintf( line, " %ld", Get_Net_Number( tn ) );
	Data_Out( line , true);
	RestorePath();
}

/*---------- Out_XDef_Net ----------*/

static void Out_XDef_Net()
{
	char *netName;
	char sTemp[256];
	TN_PTR tn = 0;

	SavePath();
	/* FindNetNamed() changes the path */
	/* Use the Default name for the subcircuit substrate terminal if it exists */

	netName = Get_TIA( ti, XDEF_SUB );

	if ( bCmd_Node_Names ) {
#if defined(PSPICE)
		strcpy( sTemp, LTC_PSpice_Process_Net_Name( netName ));
		sprintf( line, " %s", sTemp );
#endif // PSPICE
#if ( defined(HSPICE) || defined(LVS) || defined(PR) || defined(NTL) )
		strcpy( sTemp, LTC_HSpice_Process_Net_Name( netName ));
		sprintf( line, " %s", sTemp );
#endif// HSPICE, LVS or PR
	}
	else
		sprintf( line, " %ld", Get_Net_Number( tn ) );
	Data_Out( line , true);
	RestorePath();
}

/*---------- Out_Def_Net ----------*/

static void Out_Def_Net()
{
	char *netName;
	char sTemp[256];
	TN_PTR tn = 0;

	SavePath();                             /* FindNetNamed() changes the path */
	/* Use the Default name for the fourth terminal if it exists */
	netName = Get_TIA( ti, DEFSUBSTRATE );

	/* add section to attach default substrate with syntax "=pin_name" */

	if ( *element == 'M' && netName[0] == '=' ) {
		if ( netName[1] == 'D' ) tn = nets[0];
		if ( netName[1] == 'G' ) tn = nets[1];
		if ( netName[1] == 'S' ) tn = nets[2];
	}
	else {
		if ( *netName ) 
			tn = FindNetNamed( netName );
	}
	if ( tn ) {
		if ( bCmd_Node_Names && ( netName = Get_Spice_Net_Name( tn ))) {
#if defined(PSPICE)
			strcpy( sTemp, LTC_PSpice_Process_Net_Name( netName ));
			if ( *element == 'Q' )
				sprintf( line, " [%s]", sTemp );
			else
				sprintf( line, " %s", sTemp );
#endif // PSPICE
#if (defined(HSPICE) || defined(NTL) || defined(LVS) || defined(PR))
			strcpy( sTemp, netName );
			sprintf( line, " %s", sTemp );
#endif
		}
		else
			sprintf( line, " %ld", Get_Net_Number( tn ) );
		Data_Out( line , true);
	}
	else {
		if ( *netName ) {
			char msg[128];
			sprintf( msg, "Unrecognized default substrate %s", netName );
			errorWithInstance( msg, ti );
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

static void Out_Nets_Only( int count )
{
	for ( int ii = 0; ii < count; ii++ ) {
		if ( nets[ii] ) {
			char* name;
			if ( bCmd_Node_Names && ( name = Get_Spice_Net_Name( nets[ii] ) ) ) {
#if defined(PSPICE)
				name = LTC_PSpice_Process_Net_Name (name);
#endif // PSPICE
				sprintf( line, " %s", name );
			}
			else
				sprintf( line, " %ld", Get_Net_Number( nets[ii] ) );
			Data_Out( line , false);
		}
	}
}

/*---------- Bipolar Transistor Models ----------*/

static int Bipolar_Pins( TP_PTR tp )
{
	char* name;
	TN_PTR net;

	net = NetContainingPin( tp );
	if ( bCmd_Flat && net )
		net = FindNetRoot( net );
	name = Get_TPA( tp, NAME );
	if ( *name == 'C' )
		nets[0] = net;
	else if ( *name == 'B' )
		nets[1] = net;
	else if ( *name == 'E' )
		nets[2] = net;
	else if ( *name == 'S' ) {
		nets[3] = net;
		if ( !net ) {
			char msg[128];
			sprintf( msg, " Unconnected pin on bipolar transistor %s", name );
			errorWithInstance( msg, ti );
		}
		else {
			char msg[128];
			sprintf( msg, " Unconnected pin on bipolar transistor %s", name );
			errorWithInstance( msg, ti );
		}
	}
	return( 0 );
}

/* Prefix = Q */
static void Bipolar_Transistor() {
	char* val;
	bool bSimPrimitive = true;

#if ( defined(PSPICE) || defined(HSPICE) )
	char szSpiceModel[256];
#endif // PSPICE or HSPICE

#if ( defined(LVS) || defined(PR) || defined(NTL) )
	char szShrink[256];
	char szVal[256];
	char szResize[256];
	char *tVal;
#endif // LVS
	ForEachInstancePin( ti, Bipolar_Pins );

#if ( defined(PSPICE) || defined(HSPICE) )
	if ( *(val = Get_TIA( ti, SIM_LEVEL ) ) ) {
		if ((*val == 'N') || (*val == 'n') || (*val == '0'))
			bSimPrimitive = true;
		else
			bSimPrimitive = false;
	}
	else
		bSimPrimitive = true;
#endif // PSPICE or HSPICE

	if ( nets[0] && nets[1] && nets[2] ) {
		Out_Nets( 4 );
		if ( !nets[3] ) Out_Def_Net();

#if ( defined(PSPICE) || defined(HSPICE) )
		/* SPICEMODEL */
		if ( *(val = Get_TIA( ti, SPICEMODEL ) ) && *val != '*' ) {
			if ( bSimPrimitive )
				sprintf( line, " %s", val );
			else {
				strcpy(szSpiceModel, val);
				if ( *(val = Get_TIA( ti, SIM_LEVEL ) ) )
					sprintf( line, " %s%s", szSpiceModel, val );
				else
					sprintf( line, " %s", szSpiceModel);
			}
			Data_Out( line , false);
		}
		else
			errorWithInstance("Device model needs to be checked" , ti );
#endif // PSPICE or HSPICE

		/* LVS_TYPE */
#if ( defined(LVS) || defined(PR) )
		if ( *(val = Get_TIA( ti, LVS_TYPE ) ) && *val != '*' ) {
			sprintf( line, " %s", val );
			Data_Out( line , false);
		}
		else  if (*(tVal = Get_TIA( ti, LVS_REMOVE ) ) == NULL ) 
			errorWithInstance("Missing LVS type attribute" , ti );
#endif //LVS PR

		/* CELL */
#if  defined(NTL)
		if ( *(val = Get_TIA( ti, CELL ) ) && *val != '*' ) {
			sprintf( line, " %s", val );
			Data_Out( line , false);
		}
		else  if (*(tVal = Get_TIA( ti, LVS_REMOVE ) ) == NULL ){ 
			sprintf( line, " DUMMY" );
			Data_Out( line , false);
		}

#endif // NTL

		/* MULTI */
		if (( *(val = Get_TIA( ti, MULTI ) ) && *val != '*' ) && bSimPrimitive) {
			if ( !LTCSimPassParamVal( val )) {
#if (defined(PSPICE) || defined(HSPICE))
				sprintf( line, " %s", val);
#endif // PSPICE or HSPICE
#if ( defined(LVS) || defined(PR) || defined(NTL) )
				sprintf( line, " M=%s", val);
#endif // LVS
			}
			else {
#if (defined(PSPICE) || defined(HSPICE))
				sprintf( line, " %s", val);
#endif // PSPICE or HSPICE
#if ( defined(LVS) || defined(PR) || defined(NTL) )
				sprintf( line, " M=%s", val);
#endif // LVS
			}
			Data_Out( line , false);
		} 

#if ( defined(LVS) || defined(PR)  || defined(NTL))

		if ( bCmd_WLBip ) {
			/* LENGTH */
			if ( *(val = Get_TIA( ti, LENGTH ) ) && *val != '*' ) {
				if ( !LTCSimPassParamVal( val )) {
					if ( bCmd_Shrink ) {
						strcpy(szVal, val);
						val	= Get_TIA( ti, SHRINK );
						strcpy(szShrink,val);
						val = Get_TIA( ti, GATE_RESIZE );
						strcpy(szResize,val);
						sprintf( line, " L=(%s*%s)", szVal, szShrink );
					}
					else
						sprintf( line, " L=%s", val);
				}
				else if (bCmd_Shrink) {
					strcpy( szVal, LTCSimExtParam( val ));
					val = Get_TIA( ti, SHRINK );
					strcpy(szShrink,val);
					val = Get_TIA( ti, GATE_RESIZE );
					strcpy(szResize,val);
					sprintf( line, " L=%s*%s", szVal, szShrink );
				}
				else {
					strcpy( szVal, LTCSimExtParam( val ));
					sprintf( line, " L=%s", szVal );
				}
				Data_Out( line , false);
			}
			else 
				errorWithInstance("Missing length value attribute" , ti );

			/* WIDTH */
			if ( *(val = Get_TIA( ti, WIDTH ) ) && *val != '*' ) {
				if ( !LTCSimPassParamVal( val )) {
					if (bCmd_Shrink) {
						strcpy(szVal, val);
						val = Get_TIA( ti, SHRINK );
						strcpy(szShrink,val);
						sprintf( line, " W=%s*%s",szVal,szShrink);
					}
					else
						sprintf( line, " W=%s", val);
				}
				else {
					if (bCmd_Shrink) {
						strcpy(szVal, LTCSimExtParam( val ));
						val = Get_TIA( ti, SHRINK );
						strcpy(szShrink,val);
						val = Get_TIA( ti, GATE_RESIZE );
						strcpy(szResize,val);
						sprintf( line, " W=%s*%s",szVal,szShrink);
					}
					else {
						strcpy(szVal, LTCSimExtParam( val ));
						sprintf( line, " W=%s", szVal );
					}
				}
				Data_Out( line , false);
			}
			else
				errorWithInstance("Missing width value attribute" , ti );
		}
		/* AREA */
		if ( bCmd_AreaBip ) {
			if (( *(val = Get_TIA( ti, AREA ) ) && *val != '*' )) {
				if ( !LTCSimPassParamVal( val )) {
					if (bCmd_Shrink) {
						strcpy(szVal, val);
						val = Get_TIA( ti, SHRINK );
						strcpy(szShrink,val);
						sprintf( line, " $EA=%s*(%s*%s)",szVal,szShrink,szShrink);
					}
					else
						sprintf( line, " $EA=%s", val);
				}
				else {
					if (bCmd_Shrink) {
						strcpy(szVal, LTCSimExtParam( val ));
						val = Get_TIA( ti, SHRINK );
						strcpy( szShrink, val );
						sprintf( line, " $EA=(%s*%s*%s)",szVal,szShrink,szShrink);
					}
					else {
						strcpy(szVal, LTCSimExtParam( val ));
						sprintf( line, " $EA=%s", szVal );
					}
				}
				Data_Out( line , false);
			}
			else
				errorWithInstance("Area not specified on bipolar transistor ", ti );
		}
#endif // LVS

#if (defined(PSPICE) || defined(HSPICE))
		/* SPICELINE */
		if (( *(val = Get_TIA( ti, SPICELINE ) ) && *val != '*' ) && bSimPrimitive ) {
			sprintf( line, " %s", val );
			Data_Out( line , false);
		}
#endif // PSPICE or HSPICE

		/* SPICELINE3 */
		if ((*(val = Get_TIA( ti, SPICELINE3 ))) && !bSimPrimitive) {
#if defined(PSPICE)
			sprintf( line, " PARAMS: %s", val );
#endif //PSPICE
#if (defined(HSPICE) || defined(LVS) || defined(PR) || defined(NTL) )
			sprintf( line, " %s", val );
#endif // HSPICE or LVS
			Data_Out( line , false);
		}
#if defined(NTL)
		/* APT LOCATION */
		if (*(val = Get_TIA( ti, 254 ))){
			sprintf( line, " X_LOC=%s Y_LOC=%s", LTCSimSplitXLoc( val ), LTCSimSplitYLoc( val ) );
			Data_Out( line , true);  
		}
#endif // NTL	
		Data_Out( "\n" , false);
	}
	else
		errorWithInstance("Unconnected pin on bipolar transisto", ti );
}


/*---------- FET Transistor Models ----------*/

static int FET_Pins( TP_PTR tp )
{
	char* name;
	TN_PTR net;

	net = NetContainingPin( tp );
	if ( bCmd_Flat && net ) net = FindNetRoot( net );
	name = Get_TPA( tp, NAME );
	if      ( *name == 'D' ) nets[0] = net;
	else if ( *name == 'G' ) nets[1] = net;
	else if ( *name == 'S' ) nets[2] = net;
	else if ( *name == 'B' ) {
		nets[3] = net;
		if ( !net ) {
			char msg[128];
			sprintf( msg, "Unconnected pin on transistor %s", name );
			errorWithInstance( msg, ti );
		}
	}
	else {
		char msg[128];
		sprintf( msg, "Unrecognized pin on transistor %s", name );
		errorWithInstance( msg, ti );
	}
	return( 0 );
}


/*---------- FET Transistor Models ----------*/

static int JFET_Pins( TP_PTR tp )
{
	char* name;
	TN_PTR net;

	net = NetContainingPin( tp );
	if ( bCmd_Flat && net ) net = FindNetRoot( net );
	name = Get_TPA( tp, NAME );
	if      ( *name == 'D' ) nets[0] = net;
	else if ( *name == 'G' ) nets[1] = net;
	else if ( *name == 'S' ) nets[2] = net;
#if defined(HSPICE) 
	else if ( *name == 'B' ) {
		nets[3] = net;
		if ( !net ) {
			char msg[128];
			sprintf( msg, "Unconnected pin on transistor %s", name );
			errorWithInstance( msg, ti );
		}
	}
#endif // HSPICE
	else {
		char msg[128];
		sprintf( msg, "Unrecognized pin on transistor %s", name );
		errorWithInstance( msg, ti );
	}
	return( 0 );
}

char *LTCReplacePWLScale(char *value)
{
	char *sReturn;

	sReturn = new char[strlen(value) + 10];
	strcpy( sTclTxt, LTCSimExtParam( value ));
	sprintf( pattern, ".*1E-(6|12)]?");
	int idx = Tcl_RegExpMatch(interp, sTclTxt, pattern);

	if ( idx > 0 ) {
		strcpy( sReturn, sTclTxt );
		return( sReturn );
	}
	else {
#if (defined(HSPICE) || defined(PSPICE))
		sprintf( sReturn,"%s*1E-6", sTclTxt );
		return ( sReturn);
#endif
#if (defined(LVS) || defined(PR) || defined(NTL))
		strcpy( sReturn, sTclTxt );
		return( sReturn );
#endif
	}
}



char *LTCReplaceAScale(char *value)
{
	char *sReturn;

	sReturn = new char[strlen(value) + 10];
	strcpy( sTclTxt, LTCSimExtParam( value ));
	sprintf( pattern, ".*1E-(6|12)]?");
	int idx = Tcl_RegExpMatch(interp, sTclTxt, pattern);

	if ( idx > 0 ) {
		strcpy( sReturn, sTclTxt );
		return( sReturn );
	}
	else {
#if (defined(HSPICE) || defined(PSPICE))
		sprintf( sReturn,"%s*1E-12", sTclTxt );
		return ( sReturn);
#endif
#if (defined(LVS) || defined(PR) || defined(NTL))
		strcpy( sReturn, sTclTxt );
		return( sReturn );
#endif
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

#if ( defined(PSPICE) || defined(HSPICE) )
	char szSpiceModel[256];
#endif // PSPICE or HSPICE

#if ( defined(LVS) || defined(PR) || defined(NTL) )
	char *tVal;
#endif // LVS

#if (defined(PSPICE) || defined(HSPICE))
	if ( *(val = Get_TIA( ti, SIM_LEVEL ))) {
		if ((*val == 'N') || (*val == 'n') || (*val == '0'))
			bSimPrimitive = true;
		else
			bSimPrimitive = false;
	}
	else
		bSimPrimitive = true;
#endif // PSPICE or HSPICE

	ForEachInstancePin( ti, FET_Pins );
	if ( nets[0] && nets[1] && nets[2] ) {
		Out_Nets( 4 );
#if defined(PSPICE)
		if ( !nets[3] && !bDigitalMode )
			Out_Def_Net();
#endif // PSPICE
#if (defined(HSPICE) || defined(LVS) || defined(PR) || defined(NTL))
		Out_Def_Net();
#endif // HSPICE LVS PR

		/* LVS_TYPE */
#if ( defined(LVS) || defined(PR))
		if ( *(val = Get_TIA( ti, LVS_TYPE ) ) && *val != '*' ) {
			sprintf( line, " %s", val );
			Data_Out( line , false);
		}
		else 
			if ( *( tVal = Get_TIA( ti, LVS_REMOVE )) == NULL ) 
				errorWithInstance("Missing LVS type attribute" , ti );
#endif // LVS

		/* CELL */
#if defined(NTL)
		if ( *(val = Get_TIA( ti, CELL ) ) && *val != '*' ) {
			sprintf( line, " %s", val );
			Data_Out( line , false);
		}
		else  if (*(tVal = Get_TIA( ti, LVS_REMOVE ) ) == NULL ){ 
			sprintf( line, " DUMMY" );
			Data_Out( line , false);
		}
#endif // NTL


#if defined(PSPICE)
		if ( !bDigitalMode ) {
			/* SPICEMODEL */
			if ( *(val = Get_TIA( ti, SPICEMODEL ) ) && *val != '*' ) {
				if ( bSimPrimitive )
					sprintf( line, " %s", val );
				else {
					strcpy(szSpiceModel, val);
					if ( *(val = Get_TIA( ti, SIM_LEVEL ) ) )
						sprintf( line, " %s%s", szSpiceModel, val );
					else
						sprintf( line, " %s", szSpiceModel);
				}
				Data_Out( line , false);
			}
			else
				errorWithInstance("Device model needs to be checked" , ti );
		}
#endif // PSPICE

#if defined(HSPICE)
		/* SPICEMODEL */
		if ( *(val = Get_TIA( ti, SPICEMODEL ) ) && *val != '*' ) {
			if ( bSimPrimitive )
				sprintf( line, " %s", val );
			else {
				strcpy(szSpiceModel, val);
				if ( *(val = Get_TIA( ti, SIM_LEVEL ) ) )
					sprintf( line, " %s%s", szSpiceModel, val );
				else
					sprintf( line, " %s", szSpiceModel);
			}
			Data_Out( line , false);
		}
		else
			errorWithInstance("Device model needs to be checked" , ti );
#endif //  HSPICE

		if ( bSimPrimitive ) {
			/* LENGTH */
			if ( *(val = Get_TIA( ti, LENGTH ) ) && *val != '*' ) {
				if ( !LTCSimPassParamVal( val )) {
					if (bCmd_Shrink) {
						strcpy(szVal, val);
						val	= Get_TIA( ti, SHRINK );
						strcpy(szShrink,val);
						val = Get_TIA( ti, GATE_RESIZE );
						strcpy(szResize,val);
#if defined(PSPICE)
						if ( !bDigitalMode )
							sprintf( line, " L={((%s*%s)-%s)*1E-6}",szVal,szShrink,szResize);
#endif // PSPICE
#if defined(HSPICE)
						sprintf( line, " L='((%s*%s)-%s)*1E-6'",szVal,szShrink,szResize);
#endif // HSPICE
#if ( defined(LVS) || defined(PR) || defined(NTL) )
						sprintf( line, " L=(%s*%s)-%s",szVal,szShrink,szResize);
#endif // LVS
					}
					else {
#if defined(PSPICE)
						if ( !bDigitalMode )
							sprintf( line, " L=%sU", val); 
#endif // PSPICE
#if defined(HSPICE)
						sprintf( line, " L=%sU", val);
#endif // HSPICE
#if ( defined(LVS) || defined(PR) || defined(NTL) )
						sprintf( line, " L=%s", val);
#endif // LVS
					}
				}
				else {
					if (bCmd_Shrink) {
						strcpy(szVal, LTCSimExtParam(val));
						val	= Get_TIA( ti, SHRINK );
						strcpy(szShrink,val);
						val = Get_TIA( ti, GATE_RESIZE );
						strcpy(szResize,val);
#if defined(PSPICE)
						if ( !bDigitalMode )
							sprintf( line, " L={((%s*%s)-%s)*1E-6}",szVal,szShrink,szResize);
#endif // PSPICE
#if defined(HSPICE)
						sprintf( line, " L='((%s*%s)-%s)*1E-6'",szVal,szShrink,szResize);
#endif // HSPICE
#if ( defined(LVS) || defined(PR) || defined(NTL) )
						sprintf( line, " L=(%s*%s)-%s",szVal,szShrink,szResize);
#endif //LVS
					}
					else {
#if defined(PSPICE)
						if ( !bDigitalMode )
							sprintf( line, " L={%s}", LTCReplacePWLScale(val));
#endif // PSPICE
#if defined(HSPICE)
						sprintf( line, " L='%s'", LTCReplacePWLScale(val));
#endif // HSPICE
#if ( defined(LVS) || defined(PR) || defined(NTL) )
						sprintf( line, " L=%s", LTCReplacePWLScale(val));
#endif // LVS
					}
				}
#if defined(PSPICE)
				if ( !bDigitalMode )
					Data_Out( line , false);
#endif // PSPICE
#if ( defined(HSPICE) || defined(LVS) || defined(PR) || defined(NTL) )
				Data_Out( line , false);
#endif // HSPICE LVS PR
			}
			else if ( *val == '*' )
				errorWithInstance("Missing length value attribute" , ti );

			/* WIDTH */
			if ( *(val = Get_TIA( ti, WIDTH ) ) && *val != '*' ) {
				if ( !LTCSimPassParamVal( val )) {
					if (bCmd_Shrink) {
						strcpy(szVal, val);
						val	= Get_TIA( ti, SHRINK );
						strcpy(szShrink,val);
#if defined(PSPICE)
						if ( !bDigitalMode )
							sprintf( line, " W={(%s*%s)*1E-6}",szVal,szShrink);
#endif //PSPICE
#if defined(HSPICE)
						sprintf( line, " W='(%s*%s)*1E-6'",szVal,szShrink);
#endif //HSPICE
#if ( defined(LVS) || defined(PR) || defined(NTL) )
						sprintf( line, " W=%s*%s",szVal,szShrink);
#endif //LVS
					}
					else {
#if defined(PSPICE)
						if ( !bDigitalMode )
							sprintf( line, " W=%sU", val);
#endif // PSPICE
#if defined(HSPICE)
						sprintf( line, " W=%sU", val);
#endif // HSPICE
#if ( defined(LVS) || defined(PR) || defined(NTL) )
						sprintf( line, " W=%s", val);
#endif // LVS
					}
				}
				else {
					if (bCmd_Shrink) {
						strcpy(szVal, LTCSimExtParam( val ));
						val	= Get_TIA( ti, SHRINK );
						strcpy(szShrink,val);
						val = Get_TIA( ti, GATE_RESIZE );
						strcpy(szResize,val);
#if defined(PSPICE)
						if ( !bDigitalMode )
							sprintf( line, " W={(%s*%s)*1E-6}",szVal,szShrink);
#endif //PSPICE
#if defined(HSPICE)
						sprintf( line, " W='(%s*%s)*1E-6'",szVal,szShrink);
#endif //HSPICE
#if ( defined(LVS) || defined(PR) || defined(NTL) )
						sprintf( line, " W=%s*%s",szVal,szShrink);
#endif //LVS PR
					}
					else {
#if defined(PSPICE)
						if ( !bDigitalMode )
							sprintf( line, " W={%s}", LTCReplacePWLScale(val));
#endif // PSPICE
#if defined(HSPICE)
						sprintf( line, " W='%s'", LTCReplacePWLScale(val));
#endif // HSPICE
#if ( defined(LVS) || defined(PR) || defined(NTL) )
						sprintf( line, " W=%s", LTCReplacePWLScale(val));
#endif // LVS PR
					}
				}
#if defined(PSPICE)
				if ( !bDigitalMode )
					Data_Out( line , false);
#endif // PSPICE
#if ( defined(HSPICE) || defined(LVS) || defined(PR) || defined(NTL) )
				Data_Out( line , false);
#endif // HSPICE LVS PR
			}
			else if ( *val == '*' )
				errorWithInstance( "Missing width value attribute", ti );

#if ( defined(PSPICE) || defined(HSPICE) )
			/* AREA_S */
			if ( *(val = Get_TIA( ti, AREA_S ) ) && *val != '*' ) {
				if ( !LTCSimPassParamVal( val )) {
					if (bCmd_Shrink) {
						strcpy(szVal, val);
						val	= Get_TIA( ti, SHRINK );
						strcpy(szShrink,val);
#if defined(PSPICE)
						if ( !bDigitalMode )
							sprintf( line, " AS={(%s*%s*%s)*1E-12}",szVal,szShrink,szShrink);
#endif //PSPICE
#if defined(HSPICE)
						sprintf( line, " AS='(%s*%s*%s)*1E-12'",szVal,szShrink,szShrink);
#endif //HSPICE
					}
					else
#if defined(PSPICE)
						if ( !bDigitalMode )
							sprintf( line, " AS=%sP", val);
#endif //PSPICE
#if defined(HSPICE)
					sprintf( line, " AS=%sP", val);
#endif //HSPICE
				}
				else {
					if (bCmd_Shrink) {
						strcpy(szVal, LTCSimExtParam( val ));
						val	= Get_TIA( ti, SHRINK );
						strcpy(szShrink,val);
#if defined(PSPICE)
						if ( !bDigitalMode )
							sprintf( line, " AS={%s*%s*%s}",szVal,szShrink,szShrink);
#endif //PSPICE
#if defined(HSPICE)
						sprintf( line, " AS='%s*%s*%s'",szVal,szShrink,szShrink);
#endif //HSPICE
					}
					else {
#if defined(PSPICE)
						if ( !bDigitalMode )
							sprintf( line, " AS={%s}", LTCReplaceAScale(val));
#endif // PSPICE
#if defined(HSPICE)
						sprintf( line, " AS='%s'", LTCReplaceAScale(val));
#endif // HSPICE
					}
				}
#if defined(PSPICE)
				if ( !bDigitalMode )
					Data_Out( line , false);
#endif // PSPICE
#if defined(HSPICE) 
				Data_Out( line , false);
#endif // HSPICE
			}
#endif //PSPICE HSPICE

#if ( defined(PSPICE) || defined(HSPICE) )
			/* AREA_D */
			if ( *(val = Get_TIA( ti, AREA_D ) ) && *val != '*' ) {
				if ( !LTCSimPassParamVal( val )) {
					if (bCmd_Shrink) {
						strcpy(szVal, val);
						val = Get_TIA( ti, SHRINK );
						strcpy(szShrink,val);
#if defined(PSPICE)
						if ( !bDigitalMode )
							sprintf( line, " AD={(%s*%s*%s)*1E-12}",szVal,szShrink,szShrink);
#endif //PSPICE
#if defined(HSPICE)
						sprintf( line, " AD='(%s*%s*%s)*1E-12'",szVal,szShrink,szShrink);
#endif //HSPICE
					}
					else
#if defined(PSPICE)
						if ( !bDigitalMode )
							sprintf( line, " AD=%sP", val);
#endif //PSPICE
#if defined(HSPICE)
					sprintf( line, " AD=%sP", val);
#endif //HSPICE
				}
				else {
					if (bCmd_Shrink) {
						strcpy(szVal, LTCSimExtParam( val ));
						val	= Get_TIA( ti, SHRINK );
						strcpy(szShrink,val);
#if defined(PSPICE)
						if ( !bDigitalMode )
							sprintf( line, " AD={%s*%s*%s}",szVal,szShrink,szShrink);
#endif //PSPICE
#if defined(HSPICE)
						sprintf( line, " AD='%s*%s*%s'",szVal,szShrink,szShrink);
#endif //HSPICE
					}
					else {
#if defined(PSPICE)
						if ( !bDigitalMode )
							sprintf( line, " AD={%s}", LTCReplaceAScale(val));
#endif // PSPICE
#if defined(HSPICE)
						sprintf( line, " AD='%s'", LTCReplaceAScale(val));
#endif // HSPICE
					}
				}
#if defined(PSPICE)
				if ( !bDigitalMode )
					Data_Out( line , false);
#endif // PSPICE
#if defined(HSPICE)
				Data_Out( line , false);
#endif // HSPICE
			}
#endif // PSPICE HSPICE

#if ( defined(PSPICE) || defined(HSPICE) )
			/* PERI_S */
			if ( *(val = Get_TIA( ti, PERI_S ) ) && *val != '*' ) {
				if ( !LTCSimPassParamVal( val )) {
					if (bCmd_Shrink) {
						strcpy(szVal, val);
						val	= Get_TIA( ti, SHRINK );
						strcpy(szShrink,val);
						val = Get_TIA( ti, GATE_RESIZE );
						strcpy(szResize,val);
#if defined(PSPICE)
						if ( !bDigitalMode )
							sprintf( line, " PS={((%s*%s)+%s)*1E-6}",szVal,szShrink,szResize);
#endif //PSPICE
#if defined(HSPICE)
						sprintf( line, " PS='((%s*%s)+%s)*1E-6'",szVal,szShrink,szResize);
#endif // HSPICE
					}
					else
#if defined(PSPICE)
						if ( !bDigitalMode )
							sprintf( line, " PS=%sU", val);
#endif //PSPICE
#if defined(HSPICE)
					sprintf( line, " PS=%sU", val);
#endif // HSPICE
				}
				else {
					if (bCmd_Shrink) {
						strcpy(szVal, LTCSimExtParam( val ));
						val	= Get_TIA( ti, SHRINK );
						strcpy(szShrink,val);
						val = Get_TIA( ti, GATE_RESIZE );
						strcpy(szResize,val);
#if defined(PSPICE)
						if ( !bDigitalMode )
							sprintf( line, " PS={(%s*%s)+(%s*1E-6)}",szVal,szShrink,szResize);
#endif //PSPICE
#if defined(HSPICE)
						sprintf( line, " PS='(%s*%s)+(%s*1E-6)'",szVal,szShrink,szResize);
#endif // HSPICE
					}
					else {
#if defined(PSPICE)
						if ( !bDigitalMode )
							sprintf( line, " PS={%s}", LTCReplacePWLScale(val));
#endif // PSPICE
#if defined(HSPICE)
						sprintf( line, " PS='%s'", LTCReplacePWLScale(val));
#endif // HSPICE
					}
				}
#if defined(PSPICE)
				if ( !bDigitalMode )
					Data_Out( line , false);
#endif // PSPICE
#if defined(HSPICE)
				Data_Out( line , false);
#endif // HSPICE
			}
#endif // PSPICE HSPICE

#if ( defined(PSPICE) || defined(HSPICE) )
			/* PERI_D */
			if ( *(val = Get_TIA( ti, PERI_D ) ) && *val != '*' )  {
				if ( !LTCSimPassParamVal( val )) {
					if (bCmd_Shrink) {
						strcpy(szVal, val);
						val	= Get_TIA( ti, SHRINK );
						strcpy(szShrink,val);
						val = Get_TIA( ti, GATE_RESIZE );
						strcpy(szResize,val);
#if defined(PSPICE)
						if ( !bDigitalMode )
							sprintf( line, " PD={((%s*%s)+%s)*1E-6}",szVal,szShrink,szResize);
#endif //PSPICE
#if defined(HSPICE)
						sprintf( line, " PD='((%s*%s)+%s)*1E-6'",szVal,szShrink,szResize);
#endif // HSPICE
					}
					else {
#if defined(PSPICE)
						if ( !bDigitalMode )
							sprintf( line, " PD=%sU", val);
#endif //PSPICE
#if defined(HSPICE)
						sprintf( line, " PD=%sU", val);
#endif // HSPICE
					}
				}
				else {
					if (bCmd_Shrink) {
						strcpy(szVal, LTCSimExtParam( val ));
						val	= Get_TIA( ti, SHRINK );
						strcpy(szShrink,val);
						val = Get_TIA( ti, GATE_RESIZE );
						strcpy(szResize,val);
#if defined(PSPICE)
						if ( !bDigitalMode )
							sprintf( line, " PD={(%s*%s)+(%s*1E-6)}",szVal,szShrink,szResize);
#endif //PSPICE
#if defined(HSPICE)
						sprintf( line, " PD='(%s*%s)+(%s*1E-6)'",szVal,szShrink,szResize);
#endif // HSPICE
					}
					else {
#if defined(PSPICE)
						if ( !bDigitalMode )
							sprintf( line, " PD={%s}", LTCReplacePWLScale(val));
#endif // PSPICE
#if defined(HSPICE)
						sprintf( line, " PD='%s'", LTCReplacePWLScale(val));
#endif // HSPICE
					}
				}
#if defined(PSPICE)
				if ( !bDigitalMode )
					Data_Out( line , false);
#endif // PSPICE
#if defined(HSPICE)
				Data_Out( line , false);
#endif // HSPICE
			}
#endif // PSPICE HSPICE

#if ( defined( PSPICE ) || defined( HSPICE ))
			/* NRS */
			if ( *(val = Get_TIA( ti, NRS ) ) && *val != '*' ) {
				sprintf( line, " NRS=%s", val );
				Data_Out( line , false);
			}
			/* NRD */
			if ( *(val = Get_TIA( ti, NRD ) ) && *val != '*' ) {
				sprintf( line, " NRD=%s", val );
				Data_Out( line , false);
			}
#endif // PSPICE or HSPICE
		}
		/* MULTI */
		if ( *(val = Get_TIA( ti, MULTI ) ) && *val != '*' ) {
			sprintf( line, " %s%s", szCmd_MultiCode, val );
			Data_Out( line , false);
		} 
		if ( bSimPrimitive ) {
#if ( defined(LVS) || defined(PR) )
			/* LVS_LDD */
			if ( *(val = Get_TIA( ti, LVS_LDD ))) {
				tVal = Get_TIA( ti, LVS_TYPE );
				if (toupper( *val ) == 'Y') {
					sprintf( line, " $LDD[%s]", tVal );
				}
				else {
					sprintf( line, " $LDD[%s]", val );
				}
				Data_Out( line , true );
			}
#endif // LVS PR
			/* SPICELINE */
			if ( *(val = Get_TIA( ti, SPICELINE ) ) && *val != '*' ) {
#if defined(PSPICE)
				if ( !bDigitalMode )
					sprintf( line, " PARAMS: %s", val );
#endif //PSPICE
#if ( defined(HSPICE) || defined(LVS) || defined(PR) || defined(NTL) )
				sprintf( line, " %s", val );
#endif // HSPICE LVS PR
#if defined(PSPICE)
				if ( !bDigitalMode )
					Data_Out( line , false);
#endif // PSPICE
#if ( defined(HSPICE) || defined(LVS) || defined(PR) || defined(NTL) )
				Data_Out( line , false);
#endif // HSPICE LVS PR
			}
		}

		/* SPICELINE3 */
		if ((*(val = Get_TIA( ti, SPICELINE3 ))) && !bSimPrimitive) {
#if defined(PSPICE)
			if ( !bDigitalMode )
				sprintf( line, " PARAMS: %s", val );
#endif //PSPICE
#if ( defined(HSPICE) || defined(LVS) || defined(PR) || defined(NTL) )
			sprintf( line, " %s", val );
#endif // HSPICE  LVS PR
#if defined(PSPICE)
			if ( !bDigitalMode )
				Data_Out( line , false);
#endif // PSPICE
#if ( defined(HSPICE) || defined(LVS) || defined(PR) || defined(NTL) )
			Data_Out( line , false);
#endif // HSPICE LVS PR
		}
#if defined(PSPICE)
		if ( bDigitalMode ) {
			if ( *(val = Get_TIA( ti, DIGITAL_TIMING ))) {
				sprintf( line, " %s", val );
				Data_Out( line , false);
			}
			else {
				char msg[128];
				sprintf( msg, "Error:Timing information not available on instance" );
				errorWithInstance( msg, ti );
			}
			if ( *(val = Get_TIA( ti, DIGITAL_IO )))	{
				sprintf( line, " %s", val );
				Data_Out( line , false);
			}
			else {
				char msg[128];
				sprintf( msg, "Error:I/O information not available on instance" );
				errorWithInstance( msg, ti );
			}
			if ( *(val = Get_TIA( ti, DIGITAL_MNTYMXDLY ))) {
				sprintf( line, " MNTYMXDLY=%s", val );
				Data_Out( line , false);
			}
			if ( *(val = Get_TIA( ti, DIGITAL_IO_LEVEL ))) {
				sprintf( line, " IO_LEVEL=%s", val );
				Data_Out( line , false);
			}
		}
#endif // PSPICE
#if defined(NTL)
		/* APT LOCATION */
		if (*(val = Get_TIA( ti, 254 ))){
			sprintf( line, " X_LOC=%s Y_LOC=%s", LTCSimSplitXLoc( val ), LTCSimSplitYLoc( val ) );
			Data_Out( line , true);  
		}
#endif // NTL	
		Data_Out( "\n" , false);
	}
	else {
		errorWithInstance("Unconnected pin on transistor" , ti );
	}
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

#if ( defined(PSPICE) || defined(HSPICE) )
	char szSpiceModel[256];
#endif // PSPICE or HSPICE

#if ( defined(LVS) || defined(PR) || defined(NTL) )
	char *tVal;
#endif // LVS

#if (defined(PSPICE) || defined(HSPICE))
	if ( *(val = Get_TIA( ti, SIM_LEVEL ))) {
		if ((*val == 'N') || (*val == 'n') || (*val == '0'))
			bSimPrimitive = true;
		else
			bSimPrimitive = false;
	}
	else
		bSimPrimitive = true;
#endif // PSPICE or HSPICE

	ForEachInstancePin( ti, JFET_Pins );
	if ( nets[0] && nets[1] && nets[2] ) {
#if defined(HSPICE)
		Out_Nets( 4 );
		Out_Def_Net();
#endif // HSPICE
#if (defined(PSPICE) || defined(LVS) || defined(PR) || defined(NTL))
		Out_Nets( 3 );
#endif

		/* LVS_TYPE */
#if ( defined(LVS) || defined(PR))
		if ( *(val = Get_TIA( ti, LVS_TYPE ) ) && *val != '*' ) {
			sprintf( line, " %s", val );
			Data_Out( line , false);
		}
		else 
			if ( *( tVal = Get_TIA( ti, LVS_REMOVE )) == NULL ) 
				errorWithInstance("Missing LVS type attribute" , ti );
#endif // LVS

		/* CELL */
#if defined(NTL)
		if ( *(val = Get_TIA( ti, CELL ) ) && *val != '*' ) {
			sprintf( line, " %s", val );
			Data_Out( line , false);
		}
		else  if (*(tVal = Get_TIA( ti, LVS_REMOVE ) ) == NULL ){ 
			sprintf( line, " DUMMY" );
			Data_Out( line , false);
		}
#endif // NTL

#if defined(PSPICE)
		if ( !bDigitalMode ) {
			/* SPICEMODEL */
			if ( *(val = Get_TIA( ti, SPICEMODEL ) ) && *val != '*' ) {
				if ( bSimPrimitive )
					sprintf( line, " %s", val );
				else {
					strcpy(szSpiceModel, val);
					if ( *(val = Get_TIA( ti, SIM_LEVEL ) ) )
						sprintf( line, " %s%s", szSpiceModel, val );
					else
						sprintf( line, " %s", szSpiceModel);
				}
				Data_Out( line , false);
			}
			else
				errorWithInstance("Device model needs to be checked" , ti );
		}
#endif // PSPICE

#if defined(HSPICE)
		/* SPICEMODEL */
		if ( *(val = Get_TIA( ti, SPICEMODEL ) ) && *val != '*' ) {
			if ( bSimPrimitive )
				sprintf( line, " %s", val );
			else {
				strcpy(szSpiceModel, val);
				if ( *(val = Get_TIA( ti, SIM_LEVEL ) ) )
					sprintf( line, " %s%s", szSpiceModel, val );
				else
					sprintf( line, " %s", szSpiceModel);
			}
			Data_Out( line , false);
		}
		else
			errorWithInstance("Device model needs to be checked" , ti );
#endif //  HSPICE

		if ( bSimPrimitive ) {
			/* LENGTH */
			if ( *(val = Get_TIA( ti, LENGTH ) ) && *val != '*' ) {
				if ( !LTCSimPassParamVal( val )) {
					if (bCmd_Shrink) {
						strcpy(szVal, val);
						val	= Get_TIA( ti, SHRINK );
						strcpy(szShrink,val);
						val = Get_TIA( ti, GATE_RESIZE );
						strcpy(szResize,val);
#if defined(HSPICE)
						sprintf( line, " L='((%s*%s)-%s)*1E-6'",szVal,szShrink,szResize);
#endif // HSPICE
#if ( defined(LVS) || defined(PR) || defined(NTL) )
						sprintf( line, " L=(%s*%s)-%s",szVal,szShrink,szResize);
#endif // LVS
					}
					else {
#if defined(HSPICE)
						sprintf( line, " L=%sU", val);
#endif // HSPICE
#if ( defined(LVS) || defined(PR) || defined(NTL) )
						sprintf( line, " L=%s", val);
#endif // LVS
					}
				}
				else {
					if (bCmd_Shrink) {
						strcpy(szVal, LTCSimExtParam(val));
						val	= Get_TIA( ti, SHRINK );
						strcpy(szShrink,val);
						val = Get_TIA( ti, GATE_RESIZE );
						strcpy(szResize,val);
#if defined(HSPICE)
						sprintf( line, " L='((%s*%s)-%s)*1E-6'",szVal,szShrink,szResize);
#endif // HSPICE
#if ( defined(LVS) || defined(PR) || defined(NTL) )
						sprintf( line, " L=(%s*%s)-%s",szVal,szShrink,szResize);
#endif //LVS
					}
					else {
#if defined(HSPICE)
						sprintf( line, " L='%s'", LTCReplacePWLScale(val));
#endif // HSPICE
#if ( defined(LVS) || defined(PR) || defined(NTL) )
						sprintf( line, " L=%s", LTCReplacePWLScale(val));
#endif // LVS
					}
				}
#if ( defined(HSPICE) || defined(LVS) || defined(PR) || defined(NTL) )
				Data_Out( line , false);
#endif // HSPICE LVS PR
			}
			else if ( *val == '*' )
				errorWithInstance("Missing length value attribute" , ti );

			/* WIDTH */
			if ( *(val = Get_TIA( ti, WIDTH ) ) && *val != '*' ) {
				if ( !LTCSimPassParamVal( val )) {
					if (bCmd_Shrink) {
						strcpy(szVal, val);
						val	= Get_TIA( ti, SHRINK );
						strcpy(szShrink,val);
#if defined(HSPICE)
						sprintf( line, " W='(%s*%s)*1E-6'",szVal,szShrink);
#endif //HSPICE
#if ( defined(LVS) || defined(PR) || defined(NTL) )
						sprintf( line, " W=%s*%s",szVal,szShrink);
#endif //LVS
					}
					else {
#if defined(HSPICE)
						sprintf( line, " W=%sU", val);
#endif // HSPICE
#if ( defined(LVS) || defined(PR) || defined(NTL) )
						sprintf( line, " W=%s", val);
#endif // LVS
					}
				}
				else {
					if (bCmd_Shrink) {
						strcpy(szVal, LTCSimExtParam( val ));
						val	= Get_TIA( ti, SHRINK );
						strcpy(szShrink,val);
						val = Get_TIA( ti, GATE_RESIZE );
						strcpy(szResize,val);
#if defined(HSPICE)
						sprintf( line, " W='(%s*%s)*1E-6'",szVal,szShrink);
#endif //HSPICE
#if ( defined(LVS) || defined(PR) || defined(NTL) )
						sprintf( line, " W=%s*%s",szVal,szShrink);
#endif //LVS PR
					}
					else {
#if defined(HSPICE)
						sprintf( line, " W='%s'", LTCReplacePWLScale(val));
#endif // HSPICE
#if ( defined(LVS) || defined(PR) || defined(NTL) )
						sprintf( line, " W=%s", LTCReplacePWLScale(val));
#endif // LVS PR
					}
				}
#if ( defined(HSPICE) || defined(LVS) || defined(PR) || defined(NTL) )
				Data_Out( line , false);
#endif // HSPICE LVS PR
			}
			else if ( *val == '*' )
				errorWithInstance( "Missing width value attribute", ti );

			/* MULTI */
			if ( *(val = Get_TIA( ti, MULTI ) ) && *val != '*' ) {
#if defined(PSPICE)
				sprintf( line, " %s", val );
#endif
#if ( defined(HSPICE) || defined(LVS) || defined(PR) || defined(NTL) )
				sprintf( line, " M=%s", val );
#endif
				Data_Out( line , false);
			} 

			/* LVS_LDD */
#if ( defined(LVS) || defined(PR) || defined(NTL) )
			if ( bSimPrimitive ) {
				if ( *(val = Get_TIA( ti, LVS_LDD ))) {
					tVal = Get_TIA( ti, LVS_TYPE );
					if (toupper( *val ) == 'Y') {
						sprintf( line, " $LDD[%s]", tVal );
					}
					else {
						sprintf( line, " $LDD[%s]", val );
					}
					Data_Out( line , true );
				}
			}
#endif // LVS PR
		}
#if defined(NTL)
		/* APT LOCATION */
		if (*(val = Get_TIA( ti, 254 ))){
			sprintf( line, " X_LOC=%s Y_LOC=%s", LTCSimSplitXLoc( val ), LTCSimSplitYLoc( val ) );
			Data_Out( line , true);  
		}
#endif // NTL	
		Data_Out( "\n" , false);
	}
	else {
		errorWithInstance("Unconnected pin on transistor" , ti );
	}
}

                /*---------- Transmission Lines ----------*/

static int XLine_Pins( TP_PTR tp )
{
	char* name;
	TN_PTR net;
	int err = 0;

	net = NetContainingPin( tp );
	if ( bCmd_Flat && net ) net = FindNetRoot( net );
	name = Get_TPA( tp, NAME );
	if      ( *name == 'I' )
	{
		if      ( *(name+1) == '1' ) nets[0] = net;
		else if ( *(name+1) == '2' ) nets[2] = net;
		else err = 1;
	}
	else if ( *name == 'R' )
	{
		if      ( *(name+1) == '1' ) nets[1] = net;
		else if ( *(name+1) == '2' ) nets[3] = net;
		else err = 1;
	}
	else err = 1;
	if ( err )
	{	char msg[128];
	sprintf( msg, "Unrecognized pin on transmission lin %s", name );
	errorWithInstance( msg, ti );
	}
	return( 0 );
}

/* Prefix = T */
static void Transmission_Line()
{
	char* val;

	ForEachInstancePin( ti, XLine_Pins );

	if ( nets[0] && nets[1] && nets[2] && nets[3] )
	{
		Out_Nets( 4 );
		if ( *(val = Get_TIA( ti, IMPEDANCE ) ) && *val != '*' )
		{
			sprintf( line, " ZO=%s", val );
			Data_Out( line , false);
		}
		if ( *(val = Get_TIA( ti, VALUE ) ) && *val != '*' )
		{
			sprintf( line, " TD=%s", val );
			Data_Out( line , false);
		}
		if ( *(val = Get_TIA( ti, SPICELINE ) ) && *val != '*' )
		{
			sprintf( line, " %s", val );
			Data_Out( line , false);
		}
		if ( *(val = Get_TIA( ti, SPICELINE2 ) ) && *val != '*' )
		{
			sprintf( line, " %s", val );
			Data_Out( line , false);
		}
		Data_Out( "\n" , false);
	}
	else
	{
		errorWithInstance( "Unconnected pin", ti );
	}
}

/*---------- Diode Model ----------*/

static int Diode_Pins( TP_PTR tp )
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

	spiceorder = Get_TPA( tp, SPICEORDER );
	net = NetContainingPin( tp );
	if ( bCmd_Flat && net ) net = FindNetRoot( net );
	name = Get_TPA( tp, NAME );
	if ((strcmp( name, str1 ) == 0) || (strcmp( name, str2 ) == 0))
	{
		if ((strcmp( name, str1 ) == 0))
		{
			nets[0] = net;
		}
		if ((strcmp( name, str2 ) == 0))
		{
			nets[1] = net;
		}
	}
	else 
	{
		if ((strcmp( name, str1_old ) == 0) || (strcmp( name, str2_old ) == 0))
		{
			if ((strcmp( name, str1_old ) == 0))
			{
				nets[0] = net;
			}
			if ((strcmp( name, str2_old ) == 0))
			{
				nets[1] = net;
			}
		}
		else
		{
			if ((strcmp( name, str1_old2 ) == 0) || (strcmp( name, str2_old2 ) == 0))
			{
				if ((strcmp( name, str1_old2 ) == 0))
				{
					nets[0] = net;
				}
				if ((strcmp( name, str2_old2 ) == 0))
				{
					nets[1] = net;
				}
			}
			else	
			{
				if (*spiceorder != '\0')
				{
					index = atoi( spiceorder );
					nets[index-1] = net;
				}
			}
		}
	}
	/* Legacy
	if      ( *name == '+' ) nets[0] = net;
	else                     nets[1] = net;
	*/
	return( 0 );

}

/* Prefix = D */
static void Diode()
{
	char* val;

#if ( defined(LVS) || defined(PR) || defined(NTL) )
	char *tVal;
#endif // LVS

	char szVal[256];
	char szShrink[256];
	bool bSimPrimitive = true;

#if ( defined( PSPICE ) || defined( HSPICE ))
	char szSpiceModel[64];

	if ( *(val = Get_TIA( ti, SIM_LEVEL ) ) )
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
#endif // PSPICE or HSPICE

	ForEachInstancePin( ti, Diode_Pins );
	if ( nets[0] && nets[1] ) {
		Out_Nets( 2 );
#if ( defined(PSPICE) || defined(HSPICE) )
		/* SPICEMODEL */
		if ( *(val = Get_TIA( ti, SPICEMODEL ) ) && *val != '*' ) {
			if (bSimPrimitive)
			{
				sprintf( line, " %s", val );
			}
			else
			{
				strcpy(szSpiceModel, val);
				if ( *(val = Get_TIA( ti, SIM_LEVEL ) ) )
				{
					sprintf( line, " %s%s", szSpiceModel, val );
				}
				else
				{
					sprintf( line, " %s", szSpiceModel);
				}
			}
			Data_Out( line , false);
		}
#endif // PSPICE or HSPICE

		/* LVS_TYPE */
#if ( defined(LVS) || defined(PR) )
		if ( *(val = Get_TIA( ti, LVS_TYPE ) ) && *val != '*' )
		{
			sprintf( line, " %s", val );
			Data_Out( line , false);
		}
		else
		{
			if (*(tVal = Get_TIA( ti, LVS_REMOVE ) ) == NULL )
			{
				errorWithInstance("Missing LVS type attribute" , ti );
			}
		}
#endif // LVS

#if  defined(NTL)
		/* CELL */
		if ( *(val = Get_TIA( ti, CELL ) ) && *val != '*' ) {
			sprintf( line, " %s", val );
			Data_Out( line , false);
		}
		else {
			if (*(tVal = Get_TIA( ti, LVS_REMOVE ) ) == NULL ){ 
				sprintf( line, " DUMMY" );
				Data_Out( line , false);
			}
		}
#endif // LVS

		if ( *(val = Get_TIA( ti, MULTI ))) {
			if (bCmd_Shrink) {
				strcpy(szVal, val);
				val = Get_TIA( ti, SHRINK );
				strcpy(szShrink,val);
#if defined(PSPICE)
				sprintf( line, " {%s*%s*%s}",szVal,szShrink,szShrink);
#endif // PSPICE
#if defined(HSPICE)
				sprintf( line, " '%s*%s*%s'",szVal,szShrink,szShrink);
#endif // HSPICE
#if ( defined( LVS ) || defined(PR)  || defined(NTL))
				sprintf( line, " M='%s*%s*%s'",szVal,szShrink,szShrink);
#endif // LVS or PR	    
			}
			else {
#if ( defined( PSPICE ) || defined( HSPICE ))
				sprintf( line, " %s", val);
#endif // PSPICE
#if ( defined( LVS ) || defined(PR)  || defined(NTL))
				sprintf( line, " M=%s", val);
#endif // PSPICE
			}
			Data_Out( line , false);
		}

#if ( defined(LVS) || defined(PR) || defined(NTL) )
		/* DAREA */
		if (( *(val = Get_TIA( ti, DAREA ) ) && *val != '*' ) && bSimPrimitive)
		{
			if (bCmd_Shrink)
			{
				strcpy(szVal, val);
				val	= Get_TIA( ti, SHRINK );
				strcpy(szShrink,val);
				sprintf( line, " %s*%s*%s",szVal,szShrink,szShrink);
			}
			else
				sprintf( line, " %s", val);
			Data_Out( line , false);
		}
		/* DPERIM */
		if (( *(val = Get_TIA( ti, DPERIM ) ) && *val != '*' ) && bSimPrimitive)
		{
			if (bCmd_Shrink)
			{
				strcpy(szVal, val);
				val	= Get_TIA( ti, SHRINK );
				strcpy(szShrink,val);
				sprintf( line, " %s*%s",szVal,szShrink);
			}
			else
				sprintf( line, " %s", val);
			Data_Out( line , false);
		}
		/* DEFSUBSTRATE */
		if (( *(val = Get_TIA( ti, DEFSUBSTRATE ) ) && *val != '*' ) && bSimPrimitive)
		{
			sprintf( line, " $SUB=%s",  val );
			Data_Out( line , false);
		}
#endif // LVS


#if ( defined(PSPICE) || defined(HSPICE) )
		if (( *(val = Get_TIA( ti, SPICELINE ) ) && *val != '*' ) && bSimPrimitive )
		{
			sprintf( line, " %s", val );
			Data_Out( line , false);
		}
#endif // PSPICE or HSPICE

		/* SPICELINE3 */
		if ((*(val = Get_TIA( ti, SPICELINE3 ))) && !bSimPrimitive)
		{
#if defined(PSPICE)
			sprintf( line, " PARAMS: %s", val );
#endif //PSPICE
#if ( defined(HSPICE) || defined(LVS) || defined(PR) || defined(NTL) )
			sprintf( line, " %s", val );
#endif // HSPICE or LVS
		}
#if defined(NTL)
		/* APT LOCATION */
		if (*(val = Get_TIA( ti, 254 ))){
			sprintf( line, " X_LOC=%s Y_LOC=%s", LTCSimSplitXLoc( val ), LTCSimSplitYLoc( val ) );
			Data_Out( line , true);  
		}
#endif // NTL	
		Data_Out( "\n" , false);
	}
	else
	{
		errorWithInstance( "Unconnected pin", ti );
	}
}

                /*---------- Independent Source ----------*/

static int Ind_Source_Pins( TP_PTR tp )
{
  char* name;
  TN_PTR net;

  net = NetContainingPin( tp );
  if ( bCmd_Flat && net ) net = FindNetRoot( net );
  name = Get_TPA( tp, NAME );
  if      ( *name == '+' ) nets[0] = net;
  else                     nets[1] = net;
  return( 0 );
}

/* Prefix = I - Independent Current Source, V - Independent Voltage Source */
static void Independent_Source()
{
	char* val;

	ForEachInstancePin( ti, Ind_Source_Pins );

	if ( nets[0] && nets[1] )
	{
		Out_Nets( 2 );
		if ( *(val = Get_TIA( ti, VALUE ) ) && *val != '*' )
		{
			sprintf( line, " %s", val );
			Data_Out( line , false);
		}
		else if ( *val == '*' )
		{
			errorWithInstance( "Missing value attribute", ti );
		}


		if ( *(val = Get_TIA( ti, SPICELINE ) ) && *val != '*' )
		{
			sprintf( line, " %s",  val );
			Data_Out( line , false);
		}
		if ( *(val = Get_TIA( ti, SPICELINE2 ) ) && *val != '*' )
		{
			sprintf( line, " %s",  val );
			Data_Out( line , false);
		}
		Data_Out( "\n" , false);
	}
	else
	{
		errorWithInstance( "Unconnected pin", ti );
	}
}

                /*---------- V_Control_Source ----------*/

static int V_Control_Source_Pins( TP_PTR tp )
{
  char* name;
  TN_PTR net;

  net = NetContainingPin( tp );
  if ( bCmd_Flat && net ) net = FindNetRoot( net );
  name = Get_TPA( tp, NAME );
  if      ( *name == '+' ) nets[0] = net;
  else if ( *name == 'P' ) nets[2] = net;
  else if ( *name == 'N' ) nets[3] = net;
  else                     nets[1] = net;
  return( 0 );
}

/* Prefix = E - Voltage Controlled Voltage, G - Voltage Controlled Current */
static void V_Control_Source()
{
  char* val;

  ForEachInstancePin( ti, V_Control_Source_Pins );

  if ( nets[0] && nets[1] && nets[2] && nets[3] )
    {
      Out_Nets( 4 );
      if ( *(val = Get_TIA( ti, VALUE ) ) && *val != '*' )
	{
	  sprintf( line, " %s",  val );
	  Data_Out( line , false);
	}
      if ( *(val = Get_TIA( ti, SPICELINE ) ) && *val != '*' )
	{
	  sprintf( line, " %s", val );
	  Data_Out( line , false);
	}
      if ( *(val = Get_TIA( ti, SPICELINE2 ) ) && *val != '*' )
	{
	  sprintf( line, " %s", val );
	  Data_Out( line , false);
	}
      Data_Out( "\n" , false);
    }
  else
    {
      errorWithInstance( "Unconnected pin", ti );
    }
}

               /*---------- TwoPort Model ----------*/

static int TwoPort_Pins( TP_PTR tp )
{
  TN_PTR net;

  net = NetContainingPin( tp );
  if ( bCmd_Flat && net ) net = FindNetRoot( net );
  if ( nets[0] ) nets[1] = net;
  else           nets[0] = net;
  return( 0 );
}

/* Prefix = L - Inductor, R - Resistor */
static void TwoPort()
{
	char* val;
#if ( defined(LVS) || defined(PR) || defined(NTL) )
	char *tVal, *tVal1;
	char *szTempValName;
#endif // LVS

	ForEachInstancePin( ti, TwoPort_Pins );

	if ( nets[0] && nets[1] ) {
		Out_Nets( 2 );

#if (defined(HSPICE) || defined(PSPICE) )
		/* SPICEMODEL */
		if ( *(val = Get_TIA( ti, SPICEMODEL ) ) && *val != '*' ) {
			sprintf( line, " %s", val );
			Data_Out( line , false);
		}
		/* VALUE */
		if ( *(val = Get_TIA( ti, VALUE ) ) && *val != '*' ) {
			sprintf( line, " %s", val );
			Data_Out( line , false);
		}
		else if (*val == '*')
			errorWithInstance( "Missing value attribute", ti );
#endif // HSPICE or PSPICE

#if ( defined(LVS) || defined(PR) || defined(NTL) )
		/* VALUE */
		if ( *(val = Get_TIA( ti, VALUE ) ) && *val != '*' ) {
			if ( !LTCSimPassParamVal( val )) {
				szTempValName = new char[strlen(val) + 2];
				strcpy(szTempValName, val);
				if ( *( tVal1 = Get_TIA( ti, LVS_VALUE_DELTA )))
					sprintf( line, " %s*(1+(%s)/100)", szTempValName, tVal1);
				else
					sprintf( line, " %s", szTempValName);
				if ( *(tVal = Get_TIA( ti, LVS_SHORT ) ) && *element == 'R' && (*tVal == 'y' || *tVal =='Y') )
					sprintf( line, " %s", "0.01" );
			}
			else {
				szTempValName = new char[strlen(val) + 2];
				strcpy(szTempValName, LTCSimExtParam( val ));
				if ( *( tVal1 = Get_TIA( ti, LVS_VALUE_DELTA )))
					sprintf( line, " %s*(1+(%s)/100)", No_Blanks(szTempValName), tVal1);
				else
					sprintf( line, " %s", No_Blanks(szTempValName));
				if ( *(tVal = Get_TIA( ti, LVS_SHORT ) ) && *element == 'R' && (*tVal == 'y' || *tVal =='Y') )
					sprintf( line, " %s", "0.01" );
			}
			Data_Out( line , false);
		}
		else if ( *val == '*' ) 
			errorWithInstance( "Missing value attribute", ti );
#endif // LVS PR NTL

		/* LVS_TYPE */
#if ( defined(LVS) || defined(PR))
		if ( *(val = Get_TIA( ti, LVS_TYPE ) ) ) { 
			sprintf( line, " $[%s]", val );
			Data_Out( line , true);
		}
		else {
			if (((*(tVal = Get_TIA( ti, LVS_REMOVE ) ) == NULL ) &&
				(*(tVal1 = Get_TIA( ti, LVS_SHORT ) ) == NULL ))) {
					errorWithInstance( "Missing LVS type", ti );
			}
		}
#endif // LVS PR 

#if ( defined(NTL) )
		/* CELL */
		if ( *(val = Get_TIA( ti, CELL ) ) ) { 
			sprintf( line, " %s", val );
			Data_Out( line , true);
		}
		else { 
			if (*(tVal = Get_TIA( ti, LVS_REMOVE ) ) == NULL ){ 
				sprintf( line, " DUMMY" );
				Data_Out( line , false);
			}
		}
#endif //  NTL

		/* DEFSUBSTRATE */
#if ( defined(LVS) || defined(PR) || defined(NTL) )
		if ( *(val = Get_TIA( ti, DEFSUBSTRATE ) ) && *val != '*' ) {
			sprintf( line, " $SUB=%s", val );
			Data_Out( line , false);
		}
		else if ( *val == '?' )
			errorWithInstance( "Missing value", ti );
#endif // LVS PR NTL

		/* WIDTH */
#if ( defined(LVS) || defined(PR) || defined(NTL) )
		if (!( *(val = Get_TIA( ti, LVS_REMOVE ) ) && (*val == 'y' || *val =='Y') )) {
			if ( *(val = Get_TIA( ti, WIDTH ) ) && *val != '*' ) {
				if ( !LTCSimPassParamVal( val )) {
					if (bCmd_Shrink) {
						szTempValName = new char[strlen(val) + 2];
						strcpy(szTempValName, val);
						val = Get_TIA( ti, SHRINK );
						sprintf( line, " $W=%s*%s", szTempValName, val);
					}
					else
						sprintf( line, " $W=%s", val);
				}
				else {
					szTempValName = new char[strlen(val) + 2];
					strcpy(szTempValName, LTCSimExtParam( val ));
					if (bCmd_Shrink) {
						tVal = Get_TIA( ti, SHRINK );
						sprintf( line, " $W=%s*%s", No_Blanks(szTempValName),tVal);
					}
					else
						sprintf( line, " $W=%s", No_Blanks(szTempValName));
				}
				Data_Out( line , false);
			}
#endif // LVS PR NTL

			/* LENGTH */
#if ( defined(LVS) || defined(PR) || defined(NTL))
			if ( *(val = Get_TIA( ti, LENGTH ) ) && *val != '*' ) {
				if ( !LTCSimPassParamVal( val )) {
					if (bCmd_Shrink) {
						szTempValName = new char[strlen(val) + 2];
						strcpy(szTempValName, val);
						val = Get_TIA( ti, SHRINK );
						sprintf( line, " $L=%s*%s",szTempValName, val);
					}
					else
						sprintf( line, " $L=%s", val);
				}
				else {
					szTempValName = new char[strlen(val) + 2];
					strcpy(szTempValName, LTCSimExtParam( val ));
					if (bCmd_Shrink) {
						tVal = Get_TIA( ti, SHRINK );
						sprintf( line, " $L=%s*%s", No_Blanks(szTempValName),tVal);
					}
					else
						sprintf( line, " $L=%s", No_Blanks(szTempValName));
				}
				Data_Out( line , false);
			}
		}
#endif // LVS PR 
#    
		if ( *(val = Get_TIA( ti, MULTI ) ) && *val != '*' ) {
#if ( defined(PSPICE) || defined(LVS) || defined(PR) || defined(NTL) )
			errorWithInstance( "M not supported in PSpice or Dracula", ti );
#endif // PSPICE
#if defined(HSPICE)
			sprintf( line, " %s%s", szCmd_MultiCode, val );
			Data_Out( line , false);
#endif // HSPICE
		}

#if (defined(HSPICE) || defined(PSPICE) )
		if ( *(val = Get_TIA( ti, SPICELINE ) ) && *val != '*' ) {
			sprintf( line, " %s", val );
			Data_Out( line , false);
		}
		if ( *(val = Get_TIA( ti, SPICELINE2 ) ) && *val != '*' ) {
			sprintf( line, " %s", val );
			Data_Out( line , false);
		}
#endif // HSPICE or PSPICE
#if defined(NTL)
		/* APT LOCATION */
		if (*(val = Get_TIA( ti, 254 ))){
			sprintf( line, " X_LOC=%s Y_LOC=%s", LTCSimSplitXLoc( val ), LTCSimSplitYLoc( val ) );
			Data_Out( line , true);  
		}
#endif // NTL	
		Data_Out( "\n" , false);
	}
	else 
		errorWithInstance( "Unconnected pin", ti );
}
/*---------- Capacitor Model ----------*/

static int Capacitor_Pins( TP_PTR tp )
{
  char* name;
  TN_PTR net;
  char str1[]= "T1";
  char str1_old[] = "+";
  char str1_old2[] = "A";
  char str1_old3[] = "TP";
  char str2[]= "T2";
  char str2_old[] = "-";
  char str2_old2[] = "B";
  char str2_old3[] = "BP";
  int index;
  char* spiceorder;

  spiceorder = Get_TPA( tp, SPICEORDER );
  net = NetContainingPin( tp );
  if ( bCmd_Flat && net ) net = FindNetRoot( net );
  name = Get_TPA( tp, NAME );

  if ((strcmp( name, str1 ) == 0) || (strcmp( name, str2 ) == 0)) {
    if ((strcmp( name, str1 ) == 0)) 
      nets[0] = net;
    if ((strcmp( name, str2 ) == 0))
      nets[1] = net;
  }
  else {
    if ((strcmp( name, str1_old ) == 0) || (strcmp( name, str2_old ) == 0)) {
      if ((strcmp( name, str1_old ) == 0)) 
	nets[0] = net;
      if ((strcmp( name, str2_old ) == 0))
	nets[1] = net;
    }
    else {
      if ((strcmp( name, str1_old2 ) == 0) || (strcmp( name, str2_old2 ) == 0)) {
	if ((strcmp( name, str1_old2 ) == 0))
	  nets[0] = net;
	if ((strcmp( name, str2_old2 ) == 0))
	  nets[1] = net;
      }
      else {
	if ((strcmp( name, str1_old3 ) == 0) || (strcmp( name, str2_old3 ) == 0)) {
	  if ((strcmp( name, str1_old3 ) == 0))
	    nets[0] = net;
	  if ((strcmp( name, str2_old3 ) == 0))
	    nets[1] = net;
	}
	else {
	  if (*spiceorder != '\0') {
	    index = atoi( spiceorder );
	    nets[index-1] = net;
	  }
	}
      }
    }
  }
  return( 0 );
}

/* Prefix = C - Capacitor */
static void Capacitor()
{
	char *val;
	char *szTempValName;
	bool bSimPrimitive = true;
#if (defined(PSPICE) || defined(HSPICE))
	char szSpiceModel[256];
#endif // PSPICE or HSPICE

#if ( defined(LVS) || defined(PR) || defined(NTL) )
	char *tVal; 
	char *tVal1;
#endif

	char szVal[256];
	char szShrink[256];

	ForEachInstancePin( ti, Capacitor_Pins );

	if ( nets[0] && nets[1] ) {
		Out_Nets( 2 );

#if (defined(PSPICE) || defined(HSPICE))
		if ( *(val = Get_TIA( ti, SIM_LEVEL ) ) ) {
			if ((*val == 'N') || (*val == 'n') || (*val == '0'))
				bSimPrimitive = true;
			else
				bSimPrimitive = false;
		}
		else
			bSimPrimitive = true;
#endif // PSPICE or HSPICE

		/* SPICEMODEL */
#if ( defined(PSPICE) || defined(HSPICE) )
		if ( *(val = Get_TIA( ti, SPICEMODEL ) ) && *val != '*' ) {
			if (bSimPrimitive) 
				sprintf( line, " %s", val );
			else {
				strcpy(szSpiceModel, val);
				if ( *(val = Get_TIA( ti, SIM_LEVEL ) ) )
					sprintf( line, " %s%s", szSpiceModel, val );
				else
					sprintf( line, " %s", szSpiceModel);
			}
			Data_Out( line , false);
		}
#endif // PSPICE or HSPICE

		/* VALUE */
		if (( *(val = Get_TIA( ti, VALUE ) ) && *val != '*' ) && bSimPrimitive) {
			if ( !LTCSimPassParamVal( val )) {
				if (bCmd_Shrink) {
					strcpy(szVal, val);
					val = Get_TIA( ti, SHRINK );
					strcpy(szShrink,val);
#if defined(PSPICE)
					sprintf( line, " {%s*(%s*%s)}",szVal,szShrink,szShrink);
#endif // PSPICE
#if defined(HSPICE)
					sprintf( line, " '%s*(%s*%s)'",szVal,szShrink,szShrink);
#endif // HSPICE
#if ( defined(LVS) || defined(PR) || defined(NTL) )
					if ( *( tVal1 = Get_TIA( ti, LVS_VALUE_DELTA )))
						sprintf( line, " %s*%s*%s*(1+(%s)/100)",szVal,szShrink,szShrink,tVal1);
					else
						sprintf( line, " %s*%s*%s",szVal,szShrink,szShrink);
#endif // LVS
				}
				else {
					strcpy(szVal, val);
#if defined(PSPICE) || defined(HSPICE)
					sprintf( line, " %s", szVal);
				}
#endif
#if ( defined(LVS) || defined(PR) || defined(NTL) )
					if ( *( tVal1 = Get_TIA( ti, LVS_VALUE_DELTA )))
						sprintf( line, " %s*(1+(%s)/100)", LTCSimReplacePFByP( szVal ),tVal1);
					else
						sprintf( line, " %s", LTCSimReplacePFByP( szVal ));
				}
#endif
			}
			else { 
				szTempValName = new char[strlen(val) + 2];
				strcpy(szTempValName, LTCSimExtParam( val ));
				if (bCmd_Shrink) {
					val	= Get_TIA( ti, SHRINK );
#if defined(PSPICE)
					sprintf( line, " {%s*(%s*%s)}",No_Blanks(szTempValName),val,val);
#endif // PSPICE
#if defined(HSPICE)
					sprintf( line, " '%s*(%s*%s)'",No_Blanks(szTempValName),val,val);
#endif // HSPICE
#if ( defined(LVS) || defined(PR) || defined(NTL) )
					if ( *( tVal1 = Get_TIA( ti, LVS_VALUE_DELTA )))
						sprintf( line, " %s*%s*%s*(1+(%s)/100)",No_Blanks(szTempValName),val,val,tVal1);
					else
						sprintf( line, " %s*%s*%s",No_Blanks(szTempValName),val,val);

#endif // LVS
				}
				else {
#if defined(PSPICE)
					sprintf( line, " {%s}",No_Blanks(szTempValName));
#endif // PSPICE
#if defined(HSPICE)
					sprintf( line, " '%s'",No_Blanks(szTempValName));
#endif // HSPICE
#if ( defined(LVS) || defined(PR) || defined(NTL) )
					sprintf( line, " %s",No_Blanks(szTempValName));
#endif // LVS
				}
			}
			Data_Out( line , false);
		}
		else if ( *val == '*' ) 
			errorWithInstance( "Missing value", ti );

		/* LVS_TYPE */
#if ( defined(LVS) || defined(PR) )
		if (( *(val = Get_TIA( ti, LVS_TYPE ))) && bSimPrimitive) {
			sprintf( line, " $[%s]", val );
			Data_Out( line , true);
		}
		else {
			if (*(tVal = Get_TIA( ti, LVS_REMOVE ) ) == NULL )
				errorWithInstance( "Missing LVS type", ti );
		}
#endif // LVS PR 	

#if defined(NTL)
		/* CELL */
		if (( *(val = Get_TIA( ti, CELL ))) && bSimPrimitive) {
			sprintf( line, " %s", val );
			Data_Out( line , true);
		}
		else {
			if (*(tVal = Get_TIA( ti, LVS_REMOVE ) ) == NULL ){ 
				/*      errorWithInstance("Missing CELL attribute" , ti ); */
				sprintf( line, " DUMMY" );
				Data_Out( line , false);
			}
		}
#endif // NTL	


		/* SPICELINE */
#if ( defined(HSPICE) || defined(PSPICE))
		if (( *(val = Get_TIA( ti, SPICELINE ) ) && *val != '*' ) && bSimPrimitive) {
			sprintf( line, " %s", val );
			Data_Out( line , false);
		}
#endif // HSPICE or PSPICE

		/* DEFSUBSTRATE */
#if ( defined(LVS) || defined(PR) )
		if (( *(val = Get_TIA( ti, DEFSUBSTRATE ))) && bSimPrimitive) {
			sprintf( line, " $SUB=%s", val );
			Data_Out( line , false);
		}
#endif // LVS PR

		/* SPICELINE3 */
		if ((*(val = Get_TIA( ti, SPICELINE3 ))) && !( bSimPrimitive )) {
#if defined(PSPICE)
			sprintf( line, " PARAMS: %s", val );
#endif //PSPICE
#if ( defined(HSPICE) || defined(LVS) || defined(PR) || defined(NTL) )
			sprintf( line, " %s", val );
#endif // HSPICE or LVS
		}
#if defined(NTL)
		/* APT LOCATION */
		if (*(val = Get_TIA( ti, 254 ))){
			sprintf( line, " X_LOC=%s Y_LOC=%s", LTCSimSplitXLoc( val ), LTCSimSplitYLoc( val ) );
			Data_Out( line , true);  
		}
#endif // NTL	
		Data_Out( "\n" , false);
	}
	else
		errorWithInstance( "Unconnected pin", ti );
}


                   /*---------- SubCiruit ----------*/

#define MAX_PINS 512
static TP_PTR pins[MAX_PINS];
static int order_pins, pin_count;

static int SubCircuit_Pins( TP_PTR tp )
{
  int index;
  char* spiceorder;
  
  spiceorder = Get_TPA( tp, SPICEORDER );
  if ( !pin_count )        /* first pin determines whether order is required */
    order_pins = *spiceorder != '\0';
  else if ( order_pins != ( *spiceorder != '\0' ) )
    order_pins = -1;                    /* some pins have order, some don't */
  if ( order_pins == 0 )
    pins[pin_count++] = tp;
  else if ( order_pins == 1 ) {
    index = atoi( spiceorder );
    if ( index < 0 || index >= MAX_PINS )
      order_pins = -2;
    else {
      /* bus pins will all have the same number so look for the next slot */
      while ( pins[index] && index < MAX_PINS-1 ) index++;     /* bus pin? */
      pins[index] = tp;
      pin_count++;
    }
  }
  return( order_pins < 0 );
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

  strcpy( instname, inst );
  while ( szIllegalChar = strpbrk( instname, ".-[]()<>{}" )) {
    *szIllegalChar = '_';
  }
 
  /* either all or none of the pins must have SPICEORDER specified */
  for ( ii = 0; ii < MAX_PINS; ii++ ) pins[ii] = 0;
  pin_count = 0;
  order_pins = 0;
  ForEachInstancePin( ti, SubCircuit_Pins );
  td = DescriptorOfInstance( ti );
  if ( order_pins == -1 ) {
    sprintf( line, "Some pins on type = %s do not have spice order specified",Get_TDA( td, NAME ) );
    Error_Out( line );
  }
  else if ( order_pins == -2 ) {
    sprintf( line, "Incorrect pin ordering on type = %s",Get_TDA( td, NAME ) );
    Error_Out( line );
  }
  else {
    if ( bCmd_FilterPrefix && *element == *inst ) {
#if ( defined(LVS) || defined(PR) || defined(NTL) )
      if ( *(val = Get_TIA( ti, LVS_REMOVE ) ) && *val == 'y' || *val =='Y' )
	sprintf(line, "*%s", instname );
      else
	sprintf(line, "%s", instname );
#endif // LVS
#if (defined(HSPICE) || defined(PSPICE))
      sprintf( line, "%s", instname );
#endif // HSPICE or PSPICE
    }
    else {
#if ( defined(LVS) || defined(PR) || defined(NTL) )
      if ( *(val = Get_TIA( ti, LVS_REMOVE ) ) && *val == 'y' || *val =='Y' )
	sprintf( line, "*%s%s", element, instname );
      else
	sprintf(line, "%s%s", element, instname );
#endif // LVS
#if (defined(HSPICE) || defined(PSPICE))
      sprintf(line, "%s%s", element, instname );
#endif // HSPICE or PSPICE
    }
    Data_Out( line , false);
    if ( *element == 'U' ) {
      if ( !*(name = Get_TIA( ti, SPICEMODEL ) ) )
	name = Get_TDA( td, NAME );
      sprintf( line, " %s", name );
      if ( *(sim_level = Get_TIA( ti, SIM_LEVEL ) ) )
	sprintf( line, "%s%s", line, sim_level);
      Data_Out( line , false);
    }
    for ( ii = 0; pin_count > 0; ii++ ) {
      if ( pins[ii] ) {
	pin_count--;
	net = NetContainingPin( pins[ii] );
	if ( bCmd_Flat && net ) net = FindNetRoot( net );
	if ( net ) templ = Get_Net_Number( net );
	else templ = num_unconn++;
	if ( bCmd_Node_Names && !net )
	  sprintf( line, " UNC%ld", templ );
	else if ( bCmd_Node_Names && ( name = Get_Spice_Net_Name( net ) ) ) {
#if defined(PSPICE)
	  name = LTC_PSpice_Process_Net_Name( name );
	  sprintf( line, " %s", name );
#endif // PSPICE
#if ( defined(HSPICE) || defined(LVS) || defined(PR) || defined(NTL) )
	  sprintf( line, " %s", name );
#endif // HSPICE or LVS
	}
	else
	  sprintf( line, " %ld", templ );
	Data_Out( line , false);
      }
    }
    /* XDef_Tub */ 
    if ( *(val = Get_TIA( ti, XDEF_TUB ) ) ) 
      Out_XDef_Tub_Net();


    /* XDef_Sub */ 
    if ( *(val = Get_TIA( ti, XDEF_SUB ) ) ) 
      Out_XDef_Net();
    
    if ( *element == 'X' ) {
      /* SPICEMODEL */
      if ( !*(name = Get_TIA( ti, SPICEMODEL )))
	name = Get_TDA( td, NAME );
      sprintf( szSpiceModel, "%s", name );
#if (defined(PSPICE) || defined(HSPICE))
      if ( *(val = Get_TIA( ti, SIM_LEVEL ))) {
	if ((*val == 'N') || (*val == 'n') || (*val == '0'))
	  sprintf( line, " %s", szSpiceModel );
	else
	  sprintf( line, " %s%s", szSpiceModel, val );
      }
      else
	sprintf( line, " %s", szSpiceModel );
#endif // PSPICE	or HSPICE
#if ( defined(LVS) || defined(PR) || defined(NTL) )
      if ( *(val = Get_TIA( ti, LVS_LEVEL ))) {
	if ((*val == 'N') || (*val == 'n') || (*val == '0'))
	  sprintf( line, " %s", szSpiceModel );
	else
	  sprintf( line, " %s%s", szSpiceModel, val );
      }
      else
	sprintf( line, " %s", szSpiceModel );
#endif // LVS
      Data_Out( line , false);
      /* SPICELINE */
      if ( *(val = Get_TIA( ti, SPICELINE ) ) && *val != '*' ) {
#if defined(PSPICE)
	sprintf( line, " PARAMS: %s", val );
#endif // PSPICE
#if ( defined(HSPICE) || defined(LVS) || defined(PR) || defined(NTL) )
	sprintf( line, " %s", val );
#endif // HSPICE or LVS
	Data_Out( line , false);
      }
#if defined(NTL)
    /* APT LOCATION */
    if (*(val = Get_TIA( ti, 254 ))){
      sprintf( line, " X_LOC=%s Y_LOC=%s", LTCSimSplitXLoc( val ), LTCSimSplitYLoc( val ) );
      Data_Out( line , true);  
    }
#endif // NTL	
      Data_Out( "\n" , false);
    }
  }
}
         /*---------- Dummy Routine for unspecified prefix's ----------*/

static void Dummy()
{
  TD_PTR td;
  char* prefix;
  td = DescriptorOfInstance( ti );
  prefix = Get_TDA( td, PREFIX );
  
  /* Don't put this message out any more than necessary, keep the file small */
  if ( *prefix != *element ) {    /* instance override..Why did user do this?? */
    sprintf( line, "Invalid prefix on element %s%s",
	     bCmd_Flat ? "I = ." : "",
	     bCmd_Flat ? InstanceName( ti ) :
	     LocalInstanceName( ti ) );
    Error_Out( line );
  }
  else if ( ti == FirstInstanceOf( td ) ) {         /* only one error per type */
    sprintf( line, "Invalid prefix on symbol type = %s",
	     Get_TDA( td, NAME ) );
    Error_Out( line );
  }
}

/* Prefix = B - MESFET, M - MOSFET */
static void CacheFETTransNames()
{
  ForEachInstancePin( ti, FET_Pins );
  
  if ( nets[0] && nets[1] && nets[2] ) {
    //Out_Nets( 4 );
    //if ( !nets[3] ) Out_Def_Net();
    Add_Names_To_Flat_Cache(4);
  }
}

/* Prefix = J - JFET */
static void CacheJFETTransNames()
{
  ForEachInstancePin( ti, JFET_Pins );
  
  if ( nets[0] && nets[1] && nets[2] ) {
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
  ForEachInstancePin( ti, TwoPort_Pins );
  
  if ( nets[0] && nets[1] ) {
    //Out_Nets( 2 );
    Add_Names_To_Flat_Cache(2);
  }
}

/* Prefix = C - Capacitor */
static void CacheCapacitorNames()
{
  ForEachInstancePin( ti, Capacitor_Pins );
  
  if ( nets[0] && nets[1] ) {
    //Out_Nets( 2 );
    Add_Names_To_Flat_Cache(2);
  }
}

/* Prefix = D */
static void CacheDiodeNames()
{
  ForEachInstancePin( ti, Diode_Pins );
  
  if ( nets[0] && nets[1] ) {
    //Out_Nets( 2 );
    Add_Names_To_Flat_Cache(2);
  }
}

/* Prefix = E - Voltage Controlled Voltage, G - Voltage Controlled Current */
static void CacheVControlSrcNames()
{
  ForEachInstancePin( ti, V_Control_Source_Pins );
  
  if ( nets[0] && nets[1] && nets[2] && nets[3] ) {
    //Out_Nets( 4 );
    Add_Names_To_Flat_Cache(4);
  }
}

/* Prefix = I - Independent Current Source, V - Independent Voltage Source */
static void CacheIndSourceNames()
{
  ForEachInstancePin( ti, Ind_Source_Pins );
  
  if ( nets[0] && nets[1] ) {
    //Out_Nets( 2 );
    Add_Names_To_Flat_Cache(2);
  }
}

/* Prefix = Q */
static void CacheBipolarTransNames()
{
  ForEachInstancePin( ti, Bipolar_Pins );
  
  if ( nets[0] && nets[1] && nets[2] ) {
    //Out_Nets( 4 );
    //if ( !nets[3] ) Out_Def_Net();
    Add_Names_To_Flat_Cache(4);
  }
}

/* Prefix = T */
static void CacheTransLineNames()
{
  ForEachInstancePin( ti, XLine_Pins );
  
  if ( nets[0] && nets[1] && nets[2] && nets[3] ) {
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

static void (*Primitive[])() =
{
  Dummy,                          /* A -                                     */
  FET_Transistor,                 /* B - MESFET Device                       */
  Capacitor,                      /* C - Capacitor                           */
  Diode,                          /* D - Diode Device                        */
  V_Control_Source,               /* E - Voltage Controlled - Voltage Source */
  Dummy,                          /* F - Current Controlled - Current Source */
  V_Control_Source,               /* G - Voltage Controlled - Current Source */
  Dummy,                          /* H - Current Controlled - Voltage Source */
  Independent_Source,             /* I - Independent Current Source          */
  JFET_Transistor,                /* J - JFET Device                         */
  Dummy,                          /* K - Mutual Inductor                     */
  TwoPort,                        /* L - Inductor                            */
  FET_Transistor,                 /* M - MOSFET Device                       */
  Dummy,                          /* N -                                     */
  Dummy,                          /* O -                                     */
  Dummy,                          /* P -                                     */
  Bipolar_Transistor,             /* Q - BJT - Bipolar Junction Device       */
  TwoPort,                        /* R - Resistor                            */
  Dummy,                          /* S - Switch Device                       */
  Transmission_Line,              /* T - Transmission Line                   */
  Dummy,                          /* U - Uniform Distributed RC Line         */
  Independent_Source,             /* V - Independent Voltage Source          */
  Dummy,                          /* W -                                     */
  SubCircuit,                     /* X - Sub Circuit Call                    */
  Dummy,                          /* Y -                                     */
  Dummy                           /* Z -                                     */
};

static void (*FlatNameCache[])() =
{
  CacheDummyNames,                /* A -                                     */
  CacheFETTransNames,             /* B - MESFET Device                       */
  CacheCapacitorNames,            /* C - Capacitor                           */
  CacheDiodeNames,                /* D - Diode Device                        */
  CacheVControlSrcNames,          /* E - Voltage Controlled - Voltage Source */
  CacheDummyNames,                /* F - Current Controlled - Current Source */
  CacheVControlSrcNames,          /* G - Voltage Controlled - Current Source */
  CacheDummyNames,                /* H - Current Controlled - Voltage Source */
  CacheIndSourceNames,            /* I - Independent Current Source          */
  CacheJFETTransNames,            /* J - JFET Device                         */
  CacheDummyNames,                /* K - Mutual Inductor                     */
  CacheTwoPortNames,              /* L - Inductor                            */
  CacheFETTransNames,             /* M - MOSFET Device                       */
  CacheDummyNames     ,           /* N -                                     */
  CacheDummyNames,                /* O -                                     */
  CacheDummyNames,                /* P -                                     */
  CacheBipolarTransNames,         /* Q - BJT - Bipolar Junction Device       */
  CacheTwoPortNames,              /* R - Resistor                            */
  CacheDummyNames,                /* S - Switch Device                       */
  CacheTransLineNames,            /* T - Transmission Line                   */
  CacheDummyNames,                /* U - Uniform Distributed RC Line         */
  CacheIndSourceNames,            /* V - Independent Voltage Source          */
  CacheDummyNames,                /* W -                                     */
  CacheSubCircuitNames,           /* X - Sub Circuit Call                    */
  CacheDummyNames,                /* Y -                                     */
  CacheDummyNames                 /* Z -                                     */
};

int Do_Primitive( TI_PTR tii, char *prefix )
{
  int index, ii;
  
  /* Do_Primitive is for the Hierarchical Format ( bCmd_Flat == FALSE ) */
  for ( ii = 0; ii < MAX_NETS; ii++ ) nets[ii] = 0;
  ti = tii;       /* ti pointer and element placed in statics for all to use */
  element = prefix;
  inst = LocalInstanceName( ti );
  index = *element - 'A';
  if ( index >= 0 && index <= 25 ) {
#if defined(PSPICE)
    char ch = '\0';
    char *val;
    if ( bCmd_MixedSignal ) {
      if ( *( val = Get_TIA( ti, DIGITAL_EXTRACT ))) {
	ch = toupper( *val );
	if ( ch == 'Y' )
	  bDigitalMode = true;
	else
	  bDigitalMode = false;
      }
    }
#endif // PSPICE
    Primitive[ index ]();
  }
  else 
    Dummy();
  return( 0 );
}

static int Is_Valid_Prefix( char prefix )
{
  int index, retn = FALSE;
  index = prefix - 'A';
  if ( index >= 0 && index <= 25 && Primitive[ index ] != Dummy ) retn = TRUE;
  return( retn );
}

int Code_Primitives( TI_PTR ti_prim )
{
  int index, ii;
  char* prefix;
  TD_PTR td;
  
  /* Code_Primitives is for the Flattened Format ( bCmd_Flat == TRUE ) */
  for ( ii = 0; ii < MAX_NETS; ii++ ) nets[ii] = 0;
  ti = ti_prim;   /* ti pointer and element placed in statics for all to use */
  if ( *( prefix = Get_TIA( ti, PREFIX ) ) && Is_Valid_Prefix( *prefix ) ) {
    index = toupper( *prefix ) - 'A';
    sprintf( elembuf, "%c%ld", *prefix, InstanceNumber( ti_prim ) );
    element = elembuf;
    Primitive[ index ]();
  }
  else {                     /* Only print errors once for each type of symbol */
    td = DescriptorOfInstance( ti_prim );
    if ( ti == FirstInstanceOf( td ) ) {
      sprintf( line, "Error: Missing or invalid prefix code on symbol type = %s",
	       Get_TDA( td, NAME ) );
      Error_Out( line );
    }
  }
  return( 0 );
}

int Cache_Flat_Underscored_Names( TI_PTR ti_prim )
{
  int index, ii;
  char* prefix;

  /* Code_Primitives is for the Flattened Format ( bCmd_Flat == TRUE ) */
  for ( ii = 0; ii < MAX_NETS; ii++ ) nets[ii] = 0;
  ti = ti_prim;   /* ti pointer and element placed in statics for all to use */
  if ( *( prefix = Get_TIA( ti, PREFIX ) ) && Is_Valid_Prefix( *prefix ) ) {
    index = toupper( *prefix ) - 'A';
    sprintf( elembuf, "%c%ld", *prefix, InstanceNumber( ti_prim ) );
    element = elembuf;
    FlatNameCache[ index ]();
  }
  return( 0 );
}

void Add_Names_To_Flat_Cache(int nCount)
{
  for ( int ii = 0; ii < nCount; ii++ ) {
    if ( nets[ii] ) {
      char* name;
      if ( bCmd_Node_Names && ( name = NetName( nets[ii] ) ) ) {
	sprintf( line, " %s", name );

	char *szResult;
	if (*name == '.')
	  szResult = strpbrk(name, "-");
	
	if ((*name != '.' && strpbrk( name, "_" )) ||
	    (*name == '.' && strpbrk(szResult, "_"))) {
	  bool bNameAlreadyInCache = false;
	  char *szIllegalChar;
	  while ( szIllegalChar = strpbrk( name, ".-" ) )
	    *szIllegalChar = '_';

	  for (int i = 0; i < nMaxIndexCount; i++) {
	    if (!stricmp(name, UnderscoreNameCache[i])) {
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
  

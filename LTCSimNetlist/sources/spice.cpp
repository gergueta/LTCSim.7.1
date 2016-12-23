#include "spice.h"

Tcl_Interp *interp;

BOOL RegisteredXGNDXto0()
{
	BOOL rval = FALSE;
	HKEY hCU = NULL;
	if (ERROR_SUCCESS == RegOpenKeyEx(HKEY_CURRENT_USER, "Software\\LTC\\LTCsim\\ActiveProject", 0, KEY_QUERY_VALUE, &hCU))
	{
		DWORD type;
		char data[MAX_PATH];
		DWORD dataSz = MAX_PATH; memset(data, 0, MAX_PATH);
		if (ERROR_SUCCESS == RegQueryValueEx(hCU, "XGNDXto0", NULL, &type, (unsigned char *)&data, &dataSz))
		{
			if ((REG_SZ == type) && *data)
				rval = !strcmp("1", data);
		}
		RegCloseKey(hCU);
	}
	return(rval);
}

/*---------- ExtendNetBase ----------*/

static int ExtendNetBase() {
	int nMax = max_nets + 512;
	void* pTmp = realloc(net_tn, nMax * sizeof(TN_PTR));
	if (pTmp){
		max_nets = nMax;
		net_tn = (TN_PTR*)pTmp;
	}
	else
		MajorError("Insufficient memory to process design\nClose other processes");
	return(pTmp == NULL); /* abort if fail to alloc */
}

/* Get_Net_Number is coded differently in Flat version */
long Get_Net_Number(TN_PTR tn) {
	/* Finds the number of the given net, Hierarchical version */
	long ll;
	char* name;

	if (NetLocExtGbl(tn) == 2) {
		/* for global nets the tn's stored in the net_tn will be root tn's for
	   node 0 and other nodes if using .global, otherwise the tn's will be
	   local.  The parameter tn will be local unless it came from a FindNetNamed
	   which happens in looking for DEFSUBSTRATE.  So the only valid way to find
	   the net is by comparing the names. */
		name = NetName(tn);

		if (!_stricmp(name, "GND") && net_tn[0])
			ll = 0;
		else if (bCmd_Use_Globals) {
			for (ll = 1; ll < num_globals && _stricmp(name, NetName(net_tn[ll]));
				ll++);
				if (ll >= num_globals)
					ll = num_nets; /* failed to find it, BUG */
		}
		else {
			for (ll = num_globals; ll < num_nets && _stricmp(name, NetName(net_tn[ll]));
				ll++);
		}
	}
	else {
		for (ll = num_globals; ll < num_nets && tn != net_tn[ll];
			ll++);
	}
	if (ll >= num_nets) {
		sprintf(line, "Failed to find net (%lx) %s", tn, name);
		Error_Out(line);
	}
	return(ll);
}

/* Find_Net_Number_Of is coded differently in Flat version */
long Find_Net_Number_Of(char* name)
{
	/* Finds the number of the net with the given name, Hierarchical version */
	long ll;

	for (ll = num_nets - 1; ll >= 0 && net_tn[ll] &&
		_stricmp(name, NetName(net_tn[ll])); ll--);
		if (ll >= 0 && net_tn[ll] == 0)
			ll = -1; /* not found */
	return(ll);
}
/*---------- Code_Pin_BG ----------*/

static int Code_Pin_BG(TP_PTR tp) {
	TN_PTR tn;
	TG_PTR tg;

	long templ;
	char *name;

	tg = GenericPinOfPin(tp);

	if (_stricmp(Get_TGA(tg, NAME), "PWR") == 0) {
		if (tn = NetContainingPin(tp)) templ = Get_Net_Number(tn);
		else templ = num_unconn++;
		if (bCmd_Node_Names && !tn)
			sprintf(GATE_BP_NODE, "unc%ld", templ);
		else if (bCmd_Node_Names && (name = Get_Spice_Net_Name(tn)))
			sprintf(GATE_BP_NODE, " %s", name);
		else sprintf(GATE_BP_NODE, " %ld", templ);
	}
	if (_stricmp(Get_TGA(tg, NAME), "RTN") == 0) {
		if (tn = NetContainingPin(tp))
			templ = Get_Net_Number(tn);
		else
			templ = num_unconn++;

		if (bCmd_Node_Names && !tn)
			sprintf(GATE_BN_NODE, "unc%ld", templ);
		else if (bCmd_Node_Names && (name = Get_Spice_Net_Name(tn)))
			sprintf(GATE_BN_NODE, " %s", name);
		else sprintf(GATE_BN_NODE, " %ld", templ);
	}
	return(0);
}
/*---------- Code_Pin ----------*/

static int Code_Pin(TP_PTR tp) {
	/* List all non-global pins.  If not using globals list global pins
	 except GND.  For LVS list GND also */
	if (!GlobalPin(tp) || (!bCmd_Use_Globals && (bCmd_LVS || _stricmp(Get_TPA(tp, NAME), "GND")))) {
		long templ;
		TN_PTR tn;
		if (tn = NetContainingPin(tp))
			templ = Get_Net_Number(tn);
		else
			templ = num_unconn++; /* unconnected pin */
		char* name;
		if (bCmd_Node_Names && !tn)
			sprintf(line, " unc%ld", templ);
		else if (bCmd_Node_Names && (name = Get_Spice_Net_Name(tn)))
			sprintf(line, " %s", name);
		else sprintf(line, " %ld", templ);
		Data_Out(line, false);
	}
	return(0);
}

/*----------Do_Subcircuit-------------*/
static int Do_Subcircuit(TI_PTR ti) {
	TD_PTR td;

	char prefix[64], *name, *val, *tempName, ch = '\0';
	char sim_level[64];
	char tVal[256];
	char tName[256];

	td = DescriptorOfInstance(ti);
	bool fType = false;

	strcpy(prefix, Get_TIA(ti, PREFIX));
	strcpy(sim_level, Get_TIA(ti, SIM_LEVEL));
	name = LocalInstanceName(ti);

	char *szIllegalChar;
	while (szIllegalChar = strpbrk(name, ".-[]()<>{}")) {
		*szIllegalChar = '_';
	}
	switch (cCmd_Tool)
	{
	case 'l':
	case 'p':
	default:
		if (bCmd_MixedSignal && (toupper(*(val = Get_TIA(ti, DIGITAL_EXTRACT))) == 'Y')) {
			sprintf(line, "U%s", name);
			Data_Out(line, false);
			if (*(val = Get_TIA(ti, DIGITAL_PRIMITIVE))) {
				sprintf(line, " %s", val);
				Data_Out(line, false);
			}
			else {
				char msg[128];
				sprintf(msg, "Error:Digital primitive information not available on instance");
				errorWithInstance(msg, ti);
			}
		}
		else {
			if (bCmd_FilterPrefix && (('X' == *name) || ('x' == *name))) {
				sprintf(line, "%s", name);
				Data_Out(line, false);
			}
			else {
				if (bCmd_IgnoreCase)
					sprintf(line, "X%s", name);
				else
					sprintf(line, "x%s", name);
				Data_Out(line, false);
			}
		}
		break;
	case 'h':
		if (bCmd_FilterPrefix && (('X' == *name) || ('x' == *name))) {
			sprintf(line, "%s", name);
			Data_Out(line, false);
		}
		else {
			if (bCmd_IgnoreCase)
				sprintf(line, "X%s", name);
			else
				sprintf(line, "x%s", name);
			Data_Out(line, false);
		}
		break;
	case 'a':
	case 'd':
	case 't':
		if (*(val = Get_TIA(ti, LVS_REMOVE)) && (*val == 'y' || *val == 'Y')) {
			if (bCmd_FilterPrefix && (('X' == *name) || ('x' == *name))) {
				sprintf(line, "*%s", name);
				Data_Out(line, false);
			}
			else {
				if (bCmd_IgnoreCase)
					sprintf(line, "*X%s", name);
				else
					sprintf_s(buffer, line, "*x%s", name);
				Data_Out(line, false);
			}
		}
		else {
			if (bCmd_FilterPrefix && (('X' == *name) || ('x' == *name))) {
				sprintf(line, "%s", name);
				Data_Out(line, false);
			}
			else {
				if (bCmd_IgnoreCase)
					sprintf(line, "X%s", name);
				else
					sprintf(line, "x%s", name);
				Data_Out(line, false);
			}
		}
		break;
	}

	// PWR 
	if (*(val = Get_TIA(ti, PWR))) {
		switch (cCmd_Tool)
		{
		case 'l':
		case 'p':
		default:
			strcpy(tName, LTC_PSpice_Process_Net_Name(val));
			if (bCmd_MixedSignal && (toupper(*(val = Get_TIA(ti, DIGITAL_EXTRACT))) == 'Y'))
				sprintf(line, " %s", "$G_Dpwr");
			else
				sprintf(line, " %s", tName);
			break;
		case 'h':
		case 'a':
		case 'd':
		case 't':
			strcpy(tName, LTC_HSpice_Process_Net_Name(val));
			sprintf(line, " %s", tName);
			break;
		}
		fType = false;
		Data_Out(line, false);
	}
	else
		fType = true;

	// RTN
	if (*(val = Get_TIA(ti, RTN))) {
		switch (cCmd_Tool)
		{
		case 'l':
		case 'p':
		default:
			strcpy(tName, LTC_PSpice_Process_Net_Name(val));
			if (bCmd_MixedSignal && (toupper(*(val = Get_TIA(ti, DIGITAL_EXTRACT))) == 'Y'))
				sprintf(line, " %s", "$G_Dgnd");
			else
				sprintf(line, " %s", tName);
			break;;
		case 'h':
		case 'a':
		case 'd':
		case 't':
			strcpy(tName, LTC_HSpice_Process_Net_Name(val));
			sprintf(line, " %s", tName);
			break;
		}
		Data_Out(line, false);
	}

	// GATE_BP				
	switch (cCmd_Tool)
	{
	case 'l':
	case 'p':
	default:
		if ((!bCmd_MixedSignal) || (bCmd_MixedSignal && ((toupper(*(val = Get_TIA(ti, DIGITAL_EXTRACT))) == 'N') || !(*(val = Get_TIA(ti, DIGITAL_EXTRACT)))))) {
			if (*(val = Get_TIA(ti, GATE_BP))) {
				if (_stricmp(val, "GATE_BP") == 0) {
					if (!fType) {
						tempName = LTC_PSpice_Process_Net_Name(Get_TIA(ti, PWR));
						sprintf(line, " %s", tempName);
					}
					else {
						strcpy(GATE_BP_NODE, "\0");
						strcpy(GATE_BN_NODE, "\0");
						ForEachInstancePin(ti, Code_Pin_BG);
						sprintf(line, " %s", GATE_BP_NODE);
					}
				}
				else {
					if (_stricmp(val, "PASS_GATE_BP") == 0){
						sprintf(line, "%s", " GATE_BP");
					}
					else {
						tempName = LTC_PSpice_Process_Net_Name(val);
						sprintf(line, " %s", tempName);
					}
				}
				Data_Out(line, false);
			}
		}
		break;
	case 'h':
	case 'a':
	case 'd':
	case 't':
		if (*(val = Get_TIA(ti, GATE_BP))) {
			if (_stricmp(val, "GATE_BP") == 0) {
				if (!fType) {
					char *cTemp = new char[256];
					cTemp = LTC_HSpice_Process_Net_Name(Get_TIA(ti, PWR));
					tempName = LTC_HSpice_Process_Net_Name(Get_TIA(ti, PWR));
					sprintf(line, " %s", tempName);
				}
				else {
					strcpy(GATE_BP_NODE, "\0");
					strcpy(GATE_BN_NODE, "\0");
					ForEachInstancePin(ti, Code_Pin_BG);
					sprintf(line, " %s", GATE_BP_NODE);
				}
			}
			else {
				if (_stricmp(val, "PASS_GATE_BP") == 0){
					sprintf(line, "%s", " GATE_BP");
				}
				else {
					tempName = LTC_HSpice_Process_Net_Name(val);
					sprintf(line, " %s", tempName);
				}
			}
			Data_Out(line, false);
		}
		break;
	}

	//GATE_BN				
	switch (cCmd_Tool)
	{
	case 'l':
	case 'p':
	default:
		if ((!bCmd_MixedSignal) || (bCmd_MixedSignal && ((toupper(*(val = Get_TIA(ti, DIGITAL_EXTRACT))) == 'N') || !(*(val = Get_TIA(ti, DIGITAL_EXTRACT)))))) {
			if (*(val = Get_TIA(ti, GATE_BN))) {
				if (_stricmp(val, "GATE_BN") == 0) {
					if (!fType) {
						tempName = LTC_PSpice_Process_Net_Name(Get_TIA(ti, RTN));
						sprintf(line, " %s", tempName);
					}
					else {
						strcpy(GATE_BP_NODE, "\0");
						strcpy(GATE_BN_NODE, "\0");
						ForEachInstancePin(ti, Code_Pin_BG);
						sprintf(line, " %s", GATE_BN_NODE);
					}
				}
				else {
					if (_stricmp(val, "PASS_GATE_BN") == 0){
						sprintf(line, "%s", " GATE_BN");
					}
					else {
						tempName = LTC_PSpice_Process_Net_Name(val);
						sprintf(line, " %s", tempName);
					}
				}
				Data_Out(line, false);
			}
		}
		break;
	case 'h':
	case 'a':
	case 'd':
	case 't':
		if (*(val = Get_TIA(ti, GATE_BN))) {
			if (_stricmp(val, "GATE_BN") == 0) {
				if (!fType) {
					tempName = LTC_HSpice_Process_Net_Name(Get_TIA(ti, RTN));
					sprintf(line, " %s", tempName);
				}
				else {
					strcpy(GATE_BP_NODE, "\0");
					strcpy(GATE_BN_NODE, "\0");
					ForEachInstancePin(ti, Code_Pin_BG);
					sprintf(line, " %s", GATE_BN_NODE);
				}
			}
			else {
				if (_stricmp(val, "PASS_GATE_BN") == 0){
					sprintf(line, "%s", " GATE_BN");
				}
				else {
					tempName = LTC_HSpice_Process_Net_Name(val);
					sprintf(line, " %s", tempName);
				}
			}
			Data_Out(line, false);
		}
		break;
	}

	ForEachInstancePin(ti, Code_Pin);

	// XDEF_TUB
	if (*(val = Get_TIA(ti, XDEF_TUB))) {
		switch (cCmd_Tool)
		{
		case 'l':
		case 'p':
		default:
			tempName = LTC_PSpice_Process_Net_Name(val);
			break;
		case 'h':
		case 'a':
		case 'd':
		case 't':
			tempName = LTC_HSpice_Process_Net_Name(val);
			break;
		}
		sprintf(line, " %s", tempName);
		Data_Out(line, false);
	}

	// XDEF_SUB
	if (*(val = Get_TIA(ti, XDEF_SUB))) {
		switch (cCmd_Tool)
		{
		case 'l':
		case 'p':
		default:
			tempName = LTC_PSpice_Process_Net_Name(val);
			break;
		case 'h':
		case 'a':
		case 'd':
		case 't':
			tempName = LTC_HSpice_Process_Net_Name(val);
			break;
		}
		sprintf(line, " %s", tempName);
		Data_Out(line, false);
	}

	switch (cCmd_Tool)
	{
	case 'l':
	case 'p':
	default:
		if (bCmd_MixedSignal && toupper(*(val = Get_TIA(ti, DIGITAL_EXTRACT))) == 'Y') {
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
				sprintf(line, " MNTYMXDLY=%s", val);
				Data_Out(line, false);
			}

			if (*(val = Get_TIA(ti, DIGITAL_IO_LEVEL))) {
				sprintf(line, " IO_LEVEL=%s", val);
				Data_Out(line, false);
			}
		}
		else {
			if (!*(tempName = Get_TIA(ti, SPICEMODEL))) tempName = Get_TDA(td, NAME);
			sprintf(line, " %s", tempName);
			Data_Out(line, false);

			if (*(val = Get_TIA(ti, MULTI)) && *val != '*') {
				sprintf(line, " %s%s", szCmd_MultiCode, val);
				Data_Out(line, false);
			}
		}
		break;
	case 'h':
	case 'a':
	case 'd':
	case 't':
		if (!*(tempName = Get_TIA(ti, SPICEMODEL))) tempName = Get_TDA(td, NAME);
		sprintf(line, " %s", tempName);
		Data_Out(line, false);

		if (*(val = Get_TIA(ti, MULTI)) && *val != '*') {
			sprintf(line, " %s%s", szCmd_MultiCode, val);
			Data_Out(line, false);
		}
		break;
	}

	// Spiceline
	if (*(val = Get_TIA(ti, SPICELINE)) && *val != '*') {
		sprintf(tVal, " %s", val);
		switch (cCmd_Tool)
		{
		case 'l':
		case 'p':
		default:
			if ((!bCmd_MixedSignal) || (bCmd_MixedSignal && ((toupper(*(val = Get_TIA(ti, DIGITAL_EXTRACT))) == 'N') || !(*(val = Get_TIA(ti, DIGITAL_EXTRACT)))))) {
				sprintf(line, " params: %s", tVal);
				Data_Out(line, false);
			}
			break;
		case 'h':
		case 'a':
		case 'd':
		case 't':
			sprintf(line, " %s", tVal);
			Data_Out(line, false);
			break;
		}
	}

	//APT location
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
	return(0);
}

/*---------- Code_Sub_Block ----------*/

static int Code_Sub_Block(TI_PTR ti)
{
	TD_PTR td;

	char prefix[20];
	char ch = '\0';
	char sim_level[64];

	td = DescriptorOfInstance(ti);
	bool fType = false;

	strcpy(prefix, Get_TIA(ti, PREFIX));
	strcpy(sim_level, Get_TIA(ti, SIM_LEVEL));


	if (*prefix) ch = toupper(*prefix);

	if (PrimitiveCell(td) && ch) {
		Do_Primitive(ti, prefix);
	}
	else
	{
		/* instance of a lower level block */
		if (PrimitiveCell(td)) {
			sprintf(line, "Missing prefix code on symbol type %s",
				Get_TDA(td, NAME));
			Error_Out(line);
		}
		Do_Subcircuit(ti);
	}
	return(0);
}

/*---------- Number_Local_Nets ----------*/

static int Number_Local_Nets(TN_PTR tn)
{
	int abort = FALSE;
	if (NetLocExtGbl(tn) == 0) {
		/* only save LOCAL's */
		CHECK_NET_MEM(num_globals + num_pins + num_locals + 1);
		net_tn[num_globals + num_pins + num_locals++] = tn;
	}
	return(abort);
}

/*---------- Number_Externals ----------*/

static int Number_Externals(TN_PTR tn) {
	int abort = FALSE;
	/* number externals and if not using .global, all globals except GND */
	if (NetLocExtGbl(tn) == 1 || /* its an external net */
		(NetLocExtGbl(tn) == 2 && /* or its a global */
		!bCmd_Use_Globals && /* and we're not using .global */
		_stricmp(NetName(tn), "GND"))) /* & ! GND */
	{
		CHECK_NET_MEM(num_globals + num_pins + 1);
		net_tn[num_globals + num_pins++] = tn;
	}
	return(abort);
}

/*---------- Number_Pins ----------*/

static int Number_Pins(TP_PTR tp) {
	int abort = FALSE;
	TN_PTR tn;
	/* Number only the pins that are represented by nets */
	tn = NetDefinedByPin(tp);
	if (tn) abort = Number_Externals(tn);
	return(abort);
}

//////////
static int List_Instance_Pin(TP_PTR tp) {
	char *szName;
	TN_PTR tn;
	tn = NetContainingPin(tp);
	if (tn) {
		szName = NetName(tn);
	}
	else {
		return(FALSE);
	}

	if (strpbrk(szName, "_")) {
		bool bNameAlreadyInCache = false;
		char **UnderscoreNameCache = SubCircuits[nSubCircuitIndex];

		for (int i = 0; i < *(SubCircuitMaxIndexCount[nSubCircuitIndex]); i++) {
			if (!_stricmp(szName, UnderscoreNameCache[i])) {
				bNameAlreadyInCache = true;
				break;
			}
		}

		if (!bNameAlreadyInCache) {
			if (UnderscoreNameCache == NULL) {
				UnderscoreNameCache = new char*[nMaxCachedItems];
			}
			else if (*(SubCircuitMaxIndexCount[nSubCircuitIndex]) == nMaxCachedItems) {
				char **y = new char*[nMaxCachedItems * 2];
				for (int i = 0; i < nMaxCachedItems; i++) {
					*(y + i) = *(UnderscoreNameCache + i);
				}
				delete UnderscoreNameCache;
				UnderscoreNameCache = y;
				nMaxCachedItems *= 2;
			}
			SubCircuits[nSubCircuitIndex] = UnderscoreNameCache;
			char *pszTemp = new char[strlen(szName) + 1];
			strcpy(pszTemp, szName);
			*(UnderscoreNameCache + *(SubCircuitMaxIndexCount[nSubCircuitIndex])) = pszTemp;
			(*(SubCircuitMaxIndexCount[nSubCircuitIndex]))++;
		}
	}
	return(FALSE);
}

static int List_Sub(TI_PTR ti)
{
	ForEachInstancePin(ti, List_Instance_Pin);
	return(FALSE);
}

static int Check_Block_Net(TN_PTR tn)
{
	char *szName;
	if (NetLocExtGbl(tn) == EXTERNAL_NET) {
		szName = NetName(tn);
		if (strpbrk(szName, "_")) {
			; //No-op
		}
	}
	return(FALSE);
}
/*---------- Cache_Underscored_Names ----------*/
static int Cache_Underscored_Names(TD_PTR td) {
	int abort = FALSE;
	int i;
	TI_PTR ti;
	char *szName;
	szName = Get_TDA(td, NAME);

	if (SubCircuitNames == NULL) {
		SubCircuitNames = new char*[nMaxNumSubCircuits];
		SubCircuitMaxIndexCount = new int*[nMaxNumSubCircuits];
		SubCircuits = new char**[nMaxNumSubCircuits];
		for (i = 0; i < nMaxNumSubCircuits; i++) {
			//Ensure that pointers are NULL for this is how
			//to tell whether or not a cache eventually needs
			//to be created
			SubCircuits[i] = NULL;
		}
	}
	else if (nMaxSubCircuitIndexCount == nMaxNumSubCircuits) {
		char ***x = new char**[nMaxNumSubCircuits * 2];
		char **y = new char*[nMaxNumSubCircuits * 2];
		int **z = new int*[nMaxNumSubCircuits * 2];

		for (i = 0; i < nMaxNumSubCircuits; i++) {
			x[i] = SubCircuits[i];
		}

		for (i = nMaxNumSubCircuits; i < nMaxNumSubCircuits * 2; i++) {
			//Ensure that pointers for the newly expanded array
			//slots get set to NULL for this is how to tell 
			//whether or not a cache eventually needs to be created
			x[i] = NULL;
		}

		for (i = 0; i < nMaxNumSubCircuits; i++) {
			y[i] = SubCircuitNames[i];
		}

		for (i = 0; i < nMaxNumSubCircuits; i++) {
			z[i] = SubCircuitMaxIndexCount[i];
		}

		delete SubCircuits;
		delete SubCircuitNames;
		delete SubCircuitMaxIndexCount;
		SubCircuits = x;
		SubCircuitNames = y;
		SubCircuitMaxIndexCount = z;
		nMaxNumSubCircuits *= 2;
	}

	char *pszTemp = new char[strlen(szName) + 1];
	int *pszIntTemp = new int[1];
	*pszIntTemp = 0;
	strcpy(pszTemp, szName);
	//nSubCircuitIndex is used to keep the current index for other routines
	nSubCircuitIndex = nMaxSubCircuitIndexCount;
	SubCircuitMaxIndexCount[nSubCircuitIndex] = pszIntTemp;
	SubCircuitNames[nSubCircuitIndex] = pszTemp;
	//Increment count so the next subcircuit will be put in the
	//next slot in the array
	nMaxSubCircuitIndexCount++;

	ti = FirstInstanceOf(td);
	if (!ti) ForEachBlockNet(td, Check_Block_Net);
	ForEachSubBlock(td, List_Sub);
	return(abort);
}

/*----------  Code_Block  ----------*/

static int Code_Block(TD_PTR td) {

	int abort = FALSE;
	TI_PTR ti;
	long ll;
	char *name, *val;
	bool fType = false;

	/* This is for the definition of the block or .subckt */

	num_pins = 0; /* each pin on the block represents a net, number them */

	ti = FirstInstanceOf(td);
	name = Get_TDA(td, NAME);
	if (szCurrentSubCircuitName != NULL) {
		delete szCurrentSubCircuitName;
	}
	szCurrentSubCircuitName = new char[strlen(name) + 1];
	strcpy(szCurrentSubCircuitName, name);

	if ((bCmd_Macro && ti) || td != Root_TD) {
		/* generate a macro block */
		Data_Out("***\n", false);
		if (!bCmd_IgnoreCase)
			sprintf(line, ".subckt %s", Get_TDA(td, NAME));
		else
			sprintf(line, ".SUBCKT %s", Get_TDA(td, NAME));
		Data_Out(line, false);

		/* code a list of the pin names */
		abort = ForEachInstancePin(ti, Number_Pins);
		if (!abort) {
			int bPrintNames = false;
			if (!bCmd_Use_Globals)
				ll = 0; /* list all globals */
			else
				ll = num_globals;
			if (*(val = Get_TDA(td, PWR))) {
				if (bCmd_IgnoreCase)
					strcpy(line, " PWR");
				else
					strcpy(line, " pwr");
				Data_Out(line, false);
				if (*(val = Get_TDA(td, RTN))) {
					if (bCmd_IgnoreCase)
						strcpy(line, " RTN");
					else
						strcpy(line, " rtn");
					Data_Out(line, false);
				}
				fType = false;
			}
			else
				fType = true;
			if (*(val = Get_TDA(td, GATE_BP))) {
				switch (cCmd_Tool)
				{
				case 'l':
				case 'p':
					sprintf(line, " %s", LTC_PSpice_Process_Net_Name(val));
					break;
				case 'h':
				case 'a':
				case 'd':
				case 't':
					sprintf(line, " %s", val);
					break;
				}
				Data_Out(line, false);
			}
			if (*(val = Get_TDA(td, GATE_BN))) {
				switch (cCmd_Tool)
				{
				case 'l':
				case 'p':
					sprintf(line, " %s", LTC_PSpice_Process_Net_Name(val));
					break;
				case 'h':
				case 'a':
				case 'd':
				case 't':
					sprintf(line, " %s", val);
					break;
				}
				Data_Out(line, false);
			}
			for (; ll < num_globals + num_pins; ll++) {
				/* skip GND if it does not exist on this block */
				if (ll == 0 && !FindPinWithAttribute(ti, NAME, "GND"));
				else if (bCmd_Node_Names && (name = Get_Spice_Net_Name(net_tn[ll]))) {
					sprintf(line, " %s", name);
					Data_Out(line, false);
				}
				else {
					sprintf(line, " %ld", ll);
					Data_Out(line, false);
					bPrintNames = true;
				}
			}
			if (*(val = Get_TDA(td, SPICELINE2)) && *val != '*') {
				/* The old code used to write SPICELINE2 on a separate line.
							Some users inserted a plus sign in SPICELINE2 to work around
							this.  So we skip a leading plus sign */
				if (*val == '+')
					val++;
				switch (cCmd_Tool)
				{
				case 'l':
				case 'p':
					sprintf(line, " params: %s", val);
					break;
				case 'h':
				case 'a':
				case 'd':
				case 't':
					sprintf(line, " %s", val);
					break;
				default:
					sprintf(line, " params: %s", val);
					break;
				}
				Data_Out(line, false);
			}
			Data_Out("\n", false);
			if (bPrintNames) {
				/* list the pin names as a comment */
				In_Comment(1);
				Data_Out("* PIN NAMES", false);
				if (!bCmd_Use_Globals)
					ll = 1; /* list all globals except GND */
				else
					ll = num_globals;
				for (; ll < num_globals + num_pins; ll++) {
					/* skip GND if it does not exist on this block */
					if (ll == 0 && !FindPinWithAttribute(ti, NAME, "GND"));
					else {
						sprintf(line, " %s", NetName(net_tn[ll]));
						Data_Out(line, false);
					}
				}
				In_Comment(0);
				Data_Out("\n", false);
			}
		}
	}
	else {
		Data_Out("* Main network description\n", false);
		if (bCmd_Macro) {
			sprintf(line, "Missing symbol for %s", szRootName);
			Error_Out(line);
		}
		/* comment a list of the external pin numbers and names */
		abort = ForEachBlockNet(Root_TD, Number_Externals);
		if (!abort) {
			// TODO:  Fix this to list names of globals that may be renamed
			// even in case of bCmd_Node_Names.
			if (!bCmd_Node_Names && num_pins) {
				In_Comment(1);
				Data_Out("* EXTERNAL NAMES", false);
				for (ll = num_globals; ll < num_globals + num_pins; ll++) {
					name = NetName(net_tn[ll]);
					sprintf(line, " %ld=%s", ll, name);
					Data_Out(line, false);
				}
				In_Comment(0);
				Data_Out("\n", false);
			}
		}
	}
	if (!abort) {
		num_locals = 0;
		abort = ForEachBlockNet(td, Number_Local_Nets);
	}
	if (!abort) {
		switch (cCmd_Tool)
		{
		case 'l':
		case 'p':
		case 'h':
		case 'a':
		case 'd':
		case 't':
			num_unconn = num_nets = num_globals + num_pins + num_locals;
			/* generate the code for each sub_block */
			ForEachSubBlock(td, Code_Sub_Block);
			break;
			/*
			case 't':
			if (!(*(val = Get_TDA( td, DIGITAL_STDCELL )) == 'Y')) {
			num_unconn = num_nets = num_globals + num_pins + num_locals;
			ForEachSubBlock( td, Code_Sub_Block );
			}
			break;
			*/
		}
	}
	if ((bCmd_Macro && ti) || td != Root_TD) {
		/* coded this one as a SUBCKT */
		if (bCmd_IgnoreCase)
			sprintf(line, ".ENDS %s\n", Get_TDA(td, NAME));
		else
			sprintf(line, ".ends %s\n", Get_TDA(td, NAME));
		Data_Out(line, false);
	}
	return(abort);
}

/*---------- Do_Modeled_Types ----------*/

static int Do_Modeled_Types(TD_PTR td) {
	/* if a primitive (or block if !use primitives )
	 has a PREFIX of 'X' or SIM_PREFIX of 'N', look for a .p/.h/.l/ .a file */
	char *pVal;
	char *dfVal;
	char *spVal;
	char *temp;

	switch (cCmd_Tool)
	{
	case 'l':
	case 'p':
		pVal = Get_TDA(td, PREFIX);
		dfVal = Get_TDA(td, DIGITAL_FILE);
		spVal = Get_TDA(td, SIM_PREFIX);
		temp = Get_TDA(td, NAME);
		if (!bCmd_MixedSignal) {
			if ((!bCmd_PrimitiveLevel || PrimitiveCell(td)) && ((*pVal == 'X') || (*spVal == 'N'))) {
				if (Merge_Macro_File(Get_TDA(td, NAME)))
					MarkBlockDone(td);
				else {
					char msg[128];
					sprintf(msg, "Error: macro file %s.p not found", Get_TDA(td, NAME));
					error_count = error_count + 1;
					Error_Out(msg);
				}
			}
		}
		else {
			if ((!bCmd_PrimitiveLevel || PrimitiveCell(td)) && ((*pVal == 'X') || (*spVal == 'N'))) {
				if (Merge_Macro_File(Get_TDA(td, NAME)))
					MarkBlockDone(td);
			}
			else {
				if (*dfVal == 'Y') {
					Merge_Digital_Macro_File(Get_TDA(td, NAME));
					MarkBlockDone(td);
				}
			}
		}
		break;
	case 'h':
		if ((!bCmd_PrimitiveLevel || PrimitiveCell(td)) && ((*Get_TDA(td, PREFIX) == 'X') || (*Get_TDA(td, SIM_PREFIX) == 'N'))) {
			if (Merge_Macro_File(Get_TDA(td, NAME)))
				MarkBlockDone(td);
			else {
				char msg[128];
				sprintf(msg, "Error: macro file %s.h not found", Get_TDA(td, NAME));
				error_count = error_count + 1;
				Error_Out(msg);
			}
		}
		break;
	case 'a':
	case 'd':
	case 't':
		if ((!bCmd_PrimitiveLevel || PrimitiveCell(td)) && ((*Get_TDA(td, PREFIX) == 'X') || (*Get_TDA(td, SIM_PREFIX) == 'N'))) {
			if (Merge_Macro_File(Get_TDA(td, NAME)))
				MarkBlockDone(td);
			else {
				char msg[128];
				sprintf(msg, "Error: macro file %s.l not found", Get_TDA(td, NAME));
				error_count = error_count + 1;
				Error_Out(msg);
			}
		}
		break;
	default:
		break;
	}
	return(0);
}

/*---------- Do_Global_Net ----------*/

static int Do_Global_Net(const char* name) {
	int abort = FALSE;
	TN_PTR tn;
	if ((tn = FindNetNamed(name)) && tn != net_tn[0]) {
		CHECK_NET_MEM(num_globals + 1);
		net_tn[num_globals++] = tn;
	}
	return(abort);
}

/*---------- List_Globals ----------*/

static void List_Globals() {
	long ll, first_global = 1;
	LTCUtils ltcUtility;

	net_tn[0] = FindNetNamed("GND"); /* Node zero is reserved for GND */
	if (net_tn[0] && NetLocExtGbl(net_tn[0]) != 2) {
		sprintf(line, "gnd not defined as a GlobalNet.");
		Error_Out(line);
	}
	num_globals = 1;

	if (bCmd_Use_Globals) {
		ForEachGlobalNetName(Do_Global_Net);
		switch (cCmd_Tool)
		{
		case 'h':
			if (bCmd_IgnoreCase)
				Data_Out(".GLOBAL", false);
			else
				Data_Out(".global", false);
			break;
		case 'l':
		case 'p':
		case 'a':
		case 'd':
		case 't':
			if (bCmd_IgnoreCase)
				Data_Out("**.GLOBAL", false);
			else
				Data_Out("**.global", false);
			break;
		}
		if (net_tn[0]) first_global = 0;
		if (bCmd_Node_Names) {
			for (ll = first_global; ll < num_globals; ll++) {
				sprintf(line, " %s", _strdup(NetName(net_tn[ll])));
				/*
						CString sTemp;
						sTemp = CString(line);
						if( !bCmd_IgnoreCase ) sTemp.MakeLower();
						*/
				char* cTemp = new char[256];
				strcpy(cTemp, line);
				String^ sTemp = ltcUtility.LtcCharsToString(cTemp);
				sTemp = sTemp->ToLower();
				/* to verify if this works*/
				strcpy_s(line, sTemp->Length + 1, ltcUtility.LtcStringToChars(sTemp));
				Data_Out(line, false);
			}
			Data_Out("\n", false);
		}
		else {
			for (ll = first_global; ll < num_globals; ll++) {
				sprintf(line, " %ld", ll);
				Data_Out(line, false);
			}
			Data_Out("\n", false);
			In_Comment(1);
			Data_Out("* global names", false);
			for (ll = first_global; ll < num_globals; ll++) {
				sprintf(line, " %s", NetName(net_tn[ll])); Data_Out(line, false);
			}
			Data_Out("\n", false);
			In_Comment(0);
		}
	}
	ltcUtility.~LTCUtils();
}

void FreeAllocatedMemory(void) {
	int ii;
	//free memory used for caching names with underscores
	for (ii = 0; ii < nMaxNumSubCircuits; ii++) {
		if (SubCircuits[ii] != NULL) {
			char **UnderscoreNameCache = SubCircuits[ii];
			for (int j = 0; j < *(SubCircuitMaxIndexCount[ii]); j++) {
				delete UnderscoreNameCache[j];
			}
			delete UnderscoreNameCache;
		}
	}
	//free memory used for subcircuit names
	for (ii = 0; ii < nMaxSubCircuitIndexCount; ii++) {
		delete SubCircuitNames[ii];
	}
	delete SubCircuitNames;

	//free memory used for indexing into the caches
	/* Creates problems with a block without subblocks */
	/*
		for (ii = 0; ii < *(SubCircuitMaxIndexCount[ii]); ii++)
		{
		delete SubCircuitMaxIndexCount[ii];
		}
		*/
	delete SubCircuitMaxIndexCount;

	//free memory for the current subcircuit name
	delete szCurrentSubCircuitName;
	//free memory used to hold the new name if a clash is found
	if (szNewName != NULL) {
		delete szNewName;
	}
}

int LTCSim_List_Type(TD_PTR td){
	char *sPrefix;
	char *sName;

	sPrefix = Get_TDA(td, PREFIX);
	sName = Get_TDA(td, NAME);
	if (PrimitiveCell(td))
		fprintf(file, "%s: %s\n", sPrefix, sName);
	return(FALSE);
}

int LTCSim_List_Type2(TD_PTR td)
{
	char *sPrefix;
	char *sName;
	LTCUtils ltcUtility;

	sPrefix = Get_TDA(td, PREFIX);
	sName = Get_TDA(td, NAME);
	if (PrimitiveCell(td))
	{
		String^ sTemp = String::Format("{0}: {1}\n", ltcUtility.LtcCharsToString(sPrefix), ltcUtility.LtcCharsToString(sName));
		fprintf_s(file, ltcUtility.LtcStringToChars(sTemp));
	}
	ltcUtility.~LTCUtils();
	return(FALSE);
}

void Process(int argc, char *argv[]) {
	int ii, abort = 0;
	int notepad = FALSE;
	FILE *patfile;
	char cFileNameA[_MAX_PATH], cTimeA[64];
	char *cFileNameB = new char[_MAX_PATH];
	long length;
	char *cExtP;
	String^ sExt;
	char *test;

	//cExtP = sExtension;
	/* check the arguments for program options and file extension */
	LTCXmlUtils ltcXmlUtility;
	LTCUtils ltcUtility;

	for (ii = 1; ii < argc; ii++)
	{
		if (*argv[ii] == '-')
		{
			if (!strnicmp(argv[ii], "-p=", 3))
			{
				String^ projectXmlFileName = gcnew String(argv[ii]);
				projectXmlFileName = projectXmlFileName->Substring(3);
				FileInfo ^fi = gcnew FileInfo(projectXmlFileName);
				if (fi->Exists)
				{
					IntPtr ptrToNativeString = Marshal::StringToHGlobalAnsi(projectXmlFileName);
					char* nativeString = static_cast<char*>(ptrToNativeString.ToPointer());
					int iTemp = ltcXmlUtility.readLTCSimXmlParameters(projectXmlFileName);
					sExt = ltcXmlUtility.LTCSetFileExtension();
				}
				else
				{
					char *msg = "Error: Project.xml file not found!";
					MajorError(msg);
				}
			}
			if (!strnicmp(argv[ii], "-ext=.", 6))
				cExtP = argv[ii] + 5;
			if (!strnicmp(argv[ii], "-view", 5))
				notepad = TRUE;
			if (!strnicmp(argv[ii], "-sim", 4))
				bCmd_Simulate = 1;
		}
	}

	/* setup the parameters for the output file processing */
	max_line_len = 78;
	line_len = 78;
	continue_str = "\n+";
	comment_continue_str = "\n*";
	begin_error_str = "*** ";

	error_count = 0; /* counts calls to Error_Out */

	/* open the file used by Data_Out */
	strcpy(cFileNameA, szRootName);
	String^ sFileNameA = gcnew String(cFileNameA);
	sFileNameA = sFileNameA + sExt;
	cExtP = ltcUtility.LtcStringToChars(sExt);
	AddExt(cFileNameA, cExtP);
	strlwr(FileInPath(cFileNameA));
	file = fopen(cFileNameA, "w");
	//CString sHeaderFileName = getFileName( CString( cFileNameA ));
	String^ sHeaderFileName = ltcUtility.LtcCharsToString(cFileNameA);


	char szErrFileName[_MAX_PATH];
	strcpy(szErrFileName, szRootName);
	AddExt(szErrFileName, ".err");
	errorFile = fopen(szErrFileName, "w");

	if (file) {
		char szTitle[50];
		GetProductName(szTitle, sizeof(szTitle));
		char szVersion[30];
		GetProductVersion(szVersion, sizeof(szVersion));
		switch (cCmd_Tool)
		{
		case 'l':
			sprintf(line, "* LTC LTspice Netlist %s - %s Version %s\n", NETLIST_VER, szTitle, szVersion);
			break;
		case 'p':
			sprintf(line, "* LTC PSpice Netlist %s - %s Version %s\n", NETLIST_VER, szTitle, szVersion);
			break;
		case 'h':
			sprintf(line, "* LTC HSpice/LTSpice Netlist %s - %s Version %s\n", NETLIST_VER, szTitle, szVersion);
			break;
		case 'a':
			sprintf(line, "* LTC Assura Netlist %s - %s Version %s\n", NETLIST_VER, szTitle, szVersion);
			break;
		case 'd':
			sprintf(line, "* LTC Dracula Netlist %s - %s Version %s\n", NETLIST_VER, szTitle, szVersion);
			break;
		case 't':
			sprintf(line, "* LTC APT Netlist %s - %s Version %s\n", NETLIST_VER, szTitle, szVersion);
			break;
		default:
			sprintf(line, "* LTC LTspice Netlist %s - %s Version %s\n", NETLIST_VER, szTitle, szVersion);
			break;
		}
		Data_Out(line, false);
		if (bCmd_IgnoreCase){
			sprintf(line, "* Warning: Ignore-case option used!\n");
			Data_Out(line, false);
		}
		GetIntlDateTimeString(cTimeA);
		// sprintf( line, "* %s - %s\n*\n", cFileNameA, cTimeA );
		int iTemp = sHeaderFileName->LastIndexOf("\\");
		sprintf(line, "* %s - %s\n*\n", ltcUtility.LtcStringToChars(sHeaderFileName->Substring(iTemp + 1)), cTimeA);
		Data_Out(line, false);

		switch (cCmd_Tool)
		{
		case 'd':
			Merge_Dracula_Header_File(szRootName);
			break;
		case 'a':
			Merge_Assura_Header_File(szRootName);
			break;
		}
		/* allocate memory for the max number of nets in a block */
		if (net_tn = (TN_PTR*)calloc(max_nets, sizeof(TN_PTR))) {
			List_Globals();

			SortPinsByOrder(SPICEORDER);

			//First pass - cache any names that use underscores
			SetupBlockScan(); /* prepare for bottom up hierarchical scan */
			/* read in .spi files for Primitives with PREFIX = 'X' */
			ForEachDescriptor(Do_Modeled_Types);

			ForEachBlock(Cache_Underscored_Names);

			//Second pass - write netlist
			SetupBlockScan(); /* prepare for bottom up hierarchical scan */
			/* read in .spi files for Primitives with PREFIX = 'X' */
			ForEachDescriptor(Do_Modeled_Types);

			interp = Tcl_CreateInterp();
			ForEachBlock(Code_Block);
			Tcl_DeleteInterp(interp);

			fseek(file, 0L, SEEK_END);
			length = ftell(file);
			fclose(file);
			fclose(errorFile);
			if (error_count) {
				char szBadFileName[_MAX_PATH];
				strcpy(szBadFileName, szRootName);
				AddExt(szBadFileName, ".bad");
				MoveFile(cFileNameA, szBadFileName);
				DeleteFile(cFileNameA);
				DisplayErrors(szErrFileName);
			}
			else {
				/* process the users pattern file to replace names in quotes with
					 the corresponding number.  This will only work because the last
					 block processed is always the top level block so names get
					 mapped properly */
				if (!bCmd_Node_Names) {
					sprintf(cFileNameA, "%s.spp", szRootName);
					strlwr(FileInPath(cFileNameA));
					if (patfile = fopen(cFileNameA, "r"))
						Process_Pattern_File(patfile);
				}
				if (notepad) {
					sprintf(cFileNameA, "%s%s", szRootName, cExtP);
					LaunchEditor(cFileNameA);
				}
				AddExt(cFileNameA, ".err");
				if (_access(cFileNameA, 00) == 0) {
					//err file exist?
					DeleteFile(cFileNameA);
				}
				AddExt(cFileNameA, ".bad");
				if (_access(cFileNameA, 00) == 0) {
					//err file exist?
					DeleteFile(cFileNameA);
				}
				if (bCmd_Simulate) {
					String ^Stim = gcnew String(ltcUtility.LtcCharsToString(sStim));
					String ^Options = gcnew String(ltcUtility.LtcCharsToString(sOptions));
					String ^Command = gcnew String(ltcUtility.LtcCharsToString(sCommand));
					ltcUtility.LTCStartSimulation(Command, Options, Stim);
				}
				if (bCmd_PrimitiveReport)
				{
					strcpy(sReportFileName, szRootName);
					AddExt(sReportFileName, ".list");
					strlwr(FileInPath(sReportFileName));
					ltcUtility.LTCGenerateList(sReportFileName);
					if (notepad)
						LaunchViewer(sReportFileName);
				}
			}
			if (net_tn) {
				free(net_tn);
				net_tn = NULL;
			}

			FreeAllocatedMemory();
		}
		else
			MajorError("Not enough memory to process design");
	}
	ltcUtility.~LTCUtils();
}



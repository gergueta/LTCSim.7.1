#pragma once
#include <stdafx.h>
#include "pikproc.h"
#include "dataout.h"
/*
#include "atlstr.h"
*/
#include "LTCUtils.h"
#include "LTCXmlUtils.h"
#include <string>
#include <cstring>

using namespace System;
using namespace System::IO;
using namespace System::Xml;
using namespace System::Runtime::InteropServices;
using namespace LTCSimNetlist;

using namespace std;
#using <mscorlib.dll>
#include <tchar.h>
#include "Windows.h"

#using <System.dll>
#using <System.xml.dll>



extern char szCmd_MultiCode[];

#define NETLIST_VER "7.0"
unsigned int feature_code = 0;
unsigned int feature_version = 0;
unsigned long ProcRequiredLicBit = 0xFFFFFFFF;
unsigned long ProcRequiredVersion = 0;

int  bCmd_Macro = FALSE;
int bCmd_Node_Names = FALSE;
int bCmd_Use_Globals = FALSE;
int  bCmd_LVS = FALSE;
int  bCmd_FilterPrefix;
int  bCmd_Units = TRUE; 
int  bCmd_Flat = FALSE;
int  bCmd_PrimitiveLevel = 0;
int  bCmd_XGNDXto0 = FALSE;
int  bCmd_GNDto0 = FALSE;
int  bCmd_Shrink = FALSE;
int  bCmd_WLRes = FALSE;
int  bCmd_WLBip = FALSE;
int  bCmd_AreaBip = FALSE;
int  bCmd_MixedSignal = FALSE;
int bCmd_VerilogA = FALSE;
//extern char cCmd_Tool;
int bCmd_Simulate;
char *sLTspiceSyntax = new char[24];
int bCmd_PrimitiveReport;
char *sLVSShort = new char[512];
int bCmd_IgnoreCase = FALSE;
int iLtspiceSyntax;

long num_unconn;

static long num_locals, num_globals, num_pins, num_nets;
static long max_nets = 2048;
static TN_PTR* net_tn;
extern int nMaxCachedItems = 128;
int nSubCircuitIndex = 0;
extern char *szNewName;

extern char **SubCircuitNames;
extern char ***SubCircuits;
extern int **SubCircuitMaxIndexCount;
extern char *szCurrentSubCircuitName;
int nMaxNumSubCircuits = 1024;
extern int nMaxSubCircuitIndexCount;
extern char *element;
extern FILE *errorFile;

#define CHECK_NET_MEM( amt ) if ( amt > max_nets ) \
   abort = ExtendNetBase(); if ( abort ) return( abort );

/* external functions */
int Merge_Macro_File(char*);
int Merge_Dracula_Header_File(char*);
int Merge_Assura_Header_File(char*);
int Merge_Digital_Macro_File(char*);
int Do_Primitive(TI_PTR, char *);
void Process_Pattern_File(FILE *);
char* Get_Spice_Net_Name(TN_PTR);
char* LTC_HSpice_Process_Net_Name(char *);
char* LTC_PSpice_Process_Net_Name(char *);
char* szGlobalPinNames[1024];
int Merge_Header_File(char*);
int Merge_Dracula_Header_File(char*);
int Merge_Assura_HeaderFile(char*);
char* LTCSimReplacePFByP(char *value);
char* LTCSimSplitXLoc(char *value);
char* LTCSimSplitYLoc(char *value);

/* public functions */
long Get_Net_Number(TN_PTR tn);
long Find_Net_Number_Of(char *name);
char GATE_BP_NODE[256], GATE_BN_NODE[256];
extern char *determineFullInstPath(TI_PTR ti);
extern void errorWithInstance(char *string, TI_PTR ti);
char *ProgramName = "LTCSimNetlist.exe";
char *sCommand = new char[512];
char *sOptions = new char[512];
char *sBracketSubstitutionLeft = new char[24];
char *sBracketSubstitutionRight = new char[24];
char *sStim = new char[512];
char *sWorkingDir = new char[512];
char *sArguments = new char[512];
char *sReportFileName = new char[_MAX_FNAME];
char buffer[500];
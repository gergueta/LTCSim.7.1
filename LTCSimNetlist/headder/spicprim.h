#include <stdafx.h>
#include "LTCUtils.h"
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
extern char *sLVSShort;
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

extern long num_globals;
bool bDigitalMode = false;

char cCmd_Tool;
extern FILE *errorFile;

extern char* sBracketSubstitutionLeft;
extern char* sBracketSubstitutionRight;
extern int bCmd_IgnoreCase;
using namespace LTCSimNetlist;
extern char buffer[];
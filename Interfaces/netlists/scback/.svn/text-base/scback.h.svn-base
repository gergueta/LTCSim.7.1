/* back.h -- Include for PCB back annotation */

/*  Copyright 1993 Xilinx Coporation, 2000 Cohesion Systems, inc. All Rights Reserved.
 *
 * This program is protected under the copyright laws as a published work.
 * It may not be copied, reproduced, further distributed, adaptations
 * made from the same, or used to prepare derivative works, without the
 * prior written consent of Cohesion Systems, inc
 *
 * History:
 *    8/04/95 - Included in Version 2.8
 */

//#define MAX_PINS 768
#define MAX_PINS 100
#define MAX_GATES 100


typedef struct _pinref
{
	char name[12];
	char number[12];
} pinref;

typedef struct _swap
 { SI_PTR number;                                          /* Instance Number */
   char refdes[12];        /* hope this is long enough for the longest refdes */
 } SWAP;


typedef struct _swapg
 { SI_PTR number;                                          /* Instance Number */
   char refdes[12];        /* hope this is long enough for the longest refdes */
	pinref* pinList; 
	int pinCount;
	int pinMax;
 } SWAPG;

typedef struct _swapp
 { SI_PTR number;                                          /* Instance Number */
	char refdes[12]; 
 } SWAPP;

extern SWAP* Swaps;
extern unsigned long swap_hwm, max_swap;

extern SWAPG* SwapG;
extern unsigned long swapg_hwm, max_swapg;

extern SWAPP* SwapP;
extern unsigned long swapp_hwm, max_swapp;

extern int ChangeInst( char *attribute, char *name, char *value, int lineno );
extern int ChangeNet( char *attribute, char *name, char *value, int lineno );
extern int ChangePin( char *attribute, char *name, char *value, int lineno );
extern int Rename( char *name1, char *name2, int lineno );
extern int SwapPins( char *name, char *pin1, char *pin2, int lineno );
extern int SwapSection( char *gate1, char *gate2, char sect_delim, int lineno );
extern int GetWord( char **cptr, char *word );
extern int SwapGates( char* gate1, char* gate2, char* pinlist, int lineno );
extern int ChangeInstByNum( int atnum, char* name, char* value, int lineno );
extern int ChangeSymAttrByNum(int AttrNum, char *RefName, char *Value, int LineNum);
extern int ChangeNetAttrByNum( int atnum, char *name, char *value, int lineno );
extern SI_PTR FindInstanceNamed( char* name );
extern int BeginRename();
extern int EndRename();
extern int BeginMoveGates();
extern int EndMoveGates();
extern int BeginMovePins();
extern int EndMovePins();

extern int IsLetter(char c);
extern int IsNumber(char c);
extern int IsWhiteSpace(char c);
extern int IsNull(char c);
extern int IsGateRef(char *RefName);
extern int MoveGate(char *GateRef1, char *GateRef2, int LineNum);
extern int MovePin( char *Ref, char *Pin1Ref, char *Pin2Ref, int LineNum );
extern int MovePinInGate( char *GateRef, char *Pin1Ref, char *Pin2Ref, int LineNum );

extern int GetWord( char** cptr, char* word );

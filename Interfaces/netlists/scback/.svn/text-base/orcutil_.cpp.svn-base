#include "stdafx.h"
#include <string.h>
#include "spikproc.h"
#include "scback.h"


int IsLetter(char c)
{
	if( (c >= 'A') && (c <= 'Z') )
	{
		return TRUE;
	}
	
	if( (c >= 'a') && (c <= 'z') )
	{
		return TRUE;
	}

	return FALSE;
}

int IsNumber(char c)
{
	if( (c >= '0') && (c <= '9') )
	{
		return TRUE;
	}

	return FALSE;
}

int IsWhiteSpace(char c)
{
	if(c < 33)
	{
		return TRUE;
	}

	return FALSE;
}

int IsNull(char c)
{
	if(c == '\0')
	{
		return TRUE;
	}
	
	return FALSE;
}

int IsGateRef(char *RefName)
{
	if(RefName == NULL)
	{
		return FALSE;
	}
	
	if(!IsLetter(*RefName))
	{
		return FALSE;
	}

	while(IsLetter(*RefName))
	{
		RefName++;
	}
	
	if(!IsNumber(*RefName))
   {
   	return FALSE;
   }
   
	while(IsNumber(*RefName))
	{
		RefName++;
	}
	
	if(!IsLetter(*RefName))
	{
		return FALSE;
	}
	
	RefName++;

	if(IsNull(*RefName))
	{
		return TRUE;
	}
	
	return FALSE;	
}

typedef
struct _pininst
{
	SI_PTR GateInstPtr;
	int IsCommon;
	int GateNum;
	int GateType;
} pininst;


SWAPG *SwapG;
unsigned long swapg_hwm, max_swapg = 100;

SWAPP *SwapP;
unsigned long swapp_hwm, max_swapp = 100;

static char theRef[64];
static SI_PTR theInstPtr;
static SP_PTR thePinPtr;
static pininst thePinList[MAX_PINS];
static char thePinListRef[64];
static SI_PTR thePinListInstPtr;
static int theGateType;


static int CheckGatePin(SP_PTR spptr, PN_PTR pnptr, struct _pin *sptr)
{
	char buffer[64];
	char plist[256], *plistptr;
	int PinNum, TempPin;
	int GateNum;
	
   strcpy(buffer, Get_PA( spptr, PINNUM ));
   
	PinNum = atoi(buffer) - 1;

	if((PinNum < 0) || (PinNum >= MAX_PINS))
	{
		return FALSE;
	}

	if(thePinList[PinNum].IsCommon == TRUE)
	{
		return FALSE;
	}
	
	if(thePinList[PinNum].GateInstPtr != (SI_PTR)0)
	{
		thePinList[PinNum].GateInstPtr = (SI_PTR)0;
		thePinList[PinNum].IsCommon = TRUE;
		return FALSE;
	}
	
	thePinList[PinNum].GateInstPtr = thePinListInstPtr;					
	thePinList[PinNum].GateType = theGateType;					

   strcpy(plist, Get_PNA( pnptr, PINNUM ) );  
	plistptr = plist;
  
	GateNum = 1;

	while(GetWord( &plistptr, buffer ))
	{
		TempPin = atoi(buffer) - 1;
	
		if((TempPin < 0) || (TempPin >= MAX_PINS))
		{
			return FALSE;
		}

		if(thePinList[TempPin].IsCommon == FALSE)
		{
		   if(TempPin == PinNum)
		   {
				if(thePinList[TempPin].GateNum == 0)
				{
					thePinList[TempPin].GateNum = GateNum;
				}
				else
				{
					thePinList[TempPin].GateNum = 0;					
					thePinList[TempPin].GateType = 0;					
					thePinList[TempPin].GateInstPtr = (SI_PTR)0;
					thePinList[TempPin].IsCommon = TRUE;
				}
		   }
			else 
			{
				if((thePinList[TempPin].GateType == theGateType) && (thePinList[TempPin].GateNum != 0) && (thePinList[TempPin].GateNum != GateNum) )
				{
					thePinList[TempPin].GateNum = 0;					
					thePinList[TempPin].GateType = 0;					
					thePinList[TempPin].GateInstPtr = (SI_PTR)0;
					thePinList[TempPin].IsCommon = TRUE;
				}

				thePinList[TempPin].GateType = theGateType;					
			}			
		}

		GateNum++;
	}


	return FALSE;
}

static int CheckGateInstance(SI_PTR iptr, struct _inst *sptr)
{
 	if ( strcmp( thePinListRef, GetRefDesignator( iptr ) ) == 0 )
	{
		theGateType++;
		thePinListInstPtr = iptr;
	 	ForEachInstancePin( iptr, CheckGatePin );
	}
	
	return FALSE;
}


int BuildPinList(char *RefName)
{
	int i;
   
	strncpy(thePinListRef, RefName, 64);

	theGateType = 0;

   for(i=0; i<MAX_PINS; i++)
   {
   	thePinList[i].GateInstPtr = (SI_PTR)0;
   	thePinList[i].GateNum = 0;
   	thePinList[i].IsCommon = FALSE;
		thePinList[i].GateType = 0;
   }		

   ForEachSymbolInstance( 0, (ST_PTR) NULL, CheckGateInstance );

	return TRUE;
}

int FindGateInstPtr( char *GateRef, SI_PTR *InstPtr )
{
	int GateTypeList[MAX_GATES];
	int GateTypeCount;

	int i, j, GateCount, GateNum;
	int TotalGateCount;
	int LastGateType;
   int LastGateNum;

	strncpy(theRef, GateRef, 64);
	GateNum = theRef[strlen(theRef)-1] - 'A';
	theRef[strlen(theRef)-1] = '\0';   

	BuildPinList(theRef);
		
	GateCount = 0;
	TotalGateCount = 0;
	GateTypeCount = 0;
	LastGateType = 0;
	LastGateNum = 0;
	
   for(i=0; i<MAX_PINS; i++)
   {
		/* only check the pins that haven't been marked as common and that have been assigned a type */

		if((thePinList[i].IsCommon == FALSE) && (thePinList[i].GateType != 0))
		{
         for(j=0; (j<GateTypeCount) && (GateTypeList[j] != thePinList[i].GateType); j++)
         {
         }
         
         if(j==i)
         {
				GateTypeList[GateTypeCount++] = thePinList[i].GateType;
         }

			if(thePinList[i].GateType != LastGateType)
			{
				LastGateType = thePinList[i].GateType;
				TotalGateCount += GateCount;
				LastGateNum = 0;
				GateCount = 0;
			}				

			if(thePinList[i].GateNum != LastGateNum)
			{
				LastGateNum = thePinList[i].GateNum;
				GateCount++;
			}

			if(TotalGateCount + GateCount - 1 == GateNum)
			{
				if(thePinList[i].GateInstPtr != (SI_PTR)0)
				{
					*InstPtr = thePinList[i].GateInstPtr;
					return TRUE;
				}					
				
				return FALSE;
			}
		}			
   }		

   return FALSE;
}

static int CheckInstance(SI_PTR iptr, struct _inst *sptr)
{
 	if ( strcmp( theRef, GetRefDesignator( iptr ) ) == 0 )
	{
		theInstPtr = iptr;
	}
	
	return FALSE;
}

int FindInstPtr( char *Ref, SI_PTR *InstPtr )
{	
	strncpy(theRef, Ref, 64);

	theInstPtr = (SI_PTR) 0; // was == in v4.1 - jesse

   ForEachSymbolInstance( 0, (ST_PTR) NULL, CheckInstance );
	
   if(theInstPtr == (SI_PTR) 0 )
   {
   	return FALSE;
   }

	*InstPtr = theInstPtr;
		
   return TRUE;
 }

static int CheckPin(SP_PTR spptr, PN_PTR pnptr, struct _pin *sptr )
{ 
	char temp[256];

   if ( strcmp( theRef, Get_SPA( spptr, pnptr, PINNAME ) ) == 0 )
   {
		strcpy(temp, Get_PA(spptr, PINNUM));
   	thePinPtr = spptr;
   	return TRUE;
   }

   return FALSE;
}

int FindPinPtr(SI_PTR InstPtr, char *PinRef, SP_PTR *PinPtr)
{
	ST_PTR stptr;
	strncpy(theRef, PinRef, 64);

   stptr = TypeOfInstance( InstPtr );
   Activate_Symbol_Type( stptr);
	
	thePinPtr = (SP_PTR) 0;

   ForEachInstancePin( InstPtr, CheckPin );
	
   if(thePinPtr == (SP_PTR) 0)
   {
   	return FALSE;
   }
   
	*PinPtr = thePinPtr;
	
	return TRUE;   	
}

int GetPinNum(SP_PTR PinPtr, char *PinNum)
{
	SI_PTR InstPtr;
	ST_PTR stptr;

	if(!(InstPtr = InstanceContainingPin(PinPtr)))
	{
		return FALSE;
	}

   stptr = TypeOfInstance( InstPtr );
   Activate_Symbol_Type( stptr);

	strcpy(PinNum, Get_SPA(PinPtr,0, PINNUM));
	
	return TRUE;
}	

static int CheckPinGroups(SP_PTR Pin1Ptr, SP_PTR Pin2Ptr)
{
	SI_PTR InstPtr;
	ST_PTR stptr;

	if(!(InstPtr = InstanceContainingPin(Pin1Ptr)))
	{
		return FALSE;
	}
	
	if(InstanceContainingPin(Pin2Ptr) != InstPtr)
	{
		return FALSE;
	}

   stptr = TypeOfInstance( InstPtr );
   Activate_Symbol_Type( stptr);

	if(strcmp(Get_SPA(Pin1Ptr, 0, PINGROUP), Get_SPA(Pin2Ptr, 0, PINGROUP)) != 0)
   { 
      return FALSE;
   }

	return TRUE;
}



int CheckGateGroups(SI_PTR Inst1Ptr, SI_PTR Inst2Ptr)
{
	ST_PTR stptr;
	char Group1[64], Group2[64];

   stptr = TypeOfInstance( Inst1Ptr );
   Activate_Symbol_Type( stptr);

	strcpy(Group1, Get_SIA( Inst1Ptr, GATEGROUP ));
	
   stptr = TypeOfInstance( Inst2Ptr );
   Activate_Symbol_Type( stptr);

	strcpy(Group2, Get_SIA( Inst2Ptr, GATEGROUP ));

	if(strncmp(Group1, Group2, 64) != 0)
   { 
      return FALSE;
   }

	return TRUE;
}

int CheckCompNames(SI_PTR Inst1Ptr, SI_PTR Inst2Ptr)
{
	ST_PTR stptr;
	char Name1[64], Name2[64];

   stptr = TypeOfInstance( Inst1Ptr );
   Activate_Symbol_Type( stptr);

	strcpy(Name1, Get_SIA( Inst1Ptr, COMPNAME ));
	
   stptr = TypeOfInstance( Inst2Ptr );
   Activate_Symbol_Type( stptr);

	strcpy(Name2, Get_SIA( Inst2Ptr, COMPNAME ));

	if(strnicmp(Name1, Name2, 64) != 0)
   { 
      return FALSE;
   }

	return TRUE;
}


int IsCommonPin(SP_PTR PinPtr)
{
	SI_PTR InstPtr;
	ST_PTR stptr;
	char buffer[256];
	int PinNum;

	if(!(InstPtr = InstanceContainingPin(PinPtr)))
	{
		return FALSE;
	}

   stptr = TypeOfInstance( InstPtr );
   Activate_Symbol_Type( stptr);

   strcpy(buffer, Get_PA( PinPtr, PINNUM ));

   
   PinNum = atoi(buffer) - 1;

	if((PinNum < 0) || (PinNum >= MAX_PINS))
	{
		return FALSE;
	}

	if(!BuildPinList(GetRefDesignator(InstPtr)))
	{
		return FALSE;
	}

	return thePinList[PinNum].IsCommon;
}


/******************* MoveGate ********************/

static int SwapG_InstNum;

static void RememberGate( SI_PTR iptr, char* refdes )
{
	if ( swapg_hwm + 1 >= max_swapg )
	{
		int nMax = max_swapg + 512;
		void* pTmp = realloc( SwapG, nMax * sizeof(SWAPG) );
		if ( pTmp )
		{
			max_swapg = nMax;
			SwapG = (SWAPG*)pTmp;
		}
		else
		{
			MajorError( 
				"Insufficient memory to process design\nClose other processes" );
		}
	}
	if ( SwapG )
	{
		SwapG[swapg_hwm].number = iptr;
		strcpy( SwapG[swapg_hwm].refdes, refdes); 
		SwapG[swapg_hwm].pinCount=0;
		SwapG[swapg_hwm].pinMax=20;

		if (!(SwapG[swapg_hwm].pinList = (pinref*)calloc( SwapG[swapg_hwm].pinMax, sizeof(pinref) ) ) )
		{
			MajorError( 
				"Insufficient memory to process design\nClose other processes" );
			return;		// KLUDGE, return abort?
		}
		swapg_hwm++;
	}
}

static int StorePin(SP_PTR spptr, PN_PTR pnptr, struct _pin *sptr)
{
	int pinnum=0;

	SI_PTR InstPtr;
	ST_PTR stptr;

	if(!IsCommonPin(spptr))                 
	{
		pinnum = SwapG[SwapG_InstNum].pinCount;
		SwapG[SwapG_InstNum].pinCount++;

		if ( SwapG[SwapG_InstNum].pinCount + 1 >= SwapG[SwapG_InstNum].pinMax )
		{
			int nMax = SwapG[SwapG_InstNum].pinMax + 20;
			void* pTmp = realloc( SwapG[SwapG_InstNum].pinList, nMax * sizeof(pinref) );
			if ( pTmp )
			{
				SwapG[SwapG_InstNum].pinMax = nMax;
				SwapG[SwapG_InstNum].pinList = (pinref*)pTmp;
			}
			else
			{
				MajorError( "Insufficient memory to process design\nClose other processes" );
				return TRUE;
			}
		}

		if(!(InstPtr = InstanceContainingPin(spptr)))
		{
			return TRUE;
		}

		stptr = TypeOfInstance( InstPtr );
		Activate_Symbol_Type( stptr);

		strcpy( SwapG[SwapG_InstNum].pinList[pinnum].name, Get_SPA( spptr, pnptr, PINNAME ) );
		strcpy( SwapG[SwapG_InstNum].pinList[pinnum++].number, Get_PA( spptr, PINNUM ) );
	}
	else
	{
		if(!(InstPtr = InstanceContainingPin(spptr)))
		{
			return TRUE;
		}

		stptr = TypeOfInstance( InstPtr );
		Activate_Symbol_Type( stptr);
	}
	return FALSE;
}

int MoveGate(char *GateRef1, char *GateRef2, int LineNum)
{
	SI_PTR Gate1Ptr, Gate2Ptr;
	ST_PTR stptr;
	char buff[256];

   if(!FindGateInstPtr(GateRef1, &Gate1Ptr))
   { 
   	sprintf( buff, "Error at line %d: Can't find Gate :%s",LineNum, GateRef1 );
      ErrorMsg ( buff );
      return FALSE;
   }

   if(!FindGateInstPtr(GateRef2, &Gate2Ptr))
   { 
   	sprintf( buff, "Error at line %d: Can't find Gate :%s", LineNum, GateRef2 );
      ErrorMsg ( buff );
      return FALSE;
   }
   
   if(!CheckGateGroups(Gate1Ptr, Gate2Ptr))
   {
   	sprintf( buff, "Error at line %d: %s and %s are not equivalent gates", LineNum, GateRef1, GateRef2 );
      ErrorMsg ( buff );
      return FALSE;
   }

	SwapG_InstNum	= (int) swapg_hwm;
	RememberGate(Gate2Ptr, GetRefDesignator(Gate1Ptr));			

      /* We must first activate the symbol to assure the attribute
       * operations will behave correctly
       */

   stptr = TypeOfInstance( Gate1Ptr );
   Activate_Symbol_Type( stptr);
	
   ForEachInstancePin( Gate1Ptr, StorePin );

   return TRUE;
 }

/******************* BeginMoveGates ********************/

int BeginMoveGates()
{
	swapg_hwm = 0;
	if( !( SwapG = (SWAPG*)calloc( max_swapg, sizeof(SWAPG) ) ) )
	{
		return FALSE;
	}
	return TRUE;
}

/******************* EndMoveGates ********************/

int EndMoveGates()
{
	ST_PTR stptr;
	SP_PTR spptr;
	int i;

	if(SwapG)
	{
		SwapG_InstNum	= ((int) swapg_hwm) - 1;

		while ( SwapG_InstNum >= 0 )
		{	
			stptr = TypeOfInstance( SwapG[SwapG_InstNum].number );
			Activate_Symbol_Type( stptr);

			for(i=0; i<SwapG[SwapG_InstNum].pinCount; i++)
			{
				if( FindPinPtr(SwapG[SwapG_InstNum].number, SwapG[SwapG_InstNum].pinList[i].name, &spptr) )
				{ 
					Add_PA( spptr, PINNUM, SwapG[SwapG_InstNum].pinList[i].number);
				}
			}

			Add_IA( SwapG[SwapG_InstNum].number, REFNAME, SwapG[SwapG_InstNum].refdes );

			free( SwapG[SwapG_InstNum].pinList );

			SwapG_InstNum--;
		}

		free( SwapG );
		SwapG = NULL;
	}

	return TRUE;
}


/******************* MovePin & MovePinInGate ********************/

static void RememberPin( SP_PTR iptr, char* refdes )
{
	if ( swapp_hwm + 1 >= max_swapp )
	{
		int nMax = max_swapp + 512;
		void* pTmp = realloc( SwapP, nMax * sizeof(SWAPP) );
		if ( pTmp )
		{
			max_swapp = nMax;
			SwapP = (SWAPP*)pTmp;
		}
		else
		{
			MajorError( "Insufficient memory to process design\nClose other processes" );
		}
	}
	if ( SwapP )
	{
		SwapP[swapp_hwm].number = iptr;
		strcpy( SwapP[swapp_hwm].refdes, refdes);
		swapp_hwm++;
	}
}

/******************* MovePin  ********************/

int MovePin( char *Ref, char *Pin1Ref, char *Pin2Ref, int LineNum )
 {
	SI_PTR InstPtr;
	SP_PTR Pin1Ptr, Pin2Ptr;
	char buff[256], PinNum[64];

	if(!FindInstPtr(Ref, &InstPtr))
   { 
   	sprintf( buff, "Error at line %d: Can't find reference:%s", LineNum, Ref );
      ErrorMsg ( buff );
      return FALSE;
   }
   
	if(!FindPinPtr(InstPtr, Pin1Ref, &Pin1Ptr))
   { 
   	sprintf( buff,  "Error at line %d: Can't find pin:%s", LineNum, Pin1Ref );
      ErrorMsg ( buff );
      return FALSE;
   }

	if(!FindPinPtr(InstPtr, Pin2Ref, &Pin2Ptr))
   { 
   	sprintf( buff, "Error at line %d: Can't find pin:%s", LineNum, Pin2Ref );
      ErrorMsg ( buff );
      return FALSE;
   }

	if(IsCommonPin(Pin1Ptr))
   { 
   	sprintf( buff, "Error at line %d: %s is a common pin", LineNum, Pin1Ref );
      ErrorMsg ( buff );
      return FALSE;
   }

	if(IsCommonPin(Pin2Ptr))
   { 
   	sprintf( buff, "Error at line %d: %s is a common pin", LineNum, Pin2Ref );
      ErrorMsg ( buff );
      return FALSE;
   }

	if(!CheckPinGroups(Pin1Ptr, Pin2Ptr))
   { 
   	sprintf( buff, "Error at line %d: Pins aren't in the same group", LineNum );
      ErrorMsg ( buff );
      return FALSE;
   }

	GetPinNum(Pin1Ptr, PinNum);

	RememberPin(Pin2Ptr, PinNum);

	return TRUE;
 }


/******************* MovePinInGate ********************/

int MovePinInGate( char *GateRef, char *Pin1Ref, char *Pin2Ref, int LineNum )
{
	SI_PTR InstPtr;
	SP_PTR Pin1Ptr, Pin2Ptr;
	char buff[256], PinNum[64];

	if(!FindGateInstPtr(GateRef, &InstPtr))
   { 
   	sprintf( buff, "Error at line %d: Can't find Reference:%s", LineNum, GateRef );
      ErrorMsg ( buff );
      return FALSE;
   }
   
	if(!FindPinPtr(InstPtr, Pin1Ref, &Pin1Ptr))
   { 
   	sprintf( buff, "Error at line %d: Can't find Pin:%s", LineNum, Pin1Ref );
      ErrorMsg ( buff );
      return FALSE;
   }

	if(!FindPinPtr(InstPtr, Pin2Ref, &Pin2Ptr))
   { 
   	sprintf( buff, "Error at line %d: Can't find Pin:%s", LineNum, Pin2Ref );
      ErrorMsg ( buff );
      return FALSE;
   }

	if(IsCommonPin(Pin1Ptr))
   { 
   	sprintf( buff, "Error at line %d: %s is a common pin", LineNum, Pin1Ref );
      ErrorMsg ( buff );
      return FALSE;
   }

	if(IsCommonPin(Pin2Ptr))
   { 
   	sprintf( buff, "Error at line %d: %s is a common pin", LineNum, Pin2Ref );
      ErrorMsg ( buff );
      return FALSE;
   }

	if(!CheckPinGroups(Pin1Ptr, Pin2Ptr))
   { 
   	sprintf( buff, "Error at line %d: Pins aren't in the same Group", LineNum );
      ErrorMsg ( buff );
      return FALSE;
   }

	GetPinNum(Pin1Ptr, PinNum);

	RememberPin(Pin2Ptr, PinNum);

	return TRUE;
}


/******************* BeginMovePins ********************/

int BeginMovePins()
{
	swapp_hwm = 0;
	if ( !( SwapP = (SWAPP*)calloc( max_swapp, sizeof(SWAPP) ) ) )
	{
		return FALSE;
	}
	return TRUE;
}


/******************* EndMovePins ********************/

int EndMovePins()
{
	SI_PTR InstPtr;
	ST_PTR stptr;

	if(SwapP)
	{
	   while ( swapp_hwm > 0 )
	   {
	      swapp_hwm--;

			if(!(InstPtr = InstanceContainingPin(SwapP[swapp_hwm].number)))
			{
				return FALSE;
			}
		
		   stptr = TypeOfInstance( InstPtr );
		   Activate_Symbol_Type( stptr);           
		   
	      Add_PA( SwapP[swapp_hwm].number, PINNUM,
	               SwapP[swapp_hwm].refdes );  
	   }
	
	   free( SwapP );
	   SwapP = NULL;
	}

	return TRUE;
}

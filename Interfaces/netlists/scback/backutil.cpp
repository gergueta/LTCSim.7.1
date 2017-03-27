/* backutil.c - Utility functions for Schematic Back Annotation */

/*  Copyright 1993 Xilinx Coporation, 2000 Cohesion Systems, inc. All Rights Reserved.
 *
 * This program is protected under the copyright laws as a published work.
 * It may not be copied, reproduced, further distributed, adaptations
 * made from the same, or used to prepare derivative works, without the
 * prior written consent of Cohesion Systems, inc
 *
 * History:
 *    5/05/93 - Included in Version 2.5
 */

#include "stdafx.h"
#include <string.h>
#include "spikproc.h"
#include "scback.h"

static int pinCount;
static int noPinsYet;
static int refWasFound;
static int foundPin1, foundPin2;
static int theGroup1, theGroup2;
static int sameGate;
static int whichGate, whichPin, assignOK;
static int theSection1, theSection2;
static int theAttribute;
static SI_PTR theInstPtr;
static SI_PTR theInst1Ptr; 
static SI_PTR theInst2Ptr;
static SP_PTR thePinPtr;
static char *theName;
static char *theGate1, *theGate2;
static char *theRef1, *theRef2;
static char *theValue;
static char *theInstName;
static char *thePinName;
static char pinIn1[64], pinIn2[64];
static char theComponent1[_MAX_PATH], theComponent2[_MAX_PATH];
static char pinList[2][256][32];
static char buff[256];


SWAP *Swaps;
unsigned long swap_hwm, max_swap;

int GetWord( char** cptr, char* word )
 { int ok = FALSE;
   char *target;

     /* Skip leading blank space
      */
   while ( ( **cptr == ' ' ) || ( **cptr == '\t' ) )
      ++(*cptr);

   target = word;
   while ( **cptr )
    { if ( ( **cptr == '\t' ) || ( **cptr == ' ' ) ||
           ( **cptr == '\n' ) || ( **cptr == '\r' ) || ( **cptr == '\0' ) )
         break;
      *target = **cptr;
      ++target;
      ++(*cptr);
      ok = TRUE;
    }
   *target = '\0';

   return ok;
 }

/*********************** Change Instance *******************/

static int CheckInst( SI_PTR iptr, struct _inst* sptr )
 { if ( strcmp( theName, GetInstanceName( iptr ) ) == 0 )
    { theInstPtr = iptr;
      return TRUE;
    }

   return FALSE;
 }

SI_PTR FindInstanceNamed( char* name )
 { theInstPtr = (SI_PTR) NULL;
   theName = name;
   ForEachSymbolInstance( 0, (ST_PTR) NULL, CheckInst );
   return theInstPtr;
 }

int ChangeInst( char* attribute, char* name, char* value, int lineno )
 { int atnum;
   SI_PTR iptr;
   ST_PTR stptr;

    iptr = FindInstanceNamed( name );
    if ( iptr == (SI_PTR) NULL )
     { sprintf( buff, "Error at line %d, Can't find instance %s",
                          lineno, name );
       ErrorMsg ( buff );
       return FALSE;
     }
    atnum = GetSymAttrNumber( attribute );
    if ( atnum < 0 )
     { sprintf( buff, "Error at line %d, Invalid Attribute %s\n",
                          lineno, attribute );
       ErrorMsg ( buff );
       return FALSE;
     }

      /* We must first activate the symbol to assure the attribute
       * operations will behave correctly
       */
   stptr = TypeOfInstance( iptr );
   Activate_Symbol_Type( stptr );
   Add_IA( iptr, atnum,  value );

   return TRUE;
 }

int ChangeInstByNum( int atnum, char* name, char* value, int lineno )
 { 
   SI_PTR iptr;
   ST_PTR stptr;

    iptr = FindInstanceNamed( name );
    if ( iptr == (SI_PTR) NULL )
     { sprintf( buff, "Error at line %d, Can't find instance %s",
                          lineno, name );
       ErrorMsg ( buff );
       return FALSE;
     }

      /* We must first activate the symbol to assure the attribute
       * operations will behave correctly
       */
   stptr = TypeOfInstance( iptr );
   Activate_Symbol_Type( stptr );
   Add_IA( iptr, atnum, value );

   return TRUE;
 }


/*********************** Rename Component *******************/

static void RememberRef( SI_PTR iptr, char* newref )
{
	if ( swap_hwm + 1 >= max_swap )
	{
		int nMax = max_swap + 512;
		void *pTmp = realloc( Swaps, nMax * sizeof(SWAP) );
		if ( pTmp )
		{
			max_swap = nMax;
			Swaps = (SWAP*)pTmp;
		}
		else
		{
			MajorError( "Insufficient memory to process design\nClose other processes" );
			// NOTE, no way to abort
		}
	}
	if ( Swaps )
	{
		Swaps[swap_hwm].number = iptr;
		strcpy( Swaps[swap_hwm].refdes, newref );
		swap_hwm++;
	}
}

static int CheckRef( SI_PTR iptr, struct _inst* sptr )
 { if ( strcmp( theRef1, GetRefDesignator( iptr ) ) == 0 )
    { refWasFound = TRUE;
         /* Save the swap information */
      RememberRef( iptr, theRef2 );
    }

   return 0;
 }

int Rename( char* name1, char* name2, int lineno )
 {
   theRef1 = name1;
   theRef2 = name2;
   refWasFound = FALSE;
   ForEachSymbolInstance( 0, (ST_PTR) NULL, CheckRef );
   if ( !refWasFound )
    { sprintf( buff, "Error at line %d: %s not found", lineno, name1 );
      ErrorMsg ( buff );
      return FALSE;
    }
   else
      return TRUE;
 }

int BeginRename()
{
	swap_hwm = 0;
	max_swap = 100;
	if( !( Swaps = (SWAP*)calloc( max_swap, sizeof(SWAP) ) ) )
	{
		return FALSE;
	}
	return TRUE;
}

int EndRename()
{
	if(Swaps)
	{
		while ( swap_hwm > 0 )
		{
			swap_hwm--;
			ST_PTR stptr = TypeOfInstance( Swaps[swap_hwm].number );
			Activate_Symbol_Type( stptr);
			Add_IA( Swaps[swap_hwm].number, REFNAME,
				Swaps[swap_hwm].refdes );
		}
		/* Free the SWAP memory */
		free( Swaps );
		Swaps = 0;
	}
	return TRUE;
}


/********************** Change Attribute **********************/

static int ChangeAttr( SI_PTR iptr, struct _inst* sptr )
 { if ( strcmp( theRef1, GetRefDesignator( iptr ) ) == 0 )
    { refWasFound = TRUE;
         /* Change the attribute */
    	Add_IA( iptr, theAttribute, theValue );
    }

   return 0;
 }

int ChangeSymAttrByNum(int AttrNum, char *RefName, char *Value, int LineNum)
{
   theRef1 = RefName;
	theValue = Value;
	theAttribute = AttrNum;
   refWasFound = FALSE;
   ForEachSymbolInstance( 0, (ST_PTR) NULL, ChangeAttr );
   if ( !refWasFound )
    { sprintf( buff, "Error at line %d: %s not found", LineNum, RefName );
      ErrorMsg ( buff );
      return FALSE;
    }
   else
      return TRUE;
}


/************* Change Net *********************/

int ChangeNet( char* attribute, char* name, char* value, int lineno )
 { int atnum;
   NT_PTR nptr;

   nptr = FindNetNamed( name );
   if ( nptr == (NT_PTR) NULL )
    { sprintf( buff, "Error at line %d, Can't find net %s",
                         lineno, name );
      ErrorMsg ( buff );
      return FALSE;
    }
   atnum = GetNetAttrNumber( attribute );
   if ( atnum < 0 )
    { sprintf( buff, "Error at line %d, Invalid Attribute %s\n",
                         lineno, attribute );
      ErrorMsg ( buff );
      return FALSE;
    }

   Add_NA( nptr, atnum, value );

   return TRUE;
 }


/************* ChangeNetAttribute *********************/

int ChangeNetAttrByNum( int atnum, char *name, char *value, int lineno )
{
   NT_PTR nptr;

   nptr = FindNetNamed( name );
   if ( nptr == (NT_PTR) NULL )
    { sprintf( buff, "Error at line %d, Can't find net %s",
                         lineno, name );
      ErrorMsg ( buff );
      return FALSE;
    }

   Add_NA( nptr, atnum, value );

   return TRUE;
}

/************* Change Pin *********************/

static int CheckPin( SP_PTR spptr, PN_PTR pnptr, struct _pin* sptr )
 { if ( strcmp( thePinName, GetPinName( pnptr ) ) == 0 )
    { thePinPtr = pnptr;
      return TRUE;
    }

   return FALSE;
 }

SP_PTR FindPinNamed( char* name )
 { SI_PTR iptr;
   ST_PTR stptr;
   char *cp;

   thePinPtr = (SP_PTR) NULL;

     /* Name is in the form <instname>-<pinname>
      */
   strcpy( theInstName, name );
   cp = strrchr( theInstName, '-' );
   *cp = '\0';  /* terminate instance name */
   strcpy ( thePinName, ++cp );

   iptr = FindInstanceNamed( theInstName );
   if ( iptr == (SI_PTR) NULL )
      return (SP_PTR) NULL;

      /* We must first activate the symbol to assure the attribute
       * operations will behave correctly
       */
   stptr = TypeOfInstance( iptr );
   Activate_Symbol_Type( stptr );
   ForEachInstancePin( iptr, CheckPin );
   return thePinPtr;
 }

int ChangePin( char* attribute, char* name, char* value, int lineno )
 { int atnum;
   SP_PTR pptr;

   pptr = FindPinNamed( name );
   if ( pptr == (SP_PTR) NULL )
    { sprintf( buff, "Error at line %d, Can't find pin %s",
                         lineno, name );
      ErrorMsg ( buff );
      return FALSE;
     }
   atnum = GetPinAttrNumber( attribute );
   if ( atnum < 0 )
    { sprintf( buff, "Error at line %d, Invalid Attribute %s\n",
                         lineno, attribute );
      ErrorMsg ( buff );
      return FALSE;
    }

   Add_PA( pptr, atnum, value );

   return TRUE;
 }

/************* Swap Pins *********************/

static int SwapNumbers( SP_PTR spptr, PN_PTR pnptr, struct _pin* sptr )
 { char group[64];
   if ( strcmp( theRef1,
                  Get_PA( spptr, PINNUM ) ) == 0 )
    {
      foundPin1 = TRUE;
      Add_PA( spptr, PINNUM, theRef2 );
      strcpy( group, Get_SPA( spptr, pnptr, PINGROUP ) );
      sscanf( group, "%d", &theGroup1 );
    }
   else if ( strcmp( theRef2,
                      Get_PA( spptr, PINNUM ) ) == 0 )
    {
      foundPin2 = TRUE;
      Add_PA( spptr, PINNUM, theRef1 );
      strcpy( group, Get_SPA( spptr, pnptr, PINGROUP ) );
      sscanf( group, "%d", &theGroup2 );
    }

   return ( foundPin1 && foundPin2 );
 }

static int CheckComp( SI_PTR iptr, struct _inst* sptr )
 { if ( strcmp( theName, GetRefDesignator( iptr ) ) == 0 )
    {
      ForEachInstancePin( iptr, SwapNumbers );

         /* At this point, we have processed all the pins for this instance.
          * We should have, therefore, found both pins to be swapped, or
          * neither.  If we have found only 1 of them, that is an error.
          */
      if ( foundPin1 != foundPin2 )
         sameGate = FALSE;
    }

   return 0;
 }

int SwapPins( char* name, char* pin1, char* pin2, int lineno )
 { foundPin1 = FALSE;
   foundPin2 = FALSE;
   sameGate = TRUE;
   theName = name;
   theRef1 = pin1;
   theRef2 = pin2;
   ForEachSymbolInstance( 0, (ST_PTR) NULL, CheckComp );

   if ( !foundPin1 )
    { sprintf( buff, "Error at line %d Can't find %s pin %s",
                          lineno, name, pin1 );
      ErrorMsg ( buff );
      return FALSE;
    }

   if ( !foundPin2 )
    { sprintf( buff, "Error at line %d Can't find %s pin %s",
                          lineno, name, pin2 );
      ErrorMsg ( buff );
      return FALSE;
    }

   if ( theGroup1 != theGroup2 )
    { sprintf( buff, 
            "Error at line %d: %s pins %s and %s are not in same pin group",
                          lineno, name, pin1, pin2 );
      ErrorMsg ( buff );
      return FALSE;
    }

   if ( !sameGate )
    { sprintf( buff,
            "Error at line %d: %s pins %s and %s are not on same gate",
                          lineno, name, pin1, pin2 );
      ErrorMsg ( buff );
      return FALSE;
    }

   return TRUE;
 }

/************* Swap Gates *********************/

static int AssignPin( SP_PTR spptr, PN_PTR pnptr, struct _pin* sptr )
 { if ( strcmp( theName, Get_PA( spptr, PINNUM ) ) == 0 )
    {
      Add_PA( spptr, PINNUM, theRef1 );
      assignOK = TRUE;
      return TRUE;
    }

   return 0;
 }

static int DoPinSwap( char* pin1, char *pin2 )
 { ST_PTR stptr;

      /* make sure the symbol we are working on is "active"
       */
   stptr = TypeOfInstance( theInst1Ptr );
   Activate_Symbol_Type( stptr );

   assignOK = FALSE;
   theName = pin1;
   theRef1 = pin2;
   ForEachInstancePin( theInst1Ptr, AssignPin );
   foundPin1 = assignOK;

      /* make sure the symbol we are working on is "active"
       */
   stptr = TypeOfInstance( theInst2Ptr );
   Activate_Symbol_Type( stptr );
   assignOK = FALSE;
   theName = pin2;
   theRef1 = pin1;
   ForEachInstancePin( theInst2Ptr, AssignPin );
   foundPin2 = assignOK;

   return 0;
 }

static int DoGateSwap()
 { ST_PTR stptr;

   stptr = TypeOfInstance( theInst1Ptr );
   Activate_Symbol_Type( stptr );
   Add_IA( theInst1Ptr, REFNAME, theGate2 );

   stptr = TypeOfInstance( theInst2Ptr );
   Activate_Symbol_Type( stptr );
   Add_IA( theInst2Ptr, REFNAME, theGate1 );

   return TRUE;
 }

static int GetPins( SP_PTR spptr, PN_PTR pnptr, struct _pin* sptr )
 { if ( whichGate == 1 )
    { if ( strcmp( theRef1, Get_PA( spptr, PINNUM ) ) == 0 )
         foundPin1 = TRUE;
         return TRUE;
    }
   else if ( whichGate == 2 )
    { if ( strcmp( theRef2, Get_PA( spptr, PINNUM ) ) == 0 )
         foundPin2 = TRUE;
         return TRUE;
    }

   return FALSE;
 }

static int GetGates( SI_PTR iptr, struct _inst* sptr )
 { 
 	char *temp;
 
 if ( strcmp( theGate1, GetRefDesignator( iptr ) ) == 0 )
    { whichGate = 1;
   
   	temp = Get_SIA( iptr, GATEGROUP );
	
      ForEachInstancePin( iptr, GetPins );
      if ( foundPin1 && ( theInst1Ptr == (SI_PTR) NULL ) )
       { theInst1Ptr = iptr;
         strcpy( theComponent1, Get_SIA( iptr, COMPNAME ) );
       }
    }
   if ( strcmp( theGate2, GetRefDesignator( iptr ) ) == 0 )
    { whichGate = 2;

   	temp = Get_SIA( iptr, GATEGROUP );

      ForEachInstancePin( iptr, GetPins );
      if ( foundPin2 && ( theInst2Ptr == (SI_PTR) NULL ) )
       { theInst2Ptr = iptr;
         strcpy( theComponent2, Get_SIA( iptr, COMPNAME ) );
       }
    }

   return ( foundPin1 && foundPin2 );
 }

static int FindPinInSection( SP_PTR spptr, PN_PTR pnptr, struct _pin* sptr )
 { char *plist, pnum[64];
   int i, highest;

      /* The pin number from the symbol editor on any pin of
       * any section should contain a list of pin numbers for that
       * pin.  Pick the number corresponding to the sections we are
       * looking for and use to find the right instance.
       */
   if ( noPinsYet )
    { highest = (theSection1 > theSection2) ? theSection1 : theSection2;
      plist = Get_PNA( pnptr, PINNUM );
      for ( i=0; i <= highest; ++i )
       {
           if ( !GetWord( &plist, pnum ) )
              return TRUE;

           if ( i == theSection1 ) strcpy( pinIn1, pnum );
           if ( i == theSection2 ) strcpy( pinIn2, pnum );
       }
      noPinsYet = FALSE;
    }

   if ( whichGate == 1 )
    {
      if ( strcmp( pinIn1, Get_PA( spptr, PINNUM ) ) == 0 )
       { foundPin1 = TRUE;
         return TRUE;
       }
    }
   else if ( whichGate == 2 )
    {
      if ( strcmp( pinIn2, Get_PA( spptr, PINNUM ) ) == 0 )
       { foundPin2 = TRUE;
         return TRUE;
       }
    }
   return FALSE;
 }

static int GetSection( SI_PTR iptr, struct _inst* sptr )
 { 
 	char *temp;
 
 	if ( strcmp( theGate1, GetRefDesignator( iptr ) ) == 0 )
    { whichGate = 1;

   	temp = Get_SIA( iptr, GATEGROUP );

      ForEachInstancePin( iptr, FindPinInSection );
      if ( foundPin1 && ( theInst1Ptr == (SI_PTR) NULL ) )
       { theInst1Ptr = iptr;
         strcpy( theComponent1, Get_SIA( iptr, COMPNAME ) );
       }
    }
   if ( strcmp( theGate2, GetRefDesignator( iptr ) ) == 0 )
    { whichGate = 2;

   	temp = Get_SIA( iptr, GATEGROUP );

      ForEachInstancePin( iptr, FindPinInSection );
      if ( foundPin2 && ( theInst2Ptr == (SI_PTR) NULL ) )
       { theInst2Ptr = iptr;
         strcpy( theComponent2, Get_SIA( iptr, COMPNAME ) );
       }
    }

   return ( foundPin1 && foundPin2 );
 }

static int StorePin( SP_PTR spptr, PN_PTR pnptr, struct _pin* sptr )
 {
   strcpy( pinList[whichGate - 1][whichPin++], Get_PA( spptr, PINNUM ) );
   return FALSE;
 }

static int LoadPin( SP_PTR spptr, PN_PTR pnptr, struct _pin* sptr )
 {
   Add_PA( spptr, PINNUM, pinList[whichGate - 1][whichPin++] );
   return FALSE;
 }

static int SwapInstances()
 { ST_PTR stptr;

      /* We must first activate the symbol to assure the attribute
       * operations will behave correctly
       */
   stptr = TypeOfInstance( theInst1Ptr );
   Activate_Symbol_Type( stptr);
   whichGate = 1;
   whichPin = 0;
   ForEachInstancePin( theInst1Ptr, StorePin );

   stptr = TypeOfInstance( theInst2Ptr );
   Activate_Symbol_Type( stptr);
   whichGate = 2;
   whichPin = 0;
   ForEachInstancePin( theInst2Ptr, StorePin );

   stptr = TypeOfInstance( theInst1Ptr );
   Activate_Symbol_Type( stptr);
   whichGate = 2;
   whichPin = 0;
   ForEachInstancePin( theInst1Ptr, LoadPin );

   stptr = TypeOfInstance( theInst2Ptr );
   Activate_Symbol_Type( stptr);
   whichGate = 1;
   whichPin = 0;
   ForEachInstancePin( theInst2Ptr, LoadPin );

   Add_IA( theInst2Ptr, REFNAME, theGate1 );

   stptr = TypeOfInstance( theInst1Ptr );
   Activate_Symbol_Type( stptr);
   Add_IA( theInst1Ptr, REFNAME, theGate2 );

   return TRUE;
 }

int SwapSection( char* gate1, char* gate2, char sect_delim, int lineno )
 { char ref1[64], ref2[64], buff[256], *split;

   strcpy( ref1, gate1 );
   strcpy( ref2, gate2 );
   split = strchr( ref1, sect_delim );
   if ( split == NULL )
    { sprintf( buff, "Error at line %d: Invalid Gate Section Designation:%s",
                     lineno, gate1 );
      ErrorMsg ( buff );
      return FALSE;
    }
   *split = '\0';
   ++split;
   theSection1 = *split - 'A';
   theGate1 = ref1;

   split = strchr( ref2, sect_delim );
   if ( split == NULL )
    { sprintf( buff, "Error at line %d: Invalid Gate Section Designation:%s",
                     lineno, gate2 );
      ErrorMsg ( buff );
      return FALSE;
    }
   *split = '\0';
   ++split;
   theSection2 = *split - 'A';
   theGate2 = ref2;

   noPinsYet = TRUE;
   foundPin1 = foundPin2 = FALSE;
   theInst1Ptr = (SI_PTR) NULL;
   theInst2Ptr = (SI_PTR) NULL;
   ForEachSymbolInstance( 0, (ST_PTR) NULL, GetSection );
   if ( !foundPin1 )
    { sprintf( buff, "Error at line %d: Can't find Gate Section:%s",
                         lineno, gate1 );
      ErrorMsg ( buff );
      return FALSE;
    }
   if ( !foundPin2 )
    { sprintf( buff, "Error at line %d: Can't find Gate Section:%s",
                         lineno, gate2 );
      ErrorMsg ( buff );
      return FALSE;
    }
   if ( stricmp( theComponent1, theComponent2 ) )
    { sprintf( buff, "Error at line %d: %s and %s are not equivalent gates",
                    lineno, theGate1, theGate2 );
      ErrorMsg ( buff );
      return FALSE;
    }

   return SwapInstances();
 }

int SwapGates( char* gate1, char* gate2, char* pinlist, int lineno )
 { char pin1[64], pin2[64], *cptr;
   int status;

   foundPin1 = FALSE;
   foundPin2 = FALSE;
   theGate1 = gate1;
   theGate2 = gate2;

   cptr = pinlist;
   status = GetWord(&cptr, pin1);
   status &= GetWord(&cptr, pin2);
   if ( !status )
    { sprintf( buff, "Error in Back Annotation File at line %d", lineno );
      ErrorMsg ( buff );
      return FALSE;
    }

   theRef1 = pin1;
   theRef2 = pin2;
   theInst1Ptr = (SI_PTR) NULL;
   theInst2Ptr = (SI_PTR) NULL;
   ForEachSymbolInstance( 0, (ST_PTR) NULL, GetGates );

   if ( !foundPin1 )
    { sprintf( buff, "Error at line %d Can't find %s pin %s",
                          lineno, gate1, pin1 );
      ErrorMsg ( buff );
      return FALSE;
    }
   if ( !foundPin2 )
    { sprintf( buff, "Error at line %d Can't find %s pin %s",
                          lineno, gate2, pin2 );
      ErrorMsg ( buff );
      return FALSE;
    }
   if ( stricmp( theComponent1, theComponent2 ) )
    { sprintf( buff, "Error at line %d: %s and %s are not equivalent gates",
                       lineno, gate1, gate2 );
      ErrorMsg ( buff );
      return FALSE;
    }

   while ( status )
    {
      DoPinSwap( pin1, pin2 );
      if ( !foundPin1 )
       { sprintf( buff, "Error at line %d Can't find %s pin %s",
                             lineno, gate1, pin1 );
         ErrorMsg ( buff );
         return FALSE;
       }
      else if ( !foundPin2 )
       { sprintf( buff, "Error at line %d Can't find %s pin %s",
                             lineno, gate2, pin2 );
         ErrorMsg ( buff );
         return FALSE;
       }
      status = GetWord( &cptr, pin1 );
      status &= GetWord( &cptr, pin2 );
    }
   return DoGateSwap();
 }

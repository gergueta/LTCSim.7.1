#include "stdafx.h"
#include <string.h>
#include <stdio.h>
#include "spikproc.h"
#include "scback.h"

#define MAXPARTPROPERTIES	100	/* maximum size of the part property array			*/
#define MAXNETPROPERTIES	100	/* maximum size of the net property array				*/
#define MAXTOKENS				100	/* maximum number of tokens per line 					*/
#define PROPERTYLENGTH		32		/* maximum length of attribute string					*/
#define INVALIDPROPERTY		-1		/* terminates the property tables						*/
#define UNUSEDPROPERTY		-2		/* indicates that the property isn't used by ECS	*/
#define BUFFERSIZE			256	/* maximum number of characters per line				*/


/********/

extern int IsGateRef(char *);
extern int IsLetter(char);
extern int IsNumber(char);
extern int IsNull(char);
extern int IsWhiteSpace(char);
extern int FindGateInstPtr();

/********** Functions to add the values of attributes **********/

int ChangePartAttr_Generic(int AttrNum, char *RefName, char *Value, int LineNum);
int ChangePartAttr_CompLoc(int AttrNum, char *RefName, char *Value, int LineNum);
int ChangeNetAttr_Generic(int AttrNum, char *RefName, char *Value, int LineNum);
int ChangeNetAttr_ftoi(int AttrNum, char *RefName, char *Value, int LineNum);

/********** Structure used for the PartPropertyTable and NetPropertyTable *********/

typedef 
struct _PropertyTable
{
	char  Name[PROPERTYLENGTH + 1];                 /* Orcad property name									*/
	int 	Number;												/* the corresponding ECS attribute number			*/
	int 	(* Function)(int, char *, char *, int);	/* corresponding function to add the property 	*/
} PropertyTable;

/********** PartPropertyTable *********/


PropertyTable PartPropertyTable[] = 
{ /* OrCad Property,		ECS Attribute,			Function to change the attribute */  
	{ "{Reference}",		REFNAME, 				NULL },
	{ "PCB Footprint",	GEOMETRY,				ChangePartAttr_Generic },
	{ "FPLIST",				MASSTECKFP, 			ChangePartAttr_Generic },
	{ "COMPSIDE",			COMPLAYER,				ChangePartAttr_Generic },
	{ "COMPLOC",         COMPLOC, 				ChangePartAttr_CompLoc },
	{ "COMPROT",         COMPROT, 				ChangePartAttr_Generic },
	{ "COMPGROUP",			COMPGROUP,				ChangePartAttr_Generic },
	{ "COMPFIXED",       COMPFIXED,				ChangePartAttr_Generic },
	{ "COMPLOCKED",      COMPLOCKED, 			ChangePartAttr_Generic },
	{ "COMPKEY",			COMPKEY,					ChangePartAttr_Generic },
	{ "DECOUPLER",       DECOUPLER,				ChangePartAttr_Generic },
	{ "MEMORY",          UNUSEDPROPERTY, 		NULL },
	{ "",						INVALIDPROPERTY, 		NULL }	/* End of Table */
};

/********** NetPropertyTable *********/

PropertyTable NetPropertyTable[] =
{	/* Orcad Property, 	ECS Attribute,			Function to change the attribute */
	{ "{Net Name}",		NAME,						NULL },
	{ "ROUTELAYERS",		ROUTELAYERS,			ChangeNetAttr_Generic },
	{ "PLANELAYERS", 		UNUSEDPROPERTY,		NULL },
	{ "NETWEIGHT",       NETWEIGHT,				ChangeNetAttr_Generic },
	{ "VIAPERNET",       VIAPERNET,				ChangeNetAttr_Generic },
	{ "MINWIDTH",        MINWIDTH,				ChangeNetAttr_ftoi },
	{ "MAXWIDTH",        MAXWIDTH,				ChangeNetAttr_ftoi },
	{ "WIDTHBYLAYER",    WIDTHBYLAYER,			ChangeNetAttr_ftoi },
	{ "SPACINGBYLAYER",  SPACINGBYLAYER,		ChangeNetAttr_Generic },
	{ "CONNWIDTH",       CONNWIDTH,				ChangeNetAttr_ftoi },
	{ "RECONNTYPE",      RECONNTYPE,				ChangeNetAttr_Generic },
	{ "TESTPOINT",       TESTPOINT,				ChangeNetAttr_Generic },
	{ "HIGHLIGHT",       HIGHLIGHT,           ChangeNetAttr_Generic },
	{ "",						INVALIDPROPERTY,		NULL }	/* End of Table */
};

/********** Arrays of ECS attributes that are filled in as the headers are parsed **********/

int PartPropertyArray[MAXPARTPROPERTIES], PartPropertyArrayCount = 0;

int NetPropertyArray[MAXNETPROPERTIES], NetPropertyArrayCount = 0;


/********** ReadLine **********/

/* read a line into Buffer (assuming no line is longer then BUFFERSIZE 	*/

int ReadLine(FILE *FilePtr, char *Buffer, int *LineNum)
{	
	if ( fgets( Buffer, BUFFERSIZE, FilePtr ) == NULL )
	{
		return FALSE;
	}

	(*LineNum)++;
	
	return TRUE;
}


/********** FindPropertyNumber from the table **********/

int FindPropertyNumber (PropertyTable Table[], char *Name, int *PropertyNumber)
{
	int i=0;		

	while (Table[i].Number != INVALIDPROPERTY)
	{
		if (strcmp(Table[i].Name, Name) == 0)
		{
			*PropertyNumber = Table[i].Number;
			return TRUE;
		}
		i++;
	}
	*PropertyNumber = INVALIDPROPERTY;
	return FALSE;
} 

/********** FindPropertyNumberPosition from table **********/

int FindPropertyNumberPosition (PropertyTable Table[], int PropertyNumber, int *Position)
{
	int i=0;		

	while (Table[i].Number != INVALIDPROPERTY)
	{
		if (Table[i].Number == PropertyNumber)
		{
			*Position = i;
			return TRUE;
		}
		i++;
	}
	*Position = INVALIDPROPERTY;
	return FALSE;
} 

/********** FindNextTokenInLine **********/

/*	Sets the Token pointer to the beginning of the next token and deliminates 	 	*/
/*	the token with a NULL character. BufferPosition is moved just past the end	 	*/
/* of the token. Quotation marks are stripped off. This function assumes that	 	*/
/*	BufferPosition initially points to a buffer that is terminated with a NULL		*/
/*	character and that each token is seperated by whitespace (ASCII Codes < 33)	*/

int FindNextTokenInLine(char** BufferPosition, char** Token)
{
	while(**BufferPosition < 33)
	{
		if(**BufferPosition == '\0')
		{
			return FALSE;
		}
		(*BufferPosition)++;
	}

	if(**BufferPosition == '\"')
	{
		(*BufferPosition)++;
		*Token = *BufferPosition;

		while(**BufferPosition != '\"')
		{
			if(**BufferPosition == '\0')
			{
				return FALSE;
			}
			(*BufferPosition)++;
		}

		**BufferPosition = '\0';
	}
   else
   {
		*Token = *BufferPosition;
	}
		
	while(**BufferPosition > 32)
	{
		(*BufferPosition)++;
	}
   **BufferPosition = '\0';
	(*BufferPosition)++;


	return TRUE;
}


/********** ParseSection2Line **********/

/*	parse out the line currently contained in the buffer */

int ParseSection2Line(char *Buffer, int LineNum)
{
	char  *BufferPosition, *Command, *Parm1, *Parm2, *Parm3, buff[256];

	BufferPosition = Buffer;

	if(FindNextTokenInLine(&BufferPosition, &Command) == FALSE)
   {
		/* No Command */
   	return TRUE;
   }

	if(strncmp(Command, "ChangeRef", 9) == 0)
	{		
		if(FindNextTokenInLine(&BufferPosition, &Parm1) == FALSE)
      {
			sprintf( buff, "Error at line %d, Can't find reference 1", LineNum );
      	ErrorMsg ( buff );
      	return FALSE;
      }
      if(FindNextTokenInLine(&BufferPosition, &Parm2) == FALSE)
      {
			sprintf( buff, "Error at line %d, Can't find reference 2", LineNum );
      	ErrorMsg ( buff );
      	return FALSE;
      }

		if(IsGateRef(Parm1) && IsGateRef(Parm2))
		{ 
			/* Gate Change */
			return MoveGate(Parm1, Parm2, LineNum);
		}
		else if(!IsGateRef(Parm1) && ! IsGateRef(Parm2))
		{
      	return Rename(Parm1, Parm2, LineNum);
      }
	}
	else if(strncmp(Command, "ChangePin", 9) == 0)
	{
		if(FindNextTokenInLine(&BufferPosition, &Parm1) == FALSE)
      {
			sprintf( buff, "Error at line %d, Can't find reference", LineNum );
      	ErrorMsg ( buff );
      	return FALSE;
      }
      if(FindNextTokenInLine(&BufferPosition, &Parm2) == FALSE)
      {
			sprintf( buff, "Error at line %d, Can't find pin 1", LineNum );
      	ErrorMsg ( buff );
      	return FALSE;
      }
      if(FindNextTokenInLine(&BufferPosition, &Parm3) == FALSE)
      {
			sprintf( buff, "Error at line %d, Can't find pin 2", LineNum );
      	ErrorMsg ( buff );
      	return FALSE;
      }
		
		if(!IsGateRef(Parm1))
		{
			return MovePin(Parm1, Parm2, Parm3, LineNum);
		}
		
		return MovePinInGate(Parm1, Parm2, Parm3, LineNum);
	}
	else 
	{
		sprintf( buff, "Error at line %d, Invalid command: %s", LineNum, Command );
   	ErrorMsg ( buff );
		return FALSE;
	}

	return FALSE;
}

/********** ParseSection3Line **********/

/* parse out the line currently contained in the buffer. The function passed in receives	*/
/* the array of tokens, the number of elements in the array, and the current line number	*/				

int ParseSection3Line(char *Buffer, int (* Function)(char **, int, int), int LineNum)
{
	char *Token, *BufferPosition, *TokenArray[MAXTOKENS], buff[256];
   int i, TokenCount;
   
	BufferPosition = Buffer;

	for(i=0, TokenCount=0; (i<MAXTOKENS) && (FindNextTokenInLine(&BufferPosition, &Token) != FALSE); i++)
	{
		TokenArray[i] = Token;
		TokenCount++;
	}

	if(i >= MAXTOKENS)
	{
		sprintf( buff, "Error at line %d, Number of tokens exceeds MAXTOKENS", LineNum );
   	ErrorMsg ( buff );
		return FALSE;
	}
   
	return Function(TokenArray, TokenCount, LineNum);
}

/********** AddPartProperties **********/

/*	add the properties to the PartPropertyArray - find the property numbers and set the count	*/

int AddPartProperties(char **TokenArray, int TokenCount, int LineNum)
{	
	char buff[256];
	int i;
	
	if((TokenCount >= MAXPARTPROPERTIES) || (TokenCount < 0))
	{
		sprintf( buff, "Error at line %d, Number of tokens exceeds MAXPARTPROPERTIES", LineNum );
   	ErrorMsg ( buff );
		return FALSE;
	}

	for(i=0; i<TokenCount; i++)
	{				
		if(FindPropertyNumber(PartPropertyTable, TokenArray[i], &PartPropertyArray[i]) == FALSE)
		{
			sprintf( buff, "Error at line %d, Can't find part property %s", LineNum, TokenArray[i] );
      	ErrorMsg ( buff );
			return FALSE;
		}
   }
   
   PartPropertyArrayCount = TokenCount;
	
	return TRUE;
}

/********** AddNetProperties **********/

/*	add the properties to the NetPropertyArray - find the property numbers and set the count	*/

int AddNetProperties(char **TokenArray, int TokenCount, int LineNum)
{
	int i;
	char buff[256];
	
	if((TokenCount >= MAXNETPROPERTIES) || (TokenCount < 0))
	{
		sprintf( buff, "Error at line %d, Number of tokens exceeds MAXNETPROPERTIES", LineNum );
   	ErrorMsg ( buff );
		return FALSE;
	}

	for(i=0; i<TokenCount; i++)
	{				
		if(FindPropertyNumber(NetPropertyTable, TokenArray[i], &NetPropertyArray[i]) == FALSE)
		{
			sprintf( buff, "Error at line %d, Can't find net property %s", LineNum, TokenArray[i] );
      	ErrorMsg ( buff );
			return FALSE;
		}
   }
   
   NetPropertyArrayCount = TokenCount;
	
	return TRUE;
}

/********** ProcessPartProperties **********/

int ProcessPartProperties(char **TokenArray, int TokenCount, int LineNum)
{
	int i, RefPosition;
	char buff[256];
	
	if((TokenCount >= MAXPARTPROPERTIES) || (TokenCount < 0))
	{
		sprintf( buff, "Error at line %d, Number of tokens exceeds MAXPARTPROPERTIES", LineNum );
   	ErrorMsg ( buff );
		return FALSE;
	}

	if(FindPropertyNumberPosition(PartPropertyTable, REFNAME, &RefPosition) == FALSE)
	{
		sprintf( buff, "Error at line %d, Can't find part property %s", LineNum, TokenArray[RefPosition] );
   	ErrorMsg ( buff );
		return FALSE;
	}

	for(i=0; i<TokenCount; i++)
	{				
		if((i != RefPosition) && (PartPropertyTable[i].Function != NULL))
		{
			if(!PartPropertyTable[i].Function(PartPropertyTable[i].Number, TokenArray[RefPosition], TokenArray[i], LineNum))
			{
				return FALSE;
			}
		}
   }

	return TRUE;
}

/********** ProcessNetProperties **********/

int ProcessNetProperties(char **TokenArray, int TokenCount, int LineNum)
{
	int i, RefPosition;
	char buff[256];
	
	if((TokenCount >= MAXNETPROPERTIES) || (TokenCount < 0))
	{
		sprintf( buff, "Error at line %d, Number of tokens exceeds MAXNETPROPERTIES", LineNum );
   	ErrorMsg ( buff );
		return FALSE;
	}

	if(FindPropertyNumberPosition(NetPropertyTable, NAME, &RefPosition) == FALSE)
	{
		sprintf( buff, "Error at line %d, Can't find net property %s", LineNum, TokenArray[RefPosition] );
   	ErrorMsg ( buff );
		return FALSE;
	}

	for(i=0; i<TokenCount; i++)
	{				
		if((i != RefPosition) && (NetPropertyTable[i].Function != NULL))
		{
			if(!NetPropertyTable[i].Function(NetPropertyTable[i].Number, TokenArray[RefPosition], TokenArray[i], LineNum))
			{
				return FALSE;
			}
		}
   }

	return TRUE;
}

/********** DoOrcadChanges **********/

int DoOrcadChanges( FILE *FilePtr )
{  
	char Buffer[BUFFERSIZE];   
	int LineNum=0;
	
	*Buffer = '\0';

   while ( ReadLine(FilePtr, Buffer, &LineNum) == TRUE )
	{
      if ( strncmp( Buffer, ".Section1", 9 ) == 0 )
      {
			/* NO-OP */
      }
      else if ( strncmp( Buffer, ".Section2", 9 ) == 0 )
      {
			if(!BeginRename())
			{
				ErrorMsg("Out of memory");
				return FALSE;
			}
			if(!BeginMoveGates())
			{
				ErrorMsg("Out of memory");
				return FALSE;
			}
			if(!BeginMovePins())
			{
				ErrorMsg("Out of memory");
				return FALSE;
			}
		
			/* parse each line in this section */

			while((ReadLine(FilePtr, Buffer, &LineNum) == TRUE) && (strncmp(Buffer, ".End", 4) != 0))
			{
				if(!ParseSection2Line(Buffer, LineNum))
				{
					return FALSE;
				}
			}
			
			EndMovePins();
	      EndMoveGates();
			EndRename();
      }
      else if ( strncmp( Buffer, ".Section3", 9 ) == 0 )
      {
			/* read the first line in this section */

			if((ReadLine(FilePtr, Buffer, &LineNum) == TRUE) && (strncmp(Buffer, ".End", 4) != 0))
			{
				/* parse out the property names and add each part property number to PartPropertyArray */

				if(!ParseSection3Line(Buffer, AddPartProperties, LineNum))
				{
					return FALSE;
				}

				/* parse out the corresponding property values and process them */

				while((ReadLine(FilePtr, Buffer, &LineNum) == TRUE) && (strncmp(Buffer, ".End", 4) != 0))
				{
					if(!ParseSection3Line(Buffer, ProcessPartProperties, LineNum))
					{
						return FALSE;
					}
				}	 
			}	 
      }
      else if ( strncmp( Buffer, ".Section4", 9 ) == 0 )
      {
			/* read the first line in this section */

			if((ReadLine(FilePtr, Buffer, &LineNum) == TRUE) && (strncmp(Buffer, ".End", 4) != 0))
			{
				/* parse out the property names and add each net property number to NetPropertyArray */

				if(!ParseSection3Line(Buffer, AddNetProperties, LineNum))
				{
					return FALSE;
				}

				/* parse out the corresponding property values and process them */

				while((ReadLine(FilePtr, Buffer, &LineNum) == TRUE) && (strncmp(Buffer, ".End", 4) != 0))
				{
					if(!ParseSection3Line(Buffer, ProcessNetProperties, LineNum))
					{
						return FALSE;
					}
				}	 
			}	 
      }     
	}                                

   return TRUE;
	
} /* End DoOrcadChanges */



/********** ChangePartAttr_Generic **********/

int ChangePartAttr_Generic(int AttrNum, char *RefName, char *Value, int LineNum)
{	
	return ChangeSymAttrByNum(AttrNum, RefName, Value, LineNum);
}

/********** ChangePartAttr_CompLoc **********/

int ChangePartAttr_CompLoc(int AttrNum, char *RefName, char *Value, int LineNum)
{
	char NewValue[64];

	float x,y;

	if(sscanf(Value, "[%f,%f]", &x, &y) != 2)
	{
		return FALSE;
	}
	
	sprintf(NewValue, "%d %d", (int)x, (int)y);

	return ChangeSymAttrByNum(AttrNum, RefName, NewValue, LineNum);
}

/********** ChangeNetAttr_ftoi **********/

int ChangeNetAttr_ftoi(int AttrNum, char *RefName, char *Value, int LineNum)
{
	char NewValue[64];

	float x;

	if(sscanf(Value, "%f", &x) != 1)
	{
		return TRUE;
	}
	
	sprintf(NewValue, "%d", (int)x);

	return ChangeNetAttrByNum(AttrNum, RefName, NewValue, LineNum);
}

/********** ChangeNetAttr_Generic **********/

int ChangeNetAttr_Generic(int AttrNum, char *RefName, char *Value, int LineNum)
{	
	return ChangeNetAttrByNum(AttrNum, RefName, Value, LineNum);
}


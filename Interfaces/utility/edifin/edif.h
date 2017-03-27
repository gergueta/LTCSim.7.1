/* edif.h -- Definitions and structures for EDIF Compiler */

/* Copyright (C) 1993 -- Data I/O Corporation -- All Rights Reserved.
 *
 * This program is protected under the copyright laws as a published work.
 * It may not be copied, reproduced, further distributed, adaptations
 * made from the same, or used to prepare derivative works, without the
 * prior written consent of the Data I/O Corporation
 *
 * History:
 *    5/05/93 - Included in Version 2.5
 */

#define FIGURECLASS             1
#define PORTCLASS               2
#define CELLCLASS               3
#define SYMBOL_PROPERTYCLASS    4
#define PORT_PROPERTYCLASS      5
#define INTERFACE_PROPERTYCLASS 6
#define CELL_PROPERTYCLASS      7

typedef struct tagDEF
 { struct tagDEF* next;
   int id;
   char* name;
 } DEF;

typedef struct tagPROPERTYDEF
 { struct tagPROPERTYDEF* next;
   int id;
   char* name;
   BYTE num;
   BYTE kind;          /* 1 = from SymAttr, 0 = special e.g. titleblock attrs */
   BYTE type;                                        /* K_STRING or K_INTEGER */
 } PROPERTYDEF;

typedef struct tagPORTDEF
 { struct tagPORTDEF* next;
   int id;
   char* name;
   PN_PTR pn;
 } PORTDEF;

typedef struct tagFIGUREDEF
 { struct tagFIGUREDEF* next;
   int id;
   char* name;
   int pathWidth;
   int borderWidth;
   int textHeight;
   int visible;
 } FIGUREDEF;

#define SCALE_IT( num ) \
   if ( num < 0 ) num = ( num * scale_num - scale_denom/2 ) / scale_denom; \
   else           num = ( num * scale_num + scale_denom/2 ) / scale_denom;

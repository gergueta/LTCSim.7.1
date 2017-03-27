/* edifin.h -- Include file of include files */

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

#include "attr.h"
#include "key.h"
#include "sympi.h"
#include "edif.h"
#include "funcs.h"

extern int lookahead;

DEF*        array( int );
int         booleanValue();
char*       designator();
int         display();
int         figure( int );
void        figureGroup();
void        figureGroupOverride();
long        integerDisplay();
long        integerToken();
long        integerValue();
int         keywordDisplay();
DEF*        nameDef( int );
DEF*        nameRef( int );
void        numberDisplay( long*, long* );
void        numberValue( long*, long* );
void        pointValue( POINT* );
void        port();
void        portImplementation();
PROPERTYDEF* property( int );
PROPERTYDEF* propertyDisplay( int );
void        rectangle( int );
char*       stringDisplay();
char*       stringValue();
int         symbol_();
int         typedValue();
int         unit();

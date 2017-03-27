/* pikproc.h - Header file for PIK built applications */

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
#include "platform.h"

#if !defined(__TRDATA_H__)

typedef  DWORD   TD_PTR, TI_PTR, TP_PTR, TN_PTR, TG_PTR, TA_PTR, TPTR;

#endif	// ! __TRDATA_H__

#include "pikfuncs.h"

extern TD_PTR Root_TD;        /* Pointer to the definition for the root block */

extern unsigned long command_flags;    /* low bit if /A through /Z in ECS.INI */

extern char szRootName[];          /* contains the name of the root schematic */

/* Symbol Type Definitions */

#ifndef SY_COMP

#define SY_COMP      1
#define SY_GATE      2
#define SY_CELL      3
#define SY_BLOCK     4
#define SY_GRAPHIC   5
#define SY_PIN       6
#define SY_MASTER    7
#define SY_RIPPER    8

#endif	// ! SY_COMP

/* Net Type Definitions - returned by NetLocExtGbl */

#define LOCAL_NET    0
#define EXTERNAL_NET 1
#define GLOBAL_NET   2


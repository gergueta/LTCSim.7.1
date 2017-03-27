/* scsdef.h -- Constant and Macros for SCS */

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

#ifndef __SCSDEF_H__
#define __SCSDEF_H__

#define MAGIC  0x2778
#define SY_MAGIC  0x57ac
#define SYM_LIB_MAGIC 0x2aa2
#define SCH_LIB_MAGIC 0x2bb2
#define FILE_VERSION 0x3		// set inside of symbols and schematics
#define FILE_MASK 0x7			// symbols or schematics have one of these bits set
#define GRID 16
#define GRIDEXP 4

/* prevent the sheet width and height from being too large.
 * The largest number that we can safely use in pixels is 32000.  The
 * maximum zoom factor is 32 / GRID.  So the maximum world is 1000 * GRID. 
 */
#define MAX_SHEET_WIDTH   1000 * GRID
#define MAX_SHEET_HEIGHT  1000 * GRID
#define MAX_SHEETS 399
	/* A hard-coded definition in Sort_Ports() */
#define PINS_IN_Sort_Ports  10000   /* MAX ? */

#define max_type_name 32
#define max_net_name  256
#define max_inst_name 40
#define max_ref_name  40
#define max_pin_num   10

#define DOT   '.'    /* hierarchical separator */
#define DASH  '-'    /* hierarchical separator */

#endif	// ! __SCSDEF_H__

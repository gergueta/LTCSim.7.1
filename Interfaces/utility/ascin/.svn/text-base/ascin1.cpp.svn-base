/* ascin1.c -- High level parse for ASCII IN */

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

#include "stdafx.h"
#include "ascin.h"

extern int abort_flag;

SI_PTR current_si;           /* keeps track of which symbol gets the SymAttrs */
TB_PTR current_tb;       /* keeps track of which table gets the table entries */

int first_sheet;             /* remembers whether or not we have seen a sheet */
int ver24;              /* old version if TRUE, convert coordinates and fonts */

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

int Asc_In()
 { int key;
   int initialization_error = 1;

   current_si = 0;           /* have not encountered any symbol instances yet */
   current_tb = 0;                /* have not encountered any data tables yet */
   first_sheet = 1;                                      /* have no sheet yet */
   ver24 = FALSE;
   key = GetLine();  /* Version */
   if ( key != K_VERSION ) SynError( "Version expected" );
   else
    { Parse_Version();
      key = GetLine();
      if ( key != K_SHEET ) SynError( "Sheet expected" );
      else
       { Parse_Sheet();
         initialization_error = 0;
       }
    }
   while( !initialization_error && ( key = GetLine() ) >= 0 && !abort_flag )
    { switch( key )
       { case K_ARC:
            Parse_Arc();
            break;
         case K_BUSTAP:
            Parse_BusTap();
            break;
         case K_CIRCLE:
            Parse_Circle();
            break;
         case K_FLAG:
            Parse_Flag();
            break;
         case K_IOPIN:
            Parse_IOPin();
            break;
         case K_LINE:
            Parse_Line();
            break;
         case K_NETATTR:
            Parse_NetAttr();
            break;
         case K_PINATTR:
            Parse_PinAttr();
            break;
         case K_RECTANGLE:
            Parse_Rectangle();
            break;
         case K_SHEET:
            Parse_Sheet();
            break;
         case K_SYMATTR:
            Parse_SymAttr();
            break;
         case K_SYMBOL:
            Parse_Symbol();
            break;
         case K_TABLE:
            Parse_Table();
            break;
         case K_TABLEATTR:
            Parse_TableAttr();
            break;
         case K_TABLEDATA:
            Parse_TableData();
            break;
         case K_TEXT:
            Parse_Text();
            break;
         case K_WINDOW:
            Parse_Window();
            break;
         case K_WIRE:
            Parse_Wire();
            break;
         case K_ATTRFLAG:
            Parse_Attr_Flag();
            break;
         default:
            break;
       }
    }
   return( !initialization_error );
 }

/* asyin1.c -- High level parse for ASCII IN */

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

PN_PTR current_pn;              /* keeps track of which pin gets the PinAttrs */
int ver24;              /* old version if TRUE, convert coordinates and fonts */

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

int Asc_In()
 { int key;
   POINT xy;

   current_pn = 0;                       /* have not encountered any pins yet */
   ver24 = FALSE;
   SymbolInit( 0 );
   xy.x = xy.y = 0;                  /* origin is always zero for saved files */
   Set_Origin( xy );
   key = GetLine();  /* Version */
   if ( key == K_VERSION ) Parse_Version();
   else SynError( "Version Expected" );
   key = GetLine();
   if ( key == K_SYMBOLTYPE ) Parse_SymbolType();
   else SynError( "SymbolType Expected" );
   while( ( key = GetLine() ) >= 0 && !abort_flag )
    { switch( key )
       { case K_LINE:
            Parse_Line();
            break;
         case K_RECTANGLE:
            Parse_Rectangle();
            break;
         case K_CIRCLE:
            Parse_Circle();
            break;
         case K_ARC:
            Parse_Arc();
            break;
         case K_TEXT:
            Parse_Text();
            break;
         case K_SYMATTR:
            Parse_SymAttr();
            break;
         case K_WINDOW:
            Parse_Window();
            break;
         case K_PIN:
            Parse_Pin();
            break;
         case K_PINATTR:
            Parse_PinAttr();
            break;
         default:
            break;
       }
    }
   return( 1 );
 }

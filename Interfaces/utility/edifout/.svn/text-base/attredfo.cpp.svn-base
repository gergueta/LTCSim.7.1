/* attredfo.c -- Pin and Attribute portion of Translator from symbol to EDIF */

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
#include "spikproc.h"
#include "funcs.h"
#include "dwgctrl.h"

extern char *just[];
extern int font_height[];
extern int pin_count;

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/* Text windows are output as property displays for the property which is
   listed as being displayed in the window of that number.  So windows
   must have some attribute displayed in them to be saved.  If the attribute
   for a window does not occur on this symbol we put it out anyway.
   Special attributes CELL, DESIGNATOR and INSTANCE are handled differently. */

                   /*---------- Do_Window ----------*/

int Do_Window( struct _twin* twin )
 { char str[256], str1[256];
   const char* name;
   /* KLUDGE must rewrite this for graphic windows */
   name = NULL;                                    /* start with no attribute */
   if ( twin->number >= GRAPHICWIN_File &&
        twin->number < GRAPHICWIN_File + NUMGRAPHICWINDOWS )
    { /* these are the special attribute windows for title blocks */
      name = GetAttrWindowName( twin->number );
      MakeValidRef( name, str1 );
      sprintf( str, "(propertyDisplay %s", str1 );
      Out( str, 1 );
    }
   else
    { /* find the first attribute for this window */
      int num = GetAttrOfWindow( twin->number );
      if ( num >= 0 )
       { name = GetSymAttrName( num );
         if ( num == NAME+1 )
            Out( "(keywordDisplay cell", 1 );
         else if ( num == NAME )
            Out( "(keywordDisplay instance", 1 );
         else if ( num == REFNAME )
            Out( "(keywordDisplay designator", 1 );
         else
          { MakeValidRef( name, str1 );
            sprintf( str, "(propertyDisplay %s", str1 );
            Out( str, 1 );
          }
       }
    }
   if ( name )
    { if ( twin->font != 2 )                                   /* larger font */
       { sprintf( str,
                  "(display (figureGroupOverride NORMAL (textHeight %d))",
                                                 font_height[ twin->font ] );
       }
      else
       { sprintf( str, "(display NORMAL" );
       }
      Out( str, 1 );
      sprintf( str, "(justify %s)", just[ twin->just ] );
      Out( str, 0 );
      if ( twin->rot )
         Out( "(orientation R90)", 0 );
      sprintf( str, "(origin (pt %d %d))", twin->xo, -twin->yo );
      Out( str, 0 );
      Out( ")", -1 ); /* display */
      Out( ")", -1 ); /* propertyDisplay or keywordDisplay */
    }
   return( FALSE );
 }

                /*---------- Define_Window_Attrs ----------*/

/* define the attributes for the windows */
int Define_Window_Attrs( struct _twin* twin )
 { char str[256], str1[256];
   const char* name;
   /* EDIF requires that properties be defined before being referenced.
      Here we define any property needed for attribute windows in case it
      was not already defined because of having a value for the attribute */
   name = NULL;                                    /* start with no attribute */
   if ( twin->number >= GRAPHICWIN_File &&
        twin->number < GRAPHICWIN_File + NUMGRAPHICWINDOWS )
    { /* these are the special attribute windows for title blocks */
      name = GetAttrWindowName( twin->number );
    }
   else
    { /* find the first attribute for this window */
      int num = GetAttrOfWindow( twin->number );
      /* skip InstName, Type and RefName which are handled as EDIF
         keywords cell, instance and designator */
      if ( num >= 0 && num != NAME+1 && num != NAME && num != REFNAME )
       { if ( !*Get_SYA( num ) )          /* This window did not have a value */
            name = GetSymAttrName( num );
       }
    }
   if ( name )
    { MakeValidRef( name, str1 );
      sprintf( str, "(property %s (string \"\"))", str1 );
      Out( str, 0 );
    }
   return( FALSE );
 }

                /*---------- Do_Symbol_Attributes ----------*/

int Do_Symbol_Attributes( int num, const char* value )
 { char str[256], str1[256];
   const char* name;
   name = GetSymAttrName( num );
   if ( *name )
    { if ( num == NAME || num == NAME+1 );
      else if ( num == REFNAME )
       { MakeValidString( value, str1 );
         sprintf( str, "(designator %s)", str1 );
         Out( str, 0 );
       }
      else
       { MakeValidName( name, str1 );
         sprintf( str, "(property %s", str1 );
         Out( str, 1 );
         MakeValidString( value, str1 );
         sprintf( str, "(string %s)", str1 );
         Out( str, 0 );
         Out( ")", -1 ); /* property */
       }
    }
   return( FALSE );
 }

               /*---------- Do_Symbol_Pin_Attributes ----------*/

int Do_Symbol_Pin_Attributes( int num, const char* value )
 { char str[256], str1[256];
   const char* name;
   if ( num == PINNUM )
    { MakeValidString( value, str1 );
      sprintf( str, "(designator %s)", str1 );
      Out( str, 0 );
    }
   else if ( num == PINUSE )
    { if ( *value == 'O' ) strcpy( str1, "OUTPUT" );
      else if ( *value == 'I' ) strcpy( str1, "INPUT" );
      else strcpy( str1, "INOUT" );
      sprintf( str, "(direction %s)", str1 );
      Out( str, 0 );
    }
   else if ( num == FANIN )                        /* must be number on INPUT */
    { MakeValidNumberValue( value, str1 );
      sprintf( str, "(dcFanoutLoad %s)", str1 );
      Out( str, 0 );
    }
   else if ( num == FANOUT )                      /* must be number on OUTPUT */
    { MakeValidNumberValue( value, str1 );
      sprintf( str, "(dcMaxFanout %s)", str1 );
      Out( str, 0 );
    }
   /* could also have acLoad? and unused special cased */
   else
    { name = GetPinAttrName( num );
      if ( *name )
       { MakeValidName( name, str1 );
         sprintf( str, "(property %s", str1 );
         Out( str, 1 );
         MakeValidString( value, str1 );
         sprintf( str, "(string %s)", str1 );
         Out( str, 0 );
         Out( ")", -1 ); /* property */
       }
    }
   return( FALSE );
 }

                     /*---------- Do_Pin_Locations ----------*/

int Do_Pin_Locations( PN_PTR pn, struct _pin* pin )
 { char str[256], str1[256];
   const char* name;
   struct _bounding_box *box;
   int xo, yo, type, fjr;
   name = Get_PNA( pn, NAME );
   if ( !*name )
    { sprintf( str, "$%d", pin_count++ );
      name = str;
    }
   MakeValidRef( name, str1 );
   sprintf( str, "(portImplementation %s", str1 );
   Out( str, 1 );
   xo = pin->xo;
   yo = pin->yo;
   sprintf( str, "(connectLocation (figure NORMAL (dot (pt %d %d))))",
                                                        xo, -yo );
   Out( str, 0 );
   type = SymbolType();
   if ( type == SY_GATE || type == SY_COMP )
    { Out( "(keywordDisplay designator", 1 );
      fjr = 1;
      /* Change This after we get origin */
      box = GetSymbolBoundingBox();
      if      ( xo <= box->l )    { xo += 8; fjr = 3; }
      else if ( xo >= box->r )      xo -= 8;
      else if ( yo <= box->t )
       { if ( CTL_RotPinNumbers ) { yo += 8; fjr = 0x11; }
         else                       fjr = 7;
       }
      else if ( yo >= box->b )
       { if ( CTL_RotPinNumbers ) { yo -= 8; fjr = 0x13; }
       }
      else if ( xo > ( box->r - box->l ) / 2 )
         fjr = 3;

      if ( ( fjr & 0x0e0 ) != 2 )                              /* larger font */
       { sprintf( str,
                  "(display (figureGroupOverride NORMAL (textHeight %d))",
                                                 font_height[ fjr >> 5 ] );
       }
      else
       { sprintf( str, "(display NORMAL" );
       }
      Out( str, 1 );
      sprintf( str, "(justify %s)", just[ fjr & 0x0f ] );
      Out( str, 0 );
      if ( fjr & 0x10 )
         Out( "(orientation R90)", 0 );
      sprintf( str, "(origin (pt %d %d))", xo, -yo );
      Out( str, 0 );
      Out( ")", -1 ); /* display */
      Out( ")", -1 ); /* keywordDisplay */
    }
   /* reload xo and yo since getting the designator may have changed them */
   xo = pin->xo;
   yo = pin->yo;
   if ( pin->name_dir )
    { MakeValidRef( GetPinAttrName( NAME ), str1 );
      sprintf( str, "(propertyDisplay %s", str1 );
      Out( str, 1 );
      switch( pin->name_dir )
       { case 2:
         case 0x14:
            yo -= pin->name_offset;
            break;
         case 4:
         case 0x18:
            xo += pin->name_offset;
            break;
         case 6:
         case 0x12:
            xo -= pin->name_offset;
            break;
         case 8:
         case 0x16:
            yo += pin->name_offset;
            break;
       }
      if ( pin->name_font != 2 )
       { sprintf( str,
                  "(display (figureGroupOverride NORMAL (textHeight %d))",
                                             font_height[ pin->name_font ] );
       }
      else
       { sprintf( str, "(display NORMAL" );
       }
      Out( str, 1 );
      sprintf( str, "(justify %s)", just[ pin->name_dir & 0x0f ] );
      Out( str, 0 );
      if ( pin->name_dir & 0x10 )
         Out( "(orientation R90)", 0 );
      sprintf( str, "(origin (pt %d %d))", xo, -yo );
      Out( str, 0 );
      Out( ")", -1 ); /* display */
      Out( ")", -1 ); /* propertyDisplay */
    }
   Out( ")", -1 ); /* portImplementation */
   return( FALSE );
 }

                     /*---------- Do_Pins ----------*/

int Do_Pins( PN_PTR pn, struct _pin* pin )
 { char str[256], str1[256];
   const char* name;
   name = Get_PNA( pn, NAME );
   if ( !*name )
    { sprintf( str, "$%d", pin_count++ );
      name = str;
    }
   MakeValidName( name, str1 );
   sprintf( str, "(port %s", str1 );
   Out( str, 1 );
   ForEachSymbolPinAttribute( pn, 0, 255, Do_Symbol_Pin_Attributes );
   if ( !*Get_PNA( pn, PINUSE ) )
      Out( "(direction INPUT)", 0 );
   Out( ")", -1 ); /* port */
   return( FALSE );
 }

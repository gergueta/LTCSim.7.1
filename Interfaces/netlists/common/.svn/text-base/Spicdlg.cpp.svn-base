#include "stdafx.h"
#include <windows.h>
#include "pikproc.h"

extern HINSTANCE _hInstance;

extern unsigned long command_flags;
extern char szRootName[];
extern int bCmd_LVS;
extern int bCmd_Flat;
extern int bCmd_Macro, bCmd_Node_Names, bCmd_Use_Globals, bCmd_PrimitiveLevel;
extern int bCmd_Units;
extern int bCmd_XGNDXto0;
extern int bCmd_Shrink;
extern int bCmd_GNDto0;
extern int bCmd_WLRes;
extern int bCmd_WLBip;
extern int bCmd_AreaBip;
extern int bCmd_MixedSignal;
extern int bCmd_FilterPrefix;

char szCmd_MultiCode[] = "M=";

/* Options:
           NodeNames  Globals    Macro      PrimLevel   MultiCode
   LVS      TRUE       TRUE       TRUE       FALSE      "M="  */


static int cancel_dlg = FALSE;
static int user_picked_macro;

#define IDD_B_SPICE     300
#define IDD_P_SPICE     301
#define IDD_H_SPICE     302
#define IDD_LVS         303
#define IDD_MACRO       311
#define IDD_NODE_NAMES  312
#define IDD_USE_GLOBALS 313
#define IDD_PRIM        314
#define IDD_GND         315

                      /*---------- Setup_Dlg ----------*/

BOOL CALLBACK Setup_Dlg( HWND hWnd, unsigned message, WPARAM wParam, LPARAM lParam )
{
  int retn = TRUE;
  
  switch ( message ) {
  case WM_INITDIALOG:
    CheckDlgButton( hWnd, IDD_NODE_NAMES, bCmd_Node_Names );

    CheckRadioButton( hWnd, IDD_LVS, IDD_LVS, IDD_LVS);
    if ( !bCmd_Flat ) {
      CheckDlgButton( hWnd, IDD_MACRO, bCmd_Macro );
      CheckDlgButton( hWnd, IDD_USE_GLOBALS, bCmd_Use_Globals );
      if ( bCmd_PrimitiveLevel ) CheckDlgButton( hWnd, IDD_PRIM, 1 );
    }
    break;
  case WM_COMMAND:                                   /* a command came in */
    int cmd, id;
    id = LOWORD(wParam);
#ifdef _WIN32
    cmd = HIWORD(wParam);
#else
    cmd = HIWORD(lParam);
#endif
    switch ( wParam ){
    case IDOK:
      EndDialog( hWnd, FALSE );
      break;
    case IDCANCEL:
      cancel_dlg = TRUE;
      EndDialog( hWnd, TRUE );
      break;
    case IDD_LVS:
      bCmd_LVS = 0;
      if ( !user_picked_macro )
	bCmd_Macro = 0;                        /* follows LVS option */
      CheckRadioButton( hWnd, IDD_LVS, IDD_LVS, wParam );
      if ( wParam == IDD_LVS ) {
	bCmd_LVS = 1;
	bCmd_Macro = bCmd_Node_Names = bCmd_Use_Globals = TRUE;
      }
      CheckDlgButton( hWnd, IDD_NODE_NAMES, bCmd_Node_Names );
      if ( !bCmd_Flat )	{
	CheckDlgButton( hWnd, IDD_USE_GLOBALS, bCmd_Use_Globals );
	CheckDlgButton( hWnd, IDD_MACRO, bCmd_Macro );
      }
      break;
    case IDD_MACRO:
      bCmd_Macro = !IsDlgButtonChecked( hWnd, IDD_MACRO );
      user_picked_macro = bCmd_Macro; /* leave unless user changes it */
      CheckDlgButton( hWnd, wParam, bCmd_Macro );
      break;
    case IDD_NODE_NAMES:
      bCmd_Node_Names = !IsDlgButtonChecked( hWnd, IDD_NODE_NAMES );
      CheckDlgButton( hWnd, wParam, bCmd_Node_Names );
      break;
    case IDD_USE_GLOBALS:
      bCmd_Use_Globals = !IsDlgButtonChecked( hWnd, IDD_USE_GLOBALS );
      CheckDlgButton( hWnd, wParam, bCmd_Use_Globals );
      break;
    case IDD_PRIM:
      bCmd_PrimitiveLevel = !IsDlgButtonChecked( hWnd, IDD_PRIM );
      CheckDlgButton( hWnd, wParam, bCmd_PrimitiveLevel );
      break;
    case IDD_GND:
      bCmd_XGNDXto0 = !IsDlgButtonChecked( hWnd, IDD_GND );
      CheckDlgButton( hWnd, wParam, bCmd_XGNDXto0 );
      break;
    default:
      retn = FALSE;
    }
    break;
  default:
    retn = FALSE;
    break;
  }
  return retn;
}

                      /*---------- PreProcess ----------*/

int PreProcess( int argc, char *argv[] )
{
  bCmd_LVS = 0;
  bCmd_FilterPrefix = 0;
  bCmd_Macro = 0;
  bCmd_Node_Names = 0;
  bCmd_MixedSignal = 0;
  bCmd_AreaBip = 0;
  bCmd_Shrink = 0;
  bCmd_Units = 0;
  bCmd_WLBip = 0;
  bCmd_GNDto0 = 0;
  bCmd_XGNDXto0 = 0;
  
  if ( 1 & (int)( command_flags >> ( 'L' - 'A' ) ) ) 
    bCmd_LVS = 1;
  else                                               
    bCmd_LVS = 1;
  
  bCmd_Units = 1;
  
  if (1 & (int)( command_flags >> ( 'F' - 'A' ) ) ) bCmd_FilterPrefix = 1;
  if (1 & (int)( command_flags >> ( 'M' - 'A' ) ) ) bCmd_Macro = 1;
  if (1 & (int)( command_flags >> ( 'N' - 'A' ) ) ) bCmd_Node_Names = 1;
  if (1 & (int)( command_flags >> ( 'P' - 'A' ) ) ) bCmd_MixedSignal = 1;
  
  if (1 & (int)( command_flags >> ( 'R' - 'A' ) ) ) bCmd_AreaBip = 1;
  if (1 & (int)( command_flags >> ( 'S' - 'A' ) ) ) bCmd_Shrink = 1;
  
  if (1 & (int)( command_flags >> ( 'U' - 'A' ) ) ) bCmd_Units = 0;
  if (1 & (int)( command_flags >> ( 'W' - 'A' ) ) ) bCmd_WLBip = 1;
  if (1 & (int)( command_flags >> ( 'Y' - 'A' ) ) ) bCmd_GNDto0 = 1;
  if (1 & (int)( command_flags >> ( 'Z' - 'A' ) ) ) bCmd_XGNDXto0 = 1;
  
  /* Default for LVS was being triggered off only if user clicked on another
     button - MTL */
  if ( !bCmd_Flat ) {
    bCmd_Macro = 1 & (int)( command_flags >> ( 'M' - 'A' ) );
    user_picked_macro = bCmd_Macro;      /* leave set unless user changes it */
    
    if (1 & (int)( command_flags >> ( 'G' - 'A' ) ) ) bCmd_Use_Globals = 1;
    
    bCmd_PrimitiveLevel = !( 1 & (int)( command_flags >> ( 'X' - 'A' ) ) );
  }
  
  /*
    if ( ( command_flags & 1 ) == 0 )                 
    {
    DialogBox( _hInstance, MAKEINTRESOURCE(1), NULL, Setup_Dlg );
    }
  */
  
  /* Watch this since bCmd_MultiCode has only a three byte buffer */
  strcpy( szCmd_MultiCode, "M=" );
  
  return( cancel_dlg );
}

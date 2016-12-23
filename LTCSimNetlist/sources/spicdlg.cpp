#include "stdafx.h"
#include <windows.h>
#include "pikproc.h"
#include <atlstr.h>

extern HINSTANCE _hInstance;

extern unsigned long command_flags;
extern char szRootName[];
extern int bCmd_LVS;
extern int bCmd_Flat;
extern int bCmd_Macro;
extern int bCmd_Node_Names;
extern int bCmd_Use_Globals;
extern int bCmd_PrimitiveLevel;
extern int bCmd_Units;
extern int bCmd_XGNDXto0;
extern int bCmd_Shrink;
extern int bCmd_GNDto0;
extern int bCmd_WLRes;
extern int bCmd_WLBip;
extern int bCmd_AreaBip;
extern int bCmd_MixedSignal;
extern int bCmd_VerilogA;
extern int bCmd_FilterPrefix;
extern char cCmd_Tool;
extern int bCmd_Simulate;
int bCmd_GenerateNets;
int bCmd_BackAnnCaps;

char szCmd_MultiCode[] = "m=";

static int cancel_dlg = FALSE;
static int user_picked_macro;

#define IDC_GND         1013
#define IDC_XGNDX       1000
#define IDC_SUBCIRCUIT  311
#define IDC_OMITPREFIX  1014
#define IDC_NODE_NAMES  312
#define IDC_LTSPICE		1003
#define IDC_HSPICE		1005
#define IDC_PSPICE		1004
#define IDC_APT			1006
#define IDC_ASSURA		1007
#define IDC_CDL			1017
#define IDC_LVS			406
#define IDC_MACRO		407
#define IDC_MIXED_SIGNAL 1018
#define IDC_VERILOGA	1020
#define	IDC_BIPOLAR_AREA 1022
#define	IDC_BIPOLAR_WL	1023
#define IDC_TAB			1026

/*---------- Setup_Dlg ----------*/

BOOL CALLBACK Setup_Dlg(HWND hWnd, unsigned message, WPARAM wParam, LPARAM lParam)
{
    int retn = TRUE;

    switch (message)
    {
        case WM_INITDIALOG:
            CheckRadioButton(hWnd, IDC_LTSPICE, IDC_CDL, IDC_LTSPICE);
			cCmd_Tool = 'l';
            CheckDlgButton(hWnd, IDC_OMITPREFIX, BST_CHECKED);				
	        CheckDlgButton(hWnd, IDC_GND, BST_CHECKED);
            break;
        case WM_COMMAND:
             /* a command came in */
            int cmd, id;
            id = LOWORD(wParam);
#ifdef _WIN32
            cmd = HIWORD(wParam);
#else 
            cmd = HIWORD(lParam);
#endif 
            switch (wParam)
            {
			case IDC_LTSPICE:
				cCmd_Tool = 't';
	            CheckDlgButton(hWnd, IDC_GND, BST_CHECKED);				
				break;
			case IDC_HSPICE:
				cCmd_Tool = 'h';
	            CheckDlgButton(hWnd, IDC_GND, BST_CHECKED);				
				break;
			case IDC_PSPICE:
				cCmd_Tool = 'p';
	            CheckDlgButton(hWnd, IDC_GND, BST_CHECKED);				
				break;
			case IDC_APT:
				cCmd_Tool = 'a';
		        CheckDlgButton(hWnd, IDC_SUBCIRCUIT, BST_CHECKED);				
				break;
			case IDC_ASSURA:
				cCmd_Tool = 's';
		        CheckDlgButton(hWnd, IDC_SUBCIRCUIT, BST_CHECKED);				
				break;
			case IDC_CDL:
				cCmd_Tool = 'c';
		        CheckDlgButton(hWnd, IDC_SUBCIRCUIT, BST_CHECKED);				
				break;
			case IDOK:
				bCmd_MixedSignal = IsDlgButtonChecked(hWnd, IDC_MIXED_SIGNAL);                
		        bCmd_GNDto0 = IsDlgButtonChecked(hWnd, IDC_GND);
				bCmd_XGNDXto0 = IsDlgButtonChecked(hWnd, IDC_XGNDX);
				bCmd_Macro = IsDlgButtonChecked(hWnd, IDC_SUBCIRCUIT);
				bCmd_FilterPrefix = IsDlgButtonChecked(hWnd, IDC_OMITPREFIX);
				bCmd_MixedSignal = IsDlgButtonChecked(hWnd, IDC_MIXED_SIGNAL);
				bCmd_VerilogA = IsDlgButtonChecked(hWnd, IDC_VERILOGA);
				bCmd_AreaBip = IsDlgButtonChecked(hWnd, IDC_BIPOLAR_AREA);
				bCmd_WLBip = IsDlgButtonChecked(hWnd, IDC_BIPOLAR_WL);
				EndDialog(hWnd, FALSE);
				break;
			case IDCANCEL:
				cancel_dlg = TRUE;
				EndDialog(hWnd, TRUE);
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
	if (1 &(int)(command_flags >> ('I' - 'A')))
        bCmd_Simulate = 1;

/*   
	if (!bCmd_Flat)
    {
        bCmd_Macro = 1 &(int)(command_flags >> ('M' - 'A'));
        user_picked_macro = bCmd_Macro; 

        if (1 &(int)(command_flags >> ('G' - 'A')))
            bCmd_Use_Globals = 1;

        bCmd_PrimitiveLevel = !(1 &(int)(command_flags >> ('X' - 'A')));
    }

	if ( command_flags == 0 )                 
    {
        DialogBox( _hInstance, MAKEINTRESOURCE(1), NULL, Setup_Dlg );
    }
*/

    /* Watch this since bCmd_MultiCode has only a three byte buffer */
    strcpy_s(szCmd_MultiCode, "M=");

    return (cancel_dlg);

}

#pragma once
#include "LTCUtils.h"

using namespace System;
using namespace System::ComponentModel;
using namespace System::Collections;
using namespace System::Windows::Forms;
using namespace System::Data;
using namespace System::Drawing;
using namespace System::Runtime::InteropServices;

extern int bCmd_Node_Names;
extern int bCmd_Use_Globals;
extern int bCmd_LVS;
extern int bCmd_Units;
extern int bCmd_Flat;
extern int bCmd_PrimitiveLevel;
extern char cCmd_Tool;
extern int bCmd_AreaBip;
extern int bCmd_WLBip;
extern char* sLVSShort;
extern int bCmd_MixedSignal;
extern char* sCommand;
extern char* sOptions;
extern char* sBracketSubstitutionLeft;
extern char* sBracketSubstitutionRight;
extern int bCmd_Macro;
extern int bCmd_XGNDXto0;
extern int bCmd_GNDto0;
extern int bCmd_FilterPrefix;
extern int bCmd_Shrink;
extern char* sWorkingDir;
extern char* sStim;
extern int bCmd_PrimitiveReport;
extern int bCmd_IgnoreCase;

namespace LTCSimNetlist {

	/// <summary>
	/// Summary for LTCXmlUtils
	/// </summary>
	public ref class LTCXmlUtils : public System::Windows::Forms::UserControl
	{
	public:
		LTCXmlUtils(void)
		{
			InitializeComponent();
			//
			//TODO: Add the constructor code here
			//
		}
		String^ LTCSetFileExtension();
		String^ xmlProjectReader(String^ xmlFileName, String^ xmlData);
		int readLTCSimXmlParameters(String^ xmlFileName);
		int LTCReadXmlValueInt(String^ xmlFileName, String^ xmlSection, String^ xmlParam);
		char *LTCReadXmlValueChar(String^ xmlFileName, String^ xmlSection, String^ xmlParam);
		int LTCReadXmlValueBool(String^ xmlFileName, String^ xmlSection, String^ xmlParam);
		String^ LTCReadXmlValueString(String^ xmlFileName, String^ xmlSection, String^ xmlParam);
		bool LTCReadToolInUse(String^ sTool, int iLTspiceSyntax);

	protected:
		/// <summary>
		/// Clean up any resources being used.
		/// </summary>
		~LTCXmlUtils()
		{
			if (components)
			{
				delete components;
			}
		}

	private:
		/// <summary>
		/// Required designer variable.
		/// </summary>
		System::ComponentModel::Container ^components;

#pragma region Windows Form Designer generated code
		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		void InitializeComponent(void)
		{
			this->AutoScaleMode = System::Windows::Forms::AutoScaleMode::Font;
		}
#pragma endregion
	};
}

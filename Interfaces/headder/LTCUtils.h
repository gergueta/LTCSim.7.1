#pragma once
#include "Windows.h"
#include <stdafx.h>
#include "pikproc.h"


using namespace System;
using namespace System::ComponentModel;
using namespace System::Collections;
using namespace System::Diagnostics;
using namespace System::Runtime::InteropServices;
using namespace System::IO;
using namespace System::Text;


extern char cCmd_Tool;
extern int LTCSim_List_Type(TD_PTR td);
extern FILE *file;


namespace LTCSimNetlist {

	/// <summary>
	/// Summary for LTCUtils
	/// </summary>
	public ref class LTCUtils :  public System::ComponentModel::Component
	{
	public:
		LTCUtils(void)
		{
			InitializeComponent();
			//
			//TODO: Add the constructor code here
			//
		}
		char* LtcStringToChars(String^ sText);
		char* LtcStringBuilderToChars(StringBuilder^ sText);
		String^ LtcCharsToString(char* cChar);
		StringBuilder^ LtcCharsToStringBuilder(char* cChar);
		int LTCGenerateList(char* sReportFileName);
		int LTCStartSimulation(String ^Command, String ^Options, String ^Stim);
		StringBuilder^ LtcCharsToStringBuilder(const char aChar[]);

		LTCUtils(System::ComponentModel::IContainer ^container)
		{
			/// <summary>
			/// Required for Windows.Forms Class Composition Designer support
			/// </summary>

			container->Add(this);
			InitializeComponent();
		}

	protected:
		/// <summary>
		/// Clean up any resources being used.
		/// </summary>
		~LTCUtils()
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
			components = gcnew System::ComponentModel::Container();
		}
#pragma endregion
	};
}

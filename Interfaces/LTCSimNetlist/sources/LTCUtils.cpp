#include "LTCUtils.h"

char* LTCSimNetlist::LTCUtils::LtcStringToChars(String^ sText)
{
	IntPtr ptrToNativeString = Marshal::StringToHGlobalAnsi(sText);
	return static_cast<char*>(ptrToNativeString.ToPointer());
}

char* LTCSimNetlist::LTCUtils::LtcStringBuilderToChars(StringBuilder^ sText)
{
	String^ sTemp = sText->ToString();
	IntPtr ptrToNativeString = Marshal::StringToHGlobalAnsi(sTemp);
	return static_cast<char*>(ptrToNativeString.ToPointer());
}

String^ LTCSimNetlist::LTCUtils::LtcCharsToString(char* cChar)
{
	return gcnew String(cChar);
}

StringBuilder^ LTCSimNetlist::LTCUtils::LtcCharsToStringBuilder(char* cChar)
{
	String^ sTemp = gcnew String(cChar);
	return gcnew StringBuilder(sTemp);
}

StringBuilder^ LTCSimNetlist::LTCUtils::LtcCharsToStringBuilder(const char aChar[])
{
	StringBuilder^ sb = gcnew StringBuilder();
	for (int i = 0; aChar[i]; i++)
	{
		sb->Append((Char)aChar[i]);
	}
	return (sb);
}


int LTCSimNetlist::LTCUtils::LTCGenerateList(char* sReportFileName)
{
	// Generate new report
	try
	{
		errno_t err;
		if ((err = fopen_s(&file, sReportFileName, "w")) != 0)
		{
			fprintf(stderr, "Cannot open report file %s!\n", sReportFileName);
		}
		else
		{
			fprintf(file, "* LTCSim: Primitive device list\n\n");
			fprintf(file, "* X: Subcircuit (Macro)\n");
			fprintf(file, "* Q: Bipolar\n");
			fprintf(file, "* M: Mosfet\n");
			fprintf(file, "* D: Diode\n");
			fprintf(file, "* R: Resistor\n");
			fprintf(file, "* C: Capacitor\n");
			fprintf(file, "* L: Inductor\n");
			fprintf(file, "* J: JFet\n");
			fprintf(file, "*\n");
			SetupBlockScan();
			ForEachDescriptor( LTCSim_List_Type );
			//ForEachBlockOrCell(LTCSim_List_Type);
			fclose(file);
		}
	}
	catch (System::Exception ^ex)
	{
		MessageBox(0, "Error opening report file", "LTCSim message", MB_OK);
	}
	return 0;
}

int  LTCSimNetlist::LTCUtils::LTCStartSimulation(String^ Command, String^ Options, String ^Stim)
{
	ProcessStartInfo^ startInfo = gcnew ProcessStartInfo();
	Command = Command->Replace("\\", "\\\\");
	Stim = Stim->Replace("\\", "\\\\");
	FileInfo ^fileInformation = gcnew FileInfo(Stim);
	String ^sWorkingDir = fileInformation->DirectoryName;
	String ^Argument = Options + " " + Stim;
	startInfo->FileName = Command;
	startInfo->Arguments = Argument;
	startInfo->WorkingDirectory = sWorkingDir;
	Process::Start(startInfo);
	//Process::Start("C:\\Program Files (x86)\\LTC\\LTspiceIV\\scad3.exe");
	return (0);
}

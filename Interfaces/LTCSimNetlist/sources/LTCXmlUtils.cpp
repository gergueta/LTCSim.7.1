#include "LTCXmlUtils.h"

using namespace System;
using namespace System::Xml;
using namespace System::Xml::XPath;

String^ LTCSimNetlist::LTCXmlUtils::LTCSetFileExtension(){
	String^ Ext;
	switch (cCmd_Tool)
	{
	case 'l':
		Ext = ".spi";
		break;
	case 'p':
		Ext = ".spi";
		break;
	case 'h':
		Ext = ".spi";
		break;
	case 'a':
		Ext = ".net";
		break;
	case 'd':
		Ext = ".net";
		break;
	case 't':
		Ext = ".apt";
		break;
	}
	return(Ext);
}

String^ LTCSimNetlist::LTCXmlUtils::xmlProjectReader(String^ xmlFileName, String^ xmlData)
{
	//XmlDocument ^xmlDoc = gcnew XmlDocument();
	String^ sValue;
	try
	{
		XPathDocument ^xmlDoc = gcnew XPathDocument(xmlFileName);
		//xmlDoc->Load(xmlFileName);
		XPathNavigator ^xPathNav = xmlDoc->CreateNavigator();
		XPathNodeIterator ^list = xPathNav->Select(xmlData);
		list->MoveNext();
		XPathNavigator ^n = list->Current;
		sValue = n->Value;
	}
	catch (Exception ^ex) {
		String^ message = "Error loading project.xml file";
		String^ caption = "LTCSim error";
		MessageBoxButtons buttons = MessageBoxButtons::OK;
		MessageBox::Show(this, message, caption, buttons);
	}
	return sValue;
}

int LTCSimNetlist::LTCXmlUtils::LTCReadXmlValueInt(String^ xmlFileName, String^ xmlSection, String^ xmlParam)
{
	String^ xmlSectionData = "/LTCSimProject/" + xmlSection + "/" + xmlParam + "[1]";
	String^ sTemp = xmlProjectReader(xmlFileName, xmlSectionData);
	if (sTemp->Equals("0"))
		return 0;
	else
		return 1;
}

char *LTCSimNetlist::LTCXmlUtils::LTCReadXmlValueChar(String^ xmlFileName, String^ xmlSection, String^ xmlParam)
{
	String^ xmlSectionData = "/LTCSimProject/" + xmlSection + "/" + xmlParam + "[1]";
	String^ sTemp = xmlProjectReader(xmlFileName, xmlSectionData);
	LTCUtils ltcUtility;
	return ltcUtility.LtcStringToChars(sTemp);
}

int LTCSimNetlist::LTCXmlUtils::LTCReadXmlValueBool(String^ xmlFileName, String^ xmlSection, String^ xmlParam)
{
	String^ xmlSectionData = "/LTCSimProject/" + xmlSection + "/" + xmlParam + "[1]";
	String^ sTemp = xmlProjectReader(xmlFileName, xmlSectionData);
	if (sTemp->Equals("false"))
		return 0;
	else
		return 1;
}
String^ LTCSimNetlist::LTCXmlUtils::LTCReadXmlValueString(String^ xmlFileName, String^ xmlSection, String^ xmlParam)
{
	String^ xmlSectionData = "/LTCSimProject/" + xmlSection + "/" + xmlParam + "[1]";
	return xmlProjectReader(xmlFileName, xmlSectionData);
}

bool LTCSimNetlist::LTCXmlUtils::LTCReadToolInUse(String^ sTool, int iLtspiceSyntax) {
	bool retVal = true;

	if ((sTool->CompareTo("LTspice")) == 0)
	{
		if (iLtspiceSyntax == 0)
			cCmd_Tool = 'l';
		else
			cCmd_Tool = 'h';
	}
	else if ((sTool->CompareTo("HSpice")) == 0)
		cCmd_Tool = 'h';
	else if ((sTool->CompareTo("PSpice")) == 0)
		cCmd_Tool = 'p';
	else if ((sTool->CompareTo("Assura")) == 0)
		cCmd_Tool = 'a';
	else if ((sTool->CompareTo("Dracula")) == 0)
		cCmd_Tool = 'd';
	else if ((sTool->CompareTo("APT")) == 0)
		cCmd_Tool = 't';
	else retVal = false;
	return retVal;
}

int LTCSimNetlist::LTCXmlUtils::readLTCSimXmlParameters(String^ xmlFileName)
{

	bCmd_Node_Names = true;
	bCmd_Use_Globals = true;
	bCmd_LVS = false;
	bCmd_Units = true;
	bCmd_Flat = false;
	bCmd_PrimitiveLevel = true;
	String^ xmlData;
	String^ sInfo;
	String^ sSchemDir;
	IntPtr ptrToNativeString;
	LTCUtils ltcUtility;

	/* Read tool to netlist*/
	xmlData = "/LTCSimProject/Project/currentTool[1]";
	sInfo = xmlProjectReader(xmlFileName, xmlData);
	int iLtspiceSyntax = LTCReadXmlValueInt(xmlFileName, "LTspice", "ltspiceSyntax");

	if ((sInfo->Length) < 1)
	{
		String^ message = "Error: Tool not selected!";
		String^ caption = "LTCSim error";
		MessageBoxButtons buttons = MessageBoxButtons::OK;
		MessageBox::Show(this, message, caption, buttons);
	}
	else
	{
		LTCReadToolInUse(sInfo, iLtspiceSyntax);
	}

	/* Read Project schem directory name*/
	sSchemDir = LTCReadXmlValueString(xmlFileName, "Project", "schemDir");

	/* Read Project simulation directory name*/
	sInfo = LTCReadXmlValueString(xmlFileName, "Project", "relSimDir");
	sInfo = sSchemDir + "\\" + sInfo;
	sWorkingDir = ltcUtility.LtcStringToChars(sInfo);

	/* Read stimulus name*/
	sInfo = LTCReadXmlValueString(xmlFileName, "Project", "currentStimulus");
	if (sInfo->StartsWith("\\"))
		sInfo = sSchemDir + sInfo;
	else
		sInfo = sSchemDir + "\\" + sInfo;
	sStim = ltcUtility.LtcStringToChars(sInfo);

	/* Read Project primitive list report request*/
	bCmd_PrimitiveReport = LTCReadXmlValueBool(xmlFileName, "Project", "primReport");

	/* Read Project ignore case option*/
	bCmd_IgnoreCase = LTCReadXmlValueBool(xmlFileName, "Project", "ignoreCase");

	/* Read Project name*/
	xmlData = "/LTCSimProject/Project/name[1]";
	sInfo = xmlProjectReader(xmlFileName, xmlData);

	switch (cCmd_Tool)
	{
	case 'l':
		sCommand = LTCReadXmlValueChar(xmlFileName, "LTspice", "ltspiceCommand");
		sOptions = LTCReadXmlValueChar(xmlFileName, "LTspice", "ltspiceCommandOptions");
		sBracketSubstitutionLeft = LTCReadXmlValueChar(xmlFileName, "LTspice", "ltspiceLeftBracket");
		sBracketSubstitutionRight = LTCReadXmlValueChar(xmlFileName, "LTspice", "ltspiceRightBracket");
		bCmd_Macro = LTCReadXmlValueBool(xmlFileName, "LTspice", "ltspiceSubCircuit");
		bCmd_XGNDXto0 = LTCReadXmlValueBool(xmlFileName, "LTspice", "ltspiceXGNDX");
		bCmd_GNDto0 = LTCReadXmlValueBool(xmlFileName, "LTspice", "ltspiceGND");
		bCmd_FilterPrefix = LTCReadXmlValueBool(xmlFileName, "LTspice", "ltspiceOmitPrefix");
		bCmd_Shrink = LTCReadXmlValueBool(xmlFileName, "LTspice", "ltspiceShrink");
		iLtspiceSyntax = LTCReadXmlValueBool(xmlFileName, "LTspice", "ltspiceSyntax");
		break;
	case 'p':
		sCommand = LTCReadXmlValueChar(xmlFileName, "PSpice", "pspiceCommand");
		sOptions = LTCReadXmlValueChar(xmlFileName, "PSpice", "pspiceCommandOptions");
		sBracketSubstitutionLeft = LTCReadXmlValueChar(xmlFileName, "PSpice", "pspiceLeftBracket");
		sBracketSubstitutionRight = LTCReadXmlValueChar(xmlFileName, "PSpice", "pspiceRightBracket");
		bCmd_Macro = LTCReadXmlValueBool(xmlFileName, "PSpice", "pspiceSubCircuit");
		bCmd_XGNDXto0 = LTCReadXmlValueBool(xmlFileName, "PSpice", "pspiceXGNDX");
		bCmd_GNDto0 = LTCReadXmlValueBool(xmlFileName, "PSpice", "pspiceGND");
		bCmd_FilterPrefix = LTCReadXmlValueBool(xmlFileName, "PSpice", "pspiceOmitPrefix");
		bCmd_MixedSignal = LTCReadXmlValueBool(xmlFileName, "PSpice", "pspiceAD");
		bCmd_Shrink = LTCReadXmlValueBool(xmlFileName, "PSpice", "pspiceShrink");
		break;
	case 'h':
		sCommand = LTCReadXmlValueChar(xmlFileName, "HSpice", "hspiceCommand");
		sOptions = LTCReadXmlValueChar(xmlFileName, "HSpice", "hspiceCommandOptions");
		sBracketSubstitutionLeft = LTCReadXmlValueChar(xmlFileName, "HSpice", "hspiceLeftBracket");
		sBracketSubstitutionRight = LTCReadXmlValueChar(xmlFileName, "HSpice", "hspiceRightBracket");
		bCmd_Macro = LTCReadXmlValueBool(xmlFileName, "HSpice", "hspiceSubCircuit");
		bCmd_XGNDXto0 = LTCReadXmlValueBool(xmlFileName, "HSpice", "hspiceXGNDX");
		bCmd_GNDto0 = LTCReadXmlValueBool(xmlFileName, "HSpice", "hspiceGND");
		bCmd_FilterPrefix = LTCReadXmlValueBool(xmlFileName, "HSpice", "hspiceOmitPrefix");
		bCmd_MixedSignal = LTCReadXmlValueBool(xmlFileName, "HSpice", "hspiceVerilogA");
		bCmd_Shrink = LTCReadXmlValueBool(xmlFileName, "HSpice", "hspiceShrink");
		break;
	case 't':
		sBracketSubstitutionLeft = LTCReadXmlValueChar(xmlFileName, "APT", "aptLeftBracket");
		sBracketSubstitutionRight = LTCReadXmlValueChar(xmlFileName, "APT", "aptRightBracket");
		bCmd_Macro = LTCReadXmlValueBool(xmlFileName, "APT", "aptSubCircuit");
		bCmd_XGNDXto0 = LTCReadXmlValueBool(xmlFileName, "APT", "aptXGNDX");
		bCmd_GNDto0 = LTCReadXmlValueBool(xmlFileName, "APT", "aptGND");
		bCmd_FilterPrefix = LTCReadXmlValueBool(xmlFileName, "APT", "aptOmitPrefix");
		bCmd_Shrink = LTCReadXmlValueBool(xmlFileName, "APT", "aptShrink");
		bCmd_AreaBip = LTCReadXmlValueBool(xmlFileName, "APT", "aptBipolarArea");
		bCmd_WLBip = LTCReadXmlValueBool(xmlFileName, "APT", "aptBipolarWL");
		sLVSShort = LTCReadXmlValueChar(xmlFileName, "APT", "aptShort");
		break;
	case 'a':
		sBracketSubstitutionLeft = LTCReadXmlValueChar(xmlFileName, "Assura", "assuraLeftBracket");
		sBracketSubstitutionRight = LTCReadXmlValueChar(xmlFileName, "Assura", "assuraRightBracket");
		bCmd_Macro = LTCReadXmlValueBool(xmlFileName, "Assura", "assuraSubCircuit");
		bCmd_XGNDXto0 = LTCReadXmlValueBool(xmlFileName, "Assura", "assuraXGNDX");
		bCmd_GNDto0 = LTCReadXmlValueBool(xmlFileName, "Assura", "assuraGND");
		bCmd_FilterPrefix = LTCReadXmlValueBool(xmlFileName, "Assura", "assuraOmitPrefix");
		bCmd_Shrink = LTCReadXmlValueBool(xmlFileName, "Assura", "assuraShrink");
		bCmd_AreaBip = LTCReadXmlValueBool(xmlFileName, "Assura", "assuraBipolarArea");
		bCmd_WLBip = LTCReadXmlValueBool(xmlFileName, "Assura", "assuraBipolarWL");
		sLVSShort = LTCReadXmlValueChar(xmlFileName, "Assura", "assuraShort");
		break;
	case 'd':
		sBracketSubstitutionLeft = LTCReadXmlValueChar(xmlFileName, "Dracula", "draculaLeftBracket");
		sBracketSubstitutionRight = LTCReadXmlValueChar(xmlFileName, "Dracula", "draculaRightBracket");
		bCmd_Macro = LTCReadXmlValueBool(xmlFileName, "Dracula", "draculaSubCircuit");
		bCmd_XGNDXto0 = LTCReadXmlValueBool(xmlFileName, "Dracula", "draculaXGNDX");
		bCmd_GNDto0 = LTCReadXmlValueBool(xmlFileName, "Dracula", "draculaGND");
		bCmd_FilterPrefix = LTCReadXmlValueBool(xmlFileName, "Dracula", "draculaOmitPrefix");
		bCmd_Shrink = LTCReadXmlValueBool(xmlFileName, "Dracula", "draculaShrink");
		bCmd_AreaBip = LTCReadXmlValueBool(xmlFileName, "Dracula", "draculaBipolarArea");
		bCmd_WLBip = LTCReadXmlValueBool(xmlFileName, "Dracula", "draculaBipolarWL");
		sLVSShort = LTCReadXmlValueChar(xmlFileName, "Dracula", "draculaShort");
		break;
	default:
		break;
	}
	//ltcUtility.~LTCUtils();
	return 0;
}




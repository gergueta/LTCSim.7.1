# Microsoft Developer Studio Project File - Name="Ntlnt" - Package Owner=<4>
# Microsoft Developer Studio Generated Build File, Format Version 6.00
# ** DO NOT EDIT **

# TARGTYPE "Win32 (x86) Application" 0x0101

CFG=Ntlnt - Win32 Debug
!MESSAGE This is not a valid makefile. To build this project using NMAKE,
!MESSAGE use the Export Makefile command and run
!MESSAGE 
!MESSAGE NMAKE /f "ntlnt.mak".
!MESSAGE 
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "ntlnt.mak" CFG="Ntlnt - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "Ntlnt - Win32 Release" (based on "Win32 (x86) Application")
!MESSAGE "Ntlnt - Win32 Debug" (based on "Win32 (x86) Application")
!MESSAGE 

# Begin Project
# PROP AllowPerConfigDependencies 0
# PROP Scc_ProjName ""$/PIK/Samples/Ntlnt", CLBAAAAA"
# PROP Scc_LocalPath "."
CPP=cl.exe
MTL=midl.exe
RSC=rc.exe

!IF  "$(CFG)" == "Ntlnt - Win32 Release"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir "Release"
# PROP BASE Intermediate_Dir "Release"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 0
# PROP Output_Dir ".\Ntl\Release"
# PROP Intermediate_Dir ".\Ntl\Release"
# PROP Ignore_Export_Lib 0
# PROP Target_Dir ""
# ADD BASE CPP /nologo /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /YX /FD /c
# ADD CPP /nologo /MD /W3 /GX /O2 /I "..\editors\include" /I ".\common" /I ".\tclInclude" /D "NDEBUG" /D "NTL" /D "WIN32" /D "_WINDOWS" /YX /FD /c
# ADD BASE MTL /nologo /D "NDEBUG" /mktyplib203 /o "NUL" /win32
# ADD MTL /nologo /D "NDEBUG" /mktyplib203 /o "NUL" /win32
# ADD BASE RSC /l 0x409 /d "NDEBUG"
# ADD RSC /l 0x409 /d "NDEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:windows /machine:I386
# ADD LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:windows /machine:I386 /out:"C:\Cohesion\Designer6\bin\LTCSimNtl.exe"

!ELSEIF  "$(CFG)" == "Ntlnt - Win32 Debug"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "Debug"
# PROP BASE Intermediate_Dir "Debug"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 1
# PROP Output_Dir ".\Ntl\Debug"
# PROP Intermediate_Dir ".\Ntl\Debug"
# PROP Ignore_Export_Lib 0
# PROP Target_Dir ""
# ADD BASE CPP /nologo /W3 /Gm /GX /Zi /Od /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /YX /FD /c
# ADD CPP /nologo /MDd /W3 /Gm /GX /ZI /Od /I "..\editors\include" /I ".\common" /I ".\tclInclude" /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "NTL" /FR /YX /FD /c
# ADD BASE MTL /nologo /D "_DEBUG" /mktyplib203 /o "NUL" /win32
# ADD MTL /nologo /D "_DEBUG" /mktyplib203 /o "NUL" /win32
# ADD BASE RSC /l 0x409 /d "_DEBUG"
# ADD RSC /l 0x409 /d "_DEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:windows /debug /machine:I386 /pdbtype:sept
# ADD LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:windows /debug /machine:I386 /nodefaultlib:"msvcrt.lib" /nodefaultlib:"libcd.lib" /out:"E:\Cohesion\Designer6\bin\LTCSimNtl.exe" /pdbtype:sept
# SUBTRACT LINK32 /pdb:none /force

!ENDIF 

# Begin Target

# Name "Ntlnt - Win32 Release"
# Name "Ntlnt - Win32 Debug"
# Begin Group "Source Files"

# PROP Default_Filter "cpp;c;cxx;rc;def;r;odl;hpj;bat;for;f90"
# Begin Source File

SOURCE=.\common\Dataout.cpp
# End Source File
# Begin Source File

SOURCE=.\ntl\ntlsub.cpp
# End Source File
# Begin Source File

SOURCE=.\common\SPICDLG.cpp
# End Source File
# Begin Source File

SOURCE=.\common\spice.cpp
# End Source File
# Begin Source File

SOURCE=.\common\SPICEPAT.cpp
# End Source File
# Begin Source File

SOURCE=.\common\spicprim.cpp
# End Source File
# End Group
# Begin Group "Header Files"

# PROP Default_Filter "h;hpp;hxx;hm;inl;fi;fd"
# Begin Source File

SOURCE=.\common\attr.h
# End Source File
# Begin Source File

SOURCE=.\common\dataout.h
# End Source File
# Begin Source File

SOURCE=.\common\pikproc.h
# End Source File
# Begin Source File

SOURCE=.\common\STDAFX.H
# End Source File
# Begin Source File

SOURCE=.\tclInclude\tcl.h
# End Source File
# Begin Source File

SOURCE=.\tclInclude\tclDecls.h
# End Source File
# Begin Source File

SOURCE=.\tclInclude\tclInt.h
# End Source File
# Begin Source File

SOURCE=.\tclInclude\tclIntDecls.h
# End Source File
# Begin Source File

SOURCE=.\tclInclude\tclPlatDecls.h
# End Source File
# Begin Source File

SOURCE=.\tclInclude\tk.h
# End Source File
# Begin Source File

SOURCE=.\tclInclude\tkDecls.h
# End Source File
# Begin Source File

SOURCE=.\tclInclude\tkIntXlibDecls.h
# End Source File
# Begin Source File

SOURCE=.\tclInclude\tkPlatDecls.h
# End Source File
# End Group
# Begin Group "Resource Files"

# PROP Default_Filter "ico;cur;bmp;dlg;rc2;rct;bin;cnt;rtf;gif;jpg;jpeg;jpe"
# Begin Source File

SOURCE=.\ntl\NTLnt.RC

!IF  "$(CFG)" == "Ntlnt - Win32 Release"

!ELSEIF  "$(CFG)" == "Ntlnt - Win32 Debug"

# ADD BASE RSC /l 0x409 /i "ntl"
# ADD RSC /l 0x409 /i "ntl" /i ".\Common"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=.\common\resource.h
# End Source File
# End Group
# Begin Group "Library Files"

# PROP Default_Filter "lib"
# Begin Source File

SOURCE=.\lib\nttapkp.lib
# End Source File
# Begin Source File

SOURCE=.\lib\pik.lib
# End Source File
# Begin Source File

SOURCE=.\tclLib\tkstub84.lib
# End Source File
# Begin Source File

SOURCE=.\tclLib\tcl84.lib
# End Source File
# Begin Source File

SOURCE=.\tclLib\tcl84d.lib
# End Source File
# Begin Source File

SOURCE=.\tclLib\tclstub84.lib
# End Source File
# Begin Source File

SOURCE=.\tclLib\tk84.lib
# End Source File
# Begin Source File

SOURCE=.\tclLib\tk84d.lib
# End Source File
# End Group
# End Target
# End Project

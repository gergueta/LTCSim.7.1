/* pikfuncs.h - Function Definitions for PIK */

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

// Cross Probing with the Hierarchy Navigator
void        MarkNet( const char* name );
void        MarkInstance( const char* name );
void        UnMarkAll();
void        UpdateMarks();
void        ProbeNet( const char* name );
void        ProbeInst( const char* name );

// Attributes
char*       Get_TDA( TD_PTR, int );
char*       Get_TIA( TI_PTR, int );
char*       Get_TNA( TN_PTR, int );
char*       Get_TPA( TP_PTR, int );
char*       Get_TGA( TG_PTR, int );
char*       Get_TIA_Override( TI_PTR, int );
char*       Get_TNA_Override( TN_PTR, int );
char*       Get_TPA_Override( TP_PTR, int );
char*		Get_Passed_TIA( TI_PTR, int );
char*       LocalInstanceName( TI_PTR );
char*       LocalNetName( TN_PTR );
char*       InstanceName( TN_PTR );
char*       NetName( TN_PTR );
char*		GetPcbPinNumber( TP_PTR );

int         ForEachTIA( TI_PTR, int, int, int, int(*)( int, const char*, char*  ) );
int         ForEachTPA( TP_PTR, int, int, int, int(*)( int, const char*, char*  ) );
int         ForEachTNA( TN_PTR, int, int, int, int(*)( int, const char*, char*  ) );

int         Add_TDA( TD_PTR, int, const char*  );
int         Add_TIA( TI_PTR, int, const char*  );
int         Add_TNA( TN_PTR, int, const char*  );
int         Add_TPA( TP_PTR, int, const char*  );
int         Add_TGA( TG_PTR, int, const char*  );

// Library Paths
#define CURRENT_DIRECTORY 1
#define SYMBOL_PATHS      2
#define SCHEMATIC_PATHS   4

int         FindECSFile( const char* pszName, const char* pszExt, int nPathMode, char* pszResult );
HANDLE      OpenECSFile( const char* pszName, const char* pszExt, int nPathMode,
						char* pszResult, long* plLength );

// Relationships
TD_PTR      DescriptorContainingNet( TN_PTR );
TD_PTR      DescriptorOfInstance( TI_PTR );
TN_PTR      FindNetRoot( TN_PTR );
TI_PTR      FirstInstanceOf( TD_PTR );
TP_PTR      FirstPinOf( TI_PTR );
TG_PTR      GenericPinOfPin( TP_PTR );
TI_PTR      InstanceContainingPin( TP_PTR );
TD_PTR      OwnerOfInstance( TI_PTR );
TN_PTR      NetContainingPin( TP_PTR );
TN_PTR      NetDefinedByPin( TP_PTR );
TI_PTR      ParentInstanceOf( TD_PTR );
TP_PTR      PinDefiningNet( TN_PTR );

// Database Element Numbers
DWORD       InstanceNumber( TI_PTR );
DWORD       InstanceNumberOfNet( TN_PTR );
DWORD       InternalDescriptorNumber( TD_PTR );
DWORD       NetNumber( TN_PTR );
DWORD       PinNumber( TP_PTR );

// Searching For a Particular Element
TD_PTR      FindDescriptorNamed( const char* );
TI_PTR      FindInstanceNamed( const char* );
TI_PTR      FindInstanceNumbered( DWORD );
TI_PTR      FindInstanceRefNamed( const char* );
TN_PTR      FindNetNamed( const char* );
TN_PTR      FindNetNumbered( DWORD );
TP_PTR      FindPinNamed( const char* );
TP_PTR      FindPinWithAttribute( TI_PTR, int, const char* );

// Miscellaneous Parameters
int         DescriptorType( TD_PTR );
int         GateNumberOfInstance( TI_PTR );
int         GlobalPin( TP_PTR );
int         NetInOutBid( TN_PTR );
int         NetLocExtGbl( TN_PTR );
int         PrimitiveCell( TD_PTR );

// Traversing the Data Structures - "Local" Context
int         ForEachBlock( int(*)( TD_PTR ) );
int         ForEachBlockOrCell( int(*)( TD_PTR ) );
int         ForEachBlockNet( TD_PTR, int(*)( TN_PTR ) );
int         ForEachDescriptor( int(*)( TD_PTR ) );
int         ForEachInstancePin( TI_PTR, int(*)( TP_PTR ) );
int         ForEachNetLocalPin( TN_PTR, int(*)( TP_PTR ) );
int         ForEachParentOf( TD_PTR, int(*)( TD_PTR ) );
int         ForEachSubBlock( TD_PTR, int(*)( TI_PTR ) );
void        MarkBlockDone( TD_PTR );
void        SetupBlockScan();
int         SortPinsByOrder( int );
int         TestMark( TD_PTR );

// Traversing the Data Structures - "Hierarchical" Context
int         ForEachInstance( int(*)( TI_PTR ) );
int         ForEachMarkedOrPrimitiveInst( int(*)( TI_PTR ) );
int         ForEachNet( int(*)( TN_PTR ) );
int         ForEachNetElementPin( TN_PTR, int(*)( TP_PTR ) );
int         ForEachNetPin( TN_PTR, int(*)( TP_PTR ) );
int         ForEachPrimitiveInstance( int(*)( TI_PTR ) );
void        RestorePath();
void        SavePath();

// Utility Functions
int         DisplayErrors( const char* );
int         UpdateHierarchy( const char*, int );
int         UpdateTree( int );

int         ClearDescriptorFlag( TD_PTR );
int         GetDescriptorFlag( TD_PTR );
int         SetDescriptorFlag( TD_PTR );
void        writeOutputHeader( FILE *_file, const char *_openComment, const char *_closeComment,
							const char *_description, const char *_processName, 
							const char *_version, const char *_designName );

int         ForEachGlobalNetName( int(*)( const char* ) );
int         IsGlobalNetName( const char* );

void        AddExt( char*, const char* );
int         ChangeToFilePath( const char* filename );
int			getOutputPath( char* );
int         _CopyFile( const char* filename, const char* destpath );
char*       FileInPath( const char* );
char*       GetFilePath( const char* filename, char* path );
char*       GetFullFileName( const char* filename, char* full_name );
char*       GetIntlDateTimeString( char* );
int         GetProductName( char* buff, int buflen );
int         GetProductVersion( char* buff, int buflen );
int         LaunchEditor( const char* lpszFileName );
int         LaunchViewer( const char* lpszFileName );
int         MajorError( const char* );
int         SameFile( const char* filename1, const char* filename2 );
int         SpawnTask( const char*, const char*, int );
int         SpawnTaskEx( const char*, const char*, const char*, int nCmdShow );
int         alphanumcmp( const char* str1, const char* str2 );
int         alphanumicmp( const char* str1, const char* str2 );
void        bsort( void* data, long count, size_t size,
                 int (*compare)( const void*, const void* ) );
void        xsort( void* data, long count, size_t size,
                 int (*compare)( const void*, const void* ) );

int         ScaledNumber( const char* , int, int, long* );

// Processing Functions
int         PreProcess( int argc, char** argv );
void        Process( int argc, char** argv );
void        PostProcess();

// dialogs
#ifdef UNIX
void		setupDialog( Widget dlg );
void		catchUnmapDialogCB( Widget, void*, void* );
#endif

void		Create_Wheel( const char *msg, int showCount );
void		Update_Wheel( const char *msg );
void		Spin_Wheel( void );
void		Destroy_Wheel( void );
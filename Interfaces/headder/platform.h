// platform.h -- Contains platform independent definitions

#if !defined (__PLATFORM_H_)
#define __PLATFORM_H_

#ifdef _WIN32
#define PATH_SEPARATOR   '\\'
#endif

#ifdef UNIX
#define PATH_SEPARATOR '/'
#endif


#ifdef UNIX
#include "win_u.h"
#endif

#ifdef _WIN32
#include "unix_for_pc.h"
#endif

#ifdef UNIX

int SetCurrentDirectory( const char* pszFileName );
int GetCurrentDirectory( unsigned int nBufSize, char* pszBuffer );

DWORD GetFileSize( HANDLE hFile, DWORD* );
inline int CloseHandle( HANDLE hFile )
{
	return close( hFile );
}
inline int DeleteFile( const char* pszFileName )
{
	// DeleteFile returns 0 if failed, unlink returns 0 if succeeded
	return !unlink( pszFileName );
}

DWORD GetFullPathName( const char* pszFileName, int nBufLen, char* pszBuffer,
	char** ppszFileStart );

#define INVALID_HANDLE_VALUE HANDLE(-1) // DO NOT make this zero!!! (see win/library.cpp)

#endif // UNIX


char *getMyUserName( void );
char *getMyHostName( void );


#endif	// __PLATFORM_H_

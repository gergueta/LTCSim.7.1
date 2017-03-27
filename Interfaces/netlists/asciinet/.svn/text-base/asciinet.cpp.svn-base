/* asciinet.c -- Standard ASCII net list */

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

#include <stdafx.h>
#include "pikproc.h"
#include "version.h"


#define VER "4.0"

unsigned long ProcRequiredLicBit  = 0xffFFffFF;
unsigned long ProcRequiredVersion = VERSION_I;

static int pinnos = FALSE;
static FILE *file;

                   /*---------- List_Symbol_Attrs ----------*/

static int List_Symbol_Attrs( int num, const char* attrname, char* attr )
{
	if ( *attr )
    {
		fprintf( file, "SYMATTR %s %s\n", attrname, attr );
    }
	return( 0 );
}

                     /*---------- List_Pin_Attrs ----------*/

static int List_Pin_Attrs( int num, const char* attrname, char* attr )
{
	if ( *attr && ( pinnos && num != PINNUM || !pinnos && num != NAME ) )
    {
		fprintf( file, "PINATTR %s %s\n", attrname, attr );
    }
	return( 0 );
}

static int List_Inst_Pin( TP_PTR tp )
{
	TN_PTR tn;
	char *pin, pin_name[256];
	if ( pinnos ) 
		pin = Get_TPA( tp, PINNUM );
	else          
		pin = Get_TPA( tp, NAME );
	strcpy( pin_name, pin );
	if ( ( tn = NetContainingPin( tp ) ) &&
        ( tn = FindNetRoot( tn ) ) )
		fprintf( file, "PIN %-8s  %s\n", pin_name, NetName( tn ) );
	else
		fprintf( file, "PIN %-8s Unconnected\n", Get_TPA( tp, NAME ) );
	ForEachTPA( tp, 0, 200, 6, List_Pin_Attrs );

	return( 0 );
}

static int List_Inst( TI_PTR ti )
{
	char *nn, name[_MAX_PATH];

	Spin_Wheel();
	strcpy( name,  Get_TDA( DescriptorOfInstance( ti ), NAME ));
	for ( nn = name; *nn && *nn != '_'; nn++ );    /* strip off the _a in name */
	*nn = '\0';
	fprintf( file, "INSTANCE %s %s\n", name, InstanceName( ti ) );
	ForEachTIA( ti, 2, 200, 6, List_Symbol_Attrs );
	ForEachInstancePin( ti, List_Inst_Pin );
	return( 0 );
}

                   /*---------- List_Net_Attrs ----------*/

static int List_Net_Attrs( int num, const char* attrname, char* attr )
{
	if ( *attr )
    {
		fprintf( file, "NETATTR %s %s\n", attrname, attr );
    }
	return( 0 );
}

static int List_Net( TN_PTR tn )
{
	static int wheel = 0;
	if( !( wheel %10 )) // empirical
		Spin_Wheel();
	wheel++;
	fprintf( file, "NET %s\n", NetName( tn ));
	ForEachTNA( tn, 2, 200, 6, List_Net_Attrs );
	
	return ( 0 );
}

void Process( int argc, char* argv[] )
{
	char filename[_MAX_PATH];
	int ii, notepad = FALSE;

	pinnos = FALSE;
	/* check the arguments for program options and file extension */
	for ( ii = 1; ii < argc; ii++ )
    {
		if ( *argv[ii] == '-' )
		{
			if ( !strnicmp( argv[ii], "-view", 3 ) ) notepad = TRUE;
			else if ( !strnicmp( argv[ii], "-pinnos", 7 ) ) pinnos = TRUE;
		}
    }

// todo: handle this arg option without 'command_flags'
	pinnos = 1 & (int)( command_flags >> ( 'N' - 'A' ) );
	sprintf( filename, "%s.net", FileInPath( szRootName ) );
	strlwr( FileInPath( filename ) );

	file = fopen( filename, "w" );
	if ( file )
    {
		Create_Wheel( "Netlist Generator", FALSE );
		char time[64];
		fprintf( file, "COMMENT Generic Netlist, Compact\n" );
		fprintf( file, "COMMENT     asciinet v%s, Cohesion Designer v%s\n",
					VER, MAJORVERSION );
		fprintf( file, "COMMENT     Cohesion Systems, inc\n" );
		fprintf( file, "COMMENT     http://www.CohesionSystems.com\n" );
		GetIntlDateTimeString( time );
		fprintf( file, "COMMENT Design: %s\n", FileInPath( szRootName ) );
		fprintf( file, "COMMENT Run: %s\n\n", time );

		Update_Wheel( "Instances..." );
		ForEachPrimitiveInstance( List_Inst );
		Update_Wheel( "Nets..." );
		ForEachNet( List_Net );
		fclose( file );
		Destroy_Wheel();
		if ( notepad ) 
			LaunchEditor( filename );
    }
}

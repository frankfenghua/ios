//
//  main.c
//  DVDFiler3
//
//  Created by James Bucanek and David Mark on 8/12/12.
//  Copyright (c) 2012 Apress, Inc. All rights reserved.
//

#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <pwd.h>        // getpwuid()
#include <unistd.h>     // getuid()
#include "DVDInfo.h"
#include "DVDFile.h"

#define kListCommand    'l'
#define kNewCommand     'n'
#define kQuitCommand    'q'


char GetCommand( char *prompt );
int SetHomeDirectory( void );


int main (int argc, const char * argv[])
{
    // set working dir to ~/Desktop
    if ( SetHomeDirectory() != 0
        || chdir( "./Desktop" ) != 0 ) {
        perror( "Could not chdir to ~/Desktop" );
        exit( 1 );
    }
	
    ReadFile();
	
	char command;
	while ( (command = GetCommand( "Enter command (q=quit, n=new, l=list)" ) ) != kQuitCommand ) {
		switch( command ) {
			case kNewCommand:
				AddToList( ReadStruct() );
				break;
			case kListCommand:
				ListDVDs();
				break;
		}
        printf( "\n----------\n" );
	}
	
	WriteFile();
	
	printf( "Goodbye...\n" );
	
	return 0;
}

/*****************
 GetCommand()
 
 Prompt for, and read, a single command character
 from stdin and return it as char to the caller,
 or kQuitCommand if there's an error.
 */
char GetCommand( char *prompt )
{
    char buffer[ 100+1 ];
    printf( "%s:  ", prompt );
    if ( fgets( buffer, sizeof(buffer), stdin ) == NULL )
        return kQuitCommand;
    return *TrimLine( buffer );
}

/*******************************
 SetHomeDirectory()
 returns 0 if successful
 
 Set the current working directory to the home directory
 of the logged in user.
 */
int SetHomeDirectory( void )
{
    struct passwd *pw = getpwuid( getuid() );
    assert( pw!=NULL );     // the current user should always be valid
    return chdir( pw->pw_dir );
}

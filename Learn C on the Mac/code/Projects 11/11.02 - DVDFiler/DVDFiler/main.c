//
//  main.c
//  DVDFiler
//
//  Created by James Bucanek and David Mark on 8/12/12.
//  Copyright (c) 2012 Apress, Inc. All rights reserved.
//

#include <stdio.h>
#include <pwd.h>        // getpwuid()
#include <unistd.h>     // getuid()
#include "DVDInfo.h"
#include "DVDFile.h"


char GetCommand( char *prompt );
void SetHomeDirectory( void );


int main (int argc, const char * argv[])
{
    SetHomeDirectory();     // set working dir to ~
    chdir( "./Desktop" );   // set working dir to ~/Desktop
	ReadFile();
	
	char command;

	while ( (command = GetCommand( "Enter command (q=quit, n=new, l=list)" ) ) != 'q' ) {
		switch( command ) {
			case 'n':
				AddToList( ReadStruct() );
				break;
			case 'l':
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
 from stdin and return it as char to the caller.
 */
char GetCommand( char *prompt )
{
    char buffer[ 100+1 ];
    printf( "%s:  ", prompt );
    fgets( buffer, sizeof(buffer), stdin );
    return *TrimLine( buffer );
}

/*******************************
 SetHomeDirectory()
 
 Set the current working directory to the home directory
 of the logged in user.
 */
void SetHomeDirectory( void )
{
    struct passwd *pw = getpwuid( getuid() );
    chdir( pw->pw_dir );
}

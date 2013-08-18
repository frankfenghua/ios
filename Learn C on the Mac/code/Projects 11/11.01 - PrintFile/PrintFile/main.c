//
//  main.c
//  PrintFile
//
//  Created by James Bucanek and David Mark on 8/12/12.
//  Copyright (c) 2012 Apress, Inc. All rights reserved.
//

#include <stdio.h>      // fopen(), fgetc(), fclose(), ...
#include <pwd.h>        // getpwuid()
#include <unistd.h>     // getuid()


void SetHomeDirectory( void );


int main(int argc, const char * argv[])
{
    FILE	*fp;
    
    SetHomeDirectory();
    fp = fopen( "Desktop/My Data File.txt", "r" );
    
    if ( NULL == fp ) {
        printf( "Error opening My Data File.txt\n" );
    } else {
        int c;
        while ( (c = fgetc( fp )) != EOF )
            putchar( c );
		
		fclose( fp );
    }
    
    return 0;
}

/*******************************
    SetHomeDirectory()
 
 Set the current working directory to the home directory
 of the logged in user.
 */

void SetHomeDirectory( void )
{
    // Define a pointer to the user account info structure.
    // This structure is named "passwd" because, historically, this
    //  information came from the Unix "passwd" (password) file,
    //  where each user's account name, password, and home directory
    //  was stored.
    // Nowadays, this information is stored in a modern database,
    //  but the name of the structure persists.
    struct passwd *pw;
    
    // Call getpwuid() to get a pointer to a user account info structure.
    // The user we want is the currently logged in user (that's you!),
    //  which is obtained by calling getuid() ("get user id").
    pw = getpwuid( getuid() );
    
    // The pw_dir field of the passwd structure points to a C string
    //  that's the absolute path to the user's home directory.
    // Use this path to set the current working directory for this process.
    chdir( pw->pw_dir );
}

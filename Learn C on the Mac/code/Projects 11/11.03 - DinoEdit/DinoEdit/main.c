//
//  main.c
//  DinoEdit
//
//  Created by James Bucanek and David Mark on 8/13/12.
//  Copyright (c) 2012 Apress, Inc. All rights reserved.
//

#include <stdlib.h>
#include <stdio.h>
#include <sys/stat.h>
#include <string.h>
#include <stdbool.h>
#include <string.h>
#include <ctype.h>
#include <pwd.h>
#include <unistd.h>
#include "dinoEdit.h"

/* Function Prototypes */
void    SetHomeDirectory( void );
int		GetNumber( void );
int		GetNumberOfDinos( void );
void	ReadDinoName( int number, char *dinoName );
bool	GetNewDinoName( char *dinoName );
void	WriteDinoName( int number, char *dinoName );
char    *TrimLine( char *line );


int main(int argc, const char * argv[])
{
    SetHomeDirectory();     // set working dir to ~
    chdir( "./Desktop" );   // set working dir to ~/Desktop

	int		number;
	char	dinoName[ kDinoRecordSize+1 ];
	
    // GetNumber() returns a number typed by the user that indicates the
    //  "command" to be performed.
    //  1..n: print and optionally update a record
    //    -1: append a new record
    //     0: quit
	while ( (number = GetNumber()) != 0 ) {
        if ( number>0 ) {
            // Read the nth record and print the name
            ReadDinoName( number, dinoName );
            printf( "Dino #%d: %s\n", number, dinoName );
        } else {
            // number == -1: set number to next record #
            number = GetNumberOfDinos() + 1;
        }
		
		if ( GetNewDinoName( dinoName ) )
			WriteDinoName( number, dinoName );
	}
	
	printf( "Goodbye..." );
	
	return 0;
}

/**************************
 GetNumber()
   returns a number between 0 and the number of
           dinosaur records in the file, or -1
           if the user typed 'a'
 
 Calls GetNumberOfDino() to obtain the # of
    records in the file.
 Prompts the user to enter a number between 1 an #.
 Reads a line and converts that to an integer.
 Loops until number is between 0 and #, inclusive,
    or the line starts with the letter 'a'.
 */
int	GetNumber( void )
{
	int number, numDinos;
	
	numDinos = GetNumberOfDinos();
	
	do {
		printf( "Enter number from 1 to %d (0 to exit, a to add): ",
               numDinos );
        
        // Read a line from the keyboard and convert it to a number
        char lineBuffer[ kMaxLineLength ];
        fgets( lineBuffer, sizeof(lineBuffer), stdin );
        number = atoi( TrimLine(lineBuffer) );
        
        // If the line doesn't contain an integer, see if it starts
        //  with the letter 'a'. If so, return -1 to the caller.
        if ( number==0 && *TrimLine(lineBuffer)=='a' )
            return -1;
	} while ( (number < 0) || (number > numDinos) );
	
	return number;
}


/**********************************
 GetNewDinoName( char *dinoName )
    dinoName: char array to recieve name
      returns true if name is not empty
 
 dinoName must be at least kDinoRecordSize+1 bytes long
 
 Prompt user to type in a name.
 Read line, trim it, and copy no more
    then kDinoRecordSize characters to
    dinoName.
 */
bool GetNewDinoName( char *dinoName )
{
	char	line[ kMaxLineLength ];
	
	printf( "Enter new name (optional): " );
    fgets( line, kMaxLineLength, stdin );
    
	strlcpy( dinoName, TrimLine(line), kDinoRecordSize+1 );
		
	return ( dinoName[0] != '\0' );
}


/**********************
 GetNumberOfDinos()
    return number of dinosaur records in kDinoFileName
 
 Use stat() to obtain the length of the kDinoFileName
 file and divide that by kDinoRecordSize to determine
 the number of records in the file.
 */
int GetNumberOfDinos( void )
{
    struct stat fileStats;
    
    if ( stat( kDinoFileName, &fileStats ) != 0 )
        return 0;
    
    return fileStats.st_size / kDinoRecordSize;
}


/********************************************
 ReadDinoName( int number, char *dinoName )
    number: record number to read
  dinoName: char array to receive name
 
 dinoName[] must be at least kDinoRecordSize+1 bytes long
 
 Open the kDinoFileName file.
 Seek to the nth record.
 Copy kDinoRecordSize bytes to dinoName.
 Close file.
 */
void ReadDinoName( int number, char *dinoName )
{
	FILE	*fp;
	off_t	positionOfRecord;
	
	fp = fopen( kDinoFileName, "r" );
	
	positionOfRecord = (number-1) * kDinoRecordSize;

	fseeko( fp, positionOfRecord, SEEK_SET );
	
	fread( dinoName, kDinoRecordSize, 1, fp );
    dinoName[ kDinoRecordSize ] = '\0';

	fclose( fp );
}


/*********************************
 WriteDinoName( int number, char *dinoName )
    number: record number to write
  dinoName: name to write
 
 Open the kDinoFileName file.
 Seek to the nth record.
 Write the first kDinoRecordSize bytes of dinoName to file.
 Close file.
 */
void WriteDinoName( int number, char *dinoName )
{
	FILE	*fp;
	off_t	positionOfRecord;
	
	fp = fopen( kDinoFileName, "a+" );
	
	positionOfRecord = (number-1) * kDinoRecordSize;
	
	fseeko( fp, positionOfRecord, SEEK_SET );
	
	fwrite( dinoName, kDinoRecordSize, 1, fp );
	
	fclose( fp );
}


/***************************************************
 TrimLine( char *line )
      line: pointer to line buffer (might be modified)
    returns pointer to trimmed line
 
 Replace any whitespace characters at the end
  of the line with '\0'.
 Skip any whitespace characters at the beginning
  of the string by returning a pointer to the first
  non-whitespace character.
 */
char *TrimLine( char *line )
{
    size_t length = strlen( line );
    while ( length > 0 && isspace( line[length-1] )) {
        line[length-1] = '\0';
        length--;       // string is now one char shorter
    }
    
    char *head = line;
    while ( isspace( *head ) )
        head++;
    
    return head;
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

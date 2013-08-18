//
//  main.c
//  DVDTracker2
//
//  Created by James Bucanekand David Mark on 8/8/12.
//  Copyright (c) 2012 Apress, Inc. All rights reserved.
//

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include "dvdTracker.h"

char			GetCommand( void );
struct DVDInfo	*ReadStruct( void );
void			AddToList( struct DVDInfo *curPtr );
void			ListDVDs( void );
char            *TrimLine( char *line );

struct DVDInfo *gHeadPtr, *gTailPtr;

int main (int argc, const char * argv[])
{
	char command;
    
	while ( (command = GetCommand() ) != 'q' ) {
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
	
	printf( "Goodbye...\n" );
	
	return 0;
}

/*****************
 GetCommand()
 
 Get a single command character from stdin
 and return it as char to the caller.
 */
char GetCommand( void )
{
    char buffer[ 100+1 ];
    printf( "Enter command (q=quit, n=new, l=list):  " );
    fgets( buffer, sizeof(buffer), stdin );
    return *TrimLine( buffer );
}


/******************
 ReadStruct()
 
 Allocate a new DVDInfo struct.
 Prompt the user to supply a title, comment, and rating.
 Fill in the values of the new DVDInfo struct,
 and return the new struct to the caller.
 */
struct DVDInfo *ReadStruct( void )
{
	struct DVDInfo	*infoPtr;
	
	infoPtr = malloc( sizeof( struct DVDInfo ) );
	
	if ( infoPtr == NULL ) {
		printf( "Out of memory!!!  Goodbye!\n" );
		exit( 1 );
	}
	
    // Buffer to hold each answer
    char buffer[ 500+1 ];
    
	printf( "Enter DVD Title:  " );
    fgets( buffer, sizeof(buffer), stdin );
    strlcpy( infoPtr->title, TrimLine( buffer ), sizeof(infoPtr->title) );
	
	printf( "Enter DVD Comment:  " );
    fgets( buffer, sizeof(buffer), stdin );
    strlcpy( infoPtr->comment, TrimLine( buffer ), sizeof(infoPtr->comment) );
	
	int num;
	do {
        printf( "Enter DVD Rating (1-10):  " );
        fgets( buffer, sizeof(buffer), stdin );
        num = atoi( TrimLine( buffer ) );
	}
	while ( ( num < 1 ) || ( num > 10 ) );
	infoPtr->rating = num;
	
	return( infoPtr );
}

/*****************************************
 AddToList( struct DVDInfo *curPtr )
 curPtr: pointer to struct to add to end of list
 
 Traverses the DVDInfo linked list, starting with gHeadPtr
 and finds the tail of the list.
 Links *curPtr to the end of the list.
 */
void AddToList( struct DVDInfo *curPtr )
{
	if ( gHeadPtr == NULL )
		gHeadPtr = curPtr;
	else
		gTailPtr->next = curPtr;
	
	gTailPtr = curPtr;
	curPtr->next = NULL;
}

/*****************
 ListDVDs()
 
 Print the current list of DVDInfo structs to stdout.
 */
void ListDVDs( void )
{
	struct DVDInfo *curPtr;
	
	if ( gHeadPtr == NULL ) {
		printf( "No DVDs have been entered yet...\n" );
	} else {
		for ( curPtr = gHeadPtr; curPtr != NULL; curPtr = curPtr->next ) {
            if ( curPtr != gHeadPtr )
                printf( "--------\n" );
			printf( "Title:   %s\n", curPtr->title );
			printf( "Comment: %s\n", curPtr->comment );
			printf( "Rating:  %d\n", curPtr->rating );
		}
	}
}

/***************************************************
 TrimLine( char *line )
 line: pointer to line buffer (which might be modified)
 returns pointer to trimmed line
 
 Replace any whitespace characters at the end
 of the line with '\0'.
 Skip any space or tab characters at the beginning
 of the string by returning a pointer to the first
 non-space/tab character.
 */
char *TrimLine( char *line )
{
    // Check to see if the last character in the string
    //  is whitespace. If so, replace it with a '\0'
    //  and repeat.
    size_t length = strlen( line );
    while ( length > 0 && isspace( line[length-1] )) {
        line[length-1] = '\0';
        length--;       // string is now one char shorter
    }
    
    // Return a pointer within line to the first character
    //  that is NOT a space or tab character
    
    /* Exercise 2 notes:
     
     strspn() calculates the index of the char array in
     the first parameter of the first character that is
     not one of those in the string in the second parameter.
     
     Add this index to line to obtain the address of that character.
     */
    return line + strspn( line, " \t" );
    
    /* Exercise 2 bonus question:

     Can you tell why you don't need
     to include a \n in the second string to strspn()?

     Or, said another way, why the second half of
     TrimLine() will never encounter a \n character?
     */
}

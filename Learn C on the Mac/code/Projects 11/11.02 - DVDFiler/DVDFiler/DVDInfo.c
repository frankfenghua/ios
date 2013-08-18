//
//  DVDInfo.c
//  DVDFiler
//
//  Created by James Bucanek and David Mark on 8/12/12.
//  Copyright (c) 2012 Apress, Inc. All rights reserved.
//

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include "DVDInfo.h"


/* Global Variables */
struct DVDInfo *gHeadPtr;
static struct DVDInfo *gTailPtr;


/******************
 ReadStruct()
    returns pointer to new DVDInfo struct
 
 Allocate a new DVDInfo struct.
 
 Prompt the user to supply a title, comment, and rating.
 
 Fill in the values of the new DVDInfo struct,
 and return the new struct to the caller.
 */
struct DVDInfo *ReadStruct( void )
{
	struct DVDInfo	*infoPtr;
	
	infoPtr = NewDVDInfo();
	
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
 
 Links *curPtr to the end of the list.
 */
void AddToList( struct DVDInfo *curPtr )
{
	if ( gHeadPtr == NULL )
		gHeadPtr = curPtr;          // first struct in list
	else
		gTailPtr->next = curPtr;    // append to tail of list
    
	curPtr->next = NULL;
	gTailPtr = curPtr;
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

/******************
 NewDVDInfo()
    return pointer to new DVDInfo struct
 
 Allocate and initialize one DVDInfo struct
 */
struct DVDInfo *NewDVDInfo( void )
{
    return calloc( 1, sizeof( struct DVDInfo ) );
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
    // Check to see if the last character in the string
    //  is whitespace. If so, replace it with a '\0'
    //  and repeat.
    size_t length = strlen( line );
    while ( length > 0 && isspace( line[length-1] )) {
        line[length-1] = '\0';
        length--;       // string is now one char shorter
    }
    
    // Set a pointer to the first char in the string.
    // Increment the pointer if the first character
    //  is whitespace. Repeat until *head does not point
    //  to a whitespace character (which includes '\0').
    char *head = line;
    while ( isspace( *head ) )
        head++;
    
    // Return the pointer to the trimmed string.
    return head;
}

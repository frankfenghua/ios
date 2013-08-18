//
//  main.c
//  DVDTracker3
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

/* Exercise 3 notes:
     This version of the program doesn't use
     a gTailPtr variable. Instead, it traverses the list
     of DVDInfo structs, starting with the head, every time
     it inserts a new one. */
struct DVDInfo *gHeadPtr;

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
    /* Exercise 3 notes:
     
     Instead of relaying on a gTailPtr to point to the
     last struct in the list, this version will
     traverse the entire list looking for the
     appropriate place to insert the new struct.
     
     It also traverses the list in a very interesting way.
     
     It starts with a pointer to a pointer. Remember that a
     pointer is just another kind of variable and you can
     create a pointer to any kind of variable, including
     another pointer.
     
     The pointer pointer is initialized to point to gHeadPtr.
     */
    struct DVDInfo **nextPtrPtr = &gHeadPtr;

    /*
     To insert a struct into the middle of a linked list, you
     must change the links so that the previous link now
     points to the new struct and the new struct points
     to the struct that follows. To illustrate, here's a two
     struct list:
        A ---> B
     
     In code, this list was created something like this:
         A.next = &B;
         B.next = NULL;
     
     To insert struct X between A & B, the list needs to look like this:
        A ---> X ---> B
     
     In code, that happens something like this:
         X.next = A.next;
         A.next = &X;
     
     So to insert a struct, the new struct's next (X.next) pointer
     must be set to the value of the previous struct's next
     pointer (A.next), and then it (A.next) can be updated to point
     to the new struct (&X).
     
     This gets complicated, however, when the previous struct isn't
     a struct, it's the gHeadPtr ... and this is where nextPtrPtr comes in.
     Instead of keeping track of the previous struct, the loop
     simply keeps track of the address of the previous pointer.
     The first time through the loop that's &gHeadPtr, but on
     subsequent loops it will be the address of the next field
     in the previous struct.

     The loop stops when the current "next" pointer contains NULL
     (meaning we are at the end of the list), or the next struct in
     the list has a higher rating than this DVD.
     */
    while ( *nextPtrPtr != NULL && curPtr->rating > (*nextPtrPtr)->rating ) {
        // Traverse to the next struct in the list, by updating the
        //  pointer to the pointer to the next struct.
        nextPtrPtr = &((*nextPtrPtr)->next);
    }
    /*
     When the loop exits, the nextPtrPtr points to the previous next
     pointer variable. This, and the next field in curPtr, are all that
     needs to be updated to insert a new struct into the list.
     */
    curPtr->next = *nextPtrPtr;
    *nextPtrPtr = curPtr;

    /*
     Note that this code also works when the very first DVD is added
     to the list. When AddToList() is called, gHeadPtr is NULL.
     if gHeadPtr==NULL, and nextPtr=&gHeadPtr, then *nextPtr will be NULL.
     When the loop exits, *nextPtr = curPtr sets gHeadPtr = curPtr,
     linking gHeadPtr to the first struct!
     */
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
    return line + strspn( line, " \t" );
}

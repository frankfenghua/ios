//
//  main.c
//  DVDTracker4
//
//  Created by James Bucanekand David Mark on 8/8/12.
//  Copyright (c) 2012 Apress, Inc. All rights reserved.
//

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <stdbool.h>
#include "dvdTracker.h"

char			GetCommand( void );
struct DVDInfo	*ReadStruct( void );
void			AddToList( struct DVDInfo *curPtr );
void			ListDVDs( bool forward );
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
			case 'r':
				ListDVDs( command=='l' );
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
    printf( "Enter command (q=quit, n=new, l=list, r=reverse list):  " );
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
    /* Exercise 4 notes:
     
     To keep a doubly-linked list, not only must the next
     pointers be upated, but the prev pointers too.
     
     A doubly-linked list with both head and tail pointers
     looks like this:
         head ---> A <---> B <--- tail
     
     The code to create this list looks something like:
         head = &A;
         A.prev = NULL;
         A.next = &B;
         B.prev = &A;
         B.next = NULL;
         tail = &B;
     
     To insert a new struct (X) between A & B, the list has to
     be updated to like this:
         head ---> A <---> X <---> B <--- tail
     
     The code to insert X between A & B looks something like:
         X.next = A.next;
         X.prev = B.prev;
         A.next = &X;
         B.prev = &X;
     
     If X is being inserted at the beginning of the list, head
     must be updated. If X is inserted at the tail of the list,
     then tail must be updated.

     This code works pretty much the same way as the solution in
     exercise 3 does, with two significant changes. It keeps
     a prevPtr, initialial set to NULL, that keeps track of
     the struct we just traversed. This will become the value
     of the new struct's prev field when inserted.
     It also uses the fact that *nextPtrPtr will either point to the
     struct that will follow the new struct, or be NULL if the new
     struct is being added to the end of the list.
     */
    struct DVDInfo **nextPtrPtr = &gHeadPtr;
    struct DVDInfo *prevPtr = NULL;
    
    while ( *nextPtrPtr != NULL && curPtr->rating > (*nextPtrPtr)->rating ) {
        prevPtr = *nextPtrPtr;
        nextPtrPtr = &(prevPtr->next);
    }
    curPtr->prev = prevPtr;             // link to previous struct
    curPtr->next = *nextPtrPtr;         // link to next struct

    if ( curPtr->next != NULL )
        curPtr->next->prev = curPtr;    // link prev of next struct to curPtr
    else
        gTailPtr = curPtr;              // no next struct: curPtr is now the tail

    *nextPtrPtr = curPtr;  // link next or previous struct (or head) to curPtr
}

/*****************
 ListDVDs()
 
 Print the current list of DVDInfo structs to stdout.
 */
void ListDVDs( bool forward )
{
    /* Exercise 4 notes:

     ListDVD() was modified to accept a forward parameter.
     If true, it traverses the list from head to tail.
     If false, it traverses the list from tail to head.
     
     It does this using two conditional expressions: the
     first starts the loop with curPtr set to either gHeadPtr
     or gTailPtr.
     The second advances to the next struct using either
     the next field or the prev field.

     Alternate solution:
     
     An equally good solution would be to break out the code
     that prints the DVD information and make it its
     own function (i.e. PrintDVD()).
     
     Then create two list functions, ListDVDs() and
     ListDVDsReverse(), that use a loop to traverse the
     list in the desired order, and call PrintDVD() for
     each one.
     */
	struct DVDInfo *curPtr = ( forward ? gHeadPtr : gTailPtr );
    bool separator = false;
	
	if ( curPtr == NULL ) {
		printf( "No DVDs have been entered yet...\n" );
	} else {
		while ( curPtr != NULL ) {
            if ( separator )
                printf( "--------\n" );
			printf( "Title:   %s\n", curPtr->title );
			printf( "Comment: %s\n", curPtr->comment );
			printf( "Rating:  %d\n", curPtr->rating );
            
            curPtr = ( forward ? curPtr->next : curPtr->prev );
            separator = true;
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

//
//  DVDFile.c
//  DVDFiler
//
//  Created by James Bucanek and David Mark on 8/12/12.
//  Copyright (c) 2012 Apress, Inc. All rights reserved.
//

#include <stdbool.h>
#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include "DVDInfo.h"
#include "DVDFile.h"


/* Constants */
#define kDVDFileName    "DVD Data.txt"


/* Local Function Prototypes */
static struct DVDInfo *ReadStructFromFile( FILE *fp );


/************************
 WriteFile()

 Creates and overwrites the DVD data file
 with the current contents of the linked
 list starting with gHeadPtr.
 */
void WriteFile( void )
{
	FILE			*fp;
	struct DVDInfo	*infoPtr;
	
	fp = fopen( kDVDFileName, "w" );
    
	for ( infoPtr=gHeadPtr; infoPtr!=NULL; infoPtr=infoPtr->next ) {
		fprintf( fp, "%s\n", infoPtr->title );
		fprintf( fp, "%s\n", infoPtr->comment );
		fprintf( fp, "%d\n", infoPtr->rating );
	}
	
	fclose( fp );
}


/**************************
 ReadFile()
 
 Opens the DVD data file and reads all
 of the DVD info it can.
 
 Each new DVDInfo struct is added to the
 linked list.
 */
void ReadFile( void )
{
	FILE *fp;
	
	if ( ( fp = fopen( kDVDFileName, "r" ) ) == NULL ) {
		printf( "Could not open file!\n" );
        printf( "File '%s' should be in %s.\n", kDVDFileName, getwd(NULL) );
		return;
	}
    
    struct DVDInfo *infoPtr;
    while ( ( infoPtr = ReadStructFromFile( fp ) ) != NULL ) {
        AddToList( infoPtr );
    }
	
	fclose( fp );
}


/************************************> ReadStructFromFile <*/
static struct DVDInfo *ReadStructFromFile( FILE *fp )
{
    struct DVDInfo  *infoPtr;
    int             num;
    bool            successful = true;
    
    // Allocate a new DVDInfo struct
    infoPtr = NewDVDInfo();
    
    // Read the fields
    // If any read fails, set successful to false.
	if ( fscanf( fp, "%[^\n]\n", infoPtr->title ) == EOF )
        successful = false;
    if ( fscanf( fp, "%[^\n]\n", infoPtr->comment ) == EOF )
        successful = false;
    if ( fscanf( fp, "%d\n", &num ) == EOF )
        successful = false;
    else
        infoPtr->rating = num;
    
    // If any field was not read, free the temporary
    /// struct (so we don't leak memory) and return
    //  NULL to the caller, indicating that the record
    //  could not be read.
    if ( ! successful ) {
        free( infoPtr );
        infoPtr = NULL;
    }
    
    // Return the new DVDInfo struct read from the file, or NULL
    return infoPtr;
}

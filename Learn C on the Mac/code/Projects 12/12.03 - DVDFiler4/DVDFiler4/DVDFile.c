//
//  DVDFile.c
//  DVDFiler4
//
//  Created by James Bucanek and David Mark on 8/12/12.
//  Copyright (c) 2012 Apress, Inc. All rights reserved.
//

#include <assert.h>
#include <stdbool.h>
#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <errno.h>
#include "DVDInfo.h"
#include "DVDFile.h"


/* Constants */
#define kDVDFileName    "DVD Data.txt"
#define kDVDTempName    "DVD Data.temp"


/* Local Function Prototypes */
static struct DVDInfo *ReadStructFromFile( FILE *fp );


/************************
 WriteFile()

 Writes the DVD data file to a temporary file
 with the current contents of the linked
 list starting with gHeadPtr.

 If successful, replaces the original DVD data
 file (if there was one) with the new one.
 */
void WriteFile( void )
{
	FILE			*fp;
	struct DVDInfo	*infoPtr;
    int             error = 0;
	
    // Write the contents of the DVDInfo link list to a temporary file
	fp = fopen( kDVDTempName, "w" );
    if ( fp == NULL )
        error = errno;
    
    for ( infoPtr=gHeadPtr; infoPtr!=NULL && !error; infoPtr=infoPtr->next ) {
        if (   fprintf( fp, "%s\n", infoPtr->title ) < 0
            || fprintf( fp, "%s\n", infoPtr->comment ) < 0
            || fprintf( fp, "%d\n", infoPtr->rating ) < 0 ) {
            error = errno;
        }
    }
	
    if ( fp != NULL ) {
        if ( fclose( fp ) != 0 )
            error = errno;
    }
    
    if ( ! error ) {
        // Replace the original file with the temporary file
        unlink( kDVDFileName );     // ignore error; it might not exist
        if ( rename( kDVDTempName, kDVDFileName ) != 0 ) {
            error = errno;
            unlink( kDVDTempName );
        }
        // if rename() was successful, then original file didn't
        //  exist or unlink() was successful.
    }

    if ( error )
        fprintf( stderr, "Could not write DVD data file: %s\n", strerror(error) );
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


/**************************
 ReadStructFromFile( FILE *fp )
        fp: file to read
    returns newly allocated DVDInfo struct if successful, or
            NULL if EOF or error
 */
static struct DVDInfo *ReadStructFromFile( FILE *fp )
{
    assert( fp != NULL );       // assume a valid fp pointer
    
    struct DVDInfo  *infoPtr;
    int             scanResult;
    
    // Allocate a new DVDInfo struct
    infoPtr = NewDVDInfo();
    
    // Read the fields
    //  fscanf() returns the number of successfully scanned values
    //           returns 0 if there was an error of some kind
    //           returns EOF if it runs out of characters to scan
    scanResult = fscanf( fp, "%[^\n]\n", infoPtr->title );
    if ( scanResult == 1 ) {
        scanResult = fscanf( fp, "%[^\n]\n", infoPtr->comment );
        if ( scanResult == 1 ) {
            int num;
            scanResult = fscanf( fp, "%d\n", &num );
            if ( scanResult == 1 ) {
                infoPtr->rating = num;
                // All fscanf() calls were successful!
                // Return the new DVDInfo struct to the caller
                return infoPtr;
            }
        }
    }
    
    if ( scanResult != EOF ) {
        // If fscanf() returned something other than EOF, it means it couldn't
        //  interpret the data for some reason, probably because there was a
        //  file error or the data is formatted incorrectly.
        fprintf( stderr, "Invalid data near offset %lu, %d: %s\n",
                (long unsigned int)ftello(fp),
                errno,
                strerror(errno) );
    }
    // Note: if fscanf() did return EOF it means the entire file has been read.
    //       For this program, that's not an "error," it's just an indication
    //       that it has finished reading the file.

    // If any field was not read, or the EOF was encounterd, free the temporary
    //  struct (so we don't leak memory) and return NULL to the caller,
    //  indicating that the record could not be read.
    free( infoPtr );
    return NULL;
}

//
//  DVDFile.c
//  DVDFiler3
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
#include <setjmp.h>
#include "DVDInfo.h"
#include "DVDFile.h"


/* Constants */
#define kDVDFileName    "DVD Data.txt"


/* Local Function Prototypes */
static struct DVDInfo *ReadStructFromFile( FILE *fp );
static bool ReadOneField( FILE *fp, const char *scanFormat, void *varPtr );
/* Local variables */


/************************
 WriteFile()

 Creates and overwrites the DVD data file
 with the current contents of the linked
 list starting with gHeadPtr.
 */
void WriteFile( void )
{
	FILE			*fp = NULL;
	struct DVDInfo	*infoPtr;
    int             error = 0;
    jmp_buf         writeJump;
	
    if ( ( error = setjmp( writeJump ) ) == 0 ) {
        // Try block
        fp = fopen( kDVDFileName, "w" );
        if ( fp == NULL )
            longjmp( writeJump, errno );

        for ( infoPtr=gHeadPtr; infoPtr!=NULL; infoPtr=infoPtr->next ) {
            if ( fprintf( fp, "%s\n", infoPtr->title ) < 0 )
                longjmp( writeJump, errno );
            if ( fprintf( fp, "%s\n", infoPtr->comment ) < 0 )
                longjmp( writeJump, errno );
            if ( fprintf( fp, "%d\n", infoPtr->rating ) < 0 )
                longjmp( writeJump, errno );
            }
        
        if ( fclose( fp ) != 0 )
            longjmp( writeJump, errno );
        
        // WriteFile() was successful
    } else {
        // Exception block
        fprintf( stderr, "Could not write DVD data file: %s\n", strerror(error) );
        // Housekeeping: try to close the file after an error
        if ( fp != NULL )
            fclose( fp );
    }
}


/**************************
 ReadFile()
 
 Opens the DVD data file and reads all
 of the DVD info it can.
 
 Each new DVDInfo struct is added to the
 linked list.
 */
static jmp_buf readJump;    // long jump for read errors
void ReadFile( void )
{
	FILE *fp = NULL;
    int  error;
	
    if ( ( error = setjmp( readJump ) ) == 0 ) {
        // Try block
        if ( ( fp = fopen( kDVDFileName, "r" ) ) == NULL )
            longjmp( readJump, errno );

        struct DVDInfo *infoPtr;
        while ( ( infoPtr = ReadStructFromFile( fp ) ) != NULL ) {
            AddToList( infoPtr );
        }

        fclose( fp );

	} else {
        // Exception block
        if ( fp == NULL ) {
            // if fp is NULL, file was never opened
            printf( "Could not open file!\n" );
            printf( "File '%s' should be in %s.\n", kDVDFileName, getwd(NULL) );
        } else {
            // if fp is not NULL, failed while reading the file
            fprintf( stderr, "Invalid data near offset %lu, %d: %s\n",
                    (long unsigned int)ftello(fp),
                    error,
                    strerror(error) );
            // remember to close the file even after an error
            fclose( fp );
        }
    }
}


/*******************************
 ReadStructFromFile( FILE *fp )
        fp: file to read
    returns newly allocated DVDInfo struct if successful, or
            NULL if EOF or error
 */
static struct DVDInfo *ReadStructFromFile( FILE *fp )
{
    assert( fp != NULL );       // assume a valid fp pointer
    
    struct DVDInfo  tempInfo;
    int             num;
    
    if ( ! ReadOneField( fp, "%[^\n]\n", tempInfo.title ) )
        return NULL;
    if ( ! ReadOneField( fp, "%[^\n]\n", tempInfo.comment ) )
        return NULL;
    if ( ! ReadOneField( fp, "%d\n", &num ) )
        return NULL;
    tempInfo.rating = num;
    
    // Allocate a new DVDInfo struct, copy the values into it
    //  and return that.
    struct DVDInfo  *infoPtr;
    infoPtr = NewDVDInfo();
    *infoPtr = tempInfo;
    
    return infoPtr;
}

/***************************************************************
 ReadOneField( FILE *fp, const char *scanFormat, void *varPtr )
            fp: file to read from
    scanFormat: format string passed to fscanf()
        varPtr: pointer to returned value
        returns true if successful
                false if EOF encountered
 
 Reads one value from the file.
 If an error occurs, throws errno to readJump.
 */
static bool ReadOneField( FILE *fp, const char *scanFormat, void *varPtr )
{
    int scanResult;
    
    scanResult = fscanf( fp, scanFormat, varPtr );
    if ( scanResult == 1)
        return true;
    if ( scanResult == EOF )
        return false;
    // Error: throw exception
    longjmp( readJump, errno );
}


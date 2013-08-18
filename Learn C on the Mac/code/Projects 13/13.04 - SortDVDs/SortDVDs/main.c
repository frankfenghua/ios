//
//  main.c
//  SortDVDs
//
//  Created by James Bucanek and David Marks on 9/13/12.
//  Copyright (c) 2012 Apress, Inc. All rights reserved.
//

#include <stdio.h>
#include <stdlib.h>
#include <string.h>


typedef struct {
    const char  *title;
    const char  *country;
    int         rating;
} DVDInfo;

static DVDInfo testArray[] = {
    { "A Monster in Paris",     "France",           8 },
    { "Space Dogs",             "Russia",           5 },
    { "Wallace & Gromit",       "United Kingdom",   9 },
    { "A Bug's Life",           "United States",    9 },
    { "Despicable Me",          "United States",    7 },
    { "Planet 51",              "Spain",            6 }
};
#define kNumberOfDVDs (sizeof(testArray)/sizeof(DVDInfo))


void PrintTestArray( void );
int CompareDVDTitles( const void* l, const void* r );
int CompareDVDCountries( const void* l, const void* r );
int CompareDVDRatings( const void* l, const void* r );



int main(int argc, const char * argv[])
{
    printf( "Original order:\n" );
    PrintTestArray();

    // Sort the DVDInfo array into title order
    qsort(testArray,kNumberOfDVDs,sizeof(DVDInfo),CompareDVDTitles);
    printf( "\nTitle order:\n" );
    PrintTestArray();

    printf( "\nCountry order:\n" );
    qsort(testArray,kNumberOfDVDs,sizeof(DVDInfo),CompareDVDCountries);
    PrintTestArray();
    
    printf( "\nRating order:\n" );
    qsort(testArray,kNumberOfDVDs,sizeof(DVDInfo),CompareDVDRatings);
    PrintTestArray();

	return 0;
}


void PrintTestArray( void )
{
    printf( "%-24s %-16s %s\n", "Title", "Country", "Rating" );
    unsigned int i;
    for ( i=0; i<kNumberOfDVDs; i++ )
        printf( "%-24s %-16s %d\n",
               testArray[i].title,
               testArray[i].country,
               testArray[i].rating );
}


int CompareDVDTitles( const void* l, const void* r )
{
    const DVDInfo *leftDVDPtr = l;
    const DVDInfo *rightDVDPtr = r;
    return strcmp( leftDVDPtr->title, rightDVDPtr->title );
}

int CompareDVDCountries( const void* l, const void* r )
{
    const DVDInfo *leftDVDPtr = l;
    const DVDInfo *rightDVDPtr = r;
    return strcmp( leftDVDPtr->country, rightDVDPtr->country );
}

int CompareDVDRatings( const void* l, const void* r )
{
	const DVDInfo *leftDVDPtr = l;
	const DVDInfo *rightDVDPtr = r;
	// Calculate the reverse order: highest to lowest
	int result = rightDVDPtr->rating - leftDVDPtr->rating;
	// If result is non-zero, the ratings are different: sort according to rating
	if ( result != 0 )
		return result;
	// If result is zero, the ratings are the same: sub-sort by title
	return CompareDVDTitles( l, r );
}


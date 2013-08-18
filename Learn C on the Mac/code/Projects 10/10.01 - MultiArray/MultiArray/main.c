//
//  main.c
//  MultiArray
//
//  Created by James Bucanek and David Mark on 8/7/12.
//  Copyright (c) 2012 Apress, Inc. All rights reserved.
//

#include <stdio.h>

#define kMaxDVDs			4
#define kMaxTitleLength		256

void PrintDVDTitle( int dvdNum, char title[][ kMaxTitleLength ] );

int main (int argc, const char * argv[])
{
	char	title[ kMaxDVDs ][ kMaxTitleLength ];
	int     dvdNum;
	
	printf( "The title array takes up %zu bytes of memory.\n\n",
           sizeof( title ) );
	
	for ( dvdNum = 0; dvdNum < kMaxDVDs; dvdNum++ ) {
		printf( "Title of DVD #%d: ", dvdNum + 1 );
		fgets( title[ dvdNum ], kMaxTitleLength, stdin );
	}
	
	printf( "----\n" );
	
	for ( dvdNum = 0; dvdNum < kMaxDVDs; dvdNum++ )
		PrintDVDTitle( dvdNum, title );
	
	return 0;
}


void PrintDVDTitle( int dvdNum, char title[][ kMaxTitleLength ] )
{
	printf( "Title of DVD #%d: %s\n", dvdNum + 1, title[ dvdNum ] );
}

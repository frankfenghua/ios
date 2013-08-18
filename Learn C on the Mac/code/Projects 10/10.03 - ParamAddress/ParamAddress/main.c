//
//  main.c
//  ParamAddress
//
//  Created by James Bucanek and David Mark on 8/8/12.
//  Copyright (c) 2012 Apress, Inc. All rights reserved.
//

#include <stdio.h>
#include "paramAddress.h"


void PrintParamInfo( struct DVDInfo *myDVDPtr, struct DVDInfo myDVDCopy );


int main ( int argc, const char * argv[] )
{
	struct DVDInfo	myDVD;
	
	printf( "Address of myDVD.rating in main(): %28p\n", &(myDVD.rating) );
	
	PrintParamInfo( &myDVD, myDVD );

	return 0;
}


void PrintParamInfo( struct DVDInfo *myDVDPtr, struct DVDInfo myDVDCopy )
{
	printf( "Address of myDVDPtr->rating in PrintParamInfo(): %10p\n", &(myDVDPtr->rating) );
	
	printf( "Address of myDVDCopy.rating in PrintParamInfo(): %10p\n", &(myDVDCopy.rating) );
}
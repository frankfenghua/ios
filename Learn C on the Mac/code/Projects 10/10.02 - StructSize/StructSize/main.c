//
//  main.c
//  StructSize
//
//  Created by James Bucanek on 8/8/12.
//  Copyright (c) 2012 Apress, Inc. All rights reserved.
//

#include <stdio.h>
#include "structSize.h"


int main (int argc, const char * argv[])
{
	struct DVDInfo	myInfo;
	
	printf( " rating field: %4zu byte\n", sizeof( myInfo.rating ) );
	
	printf( "  title field: %4zu bytes\n", sizeof( myInfo.title ) );
	
	printf( "comment field: %4zu bytes\n", sizeof( myInfo.comment ) );
	
	printf( "               ----------\n" );
	
	printf( "myInfo struct: %4zu bytes", sizeof( myInfo ) );
	
	return 0;
}

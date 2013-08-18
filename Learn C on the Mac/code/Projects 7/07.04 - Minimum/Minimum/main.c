//
//  main.c
//  Minimum
//
//  Created by James Bucanek and David Mark on 7/11/12.
//  Copyright (c) 2012 Apress. All rights reserved.
//

#include <stdio.h>

int Minimum( int a, int b );


int main(int argc, const char * argv[])
{
	printf( "%d is the smaller of 7 and 23\n", Minimum(7,23) );
	printf( "%d is the smaller of 23 and 7\n", Minimum(23,7) );
	
    return 0;
}

int Minimum( int a, int b )
{
	if ( a < b )
		return a;
	return b;
}

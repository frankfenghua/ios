//
//  main.c
//  Average
//
//  Created by James Bucanek and David Mark on 7/11/12.
//  Copyright (c) 2012 Apress. All rights reserved.
//

#include <stdio.h>

int Average( int a, int b );


int main(int argc, const char * argv[])
{
	int avg;
	avg = Average( 7, 23 );
	printf( "The average of 7 and 23 is %d.\n", avg );
	
	return 0;
}

int Average( int a, int b )
{
	return ( a + b ) / 2;
}


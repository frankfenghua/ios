//
//  main.c
//  Recurse
//
//  Created by James Bucanek and David Mark on 8/25/12.
//  Copyright (c) 2012 Apress, Inc. All rights reserved.
//

#include <stdio.h>

long Factorial( long num );

int main (int argc, const char * argv[])
{
	long int num = 5;
	
	printf( "%ld factorial is %ld.", num, Factorial( num ) );
	
	return 0;
}


long int Factorial( long int num )
{
	if ( num > 1 )
		num *= Factorial( num - 1 );
	
	return( num );
}
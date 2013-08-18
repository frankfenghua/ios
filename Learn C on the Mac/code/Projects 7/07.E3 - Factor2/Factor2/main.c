//
//  main.c
//  Factor2
//
//  Created by James Bucanek on 7/12/12.
//  Copyright (c) 2012 Apress. All rights reserved.
//

#include <stdio.h>
#include <stdbool.h>
#include <math.h>

// Alternate version of Factor project that doesn't use pointer parameters.

int Factor( int number );

int main(int argc, const char * argv[])
{
	int n;
	
	for ( n = 2; n <= 20; n++ ) {
		bool isPrime;
		int factor1, factor2;
		
		factor1 = Factor( n );
		factor2 = n / factor1;		// the second factor can be calculated from the first
		isPrime = ( factor1 == 1 );	// primeness can be determined by the first factor

		if ( isPrime )
			printf( "the number %d is prime\n", n );
		else
			printf( "the number %d has %d and %d as factors\n", n, factor1, factor2 );
	}
	
    return 0;
}


int Factor( int number )
{
	if ( number < 1 )
		return 1;
	
	int factor;	
	for ( factor = sqrt(number); factor > 1; factor-- ) {
		if ( (number % factor) == 0 ) {
			break;
		}
	}
	
	return factor;
}

//
//  main.c
//  NextPrime3
//
//  Created by James Bucanek on 7/4/12.
//  Copyright (c) 2012 Apress. All rights reserved.
//

#include <stdio.h>
#include <stdbool.h>
#include <math.h>


int main(int argc, const char * argv[])
{
	int		primeIndex, candidate, i, last;
	bool    isPrime;
	
	printf( "Prime #1 is 2.\n" );
	
	candidate = 3;
	primeIndex = 2;
	
	while ( primeIndex <= 100 ) {
		isPrime = true;
		last = sqrt( candidate );
		
		for ( i = 3; (i <= last) && isPrime; i += 2 ) {
			if ( (candidate % i) == 0 )
				isPrime = false;
		}
		
		if ( isPrime ) {
			printf( "Prime #%d is %d.\n", primeIndex, candidate );
			primeIndex++;
		}
		
		candidate += 2;
	}
	
	return 0;
}


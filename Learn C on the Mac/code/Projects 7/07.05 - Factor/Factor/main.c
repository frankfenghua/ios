//
//  main.c
//  Factor
//
//  Created by James Bucanek and David Mark on 7/12/12.
//  Copyright (c) 2012 Apress. All rights reserved.
//

#include <stdio.h>
#include <stdbool.h>
#include <math.h>


bool Factor( int number, int *firstFactorPtr, int *secondFactorPtr );

int main(int argc, const char * argv[])
{
	int n;
	
	for ( n = 2; n <= 20; n++ ) {
		bool isPrime;
		int factor1, factor2;
		
		isPrime = Factor( n, &factor1, &factor2 );
		if ( isPrime )
			printf( "the number %d is prime\n", n );
		else
			printf( "the number %d has %d and %d as factors\n", n, factor1, factor2 );
		}

    return 0;
}


bool Factor( int number, int *firstFactorPtr, int *secondFactorPtr )
{
	// Factor() returns true if number is prime, false if not.
	// Sets *firstFactor and *secondFactor to two factors of number.
	// The value of number should be greater than or equal to 1.
	
	// Numbers less than 1 don't make any sense, and we can't get the
	//  square root of a negative number anyway.
	if ( number < 1 )
		return false;	// do nothing and exit immediately if number is invalid
	
	// Test each value less than or equal to the square root of number, down to 2.
	// If a value is found to be an even divisor, break out of the for loop leaving
	//	the value of factor set to that number.
	// If none are found, the loop ends with factor set to 1. This means
	//	the number is prime, since prime numbers only have 1 and themselves
	//	as factors.
	int factor;	
	for ( factor = sqrt(number); factor > 1; factor-- ) {
		if ( (number % factor) == 0 ) {
			break;
		}
	}
	
	// Return the first factor in the variable pointed to by firstFactorPtr
	*firstFactorPtr = factor;
	// Return the second factor in the variable pointed to by secondFactorPtr
	// We calculate the second factor: if f1*f2=n, then f2=n/f1
	*secondFactorPtr = number / factor;
	
	// Return true if the number is prime.
	// If the first factor is 1, the number must be prime.
	// If it's any other number, the number isn't prime.
	return ( factor == 1 );
}

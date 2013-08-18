//
//  main.c
//  Dice2
//
//  Created by James Bucanek and David Mark on 7/20/12.
//  Copyright (c) 2012 Apress. All rights reserved.
//

#include <stdio.h>
#include <time.h>	//This is to bring in the declaration of clock()
#include <stdlib.h>	//This is to bring in the declarations of srand() and rand()

#define kDiceSides		12		// number of sides on a dice
#define kLowestRoll		(1*2)
#define kHighestRoll	(kDiceSides*2)
#define kRollArraySize	(kHighestRoll+1)

#define kRolls			1000

int RollOne( void );
void PrintRolls( int rolls[] );
void PrintX( int howMany );

int main (int argc, const char * argv[])
{
	int rolls[ kRollArraySize ], twoDice, i;
	
	srand( clock() );
	
	for ( i = 0; i < kRollArraySize; i++ )
		rolls[ i ] = 0;
	
	for ( i = 1; i <= kRolls; i++ ) {
		twoDice = RollOne() + RollOne();
		++ rolls[ twoDice ];
	}
	
	PrintRolls( rolls );
	
	return 0;
}


int	RollOne( void )
{
	return ( rand() % kDiceSides ) + 1;
}


void PrintRolls( int rolls[] )
{
	int i;
	
	for ( i = kLowestRoll; i <= kHighestRoll; i++ ) {
		printf( "%2d (%3d):  ", i, rolls[ i ] );
		PrintX( rolls[ i ] / 10 );
		putchar( '\n' );
	}
}


void PrintX( int howMany )
{
	int	i;
	
	for ( i = 1; i <= howMany; i++ )
		putchar( 'x' );
}

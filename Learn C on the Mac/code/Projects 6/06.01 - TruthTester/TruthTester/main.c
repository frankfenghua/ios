//
//  main.c
//  TruthTester
//
//  Created by James Bucanek and Dave Mark on 7/4/12.
//  Copyright (c) 2012 Apress. All rights reserved.
//

#include <stdio.h>
#include <stdbool.h>


int main(int argc, const char * argv[])
{
	bool hasCar, hasTimeToGiveRide;
	
	hasCar = true;
	hasTimeToGiveRide = true;
	
	if ( hasCar && hasTimeToGiveRide )
		printf( "Hop in - I'll give you a ride!\n" );
	else
		printf( "I've either got no car, no time, or both!\n" );
	

	bool nothingElseOn, newEpisode, itsARerun;

	nothingElseOn = true;
	newEpisode = true;
	
	if ( newEpisode || nothingElseOn )
		printf( "Let's watch Family Guy!\n" );
	else
		printf( "Something else is on or I've seen this one.\n" );
	
	nothingElseOn = true;
	itsARerun = false;
	
	if ( nothingElseOn || (!itsARerun) )
		printf( "Let's watch Family Guy!\n" );
	else
		printf( "Something else is on or I've seen this one.\n" );
	
	return 0;
}

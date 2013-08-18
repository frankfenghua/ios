//
//  main.c
//  Countdown
//
//  Created by James Bucanek and David Mark on 7/14/12.
//  Copyright (c) 2012 Apress. All rights reserved.
//

#include <stdio.h>

void Countdown( void );

int main(int argc, const char * argv[])
{
	Countdown();
	Countdown();
	Countdown();
	Countdown();
	
    return 0;
}

void Countdown( void )
{
	static int count = 3;
	
	if ( count != 0 )
		printf( "%d ...\n", count-- );
	else {
		printf( "Lift-off!\n" );
	}
}

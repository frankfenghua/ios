//
//  main.c
//  DrawDots
//
//  Created by James Bucanek and David Mark on 7/11/12.
//  Copyright (c) 2012 Apress. All rights reserved.
//

#include <stdio.h>

void DrawDots( int numDots );

int main ( int argc, const char * argv[] )
{
	DrawDots( 30 );
	
	return 0;
}

void DrawDots( int numDots )
{
	int	i;
	for ( i = 1; i <= numDots; i++ )
		printf( "." );
}

//
//  main.c
//  TypeOverflow
//
//  Created by James Bucanek and David Mark on 7/19/12.
//  Copyright (c) 2012 Apress. All rights reserved.
//

#include <stdio.h>

int main(int argc, const char * argv[])
{
	unsigned char	counter;
	
	for ( counter = 1; counter <= 1000; counter++ )
		printf( "%d\n", counter );
	
	unsigned int i;
	for ( i = 100; i >= 0; i-- )
		printf( "%d\n", i );
	
    return 0;
}


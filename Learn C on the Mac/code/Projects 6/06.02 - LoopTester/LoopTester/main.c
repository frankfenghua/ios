//
//  main.c
//  LoopTester
//
//  Created by James Bucanek and Dave Mark on 7/4/12.
//  Copyright (c) 2012 Apress. All rights reserved.
//

#include <stdio.h>

int main(int argc, const char * argv[])
{
	int i;
	
	i = 0;
	
	while ( i++ < 4 )
		printf("while: i=%d\n",i);
	printf("after while loop, i=%d\n\n",i);
	
	for ( i = 0; i < 4; i++ )
		printf("first for: i=%d\n",i);
	printf("after first for loop, i=%d\n\n",i);
	
	for ( i = 1; i <= 4; i++ )
		printf("second for: i=%d\n",i);
	printf("after second for loop, i=%d\n\n",i);
	
	return 0;
}


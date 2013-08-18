//
//  main.c
//  Pointer
//
//  Created by James Bucanek and David Mark on 7/11/12.
//  Copyright (c) 2012 Apress. All rights reserved.
//

#include <stdio.h>

int main(int argc, const char * argv[])
{
	int *myPointer, myVar;
	
	myVar = 0;
	
	myPointer = &myVar;
	
	*myPointer = 27;
	
	printf("myVar = %d\n",myVar);
	
	return 0;
}


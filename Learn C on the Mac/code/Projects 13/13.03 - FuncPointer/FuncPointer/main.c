//
//  main.c
//  FuncPointer
//
//  Created by James Bucanek and David Mark on 8/25/12.
//  Copyright (c) 2012 Apress, Inc. All rights reserved.
//

#include <stdio.h>

int	SquareIt( int num );

int main (int argc, const char * argv[])
{
	int (*myFuncPtr)( int );
	int num = 5;
    int result;
	
	myFuncPtr = SquareIt;
    
    result = (*myFuncPtr)( num );
	printf( "Using form (*myFuncPtr)( num ) ... %d squared is %d.\n", num, result );
    
    result = myFuncPtr( num );
	printf( "Using form myFuncPtr( num ) ...... %d squared is %d.\n", num, result );
	
	return 0;
}

int SquareIt( int num )
{
	return num * num ;
}

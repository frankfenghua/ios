//
//  main.c
//  Iterate
//
//  Created by James Bucanek and David Mark on 8/25/12.
//  Copyright (c) 2012 Apress, Inc. All rights reserved.
//

#include <stdio.h>

int main (int argc, const char * argv[])
{
    int      i, num;
    long int fac;
    
    num = 5;
    fac = 1;
    
    for ( i=1; i<=num; i++ )
        fac *= i;
    
    printf( "%d factorial is %ld.\n", num, fac );
    
    return 0;
}

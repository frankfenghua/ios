//
//  main.c
//  SeeArgs2
//
//  Created by James Bucanek and David Mark on 8/5/12.
//  Copyright (c) 2012 Apress, Inc. All rights reserved.
//

#include <stdio.h>

int main( int argc, const char * argv[] )
{
    int i;
    
    for ( i = 1; i < argc; i++ ) {
        // If outputting more than one arg, seperate
        //  successive args with a single space.
        if ( i!=1 )
            putchar(' ');
        // Echo the arg to stdout
        printf( "%s", argv[i] );
    }
    putchar( '\n' );
    
    return 0;
}


//
//  main.c
//  SeeArgs
//
//  Created by James Bucanek and David Mark on 7/27/12.
//  Copyright (c) 2012 Apress, Inc. All rights reserved.
//

#include <stdio.h>

int main( int argc, const char * argv[] )
{
    int i;
    
    for ( i = 0; i < argc; i++ ) {
        printf( "argv[%d] = '%s'\n", i, argv[i] );
    }

    return 0;
}


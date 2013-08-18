//
//  main.c
//  Message
//
//  Created by James Bucanek and David Mark on 8/5/12.
//  Copyright (c) 2012 Apress, Inc. All rights reserved.
//

#include <stdio.h>

int main(int argc, const char * argv[])
{
    char message[] = "Leo cC ran the Man";
    int x[] = { 2, 3, 5, 4 };
    int y[] = { 6, 4, 1, 13 };
    
    int i;
    for ( i = 0; i < (sizeof(x)/sizeof(x[0])); i++ ) {
        char *xPtr, *yPtr;
        
        xPtr = message + x[ i ];
        yPtr = xPtr + y[ i ];
        
        char c;
        c = *xPtr;
        *xPtr = *yPtr;
        *yPtr = c;
    }
    
    printf( "%s!\n", message );

    return 0;
}


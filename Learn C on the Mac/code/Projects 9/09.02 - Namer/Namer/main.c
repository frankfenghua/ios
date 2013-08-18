//
//  main.c
//  Namer
//
//  Created by James Bucanek and David Mark on 7/29/12.
//  Copyright (c) 2012 Apress, Inc. All rights reserved.
//

#include <stdio.h>
#include <string.h>


int main(int argc, const char * argv[])
{
    char name[ 20 ];
    
    printf( "Type your first name, please: " );
    scanf( "%s", name );    // See "Making Name Safer"
    
    printf( "Hello, %s!\n", name );
    printf( "Your name has %zu letters.\n", strlen(name) );
    
    return 0;
}


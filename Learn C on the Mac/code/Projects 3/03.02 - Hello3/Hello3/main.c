//
//  main.c
//  Hello3
//
//  Created by James Bucanek and Dave Mark on 6/8/12.
//  Copyright (c) 2012 Apress. All rights reserved.
//

#include <stdio.h>

void SayHello( void );


int main(int argc, const char * argv[])
{
    SayHello();
    SayHello();
    SayHello();
    
    return 0;
}


void SayHello( void )
{
    printf("Hello, world!\n");
}




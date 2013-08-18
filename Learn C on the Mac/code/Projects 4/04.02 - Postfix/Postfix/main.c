//
//  main.c
//  Postfix
//
//  Created by James Bucanek and Dave Mark on 6/22/12.
//  Copyright (c) 2012 Apress. All rights reserved.
//

#include <stdio.h>

int main(int argc, const char * argv[])
{
    int myInt;
    
    myInt = 5;
    
    myInt = myInt * 3;
    printf( "myInt ---> %d\n", myInt );
    
    printf( "myInt ---> %d\n", myInt++ );
    
    printf( "myInt ---> %d\n", ++myInt );
    
    return 0;
}


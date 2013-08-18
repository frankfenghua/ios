//
//  main.c
//  Sample
//
//  Created by James Bucanek and Dave Mark on 5/30/12.
//  Copyright (c) 2012 Apress. All rights reserved.
//

#include <stdio.h>

int main(int argc, const char * argv[])
{
    int number, sum;
    sum = 0;
    for (number=1; number<=10; number++)
        sum += number;
    printf("The sum of the numbers from 1 to 10 is %d.\n",sum);
    return 0;
}


//
//  main.c
//  Overflow
//
//  Created by James Bucanek and David Mark on 7/21/12.
//  Copyright (c) 2012 Apress. All rights reserved.
//

#include <stdio.h>
#include <strings.h>

void PrintFullName( char *firstName, char *lastName );

int main(int argc, const char * argv[])
{
	PrintFullName( "David", "Mark" );
	PrintFullName( "James", "Bucanek" );
	PrintFullName( "Wilhelmina", "Romanowski" );

    return 0;
}

void PrintFullName( char *firstName, char *lastName )
{
	char fullName[ 20 ];
	
	strcpy( fullName, lastName );
	strcat( fullName, ", " );
	strcat( fullName, firstName );
	//strlcpy( fullName, lastName, sizeof(fullName) );
	//strlcat( fullName, ", ", sizeof(fullName) );
	//strlcat( fullName, firstName, sizeof(fullName) );
	
	printf( "full name: %s\n", fullName );
}


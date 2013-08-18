//
//  main.c
//  IntSizer
//
//  Created by James Bucanek and David Mark on 7/19/12.
//  Copyright (c) 2012 Apress. All rights reserved.
//

#include <stdio.h>

int main(int argc, const char * argv[])
{
	printf( "sizeof( char ) = %zu\n",sizeof( char ) );
	printf( "sizeof( unsigned char ) = %zu\n",sizeof( unsigned char ) );
	printf( "sizeof( short int ) = %zu\n",sizeof( short int ) );
	printf( "sizeof( unsigned short int ) = %zu\n",sizeof( unsigned short int ) );
	printf( "sizeof( int ) = %zu\n",sizeof( int ) );
	printf( "sizeof( unsigned int ) = %zu\n",sizeof( unsigned int ) );
	printf( "sizeof( long int ) = %zu\n",sizeof( long int ) );
	printf( "sizeof( unsigned long int ) = %zu\n",sizeof( unsigned long int ) );
	printf( "sizeof( long long int ) = %zu\n",sizeof( long long int ) );
	printf( "sizeof( unsigned long long int ) = %zu\n",sizeof( unsigned long long int ) );

	return 0;
}


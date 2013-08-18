//
//  main.c
//  FloatSizer
//
//  Created by James Bucanek and David Mark on 7/17/12.
//  Copyright (c) 2012 Apress. All rights reserved.
//

#include <stdio.h>

int main(int argc, const char * argv[])
{
	float	myFloat;
	double	myDouble;
	long double	myLongDouble;
	
	myFloat = 12345.67890123456789f;
	myDouble = 12345.67890123456789;
	myLongDouble = 12345.67890123456789L;
	
	printf( "sizeof( float ) = %zu\n", sizeof(myFloat) );
	printf( "sizeof( double ) = %zu\n", sizeof(myDouble) );
	printf( "sizeof( long double ) = %zu\n\n", sizeof(myLongDouble) );
	
	printf( "     myFloat = %25.16f\n", myFloat );
	printf( "    myDouble = %25.16f\n", myDouble );
	printf( "myLongDouble = %25.16Lf\n\n", myLongDouble );
	
	printf( "     myFloat = %e\n", myFloat );
	printf( "    myDouble = %e\n", myDouble );
	printf( "myLongDouble = %Le\n\n", myLongDouble );

	printf( "     myFloat = %.20g\n", myFloat );
	printf( "    myDouble = %.20g\n", myDouble );
	printf( "myLongDouble = %.20Lg\n", myLongDouble );
}


//
//  main.c
//  FileReader
//
//  Created by James Bucanek and David Mark on 8/13/12.
//  Copyright (c) 2012 Apress, Inc. All rights reserved.
//

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <pwd.h>
#include <unistd.h>


/* Function Prototypes */
void    SetHomeDirectory( void );
bool	ReadLineOfNums( FILE *fp, int numsPerLine, int *intArray );
void	PrintLineOfNums( int numsPerLine, int *intArray );


int main(int argc, const char * argv[])
{
    SetHomeDirectory();     // set working dir to ~
    chdir( "./Desktop" );   // set working dir to ~/Desktop

	FILE	*fp;
	int		*intArray, numsPerLine;
	
	fp = fopen( "My Numbers.txt", "r" );
	
	fscanf( fp, "%d", &numsPerLine );
	intArray = calloc( numsPerLine, sizeof( int ) );
	
	while ( ReadLineOfNums( fp, numsPerLine, intArray ) )
		PrintLineOfNums( numsPerLine, intArray );
	
	free( intArray );
	
	return 0;
}

/************************
 ReadLineOfNums( FILE *fp, int numsPerLine, int *intArray )
             fp: file
    numsPerLine: count of integers to read
       intArray: pointer to array of ints
         returns true if all ints were read
 
 intArray[] must be at least numsPerLine ints long
 
 Read ASCII encoded integer numbers from the fp character stream.
 Convert each one to an int and store it in intArray[].
 */
bool ReadLineOfNums( FILE *fp, int numsPerLine, int *intArray )
{
	int	i;
	
	for ( i=0; i<numsPerLine; i++ ) {
		if ( fscanf( fp, "%d", &(intArray[ i ]) ) != 1 )
			return false;
	}
	
	return true;
}


/*********************************
 PrintLineOfNums( int numsPerLine, int *intArray )
    numsPerLine: number of ints in intArray
       intArray: array of ints
 
 Output tab separated integers on a line to stdout
 */
void PrintLineOfNums( int numsPerLine, int *intArray )
{
	int	i;
	
	for ( i=0; i<numsPerLine; i++ )
		printf( "%d\t", intArray[ i ] );
	
	printf( "\n" );
}


/*******************************
 SetHomeDirectory()
 
 Set the current working directory to the home directory
 of the logged in user.
 */
void SetHomeDirectory( void )
{
    struct passwd *pw = getpwuid( getuid() );
    chdir( pw->pw_dir );
}

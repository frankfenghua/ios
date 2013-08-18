//
//  main.c
//  RomanNumeral
//
//  Created by James Bucanek and David Mark on 8/13/12.
//  Copyright (c) 2012 Apress, Inc. All rights reserved.
//

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdbool.h>
#include <ctype.h>


#define kMinDecimalNumber       1       // smallest number that can be converted
#define kMaxDecimalNumber       3999    // largest number that can be converted
#define kMaxRomanNumeralLength  15      // longest possible roman numeral


void PrintUsageAndExit( void );
void ReplaceNumbersInStream( FILE* stream );
void NumberToRomanNumeral( int number, char *romanNumeral );


int main( int argc, const char * argv[] )
{
    int i;
    for ( i=1/*skip first argv string*/; i<argc; i++ ) {
        if ( strcmp( argv[i], "-h" ) == 0 )
            PrintUsageAndExit();

        // try to convert argument into a number
        int number;
        number = atoi( argv[i] );
        if ( number != 0 ) {
            // only convert if argument number is in allowed range
            // (atoi() returns 0 if the string isn't a number)
            if ( number >= kMinDecimalNumber && number <= kMaxDecimalNumber ) {
                // string to hold the converted number
                char romanNumeral[ kMaxRomanNumeralLength+1 ];
                // convert number
                NumberToRomanNumeral( number, romanNumeral );
                // output original number and roman numeral
                printf( "%d = %s\n", number, romanNumeral );
            } else {
                // number is out of range
                PrintUsageAndExit();
            }
        } else {
            // second try: see if the argument is a file
            FILE* fp = fopen( argv[i], "r" );
            if ( fp != NULL ) {
                ReplaceNumbersInStream( fp );
                fclose( fp );
            } else {
                // argument is not a number or readable file
                PrintUsageAndExit();
            }
        }
    }
    
    if ( argc == 1 )
        ReplaceNumbersInStream( stdin );
    
    return 0;
}

/**************************
 PrintUsageAndExit()
 
 Prints tool help to stderr and exits with status of 1.
 */
void PrintUsageAndExit( void )
{
    fprintf( stderr, "Usage: RomanNumeral [ -h ] [ number | file ... ]\n" );
    fprintf( stderr, "\t-h      prints this message and exits\n" );
    fprintf( stderr, "\tnumber  between %d and %d\n", kMinDecimalNumber, kMaxDecimalNumber );
    fprintf( stderr, "\tfile    file echoed to stdout, replacing decimal numbers\n" );
    fprintf( stderr, "\tif no arguments are specified, replaces decimal numbers in stdin\n");
    exit( 1 );
}

/**************************
 ReplaceNummbersInStream( FILE* stream )
    stream: character stream, open for reading
 
 Echos characters in stream to stdout until it encounters
 a decimal digit.
 Decimal numbers are scanned, converted to roman numerals
 (if possible), and the converted value is output in its place.
 */
void ReplaceNumbersInStream( FILE* stream )
{
    int c;
    while ( (c=fgetc(stream)) != EOF ) {
        if ( isdigit( c ) ) {
            // character in stream appears to be the beginning
            //  of a decimal number. unget it and parse integer
            //  value using scanf().
            ungetc( c, stream );
            long long int number;
            fscanf( stream, "%lld", &number );
            if ( number >= kMinDecimalNumber && number <= kMaxDecimalNumber ) {
                // replace the number with its roman numeral value
                char romanNumeral[ kMaxRomanNumeralLength+1 ];
                NumberToRomanNumeral( (int)number, romanNumeral );
                printf( "%s", romanNumeral );
            } else {
                // number isn't in range that can be converted
                // echo it, unchanged, and continue
                printf( "%lld", number );
            }
        } else {
            // all other characters are echoed unchanged
            putchar( c );
        }
    }
}

/*******************************************************
 NumberToRomanNumeral( int number, char *romanNumeral )
    number: decimal value to convert (must be between 1-3999)
     romanNumeral: char array to receive conversion
 
 romanNumeral must be at least kMaxRomanNumeralLength+1 bytes long
 
 Convert the decimal value in a Roman numeral and copy the
 results to romanNumeral.
 */
void NumberToRomanNumeral( int number, char *romanNumeral )
{
	// Print out |number| using roman numerals
	// number is a value between 1 and 3999
	
	// fixed array Roman numeral characters
	static char roman[] = "IVXLCDM";
	
	int numeral;
	numeral = 0;
	// numeral is an index into roman[] for the current power of 10
	// numeral+0 is index of one's numeral
	// numeral+1 is index of five's numeral
	// numeral+2 is index of ten's numeral
    
	// result array will hold the finished roman numerals
	char result[ kMaxRomanNumeralLength+1 ];
	char *resultPtr;			// pointer to first character of finished string
	
	result[ kMaxRomanNumeralLength ] = '\0';		// terminate end of array
	resultPtr = &result[ kMaxRomanNumeralLength ];	// point resultPtr at last element
    // Note that resultPtr starts out pointing to the *last* element of result[],
    //  and the finished string is constructed backwards.
    
	while ( number != 0 ) {
		int digit;
		
		// Get least significant digit of number
		digit = number % 10;
		
		// Insert the roman numeral(s) for this digit, remembering that
		//	they are being inserted from right to left.
		switch ( digit ) {
            // There is no "zero" in roman numerals, insert nothing
			case 0:
				break;
                
            // if the digit is 1, 2 or 3 insert 1, 2, or 3 "one" numerals
			case 3:
				*--resultPtr = roman[ numeral ];
			case 2:
				*--resultPtr = roman[ numeral ];
			case 1:
				*--resultPtr = roman[ numeral ];
				break;
				
            // if the digit is 4, insert a "one" "five" sequence
			case 4:
				*--resultPtr = roman[ numeral+1 ];
				*--resultPtr = roman[ numeral ];
				break;
                
            // if the digit is 5, 6, 7, or 8, insert a "five" numeral
            //	followed by 0 to 3 "one" numerals
			case 8:
				*--resultPtr = roman[ numeral ];
			case 7:
				*--resultPtr = roman[ numeral ];
			case 6:
				*--resultPtr = roman[ numeral ];
			case 5:
				*--resultPtr = roman[ numeral+1 ];
				break;
                
            // If the digit is 9, insert a "one" "ten" sequence
			case 9:
				*--resultPtr = roman[ numeral+2 ];
				*--resultPtr = roman[ numeral ];
				break;
		}
		
		// Advance to next power-of-10
		number /= 10;	// decode next decimal digit
		numeral += 2;	// advance to next set of roman numerals
	}
	
    // Copy the finished roman numeral to the caller's string buffer
    strcpy( romanNumeral, resultPtr );
}


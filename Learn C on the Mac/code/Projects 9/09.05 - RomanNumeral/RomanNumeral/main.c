//
//  main.c
//  RomanNumeral
//
//  Created by James Bucanek and David Mark on 8/3/12.
//  Copyright (c) 2012 Apress, Inc. All rights reserved.
//

#include <stdio.h>
#include <string.h>
#include <stdlib.h>


#define kMinDecimalNumber       1       // smallest number that can be converted
#define kMaxDecimalNumber       3999    // largest number that can be converted
#define kMaxRomanNumeralLength  15      // longest possible roman numeral

void NumberToRomanNumeral( int number, char *romanNumeral );


int main( int argc, const char * argv[] )
{
    int i;
    for ( i=1/*skip first argv string*/; i<argc; i++ ) {
        // convert one argument into a number
        int number;
        number = atoi( argv[i] );
        
        // only convert if argument number is in convertable range
        // (not that atoi() returns 0 if the string isn't a number)
        if ( number >= kMinDecimalNumber && number <= kMaxDecimalNumber ) {
            // string to hold the converted number
            char romanNumeral[ kMaxRomanNumeralLength+1 ];

            // convert the number into a roman numeral
            NumberToRomanNumeral( number, romanNumeral );
            // output the number
            printf( "%d = %s\n", number, romanNumeral );
        }
    }
    
    return 0;
}

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


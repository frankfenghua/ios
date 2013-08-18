//
//  main.c
//  WordCount
//
//  Created by James Bucanek and David Mark on 8/1/12.
//  Copyright (c) 2012 Apress, Inc. All rights reserved.
//

#include <stdio.h>
#include <ctype.h> //This is to bring in the declaration of isspace()
#include <stdbool.h>  //This is to bring in the define of true


#define kMaxLineLength		200

void ReadLine( char *line );
int  CountWords( char *line );

int main (int argc, const char * argv[])
{
    char line[ kMaxLineLength+1 ];  // room for kMaxLineLength chars + one NUL
    int	 numWords;
    
    printf( "Type a line of text, please:\n" );
    
    ReadLine( line );
    numWords = CountWords( line );
    
    printf( "\n---- This line has %d word%s. ---\n", numWords, ( numWords!=1 ? "s" : "" ) );
    
    printf( "%s\n", line );
    
    return 0;
}


void ReadLine( char *line )
{
    int numCharsRead = 0;
    
    int c;
    while ( (c = getchar()) != EOF
           && c != '\n'
           && ++numCharsRead <= kMaxLineLength ) {
        *line++ = c;
    }
    
    *line = '\0';
}


int	CountWords( char *line )
{
    int numWords;
    bool inWord;
    
    numWords = 0;
    inWord = false;
    
    while ( *line != '\0' ) {
        if ( isspace( *line ) ) {
            inWord = false;
        }
        else {
            if ( ! inWord ) {
                numWords++;
                inWord = true;
            }
        }
        
        line++;
    }
    
    return numWords;
}

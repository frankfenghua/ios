//
//  main.c
//  WordCount2
//
//  Created by James Bucanek and David Mark on 8/1/12.
//  Copyright (c) 2012 Apress, Inc. All rights reserved.
//

#include <stdio.h>
#include <ctype.h> //This is to bring in the declaration of isspace()
#include <stdbool.h>  //This is to bring in the define of true


#define kMaxLineLength		200

// Chapter 9 exercise:
//  ReadLine() now returns a bool: true if a line was read, false if no more character
bool ReadLine( char *line );
int  CountWords( char *line );

int main (int argc, const char * argv[])
{
    char line[ kMaxLineLength+1 ];  // room for kMaxLineLength chars + one NUL
    int	 numWords;
    
    // Chapter 9 exercise:
    //  Removed the code that prompts for a line.
    
    // Chapter 9 exercise:
    //  Run ReadLine() and CountWords() in a while loop that continues, indefinately,
    //  until ReadLine() returns false (meaning there are no more characters to read).
    //  Note: Becuase of this, the program will now run in the Xcode console until you
    //        stop it with the Stop button, or type Control+D in the console pane.
    //        ^D is the ASCII end-of-file control character and will cause standard in
    //        to return an EOF.
    while ( ReadLine( line ) != false ) {
        numWords = CountWords( line );
        printf( "\n---- This line has %d word%s. ---\n", numWords, ( numWords!=1 ? "s" : "" ) );
        printf( "%s\n", line );
    }
    
    return 0;
}


bool ReadLine( char *line )
{
    int numCharsRead = 0;
    
    // Chapter 9 exercise:
    //  Changed the order of the condition expressions in the while statement.
    //  The first condition checks for EOF, then numCharsRead is incremented and
    //  tested for overflow. Finally, c is compared to '\n'.
    //  This means that if any valid character (even \n) is read, numCharsRead will
    //  be incremented and will not be 0 when the loop exits.
    //  This is important, because you don't want ReadLine() to return false for
    //  a blank line (i.e. a line that consists of nothing but a single \n).
    
    int c;
    while ( (c = getchar()) != EOF
           && ++numCharsRead <= kMaxLineLength
           && c != '\n' ) {
        *line++ = c;
    }
    
    *line = '\0';
    
    // Chapter 9 exercise:
    //  Return true if 1 or more characters were read,
    //  false if very first getchar() returned EOF.
    return ( numCharsRead!=0 );
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

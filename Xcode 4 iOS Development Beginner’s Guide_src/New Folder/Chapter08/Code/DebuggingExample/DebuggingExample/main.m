//
//  main.m
//  DebuggingExample
//
//  Created by Steven F Daniel on 23/01/11.
//  Copyright 2011 GenieSoft Studios. All rights reserved.
//

#import <UIKit/UIKit.h>


// -----------------------------------------------------------
// Example: Potential Memory Leak
// -----------------------------------------------------------
void performMemoryleak()
{
    NSString *obj = [[NSString alloc] init];    
    [obj doubleValue];
}

// -----------------------------------------------------------
// Example: Uninitialized Variable being declared
// -----------------------------------------------------------
int setReturnValue(int _varX)
{
    int number;
    
    if (_varX > 100) 
    {
        number = _varX * 2;
    }
    else if (_varX == 100)
    {
        number = _varX - 50;
    } 
    return number;
}


int main(int argc, char *argv[]) {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    int retVal = UIApplicationMain(argc, argv, nil, nil);
    [pool release];
    return retVal;
}

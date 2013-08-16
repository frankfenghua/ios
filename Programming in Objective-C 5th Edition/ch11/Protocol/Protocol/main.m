//
//  main.m
//  Protocol
//
//  Created by fenghua on 2013-08-16.
//  Copyright (c) 2013 fenghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Bicycle.h"
//#import "Car.h"
#import "StreetLegal.h"

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        
        Bicycle *bike = [[Bicycle alloc] init];
        [bike startPedaling];
        [bike signalLeftTurn];
        [bike signalStop];
        [bike lockToStructure:nil];
        
    }
    return 0;
}

/*
 http://rypress.com/tutorials/objective-c/protocols.html
 A more realistic use case can be seen in your everyday iOS application development. The entry point into any iOS app is an “application delegate” object that handles the major events in a program’s life cycle. Instead of forcing the delegate to inherit from any particular superclass, the UIKit Framework just makes you adopt a protocol:
 
 @interface YourAppDelegate : UIResponder <UIApplicationDelegate>
 As long as it responds to the methods defined by UIApplicationDelegate, you can use any object as your application delegate. Implementing the delegate design pattern through protocols instead of subclassing gives developers much more leeway when it comes to organizing their applications.
*/

/*
 Delegation
 You can also think of a protocol as an interface definition between two classes. The class that defines the protocol can be thought of as delegating the work defined by the methods in the protocol to the class that implements them. In that way, the class can be defined to be more general, with specific actions taken by the delegate class in response to certain events or to define specific parameters. Cocoa and iOS rely heavily on this concept of delegation. For example, when you set up a table on the iPhone’s display, you’ll use the UITableView class. But that class doesn’t know the title of the table, how many sections or rows it contains, or what to put in each row (cell) of the table. So, it delegates that responsibility to you by defining a protocol called UITableViewDataSource. When it needs information (for example, how many rows are in each sect ion of t he t able), it calls t he appropriat e met hod t hat you’ve defined in your class in accordance with the protocol. TheUITableView class also defines another protocol called UITableViewDelegate. The methods in this protocol define, among other things, what to do when a particular row from a table is selected. This class doesn’t know what action to take, so it delegates that responsibility to you.
 */
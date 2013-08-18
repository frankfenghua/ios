//
//  TasteOfCocoaAppDelegate.h
//  TasteOfCocoa
//
//  Created by Dave Mark on 7/4/11.
//  Copyright 2011 Dave Mark. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface TasteOfCocoaAppDelegate : NSObject <NSApplicationDelegate> {
@private
    NSWindow *window;
}

@property (assign) IBOutlet NSWindow *window;

@end

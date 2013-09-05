//
//  JSAppDelegate.m
//  ObjCPPTest
//
//  Created by Joel Saltzman on 11/15/12.
//  Copyright (c) 2012 joelsaltzman.com. All rights reserved.
//  testing out code from http://robnapier.net/blog/wrapping-cppfinal-edition-759/comment-page-1#comment-16789

#import "JSAppDelegate.h"

@implementation JSAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    CPPWrapper *wrapper = [[CPPWrapper alloc] init];
    wrapper.name = @"some name";
    NSLog(@"name: %@", wrapper.name);
}

@end

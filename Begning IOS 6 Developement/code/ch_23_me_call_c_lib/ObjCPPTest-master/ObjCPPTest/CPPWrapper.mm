//
//  CPPWrapper.m
//  ObjCPPTest
//
//  Created by Joel Saltzman on 11/15/12.
//  Copyright (c) 2012 joelsaltzman.com. All rights reserved.
//  testing out code from http://robnapier.net/blog/wrapping-cppfinal-edition-759/comment-page-1#comment-16789
#import "CPPWrapper.h"
#include "Cpp.h"

@interface CPPWrapper ()
@property (nonatomic, readwrite, assign) Cpp *cpp;
@end

@implementation CPPWrapper
@synthesize cpp = _cpp;

- (id)init {
    self = [super init];
    if (self) {
        _cpp = new Cpp();
    }
    return self;
}

- (void)dealloc {
    delete _cpp;
}

- (NSString *)name {
    return [NSString stringWithUTF8String:self.cpp->getName().c_str()];
}

- (void)setName:(NSString *)aName {
    self.cpp->setName([aName UTF8String]);
}
@end
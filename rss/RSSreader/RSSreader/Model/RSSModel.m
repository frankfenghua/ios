//
//  RSSModel.m
//  RSSreader
//
//  Created by feng on 2014-05-04.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import "RSSModel.h"

@implementation RSSModel

- (id)init
{
    self = [super init];
    if (nil != self)
    {
        self.feeds = [[NSMutableArray alloc] init];
        self.item = [[NSMutableDictionary alloc] init];
        self.title = [[NSMutableString alloc] init];
        self.link = [[NSMutableString alloc] init];
    }

    return self;
}

- (id)initWithTitle:(NSString *)newTitle {
    if ((self = [super init])) {
        self.title = [newTitle copy];
    }
    return self;
}

- (id)initWithURL:(NSURL *)newURL {
    if ((self = [super init])) {
        self.url = [newURL copy];
    }
    return self;
}

- (void)addKey:(NSString*)aKey value:(NSMutableString*)aValue {
    [self.item setObject:aValue forKey:aKey];
}
@end

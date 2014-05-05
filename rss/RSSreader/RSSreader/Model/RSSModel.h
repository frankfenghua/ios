//
//  RSSModel.h
//  RSSreader
//
//  Created by feng on 2014-05-04.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSSModel : NSObject

@property (strong, nonatomic) NSMutableString *title;
@property (strong, nonatomic) NSMutableString *link;
@property (strong, nonatomic) NSMutableString *description;
@property (strong, nonatomic) NSURL *url;
@property (strong, nonatomic) NSMutableDictionary *item;
@property (strong, nonatomic) NSMutableArray *feeds;
@property (strong, nonatomic) NSString *element;

- (id)initWithTitle:(NSString *)newTitle ;
- (id)initWithURL:(NSURL *)newURL ;
- (void)addKey:(NSString*)aKey value:(NSMutableString*)aValue ;
@end

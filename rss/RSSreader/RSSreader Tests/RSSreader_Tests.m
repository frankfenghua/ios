//
//  RSSreader_Tests.m
//  RSSreader Tests
//
//  Created by feng on 2014-05-04.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RSSModel.h"

@interface RSSreader_Tests : XCTestCase
{
    RSSModel *rssModel;
}
@end

@implementation RSSreader_Tests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    rssModel = [[RSSModel alloc] initWithURL:  [NSURL URLWithString:@"http://images.apple.com/main/rss/hotnews/hotnews.rss"]];
    rssModel.description =  [[NSMutableString alloc] initWithString:@"this is a description" ];
    rssModel.link =  [[NSMutableString alloc] initWithString:@"this is a link" ];
    rssModel.element =  @"this is a element";
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    rssModel = nil;
    [super tearDown];
}

- (void)testThatRSSFeedExists {
    RSSModel *newRSSModel = [[RSSModel alloc] init];
    XCTAssertNotNil(newRSSModel,@"should be able to create a RSSModel instance");
}

- (void)testThatTitleCanBeNamed {
    RSSModel *namedTitle = [[RSSModel alloc] initWithTitle: @"iPhone"];
    XCTAssertEqualObjects(namedTitle.title, @"iPhone",@"the Title should have the name I gave it");
}

- (void)testThatRSSModelHasAnURL {
    NSURL *url = rssModel.url;
    XCTAssertEqualObjects(url.absoluteString, @"http://images.apple.com/main/rss/hotnews/hotnews.rss",@"the RSSModel should be represented by a URL");
}

- (void)testThatRSSModelHasAnDescription {
    XCTAssertEqualObjects(rssModel.description, @"this is a description",@"the RSSModel should have a description");
}

- (void)testThatRSSModelHasALink {
    XCTAssertEqualObjects(rssModel.link, @"this is a link",@"the RSSModel should have a link");
}

- (void)testThatRSSModelHasAElement {
    XCTAssertEqualObjects(rssModel.element, @"this is a element",@"the RSSModel should have a element");
}
@end

//
//  APPMasterViewController.m
//  RSSreader
//
//  Created by feng on 2014-05-04.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import "APPMasterViewController.h"

#import "APPDetailViewController.h"
#import "RSSModel.h"

@class RSSModel;

//private stuff
@interface APPMasterViewController () {
    NSXMLParser *parser;
    RSSModel *rssModel;
}
@end

@implementation APPMasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    rssModel = [[RSSModel alloc] init ];

    rssModel.url = [NSURL URLWithString:@"http://images.apple.com/main/rss/hotnews/hotnews.rss"];
    
    parser = [[NSXMLParser alloc] initWithContentsOfURL:rssModel.url ];
    [parser setDelegate:self];
    [parser setShouldResolveExternalEntities:NO];
    [parser parse];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return rssModel.feeds.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = [[rssModel.feeds objectAtIndex:indexPath.row] objectForKey: @"title"];
    return cell;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    rssModel.element = elementName;

    if ([rssModel.element  isEqualToString:@"item"]) {

        rssModel.item        = [[NSMutableDictionary alloc] init];
        rssModel.title       = [[NSMutableString alloc] init];
        rssModel.link        = [[NSMutableString alloc] init];
        rssModel.description = [[NSMutableString alloc] init];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    if ([elementName isEqualToString:@"item"]) {

        [rssModel addKey:@"title" value:rssModel.title];
        [rssModel addKey:@"link" value:rssModel.link];
        [rssModel addKey:@"description" value:rssModel.description];
        
        [rssModel.feeds addObject:[rssModel.item copy]];
        
        
    }
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    if ([rssModel.element isEqualToString:@"title"]) {
        [rssModel.title appendString:string];
    } else if ([rssModel.element isEqualToString:@"link"]) {
        [rssModel.link appendString:string];
    } else if ([rssModel.element isEqualToString:@"description"]) {
        [rssModel.description appendString:string];
    }


}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    
    [self.tableView reloadData];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];

        NSString *string = [rssModel.feeds[indexPath.row] objectForKey: @"link"];
        NSString *titleString = [rssModel.feeds[indexPath.row] objectForKey: @"title"];
        NSString *descriptionString = [rssModel.feeds[indexPath.row] objectForKey: @"description"];

        [[segue destinationViewController] setUrl:string];
        [[segue destinationViewController] setFeedTitle:titleString];
        [[segue destinationViewController] setDescription:descriptionString];

    }
}

@end

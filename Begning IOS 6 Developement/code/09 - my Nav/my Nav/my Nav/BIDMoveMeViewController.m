//
//  BIDMoveMeViewController.m
//  my Nav
//
//  Created by fenghua on 2013-08-22.
//  Copyright (c) 2013 ClassroomM. All rights reserved.
//

#import "BIDMoveMeViewController.h"

static NSString *CellIdentifier = @"Cell";



@implementation BIDMoveMeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Move Me";
        self.rowImage = [UIImage imageNamed:@"moveMeIcon.png"];
        self.words = [@[@"Eeny", @"Meeny", @"Miney", @"Moe", @"Catch", @"A",
                      @"Tiger", @"By", @"The", @"Toe"] mutableCopy];
        self.navigationItem.rightBarButtonItem = self.editButtonItem;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:CellIdentifier];
}

#pragma mark - Table Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [self.words count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.textLabel.text = self.words[indexPath.row];
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView
shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO; }
- (void)tableView:(UITableView *)tableView
moveRowAtIndexPath:(NSIndexPath *)fromIndexPath
      toIndexPath:(NSIndexPath *)toIndexPath
{
    id object = [self.words objectAtIndex:fromIndexPath.row];
    [self.words removeObjectAtIndex:fromIndexPath.row];
    [self.words insertObject:object atIndex:toIndexPath.row];
}

@end

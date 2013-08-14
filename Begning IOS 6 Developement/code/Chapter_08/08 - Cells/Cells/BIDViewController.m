//
//  BIDViewController.m
//  Cells
//

#import "BIDViewController.h"
#import "BIDNameAndColorCell.h"

@implementation BIDViewController

static NSString *CellTableIdentifier = @"CellTableIdentifier";

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.computers = @[
    @{@"Name" : @"MacBook", @"Color" : @"White"},
    @{@"Name" : @"MacBook Pro", @"Color" : @"Silver"},
    @{@"Name" : @"iMac", @"Color" : @"Silver"},
    @{@"Name" : @"Mac Mini", @"Color" : @"Silver"},
    @{@"Name" : @"Mac Pro", @"Color" : @"Silver"}];

    UITableView *tableView = (id)[self.view viewWithTag:1];
    tableView.rowHeight = 65;
    UINib *nib = [UINib nibWithNibName:@"BIDNameAndColorCell"
                                bundle:nil];
    [tableView registerNib:nib
    forCellReuseIdentifier:CellTableIdentifier];
}

#pragma mark -
#pragma mark Table Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [self.computers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    BIDNameAndColorCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    
    NSDictionary *rowData = self.computers[indexPath.row];
    
    cell.name = rowData[@"Name"];
    cell.color = rowData[@"Color"];
    
    return cell;
}

@end

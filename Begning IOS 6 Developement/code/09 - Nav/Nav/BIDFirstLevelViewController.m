//
//  BIDFirstLevelControllerViewController.m
//  Nav
//

#import "BIDFirstLevelViewController.h"
#import "BIDSecondLevelViewController.h"
#import "BIDDisclosureButtonViewController.h"
#import "BIDCheckListViewController.h"
#import "BIDRowControlsViewController.h"
#import "BIDMoveMeViewController.h"
#import "BIDDeleteMeViewController.h"
#import "BIDPresidentsViewController.h"

static NSString *CellIdentifier = @"Cell";

@implementation BIDFirstLevelViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.title = @"First level";
        self.controllers = @[
            [[BIDDisclosureButtonViewController alloc] init],
            [[BIDCheckListViewController alloc] init],
            [[BIDRowControlsViewController alloc] init],
            [[BIDMoveMeViewController alloc] init],
            [[BIDDeleteMeViewController alloc] init],
            [[BIDPresidentsViewController alloc] init]
        ];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:CellIdentifier];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.controllers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    BIDSecondLevelViewController *controller = self.controllers[indexPath.row];
    cell.textLabel.text = controller.title;
    cell.imageView.image = controller.rowImage;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BIDSecondLevelViewController *controller = self.controllers[indexPath.row];
    [self.navigationController pushViewController:controller animated:YES];
}

@end

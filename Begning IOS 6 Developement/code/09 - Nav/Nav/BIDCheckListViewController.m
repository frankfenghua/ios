//
//  BIDCheckListViewController.m
//  Nav
//

#import "BIDCheckListViewController.h"

static NSString *CellIdentifier = @"Cell";

@implementation BIDCheckListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Check One";
        self.rowImage = [UIImage imageNamed:@"checkmarkControllerIcon.png"];
        self.snacks = @[@"Who Hash", @"Bubba Gump Shrimp Étouffée",
            @"Who Pudding", @"Scooby Snacks", @"Everlasting Gobstopper",
            @"Green Eggs and Ham", @"Soylent Green", @"Hard Tack",
            @"Lembas Bread", @"Roast Beast", @"Blancmange"];
        self.selectedSnack = NSNotFound;
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

#pragma mark - Table View Data Source Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.snacks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.textLabel.text = self.snacks[indexPath.row];
    if (self.selectedSnack == indexPath.row) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

#pragma mark - Table View Delegate Methods

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != self.selectedSnack) {
        if (self.selectedSnack != NSNotFound) {
            NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:self.selectedSnack
                                                           inSection:0];
            UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:oldIndexPath];
            oldCell.accessoryType = UITableViewCellAccessoryNone;
        }
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.selectedSnack = indexPath.row;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end

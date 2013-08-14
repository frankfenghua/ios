//
//  BIDDisclosureButtonViewController.m
//  Nav
//

#import "BIDDisclosureButtonViewController.h"
#import "BIDDisclosureDetailViewController.h"

static NSString *CellIdentifier = @"Cell";

@implementation BIDDisclosureButtonViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Disclosure Buttons";
        self.rowImage = [UIImage imageNamed:@"disclosureButtonControllerIcon.png"];

        self.movies = @[@"Toy Story", @"A Bug's Life", @"Toy Story 2",
        @"Monsters, Inc.", @"Finding Nemo", @"The Incredibles",
        @"Cars", @"Ratatouille", @"WALL-E", @"Up",
        @"Toy Story 3", @"Cars 2", @"Brave"];
        self.detailController = [[BIDDisclosureDetailViewController alloc] init];
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
    return [self.movies count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    cell.textLabel.text = self.movies[indexPath.row];
    
    return cell;
}

#pragma mark - Table View Delegate Methods

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Hey, do you see the disclosure button?"
                          message:@"Touch that to drill down instead."
                          delegate:nil
                          cancelButtonTitle:@"Won't happen again"
                          otherButtonTitles:nil];
    [alert show];
}

- (void)tableView:(UITableView *)tableView
accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    self.detailController.title = @"Disclosure Button Pressed";
    NSString *selectedMovie = self.movies[indexPath.row];
    NSString *detailMessage = [[NSString alloc]
                               initWithFormat:@"This is details for %@.",
                               selectedMovie];
    self.detailController.message = detailMessage;
    self.detailController.title = selectedMovie;
    [self.navigationController pushViewController:self.detailController
                                         animated:YES];
}

@end

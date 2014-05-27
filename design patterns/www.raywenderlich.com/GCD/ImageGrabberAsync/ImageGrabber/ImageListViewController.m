//
//  ImageListViewController.m
//  ImageGrabber
//
//  Created by Ray Wenderlich on 7/3/11.
//  Copyright 2011 Ray Wenderlich. All rights reserved.
//

#import "ImageListViewController.h"
#import "ImageInfo.h"
#import "ImageDetailViewController.h"
#import "ImageManager.h"

@implementation ImageListViewController
@synthesize imageDetailViewController;
@synthesize html;
@synthesize imageInfos;
@synthesize imageManager;
@synthesize activityIndicator;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [imageDetailViewController release];
    [html release];
    [imageInfos release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
    [imageDetailViewController release];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
        
    
    // Add activity indicator to nav bar
    CGRect frame = CGRectMake(0.0, 0.0, 25.0, 25.0);
    self.activityIndicator = [[UIActivityIndicatorView alloc]
                              initWithFrame:frame];
    [self.activityIndicator sizeToFit];
    self.activityIndicator.autoresizingMask =
    (UIViewAutoresizingFlexibleLeftMargin |
     UIViewAutoresizingFlexibleRightMargin |
     UIViewAutoresizingFlexibleTopMargin |
     UIViewAutoresizingFlexibleBottomMargin);
    [activityIndicator startAnimating];
    
    UIBarButtonItem *loadingView = [[UIBarButtonItem alloc] 
                                    initWithCustomView:self.activityIndicator];
    loadingView.target = self;
    self.navigationItem.rightBarButtonItem = loadingView;
    
    // Start image manage to load images
    self.imageInfos = [[[NSMutableArray alloc] init] autorelease];
    self.imageManager = [[[ImageManager alloc] initWithHTML:html delegate:self] autorelease];
    [imageManager process];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageUpdated:) name:@"com.razeware.imagegrabber.imageupdated" object:nil];
    
}

- (void)imageInfosAvailable:(NSArray *)newInfos done:(BOOL)done {
    
    NSLog(@"Image infos available: %d!", newInfos.count);
    
    NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:newInfos.count];
    for(int i = imageInfos.count; i < imageInfos.count + newInfos.count; ++i) {
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [indexPaths addObject:indexPath];
    }
    [imageInfos addObjectsFromArray:newInfos];
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationRight];
    
    if (done) {
        [activityIndicator stopAnimating];
    }
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"com.razeware.imagegrabber.imageupdated" object:nil];
}

- (void)imageUpdated:(NSNotification *)notif {
    
    ImageInfo * info = [notif object];
    int row = [imageInfos indexOfObject:info];
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    
    NSLog(@"Image for row %d updated!", row);
    
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
}


- (void)viewWillAppear:(BOOL)animated
{
        
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
    return imageInfos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    ImageInfo * info = [imageInfos objectAtIndex:indexPath.row];
    cell.textLabel.text = info.imageName;
    cell.imageView.image = info.image;
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    ImageInfo *info = [imageInfos objectAtIndex:indexPath.row];
    if (imageDetailViewController == nil) {
        self.imageDetailViewController = [[[ImageDetailViewController alloc] initWithNibName:@"ImageDetailViewController" bundle:[NSBundle mainBundle]] autorelease];
    }
    imageDetailViewController.info = info;
    [self.navigationController pushViewController:imageDetailViewController animated:YES];
    
}

@end

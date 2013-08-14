//
//  BIDViewController.m
//  Core Data Peristence
//

#import "BIDViewController.h"
#import "BIDAppDelegate.h"

static NSString * const kLineEntityName = @"Line";
static NSString * const kLineNumberKey = @"lineNumber";
static NSString * const kLineTextKey = @"lineText";

@interface BIDViewController ()

@end

@implementation BIDViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    BIDAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc]
                               initWithEntityName:kLineEntityName];
    
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    if (objects == nil) {
        NSLog(@"There was an error!");
        // Do whatever error handling is appropriate
    }
    
    for (NSManagedObject *oneObject in objects) {
        int lineNum = [[oneObject valueForKey:kLineNumberKey] intValue];
        NSString *lineText = [oneObject valueForKey:kLineTextKey];
        
        UITextField *theField = self.lineFields[lineNum];
        theField.text = lineText;
    }
    
    UIApplication *app = [UIApplication sharedApplication];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(applicationWillResignActive:)
     name:UIApplicationWillResignActiveNotification
     object:app];
}

- (void)applicationWillResignActive:(NSNotification *)notification
{
    BIDAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSError *error;
    for (int i = 0; i < 4; i++) {
        UITextField *theField = self.lineFields[i];
        
        NSFetchRequest *request = [[NSFetchRequest alloc]
                                   initWithEntityName:kLineEntityName];
        
        NSPredicate *pred = [NSPredicate
                             predicateWithFormat:@"(%K = %d)", kLineNumberKey, i];
        [request setPredicate:pred];
        
        NSArray *objects = [context executeFetchRequest:request error:&error];
        if (objects == nil) {
            NSLog(@"There was an error!");
            // Do whatever error handling is appropriate
        }
        
        NSManagedObject *theLine = nil;
        if ([objects count] > 0) {
            theLine = [objects objectAtIndex:0];
        } else {
            theLine = [NSEntityDescription
                       insertNewObjectForEntityForName:kLineEntityName
                       inManagedObjectContext:context];
        }
        
        [theLine setValue:[NSNumber numberWithInt:i] forKey:kLineNumberKey];
        [theLine setValue:theField.text forKey:kLineTextKey];
        
    }
    [appDelegate saveContext];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

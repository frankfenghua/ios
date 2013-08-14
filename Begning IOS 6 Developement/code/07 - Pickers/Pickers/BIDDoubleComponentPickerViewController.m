//
//  BIDDoubleComponentPickerViewController.m
//  Pickers
//

#import "BIDDoubleComponentPickerViewController.h"

@implementation BIDDoubleComponentPickerViewController

-(IBAction)buttonPressed
{
    NSInteger fillingRow = [self.doublePicker selectedRowInComponent:
                            kFillingComponent];
    NSInteger breadRow = [self.doublePicker selectedRowInComponent:
                          kBreadComponent];
    
    
    NSString *filling = self.fillingTypes[fillingRow];
    NSString *bread = self.breadTypes[breadRow];
    
    NSString *message = [[NSString alloc] initWithFormat:
                         @"Your %@ on %@ bread will be right up.", filling, bread];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:
                          @"Thank you for your order"
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"Great!"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.fillingTypes = @[@"Ham", @"Turkey", @"Peanut Butter",
    @"Tuna Salad", @"Chicken Salad", @"Roast Beef", @"Vegemite"];
    self.breadTypes = @[@"White", @"Whole Wheat", @"Rye",
    @"Sourdough", @"Seven Grain"];
}

#pragma mark -
#pragma mark Picker Data Source Methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    if (component == kBreadComponent) {
        return [self.breadTypes count];
    } else {
        return [self.fillingTypes count];
    }
}

#pragma mark Picker Delegate Methods
- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    if (component == kBreadComponent) {
        return self.breadTypes[row];
    } else {
        return self.fillingTypes[row];
    }
}

@end

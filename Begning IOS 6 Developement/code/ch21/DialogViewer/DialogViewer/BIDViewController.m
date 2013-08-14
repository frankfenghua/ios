//
//  BIDViewController.m
//  DialogViewer
//

#import "BIDViewController.h"
#import "BIDContentCell.h"
#import "BIDHeaderCell.h"

@interface BIDViewController ()
@property (copy, nonatomic) NSArray *sections;
@end

@implementation BIDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.sections = @[
    @{
    @"header" : @"First Witch",
    @"content" : @"Hey, when will the three of us meet up later?"
    },
    @{
    @"header" : @"Second Witch",
    @"content" : @"When everything's straightened out."
    },
    @{
    @"header" : @"Third Witch",
    @"content" : @"That'll be just before sunset."
    },
    @{
    @"header" : @"First Witch",
    @"content" : @"Where?"
    },
    @{
    @"header" : @"Second Witch",
    @"content" : @"The dirt patch."
    },
    @{
    @"header" : @"Third Witch",
    @"content" : @"I guess we'll see Mac there."
    },
    ];

    
    [self.collectionView registerClass:[BIDContentCell class]
            forCellWithReuseIdentifier:@"CONTENT"];
    
    self.collectionView.backgroundColor = [UIColor
                                           scrollViewTexturedBackgroundColor];

    UICollectionViewLayout *layout = self.collectionView.collectionViewLayout;
    UICollectionViewFlowLayout *flow = (UICollectionViewFlowLayout *)layout;
    flow.sectionInset = UIEdgeInsetsMake(10, 20, 30, 20);


    [self.collectionView registerClass:[BIDHeaderCell class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:@"HEADER"];
    
    flow.headerReferenceSize = CGSizeMake(100, 25);
    
    //    flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
}

// helper
- (NSArray *)wordsInSection:(NSInteger)section {
    NSString *content = self.sections[section][@"content"];
    NSCharacterSet *space = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSArray *words = [content componentsSeparatedByCharactersInSet:space];
    return words;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self.sections count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    NSArray *words = [self wordsInSection:section];
    return [words count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *words = [self wordsInSection:indexPath.section];

    BIDContentCell *cell = [self.collectionView
                            dequeueReusableCellWithReuseIdentifier:@"CONTENT"
                            forIndexPath:indexPath];
    cell.text = words[indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *words = [self wordsInSection:indexPath.section];
    CGSize size = [BIDContentCell sizeForContentString:words[indexPath.row]];
    return size;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqual:UICollectionElementKindSectionHeader]) {
        BIDHeaderCell *cell = [self.collectionView
                               dequeueReusableSupplementaryViewOfKind:kind
                               withReuseIdentifier:@"HEADER"
                               forIndexPath:indexPath];
        cell.text = self.sections[indexPath.section][@"header"];
        return cell;
    }
    return nil;
}

@end

//
//  BIDPresident.h
//  Nav
//

#import <Foundation/Foundation.h>

@interface BIDPresident : NSObject <NSCoding, NSCopying>

@property (assign, nonatomic) NSInteger number;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *fromYear;
@property (copy, nonatomic) NSString *toYear;
@property (copy, nonatomic) NSString *party;

@end

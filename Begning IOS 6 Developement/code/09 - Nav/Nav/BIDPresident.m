//
//  BIDPresident.m
//  Nav
//

#import "BIDPresident.h"

static NSString * const kPresidentNumberKey = @"President";
static NSString * const kPresidentNameKey   = @"Name";
static NSString * const kPresidentFromKey   = @"FromYear";
static NSString * const kPresidentToKey     = @"ToYear";
static NSString * const kPresidentPartyKey  = @"Party";

@implementation BIDPresident

#pragma mark - NSCoding
- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeInt:self.number forKey:kPresidentNumberKey];
    [coder encodeObject:self.name forKey:kPresidentNameKey];
    [coder encodeObject:self.fromYear forKey:kPresidentFromKey];
    [coder encodeObject:self.toYear forKey:kPresidentToKey];
    [coder encodeObject:self.party forKey:kPresidentPartyKey];
}

- (id)initWithCoder:(NSCoder *)coder
{
    if (self = [super init]) {
        self.number = [coder decodeIntForKey:kPresidentNumberKey];
        self.name = [coder decodeObjectForKey:kPresidentNameKey];
        self.fromYear = [coder decodeObjectForKey:kPresidentFromKey];
        self.toYear = [coder decodeObjectForKey:kPresidentToKey];
        self.party = [coder decodeObjectForKey:kPresidentPartyKey];
    }
    return self;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone;
{
    BIDPresident *copy = [[BIDPresident alloc] init];
    copy.number = self.number;
    copy.name = self.name;
    copy.fromYear = self.fromYear;
    copy.toYear = self.toYear;
    copy.party = self.party;
    return copy;
}

@end

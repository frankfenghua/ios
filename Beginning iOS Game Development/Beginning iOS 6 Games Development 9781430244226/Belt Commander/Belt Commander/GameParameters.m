//
//  GameParameters.m
//  Belt Commander
//
//  Created by Lucas Jordan on 8/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "GameParameters.h"

@implementation GameParameters
@synthesize includeSaucers, includePowerups, includeAsteroids, purchases;

+(id)gameParameters{
    GameParameters* params = [GameParameters new];
    [params setIncludeAsteroids:YES];
    [params setIncludeSaucers:NO];
    [params setIncludePowerups:NO];
    [params setPurchases: [NSMutableSet new]];
    
    return params;
}
- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeBool:self.includeAsteroids forKey:@"includeAsteroids"];
    [aCoder encodeBool:self.includeSaucers forKey:@"includeSaucers"];
    [aCoder encodeBool:self.includePowerups forKey:@"includePowerups"];
    
    [aCoder encodeObject:self.purchases forKey:@"purchases"];
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self != nil){
        self.includeAsteroids = [aDecoder decodeBoolForKey:@"includeAsteroids"];
        self.includeSaucers = [aDecoder decodeBoolForKey:@"includeSaucers"];
        self.includePowerups = [aDecoder decodeBoolForKey:@"includePowerups"];
        self.purchases = [aDecoder decodeObjectForKey:@"purchases"];
    }
    return self;
}
+(id)readFromDefaults{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSData* data = [defaults objectForKey:GAME_PARAM_KEY];
    if (data == nil){
        GameParameters* params = [GameParameters gameParameters];
        [params writeToDefaults];
        return params;
    } else{
        return [NSKeyedUnarchiver unarchiveObjectWithData: data];
    }
}
-(void)writeToDefaults{
    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:self];
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:data forKey:GAME_PARAM_KEY];
    [defaults synchronize];
}
@end

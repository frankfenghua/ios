//
//  Player.h
//  Ratings
//
//  Created by Marin Todorov on 8/9/13.
//
//

#import <Foundation/Foundation.h>

@interface Player : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *game;
@property (nonatomic, assign) int rating;

@end

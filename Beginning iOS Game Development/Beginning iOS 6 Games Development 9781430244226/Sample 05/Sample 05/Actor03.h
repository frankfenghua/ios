//
//  Actor03.h
//  Sample 05
//
//  Created by Lucas Jordan on 5/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Example03Controller;
long nextId;
@interface Actor03 : NSObject {
    
}
@property (nonatomic, strong) NSNumber* actorId;
@property (nonatomic) CGPoint center;
@property float rotation;
@property (nonatomic) float speed;
@property (nonatomic) float radius;
@property (nonatomic, strong) NSString* imageName;
@property (nonatomic) BOOL needsImageUpdated;

-(id)initAt:(CGPoint)aPoint WithRadius:(float)aRadius AndImage:(NSString*)anImageName;
-(void)step:(Example03Controller*)controller;
-(BOOL)overlapsWith: (Actor03*) actor;

@end
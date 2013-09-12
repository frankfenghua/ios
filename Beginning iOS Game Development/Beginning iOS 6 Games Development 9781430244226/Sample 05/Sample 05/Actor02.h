//
//  Actor02.h
//  Sample 05
//
//  Created by Lucas Jordan on 5/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Example02Controller;
long nextId;
@interface Actor02 : NSObject {
    
}
@property (nonatomic, strong) NSNumber* actorId;
@property (nonatomic) CGPoint center;
@property (nonatomic) float speed;
@property (nonatomic) float radius;
@property (nonatomic, strong) NSString* imageName;
 
-(id)initAt:(CGPoint)aPoint WithRadius:(float)aRadius AndImage:(NSString*)anImageName;
-(void)step:(Example02Controller*)controller;
-(BOOL)overlapsWith: (Actor02*) actor;

@end

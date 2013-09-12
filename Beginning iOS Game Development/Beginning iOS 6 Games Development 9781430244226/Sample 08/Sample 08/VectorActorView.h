//
//  VectorActorView.h
//  Sample 06
//
//  Created by Lucas Jordan on 5/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Actor.h"
#import "VectorRepresentation.h"

@interface VectorActorView : UIView {
    
}
@property (nonatomic, strong) Actor* actor;
@property (nonatomic, strong) NSObject<VectorRepresentationDelegate>* delegate;

@end

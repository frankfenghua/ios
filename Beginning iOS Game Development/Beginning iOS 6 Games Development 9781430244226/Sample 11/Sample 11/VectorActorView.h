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
@property (nonatomic, retain) Actor* actor;
@property (nonatomic, retain) NSObject<VectorRepresentationDelegate>* delegate;

@end

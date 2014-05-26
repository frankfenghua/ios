//
//  Album+TableRepresentation.h
//  BlueLibrary
//
//  Created by Eli Ganem on 15/8/13.
//  Copyright (c) 2013 Eli Ganem. All rights reserved.
//

#import "Album.h"

@interface Album (TableRepresentation)

- (NSDictionary*)tr_tableRepresentation;

@end

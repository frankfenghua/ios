//
//  MyDocument.h
//  MyDocument
//
//  Created by Steven F Daniel on 18/11/10.
//  Copyright (c) 2010 GenieSoft Studios. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MyDocument : NSDocument {
    IBOutlet NSTextView *rtfTextView;
    NSAttributedString *docString;
}

@property(retain)NSTextView *rtfTextView;
@property(retain)NSAttributedString *docString;
@end

//
//  structSize.h
//  StructSize
//
//  Created by James Bucanek and David Mark on 8/8/12.
//  Copyright (c) 2012 Apress, Inc. All rights reserved.
//

#ifndef StructSize_structSize_h
#define StructSize_structSize_h

#define kMaxTitleLength     256
#define kMaxCommentLength	256


/***********************/
/* Struct Declarations */
/***********************/
struct DVDInfo {
	char    rating;
	char    title[ kMaxTitleLength ];
	char    comment[ kMaxCommentLength ];
};

#endif

//
//  DVDInfo.h
//  DVDFiler
//
//  Created by James Bucanek and David Mark on 8/12/12.
//  Copyright (c) 2012 Apress, Inc. All rights reserved.
//

#ifndef DVDFiler_DVDInfo_h
#define DVDFiler_DVDInfo_h

/***********/
/* Defines */
/***********/
#define kMaxTitleLength     256
#define kMaxCommentLength	256


/***********************/
/* Struct Declarations */
/***********************/
struct DVDInfo
{
	char			rating;
	char			title[ kMaxTitleLength ];
	char			comment[ kMaxCommentLength ];
	struct DVDInfo	*next;
};

/********************/
/* Public Functions */
/********************/

extern struct DVDInfo *ReadStruct( void );
extern void AddToList( struct DVDInfo *curPtr );
extern void ListDVDs( void );
extern struct DVDInfo *NewDVDInfo( void );
extern char *TrimLine( char *line );

/********************/
/* Public Variables */
/********************/

extern struct DVDInfo *gHeadPtr;

#endif

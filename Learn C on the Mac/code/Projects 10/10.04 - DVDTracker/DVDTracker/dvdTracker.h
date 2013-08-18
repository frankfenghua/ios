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


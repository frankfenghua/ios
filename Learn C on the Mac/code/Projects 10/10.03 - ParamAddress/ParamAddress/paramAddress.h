/***********/
/* Defines */
/***********/
#define kMaxDVDs			300
#define kMaxTitleLength     50
#define kMaxCommentLength	50


/***********************/
/* Struct Declarations */
/***********************/
struct DVDInfo
{
	char	rating;
	char	title[ kMaxTitleLength ];
	char	comment[ kMaxCommentLength ];
};


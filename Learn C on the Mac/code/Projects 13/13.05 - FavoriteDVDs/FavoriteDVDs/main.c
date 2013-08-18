//
//	main.c
//	FavoriteDVDs
//
//	Created by James Bucanek and David Marks on 9/16/12.
//	Copyright (c) 2012 Apress, Inc. All rights reserved.
//

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <CoreFoundation/CoreFoundation.h>


typedef struct {
	const char	*title;
	const char	*country;
	int			rating;
} DVDInfo;

static DVDInfo testArray[] = {
	{ "A Monster in Paris",		"France",			8 },
	{ "Space Dogs",				"Russia",			5 },
	{ "Wallace & Gromit",		"United Kingdom",	9 },
	{ "A Bug's Life",			"United States",	9 },
	{ "Despicable Me",			"United States",	7 },
	{ "Planet 51",				"Spain",			6 }
};
#define kNumberOfDVDs (sizeof(testArray)/sizeof(DVDInfo))


static CFStringRef FavoriteSetItemDescription( const void *value );
static Boolean FavoriteSetCompareItems( const void *value1, const void *value2 );
static CFHashCode FavoriteSetItemHashCode( const void *value );

static CFSetCallBacks FavoriteSetCallBacks = {
	0,							// version number, must be 0
	NULL,						// allocation callback - we don't need one
	NULL,						// deallocation callback - we don't need one
	FavoriteSetItemDescription, // description callback
	FavoriteSetCompareItems,	// compare callback
	FavoriteSetItemHashCode		// hash code callback
};


int main(int argc, const char * argv[])
{
	CFMutableSetRef favorites;
	
	// Create a set object to keep track of our favorite titles
	favorites = CFSetCreateMutable( NULL, kNumberOfDVDs, &FavoriteSetCallBacks );
	
	// Add A Monster in Paris and A Bug's Life to the set of favorites
	CFSetAddValue( favorites, testArray[0].title );
	CFSetAddValue( favorites, testArray[3].title );
	
	// List the DVDs and determine which ones are favorites
	printf( "Fav Title\n" );
	unsigned int i;
	for ( i=0; i<kNumberOfDVDs; i++ ) {
		char fav = ' ';						// print a space if NOT a favorite
		// Determine if this DVD title is one of our favorites by asking
		//	the set if the title of this DVD is in the collection
		if ( CFSetContainsValue( favorites, testArray[i].title ) )
			fav = '*';
		printf( " %c  %s\n", fav, testArray[i].title );
	}
	
	return 0;
}



/************************************
 Collection callbacks

 A collection has a set of callbacks (function pointers)
	that will be called, at appropriate times, to manage
	certain aspects of the items (objects) in your collection.

 This allows you customize a set, or any other kind of
	collection, to use your particular kind of data.
	The rest of the collection library then does all of
	the work of storing, sorting, searching, and deleting items
	from the collection.

 If what you're putting into the collection are standard
	Core Foundation "objects" (CFString, CFNumber, and so on),
	then you don't have to write callbacks. That work has
	already been done for you. Simply pass the
	CFSetRetainCallBack constant and your set is ready to use.
*/

/*
 The favorites set is a colletion of simple C string pointers.
 These functions create a set that can store, find, and compare
 C string pointers.
 */

static CFStringRef FavoriteSetItemDescription( const void *value )
{
	// This function is called by the collection whenever it wants a printable
	//	description of an item. This function simply turns the title string
	//	and returns it as a Core Foundation string "object", which is what
	//	the caller expects.
	return CFStringCreateWithCString( NULL, value, kCFStringEncodingASCII );
}

static Boolean FavoriteSetCompareItems( const void *value1, const void *value2 )
{
	// This function is called whenever the collection wants to compare two
	//	items for equality. The two parameters are pointers to the two
	//	"objects" in the collection. In the favorites collection, both
	//	are C string pointers, so we use strcmp() to see if the two
	//	C strings are equal or not.
	return ( strcmp(value1,value2) == 0 );
}

static CFHashCode FavoriteSetItemHashCode( const void *value )
{
	// This function is called whenver the collection needs to calculate
	//	the so-called hash code of the item. A hash code is an integer
	//	number that makes comparing and searching for items much faster.
	// The number returned can be anything, but it must follow this rule:
	//	- Two items that are equal MUST return the same hash code
	//
	// The set is most efficient when any two items that are not equal
	//	return different numbers for their hash code. Since this is
	//	impossible (there are many more possible strings than possible
	//	hash code numbers), the idea is to create a hash code function
	//	that makes it unlikely that two different strings would return
	//	the same number. The more unlikely, the better the hash code,
	//	function, and the more efficient the set.
	
#if 1
	// Our implementation will add all of the character values of the
	//	string into a CFHashCode integer, shifting each successive
	//	character by one bit so the bits of each character get scattered
	//	around the bits of the larger integer. Step through this with
	//	the debugger to see how even slightly different strings return
	//	dramatically different numbers.
	CFHashCode code = 0;
	unsigned int bitShift = 0;
	const char* c = value;
	while ( *c != '\0' ) {
		// Note: the char value (*c) must be converted, via a typecast,
		//		 to and CFHashCode sized integer *before* it gets bit
		//		 shifted using the << operator. Without the explicit
		//		 type conversion, the << operator would happily shift
		//		 the bits of the char right into outerspace, since
		//		 a char can only hold 8 bits. By converting it first,
		//		 the bits of the char now occupy the lower bits of
		//		 a much larger integer, and have someplace to go
		//		 when shifted.
		code += ( ((CFHashCode)*c) << bitShift );
		
		// Increment bitShift so the next char gets shifted one more
		//	bit to the left. When bitShift gets so large that it
		//	would shift the char's bit off of the end of the CFHashCode
		//	integer, retart it at 0 again.
		if ( ++bitShift >= (sizeof(CFHashCode)-sizeof(char)) * 8 )
			bitShift = 0;
		
		// Advance to the next char in the string
		c++;
	}
#else
	// Alternative implementation:
	// This version, which you can compile and test by changing the
	//	#if 1 statement into an #if 0 statement, uses the Core
	//	Foundation library to calculate a hash value for us.
	// It's not as efficient--because it creates and destroys
	//	a CFString object every time it wants to calculate a hash
	//	code--but it's a lot less work.
	CFHashCode code;
	CFStringRef string;
	// Create a string object from our C string.
	string = CFStringCreateWithCString( NULL, value, kCFStringEncodingASCII );
	// Ask the string object for its hash code
	code = CFHash( string );
	// When you create or copy a Core Foundation object, you're responsible
	//	for destroying it again (much like alloc() and free()).
	CFRelease( string );
#endif
	
	return code;
}
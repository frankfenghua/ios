//
//  FlickrFetcher.h
//
//  Created for Stanford CS193p Fall 2013.
//  Copyright 2013 Stanford University. All rights reserved.
//

#import <Foundation/Foundation.h>

// key paths to photos or places at top-level of Flickr results
#define FLICKR_RESULTS_PHOTOS @"photos.photo"
#define FLICKR_RESULTS_PLACES @"places.place"

// keys (paths) to values in a photo dictionary
#define FLICKR_PHOTO_TITLE @"title"
#define FLICKR_PHOTO_DESCRIPTION @"description._content"
#define FLICKR_PHOTO_ID @"id"
#define FLICKR_PHOTO_OWNER @"ownername"
#define FLICKR_PHOTO_UPLOAD_DATE @"dateupload" // in seconds since 1970
#define FLICKR_PHOTO_PLACE_ID @"place_id"

// keys (paths) to values in a places dictionary (from TopPlaces)
#define FLICKR_PLACE_NAME @"_content"
#define FLICKR_PLACE_ID @"place_id"

// keys applicable to all types of Flickr dictionaries
#define FLICKR_LATITUDE @"latitude"
#define FLICKR_LONGITUDE @"longitude"
#define FLICKR_TAGS @"tags"

typedef enum {
	FlickrPhotoFormatSquare = 1,    // thumbnail
	FlickrPhotoFormatLarge = 2,     // normal size
	FlickrPhotoFormatOriginal = 64  // high resolution
} FlickrPhotoFormat;

@interface FlickrFetcher : NSObject

+ (NSURL *)URLforTopPlaces;

+ (NSURL *)URLforPhotosInPlace:(id)flickrPlaceId maxResults:(int)maxResults;

+ (NSURL *)URLforPhoto:(NSDictionary *)photo format:(FlickrPhotoFormat)format;

+ (NSURL *)URLforRecentGeoreferencedPhotos;

+ (NSURL *)URLforInformationAboutPlace:(id)flickrPlaceId;

+ (NSString *)extractNameOfPlace:(id)placeId fromPlaceInformation:(NSDictionary *)place;
+ (NSString *)extractRegionNameFromPlaceInformation:(NSDictionary *)placeInformation;

@end

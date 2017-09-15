//
//  Picport.h
//  PicportLauncher
//
//  Created by itok on 11/04/25.
//  Copyright 2011 itok. All rights reserved.
//

#import <Foundation/Foundation.h>

// utility macro for create option dictionary
#define PPPicportOptions(__appName__, __backURL__, __hashTag__) [Picport optionsWithAppName:(__appName__) backURL:(__backURL__) hashTag:(__hashTag__)]

// URL scheme for Picport
static NSString* const PPPicportScheme = @"jp.itok.picport";

// sender application name
static NSString* const PPPicportParamAppName = @"appName";
// sender application callback url
static NSString* const PPPicportParamBackURL = @"backURL";
// hashtag
static NSString* const PPPicportParamHashTag = @"hashtag";

// AppStore URL
static NSString* const PPPicportAppStore = @"http://itunes.apple.com/app/id828760205";

@interface Picport : NSObject {
    
}

/**
 * check Picport is available
 */
+(BOOL) isPicportAvailable;

/**
 * use pasteboard as data
 * - data:    image data
 * - uti:     data UTI (public.jpeg, public.png, etc.) <- see sample code
 * - options: key-val options
 *      - PPPicportParamAppName : sender application name
 *      - PPPicportParamBackURL : sender application callback url
 *      - PPPicportParamHashTag : hashtag
 */
+(BOOL) openPicportWithData:(NSData*)data UTI:(NSString*)uti options:(NSDictionary*)options;

/**
 * use pasteboard as image
 * - image:   image
 * # discard your photo's information such as exif
 * # Picport use image as JPEG
 * - options: key-val options
 *      - PPPicportParamAppName : sender application name
 *      - PPPicportParamBackURL : sender application callback url
 *      - PPPicportParamHashTag : hashtag
 */
+(BOOL) openPicportWithImage:(UIImage*)image options:(NSDictionary*)options;

/**
 * use assets library
 * - urls:    assets urls (assets-library://xxx)
 * - options: key-val options
 *      - PPPicportParamAppName : sender application name
 *      - PPPicportParamBackURL : sender application callback url
 *      - PPPicportParamHashTag : hashtag
 */
+(BOOL) openPicportWithAssetURLs:(NSArray*)urls options:(NSDictionary*)options;

/**
 * use photos
 * - identifiers:   assets local identifiers
 * - options:       key-val options
 *      - PPPicportParamAppName : sender application name
 *      - PPPicportParamBackURL : sender application callback url
 *      - PPPicportParamHashTag : hashtag
 */
+(BOOL) openPicportWithAssetIdentifiers:(NSArray*)identifiers options:(NSDictionary*)options;

/**
 * use latest photo
 */
+(BOOL) openPicportWithLatestPhoto;

/**
 * open AppStore
 */
+(BOOL) openAppStore;

/**
 * utility method for create option dictionary
 */
+(NSDictionary*) optionsWithAppName:(NSString*)appName backURL:(NSString*)backURL hashTag:(NSString*)hashTag;

@end

/*
 * internal use
 */
// pasteboard data type (uti)
static NSString* const PPPicportParamPasteboardType = @"type";
// assets urls (comma separated)
static NSString* const PPPicportParamAssets = @"assets";
// assets local identifiers (comma separated)
static NSString* const PPPicportParamIdentifiers = @"identifiers";

// use latest photo
static NSString* const PPPicportAssetsLatest = @"latest";

// use assets library
static NSString* const PPPicportHostAssets = @"assets";
// use pasteboard as data
static NSString* const PPPicportHostData = @"data";
// use pasteboard as image
static NSString* const PPPicportHostImage = @"image";

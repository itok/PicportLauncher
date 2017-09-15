//
//  Picport.m
//  PicportLauncher
//
//  Created by itok on 11/04/25.
//  Copyright 2011 itok. All rights reserved.
//

#import "Picport.h"

@implementation Picport

static NSString* __urlEncode(NSString* str) 
{
    return [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet alphanumericCharacterSet]];
}

+(NSDictionary*) optionsWithAppName:(NSString*)appName backURL:(NSString*)backURL hashTag:(NSString*)hashTag
{
    NSMutableDictionary* opts = [NSMutableDictionary dictionary];
    if (appName) {
        opts[PPPicportParamAppName] = appName;
    }
    if (backURL) {
        opts[PPPicportParamBackURL] = backURL;
    }
    if (hashTag) {
        opts[PPPicportParamHashTag] = hashTag;
    }
    
    return opts;
}


+(BOOL) isPicportAvailable
{
	NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@:", PPPicportScheme]];
    return [[UIApplication sharedApplication] canOpenURL:url];
}

+(BOOL) openPicportWithBase:(NSString*)base options:(NSDictionary*)options
{
    if (!(base && [base length] > 0)) {
        return NO;
    }
    
    NSMutableString* str = [NSMutableString stringWithString:base];
    for (NSString* key in [options allKeys]) {
        NSString* val = [options objectForKey:key];
        if ([val length] > 0) {
            [str appendFormat:@"&%@=%@", key, __urlEncode(val)];            
        }
    }
    
    NSURL* url = [NSURL URLWithString:str];
    if (url) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        return YES;
    }
    return NO;
}

+(BOOL) openPicportWithData:(NSData*)data UTI:(NSString*)uti options:(NSDictionary*)options
{
    if (![self isPicportAvailable]) {
        return NO;
    }
    
    if (!(data && uti && [uti length] > 0)) {
        return NO;
    }
    
    [[UIPasteboard generalPasteboard] setData:data forPasteboardType:uti];
    NSString* base = [NSString stringWithFormat:@"%@://%@/?%@=%@", PPPicportScheme, PPPicportHostData, PPPicportParamPasteboardType, uti];
    return [self openPicportWithBase:base options:options];
}

+(BOOL) openPicportWithImage:(UIImage *)image options:(NSDictionary *)options
{
    if (![self isPicportAvailable]) {
        return NO;
    }
    if (!image) {
        return NO;
    }
    [[UIPasteboard generalPasteboard] setImage:image];
    NSString* base = [NSString stringWithFormat:@"%@://%@", PPPicportScheme, PPPicportHostImage];
    return [self openPicportWithBase:base options:options];    
}

+(BOOL) openPicportWithAssetURLs:(NSArray *)urls options:(NSDictionary *)options
{
    if (![self isPicportAvailable]) {
        return NO;
    }
    
    if (!(urls && [urls count] > 0)) {
        return NO;
    }
    
    NSMutableArray* arr = [NSMutableArray array];
    for (NSURL* url in urls) {
        [arr addObject:__urlEncode([url absoluteString])];
    }
    NSString* base = [NSString stringWithFormat:@"%@://%@/?%@=%@", PPPicportScheme, PPPicportHostAssets, PPPicportParamAssets, [arr componentsJoinedByString:@","]];
    return [self openPicportWithBase:base options:options];
}

+(BOOL) openPicportWithAssetIdentifiers:(NSArray*)identifiers options:(NSDictionary*)options
{
    if (![self isPicportAvailable]) {
        return NO;
    }
    
    if (!(identifiers && [identifiers count] > 0)) {
        return NO;
    }
    
    NSMutableArray* arr = [NSMutableArray array];
    for (NSString* identifier in identifiers) {
        [arr addObject:__urlEncode(identifier)];
    }
    NSString* base = [NSString stringWithFormat:@"%@://%@/?%@=%@", PPPicportScheme, PPPicportHostAssets, PPPicportParamIdentifiers, [arr componentsJoinedByString:@","]];
    return [self openPicportWithBase:base options:options];
}

+(BOOL) openPicportWithLatestPhoto
{
    NSString* base = [NSString stringWithFormat:@"%@://%@", PPPicportScheme, PPPicportAssetsLatest];
    return [self openPicportWithBase:base options:nil];
}

+(BOOL) openAppStore
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:PPPicportAppStore] options:@{} completionHandler:nil];
    return YES;
}

@end

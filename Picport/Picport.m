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
    CFStringRef encoded = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)str, nil, CFSTR(":/?=,!$&'()*+;[]@#"), kCFStringEncodingUTF8);
    return (__bridge_transfer NSString*)encoded;
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
        return [[UIApplication sharedApplication] openURL:url];
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

+(BOOL) openPicportWithLatestPhoto
{
    NSString* base = [NSString stringWithFormat:@"%@://%@", PPPicportScheme, PPPicportAssetsLatest];
    return [self openPicportWithBase:base options:nil];
}

+(BOOL) openAppStore
{
    return [[UIApplication sharedApplication] openURL:[NSURL URLWithString:PPPicportAppStore]];
}

@end

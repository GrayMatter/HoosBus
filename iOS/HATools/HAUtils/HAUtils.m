//
//  HAUtils.m
//
//  Created by Yaogang Lian on 8/15/10.
//  Copyright 2010 HappenApps, Inc. All rights reserved.
//

#import "HAUtils.h"
#import <QuartzCore/QuartzCore.h>
#include <sys/sysctl.h>

@implementation HAUtils

+ (NSString *)appVersion
{
	return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}

+ (NSString *)appName
{
	return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
}

+ (NSString *)getUUID
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef s = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    return (__bridge NSString *)s;
}

+ (NSString *)getSysInfoByName:(char *)typeSpecifier
{
	size_t size;
    sysctlbyname(typeSpecifier, NULL, &size, NULL, 0);
    char *answer = malloc(size);
	sysctlbyname(typeSpecifier, answer, &size, NULL, 0);
	NSString *results = @(answer);
	free(answer);
	return results;
}

+ (NSString *)deviceType
{
	return [HAUtils getSysInfoByName:"hw.machine"];
}

+ (NSString *)diagnosticInfo
{
	NSMutableString *s = [NSMutableString string];
	[s appendFormat:@"App: %@\n", [HAUtils appName]];
	[s appendFormat:@"Version: %@\n", [HAUtils appVersion]];
	[s appendFormat:@"System: %@ %@\n", [[UIDevice currentDevice] systemName], [[UIDevice currentDevice] systemVersion]];
	[s appendFormat:@"Device: %@ (%@)", [[UIDevice currentDevice] model], [HAUtils deviceType]];
	return s;
}

+ (BOOL)OSVersionGreaterOrEqualTo:(NSString*)reqSysVer
{
	NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
	return ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending);
}

+ (void)showDialog:(NSString *)s
{
	[self performSelectorOnMainThread:@selector(showDialogOnMainThread:) withObject:s waitUntilDone:NO];
}

+ (void)showDialogOnMainThread:(NSString *)s
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info"
													message:s 
												   delegate:nil
										  cancelButtonTitle:@"Ok"
										  otherButtonTitles: nil];
	[alert show];
}

+ (void)showErrorDialog:(NSString *)s
{
	[self performSelectorOnMainThread:@selector(showErrorDialogOnMainThread:) withObject:s waitUntilDone:NO];
}

+ (void)showErrorDialogOnMainThread:(NSString *)s
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
													message:s 
												   delegate:nil
										  cancelButtonTitle:@"Ok"
										  otherButtonTitles: nil];
	[alert show];
}

+ (NSString *)formattedStringForDistance:(double)distance
{
#ifdef METRIC_UNIT
	if (distance < 500) {
		return [NSString stringWithFormat:@"%0.0f m", distance];
	} else {
		return [NSString stringWithFormat:@"%0.1f km", distance/1000];
	}
#endif
	
#ifdef ENGLISH_UNIT
	return [NSString stringWithFormat:@"%0.1f mi", distance / 1609.344];
#endif
    return nil;
}

+ (NSString *)removeNonNumericChars:(NSString *)s
{
    NSMutableString * output = [[NSMutableString alloc] init];
	NSCharacterSet * set = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
	NSString *sLower = [s lowercaseString];
	
	for (NSUInteger i = 0; i < [sLower length]; i++) {
		unichar ch = [sLower characterAtIndex:i];
		if ([set characterIsMember:ch]) {
			[output appendFormat:@"%c", ch];
		}
	}
    return output;
}

+ (NSString *)urlEncodeValue:(NSString *)str
{
    NSString *result = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)str, NULL, CFSTR(":/?#[]@!$&’()*+,;="), kCFStringEncodingUTF8);
    return result;
}

+ (NSData *)buildPostBody:(NSDictionary *)params
{
    NSMutableString * postBody = [NSMutableString string];
    int i = 0;
    int count = [params count] - 1;
    for (NSString * key in [params keyEnumerator]) {
        NSString * s = [NSString stringWithFormat:@"%@=%@%@", [HAUtils urlEncodeValue:key], [HAUtils urlEncodeValue:[params objectForKey:key]], (i<count ? @"&": @"")];
        [postBody appendString:s];
        i++;
    }
    return [postBody dataUsingEncoding:NSUTF8StringEncoding];
}

@end

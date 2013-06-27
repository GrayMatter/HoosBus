//
//  HAUtils.h
//
//  Created by Yaogang Lian on 8/15/10.
//  Copyright 2010 HappenApps, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HAUtils : NSObject

+ (NSString *)appVersion;
+ (NSString *)appName;
+ (NSString *)getUUID;
+ (NSString *)getSysInfoByName:(char *)typeSpecifier;
+ (NSString *)deviceType;
+ (NSString *)diagnosticInfo;
+ (BOOL)OSVersionGreaterOrEqualTo:(NSString*)reqSysVer;
+ (void)showDialog:(NSString *)s;
+ (void)showErrorDialog:(NSString *)s;
+ (NSString *)formattedStringForDistance:(double)distance;

+ (NSString *)removeNonNumericChars:(NSString *)s;

// URL related
+ (NSString *)urlEncodeValue:(NSString *)str;
+ (NSData *)buildPostBody:(NSDictionary *)params;

@end

//
//  NSDictionary+HAUtils.m
//  Showtime
//
//  Created by Yaogang Lian on 1/24/13.
//  Copyright (c) 2013 HappenApps, Inc. All rights reserved.
//

#import "NSDictionary+HAUtils.h"

@implementation NSDictionary (HAUtils)

- (NSDictionary *)mergeWithDict:(NSDictionary *)aDict
{
    NSMutableDictionary * copy = [self mutableCopy];
    for (NSString * key in aDict) {
        [copy setObject:[aDict objectForKey:key] forKey:key];
    }
    return [NSDictionary dictionaryWithDictionary:copy];
}

@end

//
//  HBTransit.m
//  HoosBus
//
//  Created by Yaogang Lian on 10/26/09.
//  Copyright 2009 Happen Next. All rights reserved.
//

#import "HBTransit.h"
#import "AppSettings+HoosBus.h"
#import "BTPredictionEntry.h"

@implementation HBTransit

- (NSArray *)filterStations:(NSArray *)ss 
{
	if ([AppSettings shouldDisplayCTSStops]) {
		return [[ss retain] autorelease];
	} else {
		NSMutableArray *res = [NSMutableArray array];
		for (BTStation *station in ss) {
			if (![station.owner isEqualToString:@"CTS"]) {
				[res addObject:station];
			}
		}
		return res;
	}
}

- (BOOL)checkStation:(BTStation *)s
{
	if ([AppSettings shouldDisplayCTSStops]) {
		return YES;
	} else {
		return (![s.owner isEqualToString:@"CTS"]);
	}
}

- (NSMutableArray *)filterPrediction:(NSMutableArray *)p
{
	if ([AppSettings shouldDisplayCTSRoutes]) {
		return [[p retain] autorelease];
	} else {
		NSMutableArray *res = [NSMutableArray array];
		for (BTPredictionEntry *entry in p) {
			BTRoute *route = [self routeWithId:entry.routeId];
			if (![route.owner isEqualToString:@"CTS"]) {
				[res addObject:entry];
			}
		}
		return res;
	}
}

- (NSDictionary *)filterRoutes:(NSDictionary *)rs
{
	if ([AppSettings shouldDisplayCTSRoutes]) {
		return [[rs retain] autorelease];
	} else {
		NSMutableDictionary *rsCopy = [rs mutableCopy];
		[rsCopy removeObjectForKey:@"CTS"];
		
		NSMutableArray *sectionNames = [[rsCopy objectForKey:@"SectionNames"] mutableCopy];
		[sectionNames removeObject:@"CTS"];
		
		[rsCopy setObject:sectionNames forKey:@"SectionNames"];
		[sectionNames release];
		
		return [rsCopy autorelease];
	}
}

@end

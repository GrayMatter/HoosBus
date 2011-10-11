//
//  HBTransit.m
//  HoosBus
//
//  Created by Yaogang Lian on 10/26/09.
//  Copyright 2009 Happen Next. All rights reserved.
//

#import "HBTransit.h"
#import "BTAppSettings+HoosBus.h"
#import "BTPredictionEntry.h"

@implementation HBTransit

- (NSArray *)filterStops:(NSArray *)ss 
{
	if ([BTAppSettings shouldDisplayCTSStops]) {
		return [[ss retain] autorelease];
	} else {
		NSMutableArray *res = [NSMutableArray array];
		for (BTStop *stop in ss) {
			if (stop.owner != CTS) {
				[res addObject:stop];
			}
		}
		return res;
	}
}

- (BOOL)checkStop:(BTStop *)s
{
	if ([BTAppSettings shouldDisplayCTSStops]) {
		return YES;
	} else {
		return (s.owner != CTS);
	}
}

- (NSMutableArray *)filterPrediction:(NSMutableArray *)p
{
	if ([BTAppSettings shouldDisplayCTSRoutes]) {
		return [[p retain] autorelease];
	} else {
		NSMutableArray *res = [NSMutableArray array];
		for (BTPredictionEntry *entry in p) {
			BTRoute *route = [self routeWithId:entry.routeId];
			if (route.owner != CTS) {
				[res addObject:entry];
			}
		}
		return res;
	}
}

- (NSDictionary *)filterRoutes:(NSDictionary *)rs
{
	if ([BTAppSettings shouldDisplayCTSRoutes]) {
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

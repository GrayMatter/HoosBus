//
//  HBTransit.m
//  HoosBus
//
//  Created by Yaogang Lian on 10/26/09.
//  Copyright 2009 Happen Next. All rights reserved.
//

#import "HBTransit.h"


@implementation HBTransit

@synthesize displayCTSStops, displayCTSRoutes;

- (id)init {
	if (self = [super init]) {
		// load CTS preferences
		NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
		
		id p;
		if (p = [prefs objectForKey:@"displayCTSStops"]) {
			self.displayCTSStops = [p boolValue];
		} else {
			self.displayCTSStops = YES;
		}
		
		if (p = [prefs objectForKey:@"displayCTSRoutes"]) {
			self.displayCTSRoutes = [p boolValue];
		} else {
			self.displayCTSRoutes = YES;
		}
	}
	return self;
}


@end

//
//  AppSettings+HoosBus.m
//  HoosBus
//
//  Created by Yaogang Lian on 2/8/11.
//  Copyright 2011 Happen Next. All rights reserved.
//

#import "AppSettings+HoosBus.h"


#define KEY_SHOULD_DISPLAY_CTS_STOPS @"displayCTSStops"
#define KEY_SHOULD_DISPLAY_CTS_ROUTES @"displayCTSRoutes"


@implementation AppSettings (HoosBus)

+ (BOOL)shouldDisplayCTSStops
{
	BOOL b = TRUE;
	id obj = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_SHOULD_DISPLAY_CTS_STOPS];
	if (obj != nil) {
		b = [obj boolValue];
	}
	return b;
}

+ (void)setShouldDisplayCTSStops:(BOOL)b
{
	[[NSUserDefaults standardUserDefaults] setBool:b forKey:KEY_SHOULD_DISPLAY_CTS_STOPS];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)shouldDisplayCTSRoutes
{
	BOOL b = TRUE;
	id obj = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_SHOULD_DISPLAY_CTS_ROUTES];
	if (obj != nil) {
		b = [obj boolValue];
	}
	return b;
}

+ (void)setShouldDisplayCTSRoutes:(BOOL)b
{
	[[NSUserDefaults standardUserDefaults] setBool:b forKey:KEY_SHOULD_DISPLAY_CTS_ROUTES];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

@end

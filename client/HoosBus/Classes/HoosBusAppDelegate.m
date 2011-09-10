//
//  HoosBusAppDelegate.m
//  HoosBus
//
//  Created by Yaogang Lian on 2/7/11.
//  Copyright 2011 Happen Next. All rights reserved.
//

#import "HoosBusAppDelegate.h"
#import "Appirater.h"
#import "FlurryAPI.h"
#import "VideoAdViewController.h"
#import "HASettings.h"
#import "Utility.h"

@implementation HoosBusAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [super application:application didFinishLaunchingWithOptions:launchOptions];
    [Appirater appLaunched];
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Load app settings
	[HASettings loadAppSettings];
    
    [super applicationDidBecomeActive:application];
    
    [self performSelectorInBackground:@selector(updateAppSettings) withObject:nil];
	[self performSelectorInBackground:@selector(updateExpiryDate) withObject:nil];
	
	NSDate *playDate = [HASettings videoAdPlayDate];
	if (playDate == nil) {
		[self performSelectorInBackground:@selector(downloadVideoAd) withObject:nil];
	} else if ([playDate timeIntervalSinceNow] < 0 && [HASettings playCountForVideoAd] == 0) {
		[self playVideoAd];
	}
}


#pragma mark -
#pragma mark App Settings

- (void)updateAppSettings
{
	@synchronized(self) {
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		
		// Don't update app settings more than once a day
		if ([[NSDate date] timeIntervalSinceDate:[HASettings lastTimeAppSettingsUpdated]] < [HASettings updateAppSettingsInterval])
			goto done_update_app_settings;
		
		NSURL *settingsURL;
		if ([Utility OSVersionGreaterOrEqualTo:@"4.0"]) {
			settingsURL = [NSURL URLWithString:APP_SETTINGS_XML];
		} else {
			settingsURL = [NSURL URLWithString:APP_SETTINGS_OS3_XML];
		}
		
		NSDictionary *settingsDict = [NSDictionary dictionaryWithContentsOfURL:settingsURL];
		if (settingsDict == nil)
			goto done_update_app_settings;
		
		[HASettings setAppSettings:settingsDict];
		[HASettings setLastTimeAppSettingsUpdated:[NSDate date]];
        
	done_update_app_settings:
		[pool release];
	}
}

- (void)updateExpiryDate
{
	@synchronized(self) {
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		
		// Don't update expiry date too often
		if ([[NSDate date] timeIntervalSinceDate:[HASettings lastTimeExpiryDateUpdated]] < [HASettings updateExpiryDateInterval])
			goto done_get_expiry_date;
		
		NSDateFormatter *df = [[NSDateFormatter alloc] init];
		[df setDateFormat:@"MMMM dd, yyyy"];
		
		NSString *s = [NSString stringWithFormat:@"%@/expiry_date?udid=%@", API_BASE_URL, [Utility deviceId]];
		NSError *error = nil;
		NSString *dateString = [NSString stringWithContentsOfURL:[NSURL URLWithString:s] encoding:NSUTF8StringEncoding error:&error];
		
		if (dateString != nil && [dateString length] > 0) {
			NSDate *expiryDate = [df dateFromString:dateString];
			[HASettings setExpiryDate:expiryDate];
		}
		
		[df release];
        
	done_get_expiry_date:
		[pool release];
	}
}

- (void)downloadVideoAd
{
	@synchronized(self) {
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		
		NSDictionary *dict = [HASettings videoAdDict];
		if (dict == nil)
			goto done_download_video_ad;
		
		// download the video file
		NSString *s = [dict objectForKey:@"video_url"];
		NSData *videoData = [NSData dataWithContentsOfURL:[NSURL URLWithString:s]];
		[videoData writeToFile:[HASettings videoAdFilePath] atomically:YES];
		
		// download the background image file
		s = [dict objectForKey:@"bg_url"];
		NSData *bgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:s]];
		[bgData writeToFile:[HASettings videoAdBgFilePath] atomically:YES];
		
		[HASettings setVideoAdPlayDate];
		
	done_download_video_ad:
		[pool release];
	}
}

- (void)playVideoAd
{
	[HASettings setPlayCountForVideoAd:1];
	VideoAdViewController *controller = [[VideoAdViewController alloc] init];
	[tabBarController presentModalViewController:controller animated:YES];
	[controller release];
	
	[FlurryAPI logEvent:@"playVideoAd"];
}


@end
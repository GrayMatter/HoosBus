//
//  HoosBusAppDelegate.m
//  HoosBus
//
//  Created by Yaogang Lian on 2/7/11.
//  Copyright 2011 Happen Next. All rights reserved.
//

#import "HoosBusAppDelegate.h"
#import "Appirater.h"


@implementation HoosBusAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [super application:application didFinishLaunchingWithOptions:launchOptions];
    
    // Set up Appirater
    [Appirater appLaunched];
    
    return YES;
}

@end
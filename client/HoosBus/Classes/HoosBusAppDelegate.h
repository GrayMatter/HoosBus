//
//  HoosBusAppDelegate.h
//  HoosBus
//
//  Created by Yaogang Lian on 2/7/11.
//  Copyright 2011 Happen Next. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTTransitDelegate.h"

@interface HoosBusAppDelegate : BTTransitDelegate


// App settings
- (void)updateAppSettings;
- (void)updateExpiryDate;
- (void)downloadVideoAd;
- (void)playVideoAd;

@end


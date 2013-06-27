//
//  HALocationManager.h
//  BusSG
//
//  Created by Yaogang Lian on 8/5/12.
//  Copyright (c) 2012 HappenApps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface HALocationManager : NSObject <CLLocationManagerDelegate>
{
	CLLocationManager * locationManager;
	BOOL isUpdatingLocation;
	BOOL locationFound;
	CLLocation *currentLocation;
}

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, assign) BOOL isUpdatingLocation;
@property (nonatomic, assign) BOOL locationFound;
@property (nonatomic, strong) CLLocation *currentLocation;

+ (HALocationManager *)defaultManager;

// Location
- (void)startUpdatingLocation;

@end

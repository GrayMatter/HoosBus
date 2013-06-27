//
//  HALocationManager.m
//  BusSG
//
//  Created by Yaogang Lian on 8/5/12.
//  Copyright (c) 2012 HappenApps. All rights reserved.
//

#import "HALocationManager.h"

#ifdef FLURRY_KEY
#import "Flurry.h"
#endif

@implementation HALocationManager

@synthesize locationManager, isUpdatingLocation, locationFound, currentLocation;


static HALocationManager * _defaultManager = nil;
+ (HALocationManager *)defaultManager
{
	if (_defaultManager == nil) {
		_defaultManager = [[HALocationManager alloc] init];
	}
	return _defaultManager;
}


#pragma mark - Object life cycle

- (id)init
{
    self = [super init];
	if (self) {
		locationManager = [[CLLocationManager alloc] init];
		[locationManager setDelegate:self]; // send location update to self
		[locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
		isUpdatingLocation = NO;
		locationFound = NO;
		currentLocation = nil;
	}
	return self;
}

- (void)dealloc
{
	locationManager.delegate = nil;
}

- (CLLocation *)currentLocation
{
	if (currentLocation == nil) {
		currentLocation = [[CLLocation alloc] initWithLatitude:CENTER_LATITUDE longitude:CENTER_LONGITUDE];
	}
	return currentLocation;
}


#pragma mark - Location management

- (void)startUpdatingLocation
{
	if (isUpdatingLocation) return;
	
	isUpdatingLocation = YES;
  	[locationManager startUpdatingLocation];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:kStartUpdatingLocationNotification
														object:self
													  userInfo:nil];
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
	[locationManager stopUpdatingLocation];
	isUpdatingLocation = NO;
	locationFound = YES;
	
	// If the user's location didn't change much, don't bother sending out notifications
	if (fabs([newLocation distanceFromLocation:self.currentLocation]) < 100) {
		[[NSNotificationCenter defaultCenter] postNotificationName:kLocationDidNotChangeNotification
															object:self
														  userInfo:nil];
	} else {
#ifdef PRODUCTION_READY
		self.currentLocation = newLocation;
#endif
        
#ifdef FLURRY_KEY
        [Flurry setLatitude:newLocation.coordinate.latitude
                           longitude:newLocation.coordinate.longitude
                  horizontalAccuracy:newLocation.horizontalAccuracy
                    verticalAccuracy:newLocation.verticalAccuracy];
#endif
		
        NSDictionary * userInfo = @{@"location": self.currentLocation};
		[[NSNotificationCenter defaultCenter] postNotificationName:kDidUpdateToLocationNotification
															object:self
														  userInfo:userInfo];
	}
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
	[manager stopUpdatingLocation];
	isUpdatingLocation = NO;
	locationFound = NO;
	
	[[NSNotificationCenter defaultCenter] postNotificationName:kDidFailToUpdateLocationNotification
														object:self
													  userInfo:nil];
	
	// NSLog(@"location manager failed");
	/*
     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
     message:@"Your location could not be determined."
     delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
     [alert show];
     [alert release];
	 */
}

@end

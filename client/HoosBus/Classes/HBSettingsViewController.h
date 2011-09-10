//
//  HBSettingsViewController.h
//  HoosBus
//
//  Created by Yaogang Lian on 10/17/09.
//  Copyright 2009 Happen Next. All rights reserved.
//


#import "HAAboutViewController.h"
#import "BTTransit.h"
#import "HAListViewController.h"


@interface HBSettingsViewController : HAAboutViewController
<HAListViewControllerDelegate>
{
    BTTransit *transit;
}

@property (nonatomic, retain) NSArray *startupScreenOptions;
@property (nonatomic, retain) NSArray *nearbyRadiusOptions;
@property (nonatomic, retain) NSArray *maxNumNearbyStopsOptions;
@property (nonatomic, retain) UISwitch *switchCtl1;
@property (nonatomic, retain) UISwitch *switchCtl2;

// Lists
- (void)setSelectedIndex:(NSUInteger)index forListName:(NSString *)name;

@end

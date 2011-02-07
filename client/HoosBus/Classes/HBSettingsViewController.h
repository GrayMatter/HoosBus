//
//  HBSettingsViewController.h
//  HoosBus
//
//  Created by Yaogang Lian on 10/17/09.
//  Copyright 2009 Happen Next. All rights reserved.
//


#import "BTSettingsViewController.h"

@interface HBSettingsViewController : BTSettingsViewController {
	UISwitch *switchCtl1;
	UISwitch *switchCtl2;
}

@property (nonatomic, retain) UISwitch *switchCtl1;
@property (nonatomic, retain) UISwitch *switchCtl2;

@end

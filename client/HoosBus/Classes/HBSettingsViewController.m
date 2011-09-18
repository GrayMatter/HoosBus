//
//  HBSettingsViewController.m
//  HoosBus
//
//  Created by Yaogang Lian on 10/17/09.
//  Copyright 2009 Happen Next. All rights reserved.
//

#import "HBSettingsViewController.h"
#import "BTAppSettings+HoosBus.h"
#import "BTTransitDelegate.h"

#define kSwitchButtonWidth		94.0
#define kSwitchButtonHeight		27.0


@implementation HBSettingsViewController

@synthesize switchCtl1, switchCtl2;

- (void)createControls
{
	CGRect frame = CGRectMake(0.0, 0.0, kSwitchButtonWidth, kSwitchButtonHeight);
	switchCtl1 = [[UISwitch alloc] initWithFrame:frame];
	[switchCtl1 addTarget:self action:@selector(switchAction1:) forControlEvents:UIControlEventValueChanged];
	
	// in case the parent view draws with a custom color or gradient, use a transparent color
	switchCtl1.backgroundColor = [UIColor clearColor];
	switchCtl1.on = [BTAppSettings shouldDisplayCTSStops];
	
	switchCtl2 = [[UISwitch alloc] initWithFrame:frame];
	[switchCtl2 addTarget:self action:@selector(switchAction2:) forControlEvents:UIControlEventValueChanged];
	switchCtl2.backgroundColor = [UIColor clearColor];
	switchCtl2.on = [BTAppSettings shouldDisplayCTSRoutes];
}

- (void)switchAction1:(id)sender
{
	[BTAppSettings setShouldDisplayCTSStops:[sender isOn]];
}

- (void)switchAction2:(id)sender
{
	[BTAppSettings setShouldDisplayCTSRoutes:[sender isOn]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self createControls];
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc
{
	[switchCtl1 release];
	[switchCtl2 release];
    [super dealloc];
}


#pragma mark -
#pragma mark Table view methods

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section 
{
	int numberOfRows;
    if (section == 0) {
		numberOfRows = 5;
	} else {
		numberOfRows = [super tableView:tv numberOfRowsInSection:section];
	}
	
	return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	if (indexPath.section == 0 && 
        (indexPath.row == 3 || indexPath.row == 4))
	{
        static NSString *HBSettingsCellIdentifier = @"HBSettingsCell";
        
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HBSettingsCellIdentifier];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:HBSettingsCellIdentifier] autorelease];
		}
        
        for (UIView *v in cell.contentView.subviews) {
			[v removeFromSuperview];
		}
		
		switch (indexPath.row) {
            case 3:
				cell.textLabel.text = @"Show CAT Stops";
				cell.textLabel.backgroundColor = [UIColor clearColor];
				switchCtl1.frame = CGRectMake(196, 8, kSwitchButtonWidth, kSwitchButtonHeight);
				[cell.contentView addSubview:switchCtl1];
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
				break;
			case 4:
				cell.textLabel.text = @"Show CAT Routes";
				cell.textLabel.backgroundColor = [UIColor clearColor];
				switchCtl2.frame = CGRectMake(196, 8, kSwitchButtonWidth, kSwitchButtonHeight);
				[cell.contentView addSubview:switchCtl2];
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
				break;
			default:
				break;
		}
        return cell;
	} else {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
}

@end

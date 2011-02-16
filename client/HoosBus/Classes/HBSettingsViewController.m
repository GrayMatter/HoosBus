//
//  HBSettingsViewController.m
//  HoosBus
//
//  Created by Yaogang Lian on 10/17/09.
//  Copyright 2009 Happen Next. All rights reserved.
//

#import "HBSettingsViewController.h"
#import "AppSettings+HoosBus.h"

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
	switchCtl1.on = [AppSettings shouldDisplayCTSStops];
	
	switchCtl2 = [[UISwitch alloc] initWithFrame:frame];
	[switchCtl2 addTarget:self action:@selector(switchAction2:) forControlEvents:UIControlEventValueChanged];
	switchCtl2.backgroundColor = [UIColor clearColor];
	switchCtl2.on = [AppSettings shouldDisplayCTSRoutes];
}

- (void)switchAction1:(id)sender
{
	[AppSettings setShouldDisplayCTSStops:[sender isOn]];
}

- (void)switchAction2:(id)sender
{
	[AppSettings setShouldDisplayCTSRoutes:[sender isOn]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self createControls];
}

- (void)didReceiveMemoryWarning
{
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
	[super viewDidUnload];
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

#pragma mark Table view methods

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section 
{
	int numberOfRows;
	int newSection = section + sectionOffset;
	if (newSection == 1) {
		numberOfRows = 5;
	} else {
		numberOfRows = [super tableView:tv numberOfRowsInSection:section];
	}
	
	return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	UITableViewCell *cell;
	int newSection = indexPath.section + sectionOffset;
	if (newSection == 1 && indexPath.row > 2) {
		static NSString *HBSettingsCellIdentifier = @"HBSettingsCellID";
		
		cell = [tableView dequeueReusableCellWithIdentifier:HBSettingsCellIdentifier];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:HBSettingsCellIdentifier] autorelease];
		}
		
		for (UIView *v in cell.contentView.subviews) {
			[v removeFromSuperview];
		}
		
		switch (indexPath.row) {
			case 3:
				cell.textLabel.text = @"Show CTS Stops";
				cell.textLabel.backgroundColor = [UIColor clearColor];
				switchCtl1.frame = CGRectMake(196, 8, kSwitchButtonWidth, kSwitchButtonHeight);
				[cell.contentView addSubview:switchCtl1];
				break;
			case 4:
				cell.textLabel.text = @"Show CTS Routes";
				cell.textLabel.backgroundColor = [UIColor clearColor];
				switchCtl2.frame = CGRectMake(196, 8, kSwitchButtonWidth, kSwitchButtonHeight);
				[cell.contentView addSubview:switchCtl2];
				break;
			default:
				break;
		}
		
		cell.accessoryType = UITableViewCellAccessoryNone;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	} else {
		cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
	}
	
	return cell;
}

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	int newSection = indexPath.section + sectionOffset;
	if (newSection == 1 && indexPath.row > 2) {
		// do nothing
	} else {
		[super tableView:tv didSelectRowAtIndexPath:indexPath];
	}
}

- (void)dealloc
{
	[switchCtl1 release];
	[switchCtl2 release];
    [super dealloc];
}


@end

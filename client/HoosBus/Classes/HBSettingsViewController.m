//
//  HBSettingsViewController.m
//  HoosBus
//
//  Created by Yaogang Lian on 10/17/09.
//  Copyright 2009 Happen Next. All rights reserved.
//

#import "HBSettingsViewController.h"
#import "HBTransit.h"

@implementation HBSettingsViewController

@synthesize switchCtl1, switchCtl2;

- (void)createControls
{
	CGRect frame = CGRectMake(0.0, 0.0, kSwitchButtonWidth, kSwitchButtonHeight);
	switchCtl1 = [[UISwitch alloc] initWithFrame:frame];
	[switchCtl1 addTarget:self action:@selector(switchAction1:) forControlEvents:UIControlEventValueChanged];
	
	HBTransit *t = (HBTransit *)self.transit;
	// in case the parent view draws with a custom color or gradient, use a transparent color
	switchCtl1.backgroundColor = [UIColor clearColor];
	switchCtl1.on = t.displayCTSStops;
	
	switchCtl2 = [[UISwitch alloc] initWithFrame:frame];
	[switchCtl2 addTarget:self action:@selector(switchAction2:) forControlEvents:UIControlEventValueChanged];
	switchCtl2.backgroundColor = [UIColor clearColor];
	switchCtl2.on = t.displayCTSRoutes;
}

- (void)switchAction1:(id)sender
{
	HBTransit *t = (HBTransit *)self.transit;
	t.displayCTSStops = [sender isOn];
}

- (void)switchAction2:(id)sender
{
	HBTransit *t = (HBTransit *)self.transit;
	t.displayCTSRoutes = [sender isOn];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	[self createControls];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

#pragma mark Table view methods

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section 
{
	int numberOfRows;
	if (section == 2) {
		numberOfRows = 5;
	} else {
		numberOfRows = [super tableView:tv numberOfRowsInSection:section];
	}
	
	return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	UITableViewCell *res;
	if (indexPath.section == 2 && indexPath.row > 2) {
		static NSString *CellIdentifier = @"BTSettingsCellID";
    
		BTSettingsCell *cell = (BTSettingsCell *)[tv dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[[BTSettingsCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
		}
		
		
		/*
		 CGRect contentRect = [self.contentView bounds];
		 frame = CGRectMake(contentRect.size.width - self.view.bounds.size.width - kCellLeftOffset,
		 round((contentRect.size.height - self.view.bounds.size.height) / 2.0),
		 self.view.bounds.size.width,
		 self.view.bounds.size.height);
		 */
		switch (indexPath.row) {
			case 3:
				cell.nameLabel.text = @"Show CTS Stops";
				cell.view = switchCtl1;
				cell.accessoryType = UITableViewCellAccessoryNone;
				break;
			case 4:
				cell.nameLabel.text = @"Show CTS Routes";
				cell.view = switchCtl2;
				cell.accessoryType = UITableViewCellAccessoryNone;
				break;
			default:
				break;
		}
		res = cell;
	} else {
		res = [super tableView:tv cellForRowAtIndexPath:indexPath];
	}
	return res;
}

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	if (indexPath.section == 2 && indexPath.row > 2) {
		// do nothing
	} else {
		[super tableView:tv didSelectRowAtIndexPath:indexPath];
	}
}

- (void)dealloc {
	[switchCtl1 release];
	[switchCtl2 release];
    [super dealloc];
}


@end

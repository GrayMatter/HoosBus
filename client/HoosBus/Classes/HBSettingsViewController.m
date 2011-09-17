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

@synthesize startupScreenOptions, nearbyRadiusOptions, maxNumNearbyStopsOptions;
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
    
    self.title = NSLocalizedString(@"Settings", @"");
    sectionOffset = 1;
	
	transit = [AppDelegate transit];
	
	self.startupScreenOptions = [NSArray arrayWithObjects:@"Nearby", @"Favorites", @"Map", @"Routes", @"Search", nil];
	self.maxNumNearbyStopsOptions = [NSArray arrayWithObjects:@"10", @"20", @"30", @"50", @"100", @"No Limit", nil];
#ifdef METRIC_UNIT
	self.nearbyRadiusOptions = [NSArray arrayWithObjects:@"0.2 km", @"0.5 km", @"1 km", @"2 km", @"5 km", @"No Limit", nil];
#else
	self.nearbyRadiusOptions = [NSArray arrayWithObjects:@"0.2 mi", @"0.5 mi", @"1 mi", @"2 mi", @"5 mi", @"No Limit", nil];
#endif
    
	[self createControls];
}


#pragma mark -
#pragma mark Memory management

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

- (void)dealloc
{
    [startupScreenOptions release], startupScreenOptions = nil;
	[nearbyRadiusOptions release], nearbyRadiusOptions = nil;
	[maxNumNearbyStopsOptions release], maxNumNearbyStopsOptions = nil;
    
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
	if (indexPath.section == 0)
	{
        static NSString *CellIdentifier1 = @"SettingsCell1";
        
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier1] autorelease];
		}
        
        for (UIView *v in cell.contentView.subviews) {
			[v removeFromSuperview];
		}
		
		switch (indexPath.row) {
			case 0:
				cell.textLabel.text = @"Startup Screen";
				cell.detailTextLabel.text = [BTAppSettings startupScreen];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
				cell.selectionStyle = UITableViewCellSelectionStyleBlue;
				break;
			case 1:
				cell.textLabel.text = @"Nearby Radius";
				cell.detailTextLabel.text = [BTAppSettings nearbyRadius];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
				cell.selectionStyle = UITableViewCellSelectionStyleBlue;
				break;
			case 2:
				cell.textLabel.text = @"Max No. of Nearby Stops";
				cell.detailTextLabel.text = [BTAppSettings maxNumNearbyStops];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
				cell.selectionStyle = UITableViewCellSelectionStyleBlue;
				break;
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{
    if (section == 0) {
        return @"Application Settings";
    } else {
        return [super tableView:tableView titleForHeaderInSection:section];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	if (indexPath.section == 0) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        HAListViewController *controller = [[HAListViewController alloc] init];
		switch (indexPath.row) {
			case 0:
				controller.list = self.startupScreenOptions;
				controller.selectedIndex = [self.startupScreenOptions indexOfObject:[BTAppSettings startupScreen]];
				controller.title = @"Startup Screen";
				controller.tag = TAG_LIST_STARTUP_SCREEN;
				break;
			case 1:
				controller.list = self.nearbyRadiusOptions;
				controller.selectedIndex = [self.nearbyRadiusOptions indexOfObject:[BTAppSettings nearbyRadius]];
				controller.title = @"Nearby Radius";
				controller.tag = TAG_LIST_NEARBY_RADIUS;
				break;
			case 2:
				controller.list = self.maxNumNearbyStopsOptions;
				controller.selectedIndex = [self.maxNumNearbyStopsOptions indexOfObject:[BTAppSettings maxNumNearbyStops]];
				controller.title = @"Max Number of Stops";
				controller.tag = TAG_LIST_MAX_NUM_NEARBY_STOPS;
				break;
			default:
				break;
		}
		controller.delegate = self;
		[self.navigationController pushViewController:controller animated:YES];
		[controller release];
	} else {
        [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}


#pragma mark -
#pragma mark ListViewControllerDelegate methods

- (void)setSelectedIndex:(NSUInteger)index inList:(NSInteger)tag
{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    switch (tag) {
        case TAG_LIST_STARTUP_SCREEN:
        {
            NSString *s = [self.startupScreenOptions objectAtIndex:index];
            [prefs setObject:s forKey:KEY_STARTUP_SCREEN];
        }
            break;
            
        case TAG_LIST_NEARBY_RADIUS:
        {
            NSString *s = [self.nearbyRadiusOptions objectAtIndex:index];
            [prefs setObject:s forKey:KEY_NEARBY_RADIUS];
        }
            break;
            
        case TAG_LIST_MAX_NUM_NEARBY_STOPS:
        {
            NSString *s = [self.maxNumNearbyStopsOptions objectAtIndex:index];
            [prefs setObject:s forKey:KEY_MAX_NUM_NEARBY_STOPS];
        }
            break;
            
        default:
            break;
    }
	[prefs synchronize];
}

@end

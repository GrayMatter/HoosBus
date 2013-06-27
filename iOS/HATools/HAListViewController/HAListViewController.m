//
//  HAListViewController.m
//  Showtime
//
//  Created by Yaogang Lian on 1/16/11.
//  Copyright 2011 HappenApps, Inc. All rights reserved.
//

#import "HAListViewController.h"


@implementation HAListViewController

@synthesize mainTableView, list, tag, selectedIndex, delegate;


#pragma mark - Initialization

- (id)init
{
    self = [super initWithNibName:@"HAListViewController" bundle:[NSBundle mainBundle]];
	if (self) {
		self.hidesBottomBarWhenPushed = YES;
	}
	return self;
}

- (id)initWithList:(NSArray *)l selectedIndex:(NSUInteger)index delegate:(id)d
{
    self = [super initWithNibName:@"HAListViewController" bundle:[NSBundle mainBundle]];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
		self.list = l;
		self.selectedIndex = index;
		self.delegate = d;
	}
	return self;
}



#pragma mark - View life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	mainTableView.backgroundColor = [UIColor clearColor];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Memory management

- (void)didReceiveMemoryWarning
{
	DDLogVerbose(@">>> %s <<<", __PRETTY_FUNCTION__);
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
	DDLogVerbose(@">>> %s <<<", __PRETTY_FUNCTION__);
    [super viewDidUnload];
	self.mainTableView = nil;
}

- (void)dealloc
{
	DDLogVerbose(@">>> %s <<<", __PRETTY_FUNCTION__);
	delegate = nil;
	
}


#pragma mark - Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ListCellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
	
	cell.textLabel.text = [self.list objectAtIndex:indexPath.row];
	
	if (selectedIndex == indexPath.row) {
		cell.textLabel.textColor = [UIColor colorWithRed:0.20 green:0.31 blue:0.52 alpha:1.0];
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	} else {
		cell.textLabel.textColor = [UIColor blackColor];
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
	
	cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	self.selectedIndex = indexPath.row;
	[delegate setSelectedIndex:indexPath.row inList:tag];
	
	[self.navigationController popViewControllerAnimated:YES];
}

@end

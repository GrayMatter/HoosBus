//
//  HAAboutViewController.m
//  HAToolsDemo
//
//  Created by Yaogang Lian on 9/9/11.
//  Copyright 2011 Happen Next. All rights reserved.
//

#import "HAAboutViewController.h"

@implementation HAAboutViewController

@synthesize mainTableView, sectionOffset;


- (id)init
{
	self = [super initWithNibName:@"HAAboutViewController" bundle:[NSBundle mainBundle]];
	if (self) {
	}
	return self;
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
}


#pragma mark - View life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.title = NSLocalizedString(@"Settings", @"");
    
    mainTableView.backgroundView = nil;
    mainTableView.backgroundColor = [UIColor clearColor];
    
    sectionOffset = 0;
}


#pragma mark - Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1 + sectionOffset;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

@end

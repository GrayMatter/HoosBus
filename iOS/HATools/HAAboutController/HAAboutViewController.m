//
//  HAAboutViewController.m
//  HAToolsDemo
//
//  Created by Yaogang Lian on 9/9/11.
//  Copyright 2011 Happen Next. All rights reserved.
//

#import "HAAboutViewController.h"
#import "HAUtils.h"
#import "HAFAQViewController.h"
#import "HAWebViewController.h"

#ifdef FLURRY_KEY
#import "Flurry.h"
#endif


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
	appArray = nil;
}


#pragma mark - View life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.title = NSLocalizedString(@"Settings", @"");
    
    mainTableView.backgroundView = nil;
    mainTableView.backgroundColor = [UIColor clearColor];
    
    sectionOffset = 0;
	appArray = nil;
    
    if (httpClient == nil) {
        httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://www.google.com"]];
        [httpClient setDefaultHeader:@"User-Agent" value:@"Mozilla/5.0"];
    }
    
    [httpClient getPath:APP_LIST_XML parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
		appArray = [NSPropertyListSerialization propertyListFromData:(NSData *)responseObject
                                                    mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                                              format:NULL
                                                    errorDescription:NULL];
        [self.mainTableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"request did fail with error: %@", error);
    }];
}


#pragma mark - Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 2 + sectionOffset;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	int numberOfRows;
	
	switch (section - sectionOffset) {
		case 0:
			numberOfRows = 3;
			break;
		case 1:
			if (appArray == nil) {
				numberOfRows = 0;
			} else {
				numberOfRows = [appArray count];
			}
			break;
		default:
			break;
	}
	
	return numberOfRows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	int newSection = indexPath.section - sectionOffset;
	if (newSection == 1)
		return 50;
	
	return 44;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{
	NSString *s = nil;
	switch (section - sectionOffset) {
		case 0:
			s = @"Support";
			break;
		case 1:
			if (appArray != nil) {
				s = @"Our Apps";
			}
			break;
		default:
			break;
	}
	return s;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	static NSString *CellIdentifier2 = @"SettingsCellSupport";
	static NSString *CellIdentifier3 = @"SettingsCellCrossPromotion";
	
	UITableViewCell *cell;
	int newSection = indexPath.section - sectionOffset;
	
    if (newSection == 0)
	{
		cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
		if (cell == nil) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2];
		}
		
		[cell.imageView setImage:nil];
		if (indexPath.row == 0) {
			cell.textLabel.text = @"FAQ";
		} else if (indexPath.row == 1) {
			cell.textLabel.text = @"HappenApps Blog";
		} else if (indexPath.row == 2) {
			cell.textLabel.text = @"Send us feedback";
		}
		
		cell.selectionStyle = UITableViewCellSelectionStyleBlue;
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	else if (newSection == 1)
	{
		cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier3];
		if (cell == nil) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier3];
		}
		
		NSDictionary * dict = appArray[indexPath.row];
        
        NSString * imageUrl = [dict[@"base_url"] stringByAppendingString:@"icon90.png"];
        [cell.imageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"app_icon_placeholder.png"]];
		
        [cell.textLabel setText:dict[@"app_name"]];
        cell.textLabel.highlightedTextColor = [UIColor whiteColor];
        [cell.textLabel setFont:[UIFont boldSystemFontOfSize:16]];
        
        [cell.detailTextLabel setText:dict[@"description"]];
        [cell.detailTextLabel setFont:[UIFont systemFontOfSize:11]];
        cell.detailTextLabel.textColor = [UIColor grayColor];
        cell.detailTextLabel.highlightedTextColor = [UIColor whiteColor];
		
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	int newSection = indexPath.section - sectionOffset;
	if (newSection == 0)
	{
		if (indexPath.row == 0) {
			[self showFAQ];
		} else if (indexPath.row == 1) {
			[self showBlog];
		} else if (indexPath.row == 2) {
			[self sendFeedback];
		}
	}
	else if (newSection == 1)
	{
		NSDictionary * appDict = appArray[indexPath.row];
        NSString * urlString = appDict[@"itunes_url"];
        NSURL * itunesURL = [NSURL URLWithString:urlString];
        [[UIApplication sharedApplication] openURL:itunesURL];

#ifdef FLURRY_KEY
		NSDictionary *flurryDict = @{@"appName": appDict[@"app_name"]};
		[Flurry logEvent:@"CLICKED_CROSS_PROMOTION" withParameters:flurryDict];
#endif
	}
}


#pragma mark - Mail

- (void)showFAQ
{
    HAFAQViewController *controller = [[HAFAQViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)showBlog
{
	HAWebViewController *controller = [[HAWebViewController alloc] initWithURL:[NSURL URLWithString:URL_BLOG]];
	controller.mode = MODE_PUSHED;
	[self.navigationController pushViewController:controller animated:YES];
}

- (void)sendFeedback
{
	if ([MFMailComposeViewController canSendMail]) {
		MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
		picker.mailComposeDelegate = self;
		
		[picker setToRecipients:@[@"support@happenapps.com"]];
		NSString *subject = [NSString stringWithFormat:@"Feedback for %@", [HAUtils appName]];
		[picker setSubject:subject];
		
		NSString *body = [NSString stringWithFormat:@"\n\n%@", [HAUtils diagnosticInfo]];
		[picker setMessageBody:body isHTML:FALSE];
		
		[self.navigationController presentModalViewController:picker animated:YES];
	} else {
		[self launchMailAppOnDevice];
	}
}

// Launches the Mail application on the device.
- (void)launchMailAppOnDevice
{
	NSString *email = [NSString stringWithFormat: @"mailto:%@", @""];
	email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}

// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController *)controller
		  didFinishWithResult:(MFMailComposeResult)result
						error:(NSError *)error 
{
	[self dismissModalViewControllerAnimated:YES];
}

@end

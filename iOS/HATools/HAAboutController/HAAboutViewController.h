//
//  HAAboutViewController.h
//  HAToolsDemo
//
//  Created by Yaogang Lian on 9/9/11.
//  Copyright 2011 Happen Next. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import <MessageUI/MessageUI.h>

@interface HAAboutViewController : UIViewController
<UITableViewDelegate, UITableViewDataSource,
MFMailComposeViewControllerDelegate> 
{
	NSArray * appArray;
    AFHTTPClient * httpClient;
}

@property (nonatomic, strong) IBOutlet UITableView * mainTableView;
@property (nonatomic, assign) NSInteger sectionOffset;

// Email
- (void)showFAQ;
- (void)showBlog;
- (void)sendFeedback;
- (void)launchMailAppOnDevice;

@end

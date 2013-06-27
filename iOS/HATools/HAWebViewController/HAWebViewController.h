//
//  HAWebViewController.h
//  Showtime
//
//  Created by Yaogang Lian on 3/20/11.
//  Copyright 2011 Happen Next. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HAWebViewController : UIViewController
<UIWebViewDelegate, UIActionSheetDelegate>
{
	NSURL *currentURL;
	
	NSInteger mode; // MODE_MODAL, MODE_PUSHED
	UIWebView *webView;
	UIToolbar* toolbar;
	UIActivityIndicatorView *activityIndicator;
	
	UIBarButtonItem *backButton;
	UIBarButtonItem *forwardButton;
	UIBarButtonItem *refreshButton;
	UIBarButtonItem *actionButton;
}

@property (nonatomic, strong) NSURL *currentURL;
@property (nonatomic, assign) NSInteger mode;
@property (nonatomic, strong) IBOutlet UIWebView *webView;
@property (nonatomic, strong) IBOutlet UIToolbar* toolbar;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *backButton;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *forwardButton;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *refreshButton;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *actionButton;

- (id)initWithURL:(NSURL*)url;
- (IBAction)actionPressed:(id)sender;
- (void)dismissWebView;

@end

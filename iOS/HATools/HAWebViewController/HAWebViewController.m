//
//  HAWebViewController.m
//  Showtime
//
//  Created by Yaogang Lian on 3/20/11.
//  Copyright 2011 Happen Next. All rights reserved.
//

#import "HAWebViewController.h"


@implementation HAWebViewController

@synthesize currentURL, mode;
@synthesize webView, toolbar, activityIndicator;
@synthesize backButton, forwardButton, refreshButton, actionButton;


- (id)initWithURL:(NSURL *)url
{
	if (self = [super init]) {
		self.hidesBottomBarWhenPushed = YES;
		self.mode = MODE_MODAL;
		self.currentURL = url;
	}
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.title = @"Loading...";
	
	if (mode == MODE_MODAL) {
		UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
																					target:self
																					action:@selector(dismissWebView)];
		self.navigationItem.rightBarButtonItem = doneButton;
	}
	
	[webView loadRequest:[NSURLRequest requestWithURL:currentURL]];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[webView stopLoading];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}


#pragma mark - Rotation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	return (toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


#pragma mark - Memory Management

- (void)didReceiveMemoryWarning
{
	DDLogVerbose(@">>> %s <<<", __PRETTY_FUNCTION__);
	
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
	DDLogVerbose(@">>> %s <<<", __PRETTY_FUNCTION__);
	
    [super viewDidUnload];
	
	self.webView = nil;
	self.toolbar = nil;
}

- (void)dealloc
{
	DDLogVerbose(@">>> %s <<<", __PRETTY_FUNCTION__);
}


#pragma mark - Actions

- (void)actionPressed:(id)sender
{
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
															 delegate:self
													cancelButtonTitle:@"Cancel"
											   destructiveButtonTitle:nil
													otherButtonTitles:@"Open with Safari", nil];
	
	[actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)as clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (as.cancelButtonIndex == buttonIndex) return;
	
	if (buttonIndex == 0) {
		[[UIApplication sharedApplication] openURL:self.currentURL];
	}
}

- (void)dismissWebView
{
	[self.navigationController dismissModalViewControllerAnimated:YES];
}


#pragma mark - UIWebView delegate

- (BOOL)webView:(UIWebView *)aWebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
	return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)aWebView
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	[activityIndicator startAnimating];
	
	// Disable toolbar button items
	self.actionButton.enabled = NO;
	self.refreshButton.enabled = NO;
}

- (void)webViewDidFinishLoad:(UIWebView *)aWebView
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[activityIndicator stopAnimating];
	
	// Enable toolbar button items
	self.actionButton.enabled = YES;
	self.refreshButton.enabled = YES;
	
	[backButton setEnabled:[webView canGoBack]]; // Enable or disable back
	[forwardButton setEnabled:[webView canGoForward]]; // Enable or disable forward
	
	// Set the title of the new page
	self.title = [aWebView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

- (void)webView:(UIWebView *)aWebView didFailLoadWithError:(NSError *)error
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	if (error != nil && ([error code] != NSURLErrorCancelled)) {
		UIAlertView *errorAlert = [[UIAlertView alloc]
								   initWithTitle:@"Error Loading Page"
								   message: [error localizedFailureReason]
								   delegate:nil
								   cancelButtonTitle:@"OK"
								   otherButtonTitles:nil];
        [errorAlert show];
	}
}

@end

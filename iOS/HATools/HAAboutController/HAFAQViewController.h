//
//  HAFAQViewController.h
//  Showtime
//
//  Created by yaogang@enflick on 5/26/11.
//  Copyright 2011 HappenApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface HAFAQViewController : UITableViewController <MBProgressHUDDelegate>
{
    NSArray *faqArray;
    MBProgressHUD *HUD;
}

@property (strong) NSArray *faqArray;

- (void)loadFAQ;
- (void)reloadTable;

@end

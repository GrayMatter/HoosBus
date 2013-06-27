//
//  HAAboutViewController.h
//  HAToolsDemo
//
//  Created by Yaogang Lian on 9/9/11.
//  Copyright 2011 HappenApps, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HAAboutViewController : UIViewController
<UITableViewDelegate, UITableViewDataSource> 

@property (nonatomic, strong) IBOutlet UITableView * mainTableView;
@property (nonatomic, assign) NSInteger sectionOffset;

@end

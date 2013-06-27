//
//  HAListViewController.h
//  Showtime
//
//  Created by Yaogang Lian on 1/16/11.
//  Copyright 2011 HappenApps, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HAListViewControllerDelegate <NSObject>
- (void)setSelectedIndex:(NSUInteger)index inList:(NSInteger)tag;
@end


@interface HAListViewController : UIViewController
<UITableViewDelegate, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *mainTableView;
@property (nonatomic, strong) NSArray *list;
@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, assign) NSUInteger selectedIndex;
@property (nonatomic, weak) id<HAListViewControllerDelegate> delegate;

- (id)initWithList:(NSArray *)l selectedIndex:(NSUInteger)index delegate:(id)d;

@end

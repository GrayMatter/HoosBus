//
//  FastScrollingCell.h
//  Showtime
//
//  Created by Yaogang Lian on 2/6/11.
//  Copyright 2011 HappenApps, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FastScrollingCell : UITableViewCell
{
	UIView * cellView;
}

@property (nonatomic, strong) UIView * cellView;

- (void)drawCellView:(CGRect)rect; // subclasses should overwrite this

@end

//
//  ErrorCell.h
//  HoosBus
//
//  Created by Yaogang Lian on 10/14/11.
//  Copyright (c) 2011 HappenApps, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FastScrollingCell.h"

@interface ErrorCell : FastScrollingCell
{
	NSString *label;
	UIImage *image;
}

@property (nonatomic, copy) NSString *label;
@property (nonatomic, strong) UIImage *image;

- (void)drawCellView:(CGRect)rect;
+ (CGFloat)rowHeightForText:(NSString *)s;

@end

//
//  EnhancedDefaultCell.h
//  Showtime
//
//  Created by Yaogang Lian on 1/15/11.
//  Copyright 2011 Happen Next. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FastScrollingCell.h"

@interface EnhancedDefaultCell : FastScrollingCell

@property (nonatomic, copy) NSString * cellText;
@property (nonatomic, strong) UIImage * cellImage;

- (void)drawCellView:(CGRect)rect;
+ (CGFloat)rowHeightForText:(NSString *)s;

@end
//
//  EnhancedDefaultCell.m
//  Showtime
//
//  Created by Yaogang Lian on 1/15/11.
//  Copyright 2011 HappenApps, Inc. All rights reserved.
//

#import "EnhancedDefaultCell.h"

#define MAIN_FONT_SIZE 15
#define MAX_TEXT_WIDTH 230
#define Y_PADDING 16

@implementation EnhancedDefaultCell

@synthesize cellText, cellImage;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		cellView.backgroundColor = [UIColor clearColor];
		cellText = nil;
		cellImage = nil;
    }
    return self;
}

- (void)drawCellView:(CGRect)rect
{
	// Color and font for the label
	UIColor * mainTextColor = nil;
	UIFont * mainFont = [UIFont boldSystemFontOfSize:MAIN_FONT_SIZE];
	
	// Choose font color based on highlighted state.
	if (self.highlighted) {
		mainTextColor = [UIColor whiteColor];
	} else {
		mainTextColor = [UIColor blackColor];
	}
	
	// Set the color for the main text items.
	[mainTextColor set];
	
	// Show label
	CGSize size = [cellText sizeWithFont:mainFont constrainedToSize:CGSizeMake(MAX_TEXT_WIDTH, CGFLOAT_MAX)
						lineBreakMode:UILineBreakModeWordWrap];
	
	CGFloat rowHeight = size.height + Y_PADDING;
	if (rowHeight < 44.0f) rowHeight = 44.0f;
	
	CGRect r = CGRectMake(47, (rowHeight-size.height)/2.0, MAX_TEXT_WIDTH, size.height);
	[cellText drawInRect:r
                withFont:mainFont
           lineBreakMode:UILineBreakModeWordWrap
               alignment:UITextAlignmentLeft];
	
	// Draw image
	[cellImage drawInRect:CGRectMake(8, (rowHeight-29)/2.0, 29, 29)];
}	



#pragma mark -
#pragma mark Misc.

+ (CGFloat)rowHeightForText:(NSString *)s
{
	CGFloat rowHeight;
	if (s == nil) {
		rowHeight = 44.0f;
	} else {
		UIFont * mainFont = [UIFont boldSystemFontOfSize:MAIN_FONT_SIZE];
		CGSize size = [s sizeWithFont:mainFont constrainedToSize:CGSizeMake(MAX_TEXT_WIDTH, CGFLOAT_MAX)
						lineBreakMode:UILineBreakModeWordWrap];
		rowHeight = size.height + Y_PADDING;
		if (rowHeight < 44.0f) rowHeight = 44.0f;
	}
	return rowHeight;
}


#pragma mark -
#pragma mark Accessibility

- (NSString *)accessibilityLabel
{
	return [NSString stringWithFormat:@"%@", cellText];
}

@end

//
//  UIImage+HAUtils.m
//
//  Created by Yaogang Lian on 10/13/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "UIImage+HAUtils.h"

@implementation UIImage (HAUtils)

- (UIImage *)imageWithOverlayColor:(UIColor *)color
{        
    CGRect rect = CGRectMake(0.0f, 0.0f, self.size.width, self.size.height);
    
    if (UIGraphicsBeginImageContextWithOptions) {
        CGFloat imageScale = 1.0f;
        if ([self respondsToSelector:@selector(scale)])  // The scale property is new with iOS4.
            imageScale = self.scale;
        UIGraphicsBeginImageContextWithOptions(self.size, NO, imageScale);
    }
    else {
        UIGraphicsBeginImageContext(self.size);
    }
    
    [self drawInRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetBlendMode(context, kCGBlendModeSourceIn);
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)imageInColor:(UIColor *)color
{
	UIGraphicsBeginImageContext(self.size);
	
	CGRect contextRect;
	contextRect.origin.x = 0.0f;
	contextRect.origin.y = -self.size.height;
	contextRect.size = self.size;
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	// set the blend mode and draw rectangle on top of image
	CGContextSetBlendMode(context, kCGBlendModeColor);
	
	// restrict drawing to within alpha channel
	CGContextScaleCTM(context, 1.0, -1.0);
	CGContextClipToMask(context, contextRect, self.CGImage);
	
	// set a new color
	const float *colors = CGColorGetComponents(color.CGColor);
	CGContextSetRGBFillColor(context, colors[0], colors[1], colors[2], colors[3]);
	CGContextFillRect(context, contextRect);
	
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return newImage;
}

@end

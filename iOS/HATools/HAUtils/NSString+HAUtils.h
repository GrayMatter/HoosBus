//
//  NSString+HAUtils.h
//
//  Created by Yaogang Lian on 10/18/10.
//  Copyright 2010 HappenApps, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (HAUtils)

// Trim white space and \n from both ends
- (NSString *)trim;

// Returns md5 hash in ALL UPPPER CASE
- (NSString *)md5;

@end

//
//  PaPaDoc.h
//  HoosBus
//
//  Created by Yaogang Lian on 2/11/12.
//  Copyright (c) 2012 Happen Apps, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <libxml/tree.h>
#import <libxml/parser.h>
#import <libxml/HTMLparser.h>
#import <libxml/xpath.h>
#import <libxml/xpathInternals.h>

@interface PaPaDoc : NSObject

+ (PaPaDoc *)docWithXMLData:(NSData *)data;
+ (PaPaDoc *)docWithHTMLData:(NSData *)data;

// Accessors
- (xmlXPathContextPtr)xpathCtx;

@end

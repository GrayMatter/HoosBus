//
//  PaPaTag.h
//
//  Created by Yaogang Lian on 2/11/12.
//  Copyright (c) 2012 Happen Apps, Inc. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import <Foundation/Foundation.h>
#import <libxml/tree.h>
#import <libxml/xpath.h>

@class PaPaDoc;

@interface PaPaTag : NSObject

// Initialization
- (id)initWithNode:(xmlNodePtr)node inDoc:(PaPaDoc *)doc;

// Tag properties
- (NSString *)name;
- (NSString *)content;
- (NSDictionary *)attributes;
- (NSString *)objectForKey:(NSString *)key;
- (NSString *)rawHtml;

// Relationships
- (PaPaTag *)parent;
- (NSArray *)children;
- (NSArray *)childrenWithTagName:(NSString *)name;
- (PaPaTag *)nextSibling;
- (PaPaTag *)previousSibling;

// Search with XPath queries
- (NSArray *)findAll:(NSString *)query;
- (PaPaTag *)find:(NSString *)query;

@end

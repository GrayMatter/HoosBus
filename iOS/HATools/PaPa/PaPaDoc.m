//
//  PaPaDoc.m
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

#import "PaPaDoc.h"
#import "PaPaTag.h"
#import <libxml/parser.h>
#import <libxml/HTMLparser.h>

@interface PaPaDoc () {
@private
    xmlDocPtr _doc;
}
- (id)initWithData:(NSData *)data isXML:(BOOL)isXML;
@end


@implementation PaPaDoc

@synthesize rootTag = _rootTag;
@synthesize xpathCtx = _xpathCtx;


#pragma mark - Constructors

+ (PaPaDoc *)docWithXMLData:(NSData *)data
{
    return [[[self class] alloc] initWithData:data isXML:YES];
}

+ (PaPaDoc *)docWithHTMLData:(NSData *)data
{
    return [[[self class] alloc] initWithData:data isXML:NO];
}


#pragma mark - Initialization

- (id)initWithData:(NSData *)data isXML:(BOOL)isXML
{
    self = [super init];
    if (self) {
        if (isXML) {
            _doc = xmlReadMemory([data bytes], (int)[data length], "", NULL, XML_PARSE_RECOVER);
        } else {
            _doc = htmlReadMemory([data bytes], (int)[data length], "", NULL, HTML_PARSE_NOWARNING | HTML_PARSE_NOERROR);
        }
        
        if (_doc == NULL) {
            NSLog(@"Unable to parse");
            return nil;
        }
        
        // Create xpath evaluation context
        _xpathCtx = xmlXPathNewContext(_doc);
        if (_xpathCtx == NULL) {
            NSLog(@"Unable to create XPath context.");
            xmlFreeDoc(_doc);
            return nil;
        }
        
        // Create root tag
        xmlNodePtr root_node = xmlDocGetRootElement(_doc);
        if (root_node == NULL) {
            NSLog(@"Empty document");
            xmlXPathFreeContext(_xpathCtx);
            xmlFreeDoc(_doc);
            return nil;
        }
        
        _rootTag = [[PaPaTag alloc] initWithNode:root_node inDoc:self];
    }
    return self;
}

- (void)dealloc
{
    xmlXPathFreeContext(_xpathCtx);
    xmlFreeDoc(_doc);
}


#pragma mark - Search with XPath queries

- (NSArray *)findAll:(NSString *)query
{
    return [_rootTag findAll:query];
}

- (PaPaTag *)find:(NSString *)query
{
    return [_rootTag find:query];
}

@end

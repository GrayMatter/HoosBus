//
//  PaPaDoc.m
//  HoosBus
//
//  Created by Yaogang Lian on 2/11/12.
//  Copyright (c) 2012 Happen Apps, Inc. All rights reserved.
//

#import "PaPaDoc.h"

@interface PaPaDoc () {
@private
    NSData * data;
    BOOL isXML;
    xmlDocPtr doc;
    xmlNodePtr _rootNode;
    xmlXPathContextPtr _xpathCtx;
}
- (id)initWithData:(NSData *)d isXML:(BOOL)b;
@end


@implementation PaPaDoc

+ (PaPaDoc *)docWithXMLData:(NSData *)data
{
    return [[[self class] alloc] initWithData:data isXML:YES];
}

+ (PaPaDoc *)docWithHTMLData:(NSData *)data
{
    return [[[self class] alloc] initWithData:data isXML:NO];
}


#pragma mark - Initialization

- (id)initWithData:(NSData *)d isXML:(BOOL)b
{
    self = [super init];
    if (self) {
        data = d;
        isXML = b;
        
        if (isXML) {
            doc = xmlReadMemory([data bytes], (int)[data length], "", NULL, XML_PARSE_RECOVER);
        } else {
            doc = htmlReadMemory([data bytes], (int)[data length], "", NULL, HTML_PARSE_NOWARNING | HTML_PARSE_NOERROR);
        }
        
        if (doc == NULL) {
            NSLog(@"Unable to parse.");
            return nil;
        }
        
        _rootNode = xmlDocGetRootElement(doc);
        if (_rootNode == NULL) {
            NSLog(@"empty document");
            xmlFreeDoc(doc);
            return nil;
        }
        
        /* Create xpath evaluation context */
        _xpathCtx = xmlXPathNewContext(doc);
        if (_xpathCtx == NULL)
        {
            NSLog(@"Unable to create XPath context.");
            xmlFreeDoc(doc);
            return nil;
        }
    }
    return self;
}

- (xmlXPathContextPtr)xpathCtx
{
    return _xpathCtx;
}

- (void)dealloc
{
    xmlXPathFreeContext(_xpathCtx);
    xmlFreeDoc(doc);
}

@end

//
//  PaPaTag.m
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

#import "PaPaTag.h"
#import "PaPaDoc.h"

@interface PaPaTag () {
@private
    xmlNodePtr _node;
    PaPaDoc * _doc;
}
- (NSArray *)performXPathQuery:(NSString *)query;
@end


@implementation PaPaTag


#pragma mark - Initialization

- (id)initWithNode:(xmlNodePtr)node inDoc:(PaPaDoc *)doc
{
    self = [super init];
    if (self) {
        _node = node;
        _doc = doc;
    }
    return self;
}


#pragma mark - Tag properties

- (NSString *)name
{
    return @((const char *)_node->name);
}

- (NSString *)content
{
    xmlChar * s = xmlNodeListGetString(_node->doc, _node->children, 1);
    NSString * content = nil;
    if (s != NULL) {
        content = @((const char *)s);
        xmlFree(s);
    }
    return content;
}

- (NSDictionary *)attributes
{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    
    for (xmlAttrPtr attr = _node->properties; attr; attr = attr->next) {
        xmlChar * content = xmlNodeListGetString(_node->doc, attr->children, 1);
        [dict setObject:@((const char *)content)
                 forKey:@((const char *)attr->name)];
        xmlFree(content);
    }
    
    return [NSDictionary dictionaryWithDictionary:dict];
}

- (NSString *)objectForKey:(NSString *)key
{
    return [[self attributes] objectForKey:key];
}

- (NSString *)rawHtml
{
    xmlBufferPtr nodeBuffer = xmlBufferCreate();
    xmlNodeDump(nodeBuffer, _node->doc, _node, 0, 1);
    NSString * s = @((const char *)nodeBuffer->content);
    xmlBufferFree(nodeBuffer);
    return s;
}


#pragma mark - Relationships

- (PaPaTag *)parent
{
    if (_node->parent) {
        return [[PaPaTag alloc] initWithNode:_node->parent inDoc:_doc];
    } else {
        return nil;
    }
}

- (NSArray *)children
{
    NSMutableArray * children = [NSMutableArray array];
    
    xmlNodePtr child;
    for (child = _node->children; child; child = child->next) {
        PaPaTag * tag = [[PaPaTag alloc] initWithNode:child inDoc:_doc];
        [children addObject:tag];
    }
    
    return [NSArray arrayWithArray:children];
}

- (NSArray *)childrenWithTagName:(NSString *)name
{
    NSMutableArray * children = [NSMutableArray array];
    xmlNodePtr child;
    for (child = _node->children; child; child = child->next) {
        //if (xmlStrcmp(children->name, (const xmlChar *)"Stories") == 0) {
        if (strcmp((char *)child->name, [name cStringUsingEncoding:NSUTF8StringEncoding])==0) {
            [children addObject:[[PaPaTag alloc] initWithNode:child inDoc:_doc]];
        }
    }
    return [NSArray arrayWithArray:children];
}

- (PaPaTag *)nextSibling
{
    if (_node->next) {
        return [[PaPaTag alloc] initWithNode:_node->next inDoc:_doc];
    } else {
        return nil;
    }
}

- (PaPaTag *)previousSibling
{
    if (_node->prev) {
        return [[PaPaTag alloc] initWithNode:_node->prev inDoc:_doc];
    } else {
        return nil;
    }
}


#pragma mark - Perform XPath queries

- (NSArray *)findAll:(NSString *)query
{
    return [self performXPathQuery:query];
}

- (PaPaTag *)find:(NSString *)query
{
    NSArray * results = [self performXPathQuery:query];
    if (results != nil && [results count] > 0) {
        return [results objectAtIndex:0];
    } else {
        return nil;
    }
}

- (NSArray *)performXPathQuery:(NSString *)query
{
    xmlXPathContextPtr ctx = [_doc xpathCtx];
    ctx->node = _node;
    
    xmlXPathObjectPtr xpathObj = xmlXPathEvalExpression((xmlChar *)[query cStringUsingEncoding:NSUTF8StringEncoding],  ctx);
    if (xpathObj == NULL) {
        NSLog(@"Unable to evaluate XPath");
        return nil;
    }
    
    xmlNodeSetPtr nodes = xpathObj->nodesetval;
    if (!nodes) {
        NSLog(@"Nodes was nil.");
        xmlXPathFreeObject(xpathObj);
        return nil;
    }
    
    NSMutableArray * results = [NSMutableArray array];
    for (NSInteger i = 0; i < nodes->nodeNr; i++) {
        xmlNodePtr node = nodes->nodeTab[i];
        PaPaTag * tag = [[PaPaTag alloc] initWithNode:node inDoc:_doc];
        [results addObject:tag];
    }
    
    // Cleanup
    xmlXPathFreeObject(xpathObj);
    
    return [NSArray arrayWithArray:results];
}

@end

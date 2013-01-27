//
//  HBFeedLoader.m
//  HoosBus
//
//  Created by Yaogang Lian on 10/1/09.
//  Copyright 2009 Yaogang Lian. All rights reserved.
//

#import "HBFeedLoader.h"
#import "BTPredictionEntry.h"
#import "NSString+HAUtils.h"
#import "PaPa.h"

@implementation HBFeedLoader


- (id)init
{
	if (self = [super init]) {
	}
	return self;
}

- (NSString *)dataSourceForStop:(BTStop *)stop
{
	return [NSString stringWithFormat:@"http://avlweb.charlottesville.org/RTT/Public/RoutePositionET.aspx?PlatformNo=%@&Referrer=uvamobile", stop.stopCode];
}

- (void)getPredictionForStop:(BTStop *)stop
{
    // Cancel previous requests
    [httpClient.operationQueue cancelAllOperations];
	
	self.currentStop = stop;
	
    [httpClient getPath:[self dataSourceForStop:stop] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        PaPaDoc * doc = [PaPaDoc docWithHTMLData:(NSData *)responseObject];
        NSArray * rows = [doc findAll:@"//tbody/tr"];
		
        // Reset self.prediction
        [self.prediction removeAllObjects];
        
        for (PaPaTag * row in rows) {
            NSArray * tdTags = [row findAll:@"td"];
            if ([tdTags count] == 3) {
                NSString * routeShortName = [[[tdTags objectAtIndex:0] content] trim];
                NSString * destination = [[[tdTags objectAtIndex:1] content] trim];
                NSString * eta = [[[tdTags objectAtIndex:2] content] trim];
                
                // Check if the route id is valid
                if ([routeShortName isEqualToString:@""]) continue;
                
                // Check if this route already exists in time table
                BOOL routeAlreadyExists = NO;
                
                for (BTPredictionEntry * pe in self.prediction) {
                    if ([routeShortName isEqualToString:pe.route.shortName] &&
                        [destination isEqualToString:pe.destination]) {
                        routeAlreadyExists = YES;
                        NSString * newETA = [NSString stringWithFormat:@"%@, %@", pe.eta, eta];
                        pe.eta = newETA;
                        break;
                    }
                }
                
                if (!routeAlreadyExists) {
                    BTPredictionEntry * entry = [[BTPredictionEntry alloc] init];
                    entry.route = [self.transit routeWithShortName:routeShortName];
                    entry.destination = destination;
                    entry.eta = eta;
                    [self.prediction addObject:entry];
                }
            }
        }
        
        [self.delegate updatePrediction:self.prediction];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DDLogError(@"request did fail with error: %@", error);
        [self.delegate updatePrediction:nil];
    }];
}

@end

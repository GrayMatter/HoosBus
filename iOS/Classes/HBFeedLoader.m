//
//  HBFeedLoader.m
//  HoosBus
//
//  Created by Yaogang Lian on 10/1/09.
//  Copyright 2009 Yaogang Lian. All rights reserved.
//

#import "HBFeedLoader.h"
#import "BTPredictionEntry.h"
#import "HAAppSettings.h"
#import "NSString+HAUtils.h"
#import "PaPa.h"

@implementation HBFeedLoader

- (void)getPredictionForStop:(BTStop *)stop
{
    NSString * dataSource = [HAAppSettings settingsForKey:@"datasource"];
    if (true) {
    //if ([dataSource isEqualToString:@"hoosbus"]) {
        [self getPredictionFromHoosBusForStop:stop];
    } else {
        [self getPredictionFromConnexionzForStop:stop];
    }
}

- (void)getPredictionFromHoosBusForStop:(BTStop *)stop
{
    // Cancel previous requests
    [httpClient.operationQueue cancelAllOperations];
    
    self.currentStop = stop;
    
    // Fetch prediction
    NSString * path = [NSString stringWithFormat:@"%@/prediction", API_BASE_URL];
    NSDictionary * params = @{@"stop": stop.stopCode};
    [httpClient getPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError * error = nil;
        NSArray * jsonArray = [NSJSONSerialization JSONObjectWithData:(NSData *)responseObject options:kNilOptions error:&error];
        
        // Return nil if the feed can not be downloaded
        if (error != nil || jsonArray == nil) {
			[delegate updatePrediction:@"Bus arrival times currently not available"];
			return;
        }
        
        // The feed has been acquired; start processing.
		// Reset self.prediction
		[self.prediction removeAllObjects];
        
        for (NSDictionary * dict in jsonArray) {
            BTPredictionEntry * entry = [[BTPredictionEntry alloc] init];
            entry.route = [self.transit routeWithShortName:dict[@"route"]];
            entry.destination = dict[@"note"];
            entry.eta = dict[@"eta"];
            [self.prediction addObject:entry];
        }
        
        [self.delegate updatePrediction:self.prediction];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DDLogError(@"request did fail with error: %@", error);
        [delegate updatePrediction:nil];
    }];
}

- (void)getPredictionFromConnexionzForStop:(BTStop *)stop
{
    // Cancel previous requests
    [httpClient.operationQueue cancelAllOperations];
	
	self.currentStop = stop;
    
    // Fetch prediction
    NSString * path = @"http://avlweb.charlottesville.org/RTT/Public/RoutePositionET.aspx";
    NSDictionary * params = @{@"PlatformNo": stop.stopCode, @"Referrer": @"uvamobile"};
	
    [httpClient getPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
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

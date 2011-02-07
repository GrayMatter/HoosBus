//
//  HBTransit.h
//  HoosBus
//
//  Created by Yaogang Lian on 10/26/09.
//  Copyright 2009 Happen Next. All rights reserved.
//

#import "BTTransit.h"


@interface HBTransit : BTTransit {
	BOOL displayCTSStops;
	BOOL displayCTSRoutes;
}

@property BOOL displayCTSStops;
@property BOOL displayCTSRoutes;

@end

//
//  BTAppSettings+HoosBus.h
//  HoosBus
//
//  Created by Yaogang Lian on 2/8/11.
//  Copyright 2011 Happen Next. All rights reserved.
//

#import "BTAppSettings.h"

@interface BTAppSettings (HoosBus)

+ (BOOL)shouldDisplayCTSStops;
+ (void)setShouldDisplayCTSStops:(BOOL)b;

+ (BOOL)shouldDisplayCTSRoutes;
+ (void)setShouldDisplayCTSRoutes:(BOOL)b;

@end

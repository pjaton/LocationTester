//
//  RegionTracker.h
//  LocationTester
//
//  Created by Patrice Jaton on 2/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Tracker.h"
#import "Option.h"

@interface RegionTracker : Tracker

- (void)startMonitoring:(Option *)newRadius accuracy:(Option *)newAccuracy;
- (void)stopMonitoring;


@end

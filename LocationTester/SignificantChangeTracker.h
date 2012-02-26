//
//  SignificantChangeTracker.h
//  LocationTester
//
//  Created by Patrice Jaton on 2/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Tracker.h"

@interface SignificantChangeTracker : Tracker

- (void)startMonitoring;
- (void)stopMonitoring;

@end

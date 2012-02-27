//
//  LocationMonitor.h
//  LocationTester
//
//  Created by Patrice Jaton on 2/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


@class LocationTracker;

@protocol TrackerAvailabilityDelegate <NSObject>

- (void)trackerAuthorizationChanged:(BOOL)authorized;

@end



#import "Tracker.h"
#import "Option.h"

@interface LocationTracker : Tracker<UIAlertViewDelegate>

@property (nonatomic, weak) id <TrackerAvailabilityDelegate> delegate;

- (void)startMonitoring:(Option *)distance accuracy:(Option *)accuracy;
- (void)stopMonitoring;

@end

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

@interface LocationTracker : Tracker<UIAlertViewDelegate>

@property (nonatomic, weak) id <TrackerAvailabilityDelegate> delegate;


- (void)startMonitoring:(CLLocationDistance)distance accuracy:(CLLocationAccuracy)accuracy;
- (void)stopMonitoring;


/*
+ (LocationTracker *)optionWithLabel:(NSString *)label andValue:(double)value;
- (LocationTracker *)initWithLabel:(NSString *)label andValue:(double)value;
*/

@end

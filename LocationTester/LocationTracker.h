//
//  LocationMonitor.h
//  LocationTester
//
//  Created by Patrice Jaton on 2/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#define LOCATIONS_FILE @"Locations"
#define LOCATIONS_FILE_TYPE @"log"

@class LocationTracker;

@protocol LocationTrackerDelegate <NSObject>

- (void)locationtracker:(LocationTracker *)tracker authorizationChanged:(BOOL)authorize;

@end



@interface LocationTracker : NSObject<CLLocationManagerDelegate>

@property (nonatomic, weak) id <LocationTrackerDelegate> delegate;


- (void)startMonitoringLocation:(CLLocationDistance)distance accuracy:(CLLocationAccuracy)accuracy;
- (void)stopMonitoringLocation;


/*
+ (LocationTracker *)optionWithLabel:(NSString *)label andValue:(double)value;
- (LocationTracker *)initWithLabel:(NSString *)label andValue:(double)value;
*/

@end

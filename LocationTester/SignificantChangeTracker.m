//
//  SignificantChangeTracker.m
//  LocationTester
//
//  Created by Patrice Jaton on 2/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SignificantChangeTracker.h"

@implementation SignificantChangeTracker


- (void)startMonitoring
{
    [self log:@"\nStart monitoring significant change..."];
    [locationManager startMonitoringSignificantLocationChanges];
    
}

- (void)stopMonitoring {
    [self log:@"\nStop monitoring significant change"];
    [locationManager stopMonitoringSignificantLocationChanges];
}




#pragma mark - Location Manager Delegate


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSDate* eventDate = newLocation.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (abs(howRecent) < 15.0) {
        [self reportLocation:newLocation withMessage:@"Significant change"];
    } else {
        DNSInfo(@"Ignore old significant location: %@", [newLocation description]);
    }
}

@end

//
//  RegionTracker.m
//  LocationTester
//
//  Created by Patrice Jaton on 2/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RegionTracker.h"

#define REGION_ID @"LocationTesterRegion"

@implementation RegionTracker {
    CLLocationDistance radius;
    CLLocationAccuracy accuracy;
}


- (void)startMonitoring:(CLLocationDistance)newRadius accuracy:(CLLocationAccuracy)newAccuracy 
{
    radius = newRadius;
    accuracy = newAccuracy;
    DNSInfo(@"Start monitoring region (radius %.0fm, accuracy: %.0fm)", newRadius, newAccuracy);
    
    // we use the radius and accuracy option to establish first the center of the
    // region. Once this center is established, we will start the true monitoring
    // of the region
    [locationManager setDistanceFilter:radius];
    [locationManager setDesiredAccuracy:accuracy];
    [locationManager startUpdatingLocation];
    
}

- (void)stopMonitoring 
{
    DNSInfo(@"Stop monitoring region");
    NSSet *regions = [locationManager monitoredRegions];
    for (CLRegion *region in regions) {
        if ([region.identifier isEqualToString:REGION_ID]) {
            [locationManager stopMonitoringForRegion:region];
        }
    }
}




#pragma mark - Location Manager Delegate


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSDate* eventDate = newLocation.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (abs(howRecent) < 15.0) {
        [manager stopUpdatingLocation];
        CLRegion *region = [[CLRegion alloc] initCircularRegionWithCenter:newLocation.coordinate radius:radius identifier:REGION_ID];
        [locationManager startMonitoringForRegion:region desiredAccuracy:accuracy];
    } else {
        DNSInfo(@"Ignore old location: %@", [newLocation description]);
    }
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    DNSNotify(@"We enter the region!\n%@", [[manager location] description]);
    [locationManager startMonitoringForRegion:region desiredAccuracy:kCLLocationAccuracyBest];
    
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    DNSNotify(@"We left the region!\n%@", [[manager location] description]);
    CLRegion *newRegion = [[CLRegion alloc] initCircularRegionWithCenter:[[manager location] coordinate] radius:20 identifier:REGION_ID];
    [locationManager startMonitoringForRegion:newRegion desiredAccuracy:kCLLocationAccuracyBest];
    
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error
{
    DNSInfo(@"Region failed with error %@", [error localizedDescription]);
}

@end

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
    Option *radius;
    Option *accuracy;
}


- (void)startMonitoring:(Option *)newRadius accuracy:(Option *)newAccuracy
{
    radius = newRadius;
    accuracy = newAccuracy;
    
    [self log:[NSString stringWithFormat:@"\nResearching region center (radius %@, accuracy: %@)...", radius.label, accuracy.label]];
    
    // we use the radius and accuracy option to establish first the center of the
    // region. Once this center is established, we will start the true monitoring
    // of the region
    [locationManager setDistanceFilter:radius.value];
    [locationManager setDesiredAccuracy:accuracy.value];
    [locationManager startUpdatingLocation];
    
}

- (void)stopMonitoring 
{
    NSSet *regions = [locationManager monitoredRegions];
    for (CLRegion *region in regions) {
        if ([region.identifier isEqualToString:REGION_ID]) {
            [locationManager stopMonitoringForRegion:region];
            [self log:[NSString stringWithFormat:@"\nStop monitoring region: <%+.6f, %+.6f> radius %.0fm", region.center.latitude, region.center.longitude, region.radius]];
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
        CLRegion *region = [[CLRegion alloc] initCircularRegionWithCenter:newLocation.coordinate radius:radius.value identifier:REGION_ID];
        [self log:[NSString stringWithFormat:@"\nMonitoring first region: <%+.6f, %+.6f> radius %.0fm", region.center.latitude, region.center.longitude, region.radius]];
        [locationManager startMonitoringForRegion:region desiredAccuracy:accuracy.value];
        
    } else {
        DNSInfo(@"Ignore old location for region: %@", [newLocation description]);
    }
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    [self reportLocation:[manager location] withMessage:@"Enter region"];
    [locationManager startMonitoringForRegion:region desiredAccuracy:kCLLocationAccuracyBest];
    
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    [self reportLocation:[manager location] withMessage:@"Exit region"];
    CLRegion *newRegion = [[CLRegion alloc] initCircularRegionWithCenter:[[manager location] coordinate] radius:radius.value identifier:REGION_ID];
    [locationManager startMonitoringForRegion:newRegion desiredAccuracy:radius.value];
    
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error
{
    DNSInfo(@"Region failed with error %@", [error localizedDescription]);
}

@end

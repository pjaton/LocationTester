//
//  LocationTracker.m
//  LocationTester
//
//  Created by Patrice Jaton on 2/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LocationTracker.h"


@implementation LocationTracker

@synthesize delegate = _delegate;


- (void)startMonitoring:(CLLocationDistance)distance accuracy:(CLLocationAccuracy)accuracy 
{
    DNSInfo(@"Start monitoring location (distance %.0fm, accuracy: %.0fm)", distance, accuracy);
    [locationManager stopUpdatingLocation];
    [locationManager setDistanceFilter:distance];
    [locationManager setDesiredAccuracy:accuracy];
    [locationManager startUpdatingLocation];
    
}

- (void)stopMonitoring 
{
    DNSInfo(@"Stop monitoring location");
    [locationManager stopUpdatingLocation];
}




#pragma mark - Location Manager Delegate


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSDate* eventDate = newLocation.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (abs(howRecent) < 15.0) {
        [self reportLocation:newLocation withMessage:@"Location"];
    } else {
        DNSInfo(@"Ignore old location: %@", [newLocation description]);
    }
}



- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    BOOL authorized = YES;
    
    // the user has explicitly denied authorization for this application, 
    // or location services are disabled in Settings
    if (status == kCLAuthorizationStatusDenied) {
        authorized = NO;
        UIAlertView *debugAlert = [[UIAlertView alloc] initWithTitle:@"This App. Requires the Location Services to Determine Your Location" message:nil delegate:self cancelButtonTitle:@"Settings" otherButtonTitles:@"Cancel", nil];
        [debugAlert show];
    }
    
    // this application is not authorized to use location services due
    // to active restrictions on location services, the user cannot change
    // this status, and may not have personally denied authorization
    else if (status == kCLAuthorizationStatusRestricted) {
        authorized = NO;
        UIAlertView *debugAlert = [[UIAlertView alloc] initWithTitle:@"Services Restricted" message:@"The location services are currently restricted on this device! Please try again later." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
        [debugAlert show];
        
    }
    
    // otherwise, the user has either not made a choice with regards to this 
    // application or (s)he has authorized it to user the location services
    
    if (nil != self.delegate) {
        [self.delegate trackerAuthorizationChanged:authorized];
    }
    
}

#pragma mark - Alert View delegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Settings"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs://"]];
    }
}

@end

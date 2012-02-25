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


- (void)startMonitoringLocation:(CLLocationDistance)distance accuracy:(CLLocationAccuracy)accuracy {
    DNSInfo(@"Start monitoring location (distance %.0fm, accuracy: %.0fm)", distance, accuracy);
    [locationManager setDistanceFilter:distance];
    [locationManager setDesiredAccuracy:accuracy];
    [locationManager startUpdatingLocation];
    
}

- (void)stopMonitoringLocation {
    DNSInfo(@"Stop monitoring location");
    [locationManager stopUpdatingLocation];
}




#pragma mark - Location Manager Delegate


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    
    NSDate* eventDate = newLocation.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (abs(howRecent) < 15.0) {
        NSString* path = [[NSBundle mainBundle] pathForResource:LOCATIONS_FILE ofType:LOCATIONS_FILE_TYPE];
        NSFileHandle *file = [NSFileHandle fileHandleForUpdatingAtPath:path];
        NSString * msg = [NSString stringWithFormat:@"\n%@", [newLocation description]];
        NSData *data = [msg dataUsingEncoding:NSUTF8StringEncoding];
        [file seekToEndOfFile];
        [file writeData: data];
        [file closeFile];

        
        
        
        if ([newLocation horizontalAccuracy] <= 10) {
            DNSNotify(@"Precision reached: %+.6f, %+.6f\n", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
            
        } else {
            DNSInfo(@"Not precise:%@", [newLocation description]);
        }
    } else {
        DNSInfo(@"Tossed:%@", [newLocation description]);
    }

}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    // TODO: add support for the following:
    // If the location service is unable to retrieve a location right away, it reports a kCLErrorLocationUnknown error and keeps trying. In such a situation, you can simply ignore the error and wait for a new event.
    // If the user denies your application’s use of the location service, this method reports a kCLErrorDenied error. Upon receiving such an error, you should stop the location service.
    // If a heading could not be determined because of strong interference from nearby magnetic fields, this method returns kCLErrorHeadingFailure.
    DNSInfo(@"LM did fail with error %@", [error localizedDescription]);

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
        [self.delegate locationtracker:self authorizationChanged:authorized];
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

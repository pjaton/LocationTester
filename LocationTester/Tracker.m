//
//  Tracker.m
//  
//
//  Created by Patrice Jaton on 2/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Tracker.h"

@implementation Tracker

- (id)init {
    self = [super init];
    if (self) {
        if (nil == locationManager) {
            locationManager = [[CLLocationManager alloc] init];
        }
        [locationManager setDelegate:self];
    }
    return self;
}


- (void) log:(NSString *)message
{
    NSString* path = [[NSBundle mainBundle] pathForResource:LOCATIONS_FILE ofType:LOCATIONS_FILE_TYPE];
    NSFileHandle *file = [NSFileHandle fileHandleForUpdatingAtPath:path];
    NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
    [file seekToEndOfFile];
    [file writeData: data];
    [file closeFile];
}


- (void) reportLocation:(CLLocation *)location withMessage:(NSString *)message
{
    [self log:[location description]];
    DNSNotify(@"Location: %+.6f, %+.6f\n", location.coordinate.latitude, location.coordinate.longitude);

}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    // TODO: add support for the following:
    // If the location service is unable to retrieve a location right away, it reports a kCLErrorLocationUnknown error and keeps trying. In such a situation, you can simply ignore the error and wait for a new event.
    // If the user denies your application’s use of the location service, this method reports a kCLErrorDenied error. Upon receiving such an error, you should stop the location service.
    // If a heading could not be determined because of strong interference from nearby magnetic fields, this method returns kCLErrorHeadingFailure.
    DNSInfo(@"LM did fail with error %@", [error localizedDescription]);
    
}


@end

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
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [NSString stringWithFormat:@"%@/%@.%@", documentsDirectory, LOCATIONS_FILE, LOCATIONS_FILE_TYPE];
    NSFileHandle *file = [NSFileHandle fileHandleForUpdatingAtPath:path];
    NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
    [file seekToEndOfFile];
    [file writeData: data];
    [file closeFile];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"logReceived" object:message];
}


- (void) reportLocation:(CLLocation *)location withMessage:(NSString *)message
{
    [self reportLocation:location withMessage:message andNotify:NO];
}

- (void) reportLocation:(CLLocation *)location withMessage:(NSString *)message andNotify:(BOOL)notify
{
    NSString *msg = [NSString stringWithFormat:@"\n%@: %@", message, [location description]];
    [self log:msg];

    if (notify) {
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        if (notification) {
            notification.alertBody = [NSString stringWithFormat:@"%@\n%+.6f, %+.6f (+/-%.0fm)", 
                                      message, 
                                      location.coordinate.latitude, 
                                      location.coordinate.longitude,
                                      location.horizontalAccuracy];
            notification.soundName = UILocalNotificationDefaultSoundName;
            [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
        }
    }
    DNSInfo(@"%@",msg);
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

//
//  Tracker.h
//  
//
//  Created by Patrice Jaton on 2/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@interface Tracker : NSObject<CLLocationManagerDelegate> {
    CLLocationManager * locationManager;  
}

- (void) log:(NSString *)message;
- (void) reportLocation:(CLLocation *)location withMessage:(NSString *)message;
- (void) reportLocation:(CLLocation *)location withMessage:(NSString *)message andNotify:(BOOL)notify;

@end

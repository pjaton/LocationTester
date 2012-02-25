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

@end

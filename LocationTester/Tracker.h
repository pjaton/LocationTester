//
//  Tracker.h
//  
//
//  Created by Patrice Jaton on 2/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

#define LOCATIONS_FILE @"Locations"
#define LOCATIONS_FILE_TYPE @"log"

@interface Tracker : NSObject<CLLocationManagerDelegate> {
    CLLocationManager * locationManager;  
}

@end

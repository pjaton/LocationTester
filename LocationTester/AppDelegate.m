//
//  AppDelegate.m
//  LocationTester
//
//  Created by Patrice Jaton on 2/19/12.
//  Copyright (c) 2012 Patrice Jaton. All rights reserved.
//

#import "AppDelegate.h"
#import "LocationTracker.h"
#import "SignificantChangeTracker.h"
#import "RegionTracker.h"
#import "ControlViewController.h"

@implementation AppDelegate {
    LocationTracker *locationTracker;
    SignificantChangeTracker *significantChangeTracker;
    RegionTracker *regionTracker;
}

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    if (nil == significantChangeTracker) {
        significantChangeTracker = [[SignificantChangeTracker alloc] init];
    }
    if (nil == regionTracker) {
        regionTracker = [[RegionTracker alloc] init];
    }

    if ([launchOptions objectForKey:UIApplicationLaunchOptionsLocationKey]) {
        DNSInfo(@"started from location");
        // nothing else to do, the appropriate location delegate (i.e Tracker) will be called
    } else {
        UILocalNotification *localNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
        if (localNotification) {
            UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
            [tabBarController setSelectedIndex:1];
        } else {
            NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString *path = [NSString stringWithFormat:@"%@/%@.%@", documentsDirectory, LOCATIONS_FILE, LOCATIONS_FILE_TYPE];
            DNSInfo(@"Path to location file: %@", path);
            if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
                DNSInfo(@"Creating locations log file");
                NSDate *date = [NSDate date];
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                [dateFormat setDateFormat:@"yyyy/MM/dd hh:mm aaa"];
                NSString *content = [NSString stringWithFormat:@"Location Tracker Log (%@)\n------------------------------------------------------------------", [dateFormat stringFromDate:date]];
                [content writeToFile:path
                          atomically:NO 
                            encoding:NSStringEncodingConversionAllowLossy 
                               error:nil];
            }

            // locations can be monitored only when the application is
            // in the foreground, which is not the case when the application
            // has been "awaken" from a location
            if (nil == locationTracker) {
                locationTracker = [[LocationTracker alloc] init];
            }
            
            UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
            ControlViewController *controlViewController = [[tabBarController viewControllers] objectAtIndex:0];
            [locationTracker setDelegate:controlViewController];
            [controlViewController setLocationTracker:locationTracker];
            [controlViewController setSignificantChangeTracker:significantChangeTracker];
            [controlViewController setRegionTracker:regionTracker];
        }
    }
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end

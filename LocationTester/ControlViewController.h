//
//  ControlViewController.h
//  LocationTester
//
//  Created by Patrice Jaton on 2/19/12.
//  Copyright (c) 2012 Patrice Jaton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "OptionsViewController.h"
#import "LocationTracker.h"
#import "SignificantChangeTracker.h"
#import "RegionTracker.h"

@interface ControlViewController : UITableViewController<TrackerAvailabilityDelegate, OptionsViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UILabel *notificationCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *locationCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *locationOptionsCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *significantCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *regionCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *regionOptionsCell;

@property (strong, nonatomic) LocationTracker *locationTracker;
@property (strong, nonatomic) SignificantChangeTracker *significantChangeTracker;
@property (strong, nonatomic) RegionTracker *regionTracker;

- (void)applyRegionOptions;
- (void)applyLocationOptions;

@end
